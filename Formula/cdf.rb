class Cdf < Formula
  desc "Interactive directory navigation using fzf"
  homepage "https://github.com/yusuf-gh/homebrew-cdf"
  url "https://github.com/yusuf-gh/homebrew-cdf/releases/download/v1.0.1/cdf-1.0.1.tar.gz"
  sha256 "8250f221a6c6fdc57ff7729e0f88ca7fd16b6c67bc0b1dbc22e764c6b35b1d1f"
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