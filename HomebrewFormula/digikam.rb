# typed: false
# frozen_string_literal: true

# Homebrew formula for Digikam
class Digikam < Formula
  APP_VERSION = "7.3.0"
  desc "Professional Photo Management with the Power of Open Source"
  homepage "https://www.digikam.org/"
  version APP_VERSION

  if OS.linux?
    url "https://mirror.csclub.uwaterloo.ca/kde/stable/digikam/#{APP_VERSION}/digiKam-#{APP_VERSION}-x86-64.appimage"
    sha256 "68c36c72102114e15ff29249806bb2bb4d389b4ceda7a9a4848412e25c174c57"
  end

  def install
    prefix.install Dir["*"]
    chmod(0755, "#{prefix}/digiKam-#{APP_VERSION}-x86-64.appimage")
    bin.install_symlink("#{prefix}/digiKam-#{APP_VERSION}-x86-64.appimage" => "digikam")
  end

  def caveats
    <<~EOS
      Executable is linked as "digikam".
    EOS
  end
end
