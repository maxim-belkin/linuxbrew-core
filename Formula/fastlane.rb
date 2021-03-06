class Fastlane < Formula
  desc "Easiest way to build and release mobile apps"
  homepage "https://fastlane.tools"
  url "https://github.com/fastlane/fastlane/archive/2.158.0.tar.gz"
  sha256 "7e9b4e9092f9f19589eb988f1f9b3bde8fc07c81420a80f9fdbf9ae45f5c456b"
  license "MIT"
  head "https://github.com/fastlane/fastlane.git"

  livecheck do
    url :head
    regex(/^([\d.]+)$/i)
  end

  bottle do
    cellar :any
    sha256 "9ffb9654b43b0d9397fd87caa9a8741b91c6407df60a5957c84122294d1e585c" => :catalina
    sha256 "1886b6dd9d4e4f6de436029c73f8a81510439e570a0e1d8235f7b6f7e4757551" => :mojave
    sha256 "892c75d45539a4456fc8b1a5858e912f7848b389050094f4694b76eeddd1b97e" => :high_sierra
    sha256 "f38c3af19c22afb5b103204be93b5581cedb943add5b2baba8039542699eae15" => :x86_64_linux
  end

  depends_on "ruby"

  def install
    ENV["GEM_HOME"] = libexec
    ENV["GEM_PATH"] = libexec

    system "gem", "build", "fastlane.gemspec"
    system "gem", "install", "fastlane-#{version}.gem", "--no-document"

    (bin/"fastlane").write <<~EOS
      #!/bin/bash
      export PATH="#{Formula["ruby"].opt_bin}:#{libexec}/bin:$PATH"
      GEM_HOME="#{libexec}" GEM_PATH="#{libexec}" \\
        exec "#{libexec}/bin/fastlane" "$@"
    EOS
    chmod "+x", bin/"fastlane"
  end

  test do
    assert_match "fastlane #{version}", shell_output("#{bin}/fastlane --version")

    actions_output = shell_output("#{bin}/fastlane actions")
    assert_match "gym", actions_output
    assert_match "pilot", actions_output
    assert_match "screengrab", actions_output
    assert_match "supply", actions_output
  end
end
