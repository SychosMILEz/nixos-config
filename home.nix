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
    lollypop

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
      rebuild = "fish -c 'cd /etc/nixos; sudo nixos-rebuild switch --flake /etc/nixos; if not git diff --quiet; git add .; git commit -m \"Auto update: rebuild on (date +%Y-%m-%d_%H:%M:%S)\"; git push; else; echo No config changes to commit.; end'";
      updateos = "fish -c 'cd /etc/nixos; nix flake update; if not git diff --quiet flake.lock; git add flake.lock; git commit -m \"Updated flake.lock on (date +%Y-%m-%d_%H:%M:%S)\"; git push; else; echo No flake updates to commit.; end; sudo nixos-rebuild switch --flake /etc/nixos'";
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
  xdg.configFile."hypr/hyprland.conf".source = ./hypr/hyprland.conf
  home.stateVersion = "25.05";
}
