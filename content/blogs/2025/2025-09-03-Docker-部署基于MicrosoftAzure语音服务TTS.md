---
title: Docker部署基于 Microsoft Azure 语音服务（TTS）
slug: docker-deployments-are-based-on-microsoft-azure-voice-service-tts-z13xyas
url: >-
  /post/docker-deployments-are-based-on-microsoft-azure-voice-service-tts-z13xyas.html
date: '2025-09-03 09:20:43+08:00'
lastmod: '2025-09-03 15:18:10+08:00'
tags:
  - Docker
  - 软件推荐
keywords: Docker,软件推荐
toc: true
isCJKLanguage: true
---





Reeden是一款功能强大的纯本地电子书阅读器，支持多种格式，提供丰富的阅读体验和个性化设置。它可以导入自定义TTS，今天我就尝试部署开源的Zuoban-TTS，然后导入Reeden进行书籍阅读。

![image](https://img.sdgarden.top/blog/2025/09/image-20250903111749-g78qzay.png)

## 📢 软件介绍

> 一个简单易用的文本转语音 (TTS) 服务，基于 Microsoft Azure 语音服务，提供高质量的语音合成能力。

项目地址：[https://github.com/zuoban/tts](https://github.com/zuoban/tts)

**功能特点**

- 支持多种语言和声音
- 可调节语速和语调
- 支持多种输出音频格式
- 兼容 OpenAI TTS API
- 支持长文本自动分割与合并
- 提供 Web UI 和 RESTful API

![20250903101750](https://img.sdgarden.top/blog/2025/09/20250903101750-20250903101803-sqy5fy2.webp)

## 🖼Docker 部署

NAS 用户推荐 Docker 部署。创建 `docker-compose.yml` 文件。

```bash
services:
  tts:  # 服务名称
    image: zuoban/zb-tts  # 使用的镜像
    container_name: tts  # 容器名称
    ports:
      - "8080:8080"  # 端口映射(主机:容器)
	# volumes:
      # - "./config.yaml:/configs/config.yaml"  # 配置文件
    restart: unless-stopped  # 建议添加自动重启策略

```

​`docker-compose up -d`  启动服务(-d 为后台运行)

部署完成后，访问 [http://localhost:8080]() 使用 Web 界面。

‍

## 💻Cloudflare Worker 部署

熟悉Cloudflare可以使用Worker进行部署。

1. 创建一个新的 Cloudflare Worker：登录 [Cloudflare](https://dash.cloudflare.com/)，点击 Workers -\>Workers & Pages -\>创建 -\>“从 Hello World! 开始” -\>部署，然后编辑。
2. 复制以下脚本内容到 Worker [worker.js](https://github.com/zuoban/tts/blob/main/workers/src/index.js)，预览下方刷新下即可看到部署好的应用。

![20250903094838](https://img.sdgarden.top/blog/2025/09/20250903094838-20250903094859-qevdae2.webp)

3. 添加环境变量 `API_KEY`​

- Workers & Pages -\> Your Worker -\> Settings -\> Variables and Secrets -\> Add
- Type: `Secret`, Name: `API_KEY`, Value: `YOUR_API_KEY`​

![20250903114139](https://img.sdgarden.top/blog/2025/09/20250903114139-20250903114152-t3r6sqi.webp)

- 点击Cloudflare Worker提供的域名链接，输入自己设置的API Key，点击保存就可以使用了。
- 有域名的可以绑定下自己的域名，使用更方便。

## ⚙️ 使用方法

### API 使用

#### 基础 API

```bash
# 基础文本转语音# 基础文本转语音
curl "http://localhost:8080/tts?t=你好，世界&v=zh-CN-XiaoxiaoNeural" -o output.mp3
# 调整语速和语调
curl "http://localhost:8080/tts?t=你好，世界&v=zh-CN-XiaoxiaoNeural&r=20&p=10" -o output.mp3
# 使用情感风格
curl "http://localhost:8080/tts?t=今天天气真好&v=zh-CN-XiaoxiaoNeural&s=cheerful" -o output.mp3
```

#### OpenAI 兼容 API

需要有 openai 的 api key 才能使用。

```bash
curl -X POST "http://localhost:8080/v1/audio/speech" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "tts-1",
    "input": "你好，世界！",
    "voice": "zh-CN-XiaoxiaoNeural",
    "speed": 0.5
  }' -o output.mp3
```

### Reeden 中使用

新建文件 `zuoban-tts.json`，把下面内容复制进去，`http://192.168.3.1:8080` ​设置为自己的地址，保存。

```json
{
	{
		"url": "http://192.168.3.1:8080/v1/audio/speech",
		"name": "Zuoban TTS Yunxi (Male-PublicIpv4)",
		"voice": "zh-CN-YunxiNeural",
		"sex": 1,
		"locale": "zh-CN",
		"group": "Custom Zuoban TTS",
		"tags": ["custom", "chinese", "male"],
		"params": {
			"method": "POST",
			"headers": {
				"Content-Type": "application/json"
			},
			"body": "{\"model\": \"tts-1\", \"input\": \"{{text}}\", \"voice\": \"zh-CN-YunxiNeural\", \"speed\": 1.0}"
		}
	},
	{
		"url": "http://192.168.3.1:8080/v1/audio/speech",
		"name": "Zuoban TTS Yunxi (Male-PublicIpv4)",
		"voice": "zh-CN-YunxiNeural",
		"sex": 1,
		"locale": "zh-CN",
		"group": "Custom Zuoban TTS",
		"tags": ["custom", "chinese", "male"],
		"params": {
			"method": "POST",
			"headers": {
				"Content-Type": "application/json"
			},
			"body": "{\"model\": \"tts-1\", \"input\": \"{{text}}\", \"voice\": \"zh-CN-YunxiNeural\", \"speed\": 1.0}"
		}
	}
}
```

然后在 Reeden 阅读软件中点击：我的-\>语音朗读-\>“...”-\>从文件导入，选择 `zuoban-tts.json`，就可以使用 Zuoban TTS 进行书籍朗读了。

![20250903143131](https://img.sdgarden.top/blog/2025/09/20250903143131-20250903143146-hobqazk.webp)

‍

## 📒 参考文章

1. [https://github.com/zuoban/tts](https://github.com/zuoban/tts)

‍
