#/bin/bash
# source: https://forum.iobroker.net/topic/2021/gel%C3%B6st-synology-systeminformationen-auslesen-und-auf-vis-darstellen

ioBrokerSetURL="http://192.168.1.82:8087/set/javascript.0.System.Synology."

URL_set_CPUTemp1="${ioBrokerSetURL}CPUTemp1?value="
URL_set_CPUTemp2="${ioBrokerSetURL}CPUTemp2?value="
URL_set_CPUTemp3="${ioBrokerSetURL}CPUTemp3?value="
URL_set_CPUTemp4="${ioBrokerSetURL}CPUTemp4?value="
URL_set_CPUUsage="${ioBrokerSetURL}CPUUsage?value="
URL_set_CPULoad="${ioBrokerSetURL}CPULoad?value="

URL_set_MemTotalGB="${ioBrokerSetURL}MemTotalGB?value="
URL_set_MemFreeGB="${ioBrokerSetURL}MemFreeGB?value="
URL_set_MemUsedGB="${ioBrokerSetURL}MemUsedGB?value="
URL_set_MemFreePercent="${ioBrokerSetURL}MemFreePercent?value="
URL_set_MemUsedPercent="${ioBrokerSetURL}MemUsedPercent?value="

URL_set_HDDTemp1="${ioBrokerSetURL}HDDTemp1?value="
URL_set_HDDTemp2="${ioBrokerSetURL}HDDTemp2?value="
URL_set_HDDTemp3="${ioBrokerSetURL}HDDTemp3?value="
URL_set_HDDTemp4="${ioBrokerSetURL}HDDTemp4?value="
URL_set_HDDTemp5="${ioBrokerSetURL}HDDTemp5?value="

URL_set_StorageVolume1Total="${ioBrokerSetURL}StorageVolume1Total?value="
URL_set_StorageVolume1Free="${ioBrokerSetURL}StorageVolume1Free?value="
URL_set_StorageVolume1Used="${ioBrokerSetURL}StorageVolume1Used?value="
URL_set_StorageVolume1FreePercent="${ioBrokerSetURL}StorageVolume1FreePercent?value="
URL_set_StorageVolume1UsedPercent="${ioBrokerSetURL}StorageVolume1UsedPercent?value="

URL_set_StorageVolume2Total="${ioBrokerSetURL}StorageVolume2Total?value="
URL_set_StorageVolume2Free="${ioBrokerSetURL}StorageVolume2Free?value="
URL_set_StorageVolume2Used="${ioBrokerSetURL}StorageVolume2Used?value="
URL_set_StorageVolume2FreePercent="${ioBrokerSetURL}StorageVolume2FreePercent?value="
URL_set_StorageVolume2UsedPercent="${ioBrokerSetURL}StorageVolume2UsedPercent?value="

URL_set_UptimeDays="${ioBrokerSetURL}UptimeDays?value="
URL_set_UptimeHours="${ioBrokerSetURL}UptimeHours?value="
URL_set_UptimeMinutes="${ioBrokerSetURL}UptimeMinutes?value="
URL_set_DSMVersion="${ioBrokerSetURL}DSMVersion?value="
URL_set_Timestamp="${ioBrokerSetURL}Timestamp?value="

# Ermitteln und Setzen der Werte

# CPU-Temperatur
CPUTemp1=$(cat /sys/bus/platform/devices/coretemp.0/hwmon/hwmon0/temp1_input | awk '{print $1/1000}')
CPUTemp2=$(cat /sys/bus/platform/devices/coretemp.0/hwmon/hwmon0/temp2_input | awk '{print $1/1000}')
CPUTemp3=$(cat /sys/bus/platform/devices/coretemp.0/hwmon/hwmon0/temp3_input | awk '{print $1/1000}')
CPUTemp4=$(cat /sys/bus/platform/devices/coretemp.0/hwmon/hwmon0/temp4_input | awk '{print $1/1000}')

url_CPUTemp1=$URL_set_CPUTemp1$CPUTemp1
echo "$url_CPUTemp1"
curl -s $url_CPUTemp1 > /dev/null 2>&1
url_CPUTemp2=$URL_set_CPUTemp2$CPUTemp2
echo "$url_CPUTemp2"
curl -s $url_CPUTemp2 > /dev/null 2>&1
url_CPUTemp3=$URL_set_CPUTemp3$CPUTemp3
echo "$url_CPUTemp3"
curl -s $url_CPUTemp3 > /dev/null 2>&1
url_CPUTemp4=$URL_set_CPUTemp4$CPUTemp4
echo "$url_CPUTemp4"
curl -s $url_CPUTemp4 > /dev/null 2>&1

# CPU-Usage
CPUUsage=$(top -b -n15 -p 1 | fgrep "Cpu(s)" | tail -1 | awk -F'id,' -v prefix="$prefix" '{ split($1, vs, ","); v=vs[length(vs)]; sub("%", "", v); printf "%s%.1f\n", prefix, 100 - v }')
url_CPUUsage=$URL_set_CPUUsage$CPUUsage
echo "$url_CPUUsage"
curl -s $url_CPUUsage > /dev/null 2>&1

# CPU-Load-Average
CPULoad=$(uptime | awk -F'[a-z]:' '{ print $2}' | sed 's/,//g' | sed 's/ /%20/g')
url_CPULoad=$URL_set_CPULoad$CPULoad
echo "$url_CPULoad"
curl -s $url_CPULoad > /dev/null 2>&1

# Memory Total in Gigabyte
MemTotalGB=$(free | grep Mem | awk '{printf "%.1f\n", $2/1024/1024}')
url_MemTotalGB=$URL_set_MemTotalGB$MemTotalGB
echo "$url_MemTotalGB"
curl -s $url_MemTotalGB > /dev/null 2>&1

# Memory Free in Gigabyte
MemFreeGB=$(free | grep Mem | awk '{printf "%.1f\n", ($4+$6)/1024/1024}')
url_MemFreeGB=$URL_set_MemFreeGB$MemFreeGB
echo "$url_MemFreeGB"
curl -s $url_MemFreeGB > /dev/null 2>&1

# Memory Used in Gigabyte
MemUsedGB=$(free | grep Mem | awk '{printf "%.1f\n", $3/1024/1024}')
url_MemUsedGB=$URL_set_MemUsedGB$MemUsedGB
echo "$url_MemUsedGB"
curl -s $url_MemUsedGB > /dev/null 2>&1

# Memory Free in Prozent
MemFreePercent=$(free | grep Mem | awk '{printf "%.1f\n", ($4+$6)/$2 * 100.0}')
url_MemFreePercent=$URL_set_MemFreePercent$MemFreePercent
echo "$url_MemFreePercent"
curl -s $url_MemFreePercent > /dev/null 2>&1

# Memory Used in Prozent
MemUsedPercent=$(free | grep Mem | awk '{printf "%.1f\n", $3/$2 * 100.0}')
url_MemUsedPercent=$URL_set_MemUsedPercent$MemUsedPercent
echo "$url_MemUsedPercent"
curl -s $url_MemUsedPercent > /dev/null 2>&1

# HDD-Temperaturen in Celsius
HDDTemp1=$(smartctl -A /dev/sda -d ata | grep Temperature_Celsius | awk '{print $10}')
url_HDDTemp1=$URL_set_HDDTemp1$HDDTemp1
echo "$url_HDDTemp1"
curl -s $url_HDDTemp1 > /dev/null 2>&1

HDDTemp2=$(smartctl -A /dev/sdb -d ata | grep Temperature_Celsius | awk '{print $10}')
url_HDDTemp2=$URL_set_HDDTemp2$HDDTemp2
echo "$url_HDDTemp2"
curl -s $url_HDDTemp2 > /dev/null 2>&1

HDDTemp3=$(smartctl -A /dev/sdc -d ata | grep Temperature_Celsius | awk '{print $10}')
url_HDDTemp3=$URL_set_HDDTemp3$HDDTemp3
echo "$url_HDDTemp3"
curl -s $url_HDDTemp3 > /dev/null 2>&1

HDDTemp4=$(smartctl -A /dev/sdd -d ata | grep Temperature_Celsius | awk '{print $10}')
url_HDDTemp4=$URL_set_HDDTemp4$HDDTemp4
echo "$url_HDDTemp4"
curl -s $url_HDDTemp4 > /dev/null 2>&1

HDDTemp5=$(smartctl -A /dev/sda -d ata | grep Temperature_Celsius | awk '{print $10}')
url_HDDTemp5=$URL_set_HDDTemp5$HDDTemp5
echo "$url_HDDTemp5"
curl -s $url_HDDTemp5 > /dev/null 2>&1

# Storage-Total Volume 1 in TB
StorageVolume1Total=$(df|awk '/volume1$/{printf "%.2f\n", ($2/1024/1024/1024)}')
url_StorageVolume1Total=$URL_set_StorageVolume1Total$StorageVolume1Total
echo "$url_StorageVolume1Total"
curl -s $url_StorageVolume1Total > /dev/null 2>&1

# Storage-Free Volume 1 in TB
StorageVolume1Free=$(df|awk '/volume1$/{printf "%.2f\n", ($4/1024/1024/1024)}')
url_StorageVolume1Free=$URL_set_StorageVolume1Free$StorageVolume1Free
echo "$url_StorageVolume1Free"
curl -s $url_StorageVolume1Free > /dev/null 2>&1

# Storage-Used Volume 1 in TB
StorageVolume1Used=$(df|awk '/volume1$/{printf "%.2f\n", ($3/1024/1024/1024)}')
url_StorageVolume1Used=$URL_set_StorageVolume1Used$StorageVolume1Used
echo "$url_StorageVolume1Used"
curl -s $url_StorageVolume1Used > /dev/null 2>&1

# Storage-Free Volume 1 in Prozent
StorageVolume1FreePercent=$(df|awk '/volume1$/{printf "%.1f\n", ($4/$2*100)}')
url_StorageVolume1FreePercent=$URL_set_StorageVolume1FreePercent$StorageVolume1FreePercent
echo "$url_StorageVolume1FreePercent"
curl -s $url_StorageVolume1FreePercent > /dev/null 2>&1

# Storage-Used Volume 1 in Prozent
StorageVolume1UsedPercent=$(df|awk '/volume1$/{printf "%.1f\n", ($3/$2*100)}')
url_StorageVolume1UsedPercent=$URL_set_StorageVolume1UsedPercent$StorageVolume1UsedPercent
echo "$url_StorageVolume1UsedPercent"
curl -s $url_StorageVolume1UsedPercent > /dev/null 2>&1

# Storage-Total Volume 2 in GB
StorageVolume2Total=$(df|awk '/volume2$/{printf "%.2f\n", ($2/1024/1024)}')
url_StorageVolume2Total=$URL_set_StorageVolume2Total$StorageVolume2Total
echo "$url_StorageVolume2Total"
curl -s $url_StorageVolume2Total > /dev/null 2>&1

# Storage-Free Volume 2 in GB
StorageVolume2Free=$(df|awk '/volume2$/{printf "%.2f\n", ($4/1024/1024)}')
url_StorageVolume2Free=$URL_set_StorageVolume2Free$StorageVolume2Free
echo "$url_StorageVolume2Free"
curl -s $url_StorageVolume2Free > /dev/null 2>&1

# Storage-Used Volume 2 in GB
StorageVolume2Used=$(df|awk '/volume2$/{printf "%.2f\n", ($3/1024/1024)}')
url_StorageVolume2Used=$URL_set_StorageVolume2Used$StorageVolume2Used
echo "$url_StorageVolume2Used"
curl -s $url_StorageVolume2Used > /dev/null 2>&1

# Storage-Free Volume 2 in Prozent
StorageVolume2FreePercent=$(df|awk '/volume2$/{printf "%.1f\n", ($4/$2*100)}')
url_StorageVolume2FreePercent=$URL_set_StorageVolume2FreePercent$StorageVolume2FreePercent
echo "$url_StorageVolume2FreePercent"
curl -s $url_StorageVolume2FreePercent > /dev/null 2>&1

# Storage-Used Volume 2 in Prozent
StorageVolume2UsedPercent=$(df|awk '/volume2$/{printf "%.1f\n", ($3/$2*100)}')
url_StorageVolume2UsedPercent=$URL_set_StorageVolume2UsedPercent$StorageVolume2UsedPercent
echo "$url_StorageVolume2UsedPercent"
curl -s $url_StorageVolume2UsedPercent > /dev/null 2>&1

# Uptime unterteilt in "volle Tage und Stunden"
UptimeSecs=$(cat /proc/uptime | awk '{printf"%.0f\n", $1}')
UptimeDays=$(($UptimeSecs/86400))
UptimeHours=$((($UptimeSecs/3600)-($UptimeDays*24)))
UptimeMinutes=$((($UptimeSecs/60)-($UptimeDays*24*60)-($UptimeHours*60)))
url_UptimeDays=$URL_set_UptimeDays$UptimeDays
echo "$url_UptimeDays"
curl -s $url_UptimeDays > /dev/null 2>&1
url_UptimeHours=$URL_set_UptimeHours$UptimeHours
echo "$url_UptimeHours"
curl -s $url_UptimeHours > /dev/null 2>&1
url_UptimeMinutes=$URL_set_UptimeMinutes$UptimeMinutes
echo "$url_UptimeMinutes"
curl -s $url_UptimeMinutes > /dev/null 2>&1

# DSM-Version
Version=$(more /etc.defaults/VERSION | grep productversion | awk -F '=' '{print $2}' | sed 's/"//g')
BuildNumber=$(more /etc.defaults/VERSION | grep buildnumber | awk -F '=' '{print $2}' | sed 's/"//g')
FixNumber=$(more /etc.defaults/VERSION | grep smallfixnumber | awk -F '=' '{print $2}' | sed 's/"//g')
DSMVersion=$Version"-"$BuildNumber"%20Update%20"$FixNumber
url_DSMVersion=$URL_set_DSMVersion$DSMVersion
echo "$url_DSMVersion"
curl -s $url_DSMVersion > /dev/null 2>&1

# Timestamp für letztes Update der Werte
TimestampDay=$(date +%Y-%m-%d)
TimestampTime=$(date +%H:%M:%S)
Timestamp=$TimestampDay"%20"$TimestampTime
url_Timestamp=$URL_set_Timestamp$Timestamp
echo "$url_Timestamp"
curl -s $url_Timestamp > /dev/null 2>&1

exit 0
