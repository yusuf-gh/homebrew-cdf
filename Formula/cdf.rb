class C degrés < Formula
  desc "Interactive directory navigation using fzf"
  homepage "https://github.com/yourusername/cdf"
  url "https://github.com/yourusername/cdf/releases/download/v1.0.0/cdf-1.0.0.tar.gz"
  sha256 "your_sha256_hash_here"
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
end