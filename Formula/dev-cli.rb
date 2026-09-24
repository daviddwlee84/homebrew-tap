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
      url "https://github.com/daviddwlee84/dev-cli/releases/download/v0.3.2/dev-cli_v0.3.2_darwin_arm64.tar.gz"
      sha256 "9d25bb9a57fa26e7961e4321a087a6c7a9b54359e15bdffa1cac1f841a02dc96"
    end
    on_intel do
      url "https://github.com/daviddwlee84/dev-cli/releases/download/v0.3.2/dev-cli_v0.3.2_darwin_amd64.tar.gz"
      sha256 "0e4fba8f3641db84dd0225201bdf300d9e6573dc557433671eaedf289291d962"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/daviddwlee84/dev-cli/releases/download/v0.3.2/dev-cli_v0.3.2_linux_arm64.tar.gz"
      sha256 "b53f27127257f52a3357493f3143372df77e7abca68427ad8e4c0c581eec094a"
    end
    on_intel do
      url "https://github.com/daviddwlee84/dev-cli/releases/download/v0.3.2/dev-cli_v0.3.2_linux_amd64.tar.gz"
      sha256 "26bf1b16a8bac461aea8349ce25b03983fc3d60ce3917b4768d19365f76460cb"
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
