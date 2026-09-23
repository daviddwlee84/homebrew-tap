class Lazypueue < Formula
  desc "Terminal interface for Pueue task queues"
  homepage "https://github.com/daviddwlee84/lazypueue"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/daviddwlee84/lazypueue/releases/download/v0.2.0/lazypueue_0.2.0_darwin_arm64.tar.gz"
      sha256 "1145a136e00885bfb962efadf8774b9d25b42572f9507a8e3e766d3004df5510"
    end
    on_intel do
      url "https://github.com/daviddwlee84/lazypueue/releases/download/v0.2.0/lazypueue_0.2.0_darwin_amd64.tar.gz"
      sha256 "0c80a97e672464a8bea99cc5f1351086297cd541ea977ec649f6bb39c8303055"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/daviddwlee84/lazypueue/releases/download/v0.2.0/lazypueue_0.2.0_linux_arm64.tar.gz"
      sha256 "20d7c678ae559e083d78a8dabc04e1fc9804fc52e83e68a844092cde8a36b0dd"
    end
    on_intel do
      url "https://github.com/daviddwlee84/lazypueue/releases/download/v0.2.0/lazypueue_0.2.0_linux_amd64.tar.gz"
      sha256 "87b6add72f72921403278391eec6809af58d9c099a5ac6e39014c7ed06de388e"
    end
  end

  def install
    bin.install "lazypueue"
    bash_completion.install "completions/lazypueue.bash" => "lazypueue"
    zsh_completion.install "completions/lazypueue.zsh" => "_lazypueue"
    fish_completion.install "completions/lazypueue.fish" if File.exist?("completions/lazypueue.fish")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lazypueue --version")
    assert_match "Usage:", shell_output("#{bin}/lazypueue --help")
  end
end
