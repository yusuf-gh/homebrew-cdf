class Cdf < Formula
  desc "Interactive directory navigation using fzf"
  homepage "https://github.com/yusuf-gh/homebrew-cdf"
  url "https://github.com/yusuf-gh/cdf/releases/download/v1.0.0/cdf-1.0.0.tar.gz"
  sha256 "b191347503d4cbcfdc8d646945a2a54cb67f94ddc0496d9d7ec4d6301370f8af"
  license "MIT"

  depends_on "fzf"

  def install
    bin.install "cdf.sh" => "cdf"
  end

  def caveats
    <<~EOS
      To enable the `cdf` function in your shell, add the following line to your ~/.zshrc or ~/.bashrc:
        source #{opt_bin}/cdf
      Then, run `source ~/.zshrc` or `source ~/.bashrc` to apply the changes.
    EOS
  end
  test do
    assert_predicate bin/"cdf", :exist?
    assert_predicate bin/"cdf", :executable?
  end
end