class Lazyset < Formula
  desc "TUI catalog and workspace with retained terminal sessions"
  homepage "https://github.com/daviddwlee84/lazyset"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/daviddwlee84/lazyset/releases/download/v0.1.2/lazyset_0.1.2_darwin_arm64.tar.gz"
      sha256 "e2296d24c2be26898f37009184262a6ad90f29feaa98656460d7d7d150e0cdde"
    end
    on_intel do
      url "https://github.com/daviddwlee84/lazyset/releases/download/v0.1.2/lazyset_0.1.2_darwin_amd64.tar.gz"
      sha256 "058c305a43bc6bec2696c4bf61df92bcbae9678580dd22b8c96b20fbf810ce5e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/daviddwlee84/lazyset/releases/download/v0.1.2/lazyset_0.1.2_linux_arm64.tar.gz"
      sha256 "1e7e3c7c8d4419decaadc0e1b944b3dd9e73c46588a9e26c76b41e1729098a5a"
    end
    on_intel do
      url "https://github.com/daviddwlee84/lazyset/releases/download/v0.1.2/lazyset_0.1.2_linux_amd64.tar.gz"
      sha256 "8d0a542c1d009d30604fca7d65ab38bdc681c0388f423b87d31e5c5119b675d4"
    end
  end

  def install
    bin.install "lazyset"
    bash_completion.install "completions/lazyset.bash" => "lazyset"
    zsh_completion.install "completions/lazyset.zsh" => "_lazyset"
    fish_completion.install "completions/lazyset.fish" if File.exist?("completions/lazyset.fish")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lazyset --version")
    assert_match "Usage:", shell_output("#{bin}/lazyset --help")
  end
end
