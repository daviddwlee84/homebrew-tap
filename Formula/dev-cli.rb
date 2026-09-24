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
      url "https://github.com/daviddwlee84/dev-cli/releases/download/v0.3.0/dev-cli_v0.3.0_darwin_arm64.tar.gz"
      sha256 "c660ead4542a88e573e3d4b7d206803f5202484c832890d22108af9abcc68165"
    end
    on_intel do
      url "https://github.com/daviddwlee84/dev-cli/releases/download/v0.3.0/dev-cli_v0.3.0_darwin_amd64.tar.gz"
      sha256 "8be2bbf3bd5671ae769683886f31e403e7b6b622e4cc59db86d6ad1c4e875d59"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/daviddwlee84/dev-cli/releases/download/v0.3.0/dev-cli_v0.3.0_linux_arm64.tar.gz"
      sha256 "002d6ecad04174732730bcbd56abe871a2510b695e69cf6c26d522e6af325dec"
    end
    on_intel do
      url "https://github.com/daviddwlee84/dev-cli/releases/download/v0.3.0/dev-cli_v0.3.0_linux_amd64.tar.gz"
      sha256 "1e63d02caf3ced57c46279e7b73619efcdef3904332f7356ee7ffe9bad1e37e4"
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
