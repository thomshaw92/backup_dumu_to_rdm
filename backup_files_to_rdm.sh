#!/bin/bash
#Thomas Shaw 20200108

#this script will go into a specified project (dumu_dir)
#then search that directory for folders that contain .IMA files (dicoms)
#each folder that contains IMAs will be archived
#the entire folder is sent to RDM excluding the folders that contian .IMA files (using the --exclude flag of tar)
#then the archived folders are deleted. 

dumu_dir=~/test_dumu_dir
#/data/dumu/barth/7TShare/Data/3_studies/7Tea
rdm_dir=~/test_rdm_dir
#/winmounts/uqtshaw/data.cai.uq.edu.au/SEVENTEA-Q0757/7Tea_backup_from_DUMU/

#find all the folders that have IMA files in them 
#find ${dumu_dir} -name '*.IMA' -printf '%h\n' | sort -u
#loop over the directories by making it into an array

cd $dumu_dir
i=0
while read line
do
    array[ $i ]="$line"        
    (( i++ ))
done < <(find . -name '*.IMA' -printf '%h\n' | sort -u)

#loop through the array $i number of times and tar each folder as you do it. 
j=0
while ((j < $i)) ; do
    cd $dumu_dir
    #cd ${array[$j]}
    tar cfz ${array[$j]}.tgz --files-from <(printf "%s\n" "${array[$j]}")
    #tar -cvzf ${array[$j]}.tar.gz ${array[$j]} 
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
include_options=()
for y in "${array[@]}"; do
    include_options+=("${y}.tgz ")
done
		      
rm -r ${include_options} 
