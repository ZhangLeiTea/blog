# 变量

## 1. 分类

- local variable
  - 只能定义在函数里
  - 语法：
    - local variable='zhanglei'

- global variable
  - 作用范围：当前shell脚本文件
    - 如果你在函数里定义了一个global变量，在函数外面也可以得到它的值
  - 默认定义的变量，都是global

## 2. export

- `name='zhanglei' export name`
  - 定义了一个global变量 name
  - export name 将global变量变为环境变量，
  - export的含义是，使得变量可以在其子进程中被访问，但不会影响其父进程