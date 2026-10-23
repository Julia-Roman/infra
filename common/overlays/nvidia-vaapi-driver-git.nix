inputs: final: prev: {
  # 0.0.17 corrupts HEVC after Chromium recreates the decode context on seek (e.g. Twitch live).
  # Pinned to a fork: master exports small surfaces (e.g. Twitch 160p) with a different modifier per
  # plane, which trips a CHECK in Chromium and crashes the GPU process.
  nvidia-vaapi-driver = prev.nvidia-vaapi-driver.overrideAttrs (oldAttrs: {
    version = "git-${inputs.nvidia-vaapi-driver-git.shortRev or "dirty"}";
    src = inputs.nvidia-vaapi-driver-git;
    # The nixpkgs install-dir patch no longer applies to master.
    patches = [ ];
    postPatch = (oldAttrs.postPatch or "") + ''
      substituteInPlace meson.build \
        --replace-fail "libva_deps.get_variable(pkgconfig: 'driverdir')" "get_option('libdir') / 'dri'"
    '';
  });
}
