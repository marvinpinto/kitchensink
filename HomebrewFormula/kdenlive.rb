# typed: false
# frozen_string_literal: true

# Homebrew formula for Kdenlive
class Kdenlive < Formula
  APP_VERSION = "21.08"
  APP_PATCH_VERSION = "3"
  desc "Open source video editor"
  homepage "https://kdenlive.org"
  version "#{APP_VERSION}.#{APP_PATCH_VERSION}"

  if OS.linux?
    url "https://download.kde.org/stable/kdenlive/#{APP_VERSION}/linux/kdenlive-#{APP_VERSION}.#{APP_PATCH_VERSION}-x86_64.appimage"
    sha256 "c969f3dcef08e74de0a78d777b9fc85ffb1afb50e18be530ea68e1a516d1d975"
  end

  def install
    prefix.install Dir["*"]
    chmod(0755, "#{prefix}/kdenlive-#{APP_VERSION}.#{APP_PATCH_VERSION}-x86_64.appimage")
    bin.install_symlink("#{prefix}/kdenlive-#{APP_VERSION}.#{APP_PATCH_VERSION}-x86_64.appimage" => "kdenlive")
  end

  def caveats
    <<~EOS
      Executable is linked as "kdenlive".
    EOS
  end
end
