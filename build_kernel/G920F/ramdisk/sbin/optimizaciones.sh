#!/system/bin/sh

# Busybox
if [ -e /su/xbin/busybox ]; then
	BB=/su/xbin/busybox;
else if [ -e /sbin/busybox ]; then
	BB=/sbin/busybox;
else
	BB=busybox;
fi;
fi;

# init.d support
if [ ! -e /system/etc/init.d ]; then
 if [ "$($BB mount | grep ' /system ' | grep -c 'ro,')" -eq "1" ]; then
    $BB mount -o remount,rw /system
 fi

    mkdir /system/etc/init.d
    chown -R root.root /system/etc/init.d
    chmod -R 755 /system/etc/init.d
 if [ "$($BB mount | grep ' /system ' | grep -c 'ro,')" -eq "1" ]; then
    $BB mount -o remount,ro /system
 fi
fi

# start init.d
for FILE in /system/etc/init.d/*; do
	sh $FILE >/dev/null
done;

# mediakill
killall -9 android.process.media
killall -9 mediaserver

$BB mount -t rootfs -o remount,ro rootfs
$BB mount -o remount,ro /system
$BB mount -o remount,rw /data
