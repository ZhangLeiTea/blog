# 0. 相关注解

参见 [replica.md](./replica.md)


---
---
---

# 1、用到的一些变量及表

select * from mysql.plugin where Name='group_replication'  
select * from information_schema.plugins where PLUGIN_NAME='group_replication';  
show plugins;  
show engines;  

innodb-cluster的内建账户： select * from mysql.user where User like 'mysql_innodb_cluster%';

group_replication相关  
  select * from performance_schema.replication_group_members;  
  select * from performance_schema.replication_group_member_stats\G  
  
server_id   server_uuid   gtid_mode=on    gtid_executed   gtid_purged

mysql_innodb_cluster_metadata库
  
# 2、MySQL节点先恢复备份在加入cluster

1. 先备份  
  mysqldump --all-databases --all-drop-database --single-trasanction --triggers --routines --set-gtid-purged=on --user=** -p*** > backup.sql
  
2. mysql节点的清理于恢复
   1. set sql_log_bin=0; set global super_read_only=0;       注：
   2. show plugins; 判断group_replication插件是否active
   3. select * from mysql.plugin where Name='group_replication'; 判断插件是否安装
   4. 如果激活， 则 stop group_replication;
   5. 如果安装，则 uninstall plugin group_replication;     注：cluster.addInstance()函数会安装group_replication并激活
   6. reset master;  // 重置master的信息
   7. set slave;     // 重置slave的信息，如删除relay-log/recovery-log
   8. source back.sql;   **恢复备份**
   9. delete from mysql.plugin where Name='group_replication';   注：备份文件中带有该项，需要手动删除
   10. 删除mysql_innodb_cluster_*账户
       1) select * from mysql.user where User like 'mysql_innodb_cluster%';  
       2) 将查到用户 drop user if exists ***;  
       3) flush privileges;  
   11. reset slave; set sql_log_bin=1;
   12. 在cluster中addInstance()即可
  
