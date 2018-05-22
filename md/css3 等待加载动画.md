---
title: css3 等待加载动画
date: 2018-05-22
categories:
- 技术
- css
tags:
- css3
- svg
- animation
- 动画
---

## 加载动画
这是一个类似于google加载图标的css3动画实现

## 效果演示
<style>
    @keyframes color {
        100%, 0% {
            stroke: #9c27b0;
        }
        50% {
            stroke: #ff9800;
        }
        100% {
            stroke: #9c27b0;
        }
    }
    @keyframes dash {
        0% {
            stroke-dasharray: 1, 200;
            stroke-dashoffset: 0;
        }
        50% {
            stroke-dasharray: 89, 200;
            stroke-dashoffset: -35px;
        }
        100% {
            stroke-dasharray: 89, 200;
            stroke-dashoffset: -124px;
        }

    }
    .loader:before {
        content: '';
        display: block;
        padding-top: 100%;
    }
    .loader {
        margin: 0 auto;
        width: 60px;
        position: absolute;
        display: block;
        left: 0;
        right: 0;
        z-index: 1;
        -webkit-transform: translate3d(0, -50%, 0);
        transform: translate3d(0, -50%, 0);
        text-align: center;
        top: 50%;
    }
    .circular {
        -webkit-animation: rotate 2s linear infinite;
        animation: rotate 2s linear infinite;
        height: 100%;
        -webkit-transform-origin: center center;
        transform-origin: center center;
        width: 100%;
        position: absolute;
        top: 0;
        bottom: 0;
        left: 0;
        right: 0;
        margin: auto;
    }
    .path {
        stroke-dasharray: 1, 200;
        stroke-dashoffset: 0;
        -webkit-animation: dash 1.5s ease-in-out infinite, color 2s ease-in-out infinite;
        animation: dash 1.5s ease-in-out infinite, color 2s ease-in-out infinite;
        stroke-linecap: round;
    }
</style>
<div class="loader">
    <svg class="circular" viewBox="25 25 50 50"><circle class="path" cx="50" cy="50" r="20" fill="none" stroke-width="2" stroke-miterlimit="10"></circle></svg>
</div>

## 源码
```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Title</title>
    <style>
        @keyframes color {
            100%, 0% {
                stroke: #9c27b0;
            }
            50% {
                stroke: #ff9800;
            }
            100% {
                stroke: #9c27b0;
            }
        }
        @keyframes dash {
            0% {
                stroke-dasharray: 1, 200;
                stroke-dashoffset: 0;
            }
            50% {
                stroke-dasharray: 89, 200;
                stroke-dashoffset: -35px;
            }
            100% {
                stroke-dasharray: 89, 200;
                stroke-dashoffset: -124px;
            }

        }
        .loader:before {
            content: '';
            display: block;
            padding-top: 100%;
        }
        .loader {
            margin: 0 auto;
            width: 60px;
            position: absolute;
            display: block;
            left: 0;
            right: 0;
            z-index: 1;
            -webkit-transform: translate3d(0, -50%, 0);
            transform: translate3d(0, -50%, 0);
            text-align: center;
            top: 50%;
        }
        .circular {
            -webkit-animation: rotate 2s linear infinite;
            animation: rotate 2s linear infinite;
            height: 100%;
            -webkit-transform-origin: center center;
            transform-origin: center center;
            width: 100%;
            position: absolute;
            top: 0;
            bottom: 0;
            left: 0;
            right: 0;
            margin: auto;
        }
        .path {
            stroke-dasharray: 1, 200;
            stroke-dashoffset: 0;
            -webkit-animation: dash 1.5s ease-in-out infinite, color 2s ease-in-out infinite;
            animation: dash 1.5s ease-in-out infinite, color 2s ease-in-out infinite;
            stroke-linecap: round;
        }
    </style>
</head>
<body>
<div class="loader">
    <svg class="circular" viewBox="25 25 50 50">
        <circle class="path" cx="50" cy="50" r="20" fill="none" stroke-width="2" stroke-miterlimit="10"></circle>
    </svg>
</div>

</body>
</html>
```