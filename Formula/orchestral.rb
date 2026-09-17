class Orchestral < Formula
  desc "Runtime for reliable, interactive AI agents"
  homepage "https://orch.pandaailabs.com"
  version "0.4.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/sizzlecar/orchestral/releases/download/v0.4.0/orchestral-v0.4.0-aarch64-apple-darwin.tar.gz"
      sha256 "acb8e1296c0641b8cf4b986ee12b23dc13ffcf41d5430f7018397eecb354e2d4"
    end
    on_intel do
      url "https://github.com/sizzlecar/orchestral/releases/download/v0.4.0/orchestral-v0.4.0-x86_64-apple-darwin.tar.gz"
      sha256 "7c6e6413bd59d7b892f7cbfe0adca85f261dd4c2b97a61e8a11b246c39dd61ab"
    end
  end

  on_linux do
    depends_on arch: :x86_64
    depends_on "bubblewrap"
    url "https://github.com/sizzlecar/orchestral/releases/download/v0.4.0/orchestral-v0.4.0-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "41f36e08be077691de205eca168faa3bc65a623014fc4a0d235385dbdcb7cc59"
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
