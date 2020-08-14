1. 字面量
   1. 字符串字面量
      - 可以带编码
      - 表示： "" 或 ['']
  
   2. 二进制字符集 和 二进制字符串 （binary string）
  `A binary string is a string of bytes. Every binary string has a character set and collation named binary. 
  A nonbinary string is a string of characters. 
  It has a character set other than binary and a collation that is compatible with the character set`
  
2. 日期、时间字面量

3. sql语句字符集
   1. **另外的资料** <mysql/character_set.md>
   2. 例如 name字段是blob类型，如何插入，来确保blob的字符集是某种固定的字符集（例如gbk）：需求就是-- 将字符串保存到blob字段中，要求能自定义字符串的字符集
       - blolb类型的字段，仍然认为是字符串类型字段
       - CREATE TABLE t (c BINARY(3));  INSERT INTO t SET c = 'a';

   - 二进制字节序列在插入到sql语句中时，需要转义处理

   - **字符串在插入到sql语句中时，也要做转义处理**
  
   - 方法一：先拼接成整个sql语句，再将sql语句整个转成该字符集 （貌似不行，但是py client编程时，最后一步就是将整条sql语句encode成 character_client编码）

   - 方法二：不直接拼接成一个sql，而是使用api提供的参数。参数在拼接到sql之前，调用了转义api（例如py-mysqlclient的 db.literal()）, 这个参数的类型可以是str/bytearray

   - 例如：MySQLDB里的cur.execute()函数，就提供了第二个参数，用于填充sql语句中的占位符

-----
-----

``` py
      ====================  注意字节序列的格式化
      a = b'zhanglei %s' % b'aaaa'

      ===========================================================
      def escape(self, obj, mapping=None):
        """Escape whatever value you pass to it.

        Non-standard, for internal use; do not use this in your applications.
        """
        if isinstance(obj, str_type):
            return "'" + self.escape_string(obj) + "'"
        if isinstance(obj, (bytes, bytearray)):
            ret = self._quote_bytes(obj)
            if self._binary_prefix:
                ret = "_binary" + ret
            return ret
        return converters.escape_item(obj, self.charset, mapping=mapping)

     ===========================
     def _quote_bytes(self, s):
        if (self.server_status &
                SERVER_STATUS.SERVER_STATUS_NO_BACKSLASH_ESCAPES):
            return "'%s'" % (_fast_surrogateescape(s.replace(b"'", b"''")),)
        return converters.escape_bytes(s)

     ===================================
       escape_string = _escape_unicode

    # On Python ~3.5, str.decode('ascii', 'surrogateescape') is slow.
    # (fixed in Python 3.6, http://bugs.python.org/issue24870)
    # Workaround is str.decode('latin1') then translate 0x80-0xff into 0udc80-0udcff.
    # We can escape special chars and surrogateescape at once.
    _escape_bytes_table = _escape_table + [chr(i) for i in range(0xdc80, 0xdd00)]

    def escape_bytes_prefixed(value, mapping=None):
        return "_binary'%s'" % value.decode('latin1').translate(_escape_bytes_table)

    def escape_bytes(value, mapping=None):
        return "'%s'" % value.decode('latin1').translate(_escape_bytes_table)
```

  - 方法三：采用api提供的占位符
       - MySQL的预编译语句？？

>>
原理：
To insert binary data into a string column (such as a BLOB column), you should represent certain characters by escape sequences（需要用转义序列来代替某些字符）. 
Backslash (\) and the quote character used to quote the string（反斜杠和引号字符） must be escaped. 
In certain client environments, it may also be necessary to escape NUL or Control+Z. 
The mysql client truncates quoted strings containing NUL characters if they are not escaped（如果没有转义，mysql客户端会截断包含NUL字符的引用字符串）,
and Control+Z may be taken for END-OF-FILE on Windows if not escaped.
For the escape sequences that represent each of these characters, see Table 9.1, “Special Character Escape Sequences”.

When writing application programs, any string that might contain any of these special characters must be properly escaped before the string is used as a data value
in an SQL statement that is sent to the MySQL server. You can do this in two ways:

  方法一、自己调用转义函数：Process the string with a function that escapes the special characters. In a C program, you can use the mysql_real_escape_string_quote() C API function to escape characters.
See Section 28.7.6.57, “mysql_real_escape_string_quote()”. Within SQL statements that construct other SQL statements, you can use the QUOTE() function. 
The Perl DBI interface provides a quote method to convert special characters to the proper escape sequences. See Section 28.9, “MySQL Perl API”. 
Other language interfaces may provide a similar capability.

  方法二、使用api提供的占位符功能：As an alternative to explicitly escaping special characters, many MySQL APIs provide a placeholder capability that enables you to insert special markers 
into a statement string, and then bind data values to them when you issue the statement. 
In this case, the API takes care of escaping special characters in the values for you.
