# HermesClaw Homebrew Formula
# 
# Usage:
#   brew tap fatbear120503/hermesclaw
#   brew install hermesclaw

class Hermesclaw < Formula
  desc "多智能体 AI 调度系统 - 动态配置 + 流式快显"
  homepage "https://github.com/fatbear120503/hermesclaw"
  version "1.0.0"

  url "https://github.com/fatbear120503/hermesclaw/releases/download/v1.0.0/HermesClaw-1.0.0.tar.gz"
  sha256 "939dfccf36214c884686d1190b3dd9ce8762dda390fc5818cc6df38cd663a807"

  depends_on "python@3.13"

  def install
    libexec.install Dir["*"]

    # Create launcher script
    (bin/"hermesclaw").write <<~EOS
      #!/bin/bash
      HERMES_DIR="#{libexec}"
      CONFIG_DIR="${HOME}/.config/hermesclaw"

      case "${1:-help}" in
        help|--help|-h)
          cat <<'HELP'
🐿️ HermesClaw v1.0 - 多智能体 AI 调度系统

命令:
  help              显示帮助
  install           首次安装向导（配置智能体）
  add               添加新智能体
  edit              编辑智能体配置
  delete            删除智能体
  list              列出所有智能体
  qrcode            生成微信配置二维码
  status            检查服务状态
  dispatch <agent>: 调用指定智能体
  dispatch all "问题"   调用所有智能体
  dispatch all "聚合分析 问题" → 深度对比分析

使用方法:
  hermesclaw install                  → 交互式配置你的 AI 智能体
  hermesclaw dispatch all "报到"      → 测试全部智能体

微信触发示例:
  oc:问题          → 🐿️ 小松鼠 (OpenClaw)
  hm:问题          → ⚡ Hermes
  cherry:问题      → 🍒 Agnes AI (自定义)
  wb:问题          → 🤖 WorkBuddy (自定义)
  all:问题         → 调用所有已配置的智能体（流式快显）
  all:聚合分析问题 → 深度对比分析

配置目录: ~/.config/hermesclaw/
HELP
          ;;
        install|setup)
          python3 "${HERMES_DIR}/scripts/setup.py" install
          ;;
        add)
          python3 "${HERMES_DIR}/scripts/setup.py" add
          ;;
        edit)
          python3 "${HERMES_DIR}/scripts/setup.py" edit
          ;;
        delete|remove)
          python3 "${HERMES_DIR}/scripts/setup.py" delete
          ;;
        list|ls)
          python3 "${HERMES_DIR}/scripts/setup.py" list
          ;;
        qrcode|qr)
          python3 "${HERMES_DIR}/scripts/wechat_qr.py"
          ;;
        status)
          python3 "${HERMES_DIR}/scripts-v3/dispatch.py" status
          ;;
        dispatch)
          shift
          cd "${HERMES_DIR}/scripts-v3" && python3 dispatch.py "$@"
          ;;
        test)
          "${HERMES_DIR}/bin/hermesclaw" dispatch all "报到"
          ;;
        *)
          echo "❌ 未知命令: $1"
          echo "运行 'hermesclaw help' 查看帮助"
          exit 1
          ;;
      esac
    EOS
    chmod 0755, bin/"hermesclaw"

    # Ensure config dir exists
    (etc/"hermesclaw").mkpath
  end

  def caveats
    <<~EOS
      🐿️ HermesClaw v1.0.0 多智能体调度系统已安装！

      快速开始:
        hermesclaw install    → 配置你的 AI 智能体

      管理智能体:
        hermesclaw add        → 添加新智能体
        hermesclaw list       → 查看已配置
        hermesclaw edit       → 修改配置
        hermesclaw delete     → 删除智能体

      使用示例:
        hermesclaw dispatch cherry: "你好"
        hermesclaw dispatch all "报到"
        hermesclaw dispatch all "聚合分析 智能马桶推荐"

      微信消息前缀 (根据你的配置):
        <agent_id>:问题   → 调用单个智能体
        all:问题          → 全部调用（流式快显）
        all:聚合分析问题  → 深度对比分析

      文档: https://github.com/fatbear120503/hermesclaw
    EOS
  end

  test do
    system "#{bin}/hermesclaw", "help"
  end
end
