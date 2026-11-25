class Lazylongarm < Formula
  desc "Set up and operate a Longarm hub and workers over SSH"
  homepage "https://github.com/daviddwlee84/lazylongarm"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/daviddwlee84/lazylongarm/releases/download/v0.5.2/lazylongarm_0.5.2_darwin_arm64.tar.gz"
      sha256 "d73c4ef41301751af08f4f675ba73e606c325733cb9c93e5c56f4627711250ba"
    end
    on_intel do
      url "https://github.com/daviddwlee84/lazylongarm/releases/download/v0.5.2/lazylongarm_0.5.2_darwin_amd64.tar.gz"
      sha256 "e7c555f1195059b4010a6285e46e697cdb4b7204f7c723cc9e7b0463760adfbe"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/daviddwlee84/lazylongarm/releases/download/v0.5.2/lazylongarm_0.5.2_linux_arm64.tar.gz"
      sha256 "a9f068c78a3848042500dab436fb0efe815478564e0cfb5baae0bb05d5a10805"
    end
    on_intel do
      url "https://github.com/daviddwlee84/lazylongarm/releases/download/v0.5.2/lazylongarm_0.5.2_linux_amd64.tar.gz"
      sha256 "033464fb5483ace94c9658c51610930c253304bc3ba72a77c4570a7682cab046"
    end
  end

  def install
    bin.install "lazylongarm"
    bash_completion.install "completions/lazylongarm.bash" => "lazylongarm"
    zsh_completion.install "completions/lazylongarm.zsh" => "_lazylongarm"
    fish_completion.install "completions/lazylongarm.fish" if File.exist?("completions/lazylongarm.fish")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lazylongarm --version")
    assert_match "Usage:", shell_output("#{bin}/lazylongarm --help")
  end
end
