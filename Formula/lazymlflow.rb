class Lazymlflow < Formula
  desc "Terminal interface for MLflow experiments"
  homepage "https://github.com/daviddwlee84/lazymlflow"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/daviddwlee84/lazymlflow/releases/download/v0.1.0/lazymlflow_0.1.0_darwin_arm64.tar.gz"
      sha256 "7e66d9f9fcc8da839da76c4c3bf1fcbc5b2b7aa3e2c490b90683e5f30929ce07"
    end
    on_intel do
      url "https://github.com/daviddwlee84/lazymlflow/releases/download/v0.1.0/lazymlflow_0.1.0_darwin_amd64.tar.gz"
      sha256 "04d9a194d6f7fdb01bd853bb1f4ffd41219cb3c8e606c38704cd1f610e8ce31b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/daviddwlee84/lazymlflow/releases/download/v0.1.0/lazymlflow_0.1.0_linux_arm64.tar.gz"
      sha256 "521afdd90d6887170a5f1099ba2b90d68616c6e164e857af63d621a35fca669b"
    end
    on_intel do
      url "https://github.com/daviddwlee84/lazymlflow/releases/download/v0.1.0/lazymlflow_0.1.0_linux_amd64.tar.gz"
      sha256 "1c03b876c15ed4a8e4a1945ddbe2100dfeb6f7a1fb4b3754ef052537ca6ac6eb"
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
