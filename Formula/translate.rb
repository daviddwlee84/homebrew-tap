class Translate < Formula
  desc "Fast terminal translation tool (CLI + TUI)"
  homepage "https://github.com/daviddwlee84/translate"
  url "https://github.com/daviddwlee84/translate/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "84fe668cceca6866bb0dcef981289dc44737a77bffa8e920dac4961cad5ead70"
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
