class Lazyclash < Formula
  desc "Terminal interface for Mihomo proxy cores"
  homepage "https://github.com/daviddwlee84/lazyclash"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/daviddwlee84/lazyclash/releases/download/v0.1.10/lazyclash_0.1.10_darwin_arm64.tar.gz"
      sha256 "a0967a1622fa3cdc8ac5b5b8c0b7e550bdd046e7665e3c0c3e1f6e9f63317ed7"
    end
    on_intel do
      url "https://github.com/daviddwlee84/lazyclash/releases/download/v0.1.10/lazyclash_0.1.10_darwin_amd64.tar.gz"
      sha256 "04d3d0debddbf1ca43155858caeb13fb04b7d5a80df41a15015a804fa5446c35"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/daviddwlee84/lazyclash/releases/download/v0.1.10/lazyclash_0.1.10_linux_arm64.tar.gz"
      sha256 "e32bc73ad32bf7765767a539b72a39c7268aef97195588b2820b397e4d5908c7"
    end
    on_intel do
      url "https://github.com/daviddwlee84/lazyclash/releases/download/v0.1.10/lazyclash_0.1.10_linux_amd64.tar.gz"
      sha256 "d39b763eda9565b02013894ce0af8212b2b09b973156f9cbcf784d96783d2e64"
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
