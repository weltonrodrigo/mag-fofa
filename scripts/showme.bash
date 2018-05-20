pid=0;

function label(){
	quem=$1;
	file=$2;

	mv -v -- "$2" "$1"
}


for i in *.jpeg;
do
	eog $i&
	pid=$!

	read -n 1 quem

	case "$quem" in
		'f')
			label "fofa"  "$i" 
			;;
		'm')
			label "mag"  "$i" 
			;;
		'n')
			label "none"  "$i" 
			;;
	esac
	kill "$pid"
done
