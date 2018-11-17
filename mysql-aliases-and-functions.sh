createMySqlDB() {
	MYSQL=$(which mysql)
	MUSER="root"
	DBNAME=""
	DUMP_FILE=""
	
	#RESOLVE PARAMETERS

	if [ "$#" -eq 0 ]; then
		DBNAME="lportal"
	elif [ "$#" -eq 1 ] && [ ! -z "$1" ] && [ -f "$1" ]; then
		filename=$(basename "$1")
		DBNAME="${filename%.*}"
		DUMP_FILE=$1
	elif [ "$#" -eq 1 ] && [ ! -z "$1" ]; then
		DBNAME=$1
	elif [ "$#" -eq 2 ] && [ -f "$1" ]; then
		DBNAME=$2
		DUMP_FILE=$1
	elif [ "$#" -eq 2 ] && [ -f "$2" ]; then
		DBNAME=$1
		DUMP_FILE=$2
	fi
	
	if [ ! -z "$DBNAME" ]; then	
		#DROP DATABASE

		dropMySqlDB  $DBNAME

		#CREATE DATABASE

		$MYSQL -u $MUSER -e "CREATE SCHEMA \`$DBNAME\` DEFAULT CHARACTER SET utf8"

		echo "database $DBNAME created successfully"
	fi

	if [ ! -z "$DUMP_FILE" ]; then
		#IMPORT FROM FILE
		$MYSQL -u $MUSER $DBNAME < $DUMP_FILE

		echo "'$PWD/$DUMP_FILE' imported in $DBNAME database"
	fi
}

copyMySqlDB() {
	MYSQL=$(which mysql)
	MYSQLADMIN=$(which mysqladmin)
	MYSQLDUMP=$(which mysqldump)	

	createMySqlDB $2

	MYSQLDUMP -u root -v $1 | MYSQL -u root -D $2

	echo "'$2' created based on $1 database"
}

dropMySqlDB() {
	MYSQL=$(which mysql)
	MUSER="root"
	
	for DBNAME in "$@"
	do
	    $MYSQL -u $MUSER -e "drop database IF EXISTS \`$DBNAME\`"
	done
}