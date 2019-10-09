directory=$1

OLDIFS=$IFS

IFS=' '
array=($(ls -t -p $directory | xargs echo))

lenOrig=${#array[*]}

<<DEBUG1
echo $lenOrig

i=0
while [ $i -lt $lenOrig ]; do
	echo "$i: ${array[$i]}"
	let i++
done
DEBUG1


svn_array=($(svn ls $directory | xargs echo))
difference=()

len=${#svn_array[*]}

# echo $len

i=0
while [ $i -lt $len ]; do
	skip=false
	for j in "${array[@]}"; do
		if [ "${svn_array[$i]}" == "$j" ]; then
			# echo "${svn_array[$i]}" == "$j";
		       	skip=true; break;
		fi
	done

	if [ $skip == false ]; then
		difference+=(${svn_array[$i]})
	fi

	let i++
done


for i in "${difference[@]}"; do
	echo "checking out $directory/$i sparsely"
	svn up $directory/$i -N
done



IFS=$OLDIFS
