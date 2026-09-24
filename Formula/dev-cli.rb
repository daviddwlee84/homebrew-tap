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
      url "https://github.com/daviddwlee84/dev-cli/releases/download/v0.3.3/dev-cli_v0.3.3_darwin_arm64.tar.gz"
      sha256 "cdd3529813b0cc1e56571be4c2456aa5f1f354cd202446f8d811505e0a2f0903"
    end
    on_intel do
      url "https://github.com/daviddwlee84/dev-cli/releases/download/v0.3.3/dev-cli_v0.3.3_darwin_amd64.tar.gz"
      sha256 "1e6b93c09ada3aa1581fde5ebc0b2777f7a6d46d0ca90d25e676eefa82a3ae62"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/daviddwlee84/dev-cli/releases/download/v0.3.3/dev-cli_v0.3.3_linux_arm64.tar.gz"
      sha256 "4868eb126037bfe9ca998e922a58bb631c298388603caf1181d3289080a4ac45"
    end
    on_intel do
      url "https://github.com/daviddwlee84/dev-cli/releases/download/v0.3.3/dev-cli_v0.3.3_linux_amd64.tar.gz"
      sha256 "ead787e33bfd670a9caeed197bf1da580e6ec5232db5610ce1988a08c4e7fd74"
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
