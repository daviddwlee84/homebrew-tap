class Translate < Formula
  desc "Fast terminal translation tool (CLI + TUI)"
  homepage "https://github.com/daviddwlee84/translate"
  url "https://github.com/daviddwlee84/translate/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "87bd41d0b76125daf71f3179fd9d937b9c8ee5d01b18e2434fdd2967554d6874"
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
