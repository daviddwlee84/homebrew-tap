class Lazylongarm < Formula
  desc "Set up and operate a Longarm hub and workers over SSH"
  homepage "https://github.com/daviddwlee84/lazylongarm"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/daviddwlee84/lazylongarm/releases/download/v0.5.1/lazylongarm_0.5.1_darwin_arm64.tar.gz"
      sha256 "26a04246008356410681eb5cb7a65a4483268c51d919899a00922acc17475e42"
    end
    on_intel do
      url "https://github.com/daviddwlee84/lazylongarm/releases/download/v0.5.1/lazylongarm_0.5.1_darwin_amd64.tar.gz"
      sha256 "4292e9c15d4af07939ff474247655e17becbaeac94a2b4ee76e229ecfc3acf0b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/daviddwlee84/lazylongarm/releases/download/v0.5.1/lazylongarm_0.5.1_linux_arm64.tar.gz"
      sha256 "2dea0d7afb8df8b34a0e5b456167f670060a9876bfadda2fc35153b610195a6f"
    end
    on_intel do
      url "https://github.com/daviddwlee84/lazylongarm/releases/download/v0.5.1/lazylongarm_0.5.1_linux_amd64.tar.gz"
      sha256 "4864a81776b17fe36c458d2d2622abc171a0b1c49c5e7e3ae86bedda70292a77"
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
