#set -x 
PID=0;

TEMP_DIR=$(mktemp -d)
FILE_LIST=""

BASENAME="http://gatos.familianascimento.org.s3.amazonaws.com/gatos/img/"


function annotate(){
	file=$1
	label=$2
	url=$3
	basedir=$(dirname $(dirname $url))

	mv -v -- "${TEMP_DIR}/${file}" "$label"

	s3cmd -v mv "$3" "${basedir}/${label}/${file}"  &
}

function download_next(){
	url="$1"
	file=$(basename "$url")

	s3cmd get -v "$url" "${TEMP_DIR}/${file}"

}

function get_list(){

	echo "Getting file list"

	FILE_LIST=$(s3cmd ls -r s3://gatos.familianascimento.org/gatos/img | grep -o 's3://.*' )

}

function main(){

	# get file list
	get_list

	# Read files one at a time
	while IFS='' read -r line || [[ -n "$line" ]]; do
		echo "Downloading ${line}";

	
		# Download the file
		download_next "$line";

		# Get it's download name
		file=$(basename "$line")

		# show the file
		eog "${TEMP_DIR}/${file}" &

		pid=$!

		# read annotation
		read -n 1 quem <&1
			
		case "$quem" in
			'f')
				annotate "$file" "fofa" "$line"
				;;
			'm')
				annotate "$file" "mag" "$line"
				;;
			'n')
				annotate "$file" "none" "$line"
				;;
		esac

		# fechar a janela para abrir a próxima.
		killall "eog"
		
	done <<< "$FILE_LIST"

}

# Let's go

main

