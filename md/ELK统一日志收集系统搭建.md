---
title: ELK统一日志收集系统搭建
date: 2019-07-09
categories:
- 技术
- elk
tags:
- elastic
- logstash
- kibana
- filebeat
---

## 安装软件
分别安装 `elasticsearch`、`logstash`、`kibana`、`filebeat`

- elasticsearch https://www.elastic.co/cn/downloads/elasticsearch
- logstash https://www.elastic.co/cn/downloads/logstash
- kibana https://www.elastic.co/cn/downloads/kibana
- filebeat https://www.elastic.co/cn/downloads/beats/filebeat

## 配置`filebeat`
`filebeat`的配置文件位置按具体的安装方式不同有所不同。假设你的安装方式是`rpm`，编辑`sudo vim /etc/filebeat/filebeat.yml`
#### 配置所要搜集的日志文件目录
```yml
filebeat.inputs:

# Each - is an input. Most options can be set at the input level, so
# you can use different inputs for various configurations.
# Below are the input specific configurations.

- type: log

  # Change to true to enable this input configuration.
  enabled: true

  # Paths that should be crawled and fetched. Glob based paths.
  paths:
    - /arthas/sites/log/mk-trade-service/*.log
    #- c:\programdata\elasticsearch\logs\*
```
#### 配置多行合并
多行合并在`java`中最常见的就是异常堆栈信息打印，就像这样：
```log
        at org.apache.tomcat.util.net.SocketProcessorBase.run(SocketProcessorBase.java:49)
        at java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1149)
        at java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:624)
        at org.apache.tomcat.util.threads.TaskThread$WrappingRunnable.run(TaskThread.java:61)
        at java.lang.Thread.run(Thread.java:748)
Caused by: java.lang.NumberFormatException: For input string: "jim"
        at java.lang.NumberFormatException.forInputString(NumberFormatException.java:65)
        at java.lang.Integer.parseInt(Integer.java:580)
        at java.lang.Integer.parseInt(Integer.java:615)
        at com.alibaba.fastjson.util.TypeUtils.castToInt(TypeUtils.java:711)
        at com.alibaba.fastjson.serializer.IntegerCodec.deserialze(IntegerCodec.java:95)
        ... 92 more
```
如下配置可以将日志和这些堆栈信息视为同一条记录：
```yaml
  # The regexp Pattern that has to be matched. The example pattern matches all lines starting with [
  multiline.pattern: '^[[:space:]]+(at|\.{3}\s+\d+\s+more)|^Caused by:'

  # Defines if the pattern set under pattern should be negated or not. Default is false.
  multiline.negate: false

  # Match can be set to "after" or "before". It is used to define if lines should be append to a pattern
  # that was (not) matched before or after or as long as a pattern is not matched based on negate.
  # Note: After is the equivalent to previous and before is the equivalent to to next in Logstash
  multiline.match: after
```

#### 一些必要的标明日志所在服务的信息
比如：我定义了一个`service`字段，用来表示日志所在的服务。这个字段待会会在`logstash`中使用到。
```yaml
fields:
  service: mk-trade-service-t2
```

#### output logstash
定义日志输出的`logstash`地址。
```yaml
#----------------------------- Logstash output --------------------------------
output.logstash:
  # The Logstash hosts
  hosts: ["10.188.56.57:5046"]
```

## 配置`logstash`
`logstash`配置主要是配置`logstash.conf`。`rpm`安装的话，一般在`/etc`目录下。我是`docker`安装的，目录是挂载的，没啥参考意义。

#### 配置监听的`beat`端口
一般就默认端口了。
```yaml
input {
  beats {
    port => 5044
  }
}
```

#### 配置输出到`elastic`
这里用上了我们在`filebeat`中定义的`service`, 这样读取`%{[fields][service]}` 。
```yml
output {
  elasticsearch {
    hosts => "10.188.56.239:9200"
    manage_template => false
    index => "%{[fields][service]}-%{[@metadata][beat]}-%{[@metadata][version]}-%{+YYYY.MM.dd}"
    document_type => "%{[@metadata][type]}"
  }
}
```

#### 过滤 `filter`

过滤很重要我们的日志会有很多意义，提取其中的数据用于查询可以让我们快速定位`bug`。
```yaml
filter {
  grok {
    match => { "message" => "\A(?<timestamp>(?:%{YEAR}-%{MONTHNUM}-%{MONTHDAY}[T ]%{HOUR}:?%{MINUTE}(?::?%{SECOND})?\s+%{NUMBER}?))\s+%{LOGLEVEL:loglevel}\s+%{NUMBER:pid}\s+(?<thread>(?:[a-zA-Z0-9-]+))\s+(?<traceId>[a-zA-Z0-9-]+)\s+(?<method>(?:[a-zA-Z0-9.]+))\s*: %{DATA:logMessage}({({[^}]+},?\s*)*})?\s*$(?<stacktrace>(?m:.*))?" }
  }
  date {
    match => ["timestamp", "yyyy-MM-dd HH:mm:ss SSS"]
    target => "@timestamp"
  }
  mutate {
    remove_field => ["timestamp"]
  }
```

`grok`的作用就是帮助我们匹配并提取字段的，我商品定义的`match`匹配的是java日志信息，匹配的内容你们可以参考下：
```log
2019-07-09 13:39:31 490 ERROR 22938 http-nio-8100-exec-6 af7bfe32826f7ce8 c.m.trade.configure.ParamDebugConfigure : 调用方法：com.mkf.trade.service.TradeServiceImpl.calOrder
2019-07-09 13:39:31 490 ERROR 22938 http-nio-8100-exec-6 af7bfe32826f7ce8 c.m.trade.configure.ParamDebugConfigure : PARAM: [{"cid":1201,"couponUniqueId":0,"itemList":"[{'id': 1, 'skuId': 1, 'activityId': 1, 'activityUniqueId': 1, 'activityUniqueKey': 'key', 'quantity': 1, 'invitationCode':654656, 'inviterType':'shop', 'inviterUid':'jim','towerShopInviterId': 'sdf565464', 'towerShopRegisterAccount': '13488709024', 'passwordKey': 'UIkksldfk666', 'towerShareKey': 'h97846s000'}]","shopId":100018,"usePoints":false,"zipcode":"string"}]
2019-07-09 13:39:31 491 ERROR 22938 http-nio-8100-exec-6 af7bfe32826f7ce8 c.m.e.resolve.RpcMkExceptionHandler     : 系统错误：com.alibaba.fastjson.JSONException: parseInt error, field : inviterUid
        at com.alibaba.fastjson.serializer.IntegerCodec.deserialze(IntegerCodec.java:99)
        at com.alibaba.fastjson.parser.deserializer.DefaultFieldDeserializer.parseField(DefaultFieldDeserializer.java:86)
        at com.alibaba.fastjson.parser.deserializer.JavaBeanDeserializer.parseField(JavaBeanDeserializer.java:1172)
        at com.alibaba.fastjson.parser.deserializer.JavaBeanDeserializer.deserialze(JavaBeanDeserializer.java:822)
        at com.alibaba.fastjson.parser.deserializer.JavaBeanDeserializer.parseRest(JavaBeanDeserializer.java:1414)
        at com.alibaba.fastjson.parser.deserializer.FastjsonASMDeserializer_6_ShoppingCartItemVo.deserialze(Unknown Source)
        at com.alibaba.fastjson.parser.deserializer.JavaBeanDeserializer.deserialze(JavaBeanDeserializer.java:269)
        at com.alibaba.fastjson.parser.DefaultJSONParser.parseArray(DefaultJSONParser.java:758)
        at com.alibaba.fastjson.parser.DefaultJSONParser.parseArray(DefaultJSONParser.java:692)
        at com.alibaba.fastjson.parser.DefaultJSONParser.parseArray(DefaultJSONParser.java:687)
        at com.alibaba.fastjson.JSON.parseArray(JSON.java:538)
Caused by: java.lang.NumberFormatException: For input string: "jim"
        at java.lang.NumberFormatException.forInputString(NumberFormatException.java:65)
        at java.lang.Integer.parseInt(Integer.java:580)
        at java.lang.Integer.parseInt(Integer.java:615)
        at com.alibaba.fastjson.util.TypeUtils.castToInt(TypeUtils.java:711)
        at com.alibaba.fastjson.serializer.IntegerCodec.deserialze(IntegerCodec.java:95)
        ... 92 more
```
推荐一个在线测试grok的网站：http://grokconstructor.appspot.com/do/match#result

下面这个作用是用提取的`timestamp` 替换 `@timestamp`字段，目的就是为了让`@timestamp`（这个字段会自动生成，使用的是收集日志的时间，和日志时间会有一点误差）的时间和日志时间完全一致
```yaml
date {
    match => ["timestamp", "yyyy-MM-dd HH:mm:ss SSS"]
    target => "@timestamp"
  }
```

删除不用的字段``timestamp`
```yaml
mutate {
    remove_field => ["timestamp"]
  }
```

## 配置`kibana`
`kibana`是用来展示我们的日志的，但是还是需要一些配置来获得更好的用户体验。
这里就不上图了，列一下几个要点。

- Management/Advanced Settings 配置时区和时间格式化
- Management/Saved Objects 配置排序方式
- Management/Index Patterns 配置特定时间字段的格式化。还可以刷新字段列表

