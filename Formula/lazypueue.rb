class Lazypueue < Formula
  desc "Terminal interface for Pueue task queues"
  homepage "https://github.com/daviddwlee84/lazypueue"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/daviddwlee84/lazypueue/releases/download/v0.1.1/lazypueue_0.1.1_darwin_arm64.tar.gz"
      sha256 "1a9d077e958cc6cc2c28a485d44bcb38c648c139193e2e6debd3bd0b44746644"
    end
    on_intel do
      url "https://github.com/daviddwlee84/lazypueue/releases/download/v0.1.1/lazypueue_0.1.1_darwin_amd64.tar.gz"
      sha256 "d9d856213f46761695d359080cb12a96dd039e20b86249ac431762752df83cd3"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/daviddwlee84/lazypueue/releases/download/v0.1.1/lazypueue_0.1.1_linux_arm64.tar.gz"
      sha256 "b464dfe47e3e3795b5e884287b3218d3531bba1c60717c24e22c499c59ad6285"
    end
    on_intel do
      url "https://github.com/daviddwlee84/lazypueue/releases/download/v0.1.1/lazypueue_0.1.1_linux_amd64.tar.gz"
      sha256 "6491ca403047e3952488a72e5e6579f6da2845aa85af189653cbe3da7019ba60"
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
