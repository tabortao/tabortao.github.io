---
title: Minio分布式对象存储部署及PicList图床设置
slug: >-
  minio-distributed-object-storage-deployment-and-piclist-graph-bed-setting-z2bsjvr
url: >-
  /post/minio-distributed-object-storage-deployment-and-piclist-graph-bed-setting-z2bsjvr.html
date: '2025-08-18 14:30:02+08:00'
lastmod: '2025-08-18 16:44:04+08:00'
tags:
  - Docker
  - 软件推荐
keywords: Docker,软件推荐
toc: true
isCJKLanguage: true
---





哈喽，各位互联网“冲浪儿”和数据存储爱好者们！ 每天和图片打交道，你是否遇到过这些糟心事：免费图床动不动就限制流量、图片加载慢如蜗牛？购买的云存储又感觉每年都在“割肉”？更重要的是，数据隐私和主权，难道不应该牢牢掌握在自己手中吗？

别担心！今天，我就来给大家介绍一个完美的解决方案：**Minio 分布式对象存储** + **PicList 图床工具**！这套组合拳能让你搭建一个完全属于自己的、高性能、高可用的私有图床，彻底告别图床的烦恼，把图片数据完全掌握在自己手里！

废话不多说，让我们一起动手，打造属于你自己的数据堡垒吧！

## 📢软件介绍

在动手之前，我们先来聊聊为什么 Minio 值得你的投入：

1. **数据主权，完全掌控：**  照片、重要文件都存在第三方服务器上，你真的放心吗？Minio 让你将数据存储在自己的物理服务器或 VPS 上，拥有数据的绝对控制权。
2. **S3 兼容，生态丰富：**  Minio 完整兼容亚马逊 S3™ 云存储服务的 API 接口。这意味着你可以无缝对接市面上几乎所有支持 S3 的工具和应用，PicList 只是其中之一！
3. **分布式架构，高可用可扩展：**  顾名思义，“分布式”是 Minio 的一大亮点。它支持将数据分散存储在多台服务器上，通过纠删码（Erasure Code）机制，即使部分硬盘或服务器故障，数据依然能够完整恢复，大大提升了存储的可靠性和可用性。未来需要扩展存储容量时也更方便。
4. **成本效益，一劳永逸：**  一次投入服务器硬件或租用服务器，后期基本没有额外的存储费用。长期来看，比购买商业云存储划算得多，尤其是像图床这种需要长期存储大量“小文件”的场景。
5. **高性能，访问飞速：**  Minio 专为高性能而设计，无论是上传还是下载，速度都非常快，能为你的网站或应用提供流畅的图片访问体验。

总之，Minio 是一个兼顾性能、可靠、安全、经济的自建存储方案，非常适合作为个人或小型团队的私有图床。**不过，自2025年6月，MinIO官方删除了11万行**​**​`Web 控制台`​**​**相关代码，功能大打折扣，推荐大家使用2025年4月22日及之前版本，最好把docker库也备份下。**

项目地址：[https://github.com/minio/minio](https://github.com/minio/minio)

## 🛠️ Minio 分布式对象存储部署

虽然标题是“分布式”，但为了方便大家理解和快速上手，我们将展示一个基于 **Docker Compose** 的**单节点 Minio 部署**方案。这足以满足大多数个人用户的需求，并且你可以随时根据需求扩展到真正的多节点分布式集群。

### **准备工作：**

1. **一台安装了 Docker 和 Docker Compose 的 Linux 服务器 (推荐)。**  （Windows 或 macOS 也可以，但生产环境通常用 Linux。）
2. **足够的硬盘存储空间**，用于存放你的图片数据。
3. **了解端口映射和文件路径。**

### **部署步骤：**

#### **第一步：创建数据存储目录**

在你的服务器上选择一个位置，创建用于存放 Minio 数据的目录。例如：

```bash
mkdir -p /docker/minio/minio_data
mkdir -p /docker/minio/minio_config # 用于存放Minio的配置
```

#### **第二步：创建 Docker Compose 文件**

在 `/opt/minio/` 目录下创建一个 `docker-compose.yml` 文件：

```yaml
services:
  minio:
    image: minio/minio:RELEASE.2025-04-22T22-12-26Z # 不要使用最新版
    container_name: minio
    restart: unless-stopped
    environment:
      - TZ=Asia/Shanghai
      - MINIO_ROOT_USER=minioadminuser # 管理员账号
      - MINIO_ROOT_PASSWORD=minioadminpassword # 管理员密码
    ports:
      - 9000:9000 # Minio API端口 (供PicList等工具访问)
      - 9001:9001 # Minio 控制台端口 (Web界面)
    volumes:
      - ./minio_data:/data
      - ./minio_config:/root/.minio
    command: minio server /data --console-address ":9001"
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:9000/minio/health/live"]
      interval: 15s
      timeout: 10s
      retries: 5

networks:
  app-tier:
    driver: bridge
```

**一点说明：**

- ​`MINIO_ROOT_USER` 和 `MINIO_ROOT_PASSWORD` 是你管理 Minio 的超级管理员账号和密码，**务必修改成复杂且安全的密码！**
- ​`9000` 端口是 Minio 的数据 API 端口，PicList 等工具会通过这个端口访问。
- ​`9001` 端口是 Minio 的 Web 控制台端口，你可以在浏览器管理 Minio。
- ​`/minio_data` 是 Minio 在容器内部存储数据的默认路径，我们通过 `volumes` 映射到宿主机的 `/opt/minio/data`。
- **关于分布式部署：**  这个 `docker-compose.yml` 是单节点部署。如果需要部署真正的分布式 Minio，`command` 会改为 `minio server /data{1...N}` 或指定多个盘符，并且需要多台服务器协同工作，每台服务器上的 Minio 实例通过 `MINIO_VOLUMES` 指定其负责的存储路径。对于个人私有图床，单节点部署已足够强大。

#### **第三步：启动 Minio 服务**

在 `/opt/minio/` 目录下执行以下命令：

```bash
docker-compose up -d
```

​`-d` 参数表示在后台运行。

#### **第四步：访问 Minio 控制台**

打开你的浏览器，访问 `http://你的服务器IP:9001`。  
使用你在 `docker-compose.yml` 中设置的 `MINIO_ROOT_USER` 和 `MINIO_ROOT_PASSWORD` 登录。

登录后，你可以在界面上创建“桶 (Bucket)”，桶就是你存储文件的容器。

## ⚙️MinIO设置

### 创建用户并设置Access Key

点击Identity-Users-Create User，创建用户

![20250818161317_PixPin](https://img.sdgarden.top/blog/2025/08/20250818161317_PixPin-20250818161327-ngo5j3v.webp)

点击用户名-Create Access Key，设置访问权限。

![20250818161507_PixPin](https://img.sdgarden.top/blog/2025/08/20250818161507_PixPin-20250818161520-4pwktco.webp)

记录好创建的Access Key 和Secret Key。

![20250818161612_PixPin](https://img.sdgarden.top/blog/2025/08/20250818161612_PixPin-20250818161625-03amjfh.webp)

### 创建存储桶并设置权限

点击Buckets，创建存储桶，例如命名为 `images`。

![20250818160845_PixPin](https://img.sdgarden.top/blog/2025/08/20250818160845_PixPin-20250818161046-a7std6v.webp)

为存储桶设置权限为public（作为图床使用时，需设置为Public）

![20250818160927_PixPin](https://img.sdgarden.top/blog/2025/08/20250818160927_PixPin-20250818161055-fzydasm.webp)

## 🌐域名及反向代理

- NPS进行内网穿透，需要把9000、9001都进行穿透
- 服务器开放9000、9001端口
- 1Panel进行反向代理，https://minio.yuming.com 反向代理9001，Minio 控制台端口 (Web界面)；https://img.yuming.com 反向代理9000，Minio API端口 (供PicList等工具访问)。

## 🖼️ PicList 图床设置

现在 Minio 对象存储已经部署好了，接下来我们把上传工具 PicList 和它连接起来。PicList 是备受推崇的跨平台图床管理工具，它功能强大，插件丰富，支持多种图床，当然也完美兼容 Minio，设置如下：

![20250818162314_PixPin](https://img.sdgarden.top/blog/2025/08/20250818162314_PixPin-20250818162322-mshw0om.webp)

![20250818162530_PixPin](https://img.sdgarden.top/blog/2025/08/20250818162530_PixPin-20250818162542-14ie4qj.webp)

---

## ✅ 总结与展望

恭喜你！到这里，你已经成功部署了 Minio 分布式对象存储，并将其与 PicList 连接，搭建了属于你自己的私有图床。从此，你的图片上传将变得更自主、更安全、更高效！

这套方案不仅适用于图片，你还可以用 Minio 存储各种文件，比如文档、视频、备份数据等等。结合 Minio 强大的 S3 兼容性，你可以探索更多应用场景，例如：

- **静态网站托管：**  将网站文件放到 Minio 上，通过 Nginx 反向代理或 CDN 实现快速访问。
- **Web 应用存储：**  将用户上传的文件、应用程序日志等存储到 Minio。
- **备份和归档：**  低成本地备份你的重要数据。

Minio 和 PicList 的组合，为你提供了强大的数据管理能力，让你真正掌握自己的数字资产。

## 📒参考文章

1. [部署私有对象存储服务: Minio](https://ysicing.me/tools/minio-deploy)
2. [MinIO最新社区版砍掉 Web 管理功能](https://ysicing.me/minio-2025-5-24)
3. [不想白了，自己动手搭个图床MinlO+PicGo+Typora](https://mp.weixin.qq.com/s/e-8gIpY8L5Ij_K-bEVFV3Q)

---

**如果你有任何疑问，或者在部署过程中遇到了问题，欢迎在评论区留言交流！让我们一起在数据自由的道路上越走越远！🚀 欢迎在评论区留言和大家一起交流！喜欢记得关注【可持续学园】，我们下期再见！**   👇

![微信公众号](https://img.sdgarden.top/blog/2025/08/%E5%BE%AE%E4%BF%A1%E5%85%AC%E4%BC%97%E5%8F%B7-20250813124220-913xdfk.webp)
