#!/bin/sh
# input: stdin
# output: stdout

# paths
 

WHATIZIT=/home/kafkass/Projects/whatizit/AbstractAnnotationTool
WHATIZITXX=$WHATIZIT/lib
DICXX=$WHATIZIT/automata

#OTHERS=$WHATIZITXX/monq.jar:$WHATIZITXX/mallet.jar:$WHATIZITXX/mallet-deps.jar:$WHATIZITXX/marie.jar:$WHATIZITXX/ie.jar

OTHERS=$WHATIZITXX/ebitmjimenotools.jar:$WHATIZITXX/monq.jar:$WHATIZITXX/mallet.jar:$WHATIZITXX/mallet-deps.jar:$WHATIZITXX/marie.jar:$WHATIZITXX/pipeline_140624.jar:$WHATIZITXX/commons-lang-2.4.jar:$WHATIZITXX/ie.jar


JAVA_HOME=/home/kafkass/Projects/whatizit/AbstractAnnotationTool/jdk1.7.0_01_x64
GREP_PATH=/home/kafkass/Projects/whatizit/AbstractAnnotationTool/Grep_tool/

export CLASSPATH=$CLASSPATH:$GREP_PATH

SENTENCISER="$JAVA_HOME/bin/java -XX:+UseSerialGC -cp $OTHERS:$WHATIZITXX/Sentenciser.jar ebi.ukpmc.sentenciser.Sentencise -rs '<document[^>]+>' -ok -ie UTF-8 -oe UTF-8"

SENTCLEANER="$JAVA_HOME/bin/java -XX:+UseSerialGC -cp $OTHERS:$WHATIZITXX/Sentenciser.jar ebi.ukpmc.sentenciser.SentCleaner -stdpipe"

SP_DICT="$JAVA_HOME/bin/java -XX:+UseSerialGC -Xmx5G -XX:MinHeapFreeRatio=10 -XX:MaxHeapFreeRatio=10 -cp $OTHERS monq.programs.DictFilter -t elem -e plain -ie UTF-8 -oe UTF-8 $DICXX/Swissprot_cttv_Oct2016.mwt"

BNCFILTER="$JAVA_HOME/bin/java -XX:+UseSerialGC -cp $OTHERS -Xmx512m -XX:MinHeapFreeRatio=15 -XX:MaxHeapFreeRatio=15 marie.bnc.BncFilter 160"


sh $GREP_PATH/Grep -r "<MedlineCitation ([^>]+>)" "</MedlineCitation>" -co -cr -rf "%0\n<document>" "\n</document>\n%0"|sed -e 's/<\/MedlineCitation>/<\/MedlineCitation>\n/g' |sh $GREP_PATH/Grep -r "<ArticleTitle>" "</ArticleTitle>" -cr -co -rf "%0<text>" "</text>%0" | sh $GREP_PATH/Grep -r "<AbstractText ([^>]+>)" "</AbstractText>" -cr -co -rf "%0<text>" "</text>%0" |sh $GREP_PATH/Grep -r "<AbstractText>" "</AbstractText>" -cr -co -rf "%0<text>" "</text>%0" | $SENTENCISER | $SENTCLEANER | $SP_DICT | $BNCFILTER


#$BNCFILTER
