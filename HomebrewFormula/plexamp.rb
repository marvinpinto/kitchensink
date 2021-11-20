# typed: false
# frozen_string_literal: true

# Homebrew formula for Plexamp
class Plexamp < Formula
  APP_VERSION = "3.8.2"
  desc "Beautiful Plex music player for audiophiles, curators, and hipsters"
  homepage "https://plexamp.com"
  version APP_VERSION

  if OS.linux?
    url "https://plexamp.plex.tv/plexamp.plex.tv/desktop/Plexamp-#{APP_VERSION}.AppImage"
    sha256 "b310044d71c449c510106da33c69dd371ef093d23f21466676c1277afc2b860a"
  end

  def install
    prefix.install Dir["*"]
    chmod(0755, "#{prefix}/Plexamp-#{APP_VERSION}.AppImage")
    bin.install_symlink("#{prefix}/Plexamp-#{APP_VERSION}.AppImage" => "plexamp")
  end

  def caveats
    <<~EOS
      Executable is linked as "plexamp".
    EOS
  end
end
