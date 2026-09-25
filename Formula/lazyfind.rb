class Lazyfind < Formula
  desc "File and text search workspace for local and SSH roots"
  homepage "https://github.com/daviddwlee84/lazyfind"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/daviddwlee84/lazyfind/releases/download/v0.1.3/lazyfind_0.1.3_darwin_arm64.tar.gz"
      sha256 "be9d4badea39f4bd52ad972e8d9d9844b318e53e54f08ee36a2126ad0c7016bc"
    end
    on_intel do
      url "https://github.com/daviddwlee84/lazyfind/releases/download/v0.1.3/lazyfind_0.1.3_darwin_amd64.tar.gz"
      sha256 "cd6cf0e668fa47fb3e6c3db85f73b7e69bbed4dc94500a2bec93fe438796537a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/daviddwlee84/lazyfind/releases/download/v0.1.3/lazyfind_0.1.3_linux_arm64.tar.gz"
      sha256 "7767dccbd7bffaba5acef70f08b5d972d0d0315c47cabb980a8f47813bc9d12e"
    end
    on_intel do
      url "https://github.com/daviddwlee84/lazyfind/releases/download/v0.1.3/lazyfind_0.1.3_linux_amd64.tar.gz"
      sha256 "7c9af8b2fd1a0125f6945fd0786ae7e523ca2d473f3014f3d5264c7b9beaaeea"
    end
  end

  def install
    bin.install "lazyfind"
    bash_completion.install "completions/lazyfind.bash" => "lazyfind"
    zsh_completion.install "completions/lazyfind.zsh" => "_lazyfind"
    fish_completion.install "completions/lazyfind.fish" if File.exist?("completions/lazyfind.fish")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lazyfind --version")
    assert_match "Usage:", shell_output("#{bin}/lazyfind --help")
  end
end
