# 1. 现象

1. 大规模停电后，mgr的各个节点自己独立启动，此时node_A想要同node_B、node_C在其gcs信道上建立通信，由于各个节点都想建立通信，这时会导致谁也建立不起来（因为节点mgr启动起来的一个前提是，和mgr中其他节点建立通信），本质上还是由于mgr的系统变量[**_mgr_seeds]或者innodb_cluster_metadata里的表[]记录了组中其他节点的信息
2. 单独重启各个节点，也可能造成[1]中的情况

# 2. 解决

1. 使用mysqlsh建立同节点的连接
2. 运行指令 dba.rebootClusterFromCompleteOutage();
3. 该指令会提示状态最新的节点是哪个（如果当前节点不是最新状态）
4. 使用mysqlsh同状态最新节点，建立连接
5. 运行指令 dba.rebootClusterFromCompleteOutage();
6. **如果遇到dba.rebootClusterFromCompleteOutage();运行时将超长**
   1. 将各个节点停机
   2. 将group_replication_start_on_boot临时改为OFF
   3. 启动各个节点
   4. 再次运行`dba.rebootClusterFromCompleteOutage();`


# dba.rebootClusterFromCompleteOutage的处理流程

1. 等看源码分析

