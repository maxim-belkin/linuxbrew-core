class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-analyzer/rust-analyzer.git",
       tag:      "2020-08-31",
       revision: "ac4b134c6be27642dbe915f32a41f9a21bd0c1c9"
  version "2020-08-31"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "92fa2a8e0e955dfd8ffb9546cf35d868af95173a2542c2891cc365cfe4281be0" => :catalina
    sha256 "757c4973fab62a6ab6a1aa6419f8fe6f6ed1d8869d7b43ecf1e84655cdf571df" => :mojave
    sha256 "0f723c0975c051300e3cf164bed8ddbf608da4ef8406ae437f665fe1023d959e" => :high_sierra
    sha256 "10c4c0eadbf9e9e532b6b660553bb19df50382429d6fd96438758cd577d90ea8" => :x86_64_linux
  end

  depends_on "rust" => :build

  def install
    cd "crates/rust-analyzer" do
      system "cargo", "install", "--bin", "rust-analyzer", *std_cargo_args
    end
  end

  test do
    def rpc(json)
      "Content-Length: #{json.size}\r\n" \
      "\r\n" \
      "#{json}"
    end

    input = rpc <<-EOF
    {
      "jsonrpc":"2.0",
      "id":1,
      "method":"initialize",
      "params": {
        "rootUri": "file:/dev/null",
        "capabilities": {}
      }
    }
    EOF

    input += rpc <<-EOF
    {
      "jsonrpc":"2.0",
      "method":"initialized",
      "params": {}
    }
    EOF

    input += rpc <<-EOF
    {
      "jsonrpc":"2.0",
      "id": 1,
      "method":"shutdown",
      "params": null
    }
    EOF

    input += rpc <<-EOF
    {
      "jsonrpc":"2.0",
      "method":"exit",
      "params": {}
    }
    EOF

    output = /Content-Length: \d+\r\n\r\n/

    assert_match output, pipe_output("#{bin}/rust-analyzer", input, 0)
  end
end
