 ***************************************************
*****************************************************
*****      	 Empirical Research Project:    	*****
*****      	  do-file for data analysis    		*****
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
*   data analysis using data from the ESS (self-perceived discrimination in country of residence, etc.)			*
*	and the World Bank (GDP of contries of birth)															    *
*****************************************************************************************************************




******************************************************************************************************************
* Step 1: Setting up the STATA environment and uploading survey data (source: European Social Survey & World Bank)
******************************************************************************************************************

clear all // cleaning the memory
capture log close // closing potentially open log files
set more off, permanently // set "more" option off
version 17.0 // setting the STATA version to be used

cd "/Users/silja/Desktop/Empirical Research Paper_19June22" // setting the working directory
log using DataAnalysis.log, replace // starting a log-file

use "ESS_WorldBank_data.dta", clear


***********************
* Step 2: data analysis
***********************


* 2.1: logistic regression analysis, marginal plots
***************************************************


/*
There are a number of variables we intend to integrate into the logistic regression analysis.

Firstly, the relevant dependent variable is "discriminated" for the analysis over all years and "discriminated2002",
"discriminated2004", etc. for the regression analysis over one specific year. These are dummy variables we
have previously created using the variable dscrgrp ("Member of a group discriminated against in this country"; 1=yes, 0=no).

Secondly, the relevant independent variable is "gdp_t" for the analysis over all years and "gdp2002_t",
"gdp2004_t", etc. for the regression analysis over one specific year.

Thirdly, we included several control variables. We tried to include variables that might induce
discrimination based on perceived economic threats and perceived cultural threats. From a wide
range of potential variables we selected
- for the analysis over all years:
	"education"
	"traditions"
	"stayduration"
	
	Here, we couldn't include the variable of net household income as it was measured in different ways
	before and after the fourth survey wave (see do-file "data preparation").
	
- for the analysis over one specific year (2002, 2004, etc.):
	"education"
	"traditions"
	"income_t"
	"stayduration"
*/



* 2.1.1: analysis over all survey years
***************************************

logit discriminated gdp_t education traditions i.stayduration essround
margins, dydx(*)
est store m_obverall

* creating a graph: marginsplot
margins, at(gdp_t=(0(5)125))	
marginsplot, recast(line) recastci(rarea) xlabel(0(25)125) ylabel(0(0.1)0.3) ytitle(Probability to feel discriminated) xtitle("GDP per capita of country of origin (in 1000 $)") title("Discrimination of Immigrants", color(black) size(medlarge)) subtitle("depending on GDP of country of origin", size(medlarge)) legend(off) saving(gdp_discriminated_AME.gph, replace)
webdoc graph, as(svg)


* 2.1.2: analysis over survey year 2002
***************************************

logit discriminated2002 gdp2002_t education traditions income_t i.stayduration
margins, dydx(*)
est store m_2002

* creating a graph: marginsplot
margins, at(gdp2002_t=(0(5)125))	
marginsplot, recast(line) recastci(rarea) xlabel(0(25)125) ylabel(0(0.1)0.3) ytitle(Probability to feel discriminated) xtitle("GDP per capita of country of origin (in 1000 $)") title("Discrimination of Immigrants", color(black) size(medlarge)) subtitle("depending on GDP of country of origin 2002", size(medlarge)) legend(off) saving(gdp2002_discriminated2002_AME.gph, replace)
webdoc graph, as(svg)


* 2.1.3: analysis over survey year 2004
***************************************

logit discriminated2004 gdp2004_t education traditions income_t i.stayduration
margins, dydx(*)
est store m_2004

* creating a graph: marginsplot
margins, at(gdp2004_t=(0(5)125))
marginsplot, recast(line) recastci(rarea) xlabel(0(25)125) ylabel(0(0.1)0.3) ytitle(Probability to feel discriminated) xtitle("GDP per capita of country of origin (in 1000 $)") title("Discrimination of Immigrants", color(black) size(medlarge)) subtitle("depending on GDP of country of origin 2004", size(medlarge)) legend(off) saving(gdp2004_discriminated2004_AME.gph, replace)
webdoc graph, as(svg)


* 2.1.4: analysis over survey year 2006
***************************************

logit discriminated2006 gdp2006_t education traditions income_t i.stayduration
margins, dydx(*)
est store m_2006

* creating a graph: marginsplot
margins, at(gdp2006_t=(0(5)125))
marginsplot, recast(line) recastci(rarea) xlabel(0(25)125) ylabel(0(0.1)0.3) ytitle(Probability to feel discriminated) xtitle("GDP per capita of country of origin (in 1000 $)") title("Discrimination of Immigrants", color(black) size(medlarge)) subtitle("depending on GDP of country of origin 2006", size(medlarge)) legend(off) saving(gdp2006_discriminated2006_AME.gph, replace)
webdoc graph, as(svg)


* 2.1.5: analysis over survey year 2008
***************************************

logit discriminated2008 gdp2008_t education traditions income_a i.stayduration
margins, dydx(*)
est store m_2008

* creating a graph: marginsplot
margins, at(gdp2008_t=(0(5)125))	
marginsplot, recast(line) recastci(rarea) xlabel(0(25)125) ylabel(0(0.1)0.3) ytitle(Probability to feel discriminated) xtitle("GDP per capita of country of origin (in 1000 $)") title("Discrimination of Immigrants", color(black) size(medlarge)) subtitle("depending on GDP of country of origin 2008", size(medlarge)) legend(off) saving(gdp2008_discriminated2008_AME.gph, replace)
webdoc graph, as(svg)


* 2.1.6: analysis over survey year 2010
***************************************

logit discriminated2010 gdp2010_t education traditions income_a // Values for the variable "stayduration" were missing in this wave, therefore, we didn't include this control variable in this regression.
margins, dydx(*)
est store m_2010

* creating a graph: marginsplot
margins, at(gdp2010_t=(0(5)125))
marginsplot, recast(line) recastci(rarea) xlabel(0(25)125) ylabel(0(0.1)0.3) ytitle(Probability to feel discriminated) xtitle("GDP per capita of country of origin (in 1000 $)") title("Discrimination of Immigrants", color(black) size(medlarge)) subtitle("depending on GDP of country of origin 2010", size(medlarge)) legend(off) saving(gdp2010_discriminated2010_AME.gph, replace)
webdoc graph, as(svg)


* 2.1.7: analysis over survey year 2012
***************************************

logit discriminated2012 gdp2012_t education traditions income_a  // Values for the variable "stayduration" were missing in this wave, therefore, we didn't include this control variable in this regression.
margins, dydx(*)
est store m_2012

* creating a graph: marginsplot
margins, at(gdp2012_t=(0(5)125))
marginsplot, recast(line) recastci(rarea) xlabel(0(25)125) ylabel(0(0.1)0.3) ytitle(Probability to feel discriminated) xtitle("GDP per capita of country of origin (in 1000 $)") title("Discrimination of Immigrants", color(black) size(medlarge)) subtitle("depending on GDP of country of origin 2012", size(medlarge)) legend(off) saving(gdp2012_discriminated2012_AME.gph, replace)
webdoc graph, as(svg)


* 2.1.8: analysis over survey year 2014
***************************************

logit discriminated2014 gdp2014_t education traditions income_a // Values for the variable "stayduration" were missing in this wave, therefore, we didn't include this control variable in this regression.
margins, dydx(*)
est store m_2014

margins, at(gdp2014_t=(0(5)125))
marginsplot, recast(line) recastci(rarea) xlabel(0(25)125) ylabel(0(0.1)0.3) ytitle(Probability to feel discriminated) xtitle("GDP per capita of country of origin (in 1000 $)") title("Discrimination of Immigrants", color(black) size(medlarge)) subtitle("depending on GDP of country of origin 2014", size(medlarge)) legend(off) saving(gdp2014_discriminated2014_AME.gph, replace)
webdoc graph, as(svg)


* 2.1.7: analysis over survey year 2016
***************************************

logit discriminated2016 gdp2016_t education traditions income_a // Values for the variable "stayduration" were missing in this wave, therefore, we didn't include this control variable in this regression.
margins, dydx(*)
est store m_2016

margins, at(gdp2016_t=(0(5)125))
marginsplot, recast(line) recastci(rarea) xlabel(0(25)125) ylabel(0(0.1)0.3) ytitle(Probability to feel discriminated) xtitle("GDP per capita of country of origin (in 1000 $)") title("Discrimination of Immigrants", color(black) size(medlarge)) subtitle("depending on GDP of country of origin 2016", size(medlarge)) legend(off) saving(gdp2016_discriminated2016_AME.gph, replace)
webdoc graph, as(svg)


* 2.1.8: analysis over survey year 2018
***************************************

/*
We intended to do the following logistic regression analysis for survey year 2018 as well but we weren't successful.

	logit discriminated2018 gdp2018_t education traditions income_a // Values for the variable "stayduration" were missing in this wave, therefore, we didn't include this control variable in this regression.
	margins, dydx(*)
	
	margins, at(gdp2018_t=(0(5)125))	
	marginsplot, recast(line) recastci(rarea) xlabel(0(25)125) ylabel(0(0.1)0.3) ytitle(Probability to feel discriminated) xtitle("GDP per capita of country of origin (in 1000 $)") title("Discrimination of Immigrants", color(black) size(medlarge)) subtitle("depending on GDP of country of origin 2018", size(medlarge)) legend(off) saving(gdp2018_discriminated2018_AME.gph, replace)
	webdoc graph, as(svg)


The problem was that there were probably no observations for immigrants that had both a value for the self-perceived
level of discrimination (discminated2018) and for the GDP per capita of their country of origin (gdp2018_t).
This could be the case because maybe none of the immigrants answered the question wheater thyy feel discriminated or not.
*/


* 2.1.9: 
***************************************

esttab m_obverall m_2002 m_2004 m_2006 m_2008 m_2010 m_2012 m_2014 m_2016, b star

*combined graph
graph combine "gdp2002_discriminated2002_AME" "gdp2004_discriminated2004_AME" "gdp2006_discriminated2006_AME" "gdp2008_discriminated2008_AME" "gdp2010_discriminated2010_AME" "gdp2012_discriminated2012_AME" "gdp2014_discriminated2014_AME" "gdp2016_discriminated2016_AME", commonscheme


*2.2 descriptive analysis of peoples attitudes towards immigrants: variables related to economic treath hypothesis
******************************************************************************************************************

/*
Besides the immigrants' perspective on self-perceived discrimination based on GDP per capita
and other (control) variables, we wanted to test the country of receiving's perspective on
their attitudes towards immigrant's based on their countries of origin's GDP's, and based
on other aspects, such as their level of education. Into this descriptive analysis, we tried
to include both variables that might induce discrimination based on perceived economic threats
and also variables that might induce discrimination based on perceived cultural threats.
*/


* 2.2.1: education qualification of immigrants - variable "educationqualification"	 
**********************************************************************************

sum educationqualification, detail
/*

      RECODE of qfimedu (Qualification for immigration:
               good educational qualification
-------------------------------------------------------------
      Percentiles      Smallest
 1%            0              0
 5%            0              0
10%            2              0       Obs              80,950
25%            5              0       Sum of wgt.      80,950

50%            7                      Mean           6.269759
                        Largest       Std. dev.      2.704023
75%            8             10
90%           10             10       Variance       7.311743
95%           10             10       Skewness      -.6274174
99%           10             10       Kurtosis       2.756394

*/

histogram educationqualification, discrete width(0.5) percent fcolor(navy%90) lcolor(navy*1.1) ytitle("Percentage", margin(medsmall)) ylabel(0(5)20, labsize(medium) labcolor(black) grid glcolor(ebblue%20) glpattern(solid)) xtitle("") xlabel( 0 "0" 1 2 3 4 5 6 7 8 9 10 "10") title("Immigrants' Educational Qualification") subtitle("How important do you regard Immigrants' Qualification of Education?") note("ESS data", span) legend(on order(0 " 0 extremely unimportant" 10 "10 extremely important") stack cols(2) rowgap(medsmall) colgap(medsmall)) graphregion(fcolor(white) ifcolor(white)) saving(educationqualification.gph, replace)

/*
graph box educationqualification, ytitle("") title("Immigrants' Educational Qualification") subtitle("How important do you regard Immigrants' Qualification of Education?") note("ESS data", span) legend(on order(0 " 0 extremely unimportant" 10 "10 extremely important") stack cols(2) rowgap(medsmall) colgap(medsmall)) graphregion(fcolor(white) ifcolor(white)) saving(educationqualification.gph, replace)
*/

* 2.2.2: immigrants' workskills needed in country - variable "workskillsneeded"	 
*******************************************************************************

sum workskillsneeded, detail
/*
      
	  RECODE of qfimwsk (Qualification for immigration:
               work skills needed in country)
-------------------------------------------------------------
      Percentiles      Smallest
 1%            0              0
 5%            0              0
10%            2              0       Obs              81,111
25%            5              0       Sum of wgt.      81,111

50%            7                      Mean            6.67632
                        Largest       Std. dev.      2.777443
75%            9             10
90%           10             10       Variance       7.714192
95%           10             10       Skewness      -.8639507
99%           10             10       Kurtosis       3.038279

*/

histogram workskillsneeded, discrete width(0.5) percent fcolor(navy%90) lcolor(navy*1.1) ytitle("Percentage", margin(medsmall)) ylabel(0(5)20, labsize(medium) labcolor(black) grid glcolor(ebblue%20) glpattern(solid)) xtitle("") xlabel( 0 "0" 1 2 3 4 5 6 7 8 9 10 "10") title("Immigrants' Workskills") subtitle("How important do you regard Immigrants' Workskills?") note("ESS data", span) legend(on order(0 " 0 extremely unimportant" 10 "10 extremely important") stack cols(2) rowgap(medsmall) colgap(medsmall)) graphregion(fcolor(white) ifcolor(white)) saving(workskillsneeded.gph, replace) name(workskills, replace)


* 2.2.3: immigrants endangering jobs? - variable "endangerjobs"	 
***************************************************************

sum endangerjobs, detail

/*
       RECODE of imtcjob (Immigrants take jobs away in
                 country or create new jobs)
-------------------------------------------------------------
      Percentiles      Smallest
 1%            0              0
 5%            0              0
10%            1              0       Obs              79,192
25%            3              0       Sum of wgt.      79,192

50%            5                      Mean           4.634887
                        Largest       Std. dev.      2.303727
75%            6             10
90%            8             10       Variance       5.307158
95%            8             10       Skewness      -.1816665
99%           10             10       Kurtosis       2.789307

*/

histogram endangerjobs, discrete width(0.5) percent fcolor(navy%90) lcolor(navy*1.1) ytitle("Percentage", margin(medsmall)) ylabel(0(5)35, labsize(medium) labcolor(black) grid glcolor(ebblue%20) glpattern(solid)) xtitle("") xlabel( 0 "0" 1 2 3 4 5 6 7 8 9 10 "10") title("Do you see Jobs threatened by Immigrants?") note("ESS data", span) legend(on order(0 " 0 Immigrants take Jobs away" 10 "10 Immigrants create new Jobs") stack cols(2) rowgap(medsmall) colgap(medsmall)) graphregion(fcolor(white) ifcolor(white)) saving(endangerjobs.gph, replace) name(endangerjobs, replace)


* 2.2.4: immigrants take out more or put in more? - variable "freeloading"	 
**************************************************************************

sum freeloading, detail

/*
      RECODE of imbleco (Taxes and services: immigrants
               take out more than they put in
-------------------------------------------------------------
      Percentiles      Smallest
 1%            0              0
 5%            0              0
10%            1              0       Obs              77,423
25%            3              0       Sum of wgt.      77,423

50%            5                      Mean           4.342934
                        Largest       Std. dev.      2.223503
75%            5             10
90%            7             10       Variance       4.943966
95%            8             10       Skewness       .0043707
99%           10             10       Kurtosis       2.830929

*/

histogram freeloading, discrete width(0.5) percent fcolor(navy%90) lcolor(navy*1.1) ytitle("Percentage", margin(medsmall)) ylabel(0(5)30, labsize(medium) labcolor(black) grid glcolor(ebblue%20) glpattern(solid)) xtitle("") xlabel( 0 "0" 1 2 3 4 5 6 7 8 9 10 "10") title("Taxes and Services") subtitle("Do you regard Immigrants to take out more than they put in?") note("ESS data", span) legend(on order(0 " 0 generally take out more" 10 "10 generally put in more") stack cols(2) rowgap(medsmall) colgap(medsmall)) graphregion(fcolor(white) ifcolor(white)) saving(freeloading.gph, replace) name(freeloading, replace)


* 2.2.5: Allow many/few immigrants depending on country's welfare - variables "imrcntr" & "imrcntr"
**************************************************************************

/*
For this last descriptive analysis we need to use a different ESS dataset.
The reason for this is that one of the variables needed below, "imrcntr",
was not listed on the download page of the ESS website, where we downloaded
all data we needed. We were only able to access the data of this variable
by downloading the whole dataset of the first survey wave (whithout specifying
just those variables we actually needed). The downloaded dataset that includes
all variables of the first wave is called "ESS1e06_6.dta".
*/

use ESS1e06_6.dta, clear

fre impcntr // imrcntr: Allow many/few immigrants from richer countries outside Europe
fre imrcntr // impcntr: Allow many/few immigrants from poorer countries outside Europe

* generating new variables for illustration:

recode impcntr (1=1 "many") (2=2 "some") (3=3 "few") (4=4 "none") (else=.), gen(poorimmigrants) 
recode imrcntr (1=1 "many") (2=2 "some") (3=3 "few") (4=4 "none") (else=.), gen(richimmigrants) 

fre poorimmigrants
fre richimmigrants


* illustration of the two variables' distributions:

gen richimmigrantsplus = richimmigrants + 0.18
gen poorimmigrantsminus = poorimmigrants - 0.18

twoway histogram richimmigrantsplus if poorimmigrants !=., /// Variable 1
 percent discrete  barwidth(0.3) /// 
	 fcolor(navy) lcolor(navy*1.1) ///
	 ylabel(0(5)45, gmax glcolor(emidblue*0.2)) yscale(extend) ///
	 xlabel( 1 "many" 2 "some" 3 "few" 4 "none") ///
	 graphregion(color(white)) plotregion(color(white)) bgcolor(white) ///
	 title("Immigrants from richer vs. immigrants from poorer countries", size(medlarge)) ///
	 subtitle("How many immigrants from outside europe do people allow?") ///
	 ytitle("Percentage", margin(small)) /// 
	 note("ESS data, 2002", span)  ///
	 legend(label(1 "rich countries") label(2 "poor countries")) ///
	 || histogram  poorimmigrantsminus if richimmigrants != ., /// Variable 2
	 percent discrete  barwidth(0.3)  fcolor(navy*0.5) lcolor(navy*0.55) ///
	 saving(poorimmigrantsvsrichimmigrants.gph, replace)
	 
* comparing the means of the two variables using a paired-samples t-test:
ttest impcntr == imrcntr

/* 
This t-test was conducted on 39'821 survey participants to determine if they have in average different attitudes about allowing immigrants from poorer versus richer countries than the one they live in.
 
Results showed that the mean attitude regarding immigrants of poorer countries was statistically significantly different from the mean attitude regarding immigrants of richer countries (t = 15.3859 with df=39820, p < 0.0001) at a significance level of 0.05.
 
A 95% confidence interval for the true difference in population means resulted in the interval of (0.0449442, 0.0580668).

One limitation of using the t-test here is that arguably the variables are not on an interval scale but rather an ordinal one. If we suppose that, the results of this test are not useful because the paired-samples t-test needs variables on an interval scale.
*/



***************
* Finalisation:
***************

log close // closing the log-file
