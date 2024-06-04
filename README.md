# roam-flake

Flake for [ro.am](https://ro.am/) application package

# Usage as a flake

Add roam-flake to your `flake.nix`:

```nix
{
  inputs.roam.url = "github:xgroleau/roam-flake";

  outputs = { nixpkgs, roam, ... } @ inputs: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        {
          environment.systemPackages = [ roam.packages.x86_64-linux.default ];
        }

        # ... the rest of your modules here ...
      ];
    };
  };

}
```

If you use it with NixOS, you will probably need to enable a keyring like `gnome.gnome-keyring.enable = true;` to save you account creds. If not, you will need to relogin everytime you open the app.
