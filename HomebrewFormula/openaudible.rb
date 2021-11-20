# typed: false
# frozen_string_literal: true

# Homebrew formula for OpenAudible
class Openaudible < Formula
  APP_VERSION = "3.2.2"
  desc "Open Source Audible Manager"
  homepage "https://openaudible.org"
  version APP_VERSION

  if OS.linux?
    url "https://github.com/openaudible/openaudible/releases/download/v#{APP_VERSION}/OpenAudible_#{APP_VERSION}_x86_64.AppImage"
    sha256 "795864a9049829e9d88231d5a709b7225fdf2baf8adee7a75d434af7843ed3e4"
  end

  def install
    prefix.install Dir["*"]
    chmod(0755, "#{prefix}/OpenAudible_#{APP_VERSION}_x86_64.AppImage")
    bin.install_symlink("#{prefix}/OpenAudible_#{APP_VERSION}_x86_64.AppImage" => "openaudible")
  end

  def caveats
    <<~EOS
      Executable is linked as "openaudible".
    EOS
  end
end
