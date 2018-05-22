title: Spring Boot中使用RabbitMQ
date: 2017-08-03
categories:
- 技术
- spring boot
tags:
- spring boot
- RabbitMQ
---

> 本博客引用自http://blog.didispace.com/spring-boot-rabbitmq/.
> 作者: 程序猿DD-翟永超 

很久没有写Spring Boot的内容了，正好最近在写Spring Cloud Bus的内容，因为内容会有一些相关性，所以先补一篇关于AMQP的整合。

## Message Broker与AMQP简介

Message Broker是一种消息验证、传输、路由的架构模式，其设计目标主要应用于下面这些场景：

- 消息路由到一个或多个目的地
- 消息转化为其他的表现方式
- 执行消息的聚集、消息的分解，并将结果发送到他们的目的地，然后重新组合相应返回给消息用户
- 调用Web服务来检索数据
- 响应事件或错误
- 使用发布-订阅模式来提供内容或基于主题的消息路由

AMQP是Advanced Message Queuing Protocol的简称，它是一个面向消息中间件的开放式标准应用层协议。AMQP定义了这些特性：

- 消息方向
- 消息队列
- 消息路由（包括：点到点和发布-订阅模式）
- 可靠性
- 安全性

## RabbitMQ

本文要介绍的RabbitMQ就是以AMQP协议实现的一种中间件产品，它可以支持多种操作系统，多种编程语言，几乎可以覆盖所有主流的企业级技术平台。

### 安装

在RabbitMQ官网的下载页面 https://www.rabbitmq.com/download.html 中，我们可以获取到针对各种不同操作系统的安装包和说明文档。这里，我们将对几个常用的平台一一说明。

下面我们采用的Erlang和RabbitMQ Server版本说明：

- Erlang/OTP 19.1
- RabbitMQ Server 3.6.5

### Windows安装

1. 安装Erland，通过官方下载页面 http://www.erlang.org/downloads 获取exe安装包，直接打开并完成安装。
2. 安装RabbitMQ，通过官方下载页面 https://www.rabbitmq.com/download.html 获取exe安装包。
3. 下载完成后，直接运行安装程序。
4. RabbitMQ Server安装完成之后，会自动的注册为服务，并以默认配置启动起来。


### Mac OS X安装

在Mac OS X中使用brew工具，可以很容易的安装RabbitMQ的服务端，只需要按如下命令操作即可：

1. brew更新到最新版本，执行：brew update
2. 安装Erlang，执行：brew install erlang
3. 安装RabbitMQ Server，执行：brew install rabbitmq

通过上面的命令，RabbitMQ Server的命令会被安装到/usr/local/sbin，并不会自动加到用户的环境变量中去，所以我们需要在.bash_profile或.profile文件中增加下面内容：

``` java
PATH=$PATH:/usr/local/sbin
```
这样，我们就可以通过rabbitmq-server命令来启动RabbitMQ的服务端了。

### Ubuntu安装

在Ubuntu中，我们可以使用APT仓库来进行安装

1. 安装Erlang，执行：apt-get install erlang
2. 执行下面的命令，新增APT仓库到/etc/apt/sources.list.d

```java 
echo 'deb http://www.rabbitmq.com/debian/ testing main' |
        sudo tee /etc/apt/sources.list.d/rabbitmq.list
```

3. 更新APT仓库的package list，执行sudo apt-get update命令

4. 安装Rabbit Server，执行sudo apt-get install rabbitmq-server命令

### Rabbit管理

我们可以直接通过配置文件的访问进行管理，也可以通过Web的访问进行管理。下面我们将介绍如何通过Web进行管理。

- 执行rabbitmq-plugins enable rabbitmq_management命令，开启Web管理插件，这样我们就可以通过浏览器来进行管理了。
```bash
> rabbitmq-plugins enable rabbitmq_management
The following plugins have been enabled:
  mochiweb
  webmachine
  rabbitmq_web_dispatch
  amqp_client
  rabbitmq_management_agent
  rabbitmq_management
Applying plugin configuration to rabbit@PC-201602152056... started 6 plugins.
```

- 打开浏览器并访问：`http://localhost:15672/`，并使用默认用户`guest`登录，密码也为`guest`。我们可以看到如下图的管理页面：
![image](https://cdn.xiangyingbaobao.com/xybb/portal/2018/5/263aab74d50ee4dd1e67a5ea62784b5a.png)

从图中，我们可以看到之前章节中提到的一些基本概念，比如：Connections、Channels、Exchanges、Queue等。第一次使用的读者，可以都点开看看都有些什么内容，熟悉一下RabbitMQ Server的服务端。

- 点击Admin标签，在这里可以进行用户的管理。

### Spring Boot整合

下面，我们通过在Spring Boot应用中整合RabbitMQ，并实现一个简单的发送、接收消息的例子来对RabbitMQ有一个直观的感受和理解。

在Spring Boot中整合RabbitMQ是一件非常容易的事，因为之前我们已经介绍过Starter POMs，其中的AMQP模块就可以很好的支持RabbitMQ，下面我们就来详细说说整合过程：

- 新建一个Spring Boot工程，命名为：“rabbitmq-hello”。
- 在pom.xml中引入如下依赖内容，其中spring-boot-starter-amqp用于支持RabbitMQ。
```xml
<parent>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-parent</artifactId>
    <version>1.3.7.RELEASE</version>
    <relativePath/> <!-- lookup parent from repository -->
</parent>
<dependencies>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-amqp</artifactId>
    </dependency>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-test</artifactId>
        <scope>test</scope>
    </dependency>
</dependencies>

```

- 在application.properties中配置关于RabbitMQ的连接和用户信息，用户可以回到上面的安装内容，在管理页面中创建用户。
``` java
spring.application.name=rabbitmq-hello
spring.rabbitmq.host=localhost
spring.rabbitmq.port=5672
spring.rabbitmq.username=spring
spring.rabbitmq.password=123456
```

- 创建消息生产者Sender。通过注入AmqpTemplate接口的实例来实现消息的发送，AmqpTemplate接口定义了一套针对AMQP协议的基础操作。在Spring Boot中会根据配置来注入其具体实现。在该生产者，我们会产生一个字符串，并发送到名为hello的队列中。
```java
@Component
public class Sender {
    @Autowired
    private AmqpTemplate rabbitTemplate;
    public void send() {
        String context = "hello " + new Date();
        System.out.println("Sender : " + context);
        this.rabbitTemplate.convertAndSend("hello", context);
    }
}

```

- 创建消息消费者Receiver。通过@RabbitListener注解定义该类对hello队列的监听，并用@RabbitHandler注解来指定对消息的处理方法。所以，该消费者实现了对hello队列的消费，消费操作为输出消息的字符串内容。
```java
@Component
@RabbitListener(queues = "hello")
public class Receiver {
    @RabbitHandler
    public void process(String hello) {
        System.out.println("Receiver : " + hello);
    }
}
```

- 创建RabbitMQ的配置类RabbitConfig，用来配置队列、交换器、路由等高级信息。这里我们以入门为主，先以最小化的配置来定义，以完成一个基本的生产和消费过程。
```java
@Configuration
public class RabbitConfig {
    @Bean
    public Queue helloQueue() {
        return new Queue("hello");
    }
}
```

- 创建应用主类：
```java
@SpringBootApplication
public class HelloApplication {
    public static void main(String[] args) {
        SpringApplication.run(HelloApplication.class, args);
    }
}
```

- 创建单元测试类，用来调用消息生产：
```java
@RunWith(SpringJUnit4ClassRunner.class)
@SpringApplicationConfiguration(classes = HelloApplication.class)
public class HelloApplicationTests {
    @Autowired
    private Sender sender;
    @Test
    public void hello() throws Exception {
        sender.send();
    }
}
```

完成程序编写之后，下面开始尝试运行。首先确保RabbitMQ Server已经开始，然后进行下面的操作：

- 启动应用主类，从控制台中，我们看到如下内容，程序创建了一个访问127.0.0.1:5672中springcloud的连接。
```java
o.s.a.r.c.CachingConnectionFactory       : Created new connection: SimpleConnection@29836d32 [delegate=amqp://springcloud@127.0.0.1:5672/]
```
同时，我们通过RabbitMQ的控制面板，可以看到Connection和Channels中包含当前连接的条目。

- 运行单元测试类，我们可以看到控制台中输出下面的内容，消息被发送到了RabbitMQ Server的hello队列中。
```java
Sender : hello Sun Sep 25 11:06:11 CST 2016
```

- 切换到应用主类的控制台，我们可以看到类似如下输出，消费者对hello队列的监听程序执行了，并输出了接受到的消息信息。
```java
Receiver : hello Sun Sep 25 11:06:11 CST 2016
```

通过上面的示例，我们在Spring Boot应用中引入`spring-boot-starter-amqp`模块，进行简单配置就完成了对RabbitMQ的消息生产和消费的开发内容。然而在实际应用中，我们还有很多内容没有演示，这里不做更多的讲解，读者可以自行查阅RabbitMQ的官方教程，有更全面的了解。

完整示例：Chapter5-2-1

开源中国：http://git.oschina.net/didispace/SpringBoot-Learning/tree/master/Chapter5-2-1
GitHub：https://github.com/dyc87112/SpringBoot-Learning/tree/master/Chapter5-2-1