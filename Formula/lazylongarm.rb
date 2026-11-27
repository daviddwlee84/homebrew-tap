class Lazylongarm < Formula
  desc "Set up and operate a Longarm hub and workers over SSH"
  homepage "https://github.com/daviddwlee84/lazylongarm"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/daviddwlee84/lazylongarm/releases/download/v0.7.1/lazylongarm_0.7.1_darwin_arm64.tar.gz"
      sha256 "e3d3a97304a50519079e02cddef87d9a075d09001f6328f087fe43c11675910b"
    end
    on_intel do
      url "https://github.com/daviddwlee84/lazylongarm/releases/download/v0.7.1/lazylongarm_0.7.1_darwin_amd64.tar.gz"
      sha256 "f67df833700266d73b70e1aadbba49e815933b78fb2f8ead6e51e2d2f18e1a1f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/daviddwlee84/lazylongarm/releases/download/v0.7.1/lazylongarm_0.7.1_linux_arm64.tar.gz"
      sha256 "89e9d0d56905604b2b5eee38f39dd9bcdb5f2e868a863ae10981a34a0676d012"
    end
    on_intel do
      url "https://github.com/daviddwlee84/lazylongarm/releases/download/v0.7.1/lazylongarm_0.7.1_linux_amd64.tar.gz"
      sha256 "902b081e09609fabfc05e54b0d02827f4eed6be5321832d8cd5ad5a71c4171e0"
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
