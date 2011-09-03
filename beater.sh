#!/bin/bash
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

DIR="/usr/share/battery-eater"
DATA_FILE="${DIR}/battery-stats.log"
LOG_FILE="${DIR}/debug.log"
IMG_FILE="${DIR}/battery.png"
GNUPLOT_CONFIG="/usr/share/battery-stats/graph-setup"
DEBUG=1
BGCOLOR="Orange"
TXTCOLOR="Black"

function battery_low(){
	local RESULT=$(( $(( `cat /proc/acpi/battery/BAT0/info | \
		grep "design capacity low:" | sed "s/ //g" | \
		cut -d: -f2 | cut -dm -f1` )) + 10 ))
	echo "$RESULT"
}

function battery_status(){
	local RESULT=$(( `cat /proc/acpi/battery/BAT0/state | \
		grep "remaining capacity:" | sed "s/ //g" | \
		cut -d: -f2 | cut -dm -f1` ))
	echo "$RESULT"
}

function _hms(){
 	local S=${1}
	((h=S/3600))
	((m=S%3600/60))
	((s=S%60))
	echo "${h}h${m}m${s}s"
}

BEGIN=`date -R`
MIN=$(battery_low)

killall battery-stats-collector
battery-stats-collector -o $DATA_FILE -i 5 &

while [ $(( STATUS=$(battery_status) )) -gt $MIN ]; do
	echo remaining capacity: $STATUS mAh
	sleep 5s
done

END=`date -R`
SECONDS=$(( (`date -d "$END" +%s`) - (`date -d "$BEGIN" +%s`) ))

BEGIN_STR=`date -d "$BEGIN" '+%Y/%m/%d %H:%M'`
END_STR=`date -d "$END" '+%Y/%m/%d %H:%M'`

cp  $GNUPLOT_CONFIG $GNUPLOT_CONFIG.backup

if grep -q "set term" $GNUPLOT_CONFIG; then
	sed -i '/set term/d'  $GNUPLOT_CONFIG
fi

if grep -q "set term output" $GNUPLOT_CONFIG; then
	sed -i '/set output/d'  $GNUPLOT_CONFIG
fi

echo "set term png" >> $GNUPLOT_CONFIG
echo "set output  \"${IMG_FILE}\""  >> $GNUPLOT_CONFIG 

battery-graph --from "${BEGIN_STR}" --to "${END_STR}" ${DATA_FILE}

sed -i '/set term png/d' $GNUPLOT_CONFIG
sed -i '/set output/d' $GNUPLOT_CONFIG

if [ -f ${IMG_FILE} ]; then rm ${IMG_FILE}; fi

convert "${IMG_FILE}" -size x45 -background "${BGCOLOR}" -fill ${TXTCOLOR} \
	label:"`_hms ${SECONDS}`" +swap -gravity center -append "${IMG_FILE}"

convert "${IMG_FILE}" -size x50 -background "${BGCOLOR}" -fill ${TXTCOLOR} \
	label:"Battery Life" +swap -gravity center -append "${IMG_FILE}"

if [ $DEBUG -gt 0 ]; then
	touch $LOG_FILE
	echo "--------------------------------------------" | tee -a $LOG_FILE
	echo `date` | tee -a $LOG_FILE
	echo --from \"${BEGIN_STR}\" --to \"${END_STR}\" | tee -a $LOG_FILE
fi
