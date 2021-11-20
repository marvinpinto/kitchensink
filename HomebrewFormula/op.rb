# typed: false
# frozen_string_literal: true

# Homebrew formula for 1Password CLI
class Op < Formula
  OP_VERSION = "1.12.3"
  desc "Installs the 1password cli from pre-built binaries"
  homepage "https://1password.com/downloads/command-line/"
  version OP_VERSION

  if OS.linux? && Hardware::CPU.intel?
    url "https://cache.agilebits.com/dist/1P/op/pkg/v#{OP_VERSION}/op_linux_amd64_v#{OP_VERSION}.zip"
    sha256 "947df336974f1b16b2fad50fe1621799348a8316758fd733f58b4671f6b08990"
  end

  if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
    url "https://cache.agilebits.com/dist/1P/op/pkg/v#{OP_VERSION}/op_linux_arm64_v#{OP_VERSION}.zip"
    sha256 "82042d01ff17f5af55e2b60efb9dfc820f13afe5305c8567fcbe854c2e321dc3"
  end

  def install
    bin.install "op"
  end

  test do
    system "#{bin}/op", "--version"
  end
end
