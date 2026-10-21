inputs: final: prev: {
  helium = inputs.helium.packages.${prev.stdenv.hostPlatform.system}.default.overrideAttrs (oldAttrs: {
    # Chromium only reads the last --enable-features, so extend the upstream one instead of adding another.
    # Linux Chromium has no software HEVC decoder; HEVC playback depends on VA-API.
    # Software-decoded 10-bit video (e.g. Netflix's AV1) renders black on NVIDIA when uploaded through
    # GPU memory buffers, so those frames take the plain texture upload path instead.
    postInstall = (oldAttrs.postInstall or "") + ''
      substituteInPlace $out/bin/helium \
        --replace-fail "--enable-features=WaylandWindowDecorations" \
          "--enable-features=WaylandWindowDecorations,PlatformHEVCDecoderSupport,VaapiVideoDecoder,VaapiIgnoreDriverChecks,VaapiOnNvidiaGPUs,AcceleratedVideoDecodeLinuxGL,AcceleratedVideoDecodeLinuxZeroCopyGL --disable-gpu-memory-buffer-video-frames"
    '';
  });
}
