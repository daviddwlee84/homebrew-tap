class Lazymlflow < Formula
  desc "Terminal interface for MLflow experiments"
  homepage "https://github.com/daviddwlee84/lazymlflow"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/daviddwlee84/lazymlflow/releases/download/v0.2.0/lazymlflow_0.2.0_darwin_arm64.tar.gz"
      sha256 "a435acbd216e934917994b43f3817529464888e56cf45e6711accb68069ba8aa"
    end
    on_intel do
      url "https://github.com/daviddwlee84/lazymlflow/releases/download/v0.2.0/lazymlflow_0.2.0_darwin_amd64.tar.gz"
      sha256 "84975e4b477eb44377430e8054fafe1787a1fba01d3a7d59d4a85dbbdc60f0b2"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/daviddwlee84/lazymlflow/releases/download/v0.2.0/lazymlflow_0.2.0_linux_arm64.tar.gz"
      sha256 "8c44267990228afa0c7774c0e2eaaeef012df838c4a0652ba09b6c3b8ad34057"
    end
    on_intel do
      url "https://github.com/daviddwlee84/lazymlflow/releases/download/v0.2.0/lazymlflow_0.2.0_linux_amd64.tar.gz"
      sha256 "dafa64fc93b224e9b89aab4186a4e08aa9cfb1bebe6acb9b5a53dab661833f81"
    end
  end

  def install
    bin.install "lazymlflow"
    bash_completion.install "completions/lazymlflow.bash" => "lazymlflow"
    zsh_completion.install "completions/lazymlflow.zsh" => "_lazymlflow"
    fish_completion.install "completions/lazymlflow.fish" if File.exist?("completions/lazymlflow.fish")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lazymlflow --version")
    assert_match "Usage:", shell_output("#{bin}/lazymlflow --help")
  end
end
