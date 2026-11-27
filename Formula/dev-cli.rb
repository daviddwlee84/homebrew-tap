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
      url "https://github.com/daviddwlee84/dev-cli/releases/download/v0.3.7/dev-cli_v0.3.7_darwin_arm64.tar.gz"
      sha256 "2bb1b9867c0aeac7663a52aaf780473b040d936c38ae343f2bcb8db5654994e4"
    end
    on_intel do
      url "https://github.com/daviddwlee84/dev-cli/releases/download/v0.3.7/dev-cli_v0.3.7_darwin_amd64.tar.gz"
      sha256 "668d67a56587374a7cd741c11eb4fdc35492de8f92a2314aefdfa1af4155ffd9"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/daviddwlee84/dev-cli/releases/download/v0.3.7/dev-cli_v0.3.7_linux_arm64.tar.gz"
      sha256 "e25af10334ddd9271d51a90da294754344c496607a5a0cb0be0b6e70d25c3ac9"
    end
    on_intel do
      url "https://github.com/daviddwlee84/dev-cli/releases/download/v0.3.7/dev-cli_v0.3.7_linux_amd64.tar.gz"
      sha256 "cee9a583ad036937e44d1b4a663300bd3a563a77471e61349898e8135217ac31"
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
