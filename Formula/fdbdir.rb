class Fdbdir < Formula
  desc "FoundationDB Directory Explorer CLI (interactive REPL with tuple decoding)"
  homepage "https://github.com/panghy/fdbdir"
  license "MIT"
  depends_on :macos
  url "https://github.com/panghy/fdbdir/releases/download/v0.1.32/fdbdir-aarch64-apple-darwin.tar.xz" if OS.mac? && Hardware::CPU.arm?
  sha256 "e22e03ae7783bd03564deb4dd463d77c3c560697528c62db4986051ff3953ab1" if OS.mac? && Hardware::CPU.arm?
  url "https://github.com/panghy/fdbdir/releases/download/v0.1.32/fdbdir-x86_64-apple-darwin.tar.xz" if OS.mac? && Hardware::CPU.intel?
  sha256 "3438360c8076aa3470b19647ea249330863137e6e2777f32c155cf808753f530" if OS.mac? && Hardware::CPU.intel?
  url "https://github.com/panghy/fdbdir/releases/download/v0.1.32/fdbdir-x86_64-unknown-linux-gnu.tar.xz" if OS.linux? && Hardware::CPU.intel?
  sha256 "18db82f9a38456b4ed203a19f7879f7ac6d30574f0414ce8ac9d3549c187388b" if OS.linux? && Hardware::CPU.intel?

  BINARY_ALIASES = {
    "aarch64-apple-darwin"     => {},
    "x86_64-apple-darwin"      => {},
    "x86_64-unknown-linux-gnu" => {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    (BINARY_ALIASES[target_triple] || {}).each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin[source] => dest
      end
    end
  end
  def install

bin.install "fdbdir" if OS.mac? && Hardware::CPU.arm?
    bin.install "fdbdir" if OS.mac? && Hardware::CPU.intel?

    # Ensure dyld can locate libfdb_c on macOS
    if OS.mac?
      macho = MachO::MachOFile.new((bin/["fdbdir"]).to_s)
      macho.rpaths << "/usr/local/lib" unless macho.rpaths.include?("/usr/local/lib")
      macho.rpaths << "/opt/homebrew/lib" unless macho.rpaths.include?("/opt/homebrew/lib")
      macho.write!
    end

    bin.install "fdbdir" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
