class Lazymlflow < Formula
  desc "Terminal interface for MLflow experiments"
  homepage "https://github.com/daviddwlee84/lazymlflow"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/daviddwlee84/lazymlflow/releases/download/v0.3.1/lazymlflow_0.3.1_darwin_arm64.tar.gz"
      sha256 "5def4f69b838d3002fd8fb471361f5282f520aa64201694f055b85e5820da07d"
    end
    on_intel do
      url "https://github.com/daviddwlee84/lazymlflow/releases/download/v0.3.1/lazymlflow_0.3.1_darwin_amd64.tar.gz"
      sha256 "f3d0898eda7ed51e2b2a965c152b743ca1c9fed5a0d5ef222e166058074e6fce"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/daviddwlee84/lazymlflow/releases/download/v0.3.1/lazymlflow_0.3.1_linux_arm64.tar.gz"
      sha256 "810fb26c0cfef6cd0256c47f32803510f9416baec0002df75d3e211e552523c5"
    end
    on_intel do
      url "https://github.com/daviddwlee84/lazymlflow/releases/download/v0.3.1/lazymlflow_0.3.1_linux_amd64.tar.gz"
      sha256 "775d95ce723a974db7ab868223250d34e9a8b49c1ec6513b0f37ae5c18f4808f"
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
