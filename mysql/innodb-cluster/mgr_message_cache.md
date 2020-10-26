### One line of command can quickly load InnoDB Cluster data.

一行指令，快速加载innodb cluster数据

> After a series of optimizations, InnoDB Cluster 8.0 is stable enough. Early versions often cause cluster instability due to network delays, flashing, and other issues. We have also encountered customers who are frequently kicked out of nodes due to network mitigation problems, and availability cannot be guaranteed. Do not use peripheral operation and maintenance methods to ensure cluster stability, which also increases the complexity of operation and maintenance work. Now it can be effectively solved through parameter optimization and can tolerate certain network fluctuations.
> The network problem is solved. Another problem with InnoDB Cluster is the big transaction. The system will inevitably encounter big DML and load data operations. In the data synchronization mechanism, group replication is very different from async replication and semi-sync replication. It refers to the paxos protocol to realize the independent group communication engine xcom integrated in MySQL, xcom is responsible for the sending and receiving of messages between nodes, and ensuring the consistency and order of message delivery. The messages include two types of transaction writing related information and heartbeat statistics information. xcom is a single-threaded instance. Processing large transactions will inevitably affect the processing of other messages. If heartbeat messages from other nodes cannot be responded to, the node will be kicked out of the cluster if there is no response for 5 seconds. The group_replication_transaction_size_limit parameter limits the transaction size, and the rollback of transactions exceeding the limit will not be broadcast. The transaction message is writeset, and its size is determined by factors such as the number of transaction changed rows, row length, and the number of unique indexes. In order to enhance the processing capability of large transactions, 8.0.16 supports the message fragmentation mechanism. The message fragment size is controlled by the group_replication_communication_max_message_size parameter. If the message exceeds this limit, it will be automatically sub-packaged and broadcast. When it reaches other nodes, it will be automatically merged. This parameter cannot Greater than the slave_max_allowed_packet value, the default is 10MB, and the maximum limit is 1GB.

在经过一系列的优化后，innodb cluster 8.0已经足够稳定了。早前的版本经常导致cluster不稳定，主要原因有网络延迟、网络抖动、以及一些其他的问题。我们也遇到过一些用户，经常因为一些网络问题被踢出集群，集群的高可用性得不到保障。不要使用一些外围的操作和运维手段来加强cluster的稳定性，因为这会增加运维的复杂性。现在这个问题已经通过参数优化得到了解决，从而能够容忍一定的网络抖动

网络问题已经解决。innodb cluster的另一个问题就是**大事务**。集群不可避免的会遇到大的DML和load data的操作。在数据同步机制方面，gr和异步复制、半同步复制有很大的不同，gr使用paxos协议实现了对立的组通信引擎xcom, xcom被集成到MySQL中，xcom负责在节点之间发送和接收消息，并确保消息传递的一致性和有序性。这个消息有2中类型：事务写操作关联的信息和心跳统计信息。注意，xcom是单线程实例。xcom在处理大事务的时候（**注意**，xcom仅处理大事务的消息分发，大事务的执行时间xcom不关心），必可避免的影响到其他消息的处理。如果来自其他节点的心跳消息不能被及时响应，这个节点如果在5秒还是不响应则集群会剔除这个节点。group_replication_transaction_size_limit该参数限制了一个事务的最大大小，如果超过了这个限制，事务被回滚，并不会广播给其他节点。事务类型的消息是写集合，它的大小被多个因素决定，例如事务改变的行数，行的长度，唯一索引的数量。为加强对大事务的处理，8.0.16支持消息分片机制。group_replication_communication_max_message_size参数控制消息分片的大小，如果消息超过了这个限制，它兼备自动分片并广播，这些分片达到其他节点时自动合并。这个参数的值不能比slave_max_allowed_packet参数的值大，该参数的默认值是10M，最大1G

> Does the message fragmentation mechanism perfectly support large transactions?

消息分片能完美的解决大事务吗？

I simulated load data to import a 185MB file. Under the group_replication_transaction_size_limit default configuration of 147MB, it cannot be imported, and transactions that exceed the limit are rolled back.

我做了如下模拟，使用load data导入一个185M的文件到MySQL，在group_replication_transaction_size_limit默认值147M的情况下，它不能被导入，事务会因超过限制而被回滚

Setting group_replication_transaction_size_limit to 0 is equivalent to canceling the limit, the import can be successful, and the status of the cluster nodes are all normal, and no node is kicked out of the cluster.

将group_replication_transaction_size_limit设为0，意味着取消限制，那么导入能够成功，cluster中各个节点的状态也是正常的，没有节点被踢出集群

Can it handle larger matters?

它能够处理规模更大的事务吗？

In the subsequent test, I enlarged the data file to 1G, and kept the group_replication_transaction_size_limit as 0. No transaction limit was applied, and the node loss and import failure would occur. Because the xcom cache limit is exceeded, the xcom cache caches the latest message information. When the node loses connection, it is added back to the cluster. The messages during the loss of connection must be restored through the xcom cache. If the cache space is not enough, the missing messages are eliminated , The node cannot be automatically added back to the cluster, but can only be manually added back to the cluster to restore data through the asynchronous replication channel. Before 8.0.16, the xcom cache was configured with 50000 slots or 1G memory. If the limit is exceeded, the memory space is reclaimed according to the LRU strategy. In 8.0.16, the group_replication_message_cache_size parameter is added to cancel the fixed limit. Users can adjust according to the actual situation, and adjust with group_replication_member_expel_timeout to tolerate Longer network latency. The usage of xcom cache is observed in memory_summary_global_by_event_name

在接下来的测试中，我将文件的大小增加到1G，并将group_replication_transaction_size_limit设为0. 没有事务大小的限制，但是导入还是会失败【原因：执行load data的节点，xcom仅处理消息分发，并且是开启了消息分片，可能长时间不响应其他其他节点的心跳信息，导致组将其孤立，从而该事务回滚，这是有可能的，但是开启消息分片之后会降低这种可能；另一种可能：一个事务的writeset不能超过xcom的缓存大小，一旦超过则失败】  

因为超过了xcom的缓存限制，xcom缓存的作用是存放最近产生的消息。  

当一个节点同集群失去连接时，它还能被添加会集群。在节点失去连接的这段期间，集群产生的消息必须都存放在xcom的缓存中，用来恢复。如果缓存的空间不够，某些丢失的消息会被淘汰，失去连接的节点就不能自动加入集群，只能通过异步恢复通道来手动将节点加入集群。8.0.16版本之前，xcom的缓存大小是50000slot或者1G内存。如果超过了限制，内存空间将根据LRU策略来回收掉。8.0.16版本，group_replication_message_cache_size取消了固定大小的限制，用户可以根据实际情况来调整，调整group_replication_member_expel_timeout来容忍更大的网络延迟


## 失败探测
- 怀疑：如果在一定时间内，server A没有收到server B的消息，则怀疑server B哑火了
- 怀疑成立：serverA产生了怀疑，如果组中剩余的成员都同意，则怀疑生效
- 如果节点被组孤立了，那么它产生的怀疑也就失效了
- 一旦被组孤立，则不能执行任何本地事务

可以通过memory_summary_global_by_event_name表来获取xcom cache的使用

``` bash
mysql> select * from  memory_summary_global_by_event_name where event_name like 'memory/group_rpl%'\G
*************************** 1\. row ***************************
EVENT_NAME: memory/group_rpl/GCS_XCom::xcom_cache
COUNT_ALLOC: 2362
COUNT_FREE: 2317
SUM_NUMBER_OF_BYTES_ALLOC: 5687428055
SUM_NUMBER_OF_BYTES_FREE: 3196560772
LOW_COUNT_USED: 0
CURRENT_COUNT_USED: 45
HIGH_COUNT_USED: 1176
LOW_NUMBER_OF_BYTES_USED: 0
CURRENT_NUMBER_OF_BYTES_USED: 2490867283
HIGH_NUMBER_OF_BYTES_USED: 3195280758
1 row in set (0.0030 sec)

CURRENT_COUNT_USED xcom cache currently used slot number

CURRENT_NUMBER_OF_BYTES_USED xcom cache currently used memory space
```

If the xcom cache is set large enough, can it handle larger transactions?
The upper limit of group_replication_message_cache_size is 16EB, and the limit of cb_xcom_receive_data function to receive messages is 4G. If you are interested, you can test what will happen if you load a 5G data file. However, the memory and network overhead of large transactions will affect the overall performance of the cluster, so large transactions should be avoided as much as possible.

如果xcom的缓存足够大，那么能处理大事务吗？  
group_replication_message_cache_size的上限是16EB，接受消息的cb_xcom_receive_data函数的限制是4G。如果你感兴趣的话，可以测试一下导入一个5G的数据文件看看会发生什么。然而，因大事务带来的内存、网络开销将会影响整个集群的性能，所以大事务应该尽可能的避免

Understand how group replication handles large transactions, how to quickly import data?
The correct approach is to split into small files and import them in parallel. The mysql shell AdminAPI has already integrated parallel import gadgets, which automatically split and process them in parallel, which is more efficient and can be used out of the box.

mysqlsh root@localhost:4000 --ssl-mode=DISABLED -- util import-table /Users/hongbin/mysql-sandboxes/4000/mysql-files/sbtest --schema=test --table=sbtest2 --bytes-per-chunk=10M
1


to sum up
The message fragmentation mechanism can reduce the probability of nodes being kicked out of the cluster caused by large transactions to a certain extent, but the cluster performance will still be affected.
Large transactions need to take up more xcom cache space. If xcom needs to apply for more memory space, there is also the risk of being OOM.
Large transactions should be avoided as much as possible. Adjusting group_replication_transaction_size_limit, group_replication_message_cache_size, group_replication_communication_max_message_size, group_replication_member_expel_timeout parameters can only alleviate part of the problem. It is also not recommended to set group_replication_transaction_size_limit to 0 in the production environment.
Large file data loading should be split and imported. It is recommended to use util.importTable of mysql shell.


> group_replication_message_cache_size
> - 当成员离线了一段时间，但还不足以将其从集群中踢出时，它可以从其他节点的xcom缓存中接受这段时间丢失的消息，从而再次加入集群
> - 在离线的这段时间中，某些消息已经从xcom的缓存中删除了，那么离线的成员就不能以这种方式加入集群