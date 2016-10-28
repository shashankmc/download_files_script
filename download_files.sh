#!/bin/sh

#creating new dir to avoid mess of all files.
mkdir Files_Download
cd Files_Download

#base url from which files can be downloaded, change as necessary
url="http://ktbs.kar.nic.in/New/"

#contains link to the file which contains all the file names available to download"
file_list="http://ktbs.kar.nic.in/New/jsonfile/textbooks.txt"
`wget $file_list`
`cat textbooks.txt | grep "pdf" > filenames_only.txt`

#set Field separator to identify when next line occurs
IFS=$'\n'
for line in `cat filenames_only.txt`
do
	#the field separator for each line is given as the fourth field. Might be wrong for many other"
	#filename=`echo $line | tr '\n' ' ' | cut -d':' -f4`
	#Grep is more effective and flexible to extract path and file name with ext. Change regex as necessary.
	#To try powerful regex, look at option P
	filename=`echo $line | tr '\n' ' ' | grep -oie 'text[a-zA-Z0-9.\/\(\)\ -]*.pdf'`

	#the first sed replacement is for ctrl-m character which is "return". 
	clean_filename=`echo $filename | sed 's///g'| sed 's/$//g' | sed 's/,//g' | sed 's/\}//g' | sed 's/"//g' | sed 's/\ //g'`
	`wget $url$clean_filename`
done
