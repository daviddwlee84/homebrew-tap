class ExpCli < Formula
  desc "Experiment tracking and workflow CLI"
  homepage "https://github.com/daviddwlee84/exp-cli"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/daviddwlee84/exp-cli/releases/download/v0.1.1/exp-cli_0.1.1_darwin_arm64.tar.gz"
      sha256 "cc626ef2660f75f48cec3a7ff680e8244b363724e2f51a8435e279c1f14ec979"
    end
    on_intel do
      url "https://github.com/daviddwlee84/exp-cli/releases/download/v0.1.1/exp-cli_0.1.1_darwin_amd64.tar.gz"
      sha256 "af8d3e54a948ca311191694086ca41b50151d24569702eb6945b27f5902aa6e6"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/daviddwlee84/exp-cli/releases/download/v0.1.1/exp-cli_0.1.1_linux_arm64.tar.gz"
      sha256 "061a0cb3725265b6dbe7118abe9e4e3914f06f54c931863de17c032e0ce3c85b"
    end
    on_intel do
      url "https://github.com/daviddwlee84/exp-cli/releases/download/v0.1.1/exp-cli_0.1.1_linux_amd64.tar.gz"
      sha256 "d0c18d45936d30a27c1d4803a3c8ab7c7fb1464cd7ea1fbc266aade91427ffc5"
    end
  end

  def install
    bin.install "exp"
    bash_completion.install "completions/exp.bash" => "exp"
    zsh_completion.install "completions/exp.zsh" => "_exp"
    fish_completion.install "completions/exp.fish" if File.exist?("completions/exp.fish")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/exp --version")
    assert_match "Usage:", shell_output("#{bin}/exp --help")
  end
end
