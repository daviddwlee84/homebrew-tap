class Lazymlflow < Formula
  desc "Terminal interface for MLflow experiments"
  homepage "https://github.com/daviddwlee84/lazymlflow"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/daviddwlee84/lazymlflow/releases/download/v0.3.0/lazymlflow_0.3.0_darwin_arm64.tar.gz"
      sha256 "2266edb9d599a6c65ed4388b0685a0c8deee300e6a85c7b9f84257da47e43157"
    end
    on_intel do
      url "https://github.com/daviddwlee84/lazymlflow/releases/download/v0.3.0/lazymlflow_0.3.0_darwin_amd64.tar.gz"
      sha256 "216d2424172e807db3770a3b4802d1dbce02f8230442a967ee5a5d2b2e2e8c1a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/daviddwlee84/lazymlflow/releases/download/v0.3.0/lazymlflow_0.3.0_linux_arm64.tar.gz"
      sha256 "bead00d5b930209d29b7d03dfa2c0b82d58ba2e323ef9942c951b9bd41dcae07"
    end
    on_intel do
      url "https://github.com/daviddwlee84/lazymlflow/releases/download/v0.3.0/lazymlflow_0.3.0_linux_amd64.tar.gz"
      sha256 "275fa0b0ff5a166d82f85fb7775423dc108ca70ca2100cf0b64ba5b693baefd5"
    end
  end

  def install
    bin.install "lazymlflow"
    bash_completion.install "completions/lazymlflow.bash" => "lazymlflow"
    zsh_completion.install "completions/lazymlflow.zsh" => "_lazymlflow"
    fish_completion.install "completions/lazymlflow.fish" if File.exist?("completions/lazymlflow.fish")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lazymlflow --version")
    assert_match "Usage:", shell_output("#{bin}/lazymlflow --help")
  end
end
