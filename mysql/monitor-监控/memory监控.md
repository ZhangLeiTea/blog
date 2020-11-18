
1. 查看innodb相关的内存监控是否开启，默认不开启
   - SELECT * FROM performance_schema.setup_instruments WHERE NAME LIKE '%memory/innodb%';
   - SELECT * FROM performance_schema.setup_instruments WHERE NAME LIKE '%memory/group_rpl%';

2. 但是这种在线打开内存统计的方法仅对之后新增的内存对象有效，重启数据库后又会还原设置
   - update performance_schema.setup_instruments set enabled = 'yes' where name like 'memory%';

3. 对全局生命周期中的对象进行内存统计
   - [mysqld]  performance-schema-instrument='memory/%=COUNTED'



``` sql
SELECT SUBSTRING_INDEX(event_name,'/',2) AS
 code_area, sys.format_bytes(SUM(current_alloc))
 AS current_alloc
 FROM sys.x$memory_global_by_current_bytes
 GROUP BY SUBSTRING_INDEX(event_name,'/',2)
 ORDER BY SUM(current_alloc) DESC;
 ```


 ``` sql
 select * from setup_instruments  where name like 'memory/inn%' and enabled='no'\G
 ```

 ``` sql
 SELECT *
       FROM performance_schema.memory_summary_global_by_event_name
       WHERE EVENT_NAME = 'memory/sql/TABLE'\G

SELECT sum(CURRENT_NUMBER_OF_BYTES_USED) / 1024 / 1024 as total_memory
FROM performance_schema.memory_summary_global_by_event_name
WHERE EVENT_NAME like 'memory/innodb%'
```


3. 理论内存消耗计算方式
这里先不考虑 innodb_buffer_pool_size 未被完全使用的情况。另外，max_connections 计算的是最高session消耗。

> key_buffer_size + query_cache_size + tmp_table_size + innodb_buffer_pool_size + innodb_additional_mem_pool_size + innodb_log_buffer_size + max_connections * (
sort_buffer_size + read_buffer_size + read_rnd_buffer_size + join_buffer_size + thread_stack + binlog_cache_size
)