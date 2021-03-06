#! /bin/bash



pathToDateFormater='/home/heinrich/PHENOME/Ontology/DateParser.py'
pathToCSVparser='/home/heinrich/PHENOME/Ontology/CSVparser.py'
pathToCsv='/home/heinrich/PHENOME/Ontology/toParse/csv/'
pathToCsvParsed='/home/heinrich/PHENOME/Ontology/toParse/csv/parsed'
pathToTurtle='/home/heinrich/PHENOME/Ontology/toParse/turtle'
pathToConfig='/home/heinrich/PHENOME/Ontology/toParse/json'

# All path should be absolute !
function parse_date
{
    input=$@
    for file in $input
    do
    if [[ $file != *parsed* ]]
    then
    fullPathFile=$file
    # fullPathFile=$pathToCsv/$file
    basename=$(basename $file .csv)
    $pathToDateFormater $fullPathFile
    fi
    done
}

# All path should be absolute !
function csv_to_turtle
{
    input=$@
    for file in $input
    do
    if [[ $file == *parsed* ]]
    then
    fullPathFile=$file
    # fullPathFile=$pathToCsvParsed/$file
    basename=$(basename $file .csv)

    echo "COMPUTING $pathToCSVparser -i $fullPathFile -o $pathToTurtle/$basename.ttl $pathToConfig/config_${basename}.json"
    $pathToCSVparser -i $fullPathFile -o $pathToTurtle/$basename.ttl $pathToConfig/config_$basename.json
    fi
    done
}

function make_absolute_path
{
    for file in $@
    do
    # echo $(readlink -f $file)
    fullPathFile=$(readlink -f $file)
    # echo $fullPathFile
    if [ -f $fullPathFile ]
    then
    # echo $(readlink -f $file)
    list_file+=($fullPathFile)
    else
    return "$fullPathFile does not exist"
    fi
    done
    echo ${list_file[@]}
    return 0
}

if (( $# > 0 ))
then
    list_csv_file=$(make_absolute_path $@)
    for basename in $(basename $list_csv_file .csv)
    do
        list_csv_file_to_parse+=("${pathToCsvParsed}/${basename}_parsed.csv")
    done
else 
    list_csv_file=$(make_absolute_path $(find $pathToCsv -maxdepth 1 -type f))
    list_csv_file_to_parse=$(make_absolute_path $(find  $pathToCsvParsed -maxdepth 1 -type f))
fi

# echo $list_csv_file
# echo $list_csv_file_to_parse
parse_date $list_csv_file
csv_to_turtle $list_csv_file_to_parse

# parse date

# for file in $(ls $pathToCsv)
# do
#     if [[ $file != *parsed* ]]
#     then
#     fullPathFile=$pathToCsv/$file
#     basename=$(basename $file .csv)
#     $pathToDateFormater $fullPathFile
#     fi
# done


# parse csv to turtle

# for file in $(ls $pathToCsvParsed)
# do
#     if [[ $file == *parsed* ]]
#     then
#     fullPathFile=$pathToCsvParsed/$file
#     basename=$(basename $file .csv)
#     echo "COMPUTING $pathToCSVparser -i $fullPathFile -o $pathToTurtle/$basename.ttl $pathToConfig/config_$basename.json"
#     $pathToCSVparser -i $fullPathFile -o $pathToTurtle/$basename.ttl $pathToConfig/config_$basename.json
#     fi
# done
