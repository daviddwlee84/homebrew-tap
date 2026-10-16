class Lazypkg < Formula
  desc "Software inventory and reviewed package-manager operations"
  homepage "https://github.com/daviddwlee84/lazypkg"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/daviddwlee84/lazypkg/releases/download/v0.2.1/lazypkg_0.2.1_darwin_arm64.tar.gz"
      sha256 "a859d610f045193c2ff6dcb30713340c5ba29166dd79b4e9e3465b8fb3ba2cc2"
    end
    on_intel do
      url "https://github.com/daviddwlee84/lazypkg/releases/download/v0.2.1/lazypkg_0.2.1_darwin_amd64.tar.gz"
      sha256 "947fe9a15d83cb46a265a14766749dc8ccb3e8278b781e2627390ad452df46c6"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/daviddwlee84/lazypkg/releases/download/v0.2.1/lazypkg_0.2.1_linux_arm64.tar.gz"
      sha256 "d90fc73ad7cfc5443a86a38d76fac9bdc331daf55d9316719ea66ce72c448d7f"
    end
    on_intel do
      url "https://github.com/daviddwlee84/lazypkg/releases/download/v0.2.1/lazypkg_0.2.1_linux_amd64.tar.gz"
      sha256 "6364f56a0e2bf1af0d7c5e2f46b30ef5790ed0a55da1c70174c73e2b87dfac46"
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
