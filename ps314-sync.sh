#!/bin/sh


#sudo mount -o ro /home/pi/img/ps314.a.img /ps314

CFG=/home/pi/ps314-rsnapshot.conf

sudo umount /ps314
sudo mount -o ro /dev/mapper/loop0p1 /ps314

rsnapshot -c $CFG -v sync
rsnapshot -c $CFG -v sync
rsnapshot -c $CFG -v alpha

sudo umount /ps314




