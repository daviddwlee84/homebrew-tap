class DevCli < Formula
  desc "Task and worktree command center for multi-repository development"
  homepage "https://github.com/daviddwlee84/dev-cli"
  url "https://github.com/daviddwlee84/dev-cli/archive/refs/tags/v0.2.17.tar.gz"
  sha256 "7416bf3abf3c94def1ac4d207322a27469310699aa60393eff9df2abb98bea59"
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
