class Fdbdir < Formula
  desc "FoundationDB Directory Explorer CLI (interactive REPL with tuple decoding)"
  homepage "https://github.com/panghy/fdbdir"
  license "MIT"
  depends_on :macos
  url "https://github.com/panghy/fdbdir/releases/download/v0.1.31/fdbdir-aarch64-apple-darwin.tar.xz" if OS.mac? && Hardware::CPU.arm?
  sha256 "4c6984066721ad75f7cfd1c9b8f20ded900e1f44b1f11a288da3e90eb4404e50" if OS.mac? && Hardware::CPU.arm?
  url "https://github.com/panghy/fdbdir/releases/download/v0.1.31/fdbdir-x86_64-apple-darwin.tar.xz" if OS.mac? && Hardware::CPU.intel?
  sha256 "c1a388ded4793d2128c2154c81ce3b8e17985db0b8b98ff851e53b0987d99981" if OS.mac? && Hardware::CPU.intel?
  url "https://github.com/panghy/fdbdir/releases/download/v0.1.31/fdbdir-x86_64-unknown-linux-gnu.tar.xz" if OS.linux? && Hardware::CPU.intel?
  sha256 "9f98e40fe7abb0ef2f0c0e1733a0f65703fea403056721ca8eba661c04cfb3a9" if OS.linux? && Hardware::CPU.intel?

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
    # Ensure dyld can locate libfdb_c on macOS
    if OS.mac?
      macho = MachO::MachOFile.new((bin/"fdbdir").to_s)
      macho.rpaths << "/usr/local/lib" unless macho.rpaths.include?("/usr/local/lib")
      macho.rpaths << "/opt/homebrew/lib" unless macho.rpaths.include?("/opt/homebrew/lib")
      macho.write!
    end

    # Ensure dyld can locate libfdb_c on macOS
    if OS.mac?
      system "install_name_tool", "-add_rpath", "/usr/local/lib", bin/"fdbdir"
      system "install_name_tool", "-add_rpath", "/opt/homebrew/lib", bin/"fdbdir"
    end
    bin.install "fdbdir" if OS.mac? && Hardware::CPU.arm?
    bin.install "fdbdir" if OS.mac? && Hardware::CPU.intel?
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
