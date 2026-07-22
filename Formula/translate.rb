class Translate < Formula
  desc "Fast terminal translation tool (CLI + TUI)"
  homepage "https://github.com/daviddwlee84/translate"
  url "https://github.com/daviddwlee84/translate/archive/refs/tags/v0.5.1.tar.gz"
  sha256 "39dd09be481f1a01f4e7b757542b4a8fea1c85a850d8c526aa8e25e6fc90303b"
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
