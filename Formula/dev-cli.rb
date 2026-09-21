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
      url "https://github.com/daviddwlee84/dev-cli/releases/download/v0.2.40/dev-cli_v0.2.40_darwin_arm64.tar.gz"
      sha256 "a57523cc59680a0a13ff9bebe8613da36a6844c88cab8cf7d81cc3e9dd04318d"
    end
    on_intel do
      url "https://github.com/daviddwlee84/dev-cli/releases/download/v0.2.40/dev-cli_v0.2.40_darwin_amd64.tar.gz"
      sha256 "256e5ca777f2b67dbde90dbe08f93f9519b048abc551eb6f44cbc2d23f7c6c31"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/daviddwlee84/dev-cli/releases/download/v0.2.40/dev-cli_v0.2.40_linux_arm64.tar.gz"
      sha256 "4a0c2fc355a5edac462ce4394cdaadb2c619d9f786a8891603a74eac2377e01c"
    end
    on_intel do
      url "https://github.com/daviddwlee84/dev-cli/releases/download/v0.2.40/dev-cli_v0.2.40_linux_amd64.tar.gz"
      sha256 "3ff5a8b3aea1838d3db2cb837bca29297dbf5e0705b2f2091f30acd8caeb66da"
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
