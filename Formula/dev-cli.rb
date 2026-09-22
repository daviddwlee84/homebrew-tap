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
      url "https://github.com/daviddwlee84/dev-cli/releases/download/v0.2.43/dev-cli_v0.2.43_darwin_arm64.tar.gz"
      sha256 "e5a35f2ff143a2f5b83dc722b6cb7667236a39fd4eb2dc4ddd2d60ee01be960f"
    end
    on_intel do
      url "https://github.com/daviddwlee84/dev-cli/releases/download/v0.2.43/dev-cli_v0.2.43_darwin_amd64.tar.gz"
      sha256 "1d1ccfb639c8a4bb3c931b33d88825ff5aa714aabd41ea01fbb6ebee5f09d61e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/daviddwlee84/dev-cli/releases/download/v0.2.43/dev-cli_v0.2.43_linux_arm64.tar.gz"
      sha256 "b2cdc9cd05aab1ce972e5372784c344dc3f2a3a05fe3281c489b1e22e674afa4"
    end
    on_intel do
      url "https://github.com/daviddwlee84/dev-cli/releases/download/v0.2.43/dev-cli_v0.2.43_linux_amd64.tar.gz"
      sha256 "80b7693eb6fb9018e385efbee89d1ef5f35ab13310e44abcfe8dfbaa17d610c3"
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
