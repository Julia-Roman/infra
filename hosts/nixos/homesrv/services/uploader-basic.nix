{
  inputs,
  ...
}:
{
  imports = [
    inputs.uploader-basic.nixosModules.default
  ];
}
