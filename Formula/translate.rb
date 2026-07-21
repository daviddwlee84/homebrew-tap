class Translate < Formula
  desc "Fast terminal translation tool (CLI + TUI)"
  homepage "https://github.com/daviddwlee84/translate"
  url "https://github.com/daviddwlee84/translate/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "9e1d5ac23d1bee73e94f27228574dc30033d0d4f31dfd0fa4a4286b2a36f07a6"
  license "MIT"
  head "https://github.com/daviddwlee84/translate.git", branch: "main"

  depends_on "go" => :build

  def install
    # The app derives its version from debug.ReadBuildInfo, which reports
    # "(devel)" when built from a source tarball. Inject the tag via -X instead.
    # Homebrew's #{version} strips the leading "v", so re-add it.
    ldflags = "-s -w -X github.com/daviddwlee84/translate/cmd.version=v#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/translate --version")
  end
end
