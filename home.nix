{ config, pkgs, ... }:

{
  home.username = "smilez";
  home.homeDirectory = "/home/smilez";

  # Let Home Manager manage itself
  programs.home-manager.enable = true;

  # ───────────────────────────────────────────────
  # 🧩 User Packages (lightweight + personal tools)
  # ───────────────────────────────────────────────
  home.packages = with pkgs; [

    # --- Core CLI / Utility tools ---
    fastfetch          # system info
    btop               # process monitor
    fish               # shell (config below)
    starship           # prompt (config below)
    neovim             # text editor
    bat                # better cat
    fzf                # fuzzy finder
    eza                # better ls
    ripgrep            # recursive grep
    fd                 # faster find
    viu                # image preview in terminal

    # --- Personal apps ---
    lollypop           # music player (optional)
    vscode             # code editor
    git                # version control
 
    # --- Fonts and colors ---
     nerd-fonts.jetbrains-mono
     fira-code
     dejavu_fonts
     noto-fonts
     noto-fonts-emoji
     papirus-icon-theme
     bibata-cursors
     catppuccin-gtk
 ];

  # ───────────────────────────────────────────────
  # 📂 Default Applications
  # ───────────────────────────────────────────────
  xdg.mimeApps.enable = true;
  xdg.mimeApps.defaultApplications = {
    "inode/directory"         = [ "thunar.desktop" ];
    "application/x-directory" = [ "thunar.desktop" ];
  };

  # ───────────────────────────────────────────────
  # 🐚 Shell Configuration
  # ───────────────────────────────────────────────
  programs.fish = {
    enable = true;
    loginShellInit = ''
     starship init fish | source
    '';
    shellAliases = {
      # 🔧 System management aliases
      rebuild  = "cd /etc/nixos; and sudo nixos-rebuild switch --flake /etc/nixos";
      updateos = "cd /etc/nixos; and nix flake update; and sudo nixos-rebuild switch --flake /etc/nixos";

      # 🧭 Quality-of-life aliases
      ls     = "eza --icons --group-directories-first";
      cat    = "bat";
      fetch  = "fastfetch";
      htop   = "btop";
    };
    loginShell = true;
  };

  # ───────────────────────────────────────────────
  # ✨ Prompt Styling
  # ───────────────────────────────────────────────
  programs.starship.enable = true;

  # ───────────────────────────────────────────────
  # 🪟 GTK + Appearance
  # ───────────────────────────────────────────────
gtk = {
  enable = true;
  theme = {
    name = "Catppuccin-Mocha-Blue-Dark";
    package = pkgs.catppuccin-gtk;
  };
  iconTheme = {
    name = "Papirus-Dark";
    package = pkgs.papirus-icon-theme;
  };
  cursorTheme = {
    name = "Bibata-Modern-Classic";
    package = pkgs.bibata-cursors;
  };
  gtk3.extraConfig = { gtk-application-prefer-dark-theme = 1; };
  gtk4.extraConfig = { gtk-application-prefer-dark-theme = true; };
};

  # Enable font rendering for user apps
  fonts.fontconfig.enable = true;

home.file.".local/share/fonts/BadaboomBB.zip".source =
  pkgs.fetchurl {
    url = "https://www.1001fonts.com/download/badaboom-bb.zip";
    sha256 = "sha256-T44MR1NQniOXJ2Pn+bjh4m40bE6dsw4oSharSaRYhQI=";
  };

  # ───────────────────────────────────────────────
  # 🏁 Version Lock
  # ───────────────────────────────────────────────
  home.stateVersion = "25.05";
}
