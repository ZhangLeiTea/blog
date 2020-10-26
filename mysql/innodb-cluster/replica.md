# Replica

## reset master
- 控制replica source server
- 如果开启gtid_mode，会重置gtid的执行历史
  - 清除 gtid_exectued  gtid_purged
  - 清空 mysql.gtid_executed 表
- 如果开启binglog，则删除所有的binlog文件
- 当replica正在运行时（例如mgr的secondary正在运行）其行为是不可预知的

## set sql_log_bin
- 控制replica source server

## 1. change master to .. rpl_user, rpl_password
- 控制的replica server
- 信息存储在  **mysql.slave_master_info**
- master_info_repository=TABLE 是mysql.slave_master_info能查到的前提
- slave使用该语句设置的连接信息，同master建立通信
- 需要确保master上，有对应的rpl用户，且开启对应的权限




## reset slave
- replication io threads必须停止（对应 replication sql thread）例如执行stop group_replication;  
- 使副本忘记，此时副本在数据源的bin-log对应的位置（忘记自己执行到哪了）
- 清空relay-log、recovery-log
- 对gtid的执行历史没有任何影响
- mgr使用时，成员必须是offline
- 不会改变任何replication connection parameters. 即不会改变 change master to所设置的参数
- reset slave all 则会清除连接参数

## gtid_executed


## gtid_purged
- 在mgr的joining node设置primary的gtid_executed的值，则recovery则会跳过这些值


## 2. performance_schema.replication_connection_configuration
- 

## 3. mysql_innodb_cluster_metadata.instances

- 这里存放了cluster的实例
- 包含了各个实例的recovery account

## 2. dba.configureLocalInstance()

- 验证有一个合适的user用于cluster成员之间的connect
  - 给root账户开启远程连接（这里的root账户，user名就是root）
  - 创建一个新的user（是clusterAdmin user）


## 3. mysql.session

- 启动gr的必要条件？
