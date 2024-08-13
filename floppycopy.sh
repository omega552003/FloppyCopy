#! /bin/bash

# Set variables
ROOTDIR=$(dirname $0)

# Get file name from user input
read -p "Enter Filename: " FILENAME

# Set up directories
DESTINATION="$ROOTDIR/$FILENAME"
if [ ! -d "$DESTINATION/image" ]; then
    mkdir -p "$DESTINATION/image"
fi
cd $DESTINATION

# Create image from floppy
sudo ddrescue -d /dev/sda $FILENAME.img $FILENAME.logfile
sudo mount ./$FILENAME.img ./image

# Create archive of files on image
7z a -tzip "$FILENAME.zip" ./image/*

# Unmount image
sudo umount ./image
rmdir image