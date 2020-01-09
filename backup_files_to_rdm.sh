#!/bin/bash
#Thomas Shaw 20200108

#this script will go into a specified project (dumu_dir)
#then search that directory for folders that contain .IMA files (dicoms)
#this needs to be done in levels unless there is a quicker way of doing it. 
#these folders will be archived (tar) and sent to RDM 
#then the entire folder is sent to RDM.

dumu_dir=/data/dumu/barth/7TShare/Data/3_studies/7Tea
rdm_dir=/winmounts/uqtshaw/data.cai.uq.edu.au/SEVENTEA-Q0757/7Tea_backup_from_DUMU/

#find all the folders that have IMA files in them
#find ${dumu_dir} -name '*.IMA' -printf '%h\n' | sort -u
#loop over the directories by making it into an array

i=0
while read line
do
    array[ $i ]="$line"        
    (( i++ ))
done < <(find ${dumu_dir} -name '*.IMA' -printf '%h\n' | sort -u)

#loop through the array $i number of times and tar each folder as you do it. 
j=0
while ((j < $i)) ;do
    tar cvzf ${array[$j]}.tar.gz -C ${j} .
    cd ${dumu_dir}
    let j++
done

#send the whole directory to UQRDM but excluding all the directories in the array
tar  --exclude-tag-under="*IMA"

#rm all the tar files in the dumu dir to save space


