
### 1. 字符集
  1. 字符集对应的是文本数据
  2. 数据分为文本数据、二进制数据（程序数据）。文本数据说到底也是由二进制存储的，但其有一个固定的特点，那就是字符编码；相应的程序数据必须由特定的程序按照特定的格式才能解析，这个格式之后程序才知道；字符编码就是众所周知的特定格式
  3. 字符集同字符编码的关系。字符集是一个规定了具体有哪些字符的集合，可看作是字符的集合，那么这些字符在计算机中如何表示呢，这就是字符编码的事了。一个字符集可能对应多个不同的编码，例如Unicode字符集有utf8/utf16/utf32等不同的编码，不同的编码的含义是：同一个字符有不同的二进制表示。字符集定了不能确定其编码，但编码定了--字符集就是确定的。
  4. ascii是7-bit编码---->美国字符集，Latin1是8-bit编码----->拉丁字符集，gbk是不定长编码（英文一字节，中文二字节）---->中文字符集，utf8不定长编码--->unicode字符集。字符集是字符的集合，不同的字符集其字符范围也不同，其编码也不同（解析二进制数据的方式不同）这是乱码的根本原因
  
### 2. mysql的字符集

- 忘了从哪个版本开始MySQL强化了字符集的概念，提供的几个字符选项

``` bash
    # character_set_client=**   
     mysqld通过网络协议接受到二进制数据时，如果该字段的类型是文本型（varchar/text）就认为这个文本型的字符编码是**这里注意是认为（按照这个编码来解析文本数据）但是client发过来的不应是**编码的文本数据，这个变量的作用是让mysqld按照**编码解析数据
    # character_set_connect=**    
    还没有确认这个的作用，反正就是第一步：mysqld会将收到的文本按照character_set_client解析（这一步的解析作用是将client的各种编码转为mysqld程序使用的编码，一般是utf16。例如Python的decode()的作用，当我们以二进制方式加载文本文件时需要decode一下，这时decode需要你来提供编码类型）第二步：将文本数据编码成character_set_connect编码（这里要说明的是，第一步仅仅是解码没有经过转码，第二步是有转码存在的）还不知道具体的用途，有一种说法是这样做mysqld可以不受client多种编码的影响，统一内部编码为

    character_set_connect，按照这种理解的话（第一、二步就合为一步：MySQL将文本数据以character_set_client编码转成character_set_connect编码）
    # character_set_results=**    这是当返回文本数据时，mysqld会将返回的结果转码成character_set_reslults
    # character_set_server=**     
    当你定义表示，该表的字段的字符集按照下面顺序选择 该字段>该表的默认字符集>character_set_database>character_set_server
    # character_set_database=**
    # character_set_system=**     这是存放表定义等元数据的字符集。例如mysql.columns表
```  

### 3、MySQL数据用latin1存储的时代

  1) 为啥能用Latin1存储所有类型的数据：如果注意到Latin1是8bit字符集那么你就找到本质了，这个相当于二进制存储,但有一点需要注意的是在这中间一定不能有任何的转码工作，说白就是你的文本数据用Latin1存储，同时mysql会话要调用set names latin1;
  
  2) 一般的在表中有一个data字段其编码为Latin1，该字段可以存储gbk、utf8等任何编码的数据，但是具体存储了什么编码类型的数据需要你自己记得
      例如，你要存储的数据是utf8，相应的MySQL字段为Latin1编码，那么你就需要告知MySQL我要存的数据的编码是Latin1（虽然真实编码是utf8），通过set names latin1; 来告知，这么做的目的是防止编码转换

  3) 终端mysql查询Latin1的数据（有中文）怎么样不乱码：第一步：确定mysql终端使用的编码，windows-cmd一般是gbk(用chcp查看）第二步：set names latin1 第三部：确定返回数据的真实编码（例如你存入的是gbk）第四部：比较终端和真实编码是否一致，如果不一致则更改终端的字符集（用chcp）。这里要注意的是mysql客户端终端也是一个程序，它同你进行交互包括将你的输入编码发给mysqld和将从mysqld拿到的数据解码显示出来，那么它是按照哪种编码类型来编解码的呢，答案是不同的终端不一样，例如windows-cmd是按照该终端使用的代码页来完成的，mycli则始终使用utf8
  
  4) **参考资料**    <mysql/字面量(literal).md>

### 4、mysql的utf8编码及blob

  1) 现在推荐使用utf8作为文本数据的编码，二进制数据用blob数据类型
  2) blob类型在mysqld返回的时候，不会经过character_set_results的转码


### 5、windows-cmd Latin1编码正确显示中文的处理


### 6. 给出一个Python的代码示例

``` python
# create table test_latin1 (name varchar(30) character set utf8, sex varchar(30) character set latin1);
# python3 -- mysqlclient第三方库

conn_info = {
  host='10.17.5.6',
  port=4456,
  passwd='ddd',
  user='user',
  charset='latin1'
}

conn = MySQLdb.connect(**conn_info)
cur = conn.cursor()
db_encoding = conn.character_set_name()
conn.select_db('test')
cur.executor("show variables like '%char%'")
charset_list = cur.fetchall()

# MySQLdb的源码，cur.executor()会先判断query、args类型，如果是Unicode str，则先将query/args
# 转码为db.encoding即Latin1，但是'张磊'是无法转码为Latin1的，所以我们先转码为utf8，传入字节序列
# 这相当于告知MySQLdb库，我们自己处理了编码（这里将utf8编码伪装成Latin1编码）
values = ['张磊'.encode('utf8'), "\0'张磊".encode('utf8)]
cur.executor("insert into test_latin1 values(%s, %s);", values)
# 完成转码之后，有一个db.literal的过程，进行字节序列转义，注意跟踪源码，看看"\0'张磊".encode('utf8)
# 转义成了什么[b"'\\0\\'\xe5\xbc\xao\xe7\xa3\x8a'"]，整个字串加了[']，对[\0][']做了转义，原本一个
# 字节变成了2个
result_select_values = cur.execute("select name, sex from test_latin1;")
select_values = cur.fetchall()
name = select_values[0][0]    # unicode编码，从latin1转成的Unicode
sex = select_values[0][1]     # Unicode编码

# 上面的两个Unicode字串不是我们想要的，
name_latin1 = name.encode('latin1')
sex_latin1 = sex.encode('latin1')
name_expected = name_latin1.decode('ut8')

```
