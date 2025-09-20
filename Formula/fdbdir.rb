class Fdbdir < Formula
  desc "FoundationDB Directory Explorer CLI (interactive REPL with tuple decoding)"
  homepage "https://github.com/panghy/fdbdir"
  version "0.1.34"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/panghy/fdbdir/releases/download/v0.1.34/fdbdir-aarch64-apple-darwin.tar.xz"
      sha256 "b9e161216079d4e7fb4b4221c4c67876af3247f7bdc379d0267b96de8c5e9e8c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/panghy/fdbdir/releases/download/v0.1.34/fdbdir-x86_64-apple-darwin.tar.xz"
      sha256 "1507350c4176356693cf9455aa01ce296190bb2f7746d6395d64bb5de361ee75"
    end
  end
  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/panghy/fdbdir/releases/download/v0.1.34/fdbdir-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "8c10d0b17a89e5c841c77869951c3a8d45e8b1b14d8a8defc529faee55cda15e"
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
