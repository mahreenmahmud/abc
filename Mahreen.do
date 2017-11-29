************************/********************************************/
* Analysis do-file consolidating RCT analysis files  			    *                             							 			*
* Written by: Farah Said					  		 		     	*                         			 
* Status: In process		                					    *
* Latest changes: 29/07/17					  	 					 	*
*********************************************************************/

/*********************************************************************
 ====================== DO-FILE INDEX=============================
FOLLOWING THE ORDER OF ANALYSIS IN PREVIOUS IGC REPORT


The following variables were significant in the attrition analysis and need to be included
for robustness: marrieddummy, dependency ratio, homeownership, asset_index, emp_index, marrieddummy*treatment

marrieddummy and dep_ratio have significant q stats. The rest are insignificant. 
 	E) Find the impact over short and longer term

	Variable "SurveyRound" mentions the round.
		Baseline	(2014)
		Endline		(2015)	
		Endline2016	(2016)

RQs from the word doc started on 25/2/15 by MM and FS:
	*)RQ1: i) effect of loan and training (treatment) on creation and sustaining business
		  ii) what explains excess within the treated?
		 iii) within control, why/not was a business opened?
	*)RQ2: does empowerment improve due to t?
	*)RQ3: does t improve well being of the household (impact)? asset, income, house structure, exp
	*)RQ4: How many households have another business? Does this change likelihood of opening a business? 
		   Look at direct questions on wanting to start a business, reasons for why they coudnt (KA and KB in data)
		   This is based on MMs discussion with Erica field.
		   
		   I look at: 
		   - How many other entrep in the household and the effect it has on opening a business
		   (no effect but ITT loses effect too in these households)
		   - Whether the business type is personal services (most common type) for these entrep has an impact
		   
		   - The use KIKK loan was put to (bar graph)
		   - The sources used to repay KIKK (bar graph)
		   - The stated purpose of other loans in each of the three years. (bar graph)
		   
		   
		   NOTE: no longer using count variables, dont provide more info and im not sure the baseline values
		   costructed correctly. 
*********************************************************************/
clear all
cd "E:\Dropbox\kashf\RCT Analysis"
use CompletePanelwoRoster070717, clear

set more off

gen marrtreat = marrieddummy*treated
label 	var 	marrtreat "Dummy: Respondent is currently married and in the treatment sample"
label 	var 	ITT 	  "Treatment"

*using 2014 branchcodes
cap drop BranchDummy*
bysort ID: replace branchcode =  branchcode[_n-1] if SurveyRound == "Endline"
bysort ID: replace branchcode =  branchcode[_n-1] if SurveyRound == "Endline2016"

quietly tab branchcode, gen(BranchDummy)

*****************************LABELLING VARIABLES********************************

bysort ID: replace Age =  Age[_n+1] - 1 if Age == . & SurveyRound == "Baseline"
*family 1: demographics
label 	var 	Age			 "Age (years)"
label 	var 	marrieddummy "Married"
label 	var 	lit 		 "Literate"
label 	var 	noofchildren "Children"
//11 missing values for dep_ratio in 2014, being replaced by 2015 values. 
bysort ID: replace dep_ratio =  dep_ratio[_n+1] if dep_ratio == . & SurveyRound == "Baseline"
label 	var 	dep_ratio 	 "Dependency ratio"
*Family 2: Respondent occupation and experience
label 	var 	selfempl 	 "Self employed"
label 	var 	pastemployee "Employee in the past"
label 	var 	pastbus 	 "Business in the past"
label 	var	 	mother_bus 	 "Mother ever had a business" //not asked at baseline
label 	var 	fam_bus 	 "Family ever had a business" //not asked at baseline
labe 	var 	otherfam_bus "Family (excl. mother) ever had a business" //not asked at baseline
//not replacin missing values in hh exp
 
*Family 3: household assets and income
label 	var 	hhexp 		 "Monthly household expenditure"
label 	var 	homeown 	 "Home owner"
label 	var 	asset_index  "Asset index"

*Family4: agency and autonomu
label 	var 	confident 	 "Confidence"
label 	var 	emp_index 	 "Employment index"
label 	var 	index_agency "Agency index"
*label 	var 	decide_count "Number of household decisions"
*label 	var 	decide_count_fin 	"Number of financial household decisions"
*label 	var 	decide_count_nonfin "Number of non-financial household decisions"
label 	var 	allowed_work 	"Allowed to work"
//last was not asked at endline

*Family5: financial inclusion
label 	var 	loansoutst14 "Outstanding loans"  //only at baseline (take out from output)
label 	var 	comm14 		 "Participated in ROSCAs"
label 	var 	bankacc 	 "Bank account"
label 	var 	loans_lastyr "Took loans in last year" 
label 	var 	insurance	 "Insurance" //not asked at baseline
label 	var 	atm			 "ATM" //not asked at baseline
*label 	var 	kikk_amount  "Size of loan provided (treatment)"
*label 	var 	kikk_repaid  "Dummy: loan (treatment) was repaid on time"
//loanam_lastyr has outstanding loan amounts but not asked at baseline

*family 6: Business creation (2015 - 2016) //not asked at baseline
label 	var 	bus_lastyear "Set up a business last year"
label 	var 	business_started 	"Set up business"
label 	var 	bus_shutlastyr	 	"Business shut down"

*family 7: Business performance (2015 - 2016) //not asked at baseline
label 	var 	busathome	 "Dummy: Respondent operates her business from home"
label 	var 	bus_startcosts 		"Busines start up costs (PKR)"
label 	var 	bus_assets 			"Business assets (PKR)"
label 	var 	bus_exp		 "Business average monthly expenditure (PKR)"
label  	var 	bus_rev 	 "Business average monthly revenues (PKR)"
label 	var 	bus_profits1 "Business average monthly profits (1)(PKR)"
label 	var 	bus_profits2 "Business average monthly profits (2)(PKR)"

*Family 8: numeracy and other skills //not asked at baseline
label 	var 	rem_training "Recalls training"
label 	var 	correct_maths 		"Basic maths"
label 	var 	digit_level 		"Digit span level"
label 	var		correct_bus			"Basic accounting" 
label 	var 	correct_finsense	"Basic finance"

*Family 9: Perceptions about self and outlook //not asked at baseline
label 	var 	pos_busoutlook 		"Positive business outlook"
label 	var 	pos_econoutlook 	"Positive economic outlook"
label 	var		planner				"Planner"
label 	var 	eagerwork		 	"Eager to work"
rename	careful	cautious
label 	var 	cautious 			"Cautious"
label 	var 	competitive 		"Competitive"	
*label 	var 	risk_averse			"Dummy: Respondent opts for certain amount in risk game"


/*we need a variable for business started since the baseline.
drop finalsample
merge m:1 ID using "${input}/2015category.dta"

drop _merge
merge m:1 ID SurveyRound using "${input}/Demographics.dta"

drop _merge
*/
drop if ID==.
bysort ID: egen totalsurveys= count(ID) if finalsample == 1
tab totalsurveys
drop if totalsurveys!=3 //to make sure only those surveyed thrice remain
sort ID Round
xtset ID Round

set more off

tab contaminated SurveyRound
tab contaminated category
tab not_disbursed category

//12 T did not get the loan
//8 C did. Therefore use ITT
*****************************D)IMPACT SR and LR*********************************
*RQ1
*******************************************************************************/



* 1) business started since treatment, controlling for attrition imbalance.
*I also check for kikk amount and find no change in results
*(kikktreated = (kikk_amount*ITT); replace with 0 if . and use in regression below). 
eststo clear
replace bus_lastyear = 0 if bus_lastyear == . & SurveyRound == "Endline2016"


*family6: 
foreach y in business_started bus_lastyear bus_shutlastyr{
			eststo Reg`y': ivreg2 	`y' ITT L.marrieddummy L.dep_ratio L.homeown L.asset_index L.marrtreat BranchDummy* if Round==2, partial(L.marrieddummy L.dep_ratio L.homeown L.asset_index L.marrtreat BranchDummy*) cluster(ID)
			}
esttab using ImpFam6.tex, b(%9.3f) se(%9.3f) ///
			label staraux star(* 0.1 ** 0.05 *** 0.01) replace width(7in) ///
			stats(N r2) nomtitles nonotes
esttab using ImpFam6.csv, b(%9.3f) p ///
			label stats(N r2) nomtitles nonotes replace

eststo clear

preserve
clear
import excel "ImpFam6.xlsx", sheet("p") cellrange(A1:A3)
rename A pval
save qimp6short, replace
do SharpenedQValues
save qimp6short, replace
restore

foreach y in business_started bus_lastyear bus_shutlastyr{
			eststo Reg`y': ivreg2 	`y' ITT L2.marrieddummy L2.dep_ratio L2.homeown L2.asset_index L2.marrtreat BranchDummy* if Round==3, partial(L2.marrieddummy L2.dep_ratio L2.homeown L2.asset_index L2.marrtreat BranchDummy*) cluster(ID)
			}
esttab using ImpFam6_long.tex, b(%9.3f) se(%9.3f) ///
			label staraux star(* 0.1 ** 0.05 *** 0.01) replace width(7in) ///
			stats(N r2) nomtitles nonotes
esttab using ImpFam6_long.csv, b(%9.3f) p ///
			label stats(N r2) nomtitles nonotes replace

eststo clear

preserve
clear
import excel "ImpFam6_long.xlsx", sheet("p") cellrange(A1:A3)
rename A pval
save qimp6long, replace
do SharpenedQValues
save qimp6long, replace
restore


*this more detailed result showing robustness to attrition controls in the appendix:
reg business_started ITT if Round==2, cluster(ID)
*outreg2 using bus1.xsls, excel se pdec(3) replace
//ivreg2 allows me to use partial which uses 2 step GMM and partials out exog variables branch dummies, 
//conceptually the same result as an OLS except neater se due to partialling. It seems partialling out 
//branch, country, time dummies this way is the norm. 
eststo: ivreg2 business_started ITT BranchDummy* if Round==2, partial(BranchDummy*) cluster(ID)
*outreg2 using bus1.xsls, excel se pdec(3) label replace
eststo: ivreg2 business_started ITT L.marrieddummy L.dep_ratio L.homeown L.asset_index L.marrtreat BranchDummy* if Round==2, partial(BranchDummy*) cluster(ID)
*outreg2 using bus1.xsls, excel se pdec(3) label append
eststo: ivreg2 business_started ITT BranchDummy* if Round==3, partial(BranchDummy*) cluster(ID)
*outreg2 using bus1.xsls, excel se pdec(3) label append
eststo: ivreg2 business_started ITT L2.marrieddummy L2.dep_ratio L2.homeown L2.asset_index L2.marrtreat BranchDummy* if Round==3, partial(BranchDummy*) cluster(ID)
*outreg2 using bus1.xsls, excel se pdec(3) label append

esttab using bus1.tex, b(%9.3f) se(%9.3f) ///
			label staraux star(* 0.1 ** 0.05 *** 0.01) replace width(9in) ///
			order(ITT L.marrieddummy L.dep_ratio L.homeown L.asset_index L.marrtreat) stats(N r2 ) nomtitles nonotes compress

eststo clear



*avg performance characteristics for those that set up a business:
//family 7: (no point running a regression, v small samples)
//we actually have very few obs for the endline. Not sure if this is worth a lot of discussion.
eststo clear
eststo rnd2: quietly estpost summarize ///
    bus_startcosts bus_assets bus_exp bus_rev bus_profits1 bus_profits2 if business_started == 1 & Round == 2
eststo rnd3: quietly estpost summarize ///
    bus_startcosts bus_assets bus_exp bus_rev bus_profits1 bus_profits2 if business_started == 1 & Round == 3

esttab rnd2 rnd3 using bussum.tex, ///
cells("count mean sd") ///
label replace


*2) correlates of business being set up - given the balance at baseline, these are the things that have 
//changed with business being set up but we dont know causation.  
*family 1-4, 7 & 8. Can have just indices? check if individual are interesting e.g. mother business
*report FDR? 
eststo clear

foreach y in mother_bus fam_bus otherfam_bus{
	gen treat`y' = ITT*`y'
			}
			
eststo: ivreg2 business_started ITT fam_bus treatfam_bus L.marrieddummy L.dep_ratio L.homeown L.asset_index L.marrtreat BranchDummy* if Round==2, partial(BranchDummy*) cluster(ID)
eststo: ivreg2 business_started ITT mother_bus treatmother_bus otherfam_bus treatotherfam_bus L.marrieddummy L.dep_ratio L.homeown L.asset_index L.marrtreat BranchDummy* if Round==2, partial(BranchDummy*) cluster(ID)
eststo: ivreg2 business_started ITT fam_bus treatfam_bus L2.marrieddummy L2.dep_ratio L2.homeown L2.asset_index L2.marrtreat BranchDummy* if Round==3, partial(BranchDummy*) cluster(ID)
eststo: ivreg2 business_started ITT mother_bus treatmother_bus otherfam_bus treatotherfam_bus L2.marrieddummy L2.dep_ratio L2.homeown L2.asset_index L2.marrtreat BranchDummy* if Round==3, partial(BranchDummy*) cluster(ID)

//business shutthing down as no impact
ivreg2 business_started ITT bus_shutlastyr L.marrieddummy L.dep_ratio L.homeown L.asset_index L.marrtreat BranchDummy* if Round==2, partial(BranchDummy*) cluster(ID)

esttab using buscorr1.tex, b(%9.3f) se(%9.3f) ///
			label staraux star(* 0.1 ** 0.05 *** 0.01) replace width(9in) ///
			order(ITT L.marrieddummy L.dep_ratio L.homeown L.asset_index L.marrtreat) stats(N r2 ) nomtitles nonotes compress

eststo clear

foreach y in rem_training correct_maths digit_level correct_bus correct_finsense{
	gen treat`y' = ITT*`y'
			}

eststo: ivreg2 business_started ITT rem_training treatrem_training L.marrieddummy L.dep_ratio L.homeown L.asset_index L.marrtreat BranchDummy* if Round==2, partial(L.marrieddummy L.dep_ratio L.homeown L.asset_index L.marrtreat BranchDummy*) cluster(ID)
eststo: ivreg2 business_started ITT correct_maths treatcorrect_maths digit_level treatdigit_level correct_bus  treatcorrect_bus L.marrieddummy L.dep_ratio L.homeown L.asset_index L.marrtreat BranchDummy* if Round==2, partial(L.marrieddummy L.dep_ratio L.homeown L.asset_index L.marrtreat BranchDummy*) cluster(ID)
eststo: ivreg2 business_started ITT rem_training treatrem_training correct_maths treatcorrect_maths digit_level digit_level correct_bus treatcorrect_bus L.marrieddummy L.dep_ratio L.homeown L.asset_index L.marrtreat BranchDummy* if Round==2, partial(L.marrieddummy L.dep_ratio L.homeown L.asset_index L.marrtreat BranchDummy*) cluster(ID)
eststo: ivreg2 business_started ITT correct_maths treatcorrect_maths correct_bus treatcorrect_bus correct_finsense treatcorrect_finsense L2.marrieddummy L2.dep_ratio L2.homeown L2.asset_index L2.marrtreat BranchDummy* if Round==3, partial(L2.marrieddummy L2.dep_ratio L2.homeown L2.asset_index L2.marrtreat BranchDummy*) cluster(ID)

esttab using buscorrfam8.tex, b(%9.3f) se(%9.3f) ///
			label staraux star(* 0.1 ** 0.05 *** 0.01) replace width(9in) ///
			stats(N r2 ) nomtitles nonotes compress
eststo clear

foreach y in pos_busoutlook pos_econoutlook planner eagerwork cautious competitive{
	gen treat`y' = ITT*`y'
			}

eststo: ivreg2 business_started ITT pos_busoutlook treatpos_busoutlook pos_econoutlook treatpos_econoutlook L.marrieddummy L.dep_ratio L.homeown L.asset_index L.marrtreat BranchDummy* if Round==2, partial(L.marrieddummy L.dep_ratio L.homeown L.asset_index L.marrtreat BranchDummy*) cluster(ID)
eststo: ivreg2 business_started ITT planner treatplanner eagerwork treateagerwork cautious treatcautious competitive treatcompetitive L.marrieddummy L.dep_ratio L.homeown L.asset_index L.marrtreat BranchDummy* if Round==2, partial(L.marrieddummy L.dep_ratio L.homeown L.asset_index L.marrtreat BranchDummy*) cluster(ID)
eststo: ivreg2 business_started ITT pos_busoutlook treatpos_busoutlook pos_econoutlook treatpos_econoutlook L2.marrieddummy L2.dep_ratio L2.homeown L2.asset_index L2.marrtreat BranchDummy* if Round==3, partial(L2.marrieddummy L2.dep_ratio L2.homeown L2.asset_index L2.marrtreat BranchDummy*) cluster(ID)
eststo: ivreg2 business_started ITT planner treatplanner eagerwork treateagerwork cautious treatcautious competitive treatcompetitive L2.marrieddummy L2.dep_ratio L2.homeown L2.asset_index L2.marrtreat BranchDummy* if Round==3, partial(L2.marrieddummy L2.dep_ratio L2.homeown L2.asset_index L2.marrtreat BranchDummy*) cluster(ID)

esttab using buscorrfam9.tex, b(%9.3f) se(%9.3f) ///
			label staraux star(* 0.1 ** 0.05 *** 0.01) replace width(9in) ///
			stats(N r2 ) nomtitles nonotes compress
eststo clear


//business shutthing down as no impact
ivreg2 business_started ITT bus_shutlastyr L.marrieddummy L.dep_ratio L.homeown L.asset_index L.marrtreat BranchDummy* if Round==2, partial(BranchDummy*) cluster(ID)

esttab using buscorr1.tex, b(%9.3f) se(%9.3f) ///
			label staraux star(* 0.1 ** 0.05 *** 0.01) replace width(9in) ///
			order(ITT L.marrieddummy L.dep_ratio L.homeown L.asset_index L.marrtreat) stats(N r2 ) nomtitles nonotes compress

eststo clear

eststo: ivreg2 bus_shutlastyr ITT fam_bus treatfam_bus L.marrieddummy L.dep_ratio L.homeown L.asset_index L.marrtreat BranchDummy* if Round==2, partial(BranchDummy*) cluster(ID)
eststo: ivreg2 bus_shutlastyr ITT mother_bus treatmother_bus otherfam_bus treatotherfam_bus L.marrieddummy L.dep_ratio L.homeown L.asset_index L.marrtreat BranchDummy* if Round==2, partial(BranchDummy*) cluster(ID)
eststo: ivreg2 bus_shutlastyr ITT fam_bus treatfam_bus L2.marrieddummy L2.dep_ratio L2.homeown L2.asset_index L2.marrtreat BranchDummy* if Round==3, partial(BranchDummy*) cluster(ID)
eststo: ivreg2 bus_shutlastyr ITT mother_bus treatmother_bus otherfam_bus treatotherfam_bus L2.marrieddummy L2.dep_ratio L2.homeown L2.asset_index L2.marrtreat BranchDummy* if Round==3, partial(BranchDummy*) cluster(ID)
//no correlate is significant
eststo clear

eststo: ivreg2 bus_lastyear ITT fam_bus treatfam_bus L2.marrieddummy L2.dep_ratio L2.homeown L2.asset_index L2.marrtreat BranchDummy* if Round==3, partial(BranchDummy*) cluster(ID)
eststo: ivreg2 bus_lastyear ITT mother_bus treatmother_bus otherfam_bus treatotherfam_bus L2.marrieddummy L2.dep_ratio L2.homeown L2.asset_index L2.marrtreat BranchDummy* if Round==3, partial(BranchDummy*) cluster(ID)
//fam bus and other fam business significant in LT. 
eststo clear

*use CompletePanelwoRoster180717, clear
*gen busnotshut = 1 - bus_shutlastyr
*save CompletePanelwoRoster180717, replace

*making one index:
do make_index
use CompletePanelwoRoster180717, clear
cap gen wgt = 1
local outcomes "business_started bus_lastyear bus_shutlastyr"
cap make_index family6 wgt `outcomes'

xtset ID Round
eststo clear
eststo Reg`y': ivreg2 	index_family6 ITT L.marrieddummy L.dep_ratio L.marrtreat BranchDummy* if Round==2, partial(L.marrieddummy L.dep_ratio L.marrtreat BranchDummy*) cluster(ID)
esttab using ImpFam6index.tex, b(%9.3f) se(%9.3f) ///
			label staraux star(* 0.1 ** 0.05 *** 0.01) replace width(7in) ///
			stats(N r2) nomtitles nonotes

eststo clear


*making one index:
do make_index
use CompletePanelwoRoster180717, clear
cap gen wgt = 1
local outcomes "business_started bus_lastyear busnotshut"
cap make_index family6_2 wgt `outcomes'

xtset ID Round
eststo clear
eststo Reg`y': ivreg2 	index_family6_2 ITT L.marrieddummy L.dep_ratio L.marrtreat BranchDummy* if Round==2, partial(L.marrieddummy L.dep_ratio L.marrtreat BranchDummy*) cluster(ID)
esttab using ImpFam6_2index.tex, b(%9.3f) se(%9.3f) ///
			label staraux star(* 0.1 ** 0.05 *** 0.01) replace width(7in) ///
			stats(N r2) nomtitles nonotes

eststo clear

*****************************D)IMPACT SR and LR*********************************
*RQ2&3
*******************************************************************************/

/* impact on hh and empowerment:
----------------------------------
*1) F 3,4,5,6,7,9
*2) q-values of each family
*3) see if need to make tree diagram a la angelucci, given everything insig?? 
----------------------------------*/
* Family 3: 
//control for attrition imbalance on married, marriedtreat and dep ratio

eststo clear
set more off
foreach y in hhexp homeown asset_index{
		
		capture drop 	`y'_pre
		gen 			`y'_pre 	= L.`y'
		
		eststo Reg`y': ivreg2 	`y' ITT `y'_pre L.marrieddummy L.dep_ratio L.marrtreat BranchDummy* if Round==2, partial(L.marrieddummy L.dep_ratio L.marrtreat BranchDummy*) cluster(ID)
			}
esttab using ImpFam3.tex, b(%9.3f) se(%9.3f) ///
			label staraux star(* 0.1 ** 0.05 *** 0.01) replace width(7in) ///
			stats(N r2) nomtitles nonotes
esttab using ImpFam3.csv, b(%9.3f) p ///
			label stats(N r2) nomtitles nonotes replace

eststo clear

foreach y in hhexp homeown asset_index{
		
		capture drop 	`y'_pre
		gen 			`y'_pre 	= L.`y'
		
		eststo Reg`y': ivreg2 	`y' (business_started = ITT) `y'_pre L.marrieddummy L.dep_ratio L.marrtreat BranchDummy* if Round==2, partial(L.marrieddummy L.dep_ratio L.marrtreat BranchDummy*) cluster(ID)
			}

eststo clear

*making one index:
do make_index
use CompletePanelwoRoster180717, clear
cap gen wgt = 1
local outcomes "hhexp asset_index homeown"
cap make_index family3 wgt `outcomes'

xtset ID Round
gen index_family3_pre = L.index_family3
eststo clear
eststo Reg`y': ivreg2 	index_family3 ITT index_family3_pre L.marrieddummy L.dep_ratio L.marrtreat BranchDummy* if Round==2, partial(L.marrieddummy L.dep_ratio L.marrtreat BranchDummy*) cluster(ID)
esttab using ImpFam3index.tex, b(%9.3f) se(%9.3f) ///
			label staraux star(* 0.1 ** 0.05 *** 0.01) replace width(7in) ///
			stats(N r2) nomtitles nonotes

eststo clear
/*NEED TO DO THIS FOR EACH FAMILY AND REGRESSIONS:
//first save a new excel with t and other p values saved in a column and then use that sheet as below:
q:
*/
preserve

clear
import excel "ImpFam3.xlsx", sheet("itt") cellrange(A1:A3)
rename A pval
save qimp3short, replace
do SharpenedQValues
save qimp3short, replace

restore

preserve

clear
import excel "ImpFam3.xlsx", sheet("other") cellrange(A1:A3)
rename A pval
save qimp3shortother, replace
do SharpenedQValues
save qimp3shortother, replace

restore
*/
set more off
foreach y in hhexp homeown asset_index{
		
		capture drop 	`y'_pre
		gen 			`y'_pre 	= L2.`y'
		
		eststo Reg`y': ivreg2 	`y' ITT `y'_pre L2.marrieddummy L2.dep_ratio L2.marrtreat BranchDummy* if Round==3, partial(L2.marrieddummy L2.dep_ratio L2.marrtreat BranchDummy*) cluster(ID)
			}
esttab using ImpFam3_long.tex, b(%9.3f) se(%9.3f) ///
			label staraux star(* 0.1 ** 0.05 *** 0.01) replace width(7in) ///
			stats(N r2) nomtitles nonotes
esttab using ImpFam3_long.csv, b(%9.3f) p ///
			label stats(N r2) nomtitles nonotes replace

eststo clear

set more off
foreach y in hhexp homeown asset_index{
		
		capture drop 	`y'_pre
		gen 			`y'_pre 	= L2.`y'
		
		eststo Reg`y': ivreg2 	`y' (business_started = ITT) `y'_pre L2.marrieddummy L2.dep_ratio L2.marrtreat BranchDummy* if Round==3, partial(L2.marrieddummy L2.dep_ratio L2.marrtreat BranchDummy*) cluster(ID)
			}
			
eststo clear

preserve
clear
import excel "ImpFam3_long.xlsx", sheet("itt") cellrange(A1:A3)
rename A pval
save qimp3short, replace
do SharpenedQValues
save qimp3short, replace
restore

preserve
clear
import excel "ImpFam3_long.xlsx", sheet("others") cellrange(A1:A3)
rename A pval
save qimp3shortother, replace
do SharpenedQValues
save qimp3shortother, replace
restore

*seperate exp items
gen food = BE11
gen nondurnonfood = BE12 + BE13 + BE14
gen medical = BE17
gen school = BE16
gen recreation = BE19
gen mobile = BE18
gen giftloans = BE113+BE114
gen savings = BE15

eststo clear
set more off
foreach y in food nondurnonfood medical school recreation mobile giftloans savings{
		
		capture drop 	`y'_pre
		gen 			`y'_pre 	= L.`y'
		
		eststo Reg`y': ivreg2 	`y' ITT `y'_pre L.marrieddummy L.dep_ratio L.marrtreat BranchDummy* if Round==2, partial(L.marrieddummy L.dep_ratio L.marrtreat BranchDummy*) cluster(ID)
			}
esttab using Impexpenses.tex, b(%9.3f) se(%9.3f) ///
			label staraux star(* 0.1 ** 0.05 *** 0.01) replace width(7in) ///
			stats(N r2) nomtitles nonotes
esttab using Impexpenses.csv, b(%9.3f) p ///
			label stats(N r2) nomtitles nonotes replace

eststo clear

set more off
foreach y in food nondurnonfood medical school recreation mobile giftloans savings{
		
		capture drop 	`y'_pre
		gen 			`y'_pre 	= L.`y'
		
		eststo Reg`y': ivreg2 	`y' (business_started = ITT) `y'_pre L.marrieddummy L.dep_ratio L.marrtreat BranchDummy* if Round==2, partial(L.marrieddummy L.dep_ratio L.marrtreat BranchDummy*) cluster(ID)
			}

			
eststo clear
set more off
foreach y in food nondurnonfood medical school recreation mobile giftloans savings{
		
		capture drop 	`y'_pre
		gen 			`y'_pre 	= L2.`y'
		
		eststo Reg`y': ivreg2 	`y' ITT `y'_pre L2.marrieddummy L2.dep_ratio L2.marrtreat BranchDummy* if Round==3, partial(L2.marrieddummy L2.dep_ratio L2.marrtreat BranchDummy*) cluster(ID)
			}
eststo clear

set more off
foreach y in food nondurnonfood medical school recreation mobile giftloans savings{
		
		capture drop 	`y'_pre
		gen 			`y'_pre 	= L2.`y'
		
		eststo Reg`y': ivreg2 	`y' (business_started = ITT) `y'_pre L2.marrieddummy L2.dep_ratio L2.marrtreat BranchDummy* if Round==3, partial(L2.marrieddummy L2.dep_ratio L2.marrtreat BranchDummy*) cluster(ID)
			}
eststo clear


* Family 4

eststo clear
set more off
foreach y in confident emp_index index_agency allowed_work{
		
		capture drop 	`y'_pre
		gen 			`y'_pre 	= L.`y'
		
		eststo Reg`y': ivreg2 	`y' ITT `y'_pre L.marrieddummy L.dep_ratio L.marrtreat BranchDummy* if Round==2, partial(L.marrieddummy L.dep_ratio L.marrtreat BranchDummy*) cluster(ID)
			}
esttab using ImpFam4.tex, b(%9.3f) se(%9.3f) ///
			label staraux star(* 0.1 ** 0.05 *** 0.01) replace width(7in) ///
			stats(N r2) nomtitles nonotes
esttab using ImpFam4.csv, b(%9.3f) p ///
			label stats(N r2) nomtitles nonotes replace

eststo clear

set more off
foreach y in confident emp_index index_agency allowed_work{
		
		capture drop 	`y'_pre
		gen 			`y'_pre 	= L.`y'
		
		eststo Reg`y': ivreg2 	`y' (business_started = ITT) `y'_pre L.marrieddummy L.dep_ratio L.marrtreat BranchDummy* if Round==2, partial(L.marrieddummy L.dep_ratio L.marrtreat BranchDummy*) cluster(ID)
			}

eststo clear

*making one index:
do make_index
use CompletePanelwoRoster180717, clear
cap gen wgt = 1
local outcomes "confident emp_index index_agency allowed_work"
cap make_index family4 wgt `outcomes'

xtset ID Round
gen index_family4_pre = L.index_family4
eststo clear
eststo Reg`y': ivreg2 	index_family4 ITT index_family4_pre L.marrieddummy L.dep_ratio L.marrtreat BranchDummy* if Round==2, partial(L.marrieddummy L.dep_ratio L.marrtreat BranchDummy*) cluster(ID)
esttab using ImpFam4index.tex, b(%9.3f) se(%9.3f) ///
			label staraux star(* 0.1 ** 0.05 *** 0.01) replace width(7in) ///
			stats(N r2) nomtitles nonotes

eststo clear


preserve
clear
import excel "ImpFam4.xlsx", sheet("itt") cellrange(A1:A4)
rename A pval
save qimp4short, replace
do SharpenedQValues
save qimp4short, replace
restore

preserve
clear
import excel "ImpFam4.xlsx", sheet("other") cellrange(A1:A4)
rename A pval
save qimp4shortother, replace
do SharpenedQValues
save qimp4shortother, replace
restore

set more off
foreach y in confident emp_index index_agency{
		
		capture drop 	`y'_pre
		gen 			`y'_pre 	= L2.`y'
		
		eststo Reg`y': ivreg2 	`y' ITT `y'_pre L2.marrieddummy L2.dep_ratio L2.marrtreat BranchDummy* if Round==3, partial(L2.marrieddummy L2.dep_ratio L2.marrtreat BranchDummy*) cluster(ID)
			}
esttab using ImpFam4_long.tex, b(%9.3f) se(%9.3f) ///
			label staraux star(* 0.1 ** 0.05 *** 0.01) replace width(7in) ///
			stats(N r2) nomtitles nonotes
esttab using ImpFam4_long.csv, b(%9.3f) p ///
			label stats(N r2) nomtitles nonotes replace

eststo clear

set more off
foreach y in confident emp_index index_agency{
		
		capture drop 	`y'_pre
		gen 			`y'_pre 	= L2.`y'
		
		eststo Reg`y': ivreg2 	`y' (business_started = ITT) `y'_pre L2.marrieddummy L2.dep_ratio L2.marrtreat BranchDummy* if Round==3, partial(L2.marrieddummy L2.dep_ratio L2.marrtreat BranchDummy*) cluster(ID)
			}
			
eststo clear

*emp decreases in ppl with other businesses in the househol
ivreg2 emp_index ITT otherentrep treatentrep L.emp_index L.marrieddummy L.dep_ratio L.homeown L.asset_index L.marrtreat BranchDummy* if Round==2, partial(L.marrieddummy L.dep_ratio L.homeown L.asset_index L.marrtreat BranchDummy*) cluster(ID)

preserve
clear
import excel "ImpFam4_long.xlsx", sheet("itt") cellrange(A1:A3)
rename A pval
save qimp4long, replace
do SharpenedQValues
save qimp4long, replace
restore

preserve
clear
import excel "ImpFam4_long.xlsx", sheet("other") cellrange(A1:A3)
rename A pval
save qimp4longother, replace
do SharpenedQValues
save qimp4longother, replace
restore


* Family 5
eststo clear

set more off
replace loans_lastyr = 0 if loans_lastyr == .

foreach y in bankacc loans_lastyr{
		
		capture drop 	`y'_pre
		gen 			`y'_pre 	= L.`y'
		
		eststo Reg`y': ivreg2 	`y' ITT `y'_pre L.marrieddummy L.dep_ratio BranchDummy* if Round==2, partial(L.marrieddummy L.dep_ratio BranchDummy*) cluster(ID)
			}
esttab using ImpFam5.tex, b(%9.3f) se(%9.3f) ///
			label staraux star(* 0.1 ** 0.05 *** 0.01) replace width(7in) ///
			stats(N r2) nomtitles nonotes
esttab using ImpFam5.csv, b(%9.3f) p ///
			label stats(N r2) nomtitles nonotes replace

eststo clear

*incidentaly, people also 10% more likely to start a business if theyv taken a loan but not random
ivreg2 business_started loans_lastyr L2.marrieddummy L2.dep_ratio BranchDummy* if Round==3, partial(L2.marrieddummy L2.dep_ratio BranchDummy*) cluster(ID)
*making one index:
do make_index
use CompletePanelwoRoster180717, clear
cap gen wgt = 1
replace loans_lastyr = 0 if loans_lastyr == .
local outcomes "bankacc loans_lastyr"
cap make_index family5 wgt `outcomes'


xtset ID Round
gen index_family5_pre = L.index_family5
eststo clear
eststo Reg`y': ivreg2 	index_family5 ITT index_family5_pre L.marrieddummy L.dep_ratio BranchDummy* if Round==2, partial(L.marrieddummy L.dep_ratio BranchDummy*) cluster(ID)
esttab using ImpFam5index.tex, b(%9.3f) se(%9.3f) ///
			label staraux star(* 0.1 ** 0.05 *** 0.01) replace width(7in) ///
			stats(N r2) nomtitles nonotes

eststo clear


preserve
clear
import excel "ImpFam5.xlsx", sheet("itt") cellrange(A1:A2)
rename A pval
save qimp5short, replace
do SharpenedQValues
save qimp5short, replace
restore

preserve
clear
import excel "ImpFam5.xlsx", sheet("other") cellrange(A1:A2)
rename A pval
save qimp5shortother, replace
do SharpenedQValues
save qimp5shortother, replace
restore


foreach y in bankacc loans_lastyr{
		
		capture drop 	`y'_pre
		gen 			`y'_pre 	= L2.`y'
		
		eststo Reg`y': ivreg2 	`y' ITT `y'_pre L2.marrieddummy L2.dep_ratio L2.marrtreat BranchDummy* if Round==3, partial(L2.marrieddummy L2.dep_ratio L2.marrtreat BranchDummy*) cluster(ID)
			}
esttab using ImpFam5_long.tex, b(%9.3f) se(%9.3f) ///
			label staraux star(* 0.1 ** 0.05 *** 0.01) replace width(7in) ///
			stats(N r2) nomtitles nonotes
esttab using ImpFam5_long.csv, b(%9.3f) p ///
			label stats(N r2) nomtitles nonotes replace

eststo clear
foreach y in insurance atm{
		
		capture drop 	`y'_pre
		gen 			`y'_pre 	= L1.`y'
		
		eststo Reg`y': ivreg2 	`y' ITT `y'_pre L2.marrieddummy L2.dep_ratio L2.marrtreat BranchDummy* if Round==3, partial(L2.marrieddummy L2.dep_ratio L2.marrtreat BranchDummy*) cluster(ID)
			}
esttab using ImpFam5_long2.tex, b(%9.3f) se(%9.3f) ///
			label staraux star(* 0.1 ** 0.05 *** 0.01) replace width(7in) ///
			stats(N r2) nomtitles nonotes
esttab using ImpFam5_long2.csv, b(%9.3f) p ///
			label stats(N r2) nomtitles nonotes replace

eststo clear


preserve
clear
import excel "ImpFam5_long.xlsx", sheet("itt") cellrange(A1:A4)
rename A pval
save qimp5long, replace
do SharpenedQValues
save qimp5long, replace
restore

preserve
clear
import excel "ImpFam5_long.xlsx", sheet("other") cellrange(A1:A4)
rename A pval
save qimp5longother, replace
do SharpenedQValues
save qimp5longother, replace
restore


*family 9: as a correlate or as an impact? no relationship either way:)
foreach y in pos_busoutlook pos_econoutlook planner eagerwork cautious competitive{

		eststo Reg`y': ivreg2 	`y' ITT L.marrieddummy L.dep_ratio L.marrtreat BranchDummy* if Round==2, partial(L.marrieddummy L.dep_ratio L1.marrtreat BranchDummy*) cluster(ID)
			}
esttab using ImpFam9.tex, b(%9.3f) se(%9.3f) ///
			label staraux star(* 0.1 ** 0.05 *** 0.01) replace width(7in) ///
			stats(N r2) nomtitles nonotes
esttab using ImpFam9.csv, b(%9.3f) p ///
			label stats(N r2) nomtitles nonotes replace

eststo clear
foreach y in pos_busoutlook pos_econoutlook planner eagerwork cautious competitive{

		eststo Reg`y': ivreg2 	`y' ITT L2.marrieddummy L2.dep_ratio L2.marrtreat BranchDummy* if Round==3, partial(L2.marrieddummy L2.dep_ratio L2.marrtreat BranchDummy*) cluster(ID)
			}
esttab using ImpFam9_long.tex, b(%9.3f) se(%9.3f) ///
			label staraux star(* 0.1 ** 0.05 *** 0.01) replace width(7in) ///
			stats(N r2) nomtitles nonotes
esttab using ImpFam9_long.csv, b(%9.3f) p ///
			label stats(N r2) nomtitles nonotes replace

eststo clear

********************************************************************************
******************						RQ4				************************
*******************************************************************************/

//Here I look at some other stats on who else has a business in the household. 
/*baseline and midline:
										****

use "/Users/farahsaid/Dropbox/Kashf_games/Analysis/CompletePanel220116_v12.dta", clear
sort ID SurveyRound
*in baseline, the relation to respondent was not coded correctly, often line numbers were written. So we have 
* the variable client for the female client. Unfortunately, this means we do not know relation at baseline. (not clean anyways)
bysort ID SurveyRound: gen entrep = (Occupation == 1 & client != 1 & SurveyRound == "Baseline") 
bysort ID SurveyRound: gen entrep_end = (Occupation == 1 & RelationRespondent != 1 & SurveyRound == "Endline") 
replace entrep = entrep_end if SurveyRound == "Endline"
bysort ID SurveyRound: egen hhentrep = total(entrep)

bysort ID SurveyRound: gen relation = RelationRespondent if RelationRespondent != 1 & SurveyRound == "Endline" & entrep == 1
bysort ID SurveyRound: egen bus_relation = mode(relation) if SurveyRound == "Endline"

tab relation

replace BusinessType = . if BusinessType == 0
gen PSBus = (BusinessType == 3 & client !=1 & SurveyRound == "Baseline") 
replace PSBus = 1 if (BusinessType == 3 & RelationRespondent !=1 & SurveyRound == "Endline") 

*Most common by far in those who answer
bysort ID SurveyRound: egen PSBus_hh = max(PSBus) 
bysort ID SurveyRound: egen PSBus_total = total(PSBus) 

replace PSBus_hh = 0 if hhentrep == 0
replace PSBus_total = 0 if hhentrep == 0

replace BusinessStartYear = . if BusinessStartYear == 1
replace BusinessStartYear = . if entrep != 1

gen busyears = 2015 - BusinessStartYear + 1 if RelationRespondent != 1 & SurveyRound == "Endline" & BusinessStartYear !=.
bysort ID SurveyRound: egen maxyrs = max(busyears)
bysort ID SurveyRound: egen minyrs = min(busyears)


tab a8 SurveyRound
replace a8 = "1" if a8 == "1 year"
replace a8 = "10" if a8 == "10 years"
replace a8 = "2" if a8 == "2 years"
replace a8 = "20" if a8 == "20 years"
replace a8 = "3" if a8 == "3 years"
replace a8 = "4" if a8 == "4 years"
replace a8 = "7" if a8 == "7 years"
replace a8 = "8" if a8 == "8 years"
destring a8, replace
replace a8 = . if entrep != 1

bysort ID SurveyRound: egen maxyrsbase = max(a8)
bysort ID SurveyRound: egen minyrsbase = min(a8)

replace busyears = a8 if busyears == . & SurveyRound == "Baseline"

keep ID hhentrep SurveyRound PSBus_hh PSBus_total busyears a8 minyrsbase maxyrsbase maxyrs minyrs relation bus_relation
duplicates drop ID SurveyRound,force

encode SurveyRound, gen(Round)
tsset ID Round
sort ID Round
*years of business: endline data more reliable than baseline where the enumerators messed up the answers
replace maxyrs = maxyrs[_n+1] if maxyrs == . & SurveyRound == "Baseline"
replace maxyrs = a8 if maxyrs == . & SurveyRound == "Baseline"
replace minyrs = minyrs[_n+1] if minyrs == . & SurveyRound == "Baseline"
replace minyrs = a8 if minyrs == . & SurveyRound == "Baseline"

save "/Users/farahsaid/Dropbox/kashf/RCT Analysis/hhentrep.dta", replace

*endline: using same questions as earlier round. In 2016 we also ask G1b but that gives
*different answers for bus of hh members and fewer businesses. SO i use section G for own bus details. 

use "/Users/farahsaid/Dropbox/kashf/RCT Analysis/Endline2015HHrosterReshapped.dta", clear
bysort ID SurveyRound: gen entrep = (Occupation == 1 & RelationRespondent != 1 & SurveyRound == "Endline") 
bysort ID SurveyRound: egen hhentrep = total(entrep)

replace BusinessType = . if BusinessType == 0
gen PSBus = 1 if (BusinessType == 3 & RelationRespondent !=1 & SurveyRound == "Endline") 

*Most common by far in those who answer - Personal business. 
bysort ID SurveyRound: egen PSBus_hh = max(PSBus) 
bysort ID SurveyRound: egen PSBus_total = total(PSBus) 

replace PSBus_hh = 0 if hhentrep == 0
replace PSBus_total = 0 if hhentrep == 0

replace BusinessStartYear = . if BusinessStartYear == 1
replace BusinessStartYear = . if entrep != 1
*the above is so that we dont record age for respondents business

gen busyears = 2015 - BusinessStartYear + 1 if RelationRespondent != 1 & SurveyRound == "Endline" & BusinessStartYear !=.
bysort ID SurveyRound: egen maxyrs = max(busyears)
bysort ID SurveyRound: egen minyrs = min(busyears)

bysort ID SurveyRound: gen relation = RelationRespondent if RelationRespondent != 1 & SurveyRound == "Endline" & entrep == 1
bysort ID SurveyRound: egen bus_relation = mode(relation) if SurveyRound == "Endline"

tab relation

keep ID hhentrep SurveyRound PSBus_hh PSBus_total busyears maxyrs minyrs relation bus_relation
duplicates drop ID,force

*no one left or joined hh so keep 2015 status quo
set obs `=_N+12'
replace ID = 25 in 619
replace ID = 53 in 620
replace ID = 123 in 621
replace ID = 127 in 622
replace ID = 154 in 623
replace ID = 186 in 624
replace ID = 187 in 625
replace ID = 247 in 626
replace ID = 255 in 627
replace ID = 285 in 628
replace ID = 308 in 629
replace ID = 346 in 630

replace SurveyRound = "Endline2016"
append using "/Users/farahsaid/Dropbox/kashf/RCT Analysis/hhentrep.dta"
drop if ID == .

foreach j in 25 53 123 127 154 186 187 247 255 285 308 346{
bysort ID: replace hhentrep = hhentrep[_n-1] if ID == `j' & SurveyRound == "Endline2016"
bysort ID: replace PSBus_hh = PSBus_hh[_n-1] if ID == `j' & SurveyRound == "Endline2016"
bysort ID: replace PSBus_total = PSBus_total[_n-1] if ID == `j' & SurveyRound == "Endline2016"
bysort ID: replace busyears = busyears[_n-1] if ID == `j' & SurveyRound == "Endline2016"
bysort ID: replace maxyrs = maxyrs[_n-1] if ID == `j' & SurveyRound == "Endline2016"
bysort ID: replace minyrs = minyrs[_n-1] if ID == `j' & SurveyRound == "Endline2016"
bysort ID: replace bus_relation = bus_relation[_n-1] if ID == `j' & SurveyRound == "Endline2016"
}

label var hhentrep  "Number of entreprenuers in the housheold, other than the respondent"
label var PSBus_hh  "One of the household member has a personal services business"
label var PSBus_total  "Total members of the household who have a personal services business"
label var maxyrs "(Maximum) Numbers of years since a business in the household has been open"
label var minyrs "(Minimum) Numbers of years since a business in the household has been open"
label var bus_relation "Relation of other enterprenuer in the household to the respondent"

save "/Users/farahsaid/Dropbox/kashf/RCT Analysis/hhentrep.dta", replace
drop Round

merge 1:1 ID SurveyRound using "/Users/farahsaid/Dropbox/kashf/RCT Analysis/CompletePanelwoRoster070717.dta", generate(_mergeOcc)
drop if _mergeOcc == 1
save CompletePanelwoRoster180717.dta, replace
										****
*/
********************************************************************************
***********					 OTHER HH BUSINESSES			********************										
********************************************************************************
use CompletePanelwoRoster180717.dta, clear

label var hhentrep  "Number of entreprenuers in the housheold, other than the respondent"
label var PSBus_hh  "One of the household member has a personal services business"
label var PSBus_total  "Total members of the household who have a personal services business"

//no treatment effect if you have other entrep/businesses in the household - few obs but could imply cannibalisation. 
//notice below, we get funds used for business but it is not clear if it is the respondents business. 
gen otherentrep = (hhentrep > 0)
label var otherentrep "Other household members have a business"
gen treatentrep = ITT*otherentrep
label var treatentrep "Respondent is in treatment group and other household members have a business"
replace bus_lastyear = 0 if bus_lastyear == . & SurveyRound == "Endline2016"

tab otherentrep SurveyRound
*age of other business (crude) given data entry issues in rosters and possible misunderstanding by enumerators at baseline:
*min - 97% of those who reported are at least a year old. Mediam is 7 years old.
tab minyrs if otherentrep == 1
su minyrs if otherentrep == 1, de
*max
tab maxyrs if otherentrep == 1
tab minyrs if SurveyRound == "Endline" & otherentrep ==1
tab minyrs if SurveyRound == "Endline2016" & otherentrep ==1

tab bus_relation if SurveyRound == "Endline" & otherentrep ==1
tab bus_relation if SurveyRound == "Endline2016" & otherentrep ==1
*v few responses in households where women are self empl but the ratio remains the same
tab bus_relation if SurveyRound == "Endline" & otherentrep ==1 & selfempl == 1, m
tab bus_relation if SurveyRound == "Endline2016" & otherentrep ==1 & selfempl == 1, m

*relationship (again a crude measure given taken from roster. Question incorrectly asked at baseline so we use midline
*gven the age of business, unlikely to have changed between baseline and midline and endline
*80% of other businesses owned by son/daughter, 17% by husband. 
tab PSBus_hh if otherentrep == 1 & SurveyRound == "Baseline"
*37% of other businesses are PS
tab PSBus_hh if otherentrep == 1 & SurveyRound == "Endline"
*41%
tab PSBus_hh if otherentrep == 1 & SurveyRound == "Endline2016"
*all of them?


*should check balance at baseline:
reg otherentrep treated if finalsample == 1 & Round == 1, r
*after labelling as in CreateVariables070717.do to F-value
reg treated sumvar* if finalsample == 1 & Round == 1, r
su otherentrep if Round == 1, de

foreach y in business_started bus_lastyear bus_shutlastyr{
			eststo Reg`y': ivreg2 	`y' ITT L.marrieddummy L.dep_ratio L.homeown L.asset_index L.marrtreat BranchDummy* if Round==2 & otherentrep == 1, partial(L.marrieddummy L.dep_ratio L.homeown L.asset_index L.marrtreat BranchDummy*) cluster(ID)
			}
			
			
foreach y in business_started bus_lastyear bus_shutlastyr{
			eststo Reg`y': ivreg2 	`y' ITT L2.marrieddummy L2.marrtreat L2.dep_ratio L2.homeown L2.asset_index BranchDummy* if Round==3 & otherentrep == 1, partial(L2.marrieddummy L2.marrtreat L2.dep_ratio L2.homeown L2.asset_index BranchDummy*) cluster(ID)
			}
esttab using ImpOtherEntrep2.tex, b(%9.3f) se(%9.3f) ///
			label staraux star(* 0.1 ** 0.05 *** 0.01) replace width(7in) ///
			stats(N r2) nomtitles nonotes

*as a correlate:
foreach y in business_started bus_lastyear bus_shutlastyr{
			eststo Reg`y': ivreg2 	`y' ITT otherentrep L.marrieddummy L.dep_ratio L.homeown L.asset_index L.marrtreat BranchDummy* if Round==2, partial(L.marrieddummy L.dep_ratio L.homeown L.asset_index L.marrtreat BranchDummy*) cluster(ID)
			}
esttab using ImpOtherEntrep3.tex, b(%9.3f) se(%9.3f) ///
			label staraux star(* 0.1 ** 0.05 *** 0.01) replace width(7in) ///
			stats(N r2) nomtitles nonotes
*as an explanatory var			
foreach y in business_started bus_lastyear bus_shutlastyr{
			eststo Reg`y': ivreg2 	`y' ITT otherentrep treatentrep L.marrieddummy L.dep_ratio L.homeown L.asset_index L.marrtreat BranchDummy* if Round==2, partial(L.marrieddummy L.dep_ratio L.homeown L.asset_index L.marrtreat BranchDummy*) cluster(ID)
			}
esttab using ImpOtherEntrep.tex, b(%9.3f) se(%9.3f) ///
			label staraux star(* 0.1 ** 0.05 *** 0.01) replace width(7in) ///
			stats(N r2) nomtitles nonotes

			
replace bus_lastyear = 0 if bus_lastyear == . & SurveyRound == "Endline2016"
			
foreach y in business_started bus_lastyear bus_shutlastyr{
			eststo Reg`y': ivreg2 	`y' ITT otherentrep treatentrep L2.marrieddummy L2.marrtreat L2.dep_ratio L2.homeown L2.asset_index BranchDummy* if Round==3, partial(L2.marrieddummy L2.marrtreat L2.dep_ratio L2.homeown L2.asset_index BranchDummy*) cluster(ID)
			}
esttab using ImpOtherEntrep2.tex, b(%9.3f) se(%9.3f) ///
			label staraux star(* 0.1 ** 0.05 *** 0.01) replace width(7in) ///
			stats(N r2) nomtitles nonotes

*controlling for baseline business
foreach y in business_started bus_lastyear bus_shutlastyr{
			eststo Reg`y': ivreg2 	`y' ITT L.otherentrep L.marrieddummy L.dep_ratio L.homeown L.asset_index L.marrtreat BranchDummy* if Round==2, partial(L.marrieddummy L.dep_ratio L.homeown L.asset_index L.marrtreat BranchDummy*) cluster(ID)
			}
			

*effect of husbands business
xtset ID Round
gen bus_byhusb = otherentrep if bus_relation == 2	
replace bus_byhusb = 0 if bus_relation > 2 & otherentrep!=.		
foreach y in business_started bus_shutlastyr{
			eststo Reg`y': ivreg2 	`y' ITT bus_byhusb  L.dep_ratio L.homeown L.asset_index  BranchDummy* if Round==2, partial( L.dep_ratio L.homeown L.asset_index BranchDummy*) cluster(ID)
			}
*esttab using ImpOtherEntrep4.tex, b(%9.3f) se(%9.3f) ///
*			label staraux star(* 0.1 ** 0.05 *** 0.01) replace width(7in) ///
*			stats(N r2) nomtitles nonotes
			
eststo clear
gen bus_husbtreat = bus_byhusb*ITT
*no variation in bus_bychild and otherenterp really so qualitatvely similar results but with funky f and covariance var issues. 
*as an explanatory var			
foreach y in business_started bus_shutlastyr{
			eststo Reg`y': ivreg2 	`y' ITT bus_byhusb bus_husbtreat L.dep_ratio L.homeown L.asset_index BranchDummy* if Round==2, partial(L.dep_ratio L.homeown L.asset_index BranchDummy*) cluster(ID)
			}
esttab using ImpOtherEntrephusb.tex, b(%9.3f) se(%9.3f) ///
			label staraux star(* 0.1 ** 0.05 *** 0.01) replace width(7in) ///
			stats(N r2) nomtitles nonotes

eststo clear

foreach y in business_started bus_lastyear bus_shutlastyr{
			eststo Reg`y': ivreg2 	`y' ITT bus_byhusb bus_husbtreat L2.dep_ratio L2.homeown L2.asset_index BranchDummy* if Round==3, partial(L2.dep_ratio L2.homeown L2.asset_index BranchDummy*) cluster(ID)
			}
esttab using ImpOtherEntrephusb_lr.tex, b(%9.3f) se(%9.3f) ///
			label staraux star(* 0.1 ** 0.05 *** 0.01) replace width(7in) ///
			stats(N r2) nomtitles nonotes
*graph of bus_relation:
*midline

preserve

keep 	if SurveyRound == "Endline"

gen 	Relation 	= ""

replace Relation 	= "Husband" 				if bus_relation == 2
replace Relation 	= "Son or daughter"			if bus_relation == 3
replace Relation 	= "Son or daughter-in-law"	if bus_relation == 4
replace Relation 	= "Grandchildren"		 	if bus_relation == 5
replace Relation 	= "Father" 					if bus_relation == 6
replace Relation 	= "Mother" 					if bus_relation == 7
replace Relation 	= "Father-in-law" 			if bus_relation == 8
replace Relation 	= "Mother-in-law" 			if bus_relation == 9
replace Relation 	= "Brother or sister" 		if bus_relation == 10
replace Relation 	= "Brother or sister-in-law" if bus_relation == 11
replace Relation 	= "Other" 					if bus_relation == 12
replace Relation 	= "Not related" 			if bus_relation == 13

tab 	Relation selfempl

gen 	MyOne = 1

collapse (sum) MyOne, by(Relation)

egen MyOneSum 	= sum(MyOne) 	if Relation != ""
replace MyOne 	= MyOne / MyOneSum * 100

graph bar MyOne, over(Relation, sort(1) descending) horiz ytitle("Proportion of responses (%)") bar(1, color(navy)) ylabel(0(10)100)

graph export BarRelation15.png, replace width(1600)

restore

*endline

preserve

keep 	if SurveyRound == "Endline2016"

gen 	Relation 	= ""

replace Relation 	= "Husband" 				if bus_relation == 2
replace Relation 	= "Son or daughter"			if bus_relation == 3
replace Relation 	= "Son or daughter-in-law"	if bus_relation == 4
replace Relation 	= "Grandchildren"		 	if bus_relation == 5
replace Relation 	= "Father" 					if bus_relation == 6
replace Relation 	= "Mother" 					if bus_relation == 7
replace Relation 	= "Father-in-law" 			if bus_relation == 8
replace Relation 	= "Mother-in-law" 			if bus_relation == 9
replace Relation 	= "Brother or sister" 		if bus_relation == 10
replace Relation 	= "Brother or sister-in-law" if bus_relation == 11
replace Relation 	= "Other" 					if bus_relation == 12
replace Relation 	= "Not related" 			if bus_relation == 13

tab 	Relation selfempl

gen 	MyOne = 1

collapse (sum) MyOne, by(Relation)

egen MyOneSum 	= sum(MyOne) 	if Relation != ""
replace MyOne 	= MyOne / MyOneSum * 100

graph bar MyOne, over(Relation, sort(1) descending) horiz ytitle("Proportion of responses (%)") bar(1, color(navy)) ylabel(0(10)100)

graph export BarRelation16.png, replace width(1600)

restore
			
********************************************************************************
***********					RESP EXISTING BUSINESS			********************
*IM NOT SURE ABOUT THIS. REVISIT LATER IS NEEDED.			
*THE ARGUMENT IS THAT SELF EMPLOYED WAS BALANCED AT BASELINE, SO DONT NEED TO 
*CHECK FOR THIS. 							
/********************************************************************************
use CompletePanelwoRoster180717.dta, clear
xtset ID Round
gen busatbase = (years_opened >1.25 & years_opened != . & Round == 2)
replace busatbase = 1 if (years_opened > 2.25 &years_opened !=. & Round == 3) 
replace busatbase = . if Round == 1
replace busatbase = . if busatbase > 40

tab busatbase SurveyRound
//this should give the same answer for endline and midline. Cant have 125 ppl say they had
//a business at bseline but only 46 at endline
tab business_started busatbase
//no business at base when business started. Therefore this variable wont explain anything. 
foreach y in business_started bus_lastyear bus_shutlastyr{
			eststo Reg`y': ivreg2 	`y' ITT busatbase L.marrieddummy L.dep_ratio L.homeown L.asset_index L.marrtreat BranchDummy* if Round==2, partial(L.marrieddummy L.dep_ratio L.homeown L.asset_index L.marrtreat BranchDummy*) cluster(ID)
			}

			
gen treatbusatbase = ITT*busatbase
eststo clear
foreach y in business_started bus_lastyear bus_shutlastyr{
			eststo Reg`y': ivreg2 	`y' ITT busatbase treatbusatbase L.marrieddummy L.dep_ratio L.homeown L.asset_index L.marrtreat BranchDummy* if Round==2, partial(L.marrieddummy L.dep_ratio L.homeown L.asset_index L.marrtreat BranchDummy*) cluster(ID)
			}
foreach y in business_started bus_lastyear bus_shutlastyr{
			eststo Reg2`y': ivreg2 	`y' ITT busatbase treatbusatbase L2.marrieddummy L2.marrtreat L2.dep_ratio L2.homeown L2.asset_index BranchDummy* if Round==3, partial(L2.marrieddummy L2.marrtreat L2.dep_ratio L2.homeown L2.asset_index BranchDummy*) cluster(ID)
			}
*esttab using correxistbus.tex, b(%9.3f) se(%9.3f) ///
*			label staraux star(* 0.1 ** 0.05 *** 0.01) replace width(7in) ///
*			stats(N r2) nomtitles nonotes
			
eststo clear
			
tab selfempl busatbase if Round == 3
tab selfempl busatbase if Round == 2
// here though, 46 ppl are self emp and had a business at baseline in r3 and 125 in r2.

*we could have only those who were selfemployed at baseline: Cleaner measure but this
*is balanced at baseline so not needed. 
gen treatselfempl = ITT*selfempl
			
foreach y in business_started bus_lastyear bus_shutlastyr{
			eststo Reg`y': ivreg2 	`y' ITT L1.selfempl L1.treatselfempl L.marrieddummy L.dep_ratio L.homeown L.asset_index L.marrtreat BranchDummy* if Round==2, partial(L.marrieddummy L.dep_ratio L.homeown L.asset_index L.marrtreat BranchDummy*) cluster(ID)
			}
foreach y in business_started bus_lastyear bus_shutlastyr{
			eststo Reg2`y': ivreg2 	`y' ITT L2.selfempl L2.treatselfempl L2.marrieddummy L2.marrtreat L2.dep_ratio L2.homeown L2.asset_index BranchDummy* if Round==3, partial(L2.marrieddummy L2.marrtreat L2.dep_ratio L2.homeown L2.asset_index BranchDummy*) cluster(ID)
			}
esttab using correxistbus.tex, b(%9.3f) se(%9.3f) ///
			label staraux star(* 0.1 ** 0.05 *** 0.01) replace width(7in) ///
			stats(N r2) nomtitles nonotes
eststo clear

*/
********************************************************************************
***********					 RESP BUSINESS TYPE				********************										
********************************************************************************
use CompletePanelwoRoster180717.dta, clear			

tab  BusinessType business_started if Round == 2, m
tab  business_started if Round == 2, m
tab  g3_1 business_started if Round == 3
tab  business_started if Round == 3, m

replace BusinessType = g3_1 if Round == 3
tab  BusinessType SurveyRound if business_started == 1

keep 	if business_started == 1

gen 	NewBusinessType 	= ""

replace NewBusinessType 	= "Agriculture/livestock" 								if BusinessType == 1
replace NewBusinessType 	= "Personal services - beauty parlor"					if BusinessType == 3
replace NewBusinessType 	= "Personal services - stitching, embroidery, knitting" if BusinessType == 4
replace NewBusinessType 	= "Personal services - handicrafts"		 				if BusinessType == 5
replace NewBusinessType 	= "Food vendor" 										if BusinessType == 7
replace NewBusinessType 	= "Other" 												if BusinessType == 9 |BusinessType == 14 | BusinessType == 17

gen 	MyOne = 1

collapse (sum) MyOne, by(NewBusinessType)

egen MyOneSum 	= sum(MyOne) 	if NewBusinessType != ""
replace MyOne 	= MyOne / MyOneSum * 100

graph bar MyOne, over(NewBusinessType, sort(1) descending) horiz ytitle("Proportion(%) of respondents") bar(1, color(navy)) ylabel(0(10)50)

graph export BarNewBusinessType.png, replace width(1600)


********************************************************************************
***********				WHY DID NOT SET UP BUSINESS			********************										
********************************************************************************
use CompletePanelwoRoster180717.dta, clear
gen thoughtaboutsetting = (KA == 1) //only midline
gen reasonnotset = KB if thoughtaboutsetting == 1
tab reasonnotset

********************************************************************************
***********					ROLE IN BUSINESS			********************										
********************************************************************************
use CompletePanelwoRoster180717.dta, clear
//overwhelmingly owner
tab g4a_1 SurveyRound
tab g4a_2 SurveyRound
tab G41 SurveyRound
tab G42 SurveyRound

gen owner = (g4a_1 == 1)
replace owner = 1 if g4a_2 == 1
replace owner = 1 if (G41 == 1 | G42 == 1 | G43 == 1 | G44 == 1 | G45 == 1)
replace owner = . if selfempl == 0
replace owner = . if SurveyRound == "Baseline"

tab owner SurveyRound
tab owner selfempl
tab selfempl SurveyRound

//Owner: Evertime at endline and 88% at midline: di 178/201

********************************************************************************
**** 								LEE BOUNDS								****
********************************************************************************


/*
use CompletePanelwoRoster070717, clear

preserve 
keep if Round == 1
replace Round = 2
keep ID Round finalsample
save R2, replace
restore

use CompletePanelwoRoster070717, clear

preserve 
keep if Round == 1
replace Round = 3
keep ID Round finalsample
save R3, replace
restore
*/
use CompletePanelwoRoster070717, clear
merge 1:1 ID Round using "/Users/farahsaid/Dropbox/kashf/RCT Analysis/R2.dta", generate(_mergeR2)
merge 1:1 ID Round using "/Users/farahsaid/Dropbox/kashf/RCT Analysis/R3.dta", generate(_mergeR3)

sort ID Round
bysort ID: replace ITT = ITT[_n-1] if ITT == . & Round == 2
label 	var 	marrtreat "Dummy: Respondent is currently married and in the treatment sample"
label 	var 	ITT 	  "Treatment"
foreach y in hhexp homeown asset_index bankacc loans_lastyr confident emp_index index_agency allowed_work marrieddummy dep_ratio marrtreat{
		gen 			`y'_pre 	= L.`y'
}

eststo clear
foreach y in business_started bus_shutlastyr{
			eststo Reg`y': reg `y' ITT marrieddummy_pre dep_ratio_pre marrtreat_pre BranchDummy* if Round == 2, r cluster(ID)
			eststo Reglb`y': leebounds `y' ITT marrieddummy_pre dep_ratio_pre marrtreat_pre BranchDummy* if Round == 2, sel(finalsample) vce(bootstrap, reps(100))
			}
			
			 hhexp homeown asset_index bankacc loans_lastyr confident emp_index index_agency allowed_work
`y' ITT `y'_pre marrieddummy_pre dep_ratio_pre marrtreat_pre BranchDummy*


esttab using lee.csv, b(%9.3f) se(%9.3f) ///
			label staraux star(* 0.1 ** 0.05 *** 0.01) replace width(9in) ///
			stats(N r2 ) nomtitles nonotes compress


bysort ID: replace ITT = ITT[_n-1] if ITT == . & Round == 3

eststo clear
foreach y in business_started bus_shutlastyr hhexp homeown asset_index bankacc loans_lastyr confident emp_index index_agency {
			eststo Reg`y': reg `y' ITT if Round == 3, r cluster(ID)
			eststo Reglb`y': leebounds `y' ITT if Round == 3, sel(finalsample) vce(bootstrap, reps(100))
			}

esttab using lee2.csv, b(%9.3f) se(%9.3f) ///
			label staraux star(* 0.1 ** 0.05 *** 0.01) replace width(9in) ///
			stats(N r2 ) nomtitles nonotes compress

			
********************************************************************************
**** 						EFFECT OF ADOPTION								****
********************************************************************************
*NO SR IMPACT OF ADOPTION IN THE RESULTS BELOW: 

use CompletePanelwoRoster180717, clear
xtset ID Round
replace loans_lastyr = 0 if loans_lastyr == .

set more off 

eststo clear
*effect of starting business, using itt as iv
foreach y in hhexp homeown asset_index bankacc loans_lastyr confident emp_index index_agency allowed_work{
		
		capture drop 	`y'_pre
		gen 			`y'_pre 	= L.`y'
		
		eststo Reg`y': ivreg2 	`y' (business_started = ITT) `y'_pre L.marrieddummy L.dep_ratio L.marrtreat BranchDummy* if Round==2, partial(L.marrieddummy L.dep_ratio L.marrtreat BranchDummy*) cluster(ID)
			}

esttab using Impadopt1.tex, b(%9.3f) se(%9.3f) ///
			label staraux star(* 0.1 ** 0.05 *** 0.01) replace width(7in) ///
			stats(N r2) nomtitles nonotes

*impact by loan use for business:
use CompletePanelwoRoster180717, clear
xtset ID Round
replace loans_lastyr = 0 if loans_lastyr == .

foreach x in a b c d e f g h i j k l m n o p q r s t u{
recode I2`x' 9999=. 1=. 2=. 3=. 4=. 5=. .=0 if SurveyRound == "Endline"
}

foreach x in a b c d e f g h i j k l m n o p q r s t u{
gen I2prop`x' = (I2`x'/I1Total) if SurveyRound == "Endline"
}
replace I2props = 1 if I2props>1
replace I2propu = 1 if I2propu>1

*keep 	if SurveyRound == "Endline"

replace I1Total = . if I1Total == 9999 & SurveyRound == "Endline"

foreach x in a b c d e f g h i j k l m n o p q r s t u{
recode I2prop`x' .=0 if I1Total !=. & SurveyRound == "Endline"
}
egen largestuse = rowmax(I2propa-I2propu) if I1Total !=. & SurveyRound == "Endline"

gen which_max = "" 

foreach x in a b c d e f g h i j k l m n o p q r s t u{
	replace which_max = "`x'"  if I2prop`x' == largestuse & largestuse!=. & SurveyRound == "Endline"
	}
replace which_max = "" if largestuse == . & SurveyRound == "Endline"
tab which_max largestuse

gen 	BusLoan 	= 1 if which_max =="r"| which_max== "s"|which_max == "t" 
replace 	BusLoan 	= 0 if BusLoan == . & which_max != "" & SurveyRound == "Endline"
replace 	BusLoan 	= 0 if BusLoan == . & ITT == 0 & SurveyRound == "Endline"
*coding control to be 0. 


set more off 

eststo clear
foreach y in hhexp homeown asset_index bankacc loans_lastyr confident emp_index index_agency allowed_work{
		
		capture drop 	`y'_pre
		gen 			`y'_pre 	= L.`y'
		
		eststo Reg`y': ivreg2 	`y' (BusLoan = ITT) `y'_pre L.marrieddummy L.dep_ratio L.marrtreat BranchDummy* if Round==2, partial(L.marrieddummy L.dep_ratio L.marrtreat BranchDummy*) cluster(ID)
			}

esttab using Impadopt2.tex, b(%9.3f) se(%9.3f) ///
			label staraux star(* 0.1 ** 0.05 *** 0.01) replace width(7in) ///
			stats(N r2) nomtitles nonotes


********************************************************************************
**** 					SOME BUSINESS NO. FOR SEC 3							****
********************************************************************************
use CompletePanelwoRoster070717, clear

			
tab business_started if Round == 2
tab business_started if Round == 2 & treated == 1
tab business_started if Round == 2 & treated == 0
tab bus_shutlastyr
tab bus_shutlastyr if Round == 2 & business_started !=1
tab bus_shutlastyr if Round == 2 & treated == 0
tab bus_shutlastyr if Round == 2 & treated == 0 & business_started == 1
tab KA
tab KA if Round == 2 
tab category if Round == 2 & KA == 1
tab category Round
di 60/328
tab KA business_started
tab category if business_started == 0 & Round == 2 & KA == 1
di 56/328
tab KB if business_started == 0 & Round == 2 & KA == 1 & ///
category == "Treatment Group"

tab business_started if Round == 2 & treated == 1
tab business_started if Round == 2
tab business_started if Round == 2 & treated == 1
tab business_started g10 if Round == 2 
tab g10 if Round == 2 
tab G10
tab G10 if business_started == 1 & Round == 2
tab business_started if Round == 3
tab business_started if Round == 3 & treated == 1
tab bus_lastyear if Round == 3 & treated == 1
tab G21 if business_started == 1
tab KA if Round == 2 & business_started == 0
tab KA if Round == 2 & business_started == 0 & treated == 1
tab KB if Round == 2 & business_started == 0 & treated == 1

tab KB if KA == 1
tab KB if KA == 1 & ITT == 1
tab KB if KA == 1 & ITT == 0


********************************************************************************
**** 							MDE for impact								****
********************************************************************************

*using the df as per the f-test in ivreg2
*according to MHE (Angrist and Pischke, ivreg2 has the correct F-stat dof
*"ivreg2 gets this right for you (thanks to Jenny Hunt for pointing out this discrepancy and to Mark Schaffer from the ivreg team for resolving it)".
*difference in only the 4rth decimal place if i use n - k

sum business_started bus_shutlastyr  if Round==2

*in the ivreg2, have df = 629
gen mde_business_started = (invt(629, 1 - (0.05 / 2)) + invt(629, 0.8))* ///
(0.3105468/((630*0.52*(1-0.52))^0.5))
*.0694884
gen mde_bus_shutlastyr = (invt(629, 1 - (0.05 / 2)) + invt(629, 0.8))* ///
(0.2848094/((630*0.52*(1-0.52))^0.5))
*.0637293

sum business_started bus_lastyear bus_shutlastyr  if Round==3

gen mde_business_started_lr = (invt(629, 1 - (0.05 / 2)) + invt(629, 0.8))* ///
(0.2440397 /((630*0.52*(1-0.52))^0.5))
*.0546067
gen mde_bus_lastyear_lr = (invt(629, 1 - (0.05 / 2)) + invt(629, 0.8))* ///
(0.2062442 /((630*0.52*(1-0.52))^0.5))
*.0461495 
gen mde_bus_shutlastyr_lr = (invt(617, 1 - (0.05 / 2)) + invt(617, 0.8))* ///
(0.1489175/((618*0.52*(1-0.52))^0.5))
*.03364496 


sum hhexp homeown asset_index bankacc loans_lastyr confident emp_index ///
index_agency allowed_work if Round == 2

gen mde_hhexp = (invt(629, 1 - (0.05 / 2)) + invt(629, 0.8))* ///
(6778.985/((630*0.52*(1-0.52))^0.5))
*1516.875

gen mde_homeown = (invt(629, 1 - (0.05 / 2)) + invt(629, 0.8))* ///
(.4338144 /((630*0.52*(1-0.52))^0.5))
*.0970709

gen mde_asset_index = (invt(629, 1 - (0.05 / 2)) + invt(629, 0.8))* ///
(1.607025/((630*0.52*(1-0.52))^0.5))
*.3595901

gen mde_bankacc = (invt(629, 1 - (0.05 / 2)) + invt(629, 0.8))* ///
(.4988189/((630*0.52*(1-0.52))^0.5))
* .1116164

gen mde_loans_lastyr = (invt(629, 1 - (0.05 / 2)) + invt(629, 0.8))* ///
(.4688952 /((630*0.52*(1-0.52))^0.5))
*.1049206

gen mde_confident = (invt(629, 1 - (0.05 / 2)) + invt(629, 0.8))* ///
(.5001185/((630*0.52*(1-0.52))^0.5))
*.1119072

gen mde_emp_index = (invt(629, 1 - (0.05 / 2)) + invt(629, 0.8))* ///
(2.108127/((630*0.52*(1-0.52))^0.5))
*.4717174

gen mde_index_agency = (invt(629, 1 - (0.05 / 2)) + invt(629, 0.8))* ///
(.9477724/((630*0.52*(1-0.52))^0.5))
*.2120749

gen mde_allowed_work = (invt(629, 1 - (0.05 / 2)) + invt(629, 0.8))* ///
(.3627215/((630*0.52*(1-0.52))^0.5))
*.0811631

sum hhexp homeown asset_index bankacc loans_lastyr insurance atm confident emp_index ///
index_agency  if Round == 3

gen mde_hhexp_lr = (invt(629, 1 - (0.05 / 2)) + invt(629, 0.8))* ///
(9253.315/((630*0.52*(1-0.52))^0.5))
*2070.5347

gen mde_homeown_lr = (invt(629, 1 - (0.05 / 2)) + invt(629, 0.8))* ///
(.4128461/((630*0.52*(1-0.52))^0.5))
*.09237902

gen mde_asset_index_lr = (invt(629, 1 - (0.05 / 2)) + invt(629, 0.8))* ///
(1.971693/((630*0.52*(1-0.52))^0.5))
*.44118875

gen mde_bankacc_lr = (invt(629, 1 - (0.05 / 2)) + invt(629, 0.8))* ///
(.499668/((630*0.52*(1-0.52))^0.5))
*.11180641

gen mde_loans_lastyr_lr = (invt(629, 1 - (0.05 / 2)) + invt(629, 0.8))* ///
(.3701079 /((630*0.52*(1-0.52))^0.5))
*.08281586

gen mde_insurance_lr = (invt(629, 1 - (0.05 / 2)) + invt(629, 0.8))* ///
(.3979152/((630*0.52*(1-0.52))^0.5))
*.08903806

gen mde_atm_lr = (invt(629, 1 - (0.05 / 2)) + invt(629, 0.8))* ///
(.3865956 /((630*0.52*(1-0.52))^0.5))
*.08650517

gen mde_confident_lr = (invt(629, 1 - (0.05 / 2)) + invt(629, 0.8))* ///
(.492714/((630*0.52*(1-0.52))^0.5))
*.11025037

gen mde_emp_index_lr = (invt(629, 1 - (0.05 / 2)) + invt(629, 0.8))* ///
(2.499043/((630*0.52*(1-0.52))^0.5))
*.55918932

gen mde_index_agency_lr = (invt(629, 1 - (0.05 / 2)) + invt(629, 0.8))* ///
(1.147565/((630*0.52*(1-0.52))^0.5))
*.25678074



exit
