class DevCli < Formula
  desc "Task and worktree command center for multi-repository development"
  homepage "https://github.com/daviddwlee84/dev-cli"
  license "MIT"

  head do
    url "https://github.com/daviddwlee84/dev-cli.git", branch: "main"
    depends_on "go" => :build
  end

  on_macos do
    on_arm do
      url "https://github.com/daviddwlee84/dev-cli/releases/download/v0.2.41/dev-cli_v0.2.41_darwin_arm64.tar.gz"
      sha256 "41b5742c01bdc530e534d2d8564793bc4fbf3615e3614ef89224da9ef0882d65"
    end
    on_intel do
      url "https://github.com/daviddwlee84/dev-cli/releases/download/v0.2.41/dev-cli_v0.2.41_darwin_amd64.tar.gz"
      sha256 "dcdccb4537a8b602c9aeac31849fb369efa42d4b369ff07c92b57612a1b2d332"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/daviddwlee84/dev-cli/releases/download/v0.2.41/dev-cli_v0.2.41_linux_arm64.tar.gz"
      sha256 "422b6edf3f7c2b42a2e63119c12047c221e25877d2b424598ac968a7c082d5ee"
    end
    on_intel do
      url "https://github.com/daviddwlee84/dev-cli/releases/download/v0.2.41/dev-cli_v0.2.41_linux_amd64.tar.gz"
      sha256 "cad28adbc056794bf2026876326cadfe500cef90f86572f2e005d4f8527ca57a"
    end
  end

  def install
    if build.head?
      ldflags = "-s -w -X github.com/daviddwlee84/dev-cli/internal/cli.Version=HEAD"
      system "go", "build", *std_go_args(output: bin/"dev", ldflags: ldflags), "./cmd/dev"
    else
      bin.install "dev"
    end
    generate_completions_from_executable(bin/"dev", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dev --version")
    assert_match "Usage:", shell_output("#{bin}/dev --help")
  end
end
