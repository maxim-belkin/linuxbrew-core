class CpuFeatures < Formula
  desc "Cross platform C99 library to get cpu features at runtime"
  homepage "https://github.com/google/cpu_features"
  url "https://github.com/google/cpu_features/archive/v0.4.1.tar.gz"
  sha256 "b7b6b27f759410f73f15f935ae646f30c9c6742731dc354416399677bd418156"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "cf7f7d47468e2c0cf321c22c86adb2c734920559b1a63553b1688ed0e4a39b73" => :catalina
    sha256 "b2736429ca74d23173266aab1d3ee6fea58ee963e0042391d803b26d322838d7" => :mojave
    sha256 "0d8119f02b609f5cfcac19177bd669668686c549bb138fbe2a0aa391df7dc838" => :high_sierra
    sha256 "d703ec98a4f4913ac50c872475e7c37e6c439326db607297fa14cd438e75f919" => :sierra
    sha256 "6b04b4841bfe83e30514f090f9c6e7f3bc214b6251980805f665d63305f20563" => :x86_64_linux
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    output = shell_output(bin/"list_cpu_features")
    assert_match /^arch\s*:/, output
    assert_match /^brand\s*:/, output
    assert_match /^family\s*:/, output
    assert_match /^model\s*:/, output
    assert_match /^stepping\s*:/, output
    assert_match /^uarch\s*:/, output
    assert_match /^flags\s*:/, output
  end
end
