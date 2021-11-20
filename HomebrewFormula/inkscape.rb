# typed: false
# frozen_string_literal: true

# Homebrew formula for Inkscape
class Inkscape < Formula
  desc "Draw Freely"
  homepage "https://inkscape.org/"
  version "1.1.1"

  if OS.linux?
    url "https://inkscape.org/gallery/item/29256/Inkscape-3bf5ae0-x86_64.AppImage"
    sha256 "51cc3c45b6b525035c977d483e72b525056782f46c5904f8858e11bdef365a7a"
  end

  def install
    prefix.install Dir["*"]
    chmod(0755, "#{prefix}/Inkscape-3bf5ae0-x86_64.AppImage")
    bin.install_symlink("#{prefix}/Inkscape-3bf5ae0-x86_64.AppImage" => "inkscape")
  end

  def caveats
    <<~EOS
      Executable is linked as "inkscape".
    EOS
  end
end
