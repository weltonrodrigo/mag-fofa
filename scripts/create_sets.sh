set -x

# must be given in percents
TRAIN_RATIO="$1"
BASEDIR=$(readlink -f "$2")

pushd "$BASEDIR"

for class in *
do 
	mkdir -p .data/{valid,train}/"$class"

	# get the file list and shuffle it
	file_list=$(ls -1 "$class" | shuf )

	# How many files in total?
	complete_size=$( echo "$file_list" | wc -l)

	# How many will be in the train set? complete_size * TRAIN_RATIO
	# round it to nearest integer.
	temp_size=$(( $complete_size * $TRAIN_RATIO / 100 ))
	train_size=$( printf "%d" "$temp_size" )

	# From the full list, get the _train_size_ firsts
	train_list=$( head -"$train_size" <<< "$file_list" )

	# From the full list , get the ones after _train_size_ + 1
	valid_list=$( tail -n+$(($train_size + 1)) <<< "$file_list" )

	# Now just move the files around:

	pushd "$class"

	## First the train list of files
	echo "$train_list" | xargs -I% cp -v -- '%' "$BASEDIR/.data/train/${class}"

	## Next the validation list of files
	echo "$valid_list" | xargs -I% cp -v -- '%' "$BASEDIR/.data/valid/${class}"

	popd

done;

