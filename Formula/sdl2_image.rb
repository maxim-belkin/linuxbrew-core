class Sdl2Image < Formula
  desc "Library for loading images as SDL surfaces and textures"
  homepage "https://www.libsdl.org/projects/SDL_image/"
  url "https://www.libsdl.org/projects/SDL_image/release/SDL2_image-2.0.5.tar.gz"
  sha256 "bdd5f6e026682f7d7e1be0b6051b209da2f402a2dd8bd1c4bd9c25ad263108d0"

  livecheck do
    url :homepage
    regex(/SDL2_image[._-]v?(\d+(?:\.\d+)*)/i)
  end

  bottle do
    cellar :any
    sha256 "691d5407fef2bc374ac3b7c2fafbe46a6bc0f9ed609f98812b24fec33ab9bd27" => :catalina
    sha256 "1b3a464579d9ef25b3bdd9276119efffd0134fda5c5dc27051a35f1b21c00cfd" => :mojave
    sha256 "55c1f996fb523c2727d2b103f0a5ecfd7a073f55ff9a7230bb609d22bbf5a576" => :high_sierra
    sha256 "e3c9cf45d97099e818c667d23af8352e6d1bba0e3b609cdddee654f2a9da80cf" => :sierra
    sha256 "7716abd8d14c9ae0088ae97b5ee12c2e29cbb4a5c93eb02af4e82e939804608b" => :x86_64_linux
  end

  depends_on "pkg-config" => :build
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "sdl2"
  depends_on "webp"

  def install
    inreplace "SDL2_image.pc.in", "@prefix@", HOMEBREW_PREFIX

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-imageio",
                          "--disable-jpg-shared",
                          "--disable-png-shared",
                          "--disable-tif-shared",
                          "--disable-webp-shared"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <SDL2/SDL_image.h>

      int main()
      {
          int success = IMG_Init(0);
          IMG_Quit();
          return success;
      }
    EOS
    if OS.mac?
      system ENV.cc, "-L#{lib}", "-lsdl2_image", "test.c", "-o", "test"
    else
      system ENV.cc, "test.c", "-L#{lib}", "-lSDL2_image", "-o", "test"
    end
    system "./test"
  end
end
