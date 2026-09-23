class Lazyclash < Formula
  desc "Terminal interface for Mihomo proxy cores"
  homepage "https://github.com/daviddwlee84/lazyclash"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/daviddwlee84/lazyclash/releases/download/v0.2.0/lazyclash_0.2.0_darwin_arm64.tar.gz"
      sha256 "2a8752471067b085871037e1159d60ba103ebf786bbb744bca15a1905cb7581e"
    end
    on_intel do
      url "https://github.com/daviddwlee84/lazyclash/releases/download/v0.2.0/lazyclash_0.2.0_darwin_amd64.tar.gz"
      sha256 "1247c0e3918b62bd9a6402c4af30491fcf7827704d8243156fca3840243dfd2b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/daviddwlee84/lazyclash/releases/download/v0.2.0/lazyclash_0.2.0_linux_arm64.tar.gz"
      sha256 "4b28903a29977f031b336aef24187a3679a394cfc306f016ec2c461f033b0cbd"
    end
    on_intel do
      url "https://github.com/daviddwlee84/lazyclash/releases/download/v0.2.0/lazyclash_0.2.0_linux_amd64.tar.gz"
      sha256 "5381641dbfa2983a280310f6fb08450eb6148b4a3575f5ffd48db094adf1c687"
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
