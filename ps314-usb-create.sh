
IMG=/home/pi/img/pi314.a.img

dd if=/dev/zero of=$IMG bs=4M count=500
sfdisk $IMG <<< ,,7
sudo kpartx -a -v $IMG
sudo mkfs.vfat /dev/mapper/loop0p1

