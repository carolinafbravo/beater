BEATER(1)



NAME
       beater - battery eater like utility

DESCRIPTION
	Calculates  the duration of your laptop's battery life and generates a 
	plot showing the battery discharge over the time. The functionality of 
	this script isvery smiliar than the popular battery-eater program 
	avaliable for other non-free platforms.

DEPENDENCIES
	The enssence of this script relies on the battery-stats package by 
	Karl E. Jorgensen <karl@jorgensen.com>

USAGE
	execute sudo beater.sh
	unplug your ac adapter and wait till your computer shutdowns
	on the nex boot the battery graph will be avaliable at /usr/share/battery-eater/battery.png

FILES
   /usr/share/battery-eater/beater.sh
       main script

   /usr/share/battery-eater/battery-stats.log
        the file where the battery statistics are collected instead of using 
	the default location /var/log/battery-stats.log

   /usr/share/battery-eater/battery.png
        plot how sumarizes all the information about battery

   /usr/share/battery-eater/debug.log
        log file for debugin purposes

   /usr/share/battery-stats/graph-setup
        file containing the configuration of gnuplot used by battery-graph to 
	generate the battery graphic. This file is temporary modified by beater  
	for  allowing save the plot to a file.

SEE ALSO
       battery-stats, battery-graph(1), battery-stats-collector(8).

AUTHOR
       Carolina Fdez. Bravo <carolinafbravo@gmail.com>




                                                                                                                                                           BEATER(1)
