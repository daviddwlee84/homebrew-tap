class Lazyansible < Formula
  desc "Personal Ansible inventory and playbook workspace"
  homepage "https://github.com/daviddwlee84/lazyansible"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/daviddwlee84/lazyansible/releases/download/v0.1.1/lazyansible_0.1.1_darwin_arm64.tar.gz"
      sha256 "7b90daab942b2ecb5afbd9d6b1131432b2b8a9f4f69027180e2245bc82b8a37c"
    end
    on_intel do
      url "https://github.com/daviddwlee84/lazyansible/releases/download/v0.1.1/lazyansible_0.1.1_darwin_amd64.tar.gz"
      sha256 "14b1d1b3cfd4eb4c7c788a7614420e8df4b871c43a383726701a278250af196d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/daviddwlee84/lazyansible/releases/download/v0.1.1/lazyansible_0.1.1_linux_arm64.tar.gz"
      sha256 "3c187568eeb0b2f30df6fff3232ed5d5178c3bf3e328c1720b215379457b5bde"
    end
    on_intel do
      url "https://github.com/daviddwlee84/lazyansible/releases/download/v0.1.1/lazyansible_0.1.1_linux_amd64.tar.gz"
      sha256 "bb59a7e9979f2f14e85d46eacac18cbc39a9e72b1be093f04e5d91b86d61d175"
    end
  end

  def install
    bin.install "lazyansible"
    bash_completion.install "completions/lazyansible.bash" => "lazyansible"
    zsh_completion.install "completions/lazyansible.zsh" => "_lazyansible"
    fish_completion.install "completions/lazyansible.fish" if File.exist?("completions/lazyansible.fish")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lazyansible --version")
    assert_match "Usage:", shell_output("#{bin}/lazyansible --help")
  end
end
