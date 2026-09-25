class Lazypkg < Formula
  desc "Software inventory and reviewed package-manager operations"
  homepage "https://github.com/daviddwlee84/lazypkg"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/daviddwlee84/lazypkg/releases/download/v0.1.4/lazypkg_0.1.4_darwin_arm64.tar.gz"
      sha256 "e4b4ced7235987e138f210b4d58d87c38b5b6e478e349c63244d1d1f8a4d16d3"
    end
    on_intel do
      url "https://github.com/daviddwlee84/lazypkg/releases/download/v0.1.4/lazypkg_0.1.4_darwin_amd64.tar.gz"
      sha256 "efed634908522f01ba392fdde7936037c3754f758c9e3e5ea7147a2c3ecd2425"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/daviddwlee84/lazypkg/releases/download/v0.1.4/lazypkg_0.1.4_linux_arm64.tar.gz"
      sha256 "b70902b9cbc6a25d08434cb3546fb0381cc6622de5772f2e0fc98e7015c0dc65"
    end
    on_intel do
      url "https://github.com/daviddwlee84/lazypkg/releases/download/v0.1.4/lazypkg_0.1.4_linux_amd64.tar.gz"
      sha256 "a6efbe9a415856bfd42d48b08a17d409955106e76289e073d28ea668c9e82590"
    end
  end

  def install
    bin.install "lazypkg"
    bash_completion.install "completions/lazypkg.bash" => "lazypkg"
    zsh_completion.install "completions/lazypkg.zsh" => "_lazypkg"
    fish_completion.install "completions/lazypkg.fish" if File.exist?("completions/lazypkg.fish")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lazypkg --version")
    assert_match "Usage:", shell_output("#{bin}/lazypkg --help")
  end
end
