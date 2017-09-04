#!/bin/sh

if [ $# -lt 2 ];then
echo "USAGE:$0 few parameters;need at least 3 parameters!"
echo "example:$0 zgl Galen"
exit 1
elif [ $# -eq 2 ];then
app=$0
old=$1
new=$2
dir=`pwd`
else
app=$0
old=$1
new=$2
path=$3
fi

function RenameDir() {
    oldstr=$1
    newstr=$2
    find $3 -name "*$oldstr*" -type d | awk -v new=$newstr -v old=$oldstr 'BEGIN{FS="/";OFS="/"}{org=$0;gsub(old, new, $NF);system("mv "org" "$0)}'
}

function RenameFile() {
    oldstr=$1
    newstr=$2
    find $3 -name "*$oldstr*" -type f | awk -v new=$newstr -v old=$oldstr 'BEGIN{FS="/";OFS="/"}{org=$0;gsub(old, new, $NF);system("mv "org" "$0)}'
}

function RenameDF() {
	oldstr=$1
    newstr=$2
	RenameDir $oldstr $newstr $3
	RenameFile $oldstr $newstr $3
}

function ChangeField() {
    oldstr=$1
	newstr=$2
    sed -i "s/$oldstr/$newstr/g" `grep $oldstr -rl --exclude=$app $3`
}

oldLower=$(echo $old | sed 's/\b[A-Z]/\L&/g')
oldUpper=$(echo $old | sed 's/\b[a-z]/\U&/g')
newLower=$(echo $new | sed 's/\b[A-Z]/\L&/g')
newUpper=$(echo $new | sed 's/\b[a-z]/\U&/g')

echo $oldLower $oldUpper $newLower $newUpper $path

RenameDF $oldLower $newLower $path
RenameDF $oldUpper $newUpper $path
ChangeField $oldLower $newLower $path
ChangeField $oldUpper $newUpper $path