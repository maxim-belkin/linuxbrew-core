class Texapp < Formula
  desc "App.net client based on TTYtter"
  homepage "https://www.floodgap.com/software/texapp/"
  url "https://www.floodgap.com/software/texapp/dist0/0.6.11.txt"
  sha256 "03c3d5475dfb7877000ce238d342023aeab3d44f7bac4feadc475e501aa06051"

  bottle do
    cellar :any_skip_relocation
    sha256 "416f71ee320ac9efd58e5da5cb91cae807c61d542e90ad624bc778e4b060dfed" => :catalina
    sha256 "8d0f4b422910cdff2f791a2c7e916f2dfc001bb060b2e43760c3db8bb7f1ac3f" => :mojave
    sha256 "6615c40b9f733227163ad90b0082c40e7a5885c8ffa36dcb6c5892c09367c279" => :high_sierra
    sha256 "6615c40b9f733227163ad90b0082c40e7a5885c8ffa36dcb6c5892c09367c279" => :sierra
    sha256 "6615c40b9f733227163ad90b0082c40e7a5885c8ffa36dcb6c5892c09367c279" => :el_capitan
    sha256 "84560f05d9dff6dfec4878d4393c248e210ec29f3081edf35078bcb7018bfca7" => :x86_64_linux
  end

  def install
    bin.install "#{version}.txt" => "texapp"
  end

  test do
    assert_match "trying to find cURL ...", pipe_output("#{bin}/texapp", "^C")
  end
end
