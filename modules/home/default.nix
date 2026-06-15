{ config, pkgs, lib , ... }:

{
  home.username = "ga";
  home.homeDirectory = "/home/ga";

  # imports = [ ../modules/access ];

  # link the configuration file in current directory to the specified location in home directory
  # home.file.".config/i3/wallpaper.jpg".source = ./wallpaper.jpg;

  # link all files in `./scripts` to `~/.config/i3/scripts`
  # home.file.".config/i3/scripts" = {
  #   source = ./scripts;
  #   recursive = true;   # link recursively
  #   executable = true;  # make all files executable
  # };

  # encode the file content in nix configuration file directly
  # home.file.".xxx".text = ''
  #     xxx
  # '';

  # set cursor size and dpi for 4k monitor
  xresources.properties = {
    "Xcursor.size" = 16;
    #"Xft.dpi" = 172;
  };

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    # here is some command line tools I use frequently
    # feel free to add your own or remove some of them
    age
    ssh-to-pgp
    ssh-to-age

    #
    fastfetch
    nnn # terminal file manager
    yazi-unwrapped

    # archives
    zip
    xz
    unzip
    p7zip
    unrar
    peazip

    # documents
    pdf4qt
    papers

    # multimedia
    photoqt
    krita
    #tacentview
	  vlc
	  rapid-photo-downloader
	  qstopmotion #cmake3.5 problem
	  tuicam
	  obs-studio
	  cameractrls-gtk4

	  # 3D
	  f3d
	  # python313Packages.f3d
	  exhibit
	  prusa-slicer
	  orca-slicer

    # utils
    tlrc # tl;dr in rust - Tealdeer alternative
    ripgrep # recursively searches directories for a regex pattern
    jq # A lightweight and flexible command-line JSON processor
    fx # Advanced JSON viewer
    yq-go # yaml processor https://github.com/mikefarah/yq
    eza # A modern replacement for ‘ls’
    fzf # A command-line fuzzy finder
    # flameshot #.override { enableWlrSupport = true; } # Amazing screenshot tool
    lshw-gui # Details of hardware configuration
    libqalculate
    qalculate-qt # Calculator

    # networking tools
    mtr # A network diagnostic tool
    iperf3
    dnsutils  # `dig` + `nslookup`
    ldns # replacement of `dig`, it provide the command `drill`
    aria2 # A lightweight multi-protocol & multi-source command-line download utility
    socat # replacement of openbsd-netcat
    nmap # A utility for network discovery and security auditing
    ipcalc  # it is a calculator for the IPv4/v6 addresses
    go # for cameradar
    cameradar # RTSP stream access tool

    # web
    qbittorrent-enhanced

    # shell related
    pay-respects

    # misc
    # googleearth-pro #INSECURE.
    asciiquarium-transparent
    cowsay
    file
    which
    tree
    gnused
    gnutar
    gawk
    zstd
    gnupg

    # nix related
    #
    # it provides the command `nom` works just like `nix`
    # with more details log output
    nix-output-monitor
    nixos-facter
    npins
    nixd
    nixfmt # A formatter for Nix code

    # productivity
    hugo # static site generator
    glow # markdown previewer in terminal

    batmon # Battery monitoring
    btop-cuda  # replacement of htop/nmon
    iotop # io monitoring
    iftop # network monitoring
    usbtop # TODO: research
    usbview

    # system call monitoring
    strace # system call monitoring
    ltrace # library call monitoring
    lsof # list open files

    # system tools
    sysstat
    lm_sensors # for `sensors` command
    ethtool
    pciutils # lspci
    usbutils # lsusb

    # electronics boards
    hevi # Advanced HEX reader
    arduino-cli
    arduino-ide
    arduino-language-server
    teensyduino
    wiringpi
    fritzing # cmake 3.5 clipper 6.42 problem
    simulide_1_2_0

    # android cellphones
    android-tools #Android Debug Bridge
    lyto #ADB wireless over QR (min. 11)
    adbtuifm # ADB file manager
    android-backup-extractor # ADB backup tool
    rogcat # Developer LOGcat wrap
    gnirehtet # Tethering from PC to phone
    spytrap-adb # Stalkware debugger
    scrcpy # Screen duplicator CLI tool
    qtscrcpy # Same with GUI
    sdkmanager

	  # drones
    mission-planner

    # whatsapp
    whatsapp-emoji-font
    karere # A whatsapp client

    # Containers
    kail # Kubernets CLI manager

    rustdesk
    inkscape-with-extensions

    mqtt-explorer
    prismlauncher-unwrapped
    temurin-jre-bin
  ];

  # basic configuration of git, please change to your own
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Gustavo Alvarado";
        email = "igoutta@users.noreply.github.com";
      };
    };
  };

  # starship - an customizable prompt for any shell
  programs.starship = {
    enable = true;
    # custom settings
    settings = {
      add_newline = false;
      aws.disabled = true;
      gcloud.disabled = true;
      line_break.disabled = true;
    };
  };

  # alacritty - a cross-platform, GPU-accelerated terminal emulator
  programs.alacritty = {
    enable = true;
    theme = "tokyo_night_enhanced";
    # custom settings
    settings = {
      env.TERM = "xterm-256color";
      window = {
        opacity = 0.4;
        blur = true;
      };
      scrolling.multiplier = 5;
      font.size = 12;
      colors.draw_bold_text_with_bright_colors = true;
      selection.save_to_clipboard = true;
      cursor.style.shape = "Beam";
      mouse.hide_when_typing = true;
      mouse.bindings = [
        {
          mouse = "Middle";
          mods = "Control";
          action  = "Paste";
        }
      ];
    };
  };

  programs.helix = {
    enable = true;
    settings = {
      theme = "autumn_night_transparent";
      editor.cursor-shape = {
        normal = "block";
        insert = "bar";
        select = "underline";
      };
    };
    languages.language = [{
      name = "nix";
      auto-format = true;
      formatter.command = "${pkgs.nixfmt}/bin/nixfmt";
    }];
    themes = {
      autumn_night_transparent = {
        "inherits" = "autumn_night";
        "ui.background" = { };
      };
    };
  };

  programs.vscode.enable = true;
  programs.zed-editor.enable = true;

  # zsh - shell
  programs.zsh = {
    enable = true;
    dotDir = "${config.xdg.configHome}/zsh";
    sessionVariables = {
      EDITOR = "hx";
    };
	  envExtra =
	  ''
      eval "$(pay-respects zsh)"
      eval "$(starship init zsh)"
	  '';

    enableCompletion = true;
    dirHashes = {
    	nixconf = "/etc/nixos";
    };
    autosuggestion = {
      enable = true;
      strategy = [ "match_prev_cmd" ];
    };
    syntaxHighlighting.enable = true;

    history = {
      path = "${config.xdg.dataHome}/zsh/zsh_history";
      extended = true; # Enable timestamp
      append = true;
      share = true;
      size = 10000;
      ignoreDups = true;
      ignoreSpace = true;
      expireDuplicatesFirst = true;
      saveNoDups = true;
    };

    # set some aliases, feel free to add more or remove some
    shellAliases = {
      update = "sudo nixos-rebuild switch";
      clean-nixos-generations = "sudo nix-collect-garbage --delete-old";
      k = "kubectl";
      urldecode = "python3 -c 'import sys, urllib.parse as ul; print(ul.unquote_plus(sys.stdin.read()))'";
      urlencode = "python3 -c 'import sys, urllib.parse as ul; print(ul.quote_plus(sys.stdin.read()))'";
    };
    shellGlobalAliases = {
      UUID = "$(uuidgen | tr -d \\n)";
      G = "| grep";
    };

    oh-my-zsh = { # "ohMyZsh" without Home Manager
      enable = true;
      custom = "${config.home.homeDirectory}/.oh-my-zsh/custom";
      theme = "geometry";
      plugins = [
        "battery"

        "zsh-navigation-tools" "zsh-interactive-cd"

        "aliases" "sudo" "tldr" "web-search"

        "systemd" "arduino-cli" "eza"

        "uv" "python"

        "ssh-agent"

        "octozen" "zbell"

        "git"
      ];
      extraConfig =
      ''
        #~~~~~ Plugin: python
        PYTHON_VENV_NAME=".venv"
        PYTHON_VENV_NAMES=($PYTHON_VENV_NAME venv)
        PYTHON_AUTO_VRUN=true
        #~~~~~ Plugin: ssh-agent
        zstyle :omz:plugins:ssh-agent quiet yes
        zstyle :omz:plugins:ssh-agent lazy yes
        #~~~~~ Plugin: zbell
        zbell_duration=30
        #~~~~~ Plugin:eza
        zstyle ':omz:plugins:eza' 'git-status' yes
        zstyle ':omz:plugins:eza' 'dirs-first' yes
        zstyle ':omz:plugins:eza' 'header' yes
        zstyle ':omz:plugins:eza' 'icons' yes
        zstyle ':omz:plugins:eza' 'color-scale' all
        zstyle ':omz:plugins:eza' 'time-style' relative
      '';
    };
  };

  services.flameshot = {
    enable = true;
    settings.General = {
      copyOnDoubleClick = true;
      savePath = "${config.home.homeDirectory}/Pictures/Screenshots";
      savePathFixed = true;
      autoCloseIdleDaemon = true;
      startupLaunch = false;
      saveAsFileExtension = ".png";
      showStartupLaunchMessage = false;
      saveLastRegion = true;
    };
  };

  # This value determines the home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update home Manager without changing this value. See
  # the home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "26.05";
}

