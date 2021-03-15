# delete from tbl where col1 < value1;  范围删除触发的大事务

1. 原因
    - mgr有 [group_replication_transaction_size_limit] 的限制，如果事务的大小超过该值则事务执行失败，导致事务rollback
    - delete一行数据时，writeset表示的是整行的数据，至于为什么传输的是整行的数据，暂时不知道原因

2. 解决
    - 评估表中一行数据的平均值
      - 方法一、select data_length, table_rows, avg_row_length from information_schema.tables where table_name = 'tbl_playertrait2';
        - 这个值涉及到了 data、index、Fragmentation
          - <https://dba.stackexchange.com/questions/69818/whats-row-size-in-mysql>
        - 这个值一般要比row data的值大，不过可以用此作为参考
      - 方法二、自己评估
    - mgr最大事务的大小约为143M
    - select count(*) from tbl where col1 < value1; 得到删除的总行数
    - 得出一次删除的最大行数：[max size one delte] = 143M * 1024 * 1024 / [行数据均值]
    - [删除循环次数] = [删除的总行数] / [max size one delte]
    - delete from tbl where col1 < value1 limit [max size one delte];
    - 重复执行上述语句，重复次数[删除循环次数]
