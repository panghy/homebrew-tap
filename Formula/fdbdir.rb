class Fdbdir < Formula
  desc "FoundationDB Directory Explorer CLI (interactive REPL with tuple decoding)"
  homepage "https://github.com/panghy/fdbdir"
  version "0.1.30"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/panghy/fdbdir/releases/download/v0.1.30/fdbdir-aarch64-apple-darwin.tar.xz"
      sha256 "d1f07d29b140e5975957e19343da3eda6762d7c0f06ad15ec78dbae9cc77d7a3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/panghy/fdbdir/releases/download/v0.1.30/fdbdir-x86_64-apple-darwin.tar.xz"
      sha256 "0950e5d0110bba6278e90dcd03ded768f8585688ad5c6af7bb9bbed643ec0560"
    end
  end
  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/panghy/fdbdir/releases/download/v0.1.30/fdbdir-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "72df60a26de445becf6e82ec6044c6f8ceff89c3308cf176deca21b8fa09a542"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin": {},
    "x86_64-apple-darwin": {},
    "x86_64-unknown-linux-gnu": {}
  }

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "fdbdir"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "fdbdir"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "fdbdir"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
