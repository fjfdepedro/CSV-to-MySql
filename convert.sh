fname="$1"

cat $fname|tr -d '"' > $fname
# https://www.baeldung.com/linux/use-command-line-arguments-in-bash-script
# https://github.com/pavanchhatpar/csv-to-sql-converter
sed 's/\s*,*\s*$//g' "$fname" > tmp.csv
op=$(echo "$fname" | cut -d"." -f 1)
TABLE=$op"xtable"
DATABASE=$op
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
sed -i "1iDROP DATABASE IF EXISTS $DATABASE;\nCREATE DATABASE $DATABASE;\nUSE $DATABASE;\nDROP TABLE IF EXISTS $TABLE;\nCREATE TABLE $TABLE ($FIELDS);" "$opfile"

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