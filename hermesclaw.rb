class Hermesclaw < Formula
  desc "多智能体消息路由调度器 - AI Agent Dispatcher for WeChat"
  homepage "https://github.com/fatbear120503/hermesclaw"
  version "0.2.0"

  url "https://github.com/fatbear120503/hermesclaw/releases/download/v0.2.0/HermesClaw-0.2.0.tar.gz"
  sha256 "1538eb26f2d3fee0202a77ed7b511839fea9f09e7c935bb67e7bc19fc3fded37"

  depends_on "python@3.13" => :recommended
  depends_on "node" => :recommended

  def install
    libexec.install Dir["*"]

    (bin/"hermesclaw").write <<~EOS
      #!/bin/bash
      HERMES_DIR="#{libexec}"
      CONFIG_DIR="${HOME}/.hermesclaw"

      case "${1:-help}" in
        help|--help|-h)
          cat <<'HELP'
🐿️ HermesClaw - 多智能体调度器 v0.2.0

命令:
  help          显示帮助
  install       安装依赖
  start         启动服务
  stop          停止服务
  status        查看状态
  config        编辑配置
  doctor        诊断问题

微信使用:
  无前缀  → 🐿️ 小松鼠 (OpenClaw)
  hm:     → ⚡ Hermes
  cherry: → 🍒 Agnes AI
  wb:     → 🤖 WorkBuddy
  both:   → 🍒 cherry + 🤖 wb
  all:    → 所有 Agent

快速调度:
  cd /usr/local/hermesclaw/scripts-v3
  python3 dispatch_v3.py all "你的问题"
HELP
          ;;
        install)
          echo "📦 安装依赖..."
          cd "${HERMES_DIR}"
          bash install.sh
          ;;
        start)
          echo "🚀 启动 HermesClaw..."
          mkdir -p "${CONFIG_DIR}"
          if [ ! -f "${CONFIG_DIR}/.env" ]; then
            cp "${HERMES_DIR}/config/.env.example" "${CONFIG_DIR}/.env"
            echo "✅ 已创建默认配置: ${CONFIG_DIR}/.env"
          fi
          cd "${HERMES_DIR}"
          bash start.sh
          ;;
        stop)
          echo "⏹ 停止..."
          pkill -f "python run.py" || true
          pkill -f "npm start" || true
          ;;
        status)
          pgrep -f "python run.py" > /dev/null && echo "✅ Router" || echo "❌ Router"
          pgrep -f "npm start" > /dev/null && echo "✅ Plugin" || echo "❌ Plugin"
          ;;
        config)
          mkdir -p "${CONFIG_DIR}"
          if [ ! -f "${CONFIG_DIR}/.env" ]; then
            cp "${HERMES_DIR}/config/.env.example" "${CONFIG_DIR}/.env"
            echo "✅ 已创建默认配置"
          fi
          echo "编辑: ${CONFIG_DIR}/.env"
          ;;
        doctor)
          echo "🔍 HermesClaw 诊断..."
          command -v python3 >/dev/null && echo "✅ python3" || echo "❌ python3 未安装"
          command -v node >/dev/null && echo "✅ node" || echo "❌ node 未安装"
          command -v npm >/dev/null && echo "✅ npm" || echo "❌ npm 未安装"
          [ -d "${HERMES_DIR}/router/venv" ] && echo "✅ Router venv" || echo "⚠️ Router venv 未创建"
          [ -d "${HERMES_DIR}/plugin/node_modules" ] && echo "✅ Plugin node_modules" || echo "⚠️ Plugin 未安装"
          ;;
        *)
          echo "未知命令: $1"
          echo "运行 'hermesclaw help'"
          exit 1
          ;;
      esac
    EOS
    chmod 0755, bin/"hermesclaw"
  end

  def caveats
    <<~EOS
      🐿️ HermesClaw v0.2.0 多智能体调度器已安装！

      使用说明:
        hermesclaw help    - 显示帮助
        hermesclaw install - 安装 Python/Node 依赖
        hermesclaw config  - 创建默认配置文件
        hermesclaw start   - 启动 Router + Plugin 服务
        hermesclaw status  - 查看运行状态
        hermesclaw stop    - 停止服务
        hermesclaw doctor  - 诊断问题

      快速调度 (Phase 3):
        cd /usr/local/hermesclaw/scripts-v3
        python3 dispatch_v3.py all "你的问题"

      微信消息前缀:
        无前缀  → 🐿️ 小松鼠 (OpenClaw)
        hm:     → ⚡ Hermes
        cherry: → 🍒 Agnes AI
        wb:     → 🤖 WorkBuddy
        both:   → 🍒 cherry + 🤖 wb
        all:    → 所有 Agent

      配置文件: ~/.hermesclaw/.env

      文档: https://github.com/fatbear120503/hermesclaw
    EOS
  end

  test do
    system "#{bin}/hermesclaw", "help"
  end
end
