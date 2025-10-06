{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.extraModulePackages = with
  config.boot.kernelPackages; [
    v4l2loopback
 ];

  networking.hostName = "Goblinz-Lair"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.smilez = {
    isNormalUser = true;
    description = "Sycho sMILEz";
    extraGroups = [ "networkmanager" "wheel" "audio"
    "video" "input" "gamemode" ];
    shell = pkgs.fish;   
    packages = with pkgs; [];
  };

  # Shells
  programs.fish.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Desktop environment
  programs.hyprland.enable = true;
 
  # Steam Requirments 
  programs.steam.enable = true;

  # Default file opener
  services.gvfs.enable = true;
  services.tumbler.enable = true;

  xdg.portal = {
    enable = true;  # only defined once
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-hyprland
    ];
    # optional but nice: set order
    config.common.default = [ "hyprland" "gtk" ];
  };
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    
     # ---- Core desktop ----
    hyprland
    waybar
    mako
    kitty
    nwg-drawer
    swww
    mpvpaper
    wl-clipboard
    cliphist
    wget
    pkgs.xfce.thunar
    kitty
    floorp
    hyprpaper
    rofi
    bat
    starship    
    haruna

     # ---- Audio / Media ----
    wireplumber
    pipewire
    pavucontrol
    playerctl
    ffmpeg-full
    strawberry

    # ---- Video / Image Editing ----
    kdePackages.kdenlive
    gimp
    inkscape
    blender

      # ---- Coding / Dev ----
    git
    gcc
    gnumake
    cmake
    pkg-config
    neovim
    vscode
    python3
    nodejs
    rustc cargo
    go
    godot
    unityhub

     # ---- Gaming ----
    steam
    lutris
    wineWowPackages.staging
    winetricks
    protontricks
    mangohud
    gamemode
    vkbasalt
    goverlay
    discord

    # ---- Emulators ----
    emulationstation-de
    rpcs3
    duckstation
    pcsx2
    dolphin-emu
    pkgs.ryubing
    pkgs.mupen64plus
    pkgs.flycast
    snes9x
    dgen-sdl
    
    # ---- Utilities ----
    fastfetch
    btop
    htop
    neofetch
    unzip
    wget
    curl
    grim slurp swappy   # screenshots
    xdg-utils
    xfce.thunar-archive-plugin
    xfce.exo
    unzip 
  ];
 
  
   nixpkgs.config.permittedInsecurePackages = [
    "freeimage-3.18.0-unstable-2024-04-18"
   ];

    # Fonts
  fonts.packages = with pkgs; [
    jetbrains-mono
    nerd-fonts.jetbrains-mono
    fira-code
    dejavu_fonts
  ];
  
  system.activationScripts.fixEtcNixosOwnership.text = ''
  echo "Fixing ownership of /etc/nixos..."
  chown -R smilez:users /etc/nixos || true
'';


  nix.settings.experimental-features = [ "nix-command" "flakes" ];
    
   # Audio (PipeWire + WirePlumber)
  services.pulseaudio.enable = false;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # ---Streaming + Recording---
  programs.obs-studio = {
    enable = true;

    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-backgroundremoval
      obs-pipewire-audio-capture
      obs-vaapi   #optional AMD hardware acceleration
      obs-gstreamer
      obs-vkcapture
      pkgs.obs-studio-plugins.obs-multi-rtmp  # multi stream
      pkgs.obs-studio-plugins.wlrobs     # wayland screen capture
    ];
  };

  # GPU Drivers (AMD 7900 XT + Raphael iGPU)
  services.xserver.videoDrivers = [ "amdgpu" ];
  hardware.graphics = {
  enable = true;
  extraPackages = with pkgs; [
    mesa
    vulkan-loader
    vulkan-validation-layers
    vulkan-tools
  ];
  extraPackages32 = with pkgs.pkgsi686Linux; [
    mesa
    vulkan-loader
  ];
};

  # Display manager (GDM)
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;

  fileSystems."/home/smilez/BoNeZ" = {
    device = "/dev/disk/by-uuid/e3a1243a-a90a-4882-9fa8-74715d5af91b";
    fsType = "ext4";
  };

  fileSystems."/home/smilez/Graves" = {
    device = "/dev/disk/by-uuid/2ca3f6ff-0db2-47f8-8f23-be89e3accf26";
    fsType = "ext4";
  };

   # Auto Update
  
  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = true;

   

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

}
