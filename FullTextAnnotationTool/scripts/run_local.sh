#!/bin/bash

#Use this command to run the Whatizit Full Text annotation pipeline

zcat ../corpara/PMC4879164_PMC4896240.xml.gz | sh ./FT_Annotator.sh > out.xml
