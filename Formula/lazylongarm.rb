class Lazylongarm < Formula
  desc "Set up and operate a Longarm hub and workers over SSH"
  homepage "https://github.com/daviddwlee84/lazylongarm"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/daviddwlee84/lazylongarm/releases/download/v0.5.0/lazylongarm_0.5.0_darwin_arm64.tar.gz"
      sha256 "09e4d291fd0e11749d231979d0e3862c51cf26783f82d41021b22cde197d0c85"
    end
    on_intel do
      url "https://github.com/daviddwlee84/lazylongarm/releases/download/v0.5.0/lazylongarm_0.5.0_darwin_amd64.tar.gz"
      sha256 "dab29574b98c8868519c04c1dcb625ef43233a1507faf6f62ed531b6308b71df"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/daviddwlee84/lazylongarm/releases/download/v0.5.0/lazylongarm_0.5.0_linux_arm64.tar.gz"
      sha256 "2cf8f5480d4e9156844a24abbbc1d2b00e9c5d6061242af7bb85b9d78bccea0d"
    end
    on_intel do
      url "https://github.com/daviddwlee84/lazylongarm/releases/download/v0.5.0/lazylongarm_0.5.0_linux_amd64.tar.gz"
      sha256 "b5d8af0609e2e5fafa1c0601ef85fdd099c9eb156dc404a835b5884e94c4e66d"
    end
  end

  def install
    bin.install "lazylongarm"
    bash_completion.install "completions/lazylongarm.bash" => "lazylongarm"
    zsh_completion.install "completions/lazylongarm.zsh" => "_lazylongarm"
    fish_completion.install "completions/lazylongarm.fish" if File.exist?("completions/lazylongarm.fish")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lazylongarm --version")
    assert_match "Usage:", shell_output("#{bin}/lazylongarm --help")
  end
end
