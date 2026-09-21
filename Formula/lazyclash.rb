class Lazyclash < Formula
  desc "Terminal interface for Mihomo proxy cores"
  homepage "https://github.com/daviddwlee84/lazyclash"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/daviddwlee84/lazyclash/releases/download/v0.1.8/lazyclash_0.1.8_darwin_arm64.tar.gz"
      sha256 "31cb7854554d4d376a7666512c03d15ad221f28940f7f1f5037a9b061f0648cd"
    end
    on_intel do
      url "https://github.com/daviddwlee84/lazyclash/releases/download/v0.1.8/lazyclash_0.1.8_darwin_amd64.tar.gz"
      sha256 "834603d84cb6dcd82cfa6c7568617772c681a187ad37904710eaace60835ef0b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/daviddwlee84/lazyclash/releases/download/v0.1.8/lazyclash_0.1.8_linux_arm64.tar.gz"
      sha256 "6ef37613cf1dbf985835a24d127556c3487052a3bff6a03f45af233f6b483290"
    end
    on_intel do
      url "https://github.com/daviddwlee84/lazyclash/releases/download/v0.1.8/lazyclash_0.1.8_linux_amd64.tar.gz"
      sha256 "d42b79f6aa9d4509ac65f2883541b27d0feac5b2c8c21ff009c23cb5f62585bf"
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
