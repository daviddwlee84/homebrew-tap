class Lazyclash < Formula
  desc "Terminal interface for Mihomo proxy cores"
  homepage "https://github.com/daviddwlee84/lazyclash"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/daviddwlee84/lazyclash/releases/download/v0.1.9/lazyclash_0.1.9_darwin_arm64.tar.gz"
      sha256 "dbb697e4ea5eea2156241934afe0200b5a666a37478c0f0b9b6ed3b688476a6f"
    end
    on_intel do
      url "https://github.com/daviddwlee84/lazyclash/releases/download/v0.1.9/lazyclash_0.1.9_darwin_amd64.tar.gz"
      sha256 "db7704835899a9b35b3512729ede83c0314af2058c71ba6e97eb20a13f3f6a69"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/daviddwlee84/lazyclash/releases/download/v0.1.9/lazyclash_0.1.9_linux_arm64.tar.gz"
      sha256 "c5a923d0e7c7ea8e7d0c2bdc375c1b9b24293e78d72efad1fefb72f3da6b3e1c"
    end
    on_intel do
      url "https://github.com/daviddwlee84/lazyclash/releases/download/v0.1.9/lazyclash_0.1.9_linux_amd64.tar.gz"
      sha256 "c3db6ea06c54b0eeaf22546b4d6a825f787bfb159944dadca5340e025b080138"
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
