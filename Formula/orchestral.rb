class Orchestral < Formula
  desc "Runtime for reliable, interactive AI agents"
  homepage "https://orch.pandaailabs.com"
  version "0.4.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/sizzlecar/orchestral/releases/download/v0.4.1/orchestral-v0.4.1-aarch64-apple-darwin.tar.gz"
      sha256 "daa8940ad625304db41ff8ef5d7a6267a654783ca13799f1b33449c8fd541196"
    end
    on_intel do
      url "https://github.com/sizzlecar/orchestral/releases/download/v0.4.1/orchestral-v0.4.1-x86_64-apple-darwin.tar.gz"
      sha256 "d03b72d5e794677b7088ded1a35b1ff884565d47073e6ac907c894e856febcbd"
    end
  end

  on_linux do
    depends_on arch: :x86_64
    depends_on "bubblewrap"
    url "https://github.com/sizzlecar/orchestral/releases/download/v0.4.1/orchestral-v0.4.1-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "ef3cfa73aa7d9c836c245db058ada2e394c0feeae2d25489d455cd452ff96fa2"
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
