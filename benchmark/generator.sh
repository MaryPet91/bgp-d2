
PATH=$PATH:bin

######## Generator Params ########
MIN_LENGTH_SEQ=90000000
MAX_LENGTH_SEQ=118000000
NUM_SEQ=10
DATABASE_NAME=benchsuiteB
DIR_DATASET=sequencesB
BUF_SIZE=10 #MB
###################################

########### KMC Params ###########
KMIN=3 
KMAX=15

# cs = 2^32 - 1
CS=4294967295
CI=1
MEM=2

DIR_OUT=sequencesB_kmers
DIR_TMP=Xtmp_work
###################################

mkdir $DIR_DATASET
mkdir $DIR_TMP
mkdir $DIR_OUT

echo "Making dataset files FASTA"
java -classpath d2-*.jar generator.MainGeneratorMultipleFiles $MIN_LENGTH_SEQ $MAX_LENGTH_SEQ $NUM_SEQ $DATABASE_NAME "$DIR_DATASET/" $BUF_SIZE

for (( x=0; x<$NUM_SEQ; x++ ))
do

	echo "Sequenza $x"

	mkdir $DIR_TMP/seq$x
	mkdir $DIR_OUT/seq$x

	for (( y=$KMIN; y<=$KMAX; y++ ))
	do

		echo "---> Sequenza $x, Conteggio k-$y"

		#echo "$x-$y"
		echo "kmc -m$MEM -k$y -fm -ci$CI -cs$CS $DIR_DATASET/seq$x.fasta $DIR_TMP/seq$x/seq$x.res $DIR_TMP"
		kmc -m$MEM -k$y -fm -ci$CI -cs$CS $DIR_DATASET/seq$x.fasta $DIR_TMP/seq$x/seq$x.res $DIR_TMP

		echo "---> kmc_dump_indexed $DIR_TMP/seq$x/db_k$y.res $DIR_OUT/seq$x/k$y.res"
		kmc_dump_indexed $DIR_TMP/seq$x/seq$x.res $DIR_OUT/seq$x/k$y.res

		#sort -n -r -k3 $DIR_OUT/seq$x/k$y.res -o $DIR_OUT/seq$x/k"$y"-ordered.res

		cat $DIR_OUT/seq$x/k$y.res >> $DIR_OUT/seq"$x"_all.res
		printf "\n" >> $DIR_OUT/seq"$x"_all.res

		rm $DIR_OUT/seq$x/k$y.res
		#rm $DIR_OUT/seq$x/k"$y"-ordered.res

		rm $DIR_TMP/seq$x/seq$x.res*

	done

	rmdir $DIR_OUT/seq$x

done

rm -rf $DIR_TMP/seq*
rmdir $DIR_TMP


env GZIP=-9 tar cvzf kmers.tar.gz $DIR_OUT
tar cvzf sequences.tar.gz $DIR_DATASET