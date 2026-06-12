class Hermesclaw < Formula
  desc "多智能体消息路由调度器 - AI Agent Dispatcher for WeChat"
  homepage "https://github.com/fatbear120503/hermesclaw"
  version "0.1.0"

  # 从 GitHub Release 下载 tar.gz
  url "https://github.com/fatbear120503/hermesclaw/releases/download/v0.1.0/HermesClaw-0.1.0.tar.gz"
  sha256 "sha256 "b7bb7fc8cf4e53afdd849dd3684eeaefb1ece0c2c1584d3f18e8d62577bc36f2""

  # 推荐依赖（非强制，会自动检测）
  depends_on "python@3.13" => :recommended
  depends_on "node" => :recommended

  def install
    # 安装到 /usr/local/Cellar/hermesclaw/0.1.0/libexec
    libexec.install Dir["*"]

    # 创建 hermesclaw 命令
    # 我们需要一个 wrapper 脚本来启动服务
    (bin/"hermesclaw").write <<~EOS
      #!/bin/bash
      HERMES_DIR="#{libexec}"
      CONFIG_DIR="${HOME}/.hermesclaw"

      case "${1:-help}" in
        help|--help|-h)
          cat <<'HELP'
      🐿️ HermesClaw - 多智能体调度器

      命令:
        install       安装依赖
        start         启动服务
        stop          停止服务
        status        查看状态
        config        编辑配置
        doctor        诊断问题

      微信使用:
        无前缀 → 🐿️ 小松鼠 (OpenClaw)
        hm: → ⚡ Hermes
        cherry: → 🍒 Agnes AI
        wb: → 🤖 WorkBuddy
        both: → 🍒 cherry + 🤖 wb
        all: → 所有 Agent
      HELP
          ;;
        install)
          echo "📦 安装依赖..."
          cd "${HERMES_DIR}/router"
          python3 -m venv venv
          source venv/bin/activate
          pip install -r requirements.txt
          cd "${HERMES_DIR}/plugin"
          npm install
          echo "✅ 依赖安装完成"
          ;;
        start)
          echo "🚀 启动 HermesClaw..."
          mkdir -p "${CONFIG_DIR}"
          if [ ! -f "${CONFIG_DIR}/.env" ]; then
            cp "${HERMES_DIR}/config/.env.example" "${CONFIG_DIR}/.env"
            echo "✅ 已创建默认配置: ${CONFIG_DIR}/.env"
          fi
          cd "${HERMES_DIR}/router"
          source venv/bin/activate
          python run.py &
          cd "${HERMES_DIR}/plugin"
          npm start &
          echo "✅ HermesClaw 已启动"
          echo "   Router: http://0.0.0.0:18889"
          echo "   Plugin: http://localhost:3001"
          ;;
        stop)
          echo "⏹ 停止 HermesClaw..."
          pkill -f "hermesclaw_router" || true
          pkill -f "node.*hermesclaw/plugin" || true
          echo "✅ 已停止"
          ;;
        status)
          pgrep -f "hermesclaw_router" > /dev/null && echo "✅ Router 运行中" || echo "❌ Router 未运行"
          pgrep -f "node.*hermesclaw/plugin" > /dev/null && echo "✅ Plugin 运行中" || echo "❌ Plugin 未运行"
          ;;
        config)
          mkdir -p "${CONFIG_DIR}"
          if [ ! -f "${CONFIG_DIR}/.env" ]; then
            cp "${HERMES_DIR}/config/.env.example" "${CONFIG_DIR}/.env"
            echo "✅ 已创建默认配置"
          fi
          echo "配置文件: ${CONFIG_DIR}/.env"
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
      🐿️ HermesClaw 多智能体调度器已安装！

      安装位置: #{opt_libexec}

      使用说明:
        hermesclaw install   - 安装 Python/Node 依赖
        hermesclaw config    - 创建默认配置文件
        hermesclaw start     - 启动 Router + Plugin 服务
        hermesclaw status    - 查看运行状态
        hermesclaw stop      - 停止服务
        hermesclaw doctor    - 诊断问题

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
