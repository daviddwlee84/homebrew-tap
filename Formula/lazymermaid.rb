class Lazymermaid < Formula
  desc "Repository Mermaid workbench with local editing and rendering"
  homepage "https://github.com/daviddwlee84/lazymermaid"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/daviddwlee84/lazymermaid/releases/download/v0.1.1/lazymermaid_0.1.1_darwin_arm64.tar.gz"
      sha256 "e2efe5ad4b7669dbfb11c16b87d985d1d2dab2cea79c07b51c8cdb7a97da6e79"
    end
    on_intel do
      url "https://github.com/daviddwlee84/lazymermaid/releases/download/v0.1.1/lazymermaid_0.1.1_darwin_amd64.tar.gz"
      sha256 "526e1e0480483a6cf570e2c7bda31ef8a35a0758d3bed97cc2e24c7e602ef593"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/daviddwlee84/lazymermaid/releases/download/v0.1.1/lazymermaid_0.1.1_linux_arm64.tar.gz"
      sha256 "ef4f7ba61182fa867ede6de6b4b04eafa9b3ca4310e62ff9bef8a1df513ee7ae"
    end
    on_intel do
      url "https://github.com/daviddwlee84/lazymermaid/releases/download/v0.1.1/lazymermaid_0.1.1_linux_amd64.tar.gz"
      sha256 "d88a0718205c1875dca22de354e968ca96418e6caf0e10ddc5d8e7f82cad694a"
    end
  end

  def install
    bin.install "lazymermaid"
    bash_completion.install "completions/lazymermaid.bash" => "lazymermaid"
    zsh_completion.install "completions/lazymermaid.zsh" => "_lazymermaid"
    fish_completion.install "completions/lazymermaid.fish" if File.exist?("completions/lazymermaid.fish")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lazymermaid --version")
    assert_match "Usage:", shell_output("#{bin}/lazymermaid --help")
  end
end
