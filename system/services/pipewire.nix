{ ... }: {
  services.pipewire = {
    enable = true;
    audio.enable = true;
    alsa.enable = true;
    wireplumber.enable = true;
    pulse.enable = true;
    jack.enable = true;
  };
}
