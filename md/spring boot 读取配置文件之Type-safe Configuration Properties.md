title: spring boot 读取配置文件之Type-safe Configuration Properties
categories:
- 技术
- spring boot
tags:
- spring boot
- Type-safe Configuration Properties
- 自动装载配置到bean
---
{% blockquote spring boot http://docs.spring.io/spring-boot/docs/1.5.2.RELEASE/reference/htmlsingle/ 1.5.2.RELEASE %}
官方文档章节 24. Externalized Configuration  24.7 Type-safe Configuration Properties
{% endblockquote %}

##### 这是spring boot加载自己的配置文件的一种方式, 通过翻译来看, spring boot称之为类型安全的配置文件

## 原理是通过一个限定配置前缀的class加载配置, 代码中前缀为’hjs’

``` java
package com.junsom;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

/**
 *
 * @Version: 1.0
 * @ProjectName:configurationPropertiesDemo
 * @PackageName: PACKAGE_NAME
 * @Author: hejunsong  何俊松
 * @Email: hejunsong@yicaikeji.com
 * @Date: 2017/3/5 17:53
 * @Copyright (c) 2017, hejunsong@yicaikeji.com All Rights Reserved.
 */
@Component
@ConfigurationProperties("hjs")
public class HeJunsong {
    private String name;
    private Boolean test;

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Boolean getTest() {
        return test;
    }

    public void setTest(Boolean test) {
        this.test = test;
    }
}
```
## 通过@Configuration注解类上添加

`@PropertySource(value = “test.properties”)`
`@EnableConfigurationProperties(value = {HeJunsong.class})`分别引入`test.properties`文件,注入到`HeJunsong.class`中

```java
package com.junsom.configure;

import com.junsom.HeJunsong;

import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.PropertySource;

/**
 *
 * @Version: 1.0
 * @ProjectName:configurationPropertiesDemo
 * @PackageName: com.junsom.configure
 * @Author: hejunsong  何俊松
 * @Email: hejunsong@yicaikeji.com
 * @Date: 2017/3/5 17:56
 * @Copyright (c) 2017, hejunsong@yicaikeji.com All Rights Reserved.
 */
@Configuration
@PropertySource(value = "test.properties")
// 在某些版本@EnableConfigureationProperties与@Component会产生冲突,可以只用一个
//@EnableConfigurationProperties(value = {HeJunsong.class})
public class Configure {

}
```
## 配置文件内容如下
``` java
hjs.name=何俊松
hjs.test=true
```

## 使用配置好的bean

```java
package com.junsom;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 *
 * @Version: 1.0
 * @ProjectName:configurationPropertiesDemo
 * @PackageName: com.junsom
 * @Author: hejunsong  何俊松
 * @Email: hejunsong@yicaikeji.com
 * @Date: 2017/3/5 18:00
 * @Copyright (c) 2017, hejunsong@yicaikeji.com All Rights Reserved.
 */
@SpringBootApplication
@RestController
@ComponentScan(basePackages = {"com.junsom"})
public class JunsomMain {
    @Autowired private HeJunsong heJunsong;

    public static void main(String[] args) throws Exception {
        SpringApplication.run(JunsomMain.class, args);
    }

    @GetMapping("hjs")
    public HeJunsong getHeJunsong() {
        return heJunsong;
    }
}
```
