ls > event.log 2 > &1

. sleep 100 & 后台执行.

cut -d ':' -f 1 /etc/passwd	-- 以:为分隔符打第1个：前的内容.
cut -d ':' -f 1,3 /etc/passwd   -- 以:为分隔符打第1和3个：前的内容.
cut -d ':' -f 1-3 /etc/passwd   -- 以:为分隔符打第1到3个：前的内容.

cut -c 1 /etc/passwd -- 打印每行第1到第3列的内容.

sort -t ":" -k3 -n /etc/passwd

sort -t ":" -k3 -n /etc/passwd | cut -d ':' -f 3

cut -d ':' -f 3 /etc/passwd | sort -n	按数字大小升序排序。
cut -d ':' -f 3 /etc/passwd | sort -nr  按数字大小降序排序。
cut -d ':' -f 3 /etc/passwd | sort -nr  按数字大小降序排序。
cut -d ':' -f 3 /etc/passwd | sort -nr | uniq -c 统计数字出现次数。

cat -A 1.txt --显示特殊字符。
wc 1.txt 

wc -l 1.txt | cut -d ' ' -f 1

lineNo=`wc -l 1.txt` | cut -d ' ' -f 1;if [ $lineNo -lt 3 ];then echo no;fi

cat 2.txt | tr 'E' 'K' -- 替换2.txt里所有的E为K.

du -sh 1.txt 查看文件大小。

for i in `seq 1 1000`; do cat /etc/passwd >> huge.log; done

split -l 10000 huge.log Kelton | ls Kelton* | xargs -i mv {} {}.txt
split -b 1M huge.log Emma | ls Emma* | xargs -i mv {} {}.txt

cd /tmp/ && ls	如果前一个命令执行成功，才执行第二个命令。
cd /tmp/ || ls	如果第一个命令执行不成功，才执行第二个命令。
cd /tmp/ ； ls	不管第一个命令执行成功与否，第二个命令都会执行。

正则表达式：
alias grep='grep --color'
grep -n --color '<keyword>' filename	显示关键字出现的行。
grep -c --color '<keyword>' filename	统计关键字出现行的次数。
grep -v --color '<keyword>' filename	取关键字不出现的行。
grep -A2 -n '<keyword>' filename	显示关键字出现的每行以及以下2行。
grep -B2 -n '<keyword>' filename	显示关键字出现的每行以及以上2行。
grep -C2 -n '<keyword>' filename	显示关键字出现的每行以及上下各2行。
grep -r '<keyword>' folder			遍历当前目录与子目录，显示所有关键字所在的行。
grep -n '^#' filename				显示所有以#开头的行。
grep -n 'n$' filename				显示所有以n结尾的行。
grep -v '^$' filename | grep -n '^[0-9]'	过滤所有空行以及数字开头的行。
grep -n '^[^0-9]' filename	显示所有非数字开头的行。
egrep —color ‘root|Direct’ 1.txt  等同于   grep －color －E ‘root|Direct’ 1.txt
grep -E —color ‘root|Direct’ 1.txt   匹配root或者匹配Direct关键字的行。
grep -E ‘(os)+’ 1.txt 匹配os关键字出现一次或者多次的行。
grep -E ‘(oo){1, 2}’ 1.txt  oo出现1次或者2次
grep -E ‘(oo){2}’ 1.txt oo出现大于等于2次


通配符：
. 任意一个字符
＊ 零个或多个前面的字符
. ＊零个或多个任意字符，空行也包括在内  — 贪婪匹配 
? 零个或一个?前面的字符  grep -E ‘ro?t’ 1.txt  — match rt or rot
+ 一个或多个＋前面的字符  grep -E ‘ro+t’ 1.txt  － match rot or root or rooot....
{} 
\


sed主要用于查找和替换。sed操作的文件内容并没有改变，除非你使用重定向存储输出。
sed '1,$p' -n 2.txt 只打印第一行。
grep -n '.*' 2.txt | sed '30,$p' -n  打印第30到最后一行，并显示行号。	-n 只打印符合条件的行。
grep --color -n '.*' 2.txt | sed '/root/p' -n 打印所有包含root关键字的行，并显示行号
grep --color -n '.*' 2.txt | sed -r '/ro?t/p' -r 无需为通配符输入转义字符
grep --color -n '.*' 2.txt | sed -e '/ro*t/p' -e '/memory/p'  -n    匹配ro*t或者匹配memory关键字的行。 非惰性匹配，如果一行同时匹配两种模式，则打印两次。以此类推。
grep --color -n '.*' 2.txt | sed '/ro*t/p;/memory/p'  -n 与上等同。
sed '/^11111$/a\22222' 1.txt    在11111这一行后加一行22222.


grep --color -n '.*' 2.txt | sed '1,30d'  删除第一到三十行。
grep --color -n '.*' 2.txt | sed '/^[0-9]/d' 删除数字开头的行。

查找与替换
grep --color -n '.*' 1.txt | sed 's/Kelton/David/g'    把Kelton关键字替换成David.
grep --color -n '.*' 1.txt | sed '1,10s/Kelton/David/g'   把第一到10行里的Kelton关键字替换成David.
grep --color -n '.*' 2.txt | sed 's/[^0-9]//g'	删除所有行里的非数字。
head /etc/passwd  | sed -r 's/([^:]+)(:.*:)([^:]+$)/\3\2\1/'  把/etc/passwd每行分为3段，第一段与第三段交换位置

awk -F 'sbin' '{print $2}' 2.txt  以字符串sbin为分隔符，打印第二段。
awk -F ":" '$1~ /root/' 2.txt 以：为分隔符，打印第一段中包含root关键字的行。
awk -F ':' 'OFS="##" {print $0}' 2.txt 以：为分隔符分割每一行，然后再用##为分隔符打印出来。
awk -F ':' '$1~/root/ {OFS="#*#"; print $1, $2, $3}' 2.txt 以：为分隔符分割每一行，然后再用#*#为分隔符打印包含root关键字的行。非精确匹配。
awk -F ':' '$1=="root" || NR > 30 {OFS="#*#"; print $1, $2, $3}' 2.txt 以：为分隔符分割每一行，然后再用#*#为分隔符打印包含root关键字或者行数大于30的行。精确匹配

NF输出读取记录的域的个数
NR表示已经读取的记录数
echo $PWD | awk -F '/' '{print $NF}'  打印PWD命令的输出的以/为分隔符的最后一个字段的值。
echo "/usr/local/etc/rc.sybase" | awk -F / '{print $NF}' -- rc.sybase

date +%Y	2016
date +%y    16
date +%d    04
date +%D    01/04/16
date +%s    时间戳
date -d @时间戳	时间戳转换为时间。
date +%F    2016-01-04
date +%T    21:53:22
date +"%Y-%m-%d %H:%M:%S"    2016-01-04 21:54:51
date +%w    
date +%W    
date -d "-1 day" +"%F %T"   往后回退一天。   2016-01-03 21:54:51
date -d "+1 month" +"%F %T"   下个月的今天。   2016-01-03 21:54:51





pstree	-- 以树的结构显示当前的进程节点
last	-- 查看上次登录或者登出的用户
nl		-- 给所查看的文本加上行号
bc		-- 计算器

bash -x ./firstShell.sh   -- 调试Shell脚本。

rpm -fq `which vim`   -- 查看vim是由哪个包安装的

数值比较
[ $a -lt 2 ]   (($a<2))   a小于2
[ $a -gt 2 ]  (($a>2))	 a大于2
[ $a -ge 2 ]  (($a>=2))  a大于等于2
[ $a -le 2 ]   (($a=<2))   a小于等于2
[ $a -eq 2 ]  (($a==2))    a等于2
[ $a -ne 2 ]   (($a!=2))   a不等于2

if [ -f ]
[ -f 1.sh ] && echo "1.sh exitst"   # 判断1.sh是否存在，如果存在，打印。
[ -f 1.sh ] || echo "1.sh exitst"   # 判断1.sh是否存在，如果不存在，打印
[ -d 123 ]    # 判断123目录是否存在
[ -e 1.sh ]    # ？？
[ -r 1.sh ]	   # 判断文件是否可读
[ -w 1.sh ]    # 判断文件是否可写
[ -x 1.sh ]    # 判断文件是否可执行f

# 将exec以下的shell命令的结果输入log.
d=`date + %F`
exec > /tmp/$d.log 2>&1
echo "Begin at `date`"
ls /tmp/sfjlsafj
cd /fjsaklfjd
echo "End at `date`" 

# function example
sum()
{
	s=$[$1+$2]
	echo $s
}
sum 1 2

# 查找本地IP地址。
ifconfig|awk 'NR==2 {print}'|awk '{print $2}'|awk -F ':' '{print $2}'
 ifconfig|grep -A1 'eth0 '|tail -1| awk '{print $2}'|awk -F ':' '{print $2}'

echo -n -- 不换行

rsync -- 用于不同机器间的数据同步