#!/bin/bash
WEBLIST=weblist.lst
STATISTIC=statistic.txt
echo '#web , byte , word  , rate #%' | tee $STATISTIC
for i in `cat $WEBLIST`; do
{
	echo $i 
	if [ ! -f $i.html ]; then
		wget --output-document=$i.html $i
	fi
	lynx -dump ${i}.html > $i.txt
	tmp=`wc -c $i.txt`
	byte=`echo $tmp | cut -d' ' -f1`
	#echo "byte:" $byte
	tmp=`wc -w $i.txt`
	word=`echo $tmp | cut -d' ' -f1`
	#echo "word:" $word
	rate=`echo "100 * $word / $byte.0" | gp -q`
	#echo $rate
	echo -n  "$i , $byte , $word , $rate" | tee >( sed -r "s:\x1B\[[0-9;]*[mK]::g" >> $STATISTIC)
}
done

