
# a script to fetch, annotate, transform, and summarize, for xml, ocr, and pdf
# input: stdin
# output: stdout

# paths
WHATIZIT=/scratch/dragon/intel/kafkass/whatizit/FullTextAnnotationTool
WHATIZITXX=$WHATIZIT/lib
DICXX=$WHATIZIT/automata  # path to your dictionary


# JAVA_HOME=~/packages/jdk1.8.0_66
JAVA_HOME=$WHATIZIT/jdk1.7.0_01_x64

# jar libraries for text annotation
OTHERS=$WHATIZITXX/monq.jar:$WHATIZITXX/mallet.jar:$WHATIZITXX/mallet-deps.jar:$WHATIZITXX/marie.jar:$WHATIZITXX/ie.jar

# ie.jar is for sentenciser
# marie.jar -> for the bnc filter
# mallet.jar -> gene-protein filtering -> SP_filter


# commands
# works as stdin and stdout
# These steps are for removing the annotations in the references
ADDTEXT="$JAVA_HOME/bin/java -XX:+UseSerialGC -cp $OTHERS:$WHATIZITXX/pmcxslpipe140627.jar\
 ebi.ukpmc.xslpipe.Pipeline -stdpipe -stageSpotText"
OUTTEXT="$JAVA_HOME/bin/java -XX:+UseSerialGC -cp $OTHERS:$WHATIZITXX/pmcxslpipe140529.jar\
 ebi.ukpmc.xslpipe.Pipeline -stdpipe -outerText"
REMBACK="$JAVA_HOME/bin/java -XX:+UseSerialGC -cp $OTHERS:$WHATIZITXX/pmcxslpipe140529.jar\
 ebi.ukpmc.xslpipe.Pipeline -stdpipe -removeBackPlain -fixEBIns"

# SENTENCISER="$JAVA_HOME/bin/java -XX:+UseSerialGC -cp $OTHERS ie.Sentencise -rs '<article[^>]+>' -ok -ie UTF-8 -oe UTF-8"
SENTENCISER="$JAVA_HOME/bin/java -XX:+UseSerialGC -cp $OTHERS:$WHATIZITXX/Sentenciser.jar\
 ebi.ukpmc.sentenciser.Sentencise -rs '<article[^>]+>' -ok -ie UTF-8 -oe UTF-8"
SENTCLEANER="$JAVA_HOME/bin/java -XX:+UseSerialGC -cp $OTHERS:$WHATIZITXX/Sentenciser.jar\
 ebi.ukpmc.sentenciser.SentCleaner -stdpipe"

# Swissprot Dictionary, for annotating text with gene/protein names... You can modify this step with another dictionary (in MWT format)

SP_DICT="$JAVA_HOME/bin/java -XX:+UseSerialGC -Xmx5G -XX:MinHeapFreeRatio=10 -XX:MaxHeapFreeRatio=10\
 -cp $OTHERS monq.programs.DictFilter -t elem -e plain -ie UTF-8 -oe UTF-8 $DICXX/Swissprot_cttv_Oct2016.mwt"


BNCFILTER="$JAVA_HOME/bin/java -XX:+UseSerialGC -cp $OTHERS -Xmx512m -XX:MinHeapFreeRatio=15\
 -XX:MaxHeapFreeRatio=15 marie.bnc.BncFilter 160"

# $ADDTEXT 
#  $OUTTEXT
echo   $SENTENCISER

echo $SENTCLEANER
echo  $REMBACK 
echo $SP_DICT
echo  $BNCFILTER

#Annotate
sed 's/^<articles>//' | sed 's/^<\/articles>//' | \
sed 's/^<article /<!DOCTYPE "JATS-archivearticle1.dtd">\n<article /' | \
sed 's/"article-type=/" article-type=/'| $ADDTEXT | $OUTTEXT | $SENTENCISER | \
$SENTCLEANER | $REMBACK | $SP_DICT | $BNCFILTER

# end
