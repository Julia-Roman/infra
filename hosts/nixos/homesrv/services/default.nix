let
  dir = ./.;
  files = builtins.readDir dir;
  dirs = builtins.filter (name: files.${name} == "directory") (builtins.attrNames files);
in
map (name: dir + /${name}) dirs
