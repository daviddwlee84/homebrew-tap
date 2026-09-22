class Lazymlflow < Formula
  desc "Terminal interface for MLflow experiments"
  homepage "https://github.com/daviddwlee84/lazymlflow"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/daviddwlee84/lazymlflow/releases/download/v0.2.1/lazymlflow_0.2.1_darwin_arm64.tar.gz"
      sha256 "365b78e6d02c5107e45b927c1f2c5c3df4b3da8ecd391bdb3672658fe641956f"
    end
    on_intel do
      url "https://github.com/daviddwlee84/lazymlflow/releases/download/v0.2.1/lazymlflow_0.2.1_darwin_amd64.tar.gz"
      sha256 "4171756096b4472261f87856e9b83be523a3c17761af570058137e033bbb383d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/daviddwlee84/lazymlflow/releases/download/v0.2.1/lazymlflow_0.2.1_linux_arm64.tar.gz"
      sha256 "fc67e7937360a646b2301ff5851ca5b99c8768c5c09ef59388da04d2581e071d"
    end
    on_intel do
      url "https://github.com/daviddwlee84/lazymlflow/releases/download/v0.2.1/lazymlflow_0.2.1_linux_amd64.tar.gz"
      sha256 "29801fd9288e30f77ee7b552d40e98348ff91ec7bc7fdda07489c351bcd5f093"
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
