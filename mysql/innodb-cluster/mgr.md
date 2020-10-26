### 1. GCS (xcom)

- 通信channel:
  - must be different to the hostname and port used for SQL and it must not be used for client applications. It must be only be used for internal communication between the members of the group while running Group Replication
  - 必须跟client的sql信道不同
  - port: 一般是 [sql port] * 10 + 1

- 成员之间通信的账密：




### 2. 恢复账户（recovery user）用户权限

- mgr的分布式恢复，使用MySQL的异步复制协议，在加入组之前同步组状态
- 要求，实例在加入组之间要有分配了正确权限的用户，用于分布式恢复
- 通信channel：
  - 使用的是sql信道，> 8.0.20时，可以自己指定信道
- 查看
  - performance_schema.replication_connection_configration
- 账密：
  - 非innodb cluster的处理
    - 创建用户
    ```
    mysql> CREATE USER rpl_user@'%' IDENTIFIED BY 'password';
    mysql> GRANT REPLICATION SLAVE ON *.* TO rpl_user@'%';
    mysql> FLUSH PRIVILEGES;
    ```
    - 下一次需要从成员恢复其状态时，使用的用户凭证
    ```
    CHANGE MASTER TO MASTER_USER='rpl_user', MASTER_PASSWORD='password' \\
		      FOR CHANNEL 'group_replication_recovery';
    ```
