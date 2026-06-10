class Hermesclaw < Formula
  desc "多智能体消息路由调度器 - AI Agent Dispatcher for WeChat"
  homepage "https://github.com/fatbear120503/hermesclaw"
  version "0.1.0"
  url "https://github.com/fatbear120503/hermesclaw/releases/download/v0.1.0/HermesClaw-0.1.0.pkg"
  sha256 "2fd67c7ceb2c6a9dd8623ce4133632f7a0b1371ce0539a0b45e18586a3a9caba"
  depends_on "python@3.13" => :recommended
  depends_on "node" => :recommended

  def install
    prefix.install Dir["*"]
    bin.install_symlink prefix/"bin/hermesclaw" if (prefix/"bin/hermesclaw").exist?
  end

  def caveats
    <<~EOS
      🐿️ HermesClaw 多智能体调度器已安装！

      微信消息前缀:
        无前缀  → 🐿️ 小松鼠 (OpenClaw)
        hm:     → ⚡ Hermes
        cherry: → 🍒 Agnes AI
        wb:     → 🤖 WorkBuddy
        both:   → 🍒 cherry + 🤖 wb
        all:    → 所有 Agent

      配置文件: ~/.hermesclaw/.env
    EOS
  end
end
