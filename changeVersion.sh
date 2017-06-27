read -p "Choose Project name 1.DropAp 2.NETTI(Easy) 3.ICE : " projectNumber

if [ $projectNumber == 1 ]; then
    projectName="dropap"
elif [ $projectNumber == 2 ] || [ $projectNumber == 3 ]; then
    projectName="blackloud"
else
    echo "Input correct number" && exit 0
fi

#read -p "Input iOS bundle identifier : " identifier
#test -z ${identifier} && echo "You MUST input identifier." && exit 0
#read -p "Input android package name : " package
#test -z ${identifier} && echo "You MUST input identifier." && exit 0
IFS=$'\t\n'
iosPathArray=( $(find . -type f -name "*Info.plist" -exec grep -l ${projectName} {} +) )
androidPathArray=( $(find . -type f -name "AndroidManifest.xml" -exec grep -l ${projectName} {} +) )
unset $IFS
#echo ${iosPathArray[1]}


for i in ${iosPathArray[@]}
do
    echo "iOS path : $i"
    version=$(awk -F"[<>]" '/CFBundleShortVersionString/ {getline;print $3;exit}' $i)
    echo "iOS current version : ${version}"
    read -p "Input new ios version : " iosNewVersion
    perl -i -pe s/${version}/${iosNewVersion}/g $i
    if [ $? -eq 0 ]; then
        echo OK
    else
        echo FAIL
    fi
done

for i in ${androidPathArray[@]}
do
    echo "Android path : $i"
    version=$(grep "versionName" $i | awk -F"\"" '{print $2}')
    echo "Android current version : ${version}"
    read -p "Input new android version : " androidNewVersion
    #sed -i s/${androidCurrentVersion}/${androidNewVersion}/g ${androidPath}
    perl -i -pe s/${version}/${androidNewVersion}/g $i
    if [ $? -eq 0 ]; then
        echo OK
    else
        echo FAIL
    fi



lastNum=${version##*.}
if [ $projectNumber == 3 ] && [ ${#lastNum} == 1 ]; then
    version=${version:0:${#version}-1}0${lastNum}
fi

newlastNum=${androidNewVersion##*.}
if [ $projectNumber == 3 ] && [ ${#newlastNum} == 1 ]; then
    androidNewVersion=${androidNewVersion:0:${#androidNewVersion}-1}0${newlastNum}
    echo "versionCode : " ${androidNewVersion}
fi


#echo "var01 len= ${#x2}"
    currentVCode=${version//./}
    if [[ $currentVCode == 0* ]]; then
        currentVCode=${currentVCode:1}
    fi
    newVCode=${androidNewVersion//.}
    if [[ $newVCode == 0* ]]; then
        newVCode=${newVCode:1}
    fi

#sed -i s/${currentVCode}/${newVCode}/g ${androidPath}
    perl -i -pe s/${currentVCode}/${newVCode}/g $i
    if [ $? -eq 0 ]; then
        echo OK
    else
    echo FAIL
    fi
done
