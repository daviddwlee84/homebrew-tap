class Lazylongarm < Formula
  desc "Set up and operate a Longarm hub and workers over SSH"
  homepage "https://github.com/daviddwlee84/lazylongarm"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/daviddwlee84/lazylongarm/releases/download/v0.4.3/lazylongarm_0.4.3_darwin_arm64.tar.gz"
      sha256 "291ee0d9abaa93c8b4074dad741d4bd1b071060b951e0c31fb2f4b3654c05f9f"
    end
    on_intel do
      url "https://github.com/daviddwlee84/lazylongarm/releases/download/v0.4.3/lazylongarm_0.4.3_darwin_amd64.tar.gz"
      sha256 "52062b33b37436795cf14df6b7eb81b1208907724da710d6b86664f1c0693bf3"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/daviddwlee84/lazylongarm/releases/download/v0.4.3/lazylongarm_0.4.3_linux_arm64.tar.gz"
      sha256 "727107a8477cc51d7ef50bc0a880b82f83c77b67f3cb2ef0a4ce4349748b256b"
    end
    on_intel do
      url "https://github.com/daviddwlee84/lazylongarm/releases/download/v0.4.3/lazylongarm_0.4.3_linux_amd64.tar.gz"
      sha256 "68fd3d671974ba370659fdbba14b6d596d7cac0be68db592c7f0783e92a3a72d"
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
