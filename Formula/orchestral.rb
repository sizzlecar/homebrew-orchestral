class Orchestral < Formula
  desc "Runtime for reliable, interactive AI agents"
  homepage "https://orch.pandaailabs.com"
  version "0.3.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/sizzlecar/orchestral/releases/download/v0.3.1/orchestral-v0.3.1-aarch64-apple-darwin.tar.gz"
      sha256 "681391e08593c3e6869f8e2fd59207534b6a0eaf4f761cee9b236bee6a63c870"
    end
    on_intel do
      url "https://github.com/sizzlecar/orchestral/releases/download/v0.3.1/orchestral-v0.3.1-x86_64-apple-darwin.tar.gz"
      sha256 "7456486ba8eaaa70c0f956555719dacdffb2189b251b5ec0d07de58fb07601f9"
    end
  end

  on_linux do
    depends_on arch: :x86_64
    depends_on "bubblewrap"
    url "https://github.com/sizzlecar/orchestral/releases/download/v0.3.1/orchestral-v0.3.1-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "8d1393bd1a568f93ad5a9492aa215baf636353b3a933d5bdb7a7c726fc922015"
  end

  def install
    if OS.linux?
      libc = Utils.safe_popen_read("getconf", "GNU_LIBC_VERSION").strip
      match = libc.match(/\Aglibc (\d+\.\d+)/)
      odie "This binary requires glibc 2.35 or newer; build from source on this host." unless match && Version.new(match[1]) >= Version.new("2.35")
    end
    bin.install "orchestral"
    pkgshare.install "configs"
  end

  test do
    assert_equal "orchestral #{version}", shell_output("#{bin}/orchestral --version").strip
    assert_match "serve", shell_output("#{bin}/orchestral serve --help")
  end
end
