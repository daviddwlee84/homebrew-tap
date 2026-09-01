class DevCli < Formula
  desc "Task and worktree command center for multi-repository development"
  homepage "https://github.com/daviddwlee84/dev-cli"
  url "https://github.com/daviddwlee84/dev-cli/archive/refs/tags/v0.2.5.tar.gz"
  sha256 "4c2508f8b4eb25dadd02addcd1274e6521fb0ed9d5663b2a73b825bef7df901f"
  license "MIT"
  head "https://github.com/daviddwlee84/dev-cli.git", branch: "main"

  depends_on "go" => :build

  def install
    ldflags = "-X github.com/daviddwlee84/dev-cli/internal/cli.Version=v#{version}"
    system "go", "build", *std_go_args(output: bin/"dev", ldflags: ldflags), "./cmd/dev"

    generate_completions_from_executable(bin/"dev", shell_parameter_format: :cobra)
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/dev --version")
    assert_match "Available Commands:", shell_output("#{bin}/dev --help")
    assert_match "#compdef dev", shell_output("#{bin}/dev completion zsh")
  end
end
