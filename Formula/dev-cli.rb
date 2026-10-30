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
      url "https://github.com/daviddwlee84/dev-cli/releases/download/v0.3.4/dev-cli_v0.3.4_darwin_arm64.tar.gz"
      sha256 "f12c6c5898d05d094e91aa8b99c974e6f3ceae1ccc09daae045a2635f62e18ed"
    end
    on_intel do
      url "https://github.com/daviddwlee84/dev-cli/releases/download/v0.3.4/dev-cli_v0.3.4_darwin_amd64.tar.gz"
      sha256 "8e9e54e104415a7158f671fe545132f59d3dd9cb30a333460755b97e4e09b9b8"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/daviddwlee84/dev-cli/releases/download/v0.3.4/dev-cli_v0.3.4_linux_arm64.tar.gz"
      sha256 "abfb0be3f9a2e5502772330e6c25587f69ef3498c4c920d13af20f359c23205a"
    end
    on_intel do
      url "https://github.com/daviddwlee84/dev-cli/releases/download/v0.3.4/dev-cli_v0.3.4_linux_amd64.tar.gz"
      sha256 "bed6a91e03f407a5b0af2fac42d56e7f7a9938b67bf5f3817534523b4c341c02"
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
