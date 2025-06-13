{ pkgs }: {
  channel = "unstable";
  packages = [
    pkgs.jdk17
    pkgs.unzip
    pkgs.fish
    pkgs.starship
    pkgs.pkg-config
    pkgs.tree
  ];
  idx.extensions = [
    "dart-code.flutter"
    "dart-code.dart-code"
    "vscodevim.vim"
    "llam4u.nerdtree"
  ];
  idx.previews = {
    previews = {
      # web = {
      #   command = [
      #     "flutter"
      #     "run"
      #     "--machine"
      #     "-d"
      #     "web-server"
      #     "--web-hostname"
      #     "0.0.0.0"
      #     "--web-port"
      #     "$PORT"
      #   ];
      #   manager = "flutter";
      # };
      # android = {
      #   command = [
      #     "flutter"
      #     "run"
      #     "--machine"
      #     "-d"
      #     "android"
      #     "-d"
      #     "localhost:5555"
      #   ];
      #   manager = "flutter";
      # };
    };
  };
}
