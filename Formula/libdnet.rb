class Libdnet < Formula
  desc "Portable low-level networking library"
  homepage "https://github.com/dugsong/libdnet"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/libdnet/libdnet-1.12.tgz"
  sha256 "83b33039787cf99990e977cef7f18a5d5e7aaffc4505548a83d31bd3515eb026"
  license "BSD-3-Clause"

  livecheck do
    url :homepage
    regex(/^libdnet[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any
    rebuild 4
    sha256 "f0f94480e8f973b31b39dfbb7f594c678f02c7176559badb1d31d644deb0a34a" => :catalina
    sha256 "540ccb96d3647a0d71f563e06d08e410d14b7d09c23f6348bc91fd22251e5ff2" => :mojave
    sha256 "ece250e6792f542e5546ac5e8e5144fe07c76ce3ddb94216181e85092d530e81" => :high_sierra
    sha256 "bb550ef762ca5d65f87b65575758557afcf8e6b93855be32638cab265540ba6b" => :sierra
    sha256 "0cf37dc7a772804f79245843b8e82ff009b24463d7b136b38d0ec0acc33ca005" => :x86_64_linux
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    # autoreconf to get '.dylib' extension on shared lib
    ENV.append_path "ACLOCAL_PATH", "config"
    system "autoreconf", "-ivf"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    system "#{bin}/dnet-config", "--version"
  end
end
