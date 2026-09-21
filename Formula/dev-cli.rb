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
      url "https://github.com/daviddwlee84/dev-cli/releases/download/v0.2.42/dev-cli_v0.2.42_darwin_arm64.tar.gz"
      sha256 "ecf94868ae94dac65ea6c2d8887ee89d8fd5479f786b17e5068f2a28b6ad182a"
    end
    on_intel do
      url "https://github.com/daviddwlee84/dev-cli/releases/download/v0.2.42/dev-cli_v0.2.42_darwin_amd64.tar.gz"
      sha256 "e86b3980ef35bbd094c3aa582697a5bb745e96e26ce021ffb81e77133f5a972a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/daviddwlee84/dev-cli/releases/download/v0.2.42/dev-cli_v0.2.42_linux_arm64.tar.gz"
      sha256 "a299fd4bbadbcf1a3c7aa9db8859cdbb8442e71168008c06405188d936afd51e"
    end
    on_intel do
      url "https://github.com/daviddwlee84/dev-cli/releases/download/v0.2.42/dev-cli_v0.2.42_linux_amd64.tar.gz"
      sha256 "b203e722c359b680373d0029b015e32869398fc8632182864f74ee2297bce612"
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
