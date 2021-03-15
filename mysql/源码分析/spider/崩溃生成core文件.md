## 1. 为什么默认不生成core

1. mysqld捕获了 SEGV 信号导致的

## 2. 如何处理

- 将配置项 【 core_file 】 添加到mysqld的配置文件中
- 修改linux的core命名规则
- 修改linux的core文件大小限制
- ulimit -c unlimited     ???????