#!/bin/bash

FullScriptPath=`pwd`
SourcePath="SourceFiles"

write_license() {
    (
        echo \/\***************************************************************************
		echo \ @file:\ \ \ \ \ \ \ \ ${1##*/}
		echo \ @author:\ \ \ \ \ \ Galen
		echo \ @data:\ \ \ \ \ \ \ \ $(date +%Y/%m/%d)
		echo \ @time:\ \ \ \ \ \ \ \ $(date +%H:%M:%S)
		echo \ @License:\ \ \ \ \ Copyright \(c\) 2014-2017 Galen
		echo \ @verbatim
		echo \ \ \ \ \<author\>\ \ \ \ \<time\>\ \ \ \ \ \ \<version\>\ \ \ \ \ \ \ \ \<desc\>
		echo \ \ \ \ \ Galen\ \ \ \ $(date +%Y/%m/%d)\ \ \ \ \ \ 0.1.0\ \ \ \ \ begin this module
		echo \ @endverbatim
        echo \***************************************************************************/
        echo
    ) >> $1
}

write_header() {
    CommandPath="$1"
    Dir=${CommandPath%/*}

    echo Generating header ${CommandPath}.h..
    if [ ! -d "$SourcePath/$Dir" ]; then
        mkdir -p $SourcePath/$CommandPath.h
        rm -rf $SourcePath/$CommandPath.h
    fi

    if [ ! -f "${SourcePath}/${CommandPath}.h" ]; then
        write_license ${SourcePath}/${CommandPath}.h

        str=$(echo $Dir | tr "[:lower:]" "[:upper:]")
        (
            echo "#ifndef ${str}_H"
            echo "#define ${str}_H"
            echo
            echo "#endif // ${str}_H"
        ) >> ${SourcePath}/${CommandPath}.h
    else
        echo ${SourcePath}/${CommandPath}.h Exist!
    fi
}

write_source() {
    CommandPath="$1"
    Dir=${CommandPath%/*}

    echo Generating header ${CommandPath}.cpp..
    if [ ! -d "$SourcePath/$Dir" ]; then
        mkdir -p $SourcePath/$CommandPath.cpp
        rm -rf $SourcePath/$CommandPath.cpp
    fi

    if [ ! -f "${SourcePath}/${CommandPath}.cpp" ]; then
        write_license ${SourcePath}/${CommandPath}.cpp
        (
            if [ -f "${SourcePath}/${CommandPath}.h" ];then
                echo "#include \"${CommandPath##*/}.h\""
            fi
        ) >> ${SourcePath}/${CommandPath}.cpp
    else
        echo ${SourcePath}/${CommandPath}.cpp Exist!
    fi
}

write_module() {
    CommandPath="$1"
    if [ -z "$CommandPath" ]; then
        echo "can't create empty module!"
    else
        echo Generating module ${CommandPath}..
        write_header $CommandPath
        write_source $CommandPath
    fi
}

case $1 in
    header)
      write_header $2
    ;;
    source)
      write_source $2
    ;;
    *)
      write_module $1
    ;;
esac
