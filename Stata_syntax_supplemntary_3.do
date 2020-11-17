//1.Start with importing the file that contains the variables of “patient_ID” and “drugs_used” in a long format (see figure ):
use "file path"
//2.If you have more variables, drop them and just keep the mention variables:
keep patient_ID drugs_used1
//3.We remove then the duplicated observations, if found and save the result:
duplicates drop
save "file path"
//4.Rename the “drugs_used1” variable into “drugs_used2” and rejoin to the previous saved file:
rename drugs_used1 drugs_used2
joinby pasientlopenr using "the saved file path"
//We have now the drugs each the each patient used in two columns (i.e. variables)
//5.We count how many patients have used drug (1) and drug (2) together (Co-medication), and name the new variable “edges”:
bysort drugs_used drugs_used2 :egen edges=count(pasientlopenr)
//6.Drop if the drug in “drugs_used1” is the same as in “drugs_used2”:
drop if drugs_used1 == drugs_used2
//7.After counting number of patients, we drop the “patient_ID” and remove duplicates if found:
drop patient_ID
duplicates drop
//We have now three variables; “drugs_used1” that represents source node, “drugs_used2” that represents target nodes and “edges” that represents the link thickness between the two nodes.

//8.Generate and export network:
nwfromedge drugs_used1 drugs_used2 edges, undirected keeporiginal
nwexport, type(pajek) replace

//9.Import to Gephi

//More on “nwcommands” here:
//https://www.stata.com/meeting/nordic-and-baltic14/abstracts/materials/dk14_grund.pdf
//and here:
//https://www.stata.com/meeting/italy15/abstracts/materials/it15_grund.pdf
