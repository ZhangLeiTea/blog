# MGR知识点汇总

## 1. GCS (xcom)

- 通信channel:
  - must be different to the hostname and port used for SQL and it must not be used for client applications. It must be only be used for internal communication between the members of the group while running Group Replication
  - 必须跟client的sql信道不同
  - port: 一般是 [sql port] * 10 + 1

- 成员之间通信的账密：
  - 节点加入组的第一步是同组建立recovery信道，即使用recovery账户同组建立连接，并验证是否需要从组恢复数据
  - 该阶段完成后，使用特殊的信道同组成员之间建立连接（这个是受group_replication_ip_allowlist影响的）

## 2. 恢复账户（recovery user）用户权限

- mgr的分布式恢复，使用MySQL的异步复制协议，在加入组之前同步组状态
- 要求，实例在加入组之间要有分配了正确权限的用户，用于分布式恢复
- 通信channel：
  - 使用的是sql信道，> 8.0.20时，可以自己指定信道
- 查看
  - performance_schema.replication_connection_configration
- 账密：
  - 非innodb cluster的处理
    - 创建用户

      ``` sql
      mysql> CREATE USER rpl_user@'%' IDENTIFIED BY 'password';
      mysql> GRANT REPLICATION SLAVE ON *.* TO rpl_user@'%';
      mysql> FLUSH PRIVILEGES;
      ```

    - 下一次需要从成员恢复其状态时，使用的用户凭证

      ```sql
      CHANGE MASTER TO MASTER_USER='rpl_user', MASTER_PASSWORD='password' FOR CHANNEL 'group_replication_recovery';
      ```

## 3. 创建一个MGR组时遇到的问题

### 3.1 恢复日志和中继日志名不能使用中文
  
- 中继日志文件名的组成 {hostname}-{relay-bin}-{group_replication_applier}.0000001
- hostname 是mysql的系统变量，但是不能修改
- hostname 读取的是计算机的名称，所以需要将计算机名设为英文

### 4. 杂技

> mgr节点，每隔1秒主动发送一次流控信息
>>发送流控的线程是单独的
>>xcom只有一个线程在处理
>>不论是流控信息还是client的trans消息，都是往队列m_xcom_input_queue写
>>有单独的notification线程，当xcom收到消息时，使用这个单独的线程回调
>>l流控是由广播线程控制的  launch_broadcast_thread   Certifier_broadcast_thread::dispatcher()


