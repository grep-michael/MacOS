#!/usr/bin/env bash
TECHID=
SYSUID=
SERIAL=
SREENSIZE=
BUILDNO=
CPUNAME=
OSVER=
COSGRADE=
FINALGRADE=
SYSNOTES=
SYSTYPE=
DISK=
SYSBAT=
SYSCOLOR=




SERIALOUTPUT=$(ioreg -l | grep IOPlatformSerialNumber)
#SERIAL=$(echo $SERIAL | sed 's/^.//;s/.$//')
SERIAL=$(echo $SERIALOUTPUT | sed -n 's/.*"IOPlatformSerialNumber" = "\([^"]*\)".*/\1/p')

exit
# Prompt to ask if user wants to erase the drive
read -p "Status: Would you like to erase the drive? (yes/no): " ERASE_DRIVE

# Convert input to uppercase with tr
ERASE_DRIVE=$(echo "$ERASE_DRIVE" | tr '[:lower:]' '[:upper:]')

if [[ "$ERASE_DRIVE" != "NO" && "$ERASE_DRIVE" != "N" ]]; then 
    echo "Status: Fetching list of internal drives..."
    internal_disks=$(diskutil list | grep "internal" | awk '{print $1}')
    
    if [ -z "$internal_disks" ]; then
        echo "Status: No internal disks found."
        echo "Status: No internal disks found." >> ./Desktop/$SYSUID_UPPER.txt
        exit 1
    fi

# Extract the numeric part of the BUILDNO_UPPER variable for format decision
        BUILDNO_NUMERIC=${BUILDNO_UPPER:1}
        
        if [[ $BUILDNO_NUMERIC -lt 1503 ]]; then
            FORMAT_TYPE="JHFS+"
            ERASE_LOG_TITLE="DISK ERASURE LOG - JHFS+"
        else
            FORMAT_TYPE="APFS"
            ERASE_LOG_TITLE="DISK ERASURE LOG - APFS"
        fi



# Display detailed information for each internal drive
echo "Status: Internal disks and their partitions:"
echo "Status: Internal disks and their partitions:" >> ~/Desktop/$SYSUID_UPPER.txt


# Iterate over each internal disk and append the diskutil output to the file
for disk in $internal_disks; do
    	echo "—————————————————————————————————————————————————————————————————————————" >> ~/Desktop/$SYSUID_UPPER.txt
    	echo "—————————————————————————————————————————————————————————————————————————"
        echo "$ERASE_LOG_TITLE" >> ./Desktop/$SYSUID_UPPER.txt
        echo "$ERASE_LOG_TITLE"
    	echo "—————————————————————————————————————————————————————————————————————————" >> ~/Desktop/$SYSUID_UPPER.txt
    	echo "—————————————————————————————————————————————————————————————————————————"
    # Use diskutil list and tee to append to the file and display to the user
    diskutil list $disk | tee -a ~/Desktop/$SYSUID_UPPER.txt
done
	echo "—————————————————————————————————————————————————————————————————————————" >> ~/Desktop/$SYSUID_UPPER.txt
	echo "—————————————————————————————————————————————————————————————————————————"

# Prompt the user to enter the disk number for erasure
echo "Status: Please enter the number of the internal disk you wish to erase (e.g., enter 0 for /dev/disk0):"

    read DISK
    
    selected_disk="/dev/disk$DISK"
    if echo "$internal_disks" | grep -q "$selected_disk"; then
                
        # Proceed with erasure
    	echo "—————————————————————————————————————————————————————————————————————————" >> ~/Desktop/$SYSUID_UPPER.txt
    	echo "—————————————————————————————————————————————————————————————————————————"
        echo "Status: Erasing $selected_disk with $FORMAT_TYPE format..."
        echo "Status: Erasing $selected_disk with $FORMAT_TYPE format..." >> ./Desktop/$SYSUID_UPPER.txt
    	echo "—————————————————————————————————————————————————————————————————————————" >> ~/Desktop/$SYSUID_UPPER.txt
    	echo "—————————————————————————————————————————————————————————————————————————"
        diskutil eraseDisk $FORMAT_TYPE 'Macintosh HD' $selected_disk
        
    	echo "—————————————————————————————————————————————————————————————————————————" >> ~/Desktop/$SYSUID_UPPER.txt
    	echo "—————————————————————————————————————————————————————————————————————————"
        echo "Status: Internal disk successfully erased with $FORMAT_TYPE format." >> ./Desktop/$SYSUID_UPPER.txt
    	echo "—————————————————————————————————————————————————————————————————————————" >> ~/Desktop/$SYSUID_UPPER.txt
    	echo "—————————————————————————————————————————————————————————————————————————"
    else
    	echo "—————————————————————————————————————————————————————————————————————————" >> ~/Desktop/$SYSUID_UPPER.txt
    	echo "—————————————————————————————————————————————————————————————————————————"
        echo "Status: Invalid selection or the selected disk is not an internal disk."
        echo "Status: Invalid selection or the selected disk is not an internal disk." >> ./Desktop/$SYSUID_UPPER.txt
    	echo "—————————————————————————————————————————————————————————————————————————" >> ~/Desktop/$SYSUID_UPPER.txt
    	echo "—————————————————————————————————————————————————————————————————————————"
        # Optionally handle invalid input without exiting the script
    fi



exit(1)
mkdir -p ./Share

# Specify the source and destination paths
source_file="./Desktop/$SYSUID_UPPER.txt"
destination="./Share"
image_volume="/Volumes/MacOS Images"
logs_directory="$image_volume/Logs"

# Check if the volume exists
if [ -d "$image_volume" ]; then
    echo "Status: Volume exists: $image_volume"

    # Check if the Logs directory exists
    if [ ! -d "$logs_directory" ]; then
       echo "Status: Logs directory does not exist. Creating..."
       if sudo install -d "$logs_directory"; then
           echo "Status: Logs directory created successfully"
       else
           echo "Error: Failed to create logs directory"
       fi
    fi

    # Copy file to logs directory
    echo "Status: Copying backup file to logs directory..."
    if yes | cp "$source_file" "$logs_directory/$SYSUID_UPPER.txt"; then
        echo "Status: Backup file successfully copied to logs."
        echo "Status: Backup file successfully copied to logs." >> "./Desktop/$SYSUID_UPPER.txt"
        echo "Status: Backup file successfully copied to logs." >> "$logs_directory/$SYSUID_UPPER.txt"

    else
        echo "Error: Failed to copy backup file to logs."
        echo "Error: Failed to copy backup file to logs." >> "./Desktop/$SYSUID_UPPER.txt"
        echo "Error: Failed to copy backup file to logs." >> "$logs_directory/$SYSUID_UPPER.txt"
    fi
else
    echo "Status: Volume does not exist: $image_volume"
fi


# Copy the file to the destination
echo "Status: Copying file to server..."
yes | cp $source_file $destination/Temp/$SYSUID_UPPER.txt
yes | cp $source_file $destination/Logs/$SYSUID_UPPER.txt

# Verify the file in the destination
echo "Status: Verifying file in destination..."
if [ -e "$destination/Logs/$SYSUID_UPPER.txt" ]; then
    echo "Status: File successfully copied to server."
    echo "Status: File successfully copied to server." >> $destination/Logs/$SYSUID_UPPER.txt
else
    echo "Error: File failed copying to server."
    echo "Error: File failed copying to server." >> $destination/Logs/$SYSUID_UPPER.txt
fi

# Unmount the share
echo "Status: Unmounting share..."
umount $destination
echo "Status: Share unmounted."
