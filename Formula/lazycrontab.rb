class Lazycrontab < Formula
  desc "Local and SSH cron inspection and schedule editing"
  homepage "https://github.com/daviddwlee84/lazycrontab"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/daviddwlee84/lazycrontab/releases/download/v0.1.3/lazycrontab_0.1.3_darwin_arm64.tar.gz"
      sha256 "47b9e16086da336ccf491ec95caa7eb67c069e655239fb6809e4b512a65144f9"
    end
    on_intel do
      url "https://github.com/daviddwlee84/lazycrontab/releases/download/v0.1.3/lazycrontab_0.1.3_darwin_amd64.tar.gz"
      sha256 "f63af52d756c22c5630485eebe532c4a0a47355961c1416e6df3f64221f14327"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/daviddwlee84/lazycrontab/releases/download/v0.1.3/lazycrontab_0.1.3_linux_arm64.tar.gz"
      sha256 "235bd1efaafc8153ed2487a111da23f240f0c9fcadc843208a1e6fb2e01c56c8"
    end
    on_intel do
      url "https://github.com/daviddwlee84/lazycrontab/releases/download/v0.1.3/lazycrontab_0.1.3_linux_amd64.tar.gz"
      sha256 "a65c29ceb1c5d1d54640a3779d2486dbfea1121118077a39f7be8fa0356e6e1a"
    end
  end

  def install
    bin.install "lazycrontab"
    bash_completion.install "completions/lazycrontab.bash" => "lazycrontab"
    zsh_completion.install "completions/lazycrontab.zsh" => "_lazycrontab"
    fish_completion.install "completions/lazycrontab.fish" if File.exist?("completions/lazycrontab.fish")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lazycrontab --version")
    assert_match "Usage:", shell_output("#{bin}/lazycrontab --help")
  end
end
