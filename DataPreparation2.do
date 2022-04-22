 ***************************************************
*****************************************************
*****      	 Empirical Research Project:    	*****
*****      	do-file for data preparation    	*****
*****                                           *****
*****            University of Bern             *****
*****      Institute of Political Science       *****
*****                                           *****
*****        	 Spring Semester 2022           *****
*****                                           *****
*****  	 Training in Empirical Research and 	*****
*****    		   Research Skills   			*****
*****                                           *****
*****     Authors (immatriculation numbers):    *****
*****	     Silja Bühlmann (19-122-167)   	    *****
*****	    Anna-Lena Kaiser (19-123-512)       *****
*****	     Adrian Mettler (18-666-172)        *****
*****               					        *****
*****                07.04.2022 		        *****
*****************************************************
 ***************************************************

 
*****************************************************************************************************************
* Contents:																										*
*   data preparation using datasets from the ESS (self-perceived discrimination in country of residence)		*
*	and the World Bank (GDP of contries of birth)															    *
*****************************************************************************************************************




*****************************************************************************************************
* Step 1: Setting up the STATA environment and uploading survey data (source: European Social Survey)
*****************************************************************************************************

clear all // cleaning the memory
capture log close // closing potentially open log files
set more off, permanently // set "more" option off
version 16.0 // setting the STATA version to be used

cd "/Users/silja/Desktop/Forschungsarbeit_aktuell" // setting the working directory
log using datapreparation2.log, replace // starting a log-file

use "ESS_data_.dta", clear




************************************************
* Step 2: adjusting the ESS dataset to our needs				// alternative country renaming by using function "encode"
************************************************


* 2.1:
********************************************
browse cntry cntbrth cntbrtha cntbrthb cntbrthc // All persons who have a value in variable "cntbrth" have the same value in variable "cntbrtha", and notably in "cntbrth" there are some country indications, which are not useful for us. For example, in "cntbrth" Yugoslavia is treated as a country and later it isn't anymore as it seized to exist. In our time-series analysis we will only consider countries that already have existed at the beginning of the analysis period and who existed at least until its end. Therefore, we decide to not use the data in "cntbrth" but only the data in the variables "cntbrtha", "cntbrthb" and "cntbrthc". Using this data we make a new variable compromosing all countries of birth (). - We call this variable "cntbrth_allwaves".


* 2.2:
********************************************
/* Before combining the three variables, we need to make sure that their values are numeric. In order to achieve this, we have to transform them first. We try to transform them through the command "kountry", which also ensures
that the country values are in the format "ISO 3166-1 alpha-3", which corresponds to the format of the country values
in the World Bank data (which we will later add to this dataset). Currently, the ESS country names are in "ISO 3166-1 alpha-2" format (or short: "iso2c") and the World Bank country names are in "ISO 3166-1 alpha-3" format (or short: "iso3c").
*/
ssc install kountry // function to change labels for country variables downloaded

/*
Bringing all values in the ESS dataset to "iso3c" format (that has a character value for each country) didn't work with the functions generate and replace. It worked when having the country values in a numerical format.

Bringing values in the ESS dataset all to "ISO 3166-1 numeric" format (that has a numerical value for each country):
*/

kountry cntbrtha, from(iso2c) to(iso3n) marker
tab _ISO3N_ MARKER // "AE" was not standardized successfully into "784" for its one single observation, all other country codes were standardized successfully (N[total]=10,053)
rename _ISO3N_ cntbrtha_ISO3N
tab cntbrtha_ISO3N, nolabel missing
describe cntbrtha_ISO3N // The variable's storage type is integer (= whole number, anywhere between or including -32,767 and 32,740).

/* Controlling whether the country names were converted adequately (using "tab cntbrtha" and "tab cntbrtha_ISO3N"), we noticed that the new variable (with the character values
having been transformed to numerical values) has totally 118 data points less than the original variable. Searching for the transformation issues for these 118 cases we detected
all of them:
First, we noticed that 116 cases with the value "CS" for former "Czechoslovakia" were not transformed to a
corresponding value in "ISO 3166-1 numeric" format. The reason is that at the moment - as the country doesn't exist anymore - there is no value defined anymore for Czechoslovakia.
Either we will therefore exclude the participants born in Czechoslovakia from our analysis or we will construct a mean GDP from the more recent GDP's of the countries that are now
in the region where Czechoslovakia was before (namely Czech Republic, Slovakia, Ukraine (Zakarpattia Oblast)). 
Furthermore, we noticed that the value for the United Arab Erimates ("AE") was successfully transformed to "784" - it was not unsuccessful as it was suggested by the above code.
Moreover, we noticed that 1 case with the value "AQ" for "Antarctica" (the territories south of 60° south latitude) were not transformed to a
corresponding value in "ISO 3166-1 numeric" format. We will manually transform it to "ATA" in the final dataset and check whether the Wold Bank data offers a GDP for this region.
Lastly, one participant indicated Bouvet Island with the corresponding code "BV" as country of birth. This was not adequately transformed - probably because Bouvet Island officially belongs to Norway. Therefore, we will recode this participant as being born in Norway (if this person is also an immigrant and has taken part in the European Social Survey in a country different from Norway).
*/

drop NAMES_STD
drop MARKER
kountry cntbrthb, from(iso2c) to(iso3n) marker
tab _ISO3N_ MARKER // "AE" was not standardized successfully into "784" for its one single observation, all other country codes were standardized successfully (N[total]=9,106)
rename _ISO3N_ cntbrthb_ISO3N
tab cntbrthb_ISO3N, nolabel missing


/* Controlling whether the country names were converted adequately (using "tab cntbrthb" and "tab cntbrthb_ISO3N"), we noticed that the new variable (with the character values
having been transformed to numerical values) has totally 2 data points less than the original variable. Searching for the transformation issues for these 2 cases we detected
all of them:

#############################
-> The result of this country name transformation is to be analysed in terms of potential errors:
Use the Wikipedia site "ISO 3166-1 alpha-2" and "ISO 3166-1 numeric" for that.

#############################

*/


*#############################
*-> And also the result of the following country name transformation is to be analysed in terms of potential errors:
*#############################

drop NAMES_STD
drop MARKER
kountry cntbrthc, from(iso2c) to(iso3n) marker
tab _ISO3N_ MARKER // "AE" was not standardized successfully into "784" for its two observations, for all other country codes this wasn't the case (N[total]=12,776)
rename _ISO3N_ cntbrthc_ISO3N
tab cntbrthc_ISO3N, nolabel missing



* 2.3:
********************************************
* combining the variables in "iso3n" format into one variable:

*#############################
*-> The result of the following variable combining is to be analysed in terms of potential errors:
*#############################

generate cntbrth_allwaves_ISO3N= .
replace cntbrth_allwaves_ISO3N = cntbrtha_ISO3N if cntbrtha_ISO3N != .
replace cntbrth_allwaves_ISO3N = cntbrthb_ISO3N if cntbrthb_ISO3N != .
replace cntbrth_allwaves_ISO3N = cntbrthc_ISO3N if cntbrthc_ISO3N != .
tab cntbrth_allwaves_ISO3N, m // All values for countries of birth - different to the one where the participants were interviewed in - were combined adequately in the new variable "cntbrth_allwaves".


* 2.4:
********************************************
* recoding the values of the new country variable into character values of "ISO 3166-1 alpha-3" (as they are used in the World Bank data)
drop NAMES_STD
drop MARKER


*#############################
*-> The result of the following country name transformation is to be analysed in terms of potential errors:
* Use the Wikipedia site "ISO 3166-1 alpha-3" and "ISO 3166-1 numeric" for that.
*#############################


kountry cntbrth_allwaves_ISO3N, from(iso3n) to(iso3c) marker
tab _ISO3C_ MARKER // "158" was standardized successfully for its three observations into "TWN" (for Taiwan, Province of China), for all other country codes this wasn't the case (N[total]=31,935)
tab cntbrth_allwaves_ISO3N // looking for the observations with the value "158" -> there are three observations
rename _ISO3C_ cntbrth_allwaves
tab cntbrth_allwaves
br cntbrth_allwaves cntbrtha cntbrthb cntbrthc cntbrth cntry // intuitive visual control: seems like an adequate change in variables
save "ESSdata_AlmostPreparedForMerge.dta", replace


* 2.5:
********************************************
/* 
Control of automatic country value recoding using the function "kountry":

controlled manually until "SL" (started from below at "ZW") using the code
tab cntbrtha, m
tab _ISO3C_, m

for automatic control using the option "marker" for the function "kountry", I'm not
yet sure how to interpret the resulting values "0" and "1" -> try to find that out

What I noticed is that although south sudan became a new country in 2011, no-one in the ESS indicated
South Sudan as country of birth. This means that the function "kountry" has surely not made any error
with such cases, which might have resulted when using this function.
*/




***********************************************************
* Step 3: Integrating World Bank data into the ESS dataset:
***********************************************************

/* The following should also be done for cntbrthb & cntbrthc respectively (within "DataPreparation1.do")
We will integrate GDP of country of birth from 2002-2018 into the ESS dataset.
We do this by merging two datasets, namely the currently opened ESS dataset as "master dataset"
and the World Bank dataset, which we will open soon, as "using dataset".
*/


* 3.1: Opening the World Bank dataset & keeping only useful variables
*********************************************************************
import delimited "daten weltbank.csv", delimiter(comma) varnames(1) clear // loading the intended dataset in STATA
browse
drop seriescode // We drop variable that we don't need.


* 3.2 Matching the linking variable's name & sorting the World Bank dataset
***************************************************************************
rename countrycode cntbrth_allwaves // The variable indicating the names of the countries is the linking variable. It is renamed to be called "cntbrtha_allwaves" like in the master dataset.
sort cntbrth_allwaves // We sort the using dataset based on the linking variable.
save "worldbankdata_PreparedForMerge.dta", replace


* 3.3 Sorting the ESS dataset
*****************************
use "ESSdata_AlmostPreparedForMerge.dta", clear
sort cntbrth_allwaves // We sort the master dataset based on the linking variable.
save "ESSdata_PreparedForMerge.dta", replace


* 3.4: Merging the datasets & saving as new dataset
***************************************************
merge m:m cntbrth_allwaves using "worldbankdata_PreparedForMerge.dta" // We merge the datasets indicating the linking variable "cntbrtha_allwaves" and the repartition "m:m". We use "m:m" as our extra-variables (GDP for several countries) have many values (GDP in several years) to be merged with many observations in the master dataset (the same countries of birth appear multiple times in several lines as several participants were born in the same country).
/*

#############################
-> The result of the merge is to be analysed in terms of potential errors:
#############################

    Result                      Number of obs
    -----------------------------------------
    Not matched                           162
        from master                        82  (_merge==1) -> e.g. observations "391854" to "391894"
        from using                         80  (_merge==2) -> e.g. observations "422986" to "423065" involving countries 

    Matched                           422,903  (_merge==3)
    -----------------------------------------
*/
browse cntbrtha cntbrth_allwaves yr2000 _merge
save "ESS_WorldBank_data.dta", replace
sort _merge
browse



//## Countries where value for gdp is missing:
//  ANT CHI GLP GUF MSR INX MTQ PYF REU TWN VEN INX MAF VGB
//## Countries where GDP is only for later year avaiable
// CYM(2006) NRU(2004) SSD (2008) SOM(2013) SXM(2009) TCA(2011) XKX(2008)

***********************************************************
* Step 4: final preparation of variables
***********************************************************



* 4.1: destring gdp variables
***************************

// variables for the gdp have been imported in string format the command destring only worked with the option force (without force, stata complained "yr2002: contains nonnumeric characters, no generate")

destring yr2002, generate(gdp2002) force
destring yr2004, generate(gdp2004) force 
destring yr2006, generate(gdp2006) force 
destring yr2008, generate(gdp2008) force 
destring yr2010, generate(gdp2010) force 
destring yr2012, generate(gdp2012) force 
destring yr2014, generate(gdp2014) force 
destring yr2016, generate(gdp2016) force
destring yr2018, generate(gdp2018) force 



* 4.2: create dummy 'discriminated'
***************************

fre dscrgrp
/*
dscrgrp -- Member of a group discriminated against in this country
-------------------------------------------------------------------
                      |      Freq.    Percent      Valid       Cum.
----------------------+--------------------------------------------
Valid   1  Yes        |      29612       7.00       7.10       7.10
        2  No         |     387727      91.65      92.90     100.00
        Total         |     417339      98.65     100.00           
Missing .             |         80       0.02                      
        .a Refusal    |        355       0.08                      
        .b Don't know |       3549       0.84                      
        .c No answer  |       1742       0.41                      
        Total         |       5726       1.35                      
Total                 |     423065     100.00                      
-------------------------------------------------------------------
*/

//generate a new dummy variable with (0 = not beeing discriminated) (1 = beeing discriminated)

recode dscrgrp (1=1 "yes") (2=0 "no") (else=.), gen(discriminated)

fre

* 4.3: save dataset
***************************

save "ESS_WorldBank_data.dta", replace
sort _merge
browse





***************
* Finalisation:
***************

log close // closing the log-file
