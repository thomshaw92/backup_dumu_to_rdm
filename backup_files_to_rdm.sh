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
#rm $dumu_dir/filenames_to_archive.txt
if [[ ! -e  $dumu_dir/filenames_to_archive.txt ]] ; then
    find ${dumu_dir} -name '*.IMA' -printf '%h\n' | sort -u >> $dumu_dir/filenames_to_archive.txt
fi
#make it into an array
IFS=$'\n' read -d '' -r -a array < $dumu_dir/filenames_to_archive.txt

cd $dumu_dir
i=0
for dir in "${array[@]}" ; do
    echo $dir
    (( i++))
done


#loop through the array $i number of times and tar each folder as you do it. 
j=0
while ((j < $i)) ; do
    cd $dumu_dir
    echo "The directory to tar is called ${array[$j]}"
    cd "${array[$j]}"
    var=${array[$j]}
    folder=""
    folder=`echo "${var##*/}"`
    cd "${var%/*}"
    echo "I am now a level above the last dir in $PWD"
    echo "The folder below I am now archiving is called" $folder "..."
    tar cfz "${folder}.tar.gz" ${folder}/*
    echo "done"
    (( j++ ))
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

