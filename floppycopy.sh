#! /bin/bash

############################################################
# Help                                                     #
############################################################
Help()
{
   # Display Help
   echo "floppycopy creates a dump, extracts and compresses a floppy disk."
   echo
   echo "Syntax: floppycopy.sh [-f|h]"
   echo "options:"
   #echo "g     Print the GPL license notification."
   echo "f     output filename."
   echo "h     Print this Help."
   #echo "v     Verbose mode."
   #echo "V     Print software version and exit."
   echo
}

############################################################
############################################################
# Main program                                             #
############################################################
############################################################

# Set variables
ROOTDIR=$(dirname $0)

############################################################
# Process the input options. Add options as needed.        #
############################################################
# Get the options
while getopts ":fh:" option; do
   case $option in
      h) # display Help
         Help
         exit;;
      f) # Enter a name
         FILENAME=$OPTARG;;
     \?) # Invalid option
         echo "Error: Invalid option"
         exit;;
   esac
done

# Get file name from user input
if test -z $FILENAME ; then
    read -p "Enter Filename: " FILENAME
fi

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