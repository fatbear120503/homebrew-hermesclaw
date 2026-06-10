class Hermesclaw < Formula
  desc "AI multi-agent dispatcher - 多智能体调度器"
  homepage "https://github.com/fatbear120503/hermesclaw"
  version "1.0.0"
  
  url "https://github.com/fatbear120503/hermesclaw/releases/download/v1.0.0/HermesClaw-1.0.0.pkg"
  sha256 "5c3fd4ebdbee8016832b5ba85259e5958ed92488472cf50edc2f36408fd24a12"
  
  depends_on "docker" => :recommended
  depends_on "docker-compose" => :recommended
  depends_on "llama.cpp" => :recommended
  depends_on "python@3.11" => :build
  
  def install
    prefix.install Dir["*"]
    bin.install_symlink prefix/"bin/hermesclaw" if (prefix/"bin/hermesclaw").exist?
    (etc/"hermesclaw").mkpath
  end
  
  def caveats
    <<~EOS
      🐿️ HermesClaw 已安装！

      快速开始:
        hermesclaw help        查看帮助
        hermesclaw onboard     初始化配置和模型
        hermesclaw start       启动服务

      配置文件: ~/.hermesclaw/.env
      更多信息: https://github.com/fatbear120503/hermesclaw
    EOS
  end
end
