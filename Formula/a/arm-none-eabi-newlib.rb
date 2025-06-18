class ArmNoneEabiNewlib < Formula
  desc "A C standard library implementation intended for use on embedded systems (ARM bare metal)"
  homepage "https://www.sourceware.org/newlib/"
  url "https://sourceware.org/pub/newlib/newlib-4.5.0.20241231.tar.gz"
  sha256 "33f12605e0054965996c25c1382b3e463b0af91799001f5bb8c0630f2ec8c852"
  license "BSD-3-Clause"

  depends_on "arm-none-eabi-gcc" => :build
  depends_on "arm-none-eabi-binutils" => :build
  depends_on "gmp"
  depends_on "isl"
  depends_on "libmpc"
  depends_on "mpfr"

  on_system :linux, macos: :ventura_or_newer do
    depends_on "texinfo" => :build
  end

  on_macos do
    depends_on "coreutils" => :build
  end

  uses_from_macos "zlib"

  def install
    # Non-GNU coreutils will fail on assembling.
    ENV.prepend_path "PATH", Formula["coreutils"].libexec/"gnubin" if OS.mac?
    target = "arm-none-eabi"
    mkdir "arm-none-eabi-newlib-build" do
      system "../configure", "--target=#{target}",
             "--prefix=#{prefix}",
             "--libdir=#{lib}/#{target}",
             "--infodir=#{info}/#{target}",
             "--enable-newlib-io-long-long",
             "--enable-newlib-io-c99-formats",
             "--enable-newlib-register-fini",
             "--enable-newlib-retargetable-locking",
             "--enable-multilib",
             "--enable-lto",
             "--disable-nls",
             "--with-system-zlib",
             *std_configure_args
      system "make"
      system "make", "install"
      # prefix.install_symlink "lib" => "lib64"
    end
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! For Homebrew/homebrew-core
    # this will need to be a test that verifies the functionality of the
    # software. Run the test with `brew test arm-none-eabi-newlib`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system bin/"program", "do", "something"`.
    system "false"
  end
end
