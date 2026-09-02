{
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    attrNames
    concatMapStringsSep
    concatStringsSep
    filter
    foldl'
    hasPrefix
    optionalAttrs
    optionalString
    optionals
    removePrefix
    replaceStrings
    reverseList
    sort
    splitString
    ;

  # Directories that must keep a fixed owner/mode/ACL, including everything
  # created inside them. Nested entries inherit their parent's attributes and
  # override only what they set themselves.
  #
  #   mode    chmod argument, applied to the directory and its contents
  #   user    chown owner (optional)
  #   group   chown group (optional)
  #   acl     comma separated setfacl entries (optional)
  #   exclude absolute paths that are neither watched nor descended into
  rules = {
    "/mnt/hdd_4t" = {
      mode = "0775";
      user = "supa";
    };
    "/mnt/hdd_4t/movies" = {
      mode = "2770";
      group = "media";
    };
    "/mnt/hdd_4t/music" = {
      mode = "2770";
      group = "media";
    };
    "/mnt/hdd_500g" = {
      mode = "2770";
      group = "media";
    };
    "/var/www" = {
      mode = "2770";
      user = "supa";
      group = "www";
      # NFS automount, leave it to the server that exports it
      exclude = [ "/var/www/fi.supa.sh/clips" ];
    };
    "/home/minecraft" = {
      mode = "2770";
      group = "minecraft";
    };
    "/home/fivem" = {
      mode = "2770";
      group = "fivem";
      acl = "group:fivem:rwx,default:group:fivem:rwx";
    };
  };

  # ancestors sort before their descendants: a prefix is always the shorter string
  paths = sort (a: b: builtins.stringLength a < builtins.stringLength b) (attrNames rules);

  covers = parent: path: parent == path || hasPrefix "${parent}/" path;

  effective = path: foldl' (acc: p: if covers p path then acc // rules.${p} else acc) { } paths;

  # entries with no rule above them: the trees actually handed to inotifywait
  roots = filter (p: !(builtins.any (q: q != p && covers q p) paths)) paths;

  excludes = lib.concatMap (p: rules.${p}.exclude or [ ]) paths;

  fnOf = path: "rule_" + replaceStrings [ "/" "." "-" ] [ "_" "_" "_" ] (removePrefix "/" path);

  indent = pad: lines: concatMapStringsSep "\n" (line: pad + line) lines;

  # a shell function that stamps one rule onto a path (and, for a directory,
  # onto everything below it)
  mkRuleFn =
    path:
    let
      r = effective path;
      owner = (r.user or "") + optionalString (r ? group) ":${r.group}";
      acl = optionals (r ? acl) (splitString "," r.acl);
      access = concatStringsSep "," (filter (e: !hasPrefix "default:" e) acl);
      defaults = concatStringsSep "," (filter (e: hasPrefix "default:" e) acl);

      # skip what this rule does not own: excluded paths, and the subtrees a
      # nested rule already covers
      pruned = (r.exclude or [ ]) ++ filter (q: q != path && covers path q) paths;
      prune = optionalString (pruned != [ ]) (
        "\\( " + concatMapStringsSep " -o " (e: "-path ${e}") pruned + " \\) -prune -o "
      );
      # -xdev so a mount nested under a watched tree keeps its own permissions.
      # stderr is dropped: entries can vanish between find listing them and
      # the -exec running (e.g. SQLite WAL files churned by a game server),
      # which is a harmless race, not a real failure.
      walk = expr: ''find "$1" -xdev -mindepth 1 ${prune}\( ${expr} \) 2>/dev/null'';

      # stderr on these is dropped: the -e check above is racy against fast
      # churn (e.g. SQLite WAL files), so the path can still vanish before
      # chown/chmod actually run on it. That's harmless, not a real failure.
      body = [
        ''[ -e "$1" ] || return 0''
        ''[ -L "$1" ] && { chown -h ${owner} -- "$1" 2>/dev/null; return 0; }''
        ''chown ${owner} -- "$1" 2>/dev/null''
        ''chmod ${r.mode} -- "$1" 2>/dev/null''
      ]
      ++ optionals (acl != [ ]) [
        ''if [ -d "$1" ]; then setfacl -m '${r.acl}' -- "$1"; else setfacl -m '${access}' -- "$1"; fi''
      ]
      ++ [ ''if [ -d "$1" ]; then'' ]
      ++ map (w: "  " + w) (
        [ (walk "! -type l -exec chown ${owner} -- {} + -exec chmod ${r.mode} -- {} +") ]
        ++ optionals (access != "") [ (walk "! -type l -exec setfacl -m '${access}' -- {} +") ]
        ++ optionals (defaults != "") [ (walk "-type d -exec setfacl -m '${defaults}' -- {} +") ]
      )
      ++ [ "fi" ];
    in
    ''
      ${fnOf path}() {
      ${indent "  " body}
      }
    '';

  watcher = pkgs.writeShellScript "enforce-permissions" ''
    set -u
    export PATH=${
      lib.makeBinPath [
        pkgs.acl
        pkgs.coreutils
        pkgs.findutils
        pkgs.inotify-tools
      ]
    }

    ${concatMapStringsSep "\n" mkRuleFn paths}

    # longest match wins, so a nested rule beats the one it is nested in
    dispatch() {
      case "$1" in
    ${indent "    " (map (p: "${p}|${p}/*) ${fnOf p} \"$1\" ;;") (reverseList paths))}
      esac
    }

    # each rule prunes the subtrees its nested rules own, so no path is walked twice
    reconcile() {
    ${indent "  " (map (p: "${fnOf p} ${p}") paths)}
    }

    watch=()
    for root in ${concatMapStringsSep " " lib.escapeShellArg roots}; do
      if [ -d "$root" ]; then
        watch+=("$root")
      else
        echo "skipping missing directory $root" >&2
      fi
    done
    [ "''${#watch[@]}" -gt 0 ] || { echo "nothing to watch" >&2; exit 1; }

    # stderr is folded into the stream so the reconcile pass can start the
    # moment the watches are up, closing the gap between the two
    inotifywait --monitor --recursive --event create --event moved_to \
      --format '%w%f' -- "''${watch[@]}" ${
        concatMapStringsSep " " (e: lib.escapeShellArg "@${e}") excludes
      } 2>&1 |
      while IFS= read -r line; do
        case "$line" in
          "Watches established."*) echo "watches established, reconciling" >&2; reconcile & ;;
          /*) dispatch "$line" ;;
          *) printf '%s\n' "$line" >&2 ;;
        esac
      done
  '';
in
{
  # the roots themselves are cheap to stamp on every activation; their contents
  # are left to the watcher, which is what used to make `z` crawl the disks
  systemd.tmpfiles.settings."10-custom-permissions-nix" = lib.mapAttrs (
    path: _:
    let
      r = effective path;
    in
    {
      d = {
        inherit (r) mode;
      }
      // optionalAttrs (r ? user) { inherit (r) user; }
      // optionalAttrs (r ? group) { inherit (r) group; };
    }
    // optionalAttrs (r ? acl) { "a+".argument = r.acl; }
  ) rules;

  systemd.services."systemd-tmpfiles-resetup".partOf = [ "sysinit-reactivation.target" ];

  systemd.services.enforce-permissions = {
    description = "Enforce owner and mode on watched directories";
    wantedBy = [ "multi-user.target" ];
    after = [ "systemd-tmpfiles-setup.service" ];
    unitConfig.RequiresMountsFor = roots;
    serviceConfig = {
      Type = "simple";
      ExecStart = watcher;
      Restart = "always";
      RestartSec = 5;
      # the reconcile pass walks the media disks, stay out of everyone's way
      Nice = 19;
      IOSchedulingClass = "idle";
    };
  };

  # one watch per directory in the trees above
  boot.kernel.sysctl."fs.inotify.max_user_watches" = 1048576;
}
