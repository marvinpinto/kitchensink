# A Kitchen Sink Development Environment

<img alt="kitchen sink logo" height="200px" src="logo.png">


## OSX Manual Preparation

Install Xcode:
```bash
xcode-select --install
```


## Linux Manual Preparation

1. Boot up the machine with the USB key in place and manually install a recent [Ubuntu Desktop](https://ubuntu.com/download/desktop) LTS release.

1. For the Dell T1700, hit F12 on startup and select USB Storage Device.

1. After the installation process completes, disable power saving & screen lock (so that the bootstrap process proceeds without complications). Power Button (top right) -> Settings -> Power > Blank Screen -> Never.

1. After the installation process completes, install a few bootstrap utilities to get going:
```bash
sudo apt-get install -y curl ca-certificates
```


## Software Setup

Initialize the software installation process with homebrew and a few other basics:
```bash
bash -xec "$(curl -L https://raw.githubusercontent.com/marvinpinto/kitchensink/main/bootstrap.sh)"
```

When bootstrapping the machine, clone the kitchensink repo locally and run the manifest from within there:
```bash
git clone https://github.com/marvinpinto/kitchensink.git /tmp/kitchensink
cd /tmp/kitchensink
```

Setup the homebrew path initially:
```bash
# linux
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
```

```bash
# osx
eval "$(/usr/local/bin/brew shellenv)"
```

Run ansible to install & manage all the sytem components:
```bash
ANSIBLE_VERBOSITY=2 make machine
```

Bootstrap the 1password CLI (for secrets), export the specified env vars after it completes:
```bash
make op-init
```

Validate that the 1password cli create the config file correctly, sometimes this does not work on the first try for whatever reason:
```bash
[[ -e "${HOME}/.openv-cfg-dir/config" ]] && true || echo "1password CLI did NOT initialize successfully, re-run: make op-init"
```

```bash
export OP_CONFIG_DIR=/tmp/openv-XXXXXXXXXX
export OP_SESSION_my=XXXXXXXXXXX
```

Initialize the dotfiles using [chezmoi](https://github.com/twpayne/chezmoi):
```bash
make chezmoi-init
```


## Post software setup

- **osx/linux**: reboot the machine and log back in

- **osx**: If a homebrew cask/cli app throws a "cannot be verified" error, ctrl+click the app icon in Finder/Applications, and then choose "Open". This effectively saves the exception in security settings and it should not throw this error again.

- **osx**: Manual keyboard preference changes (System Preferences -> Keyboard):
  - Keyboard: Adjust keyboard brightness in low light (enable)
  - Keyboard: Turn keyboard backlight off after 5 secs of inactivity (enable)
  - Modifier Keys: Change Caps lock to Ctrl
  - Shortcuts -> Accessibility: Map Cmd+Q to "Invert Colors"

- **osx**: Install divvy from the App Store, and ensure it runs on startup.

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


## Throwaway Environments from the Command Line

Aside from automatically creating environments in VSCode, this can also be used to to generate _throwaway_ environments/containers from the command line. This has only been used on Linux and probably won't work with OSX.

Using the [sink](https://github.com/marvinpinto/kitchensink/blob/775f75aec6cbd77727af87b6ceb119fb5b5d1922/dotfiles/dot_bash.d/kitchensink#L3-L45) bash function, this would create a temporary environment to experiment in, without affecting the host. Would look something like this:

```text
[mp-desktop: 19:56:07] ~
$ sink test-env
Creating new docker container
Cloning into '/home/worker/dotfiles'...
remote: Enumerating objects: 1039, done.
remote: Counting objects: 100% (364/364), done.
remote: Compressing objects: 100% (242/242), done.
remote: Total 1039 (delta 159), reused 294 (delta 97), pack-reused 675
Receiving objects: 100% (1039/1039), 321.92 KiB | 4.13 MiB/s, done.
Resolving deltas: 100% (495/495), done.

[test-env: 19:56:32] ~
# echo "hello from within test-env"
hello from within test-env

[test-env: 19:56:55] ~
# exit
exit
```

The above function creates the container (from the [Dockerfile](/Dockerfile) image), optionally mounts a source directory, then initializes the dotfiles within the container using [chezmoi](https://github.com/twpayne/chezmoi).


## License

The source code for this project is released under the [MIT License]((LICENSE.txt)).


## Credits

The original incantation of this project was inspired by [github.com/shykes/devbox](https://github.com/shykes/devbox). The logo was made by [github.com/des4maisons](https://github.com/des4maisons).
