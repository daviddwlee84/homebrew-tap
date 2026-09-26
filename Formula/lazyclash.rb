class Lazyclash < Formula
  desc "Terminal interface for Mihomo proxy cores"
  homepage "https://github.com/daviddwlee84/lazyclash"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/daviddwlee84/lazyclash/releases/download/v0.2.1/lazyclash_0.2.1_darwin_arm64.tar.gz"
      sha256 "ac632bb97e5146dc9351a76a871060b9b4692011df796adb2ae96ac438534fc4"
    end
    on_intel do
      url "https://github.com/daviddwlee84/lazyclash/releases/download/v0.2.1/lazyclash_0.2.1_darwin_amd64.tar.gz"
      sha256 "553c4984714fb70bbb35851b6843f454f2f9e123a9f089e411a88190b02636e3"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/daviddwlee84/lazyclash/releases/download/v0.2.1/lazyclash_0.2.1_linux_arm64.tar.gz"
      sha256 "83aa746fed686745197c516fe75f1bff3bc5e69e036ba0ab3a7121db61bd88bd"
    end
    on_intel do
      url "https://github.com/daviddwlee84/lazyclash/releases/download/v0.2.1/lazyclash_0.2.1_linux_amd64.tar.gz"
      sha256 "1db4ea7ee8286fc0e177f0b1069184df409f2678389e81bdc0ad17dc9cf52443"
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
