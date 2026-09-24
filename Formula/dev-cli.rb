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
      url "https://github.com/daviddwlee84/dev-cli/releases/download/v0.3.1/dev-cli_v0.3.1_darwin_arm64.tar.gz"
      sha256 "8fbd61a55de807acb6f1647b3dfad508b74d3a9c5bdc4bea9327378cedb9e633"
    end
    on_intel do
      url "https://github.com/daviddwlee84/dev-cli/releases/download/v0.3.1/dev-cli_v0.3.1_darwin_amd64.tar.gz"
      sha256 "8e1e19cebc971b7dc83ff20dd7bb39568aac66759b89698a0ce793f57ee1a67a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/daviddwlee84/dev-cli/releases/download/v0.3.1/dev-cli_v0.3.1_linux_arm64.tar.gz"
      sha256 "914beae549106d7d0d666fbd306041113d4226432686591776ef3dce07097ef4"
    end
    on_intel do
      url "https://github.com/daviddwlee84/dev-cli/releases/download/v0.3.1/dev-cli_v0.3.1_linux_amd64.tar.gz"
      sha256 "29a27109b9c32bbbf9223828b2c41255898d0c2fe9a2c603d09b0da02db9b03c"
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
