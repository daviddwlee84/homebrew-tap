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
      url "https://github.com/daviddwlee84/translate/releases/download/v0.7.0/translate_0.7.0_darwin_arm64.tar.gz"
      sha256 "1561e5364bb5df767c0ebf57f9765c35815e37cfa18b803a03015af266f61678"
    end
    on_intel do
      url "https://github.com/daviddwlee84/translate/releases/download/v0.7.0/translate_0.7.0_darwin_amd64.tar.gz"
      sha256 "b484d00a8898946765307d9ac7665e99b573a520908a2e3045c58d8e791adb7d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/daviddwlee84/translate/releases/download/v0.7.0/translate_0.7.0_linux_arm64.tar.gz"
      sha256 "7b6f3f6e9392c5276e91b6cf54059a70bb7ec5f8a680cdfdd6e7fbe327d20777"
    end
    on_intel do
      url "https://github.com/daviddwlee84/translate/releases/download/v0.7.0/translate_0.7.0_linux_amd64.tar.gz"
      sha256 "f5fa5bdc5e9cf758b1c9874ddc947f322b67118e731a63bf77adeb5a5aab8309"
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
