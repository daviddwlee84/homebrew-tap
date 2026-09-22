class Lazychezmoi < Formula
  desc "Terminal interface for chezmoi dotfiles"
  homepage "https://github.com/daviddwlee84/lazychezmoi"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/daviddwlee84/lazychezmoi/releases/download/v0.1.2/lazychezmoi_0.1.2_darwin_arm64.tar.gz"
      sha256 "40602980424417e3ff353a811ead012916e7174a179071d7d767b3508cffdbda"
    end
    on_intel do
      url "https://github.com/daviddwlee84/lazychezmoi/releases/download/v0.1.2/lazychezmoi_0.1.2_darwin_amd64.tar.gz"
      sha256 "8507a4aafa4c71a6dc3f7d504a4988f3076a460908932a1f479c6015f1725f5b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/daviddwlee84/lazychezmoi/releases/download/v0.1.2/lazychezmoi_0.1.2_linux_arm64.tar.gz"
      sha256 "37f5f8fc113da5406e1cb4fd31a1b94dd0f376fc59722ae45bb45cbfcbf0541d"
    end
    on_intel do
      url "https://github.com/daviddwlee84/lazychezmoi/releases/download/v0.1.2/lazychezmoi_0.1.2_linux_amd64.tar.gz"
      sha256 "445af34d627cc5cfc8a7aef2efc91e92e55c2aff64516ac2cea059601c047725"
    end
  end

  def install
    bin.install "lazychezmoi"
    bash_completion.install "completions/lazychezmoi.bash" => "lazychezmoi"
    zsh_completion.install "completions/lazychezmoi.zsh" => "_lazychezmoi"
    fish_completion.install "completions/lazychezmoi.fish" if File.exist?("completions/lazychezmoi.fish")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lazychezmoi --version")
    assert_match "Usage:", shell_output("#{bin}/lazychezmoi --help")
  end
end
