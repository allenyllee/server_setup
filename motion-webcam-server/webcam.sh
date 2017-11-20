#!/bin/bash

##############
# linux - How to execute a shellscript when I plug-in a USB-device - Unix & Linux Stack Exchange
# https://unix.stackexchange.com/questions/65891/how-to-execute-a-shellscript-when-i-plug-in-a-usb-device
# 
# With env, you can see what environment is set from udev and with file, you will discover the file type.
# The concrete attributes for your device can be discovered with lsusb
##############
# ubuntu - How to identify USB webcam by serial number from the Linux command line - Super User
# https://superuser.com/questions/902012/how-to-identify-usb-webcam-by-serial-number-from-the-linux-command-line
# 
# It is possible to identify all cameras. The command
# $ sudo lsusb -v -d 046d:082d | grep -i serial
# iSerial 1 05C6D16F
# 
# Now the command
# 
# $ sudo udevadm info --query=all /dev/video1 | grep 'VENDOR_ID\|MODEL_ID\|SERIAL_SHORT'
# E: ID_MODEL_ID=082d
# E: ID_SERIAL_SHORT=05C6D16F
# E: ID_VENDOR_ID=046d
# 
# returns the appropriate codes for this particular camera. 
# Trial and error with all /dev/videoX devices allows pigeon-holing all of them.
##############

LOGPATH=/tmp/webcam.log

echo '========== begin of udev events ===============' >>$LOGPATH
### echo '========== print environment variables ===========' >>$LOGPATH
### env >>$LOGPATH
### echo '' >>$LOGPATH
### 
### echo '========== device path =============' >>$LOGPATH
### # check device file type
### file "/sys${DEVPATH}" >>$LOGPATH
### echo '' >>$LOGPATH
### 
### echo '========== do somthing =============' >>$LOGPATH

# if $ACTION is "add" and /sys$DEVPATH is a directory
if [ "${ACTION}" = add -a -d "/sys${DEVPATH}" ]; then
    # if string $DEVPATH include string "video", then do somthing...
    if [ -n "$(echo ${DEVPATH} | grep "video*")" ]; then

        # welcome message
        echo "[$(date)] Hello webcam!">>$LOGPATH

        # get full Udev env variable
        ### env >>$LOGPATH

        # get device id & vendor id & device file path
        ### env | grep "ID_MODEL_ID\|ID_VENDOR_ID\|DEVNAME" >>$LOGPATH
        VENDOR_ID="$(env | grep "ID_VENDOR_ID" | cut -d'=' -f2)"
        DEVICE_ID="$(env | grep "ID_MODEL_ID" | cut -d'=' -f2)"

        # get usb device info
        echo "$(lsusb -d $VENDOR_ID:$DEVICE_ID)" >>$LOGPATH

        # get serial number
        SERIAL_NUM="$(lsusb -v -d $VENDOR_ID:$DEVICE_ID | grep "iSerial" | awk '{print $3}')"
        echo "Serial number is \"$SERIAL_NUM\"" >>$LOGPATH

        # get product name (from column 3 and after)
        PRODUCT_NAME="$(lsusb -v -d $VENDOR_ID:$DEVICE_ID | grep "idProduct" | awk -v N=3 '{sep=""; for (i=N; i<=NF; i++) {printf("%s%s",sep,$i); sep=OFS}; printf("\n")}')"

        # Udev rule to run a script after plugging in USB device on Ubuntu Linux operating system | TechyTalk
        # http://www.techytalk.info/udev-rule-to-run-script-after-plugging-in-usb-device-on-ubuntu-linux-operating-system/
        # 
        # write into /var/log/syslog
        # check it with cmd: tail -f /var/log/syslog
        logger "$PRODUCT_NAME is starting..."

        # set camera settings
        # set power_line_frequency = 2 (60Hz)
        # set exposure_auto_priority = 0 (disable)(don't auto tune exposure)
        v4l2-ctl -c power_line_frequency=2 2>&1 | logger
        v4l2-ctl -c exposure_auto_priority=0 2>&1 | logger

        # get camera settings (v4l2-ctl --all will get all settings)
        v4l2-ctl -C power_line_frequency 2>&1 | tee -a $LOGPATH
        v4l2-ctl -C exposure_auto_priority 2>&1 | tee -a $LOGPATH
        v4l2-ctl -d /dev/video1 --all | grep "Width/Height" 2>&1 | awk '{print $1 $2, $3}' | tee -a $LOGPATH

        echo "" >>$LOGPATH
    fi
fi

### 
### echo '' >>$LOGPATH
### 
### echo '========== end of this call ===============' >>$LOGPATH
### echo '' >>$LOGPATH
### echo '' >>$LOGPATH