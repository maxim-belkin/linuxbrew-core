class Cppunit < Formula
  desc "Unit testing framework for C++"
  homepage "https://wiki.freedesktop.org/www/Software/cppunit/"
  url "https://dev-www.libreoffice.org/src/cppunit-1.15.1.tar.gz"
  sha256 "89c5c6665337f56fd2db36bc3805a5619709d51fb136e51937072f63fcc717a7"
  license "LGPL-2.1"

  livecheck do
    url "https://dev-www.libreoffice.org/src/"
    regex(/href=["']?cppunit[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any
    sha256 "3e194b84577c733e5641f305a1cb5cc76355f13037898afc56c3096f98bb78fe" => :catalina
    sha256 "1c107efb84d656dd5327aa8cf13e6cbce8db7542aacba98ae98a2b05940b16ff" => :mojave
    sha256 "08a339bc38db169bce2f5eb0fc0b940bc82562c37274aa770668f681aeca4386" => :high_sierra
    sha256 "4a7ea94b2d798f84044519d25ed5655e364629b67fd509a86c1ff9ff216a5ee8" => :x86_64_linux
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/DllPlugInTester", 2)
  end
end
