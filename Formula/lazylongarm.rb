class Lazylongarm < Formula
  desc "Set up and operate a Longarm hub and workers over SSH"
  homepage "https://github.com/daviddwlee84/lazylongarm"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/daviddwlee84/lazylongarm/releases/download/v0.4.2/lazylongarm_0.4.2_darwin_arm64.tar.gz"
      sha256 "61a5f007aa7ac9d2ab3d7f9c2ce5c45ac67db611b75927b35b627416f2446a57"
    end
    on_intel do
      url "https://github.com/daviddwlee84/lazylongarm/releases/download/v0.4.2/lazylongarm_0.4.2_darwin_amd64.tar.gz"
      sha256 "b4cbce99d5a982fcdaf5bf03874143aa1e41af31cd2720b63438e816caaaec62"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/daviddwlee84/lazylongarm/releases/download/v0.4.2/lazylongarm_0.4.2_linux_arm64.tar.gz"
      sha256 "634abc8c1994fd3819fb85bcd3807cd1bc2e7515b93d9f49c1955c4cb9a038eb"
    end
    on_intel do
      url "https://github.com/daviddwlee84/lazylongarm/releases/download/v0.4.2/lazylongarm_0.4.2_linux_amd64.tar.gz"
      sha256 "521596124b07dfd44d2c85ea57d69d25f455a6966350e30c32929d9aaad471cd"
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
