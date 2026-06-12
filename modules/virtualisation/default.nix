{ pkgs, ... }:
{
  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = true;
        swtpm.enable = true;
        vhostUserPackages = [ pkgs.virtiofsd ];
      };
    };

    # Enable common container config files in /etc/containers
    containers.enable = true;

    podman = {
      enable = true;
      dockerCompat = true; # Create a `docker` alias for podman, to use it as a drop-in replacement
      dockerSocket.enable = true;
      defaultNetwork.settings.dns_enabled = true;
      extraPackages = with pkgs; [
        #qemu # needed to build the podman machine
        virtiofsd # needed to start the podman machine
      ];
    };
  };

  environment.systemPackages = with pkgs; [
    dive # look into docker image layers
    gvisor # Application Kernel for Containers
    podman-tui # status of containers in the terminal
    #docker-compose # start group of containers for dev
    podman-compose # start group of containers for dev
  ];
}
