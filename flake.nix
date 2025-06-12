{
  description = "Flutter";

  inputs = {
    flake-utils = { url = "github:numtide/flake-utils"; };
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
    android-nixpkgs = { url = "github:tadfisher/android-nixpkgs"; };
  };

  outputs = { self, nixpkgs, flake-utils, flake-compat, android-nixpkgs }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config = {
            allowUnfree = true;
            android_sdk = { accept_license = true; };
          };
        };
        android-sdk = android-nixpkgs.sdk.${system} (sdkPkgs:
          with sdkPkgs;
          [
            cmdline-tools-latest
            build-tools-34-0-0
            platform-tools
            platforms-android-34
            emulator
          ] ++ pkgs.lib.optionals (system == "aarch64-darwin")
          [ system-images-android-34-google-apis-arm64-v8a ]
          ++ pkgs.lib.optionals
          (system == "x86_64-darwin" || system == "x86_64-linux")
          [ system-images-android-34-google-apis-x86-64 ]);
        pinnedJDK = pkgs.jdk;
      in {
        devShells = {
          default = pkgs.mkShell {
            name = "flutter-dev";
            buildInputs = with pkgs;
              [ flutter gtk3 libepoxy mesa ] ++ [ pinnedJDK android-sdk ];
            JAVA_HOME = pinnedJDK;
            ANDROID_HOME = "${android-sdk}/share/android-sdk";
            GRADLE_USER_HOME = "/home/hanasaki/.gradle";
            GRADLE_OPTS =
              "-Dorg.gradle.project.android.aapt2FromMavenOverride=${android-sdk}/share/android-sdk/build-tools/34.0.0/aapt2";
          };
        };
      });
}
