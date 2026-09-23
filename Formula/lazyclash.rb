class Lazyclash < Formula
  desc "Terminal interface for Mihomo proxy cores"
  homepage "https://github.com/daviddwlee84/lazyclash"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/daviddwlee84/lazyclash/releases/download/v0.1.12/lazyclash_0.1.12_darwin_arm64.tar.gz"
      sha256 "a39b686161a2f035f0c82f72a8760bf123425685cf6f440cff1eb828ec35a03d"
    end
    on_intel do
      url "https://github.com/daviddwlee84/lazyclash/releases/download/v0.1.12/lazyclash_0.1.12_darwin_amd64.tar.gz"
      sha256 "df2e9b2a4875137c392e0d8d5d71b9594b4ef3146db18e90e2c75d176942e29b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/daviddwlee84/lazyclash/releases/download/v0.1.12/lazyclash_0.1.12_linux_arm64.tar.gz"
      sha256 "403f04bdfadbb81c77b2225ee57a9d0f1dff67967ca7098c1264cc8d61af19d1"
    end
    on_intel do
      url "https://github.com/daviddwlee84/lazyclash/releases/download/v0.1.12/lazyclash_0.1.12_linux_amd64.tar.gz"
      sha256 "7a19ab72e88a24ccc71b303f9beb449d986d1b0b7fbcbe5b6fdf529b8d6b6dc1"
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
