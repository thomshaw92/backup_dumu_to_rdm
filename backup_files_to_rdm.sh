#!/bin/bash
#Thomas Shaw 20200108

#this script will go into a specified project (dumu_dir)
#then search that directory for folders that contain .IMA files (dicoms)
#this needs to be done in levels unless there is a quicker way of doing it. 
#these folders will be archived (tar) and sent to RDM 
#then the entire folder is sent to RDM.

dumu_dir=/data/dumu/barth/7TShare/Data/3_studies/7Tea
rdm_dir=/winmounts/uqtshaw/data.cai.uq.edu.au/SEVENTEA-Q0757/7Tea_backup_from_DUMU/
#transfer all files across to RDM unless a file 


#find all the folders that have IMA files in them

find ${dumu_dir} -name '*.IMA' -printf '%h\n' | sort -u


#loop over the directories by making it into an array
i=0
while read line
do
    array[ $i ]="$line"        
    (( i++ ))
done < <(ls -ls)

echo ${array[1]}



for directoryname in `find ${dumu_dir}/* -maxdepth 1 -type d ` ;do
    cd ${directoryname}
    myarray=(`find ./ -maxdepth 1 -name "*.IMA"`)
    if [ ${#myarray[@]} -gt 0 ]; then
	echo ${x}
    fi
    cd ../
done



tar -czvf my_directory.tar.gz -C my_directory .
The -C my_directory tells tar to change the current directory to my_directory, and then . means "add the entire current directory" (including hidden files and sub-directories).





find / -type f -name "*IMA" -exec tar -rf archive.tar '{}' \;
find $dumu_directory -type f -name "*.in"
