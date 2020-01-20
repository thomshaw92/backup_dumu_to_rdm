#!/bin/bash
#Thomas Shaw 20200108

#this script will go into a specified project (dumu_dir)
#then search that directory for folders that contain .IMA files (dicoms)
#each folder that contains IMAs will be archived
#the entire folder is sent to RDM excluding the folders that contian .IMA files (using the --exclude flag of tar)
#then the archived folders are deleted. 
#USE FULL PATH 
dumu_dir=/data/dumu/barth/7TShare/Data/3_studies/7Tea
rdm_dir=/winmounts/uqtshaw/data.cai.uq.edu.au/SEVENTEA-Q0757/7Tea_backup_from_DUMU/

#find all the folders that have IMA files in them 
#find ${dumu_dir} -name '*.IMA' -printf '%h\n' | sort -u
#loop over the directories by making it into an array

cd $dumu_dir
i=0
shopt -s dotglob
shopt -s nullglob
array=(`find . -name '*.IMA' -printf '%h\n' | sort -u`)
for dir in "${array[@]}" ; do
    echo "$dir"
    (( i++))
done

#loop through the array $i number of times and tar each folder as you do it. 
j=0
while ((j < $i)) ; do
    cd $dumu_dir
    cd ${array[$j]}
    folder=${PWD##*/}
    cd ../
    tar cfz ${folder}.tar.gz ${folder}/*
    let j++
done

#send the whole directory to UQRDM but excluding all the directories in the array
exclude_options=()
for x in "${array[@]}"; do
  exclude_options+=(--exclude="$x")
done

cd $dumu_dir
tar -czvf $rdm_dir/transferred_from_dumu.tar.gz "${exclude_options[@]}" ./

#rm all the tar files in the dumu dir to save space

for y in "${array[@]}"; do
    rm -r ${y}.tar.gz  
done

