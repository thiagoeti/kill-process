#!/bin/sh

#ps -eo pid,uid,user,etime,pcpu,pmem,comm | grep httpd

#-- ----- ----- -----

echo -e "KILL Process - Apache - $(date)"

max=30 # 30min

#-- ----- ----- -----

while IFS= read -r line ; do

	#echo "${line}"

	id=${line:0:5}
	id=$(($id + 0))
	user=${line:12:6}
	time=${line:24:8}
	hh=${line:24:2}
	hh=${hh#0}
	hh=$(($hh + 0))
	mm=${line:27:2}
	mm=${mm#0}
	mm=$(($mm + 0))
	ss=${line:30:2}
	ss=${ss#0}
	ss=$(($ss + 0))

	echo -e "ID: $id / User: $user / Time: $time"

	if [[ "$user" == "apache" ]]; then

		echo -e "Hour: $hh / Minute: $mm / Second: $ss"

		if [ $hh -ge 1 ]; then
			echo -e "Hour >= 1 KILL"
			kill -9 $id
		fi
		if [ $mm -ge $max ]; then
			echo -e "Min >= $max KILL"
			kill -9 $id
		fi

	else
		echo -e "Not availability."
	fi

done < <(ps -eo pid,uid,user,etime,pcpu,pmem,comm | grep httpd)

#-- ----- ----- -----

exit $?
