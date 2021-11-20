# typed: false
# frozen_string_literal: true

# Homebrew formula for Peek
class Peek < Formula
  PEEK_VERSION = "1.3.1"
  desc "Simple animated GIF screen recorder with an easy to use interface"
  homepage "https://github.com/phw/peek"
  version PEEK_VERSION

  if OS.linux?
    url "https://github.com/phw/peek/releases/download/#{PEEK_VERSION}/peek-#{PEEK_VERSION}-0-x86_64.AppImage"
    sha256 "d492ffa049a94fc3bad079c56ed37fac693d5bd43956b583e4f46560bdafa9b9"
  end

  def install
    prefix.install Dir["*"]
    chmod(0755, "#{prefix}/peek-#{PEEK_VERSION}-0-x86_64.AppImage")
    bin.install_symlink("#{prefix}/peek-#{PEEK_VERSION}-0-x86_64.AppImage" => "peek")
  end

  def caveats
    <<~EOS
      Executable is linked as "peek".
    EOS
  end
end
