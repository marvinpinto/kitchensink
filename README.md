# A Kitchen Sink Development Environment

<img alt="kitchen sink logo" height="200px" src="logo.png">


## Contents

1. [New Machine Setup](#new-machinexsetup)
1. [Using the Kitchensink Tap](#using-the-kitchensink-tap)
1. [License](#license)
1. [Credits](#credits)


## New Machine Setup

Bootstrap the installation process with homebrew and a few other basics:

```bash
bash -xec "$(curl -L https://raw.githubusercontent.com/marvinpinto/kitchensink/main/bootstrap.sh)"
```
Run ansible to install & manage all the sytem components:

```bash
make machine
```

Bootstrap the 1password CLI (for secrets), export the specified env vars after it completes:

```bash
make op-init
```

```bash
export OP_CONFIG_DIR=/tmp/openv-XXXXXXXXXX
export OP_SESSION_my=XXXXXXXXXXX
```

Initialize the dotfiles using [chezmoi](https://github.com/twpayne/chezmoi):

```bash
make chezmoi-init
```


## Using the Kitchensink Tap

The [HomebrewFormula](/HomebrewFormula) directory contains a bunch of linux CLI & AppImage maps for use as Homebrew installations.

Add the `kitchensink` tap as follows:

```bash
brew tap marvinpinto/kitchensink "https://github.com/marvinpinto/kitchensink.git"
```

Then install a formula as follows - using the 1password cli as an example:

```bash
brew install marvinpinto/kitchensink/op
```


## License

The source code for this project is released under the [MIT License]((LICENSE.txt)).


## Credits

The original incantation of this project was inspired by [github.com/shykes/devbox](https://github.com/shykes/devbox). The logo was made by [github.com/des4maisons](https://github.com/des4maisons).
