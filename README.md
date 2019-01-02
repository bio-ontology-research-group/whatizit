# whatizit
A dictionary-based Named Entitiy Recognition tool


**How to use?**

You need to create dictionaries based on mwt format

MWT dictionary format:

`<mwt>
 
 <template><mwt>
 
 <template><z:Onto id="%1" cat="%2">%0</z:Onto></template>
 
 <r p1="$IDs" p2="$CATHEGORY" >$PATTERN</r>

</mwt> `   
 
 
 *ids: comma separated IDs in a given ontology
  
  category: entity type (e.g. phenotype, gene etc)*

Example dictionaries can be found in the automata folder of each tool.


**AbstractAnnotationTool**
  
This folder contains a tool for annotating Abstracts



**FullTextAnnotationTool**

This folder contains a tool for annotating Full text articles


*Please follow the intsructions in the scripts folder of each tool to run the tools*

Licence: Available for academic purposes only.
