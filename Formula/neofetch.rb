class Neofetch < Formula
  desc "Fast, highly customisable system info script"
  homepage "https://github.com/dylanaraps/neofetch"
  url "https://github.com/dylanaraps/neofetch/archive/7.1.0.tar.gz"
  sha256 "58a95e6b714e41efc804eca389a223309169b2def35e57fa934482a6b47c27e7"
  license "MIT"
  head "https://github.com/dylanaraps/neofetch.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9d88c0c07ebdeddaf68a5512a7f4a36cbc52851dfb1c6fc63b446f6a9baaaa01" => :catalina
    sha256 "9d88c0c07ebdeddaf68a5512a7f4a36cbc52851dfb1c6fc63b446f6a9baaaa01" => :mojave
    sha256 "9d88c0c07ebdeddaf68a5512a7f4a36cbc52851dfb1c6fc63b446f6a9baaaa01" => :high_sierra
    sha256 "09a8b957e3e61f847d8a169747b1afbb8cc271bfbd21d1d0a5e34f2359289f47" => :x86_64_linux
  end

  if OS.mac?
    depends_on "imagemagick"
    depends_on "screenresolution"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/neofetch", "--config", "none", "--color_blocks", "off",
                              "--disable", "wm", "de", "term", "gpu"
  end
end
