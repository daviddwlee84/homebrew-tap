class Translate < Formula
  desc "Terminal translation tool with CLI and TUI"
  homepage "https://github.com/daviddwlee84/translate"
  license "MIT"

  head do
    url "https://github.com/daviddwlee84/translate.git", branch: "main"
    depends_on "go" => :build
  end

  on_macos do
    on_arm do
      url "https://github.com/daviddwlee84/translate/releases/download/v0.6.2/translate_0.6.2_darwin_arm64.tar.gz"
      sha256 "b9c1190d9c471c8110e37788d67f3c0df64c9c424099dc5fcf2205c13e7b4036"
    end
    on_intel do
      url "https://github.com/daviddwlee84/translate/releases/download/v0.6.2/translate_0.6.2_darwin_amd64.tar.gz"
      sha256 "50f1e456e3d4e23b61b42ca48f026e1ac12529802b11dbcdb591fd5eaf08d3a1"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/daviddwlee84/translate/releases/download/v0.6.2/translate_0.6.2_linux_arm64.tar.gz"
      sha256 "e34d38c1cf2ec1e61f35ecc330586c4cfaf21d98ecb5547e2cdb9b4ec61c4933"
    end
    on_intel do
      url "https://github.com/daviddwlee84/translate/releases/download/v0.6.2/translate_0.6.2_linux_amd64.tar.gz"
      sha256 "8437164fe2ce4e2fd91e85b876ed770c3ced45b55196f5a53ad687ecd26f80a6"
    end
  end

  def install
    if build.head?
      system "go", "build", *std_go_args(ldflags: "-s -w")
      generate_completions_from_executable(bin/"translate", shell_parameter_format: :cobra)
    else
      bin.install "translate"
      bash_completion.install "completions/translate.bash" => "translate"
      zsh_completion.install "completions/translate.zsh" => "_translate"
      fish_completion.install "completions/translate.fish" if File.exist?("completions/translate.fish")
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/translate --version")
    assert_match "Usage:", shell_output("#{bin}/translate --help")
  end
end
