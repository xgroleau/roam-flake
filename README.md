# roam-flake
Flake for ro.am package

# Usage as a flake

[![FlakeHub](https://img.shields.io/endpoint?url=https://flakehub.com/f/xgroleau/roam-flake/badge)](https://flakehub.com/flake/xgroleau/roam-flake)

Add roam-flake to your `flake.nix`:

```nix
{
  inputs.roam-flake.url = "https://flakehub.com/f/xgroleau/roam-flake/*.tar.gz";

  outputs = { self, roam-flake }: {
    # Use in your outputs
  };

}
```
