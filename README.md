# KILL Process

Some scripts to take down processes or queries hanging.

### Apache

```bash
max=30 # 30min

while IFS= read -r line ; do

	#echo "${line}"

	id=${line:0:5}
	id=$((id + 0))
	user=${line:12:6}
	time=${line:24:8}
	hour=${line:24:2}
	hour=$((hour + 0))
	min=${line:27:2}
	min=$((min + 0))
	sec=${line:30:2}
	sec=$((sec + 0))

	echo -e "ID: $id / User: $user / Time: $time"

	if [[ "$user" == "apache" ]]; then

		echo -e "Hour: $hour / Min: $min / Sec: $sec"

		if [ $hour -ge 1 ]; then
			echo -e "Hour >= 1 KILL"
			kill -9 $id
		fi
		if [ $min -ge $max ]; then
			echo -e "Min >= $max KILL"
			kill -9 $id
		fi

	else
		echo -e "Not availability."
	fi

	echo -e "\n"

done < <(ps -eo pid,uid,user,etime,pcpu,pmem,comm | grep httpd)
```
> Important: Always kill process greater than 1h.

Cron

```bash
*/10 * * * * root bash "/data/kill-process/apache.sh" ;
```

### MySQL

```bash
host="127.0.0.1"
user="root"
passwd="master"

max=60*5 # 5min

queries=$(mysql -h"$host" -u"$user" -p"$passwd" "information_schema" -se "SELECT CONCAT('KILL ', id, ';') FROM information_schema.processlist WHERE TIME>=$max;")

echo -e "$queries"

result=$(mysql -h"$host" -u"$user" -p"$passwd" "information_schema" -se "$queries")
```

Cron

```bash
*/10 * * * * root bash "/data/kill-process/mysql.sh" ;
```
