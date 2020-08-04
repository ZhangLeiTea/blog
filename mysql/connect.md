## 1. linux的 unix socket连接

- 默认位置： /tmp/mysql.sock
- 这个文件是由mysqld在启动的时候生成的
  - [x] [mysqxld]
    - socket=/tmp/other/mysql.sock
    - 可以更改位置，但是更改位置后要让客户端感知到
  - client感知mysql.sock
    - 不加-h选项或者是localhost，默认是用socket连接
    - 命令行参数 --socket=
    - 配置文件
      - [client]
        - socket=/path


## 2. 连接  客户端连接 

### 参考资料

  > - <https://dev.mysql.com/doc/refman/8.0/en/connection-interfaces.html> 

### 2.1 变量

---
---


| 名称              |   类型    | 简介                                                                                                              |
| :---------------- | :-------: | :---------------------------------------------------------------------------------------------------------------- |
| Connections       |  status   | 试图建立连接的数据（成功+不成功)                                                                                  |
| Thread_Cache_size | variables | 在启动时预先建立的线程数                                                                                          |
| thread_stack      |     v     | 每个线程分配的栈大小。默认256K. 会限制能够执行的sql语句的复杂度                                                   |
| threads_cached    |     s     | 在线程缓冲中还有几个线程可用                                                                                      |
| threads_created   |     s     | 成功建立连接后分配的线程数，这个线程不是从线程缓冲中获取的。这个值一直累加                                        |
| max_connections   |     v     | 允许同时建立连接的数量（注意spuer user连接的问题）此值过大有负影响（消耗过多的stack或者其他资源、调度也是个问题） |

### 2.2 max_connections

#### 参考资料l

- <https://www.percona.com/blog/2013/11/28/mysql-error-too-many-connections/>
- <https://www.percona.com/blog/2019/02/25/mysql-challenge-100k-connections/>

##### 2.2.1 影响因素

- The quality of the thread library on a given platform.

- The amount of RAM available.

- The amount of RAM is used for each connection.

- The workload from each connection.

- The desired response time.

- The number of file descriptors available.

| ram  | connection buffer | max_connections |
| :--- | :---------------: | :-------------- |
| 16G  |       256K        | 1000            |
