class Lazypg < Formula
  desc "PostgreSQL development workflow with explicit environments and schema plans"
  homepage "https://github.com/daviddwlee84/lazypg"
  license "MIT"
  revision 1

  on_macos do
    on_arm do
      url "https://github.com/daviddwlee84/lazypg/releases/download/v0.1.2/lazypg_0.1.2_darwin_arm64.tar.gz"
      sha256 "58d00a8459379bccc0af19a8fb082ca49f9f083617966c94f20f134de075bd77"
    end
    on_intel do
      url "https://github.com/daviddwlee84/lazypg/releases/download/v0.1.2/lazypg_0.1.2_darwin_amd64.tar.gz"
      sha256 "e8536a52b934cbc9651263f37f4a5c9ac1418a617954208679420f547cbd2cee"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/daviddwlee84/lazypg/releases/download/v0.1.2/lazypg_0.1.2_linux_arm64.tar.gz"
      sha256 "55ff079f1b46060153c21cd8b935cfcc3433ffcb744f20d08721ebe0b467aa20"
    end
    on_intel do
      url "https://github.com/daviddwlee84/lazypg/releases/download/v0.1.2/lazypg_0.1.2_linux_amd64.tar.gz"
      sha256 "9d00bcd42b020ffcb08885ead3bd1a94350c00b2d76bec3ce1415da8cf7280ff"
    end
  end

  def install
    bin.install "lazypg"
    prefix.install "THIRD_PARTY_NOTICES.txt"
    bash_completion.install "completions/lazypg.bash" => "lazypg"
    zsh_completion.install "completions/lazypg.zsh" => "_lazypg"
    fish_completion.install "completions/lazypg.fish" if File.exist?("completions/lazypg.fish")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lazypg --version")
    assert_match "Usage:", shell_output("#{bin}/lazypg --help")
    assert_path_exists prefix/"THIRD_PARTY_NOTICES.txt"
  end
end
