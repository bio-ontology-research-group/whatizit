#]!/bin/sh
# a script to fetch, annotate, transform, and summarize, for xml, ocr, and pdf
# input: stdin
# output: stdout

# paths
WHATIZIT=..
WHATIZITXX=$WHATIZIT/lib
DICXX=$WHATIZIT/automata #This folder contains the dictionaries (in MWT format) that will be used in the annotation process.

#JAVA_HOME=~/packages/jdk1.8.0_66
#JAVA_HOME=/usr/lib/jvm/java-1.7.0-openjdk-1.7.0.131-2.6.9.0.el7_3.x86_64/jre
JAVA_HOME=../jdk1.7.0_01_x64

#If not for production
OTHERS=$WHATIZITXX/monq.jar:$WHATIZITXX/mallet.jar:$WHATIZITXX/mallet-deps.jar:$WHATIZITXX/marie.jar:$WHATIZITXX/ie.jar

#ie.jar is for sentenciser
#marie.jar -> for the bnc filter
#mallet.jar -> gene-protein filtering -> SP_filter


# commands
#works as stdin and stdout
#These processes are for removing the annotations in the references sections of articles
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


