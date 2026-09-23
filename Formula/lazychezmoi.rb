class Lazychezmoi < Formula
  desc "Terminal interface for chezmoi dotfiles"
  homepage "https://github.com/daviddwlee84/lazychezmoi"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/daviddwlee84/lazychezmoi/releases/download/v0.2.0/lazychezmoi_0.2.0_darwin_arm64.tar.gz"
      sha256 "db461b522bff54108640043f60c6f0c537aec50a089416c1b11d250572a9962a"
    end
    on_intel do
      url "https://github.com/daviddwlee84/lazychezmoi/releases/download/v0.2.0/lazychezmoi_0.2.0_darwin_amd64.tar.gz"
      sha256 "a02b771f502e1f37a88b5ae46e1e13149a75c511d2d05a6a884d5de939a24c59"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/daviddwlee84/lazychezmoi/releases/download/v0.2.0/lazychezmoi_0.2.0_linux_arm64.tar.gz"
      sha256 "2c702911d5f7c44e782dc06c3db30cfe05745df1236479afdf841183970aa52d"
    end
    on_intel do
      url "https://github.com/daviddwlee84/lazychezmoi/releases/download/v0.2.0/lazychezmoi_0.2.0_linux_amd64.tar.gz"
      sha256 "8c4456a8b1ba5af3e10d31fb12efed4183a5fe70812c7e802eb1521335b99e77"
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
