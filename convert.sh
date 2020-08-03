
while getopts f:t:d: flag
do
    case "${flag}" in
        f) fname=${OPTARG};;
        t) intable=${OPTARG};;
        d) indatabase=${OPTARG};;
    esac
done
#echo "Table: $intable";
#echo "Database: $indatabase";

# https://stackoverflow.com/questions/10154633/load-csv-data-into-mysql-in-python/10154650#10154650
# https://stackoverflow.com/questions/31235642/query-csv-file-in-python-and-create-new-table

#https://pythonhosted.org/querycsv/
#http://code.activestate.com/recipes/498130-create-sql-tables-from-csv-files/

if [ -z "${fname+set}" ]; then
   echo "error file not found"
   echo "use -f /path/to/the/file.csv"
   exit
fi


#https://www.unix.com/unix-for-dummies-questions-and-answers/9883-removing-commas-text-file.html
#cat $fname|tr -d '"' > $fname
#sed -e 's/"//g'  $fname  > TMP_00
#cp TMP_00 $fname
#rm TMP_00

cat $fname|tr -d '"' > TMP_00
cp TMP_00 $fname
rm TMP_00

# https://www.baeldung.com/linux/use-command-line-arguments-in-bash-script
# https://github.com/pavanchhatpar/csv-to-sql-converter
sed 's/\s*,*\s*$//g' "$fname" > tmp.csv
op=$(echo "$fname" | cut -d"." -f 1)




#echo ${foo##*/}

TABLE=${op##*/}"xtable"
DATABASE=${op##*/}

#TABLE=${op##*\/}"xtable"
#DATABASE=${op##*\/}


opfile="$op.sql"
op="\`$op\`"
columns=$(head --lines=1 tmp.csv | sed 's/,/`,`/g' | tr -d "\r\n")


columns="\`$columns\`"
tail --lines=+2 tmp.csv | while read l ; do
values=$(echo $l | sed 's/,/\",\"/g' | tr -d "\r\n")
values="\"$values\""
echo "INSERT INTO $TABLE($columns) VALUES ($values);"
done > "$opfile"



#CREATE TABLE Persons(PersonID int,LastName varchar(255));
#$tablecolumnstypes="\`$tablecolumnstypes\`"
#echo $tablecolumnstypes
#https://stackoverflow.com/questions/9998596/create-mysql-table-directly-from-csv-file-using-the-csv-storage-engine
#http://positon.org/import-csv-file-to-mysql

DELIM=","

#CSV="$1"
CSV="tmp.csv"


FIELDS=$(head -1 "$CSV" | sed -e 's/'$DELIM'/` varchar(255),`/g' -e 's/\r//g')
#echo $FIELDS
FIELDS='`'"$FIELDS"'` varchar(255)'

#echo $FIELDS
#sed "1iCREATE DATABASE '$DATABASE';\nUSE '$DATABASE';" $opfile

# from https://github.com/lukaneco/minecraft-server

#file2=~/mineserver/spigot.jar



# https://www.baeldung.com/linux/use-command-line-arguments-in-bash-script
# https://stackoverflow.com/questions/3601515/how-to-check-if-a-variable-is-set-in-bash

#if [ -z "$intable" ]; then echo "var is blank"; else echo "Table: $intable"; fi
#if [ -z "$indatabase" ]; then echo "var is blank"; else echo "Database: $indatabase"; fi

#if [ -z ${intable+x} ]; then $gg=1; else echo "var is set to '$intable'"; fi


if [ -n "${indatabase+set}" ]; then
    echo '$indatabase was set'
    myDatabase="USE $indatabase;\n"
else
    echo '$indatabase isnt set'
    myDatabase="DROP DATABASE IF EXISTS $DATABASE;\nCREATE DATABASE $DATABASE;\nUSE $DATABASE;\n"
fi


if [ -n "${intable+set}" ]; then
    echo '$intable was set'
else
    echo '$intable isnt set'
fi

sed -i "1i$myDatabase DROP TABLE IF EXISTS $TABLE;\nCREATE TABLE $TABLE ($FIELDS);" "$opfile"

#Work
#sed -i "1iDROP DATABASE IF EXISTS $DATABASE;\nCREATE DATABASE $DATABASE;\nUSE $DATABASE;\nDROP TABLE IF EXISTS $TABLE;\nCREATE TABLE $TABLE ($FIELDS);" "$opfile"

# Work
#sed -i "1iDROP DATABASE IF EXISTS $DATABASE;\nCREATE DATABASE $DATABASE;\nUSE $DATABASE;\nDROP TABLE IF EXISTS $TABLE;\nCREATE TABLE $TABLE ($FIELDS);" "$opfile"

#sed -i '1i\CREATE DATABASE '$DATABASE';\nUSE '$DATABASE';\nDROP TABLE IF EXISTS '$TABLE';\nCREATE TABLE '$TABLE' ('$FIELDS');' $opfile

#sed "1iCREATE DATABASE '$DATABASE';\nUSE '$DATABASE';" $opfile
#sed "3iDROP TABLE IF EXISTS '$TABLE';\nCREATE TABLE '$TABLE' ($FIELDS)" $opfile
#\nCREATE TABLE '$TABLE' ('$FIELDS');
#WORK
#echo "DROP TABLE IF EXISTS '$TABLE';\nCREATE TABLE '$TABLE' ($FIELDS);"
#echo "DROP TABLE IF EXISTS '$TABLE';"
#echo $FIELDS
#echo "CREATE TABLE '$TABLE' ($FIELDS);"

rm tmp.csv
