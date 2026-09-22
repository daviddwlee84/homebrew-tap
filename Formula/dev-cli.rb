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
      url "https://github.com/daviddwlee84/dev-cli/releases/download/v0.2.44/dev-cli_v0.2.44_darwin_arm64.tar.gz"
      sha256 "d19ed4bb44740333f810d055e69503a47661424d00bcb591940783a3b0160d40"
    end
    on_intel do
      url "https://github.com/daviddwlee84/dev-cli/releases/download/v0.2.44/dev-cli_v0.2.44_darwin_amd64.tar.gz"
      sha256 "fb1cd52327f06eb40519d63cd8388d0b7612e89343175004133bdffa89d7e91d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/daviddwlee84/dev-cli/releases/download/v0.2.44/dev-cli_v0.2.44_linux_arm64.tar.gz"
      sha256 "658edae9f28ec2d7daba90fd3b95fe1ac720a3c175cc64d75eb08adc9c872e38"
    end
    on_intel do
      url "https://github.com/daviddwlee84/dev-cli/releases/download/v0.2.44/dev-cli_v0.2.44_linux_amd64.tar.gz"
      sha256 "445445bb8b9689ca2f635858559318a8ac5a376f70facbc775b19b329f54c914"
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
