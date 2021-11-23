# A Kitchen Sink Development Environment

<img alt="kitchen sink logo" height="200px" src="logo.png">


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


## Development within VSCode Remote Containers

Combining [remote containers](https://code.visualstudio.com/docs/remote/containers#_create-a-devcontainerjson-file) with [automatically setup dotfiles](https://code.visualstudio.com/docs/remote/containers#_personalizing-with-dotfile-repositories) enables very powerful throwaway dev environments.

See the example [devcontainer.json](/.devcontainer/devcontainer.json) and my vscode [settings.json](https://github.com/marvinpinto/kitchensink/blob/26c23c94de21e00b9adfee9a3f900f0abdb889f3/dotfiles/.chezmoitemplates/vscode_settings.json#L18-L20) file for inspiration.


## License

The source code for this project is released under the [MIT License]((LICENSE.txt)).


## Credits

The original incantation of this project was inspired by [github.com/shykes/devbox](https://github.com/shykes/devbox). The logo was made by [github.com/des4maisons](https://github.com/des4maisons).
