class DevCli < Formula
  desc "Task and worktree command center for multi-repository development"
  homepage "https://github.com/daviddwlee84/dev-cli"
  url "https://github.com/daviddwlee84/dev-cli/archive/refs/tags/v0.2.36.tar.gz"
  sha256 "b1c081b109822883ede83bd6bad539c777ab7a897446076a8a33239ae6f76cd4"
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
