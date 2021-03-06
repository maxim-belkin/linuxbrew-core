class Libvirt < Formula
  desc "C virtualization API"
  homepage "https://www.libvirt.org"
  url "https://libvirt.org/sources/libvirt-6.6.0.tar.xz"
  sha256 "94e52ddd2d71b650e1a7eb5ab7e651f9607ecee207891216714020b8ff081ef9"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]
  revision 1

  livecheck do
    url "https://libvirt.org/sources/"
    regex(/href=.*?libvirt[._-]v?([\d.]+)\.t/i)
  end

  bottle do
    sha256 "26fddc5e2e3e40b10188b22b4bffb8e0eca7c8365dca5c1497246d7a0faf315b" => :catalina
    sha256 "d782a2efbe666ccaf3ae902c9ff7b854cee213e9199c23e7c90f29c098de4a01" => :mojave
    sha256 "da27d51e3bf4d3c0232881aa9adb18ce24d0306e9c3daad3475b36ba54c4324d" => :high_sierra
  end

  head do
    url "https://github.com/libvirt/libvirt.git"
    depends_on "meson" => :build
    depends_on "ninja" => :build
  end
  # remove build deps autoconf/automake/libtool in v6.7.0+
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "docutils" => :build
  depends_on "libtool" => :build
  depends_on "perl" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.8" => :build
  depends_on "rpcgen" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "gnutls"
  depends_on "libgcrypt"
  depends_on "yajl"

  def install
    mkdir "build" do
      if build.head?
        args = %W[
          --localstatedir=#{var}
          --mandir=#{man}
          --sysconfdir=#{etc}
          -Ddriver_esx=enabled
          -Ddriver_qemu=enabled
          -Dinit_script=none
        ]
        system "meson", *std_meson_args, *args, ".."
        system "meson", "compile"
        system "meson", "install"
      else
        args = %W[
          --no-git
          --prefix=#{prefix}
          --localstatedir=#{var}
          --mandir=#{man}
          --sysconfdir=#{etc}
          --with-esx
          --with-init-script=none
          --with-remote
          --with-test
          --with-vbox
          --with-vmware
          --with-qemu
        ]

        args << "ac_cv_path_RPCGEN=#{Formula["rpcgen"].opt_prefix}/bin/rpcgen"

        # Work around a gnulib issue with macOS Catalina
        args << "gl_cv_func_ftello_works=yes"

        system "../autogen.sh", *args

        # Compilation of docs doesn't get done if we jump straight to "make install"
        system "make"
        system "make", "install"
      end
    end
  end

  plist_options manual: "libvirtd"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
        <dict>
          <key>EnvironmentVariables</key>
          <dict>
            <key>PATH</key>
            <string>#{HOMEBREW_PREFIX}/bin</string>
          </dict>
          <key>Label</key>
          <string>#{plist_name}</string>
          <key>ProgramArguments</key>
          <array>
            <string>#{sbin}/libvirtd</string>
            <string>-f</string>
            <string>#{etc}/libvirt/libvirtd.conf</string>
          </array>
          <key>KeepAlive</key>
          <true/>
          <key>RunAtLoad</key>
          <true/>
        </dict>
      </plist>
    EOS
  end

  test do
    if build.head?
      output = shell_output("#{bin}/virsh -V")
      assert_match "Compiled with support for:", output
    else
      output = shell_output("#{bin}/virsh -v")
      assert_match version.to_s, output
    end
  end
end
