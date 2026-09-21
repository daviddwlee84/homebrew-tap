class Lazychezmoi < Formula
  desc "Terminal interface for chezmoi dotfiles"
  homepage "https://github.com/daviddwlee84/lazychezmoi"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/daviddwlee84/lazychezmoi/releases/download/v0.1.0/lazychezmoi_0.1.0_darwin_arm64.tar.gz"
      sha256 "f32dd45307fbfee123911f57a60d4e37316ed2bcc112faeba646ee1d5e4e54d9"
    end
    on_intel do
      url "https://github.com/daviddwlee84/lazychezmoi/releases/download/v0.1.0/lazychezmoi_0.1.0_darwin_amd64.tar.gz"
      sha256 "504ce1754f872dbe2c8a9325b591f6b947313abe3fda1dc195d4cf0810d08106"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/daviddwlee84/lazychezmoi/releases/download/v0.1.0/lazychezmoi_0.1.0_linux_arm64.tar.gz"
      sha256 "7dc0cb6575aa3b19b960e23c61019c1c0e97f71897090055a7245f734458d5a3"
    end
    on_intel do
      url "https://github.com/daviddwlee84/lazychezmoi/releases/download/v0.1.0/lazychezmoi_0.1.0_linux_amd64.tar.gz"
      sha256 "b0c2afc889f5acfafd74b6e6030f63abbc5508c08dddbe296a9e630927e8bab2"
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
