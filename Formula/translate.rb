class Translate < Formula
  desc "Fast terminal translation tool (CLI + TUI)"
  homepage "https://github.com/daviddwlee84/translate"
  version "0.6.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/daviddwlee84/translate/releases/download/v0.6.0/translate_0.6.0_darwin_arm64.tar.gz"
      sha256 "26b28a1889f66892f2f23992c47ce4dbde4d16056b3dd5c40ba64da60f995dd0"
    end
    on_intel do
      url "https://github.com/daviddwlee84/translate/releases/download/v0.6.0/translate_0.6.0_darwin_amd64.tar.gz"
      sha256 "55c9fac8f9a231de7768fde5ad5517df49e8b2415f8d8c2308370e7f535aec13"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/daviddwlee84/translate/releases/download/v0.6.0/translate_0.6.0_linux_arm64.tar.gz"
      sha256 "f75ed754549f1020b74a6608803b9b96733a7538fc39be7b21f0399cbde05eae"
    end
    on_intel do
      url "https://github.com/daviddwlee84/translate/releases/download/v0.6.0/translate_0.6.0_linux_amd64.tar.gz"
      sha256 "05384485852c244a3a6c537b939dccc385811dc0098ea5427b7d4b2cfb7e912c"
    end
  end

  head do
    url "https://github.com/daviddwlee84/translate.git", branch: "main"
    depends_on "go" => :build
  end

  def install
    if build.head?
      system "go", "build", *std_go_args(ldflags: "-s -w")
    else
      bin.install "translate"
    end

    # shell_parameter_format: :cobra runs `translate completion <shell>`.
    # Without this the tap ships no completions at all and users depend on
    # their own dotfiles to generate them.
    generate_completions_from_executable(bin/"translate", shell_parameter_format: :cobra)
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/translate --version")
    assert_match "en", shell_output("#{bin}/translate lang resolve english --json")
  end
end
