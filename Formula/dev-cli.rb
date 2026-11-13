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
      url "https://github.com/daviddwlee84/dev-cli/releases/download/v0.3.6/dev-cli_v0.3.6_darwin_arm64.tar.gz"
      sha256 "b6eac02dec8ae771e4c24b471dabd88963778730944b77a0cd3483c8167b6587"
    end
    on_intel do
      url "https://github.com/daviddwlee84/dev-cli/releases/download/v0.3.6/dev-cli_v0.3.6_darwin_amd64.tar.gz"
      sha256 "f7d99cbe49c69383a120c5761e32405ed5b2cf31352b889ec9d5098f32fde6bf"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/daviddwlee84/dev-cli/releases/download/v0.3.6/dev-cli_v0.3.6_linux_arm64.tar.gz"
      sha256 "6e60b89ce2989f932e56f1b767726a5175506c1bcfbb2f4edd336a09cda2023f"
    end
    on_intel do
      url "https://github.com/daviddwlee84/dev-cli/releases/download/v0.3.6/dev-cli_v0.3.6_linux_amd64.tar.gz"
      sha256 "11655a6ea7b124ce475fadeb60afeae252f2d9f8ea2dcd134dbb83f4031a2746"
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
