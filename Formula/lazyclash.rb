class Lazyclash < Formula
  desc "Terminal interface for Mihomo proxy cores"
  homepage "https://github.com/daviddwlee84/lazyclash"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/daviddwlee84/lazyclash/releases/download/v0.1.11/lazyclash_0.1.11_darwin_arm64.tar.gz"
      sha256 "d7318257a642c386eb04916eca9b5609c2e8bf3915cbfdf7f05e2266a00992a4"
    end
    on_intel do
      url "https://github.com/daviddwlee84/lazyclash/releases/download/v0.1.11/lazyclash_0.1.11_darwin_amd64.tar.gz"
      sha256 "b73ffd6bbfa4155f29d1a20e46d08788466fd1ac297b582096ab4893acd9cca6"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/daviddwlee84/lazyclash/releases/download/v0.1.11/lazyclash_0.1.11_linux_arm64.tar.gz"
      sha256 "ace18deb3b734c5e1bf26241dd76264dc9b58eb584b56b78e0bbb71771561e57"
    end
    on_intel do
      url "https://github.com/daviddwlee84/lazyclash/releases/download/v0.1.11/lazyclash_0.1.11_linux_amd64.tar.gz"
      sha256 "47a0f39b74bd836b28c6c26e0f794c8c9142b2f5bbce515323eaeefa35356fbc"
    end
  end

  def install
    bin.install "lazyclash"
    bash_completion.install "completions/lazyclash.bash" => "lazyclash"
    zsh_completion.install "completions/lazyclash.zsh" => "_lazyclash"
    fish_completion.install "completions/lazyclash.fish" if File.exist?("completions/lazyclash.fish")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lazyclash --version")
    assert_match "Usage:", shell_output("#{bin}/lazyclash --help")
  end
end
