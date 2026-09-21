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
      url "https://github.com/daviddwlee84/translate/releases/download/v0.6.1/translate_0.6.1_darwin_arm64.tar.gz"
      sha256 "6cc0524011c4936f6066f85f893a2beb73ee462477884b0869bbb36c4ca5c75e"
    end
    on_intel do
      url "https://github.com/daviddwlee84/translate/releases/download/v0.6.1/translate_0.6.1_darwin_amd64.tar.gz"
      sha256 "a30b2976a028fb1b58ef00cced4d25bd8c16a5b52faf4c8142c4131f7085c9ca"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/daviddwlee84/translate/releases/download/v0.6.1/translate_0.6.1_linux_arm64.tar.gz"
      sha256 "41c38ea96bca52b460cc6b9a63f534752981225d64cd950182ac800db9f80736"
    end
    on_intel do
      url "https://github.com/daviddwlee84/translate/releases/download/v0.6.1/translate_0.6.1_linux_amd64.tar.gz"
      sha256 "c1ebff59c82fccd5df1b9299796119618529fd4d8c5e08fb3e4498fad255f966"
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
