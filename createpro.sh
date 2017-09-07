#!/bin/sh

FAILED=1

if [ $# -lt 1 ];then
    echo "USAGE:$0 Error!"
	echo "Example:$0 /home/Galen/Test"
	exit ${FAILED}
elif [ $# -eq 1 ];then
    tflag=0
else 
	if [ $2 -ne 0 ];then
	    tflag=1
	else
	    tflag=0
	fi
fi

absolutePath=$1

if [ -d ${absolutePath} ];then
    echo ${absolutePath} Exists!
	exit ${FAILED}
fi

project=${absolutePath##*/}
projectLower=$(echo $project | sed 's/\b[A-Z]/\L&/g')
projectUpper=$(echo $project | sed 's/\b[a-z]/\U&/g')

echo "create pro: ${absolutePath%/*} ${project}"
mkdir -p ${absolutePath}
cd ${absolutePath}

if [ ${tflag} -ne 0 ];then
    sourcePath=F:\\galen\\ProjectsTemplate\\DllWithTest\\*
else
    sourcePath=F:\\galen\\ProjectsTemplate\\NewAppTemplate2\\*
fi

sourcePath=${sourcePath//\\//}

cp -rf ${sourcePath} `pwd`

function RenameDF() {
    oldstr=$1
    newstr=$2
    find $3 -name "*$oldstr*" | awk -v new=$newstr -v old=$oldstr 'BEGIN{FS="/";OFS="/"}{org=$0;gsub(old, new, $NF);system("mv "org" "$0)}'
}

function ChangeField() {
    oldstr=$1
	newstr=$2
    sed -i "s/${oldstr}/${newstr}/g" `grep ${oldstr} -rl $3`
}

RenameDF "@D{PROJ_NAME}" ${project} `pwd`
RenameDF "@D{PROJ_NAME_LOWER}" ${projectLower} `pwd`
ChangeField "@D{PROJ_NAME}" ${project} `pwd`
ChangeField "@D{PROJ_NAME_LOWER}" ${projectLower} `pwd`
ChangeField "@D{DATE}" $(date +%Y\\/%m\\/%d) `pwd`
ChangeField "@D{TIME}" $(date +%H:%M:%S) `pwd`
ChangeField "@D{AUTHOR}" "Galen" `pwd`

cd -
exit 0