class Lazylongarm < Formula
  desc "Set up and operate a Longarm hub and workers over SSH"
  homepage "https://github.com/daviddwlee84/lazylongarm"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/daviddwlee84/lazylongarm/releases/download/v0.6.0/lazylongarm_0.6.0_darwin_arm64.tar.gz"
      sha256 "2009102576efebae39ce76eb2023219a8a241716ab2da418b80faa101500a57b"
    end
    on_intel do
      url "https://github.com/daviddwlee84/lazylongarm/releases/download/v0.6.0/lazylongarm_0.6.0_darwin_amd64.tar.gz"
      sha256 "235d51ffff0dc87c85aa5deb0a7195910e49ef78da1f376b6b48fef5f89fc788"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/daviddwlee84/lazylongarm/releases/download/v0.6.0/lazylongarm_0.6.0_linux_arm64.tar.gz"
      sha256 "b1e26d34cfda2444d4c240ccd257165c71296018bc2a1cb2743f5ee387c2b89a"
    end
    on_intel do
      url "https://github.com/daviddwlee84/lazylongarm/releases/download/v0.6.0/lazylongarm_0.6.0_linux_amd64.tar.gz"
      sha256 "3f022077158789450550d44b27d714e3133c47c5c5e650160c95b8630d94ba86"
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
