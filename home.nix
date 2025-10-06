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
    shellAliases = {
      # 🔧 System management aliases
      rebuild  = "fish -c 'cd /etc/nixos; sudo nixos-rebuild switch --flake /etc/nixos; if not git diff --quiet; git add .; git commit -m \"Auto update: rebuild on (date +%Y-%m-%d_%H:%M:%S)\"; git push; else; echo No config changes to commit.; end'";
      updateos = "fish -c 'cd /etc/nixos; nix flake update; if not git diff --quiet flake.lock; git add flake.lock; git commit -m \"Updated flake.lock on (date +%Y-%m-%d_%H:%M:%S)\"; git push; else; echo No flake updates to commit.; end; sudo nixos-rebuild switch --flake /etc/nixos'";

      # 🧭 Quality-of-life aliases
      ls     = "eza --icons --group-directories-first";
      cat    = "bat";
      fetch  = "fastfetch";
      htop   = "btop";
    };
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

  home.file.".local/share/fonts/BadaboomBB.ttf".source =
  pkgs.fetchurl {
    url = "https://st.1001fonts.net/download/font/badaboom-bb.regular.ttf";
    sha256 = "sha256-175yq6vy6i4bkd2drcgarzqx7ngmi1rkcpnf2xn43ydn6nk55vmj";
  };

  # ───────────────────────────────────────────────
  # 🏁 Version Lock
  # ───────────────────────────────────────────────
  home.stateVersion = "25.05";
}
