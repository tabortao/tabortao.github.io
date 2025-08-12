---
title: Docker搭建个人版文件传输助手-VoceChat
slug: docker-builds-personal-version-file-transfer-assistantvocechat-2an7i3
url: >-
  /post/docker-builds-personal-version-file-transfer-assistantvocechat-2an7i3.html
date: '2025-08-06 10:42:39+08:00'
lastmod: '2025-08-12 19:01:16+08:00'
tags:
  - Docker
keywords: Docker
toc: true
isCJKLanguage: true
---



![20250806112442_PixPin](http://127.0.0.1:58604/assets/20250806112442_PixPin-20250806112519-9v4n56j.webp)



　　**微信文件传输助手**，传输文件时比较麻烦，最近在想是不是可以自己写个小网页，实现类似的文件传送功能，要用的时候点开网页，输入文字、传输图片、文件等，不想要的文件点击删除即可。正打算干的时候，尝试搜搜有没有类似的产品，就找到了VoceChat，很符合自己的预期。私有部署到自己的NAS，可以创建私有群组或公有频道，手机客户端、电脑客户端、网页端样样俱全。创建一个公共频道，把想要的文件放进去，不需要登陆，就可以查收文件。私有的文件可以私聊或群组中发送，还可以阅后即焚、定期删除。

- **用来收集资料：** 新建一个账号、一个频道（私有或公有都可以，看自己需求），发给大家，大家登录账号传输文件到频道。
- **用来分享资料：** 新建一个临时的公共频道，设置频道文件过几天删除，把要分享的资料上传到频道，发链接给对方，过期后文件自动删除。
- **公告/产品发布：** 新建一个只读公共频道，发布公共或产品更新情况，对外别人可以看到，登录也不能评论，只给看看。
- 还有更多好玩的用法，等你来发现……

　　‍

## 📢软件介绍

> ​`VoceChat` 是一款支持独立部署的个人云社交媒体聊天服务。15MB 的大小可部署在任何的服务器上，部署简单，很少需要维护。前端可以内嵌到自己的网站下，数据完全由用户自己掌握，传输过程加密。VoceChat 从 `Slack`, `Discord`, `RocketChat`, `Solid`, `Matrix` 等产品和规范中博采众长，适用于团队内部交流，个人聊天服务，网站客服，网站内嵌社区的场景。

　　项目地址：[github.com/Privoce](https://github.com/Privoce)

　　官网：[https://voce.chat/](https://voce.chat/)

## 🖼软件截图

![20250806112442_PixPin](http://127.0.0.1:58604/assets/20250806112442_PixPin-20250806112519-9v4n56j.webp)

　　‍

![20250806105320_PixPin](http://127.0.0.1:58604/assets/20250806105320_PixPin-20250806105324-fqov0zy.webp)

## 💻下载地址

### Docker 部署

　　新建`docker-compose.yml`文件，放入到docker目录后执行`docker compose up -d`。

```bash
services:
  vocechat:
	container_name:vocechat
    image: privoce/vocechat-server:latest
    restart: always       # 自动重启
    ports:
      - "3000:3000"       # 暴露端口
    volumes:
      - ./data:/home/vocechat-server/data   # 数据存储到本地目录
```

## 应用下载

　　访问官网下载即可：[https://voce.chat/](https://voce.chat/)

## 消息提醒设置

　　官网消息提醒设置（[Firebase设置 &amp; 通知 | VoceChat](https://doc.voce.chat/zh-cn/setting/setting-firebase-notification)）有问题，我参考其做了些修改，消息提醒需要电脑可访问Google。

1. 从 Firebase 控制台获取配置文件 访问 [Firebase Console](https://console.firebase.google.com/)。点击左侧边栏偏上的齿轮图标进入 **Project Settings，** 没有项目的时候需要自己先新建一个项目。

![20250806145731_PixPin](http://127.0.0.1:58604/assets/20250806145731_PixPin-20250806145733-bgmuy1d.webp)

2. 随后在页面上方的横向选项卡中，选择 **云消息传递**。 下拉页面至最下，点击 **Generate new private key**，并复制密钥对和密钥。

![20250806145937_PixPin](http://127.0.0.1:58604/assets/20250806145937_PixPin-20250806145940-onljs2y.webp)

3. 在VoceChat客户端设置—Firebase中选择**自定义**，Token地址写上一步的**密钥对，** 项目ID写创建项目时候的**项目ID，** 私有密钥写上一步的**密钥。**

![20250806150120_PixPin](http://127.0.0.1:58604/assets/network-asset-20250812190120377-20250812190257-6zvxve0.webp)

## 📒参考文章

1. [Docker部署私有聊天应用vocechat文件传输助手_NAS存储_什么值得买](https://post.smzdm.com/p/apv69n39/)
2. [VoceChat：真正“小而美”的私人聊天系统 - 知乎](https://zhuanlan.zhihu.com/p/673880938?share_code=JP21oXF3xirj&utm_psn=1936209359626548393)
