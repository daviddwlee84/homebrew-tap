class Lazychezmoi < Formula
  desc "Terminal interface for chezmoi dotfiles"
  homepage "https://github.com/daviddwlee84/lazychezmoi"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/daviddwlee84/lazychezmoi/releases/download/v0.1.1/lazychezmoi_0.1.1_darwin_arm64.tar.gz"
      sha256 "8f94cb479bdad81c2e5bdff811165a2ff831d899abb51e8b348b4640cfdfaa9c"
    end
    on_intel do
      url "https://github.com/daviddwlee84/lazychezmoi/releases/download/v0.1.1/lazychezmoi_0.1.1_darwin_amd64.tar.gz"
      sha256 "91b4289b03f86f8bb8f424921ab70027c2409549bee6592f2143ed4eb37d5560"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/daviddwlee84/lazychezmoi/releases/download/v0.1.1/lazychezmoi_0.1.1_linux_arm64.tar.gz"
      sha256 "2da6ef6f8e871dba04c727124401465324c8e192ca3f353cf754ff7ba37048e5"
    end
    on_intel do
      url "https://github.com/daviddwlee84/lazychezmoi/releases/download/v0.1.1/lazychezmoi_0.1.1_linux_amd64.tar.gz"
      sha256 "e07836b43a7952cc71f66cb60d88b07c6b445b54d22e2f138571fcd69497a91a"
    end
  end

  def install
    bin.install "lazychezmoi"
    bash_completion.install "completions/lazychezmoi.bash" => "lazychezmoi"
    zsh_completion.install "completions/lazychezmoi.zsh" => "_lazychezmoi"
    fish_completion.install "completions/lazychezmoi.fish" if File.exist?("completions/lazychezmoi.fish")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lazychezmoi --version")
    assert_match "Usage:", shell_output("#{bin}/lazychezmoi --help")
  end
end
