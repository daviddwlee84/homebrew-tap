class Lazypueue < Formula
  desc "Terminal interface for Pueue task queues"
  homepage "https://github.com/daviddwlee84/lazypueue"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/daviddwlee84/lazypueue/releases/download/v0.1.0/lazypueue_0.1.0_darwin_arm64.tar.gz"
      sha256 "88e1620a68a9c8acf26ecd453360f4332b826e1ded8b32d5476f2c3691acf989"
    end
    on_intel do
      url "https://github.com/daviddwlee84/lazypueue/releases/download/v0.1.0/lazypueue_0.1.0_darwin_amd64.tar.gz"
      sha256 "5e08161a8178ca2c075f32fd1893a5ff4f2a179e1bc556cf8a967dd94c29e97b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/daviddwlee84/lazypueue/releases/download/v0.1.0/lazypueue_0.1.0_linux_arm64.tar.gz"
      sha256 "4397795710bbf3d8754dfc1ec9dcd2351222cb5e534eaa921de78dec4326b9ba"
    end
    on_intel do
      url "https://github.com/daviddwlee84/lazypueue/releases/download/v0.1.0/lazypueue_0.1.0_linux_amd64.tar.gz"
      sha256 "f57ce08f24cc2c3f9835fa3290e3537371fe9ff12cde8c1ebc5df9dc4255d1de"
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
