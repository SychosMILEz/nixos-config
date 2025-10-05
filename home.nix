{ config, pkgs, ... }:

{
  home.username = "smilez";
  home.homeDirectory = "/home/smilez";

  # Let Home Manager manage itself
  programs.home-manager.enable = true;

  # packages installed just for this user
  home.packages = with pkgs; [
  # --- Core tools ---
    fastfetch
    btop
    fish
    starship
    neovim
    kitty
    bat
    fzf
    eza
    ripgrep
    fd
    viu              # image preview in terminal

  # --- Multimedia / UI ---
    mpv
    obs-studio
    haruna
    kdePackages.gwenview
    xdg-utils
    wl-clipboard
    grim
    slurp
    swappy

  # --- Dev / creative workflow ---
    vscode
    git
    gcc
    gnumake
    cmake
    python3
    nodejs
    rustc cargo
    go
    godot
    blender
    inkscape
    gimp  
    floorp
    pkgs.xfce.thunar
    xdg-utils
    xfce.exo
    gvfs
    xfce.thunar-archive-plugin
  ];

   # Make Thunar the default for folders
  xdg.mimeApps.enable = true;
  xdg.mimeApps.defaultApplications = {
    "inode/directory"     = [ "thunar.desktop" ];
    "application/x-directory" = [ "thunar.desktop" ];
  };

    # 🐚 Shell configuration
  programs.fish = {
    enable = true;
    shellAliases = {
      rebuild = "sudo nixos-rebuild switch --flake /etc/nixos";
      updateos = "sudo nix flake update && rebuild";
      ls = "eza --icons --group-directories-first";
      cat = "bat";
      fetch = "fastfetch";
      htop = "btop";
    };
  };

  # ✨ Prompt styling
  programs.starship.enable = true;

  # 🪟 GTK + appearance
  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    cursorTheme = {
      name = "Bibata-Modern-Classic";
      package = pkgs.bibata-cursors;
    };
  };

  # 🔤 Fonts (for user-level apps like terminal / code editors)
  fonts.fontconfig.enable = true;

  # 🧰 Waybar / Hyprland extras (if you have custom configs)
  xdg.configFile."waybar/config.jsonc".source = ./waybar/config.jsonc;
  xdg.configFile."waybar/style.css".source = ./waybar/style.css;

  home.stateVersion = "25.05";
}
