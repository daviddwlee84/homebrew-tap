class ExpCli < Formula
  desc "Experiment tracking and workflow CLI"
  homepage "https://github.com/daviddwlee84/exp-cli"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/daviddwlee84/exp-cli/releases/download/v0.1.0/exp-cli_0.1.0_darwin_arm64.tar.gz"
      sha256 "9d0ea7a19de0572209fb5590c2ed8b6a9c207a24a5aea2b43c8d67ca7c6b406a"
    end
    on_intel do
      url "https://github.com/daviddwlee84/exp-cli/releases/download/v0.1.0/exp-cli_0.1.0_darwin_amd64.tar.gz"
      sha256 "7954d98fdc938b18b1afbf278887adc5734ebac910059e38d6fad9524316f8db"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/daviddwlee84/exp-cli/releases/download/v0.1.0/exp-cli_0.1.0_linux_arm64.tar.gz"
      sha256 "e7a5e48d912195bd0b7a1a8c146e6c2dcb48fc41991ee6030db77b4e24797afb"
    end
    on_intel do
      url "https://github.com/daviddwlee84/exp-cli/releases/download/v0.1.0/exp-cli_0.1.0_linux_amd64.tar.gz"
      sha256 "5477b1abb32052cda634debc516546f2dd60f53486ea659864bba81bd3de7637"
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
