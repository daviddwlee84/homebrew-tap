class Lazypueue < Formula
  desc "Terminal interface for Pueue task queues"
  homepage "https://github.com/daviddwlee84/lazypueue"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/daviddwlee84/lazypueue/releases/download/v0.1.2/lazypueue_0.1.2_darwin_arm64.tar.gz"
      sha256 "ee962c650202338cd2684a3b95c84271e268aef70659ed70bfc464eed47931c7"
    end
    on_intel do
      url "https://github.com/daviddwlee84/lazypueue/releases/download/v0.1.2/lazypueue_0.1.2_darwin_amd64.tar.gz"
      sha256 "2471a9688f23fab8f39a09b1b67e172701ec7469305a5aee4b1ced8144029289"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/daviddwlee84/lazypueue/releases/download/v0.1.2/lazypueue_0.1.2_linux_arm64.tar.gz"
      sha256 "4228d2ff5b05795d5b74495c270247c571f01e90af004eee5ce9d34b18e509e9"
    end
    on_intel do
      url "https://github.com/daviddwlee84/lazypueue/releases/download/v0.1.2/lazypueue_0.1.2_linux_amd64.tar.gz"
      sha256 "e7ea82e85d51b2c17be8747f43e19d5fafad32e0b5b3a1d31761f4156f7d0d45"
    end
  end

  def install
    bin.install "lazypueue"
    bash_completion.install "completions/lazypueue.bash" => "lazypueue"
    zsh_completion.install "completions/lazypueue.zsh" => "_lazypueue"
    fish_completion.install "completions/lazypueue.fish" if File.exist?("completions/lazypueue.fish")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lazypueue --version")
    assert_match "Usage:", shell_output("#{bin}/lazypueue --help")
  end
end
