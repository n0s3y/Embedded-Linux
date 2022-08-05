
#!/usr/bin/env bash
textreset=$(tput sgr0) # reset the foreground colour
red=$(tput setaf 1)
yellow=$(tput setaf 2)
#shell script to find difference between two files for patching detecting

firm=`zenity --file-selection --file-filter='*.zip |*.bin' --title="Select your embedded linux firmware"`
binwalk -e $firm





FILE1=`zenity --file-selection --title="Select the file in your embedded system"`
case $? in
         0)
                echo "\"$FILE1\" selected.";;
         1)
                echo "No file selected.";;
        -1)
                echo "An unexpected error has occurred.";;
esac

FILE2=`zenity --file-selection --title="Select the corresponding File from the default linux kernel"`
case $? in
         0)
                echo "\"$FILE2\" selected.";;
         1)
                echo "No file selected.";;
        -1)
                echo "An unexpected error has occurred.";;
esac

set +o nounset
LC_ALL=C ; LANG=C ; export LC_ALL LANG
pe() { for _i;do printf "%s" "$_i";done; printf "\n"; }
pl() { pe;pe "-----" ;pe "$*"; }
db() { ( printf " db, ";for _i;do printf "%s" "$_i";done;printf "\n" ) >&2 ; }
db() { : ; }
C=$HOME/bin/context && [ -f "$C" ] && $C
set -o nounset



# Display samples of data files.
pl " Data files:"
head "$FILE1" "$FILE2"

# Set file descriptors.
exec 3<"$FILE1"
exec 4<"$FILE2"

# Code based on:
# http://www.linuxjournal.com/content/reading-multiple-files-bash

# Section 2, solution.
pl " Results:"

eof1=0
eof2=0
count1=0
count2=0
while [[ $eof1 -eq 0 || $eof2 -eq 0 ]]
do
  if read a <&3; then
    let count1++
    # printf "%s, line %d: %s\n" $FILE1 $count1 "$a"
  else
    eof1=1
  fi
  if read b <&4; then
    let count2++
    # printf "%s, line %d: %s\n" $FILE2 $count2 "$b"
  else
    eof2=1
  fi
  if [ "$a" != "$b" ]
  then
    echo " File $FILE1 and $FILE2 differ at lines ${red} $count1 ${textreset},  ${red} $count2 ${textreset}:"
    pe ${red} "$a" ${textreset}
    pe ${yellow} "$b" ${textreset}
    # exit 1
  fi
done

exit 0
