let
  dir = ./.;
  files = builtins.readDir dir;
  isModule =
    name: files.${name} == "regular" && name != "default.nix" && builtins.match ".*\\.nix" name != null;
  modules = builtins.filter isModule (builtins.attrNames files);
in
map (name: dir + /${name}) modules
