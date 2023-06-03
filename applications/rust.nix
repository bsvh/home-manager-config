{ inputs, outputs, lib, config, pkgs, ... }: 
let 
  rust_sdk = "${config.xdg.dataHome}/sdk/rust";
  cargo_path = "${rust_sdk}/cargo";
in
{

  home.packages = with pkgs; [
    bacon
    gcc
    rustup
    panamax
    sccache
  ];

  home.sessionVariables = {
    CARGO_HOME = "${cargo_path}";
  };
  home.sessionPath = [
    "${cargo_path}/bin"
  ];

  systemd.user.services.panamax-server = {
    Unit.Description = "Local rust panamax crates.io mirror.";
    Install.WantedBy = [ "default.target" ];
    Service.ExecStart = "${pkgs.panamax}/bin/panamax serve --port 8122 ${rust_sdk}/cratesio-mirror";
  };

  home.file."cargo.toml" = {
    target = "${cargo_path}/cargo.toml";
    text = ''
      [source.panamax]
      registry = "http://localhost:8122/git/crates.io-index"
      [source.panamax-sparse]
      registry = "sparse+http://localhost:8122/index/"
      
      [source.crates-io]
      replace-with = "panamax-sparse"
      
      [build]
      rustc-wrapper = "${pkgs.sccache}/bin/sccache";
      '';
  };

}
