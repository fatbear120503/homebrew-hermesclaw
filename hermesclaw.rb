class Hermesclaw < Formula
  desc "Multi-AI CLI dispatcher for OpenClaw"
  homepage "https://github.com/fatbear120503/hermesclaw"
  version "1.0.1"
  url "https://github.com/fatbear120503/hermesclaw/releases/download/v1.0.1/HermesClaw-1.0.1.tar.gz"
  sha256 "f423ca6122b5613b309c5a497ea4cde40c3ec1ac9afa4422446fb2e9c0e0dfab"
  license "MIT"

  depends_on "python@3.13"

  def install
    libexec.install Dir["*"]
    (bin/"hermesclaw").write_env_script libexec/"bin/hermesclaw",
      :PYTHONPATH => "#{libexec}/scripts-v3"
  end

  def caveats
    <<~EOS
      HermesClaw v1.0.1 installed!
      
      Setup:
        hermesclaw config        # Interactive setup wizard
        hermesclaw status        # Check all agents
      
      Usage:
        hermesclaw hm "问题"      # Hermes
        hermesclaw cherry "问题"  # Agnes AI
        hermesclaw wb "问题"      # WorkBuddy
        hermesclaw all "问题"     # All agents + aggregation
      
      Config: ~/.config/hermesclaw/
    EOS
  end

  test do
    system "#{bin}/hermesclaw", "status"
  end
end
