# typed: false
# frozen_string_literal: true

# Homebrew formula for Ergodox Wally
class ErgodoxWally < Formula
  WALLY_VERSION = "2.1.3"
  desc "Installs the Ergodox Wally flashing tool from pre-built binaries"
  homepage "https://github.com/zsa/wally"
  version WALLY_VERSION

  if OS.linux?
    url "https://github.com/zsa/wally/releases/download/#{WALLY_VERSION}-linux/wally"
    sha256 "a30c974c2fd544975e48f7f2ac99a21f936fa3e0803afeeb1096826a79afdbde"
  end

  def install
    bin.install "wally"
  end
end
