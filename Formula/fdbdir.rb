class Fdbdir < Formula
  desc "FoundationDB Directory Explorer CLI (interactive REPL with tuple decoding)"
  homepage "https://github.com/panghy/fdbdir"
  version "0.1.32"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/panghy/fdbdir/releases/download/v0.1.32/fdbdir-aarch64-apple-darwin.tar.xz"
      sha256 "e22e03ae7783bd03564deb4dd463d77c3c560697528c62db4986051ff3953ab1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/panghy/fdbdir/releases/download/v0.1.32/fdbdir-x86_64-apple-darwin.tar.xz"
      sha256 "3438360c8076aa3470b19647ea249330863137e6e2777f32c155cf808753f530"
    end
  end
  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/panghy/fdbdir/releases/download/v0.1.32/fdbdir-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "18db82f9a38456b4ed203a19f7879f7ac6d30574f0414ce8ac9d3549c187388b"
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
