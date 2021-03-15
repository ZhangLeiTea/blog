# `<<EOF`

## 1.1 一个例子

## A command with the << operator will do the following things :

- Launch the program specified in the left of the operator, cat for instance.
- Grab user input, including newlines, until what is specified on the right of the operator is met on one line, EOF for instance
- Send all that have been read except the EOF value to the standard input of the program on the left.


``` shell
cat << EOF
Hello
World
EOF
```

## 1.2 另一个例子

``` shell
mysql_passfile() {
    cat <<-EOF
        [client]
        password='123456'
    EOF
}

# 注意`cat <<-EOF`的作用，导致接下来的行，可以包含空格、tab
```



## 2. `<<`提供`Here document`的语义

## 3. `<<<`提供`Here string`的语义

- `here doc`的一个变种
- `here doc`输入一行时，至少需要三行，这时`here string`便可替代

## 4. 说明

> Technically <<< is a feature of the bash shell. It's not specific to Linux nor is it common to other shells.
>  
>Bourne compatible shells, such as bash have always had a feature called "here docs." This looks like:  
>  
``` shell
#!/usr/bin/bash 
echo 'The following command is an example of a "here" document.' 
cat << HELP 
Here is some help text.  It's fed from the shell's input stream 
(the source code of our shell script) into the cat command on its 
stdin input stream.  The part after the << token is an arbitrary 
string used to mark the end of the "document" 
HELP 
echo 'This is another command after the "here" document.' 
```
> 
> This is handy for creating certain types of script such as "shell archives" (a shell script containing a UUEncoded or Bin64/text encoding of some data following a header which represents the source code for decoding the data into the desire directory structure or list of files).
> 
> This brings us to bash's unique <<< "here" string operator.
> 
> This is similar to a "here document" except that it feeds a string into the standard input of some some program rather than feeding all of the subsequent lines from the script up to the terminating string. I'll show three examples which effectively do the same things with regards to the data fed into some other command:

``` shell
#!/usr/bin/bash 
echo -n 'Enter something to feed into a wc -c command: ' 
read something 
 
# Example one, using a "here" string: 
wc -c <<< "$something" 
# Should print out the number of character in "something" 
 
# Example two, using a "here" DOC: 
wc -c << INPUT 
$something 
INPUT 
 
# Example three, using a echo and a pipeline: 
echo "$something" | wc -c 
 
# Done 
```
> You might ask why you'd use a "here" string rather than the pipeline or the here doc for example. Well the problem with a pipeline is that the bash shell runs the commands on the right of the | in a subprocess. The subprocess exits after the end of the line (or at the first command separator such as a semicolon). That's fine for something like wc or cat (those are external commands and are run in their on subprocesses in any event). However for something like the shell read built-in, the variable set by the read would be in the sub shell and immediately forgotten when the process (sub-process) containing that shell terminates.
> 
> So we can't use pipelines to set variables in our shells.
> 
> We can use "here" docs in many cases ... but we might not want to have to span an input string across three lines (one for the line containing the <<, one for the string, and another for the "here" doc terminator).
> 
> But why use read to set a variable's value when you can just use a variable assignment?
> 
> Consider this example:


``` shell
something=1234567890 
read -n 4 FIRSTFOUR <<< "$something" 
```

> This is a quick, easy way to get just the first four characters from \$something using features specific to the read built-in command. Sure I can use parameter substitution: FIRSTFOUR=${something:0:4} ... but those substring parameter substitution features are no more portable than <<< and just about as obscure.
> Personally I've never needed to use <<< ... but it does have its niche.