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
*****                19.06.2022 		        *****
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
version 17.0 // setting the STATA version to be used

cd "/Users/silja/Desktop/Empirical Research Paper_19June22" // setting the working directory
log using DataPreparation.log, replace // starting a log-file

use "ESS_data_finalversion_.dta", clear



**********************************************************************************************************************
* Step 2: adjusting the ESS dataset to our needs before combining with World Bank dataset: variable "country of birth"
**********************************************************************************************************************


* 2.1: analysing country of birth variables
*******************************************
browse cntry cntbrth cntbrtha cntbrthb cntbrthc // All persons who have a value in variable "cntbrth" have the same value in variable "cntbrtha", and notably in "cntbrth" there are some country indications, which are not useful for us. For example, in "cntbrth" Yugoslavia is treated as a country and later it isn't anymore as it seized to exist. In our time-series analysis we will only consider countries that already have existed at the beginning of the analysis period and who existed at least until its end. Therefore, we decide to not use the data in "cntbrth" but only the data in the variables "cntbrtha", "cntbrthb" and "cntbrthc". Using this data we make a new variable compromosing all countries of birth (). - We call this variable "cntbrth_allwaves".


* 2.2: changing three relevant variables from character to numeric 
******************************************************************
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
tab _ISO3N_ MARKER // "AE" was not standardized successfully into "784" for its one single observation, all other country codes were standardized successfully (N[total]=10,658)
rename _ISO3N_ cntbrtha_ISO3N
tab cntbrtha_ISO3N, nolabel missing
describe cntbrtha_ISO3N // The variable's storage type is integer (= whole number, anywhere between or including -32,767 and 32,740).

/* Controlling whether the country names were converted adequately (using "tab cntbrtha" and "tab cntbrtha_ISO3N"), we noticed that the new variable (with the character values
having been transformed to numerical values) has totally 118 data points less than the original variable. Searching for the transformation issues for these 118 cases we detected all of the issues:

First, we noticed that 116 cases with the value "CS" for former "Czechoslovakia" were not transformed to a
corresponding value in "ISO 3166-1 numeric" format. The reason is that at the moment - as the country doesn't exist anymore - there is no value defined anymore for Czechoslovakia.
We will therefore exclude the participants born in Czechoslovakia from our analysis (through the command "kountry" they have already been excluded. - In particular, we exclude them also because the World Bank doesn't report any recent GDP values for Czechoslovakia. 

Furthermore, we noticed that the value for the United Arab Erimates ("AE") was successfully transformed to "784" - it was not unsuccessful as it was suggested by the above code.

Moreover, we noticed that 1 case with the value "AQ" for "Antarctica" (the territories south of 60° south latitude) were not transformed to a corresponding value in "ISO 3166-1 numeric" format. We exclude this participant as the World Bank doesn't report any GDP values for Antarctica.

Lastly, one participant indicated Bouvet Island with the corresponding code "BV" as country of birth. This was not adequately transformed because Bouvet Island officially belongs to Norway. Therefore, we have manually recoded this participant (with idno = 1966) as being born in Norway because the person is relevant for our analysis as they have migrated to Luxembourg and participated in the survey there.
*/


drop NAMES_STD
drop MARKER
kountry cntbrthb, from(iso2c) to(iso3n) marker
tab _ISO3N_ MARKER // "AE" was not standardized successfully into "784" for its one single observation, all other country codes were standardized successfully (N[total]=9,594)
rename _ISO3N_ cntbrthb_ISO3N
tab cntbrthb_ISO3N, nolabel missing


/*
Controlling whether the country names were converted adequately (using "tab cntbrthb" and "tab cntbrthb_ISO3N"), we noticed that the new variable (with the character values having been transformed to numerical values) has totally 2 data points less than the original variable. Searching for the transformation issues for these 2 cases we were unable to detect them. As the funtion "kountry" seems to have worked very well in the above case (only not functioning for countries that don't exist anymore), we suspect the issue to have arisen due to country codes of countries that don't officially exist (anymore). We could anyway not include these countries into the analysis because of missing GDP data.

Furthermore, we noticed that the value for the United Arab Erimates ("AE") was successfully transformed to "784" - it was not unsuccessful as it was suggested by the above code.
*/


drop NAMES_STD
drop MARKER
kountry cntbrthc, from(iso2c) to(iso3n) marker
tab _ISO3N_ MARKER // "AE" was not standardized successfully into "784" for its two observations, for all other country codes this wasn't the case (N[total]=12,979)
rename _ISO3N_ cntbrthc_ISO3N
tab cntbrthc_ISO3N, nolabel missing

/*
Controlling whether the country names were converted adequately (using "tab cntbrthc" and "tab cntbrthc_ISO3N"), we noticed that the new variable (with the character values having been transformed to numerical values) has totally 149 data points less than the original variable. Searching for the transformation issues for these 149 cases we were unable to detect them. As the funtion "kountry" seems to have worked very well in the above case (only not functioning for countries that don't exist anymore), we suspect the issue to have arisen due to country codes of countries that don't officially exist (anymore). We could anyway not include these countries into the analysis because of missing GDP data.

Furthermore, we noticed that the values for the United Arab Erimates ("AE") were successfully transformed to "784" - it was not unsuccessful as it was suggested by the above code.
*/



* 2.3: combining the three variables (in "iso3n" format) into one variable:
*****************************************************************************

generate cntbrth_allwaves_ISO3N= .
replace cntbrth_allwaves_ISO3N = cntbrtha_ISO3N if cntbrtha_ISO3N != .
replace cntbrth_allwaves_ISO3N = cntbrthb_ISO3N if cntbrthb_ISO3N != .
replace cntbrth_allwaves_ISO3N = cntbrthc_ISO3N if cntbrthc_ISO3N != .
tab cntbrth_allwaves_ISO3N, m // All values for countries of birth - different to the one where the participants were interviewed in - were combined adequately in the new variable "cntbrth_allwaves".


* 2.4: recoding country variable from numerical into character values
*********************************************************************

* Here, we recode the values of the new country variable into character values of "ISO 3166-1 alpha-3" (as they are used in the World Bank data):

drop NAMES_STD
drop MARKER
kountry cntbrth_allwaves_ISO3N, from(iso3n) to(iso3c) marker
tab _ISO3C_ MARKER
tab cntbrth_allwaves_ISO3N
rename _ISO3C_ cntbrth_allwaves
tab cntbrth_allwaves, m


* 2.5: saving adapted dataset
*****************************

save "ESSdata_AlmostPreparedForMerge.dta", replace


***********************************************************
* Step 3: Integrating World Bank data into the ESS dataset:
***********************************************************

/*
We will integrate GDP/capita of country of birth from 2002-2018 into the ESS dataset.
We do this by merging two datasets, namely the currently opened ESS dataset as "master dataset"
and the World Bank dataset, which we will open soon, as "using dataset".
*/


* 3.1: Opening the World Bank dataset & keeping only useful variables
*********************************************************************
import delimited "daten weltbank.csv", delimiter(comma) varnames(1) clear // loading the intended dataset in STATA
browse
drop seriescode // We drop variable that we don't need.


* 3.2: Matching the linking variable's name & sorting the World Bank dataset
****************************************************************************
rename countrycode cntbrth_allwaves // The variable indicating the names of the countries is the linking variable. It is renamed to be called "cntbrtha_allwaves" like in the master dataset.
sort cntbrth_allwaves // We sort the using dataset based on the linking variable.
save "worldbankdata_PreparedForMerge.dta", replace


* 3.3: Sorting the ESS dataset
******************************
use "ESSdata_AlmostPreparedForMerge.dta", clear
sort cntbrth_allwaves // We sort the master dataset based on the linking variable.
save "ESSdata_PreparedForMerge.dta", replace


* 3.4: Merging the datasets & saving as new dataset
***************************************************
merge m:m cntbrth_allwaves using "worldbankdata_PreparedForMerge.dta" // We merge the datasets indicating the linking variable "cntbrtha_allwaves" and the repartition "m:m". We use "m:m" as our extra-variables (GDP/capita for several countries) have many values (GDP/capita in several years) to be merged with many observations in the master dataset (the same countries of birth appear multiple times in several lines as several participants were born in the same country).

browse cntbrtha cntbrth_allwaves yr2000 _merge
save "ESS_WorldBank_data.dta", replace
sort _merge
browse

/*
Controlling whether the observations were combined adequately according to the countries of origin, we noticed that 162 observations have not been matched. Namely, 82 observations from the master dataset (e.g. observations "391854" to "391894") and 80 observations from the using dataset (e.g. observations "422986" to "423065"). Searching for the transformation issues we noticed that for several countries some of the GDP/capita data is missing. We cannot include these participants in our data analysis as the GDP data is necessary for it. More specifically, for the following countries (in "ISO 3166-1 alpha-3" format) there is no GDP/capita data available at all:
ANT CHI GLP GUF MSR INX MTQ PYF REU TWN VEN INX MAF VGB

And for the following countries, there is only GDP data available for a year later than the one of the first wave (2002). The year from which onwards GDP/capita data is available, is indicated in brackets:
CYM(2006) NRU(2004) SSD (2008) SOM(2013) SXM(2009) TCA(2011) XKX(2008)
*/


****************************************
* Step 4: final preparation of variables
****************************************


* 4.1: independent variable "GDP of immigrants' country of origin"
******************************************************************

* destringing variables: variables for the gdp/capita have been imported in string format. The command destring only works with the option force (without force, the error message "yr2002: contains nonnumeric characters, no generate" appears.)

destring yr2002, generate(gdp2002) force
destring yr2004, generate(gdp2004) force 
destring yr2006, generate(gdp2006) force 
destring yr2008, generate(gdp2008) force 
destring yr2010, generate(gdp2010) force 
destring yr2012, generate(gdp2012) force 
destring yr2014, generate(gdp2014) force 
destring yr2016, generate(gdp2016) force
destring yr2018, generate(gdp2018) force 


* transforming gdp/capita in dollars to gdp/capita in thousand dollars
gen gdp2002_t = gdp2002/1000
gen gdp2004_t = gdp2004/1000
gen gdp2006_t = gdp2006/1000
gen gdp2008_t = gdp2008/1000
gen gdp2010_t = gdp2010/1000
gen gdp2012_t = gdp2012/1000
gen gdp2014_t = gdp2014/1000
gen gdp2016_t = gdp2016/1000
gen gdp2018_t = gdp2018/1000


* combining gdp/capita data of individual years to a gdp/capita variable with data of all survey waves
gen gdp_t =.
replace gdp_t = gdp2002_t if essround == 1
replace gdp_t = gdp2004_t if essround == 2
replace gdp_t = gdp2006_t if essround == 3
replace gdp_t = gdp2008_t if essround == 4
replace gdp_t = gdp2010_t if essround == 5
replace gdp_t = gdp2012_t if essround == 6
replace gdp_t = gdp2014_t if essround == 7
replace gdp_t = gdp2016_t if essround == 8
replace gdp_t = gdp2018_t if essround == 9

browse gdp_t


* 4.2: dependent variable: self-perceived discrimination of immigrants
**********************************************************************

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

/*
Generating a new dummy variable with (0 = not beeing discriminated) (1 = beeing discriminated):

One important restriction we made in our dependent variable is that we only wanted to take into account (as value "1" in the dependent dummy variable) people that feel
discriminated based on a trait that might be related to their country of origin. Therefore, we made sure to only include as value "1"
people who selected at least one of the following as reason for their self-perceived discrimination. Consequently, the
participants needed to have the value "1" in the corresponding variable:

	dscrrce: Discrimination of respondent's group: colour or race
	dscrntn: Discrimination of respondent's group: nationality
	dscrrlg: Discrimination of respondent's group: religion
	dscrlng: Discrimination of respondent's group: language
	dscretn: Discrimination of respondent's group: ethnic group

	
Conversely, those people who indicated that they feel discriminated against, but not for reasons that have something to do with being an immigrant, were recoded to have the value "0" (= not feeling discriminated based on factor related to country of origin). These factors could be one or several ones of the following:
	
	dscrage: Discrimination of respondent's group: age
	dscrgnd: Discrimination of respondent's group: gender
	dscrsex: Discrimination of respondent's group: sexuality
	dscrdsb: Discrimination of respondent's group: disability
	dscroth: Discrimination of respondent's group: other grounds
	dscrref: Discrimination of respondent's group: refusal
	dscrna: Discrimination of respondent's group: no answer
	dscrdk: Discrimination of respondent's group: don't know
	dscrnap: Discrimination of respondent's group: not applicable

*/

recode dscrgrp (1=1 "yes") (2=0 "no") (else=.), gen(discriminated)

replace discriminated = 0 if discriminated == 1 & dscrrce != 1 & dscrntn != 1 & dscrrlg != 1 & dscrlng != 1 & dscretn != 1


* specifing by the year of the survey waves (discrimination per year)

fre essround
gen discriminated2002 = discriminated if essround == 1
gen discriminated2004 = discriminated if essround == 2
gen discriminated2006 = discriminated if essround == 3
gen discriminated2008 = discriminated if essround == 4
gen discriminated2010 = discriminated if essround == 5
gen discriminated2012 = discriminated if essround == 6
gen discriminated2014 = discriminated if essround == 7
gen discriminated2016 = discriminated if essround == 8
gen discriminated2018 = discriminated if essround == 9



* 4.3 control variables
***********************

/*
The following variables were intended to be used as control variables.

rlgdnme: Religion or denomination belonging to in the past
rlgdgr: How religious are you
eisced: Highest level of education, ES - ISCED
imptrad: Important to follow traditions and customs
hinctnt: Household's total net income, all sources: ESS waves 1-3
hinctnta: Household's total net income, all sources: from ESS wave 4 onward
livecntr: How long ago first came to live in country
*/


* 4.3.1 religion
****************

	fre rlgdnme
	recode rlgdnme (1=1 "Roman Catholic") (2=2 "Protestant") (3=3 "Eastern Orthodox") (4=4 "Other Christian denomination") (5=5 "Jewish") (6=6 "Islam") (7=7 "Eastern religions") (8=8 "Other Non-Christian religions") (else=.), gen(religion)
	fre religion

	recode religion (1/4=0 "christian") (5/8=1 "nonchristian"), gen(nonchristian)
	fre nonchristian

	fre rlgdgr
	gen religiosity = rlgdgr
	replace religiosity = . if religiosity == .a
	replace religiosity = . if religiosity == .b
	replace religiosity = . if religiosity == .c
	label define religiosity 1 "Not at all religious" 10 "Very religious"
	fre religiosity

/*
The variable "nonchristian" created above, indicating whether an immigrant has a religion different from christianity that is predominant in European countries, was in the end not included in the regression analysis. Mainly, because this religion variable is low in variation between the participants. Another reason is that the religion variable has a strong correlation with GDP/capita, which makes it difficult to distinctively assess their respective effects. See:  */
	regress gdp2002_t i.religion
	
/* The country of origin of non-christian immigrants has in average a -13247.6 lower GDP per capita (in US dollars), ceteris paribus, for the year of the first survey wave in 2002. The effect is highly significant. */


* 4.3.2 education
*****************

	fre eisced
	recode eisced (1=1 "less than lower secondary") (2=2 "lower secondary") (3=3 "upper secondary") (4=4 "upper secondary") (5=5 "advanced vocational") (6=6 "lower tertiary education (BA level)") (7=7 "higher tertiary education (MA level)") (else=.), gen(education)
	fre education

	
* 4.3.3 importance of traditions
********************************

	fre imptrad
	recode imptrad (1=6 "Very much like me") (2=5 "Like me") (3=4 "Somewhat like me") (4=3 "A little like me") (5=2 "Not like me") (6=1 "Not like me at all") (else=.), gen(traditions)
	fre traditions

	
* 4.3.4 household income
************************

	fre hinctnt // net household income variable for survey waves 1-3
	recode hinctnt (1=900 "<1800") (2=2700 "1800-3600") (3=4800 "3600-6000") (4=9000 "6000-12000") (5=15000 "12000-18000") (6=21000 "18000-24000") (7=27000 "24000-30000") (8=33000 "30000-36000") (9=48000 "36000-60000") (10=75000 "60000-90000") (11=105000 "90000-120000") (12=200000 ">120000") (else=.), gen(income)
	fre income
	
	gen income_t = income/1000
	
	
/* From the 4th wave onwards the variable of net household income was measured not using absolutely the same categories over all countries. But rather ten country-specific deciles were created using net household income data from previous years. The absolute numbers indicating the 10 deciles varied from country to country. As this measure of net household income doesn't correspond to the measure used in the previous survey waves, we won't use the variable net household income in the analysis that takes into account the data of all survey waves. - We will only use it in the analyses that contain the data of one specific survey wave. */

	fre hinctnta // net household income variable for survey waves 4 and later
	recode hinctnta (1=1 "1st decile") (2=2 "2nd decile") (3=3 "3rd decile") (4=4 "4th decile") (5=5 "5th decile") (6=6 "6th decile") (7=7 "7th decile") (8=8 "8th decile") (9=9 "9th decile") (10=10 "10th decile") (else=.), gen(income_a)
	fre income_a

	
* 4.3.5 Duration of stay
************************

	fre livecntr
	recode livecntr (1=1 " Within last year") (2=2 "1-5 years ago") (3=3 "6-10 years ago") (4=4 "11-20 years ago") (5=5 "More than 20 years ago") (else=.), gen(stayduration)

	
* 4.4: variables for supplementary analysis (receiving country perspective)
***************************************************************************


* 4.4.1 education qualification of immigrants - variable "educationqualification"
*********************************************************************************

fre qfimedu
recode qfimedu (0=0 "Extremely unimportant") (1=1) (2=2) (3=3) (4=4) (5=5) (6=6) (7=7) (8=8) (9=9) (10=10 "Extremely important") (else=.), gen(educationqualification)


* 4.4.2 immigrants' workskills needed in country - variable "workskillsneeded"
******************************************************************************

fre qfimwsk
recode qfimwsk (0=0 "Extremely unimportant") (1=1) (2=2) (3=3) (4=4) (5=5) (6=6) (7=7) (8=8) (9=9) (10=10 "Extremely important") (else=.), gen(workskillsneeded)
fre workskillsneeded

* 4.4.3 immigrants endangering jobs? - variable "endangerjobs"
**************************************************************

fre imtcjob
recode imtcjob (0=0 "Take jobs away") (1=1) (2=2) (3=3) (4=4) (5=5) (6=6) (7=7) (8=8) (9=9) (10=10 "Create new jobs") (else=.), gen(endangerjobs)
fre endangerjobs

* 4.4.4  immigrants take out more or put in more? - variable "freeloading"
**************************************************************************

fre imbleco
recode imbleco (0=0 "Generally take out more") (1=1) (2=2) (3=3) (4=4) (5=5) (6=6) (7=7) (8=8) (9=9) (10=10 "Generally put in more") (else=.), gen(freeloading)
fre freeloading



* 4.5: saving adapted dataset
*****************************

save "ESS_WorldBank_data.dta", replace
sort _merge
browse

***************
* Finalisation:
***************

log close // closing the log-file

****************************************
* Step 4: final preparation of variables
****************************************
