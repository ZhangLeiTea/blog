
1. hs 代表的是 handlersocket
2. pre_direct_delete_rows() 这里的pre一般是和 hs 关联的
3. direct_dete
    - delete all qualified rows in a single operation, rather than one row at a time
    - 下推到每一个分区