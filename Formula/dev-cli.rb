class DevCli < Formula
  desc "Task and worktree command center for multi-repository development"
  homepage "https://github.com/daviddwlee84/dev-cli"
  url "https://github.com/daviddwlee84/dev-cli/archive/refs/tags/v0.2.31.tar.gz"
  sha256 "3c6a8a721120fd057396d32c25e46e28f6175e507eec5cdf60a540326c3eb440"
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
