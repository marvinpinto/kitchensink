# typed: false
# frozen_string_literal: true

# Homebrew formula for Digikam
class Digikam < Formula
  APP_VERSION = "8.5.0"
  desc "Professional Photo Management with the Power of Open Source"
  homepage "https://www.digikam.org/"
  version APP_VERSION

  if OS.linux?
    url "https://mirror.csclub.uwaterloo.ca/kde/stable/digikam/#{APP_VERSION}/digiKam-#{APP_VERSION}-Qt6-x86-64.appimage"
    sha256 "dadb433bd7cc338a48c7c846bfd0a0c127756ce4652b5f27a895e45160049bc7"
  end

  def install
    prefix.install Dir["*"]
    chmod(0755, "#{prefix}/digiKam-#{APP_VERSION}-Qt6-x86-64.appimage")
    bin.install_symlink("#{prefix}/digiKam-#{APP_VERSION}-Qt6-x86-64.appimage" => "digikam")
  end

  def caveats
    <<~EOS
      Executable is linked as "digikam".
    EOS
  end
end
