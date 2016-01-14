#! /bin/bash
log=$1
# current time stamp
t_s=`date +%s`
# time stamp 2 hours ago
t_s2=`date -d "2 hours ago" +%s`
if [ ! -f /tmp/$log ]
then
    echo $t_s2 > /tmp/$log
fi
# Get time stamp in the last time.
t_s2=`tail -l /tmp/$log|awk '{print $1}'`
echo $t_s>>/tmp/$log
v=${$t_s-$t_s2}
echo $v
if [ $v -gt 3600 ]
then
    #send mail
    /dir/to/php ../mail/mail.php "$1 $2" "$3"
    echo "0" > /tmp/$log.txt
else
	if [ ! -f /tmp/$log.txt ]
	then
	    echo "0" > /tmp/$log.txt
	fi
	nu=`cat /tmp/$log.txt`
	nu2=$[nu+1]
	echo $nu2>/tmp/$log.txt
	if [ $nu2 -gt 10 ]
	then
	    #send mail
	    /dir/to/php ../mail/mail.php "Trouble continue 10 min $1 $2 " "$3"
	    echo "0" > /tmp/$log.txt
    fi
fi