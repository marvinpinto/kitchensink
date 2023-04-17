# A Kitchen Sink Development Environment

<img alt="kitchen sink logo" height="200px" src="logo.png">


## Bootable Media
Use [etcher](https://github.com/balena-io/etcher) to create a bootable Ubuntu USB disk, and follow [these instructions](https://alexlubbock.com/bootable-windows-usb-on-mac) to create a Windows 11 bootable USB.


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


## Windows Manual Preparation

1. Boot up the machine with the USB key in place and manually install [Win 11 Home](https://www.microsoft.com/en-ca/software-download/windows11).

1. When testing in Virtualbox: shift+F10, regedit, create the following key + DWORD entries `HKEY_LOCAL_MACHINE\SYSTEM\Setup\LabConfig`:
  - BypassTPMCheck: 1
  - BypassRAMCheck: 1
  - BypassSecureBootCheck: 1

1. During the installation process use `a@a.com` and a blank password when prompted for the online account. This should help bypass that and allow for a local account.

1. Install Virtualbox Guest additions when testing.

1. After installation, activate Windows using a license key. When [testing in Virtualbox](https://github.com/massgravel/Microsoft-Activation-Scripts) use the following and select `HWID`:
```
irm https://massgrave.dev/get | iex
```

1. Upgrade Powershell & DotNet
```
winget install Microsoft.PowerShell
winget install Microsoft.DotNet.DesktopRuntime.7
```

1. Enable the Windows Substem for Linux optional feature & reboot if prompted
```
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux
```

1. Bootstrap Windows using an admin powershell terminal
```
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$url = "https://raw.githubusercontent.com/ansible/ansible/v2.14.4/examples/scripts/ConfigureRemotingForAnsible.ps1"
$file = "$env:temp\setup.ps1"
(New-Object -TypeName System.Net.WebClient).DownloadFile($url, $file)
Write-Verbose "Configuring the WinRM service for Ansible..." -Verbose
powershell.exe -ExecutionPolicy ByPass -File $file -Verbose

Write-Verbose "Installing Chocolatey..." -Verbose
Set-ExecutionPolicy Bypass -Scope Process -Force; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
```

1. Install Ubuntu under a non-admin powershell terminal
```
wsl --set-default-version 1
wsl --install -d Ubuntu
```

1. Reboot the machine


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
# linux/wsl
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

```bash
ANSIBLE_PIPELINING=1 ANSIBLE_VERBOSITY=2 make windows
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


## Post Software Setup

- **osx/linux/windows**: reboot the machine and log back in

- **windows**: manual package management:
```
winget install -e --id Alacritty.Alacritty
winget install -e --id AgileBits.1Password
winget install -e --id Logitech.GHUB
Get-AppxPackage -AllUsers Microsoft.Xbox* | Remove-AppxPackage
```

- **osx**: If a homebrew cask/cli app throws a "cannot be verified" error, ctrl+click the app icon in Finder/Applications, and then choose "Open". This effectively saves the exception in security settings and it should not throw this error again.

- **osx**: Manual keyboard preference changes (System Preferences -> Keyboard):
  - Keyboard: Adjust keyboard brightness in low light (enable)
  - Keyboard: Turn keyboard backlight off after 5 secs of inactivity (enable)
  - Modifier Keys: Change Caps lock to Ctrl
  - Shortcuts -> Accessibility: Map Cmd+Q to "Invert Colors"

- **osx**: Install divvy and tailscale from the App Store and ensure they both run on startup.

- **linux**: Apply any updated software patches using the `yoloupdate` alias.

- **osx/linux**: Add the core AWS vault credentials:
  ```bash
  export OP_AWS_MFA_NAME=AWS-useraccount-marvin-dev
  ave-init marvin
  ```

- **osx/linux**: Reboot the machine at least once to verify everything worked correctly.

## Using the Kitchensink Tap

The [HomebrewFormula](/HomebrewFormula) directory contains a bunch of linux CLI & AppImage maps for use as Homebrew installations.

Add the `kitchensink` tap as follows:

```bash
brew tap marvinpinto/kitchensink "https://github.com/marvinpinto/kitchensink.git"
```

Then install a formula as follows - using digikam as an example:

```bash
brew install marvinpinto/kitchensink/digikam
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
