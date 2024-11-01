
*Defining Intervention & Control LOCs; 
*Defining Hills for ethnicity wise analysis as and when applicable

GET 
  FILE='E:\AMS_Work\MeghaLamp\Meghalamp HH3.sav'.

IF (189>LOC) AND (LOC>100) IC=1.
IF (289>LOC) AND (LOC>200) IC=2.
EXECUTE.

RECODE LOC (101 thru 139=1) (140 thru 161=2) (162 thru 188=3) (201 thru 239=1) (240 thru 261=2) (262 thru 288=3) INTO Hills.
EXECUTE.
FREQUENCIES Hills.
VALUE LABELS Hills 1 'Garo hills' 2 'Jaintia hills' 3 'Khasi hills'.
EXECUTE.

*@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@   Socio-economic Profile of HHs  @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

*Demographic Details

CTABLES
/TABLE Q111+Q18+Q112 BY IC [COUNT COLPCT.COUNT]
/CATEGORIES VARIABLES=Q111 Q18 Q112 TOTAL=YES
/TITLES TITLE="Socio-economic Categories Vs IC".CTABLES 
/VLABELS VARIABLES=Q111 Members IC DISPLAY=LABEL 
/TABLE Q111 > Members [S][MEAN] BY IC [C] 
/CATEGORIES VARIABLES=Q111 IC ORDER=A KEY=VALUE EMPTY=EXCLUDE.


        *Calculation of No. of members in each household

GET 
  FILE='E:\AMS_Work\MeghaLamp\Meghalamp-HHR.sav'. 

COMPUTE UID=(LOC*100+SN).
EXECUTE.

TABLES
  /FORMAT BLANK MISSING('.')
  /OBSERVATION= SN
  /GBASE=CASES
  /TABLE=UID BY SN
  /STATISTICS
  Sum( SN)
  Validn( SN( NEQUAL5.0 )).

GET 
  FILE='E:\AMS_Work\MeghaLamp\Meghalamp HH3.sav'.
COMPUTE UID=(LOC*100+SN).
EXECUTE.


*Recoding of education and age variables


GET 
  FILE='E:\AMS_Work\MeghaLamp\Meghalamp-HHR.sav'.

RECODE C5 (0 thru 5=1) (6 thru 14=2) (15 thru 19=3) (20 thru 29=4) (30 thru 39=5) (40 thru 49=6) (50 thru 59=7) (60 thru 69=8) (70 thru 85=9) INTO AgeCat1.
EXECUTE.

RECODE C6 (1 thru 4=1) (5 thru 9=2) (10 thru 12=3) (13=4) (14=5) (15 thru 16=6) INTO EduCat1.
EXECUTE.

*3A Demographic Profile of the Population Covered

CTABLES
/TABLE C4+AgeCat1+EduCat1+C8+C9 BY IC [COUNT, COLPCT.COUNT]
/CATEGORIES VARIABLES=C4 AgeCat1 EduCat1 C8 C9 TOTAL=YES
/TITLES TITLE="Demographic Details Vs IC".



*3B Housing and other amenities

GET 
  FILE='E:\AMS_Work\MeghaLamp\Meghalamp HH3.sav'. 

CTABLES 
/TABLE Q31 BY IC [COUNT COLPCT.COUNT]
/CATEGORIES VARIABLES=IC TOTAL=YES
/TITLES TITLE="Distribution of Households in Intervention & Control area by Type of House".


CTABLES
/TABLE Q111 BY IC > Q31 [COUNT ROWPCT.COUNT]
/CATEGORIES VARIABLES=Q111 IC TOTAL=YES
/TITLES TITLE= "Distribution by Social Category ".


        *Export HHead's Educat1 from HHR to HH- Manually using Excel file

*Distribution by Education Category

CTABLES
/TABLE HHead_Edu BY IC > Q31 [COUNT ROWPCT.COUNT]
/CATEGORIES VARIABLES=HHead_Edu IC TOTAL=YES
/TITLES TITLE= "Distribution by HH Head Education ".

*Electricity Connection

CTABLES
/TABLE Q111+HHead_Edu BY IC > Q35 [COUNT ROWPCT.COUNT]
/CATEGORIES VARIABLES=Q111 TOTAL=YES
/TITLES TITLE= "Electricity Distribution by Social Category and HH Head Education".


*Toilet availability and usage

CTABLES
/TABLE Q36+Q361 BY IC [COUNT COLPCT.COUNT]
/CATEGORIES VARIABLES=IC TOTAL=YES
/TITLES TITLE= "Toilet availability and usage".

CTABLES
/TABLE Q111+HHead_Edu BY IC > (Q36+Q361) [COUNT ROWPCT.COUNT]
/CATEGORIES VARIABLES=IC TOTAL=YES
/TITLES TITLE= "Toilet availability and usage by social category and education status of HH Head".

*Primary source of drinking water

CTABLES
/TABLE Q37 BY IC  [COUNT COLPCT.COUNT]
/CATEGORIES VARIABLES=IC TOTAL=YES
/TITLES TITLE= "Primary source of drinking water".

CTABLES
/TABLE Q111+HHead_Edu BY IC > Q37  [COUNT ROWPCT.COUNT]
/CATEGORIES VARIABLES=Q111 TOTAL=YES
/TITLES TITLE= "Source of drinking water by social category and education status of HH Head".


*4. Livelihood Assets Portfolio


IF (Q211A=2) Landholding1=Q211B.
IF (Q211A=1) Landholding1=Q211B/43560.

IF (Q211AA=2) Landholding2=Q211AB.
IF (Q211AA=1) Landholding2=Q211AB/43560.

IF (Q211BA=2) Landholding3=Q211BB.
IF (Q211BA=1) Landholding3=Q211BB/43560.

IF (Q212A=2) Landholding4=Q212B.
IF (Q212A=1) Landholding4=Q212B/43560.

IF (Q213A=2) Landholding5=Q213B.
IF (Q213A=1) Landholding5=Q213B/43560.
EXECUTE.

        *Land ownership

GET 
  FILE='E:\AMS_Work\MeghaLamp\Meghalamp HH3.sav'. 

COMPUTE OUTCOME=2.
IF (Q211B>0) OUTCOME=1.
VARIABLE LABELS OUTCOME "Ownership of Land".
VALUE LABELS OUTCOME 1 "Yes" 2 "No".
COMPUTE OUTCOME1=2.
IF (Q211AB>0) OUTCOME1=1.
VARIABLE LABELS OUTCOME1 "Ownership of Irrigated Land".
VALUE LABELS OUTCOME1 1 "Yes" 2 "No".
CTABLES
 /TABLE Q111 [ ROWPCT.TOTALN  COUNT]  BY IC > (OUTCOME + OUTCOME1)
 /CATEGORIES VARIABLES=Q111 TOTAL=YES
 /TITLE TITLE="Table: Social Category Vs Total land owned".
NEW FILE.


CTABLES
 /TABLE Q111 BY IC > (Landholding1+Landholding2+Landholding3+Landholding4+Landholding5) [MEAN]
 /CATEGORIES VARIABLES=Q111 TOTAL=YES
 /TITLE TITLE="Table: Average Landholding and Average Irrigated Land (In Acres) per Household by Social Category".
NEW FILE.


        *Agriculture Assets

IF (Q23A>0) Tractor=1.
IF MISSING(Q23A) Tractor=2.
EXECUTE.
IF (Q23B>0) Power_tiller=1.
IF MISSING(Q23B) Power_tiller=2.
EXECUTE.
IF (Q23C>0) Chaff_cutter=1.
IF MISSING(Q23C) Chaff_cutter=2.
EXECUTE.
IF (Q23D>0) Sprinkler=1.
IF MISSING(Q23D) Sprinkler=2.
EXECUTE.
IF (Q23E>0) Sprayer=1.
IF MISSING(Q23E) Sprayer=2.
EXECUTE.
IF (Q23F>0) Winnower=1.
IF MISSING(Q23F) Winnower=2.
EXECUTE.
IF (Q23G>0) Pumpset=1.
IF MISSING(Q23G) Pumpset=2.
EXECUTE.
IF (Q23H>0) Harvester=1.
IF MISSING(Q23H) Harvester=2.
EXECUTE.


CTABLES
 /TABLE Q111 BY IC > (Tractor+Power_tiller+Chaff_cutter+Sprinkler+Sprayer+Winnower+Pumpset+Harvester) [ROWPCT.COUNT COUNT]
 /CATEGORIES VARIABLES=Q111 TOTAL=YES
 /TITLE TITLE="Table: Proportion of Households exhibiting Ownership of Agricultural Assets".



        *Number of Animals Owned

IF (Q22A1>0) OR (Q22A2>0) Cow=1.
IF MISSING(Q22A1) & MISSING(Q22A2) Cow=2.
EXECUTE.
IF (Q22B1>0) OR (Q22B2>0) Goat=1.
IF MISSING(Q22B1) & MISSING(Q22B2) Goat=2.
EXECUTE.
IF (Q22C1>0) OR (Q22C2>0) Buffalo=1.
IF MISSING(Q22C1) & MISSING(Q22C2) Buffalo=2.
EXECUTE.
IF (Q22D1>0) OR (Q22D2>0) Sheep=1.
IF MISSING(Q22D1) & MISSING(Q22D2) Sheep=2.
EXECUTE.
IF (Q22E1>0) OR (Q22E2>0) Pig=1.
IF MISSING(Q22E1) & MISSING(Q22E2) Pig=2.
EXECUTE.
IF (Q22F1>0) OR (Q22F2>0) Poultry=1.
IF MISSING(Q22F1) & MISSING(Q22F2) Poultry=2.
EXECUTE.
IF (Q22G1>0) OR (Q22G2>0) Other_animals=1.
IF MISSING(Q22G1) & MISSING(Q22G2) Other_animals=2.
EXECUTE.
IF (Cow=1 OR Goat=1 OR Buffalo=1 OR Sheep=1 OR Pig=1 OR Poultry=1 OR Other_animals=1) Any_animal=1.
IF (Cow=2 AND Goat=2 AND Buffalo=2 AND Sheep=2 AND Pig=2 AND Poultry=2 AND Other_animals=2) Any_animal=2.
EXECUTE.

FREQUENCIES Cow Goat Buffalo Sheep Pig Poultry Other_animals Any_animal.

IF (Goat=1) OR (Sheep=1) Small_ruminants=1.
IF (Goat=2) AND (Sheep=2) Small_ruminants=2.
EXECUTE.

IF (Cow=1) OR (Buffalo=1) Cattle=1.
IF (Cow=2) AND (Buffalo=2) Cattle=2.
EXECUTE.

CTABLES
 /TABLE Q111 BY IC > (Cattle+Small_ruminants+Pig) [ROWPCT.COUNT COUNT]
 /CATEGORIES VARIABLES=Q111 TOTAL=YES
 /TITLE TITLE="Table:  Status of Households in terms of Ownership of Livestock".

        *Avg number of livestock calculations

COMPUTE CattleN = sum(Q22A1,Q22A2,Q22C1,Q22C2).
EXECUTE.
COMPUTE Small_ruminantsN =sum(Q22B1,Q22B2,Q22D1,Q22D2).
EXECUTE.
COMPUTE PigN=SUM(Q22E1,Q22E2).
EXECUTE.


CTABLES
 /TABLE Q111 BY IC > (CattleN+Small_ruminantsN+PigN) [MEAN]
 /CATEGORIES VARIABLES=Q111 IC TOTAL=YES
 /TITLE TITLE="Table:  Avg no. of livestock per HH (Base: HHs which have at least one animal in that category)".




*5.1 Employment & Migration- 1

GET 
  FILE='E:\AMS_Work\MeghaLamp\Meghalamp-HHR.sav'. 

COMPUTE EMP_TYPE1=2.
EXECUTE.
COMPUTE EMP_TYPE2=2.
EXECUTE.
COMPUTE EMP_TYPE3=2.
EXECUTE.
COMPUTE EMP_TYPE4=2.
EXECUTE.
COMPUTE EMP_TYPE5=2.
EXECUTE.
COMPUTE EMP_TYPE6=2.
EXECUTE.
COMPUTE EMP_TYPE7=2.
EXECUTE.
COMPUTE EMP_TYPE8=2.
EXECUTE.
COMPUTE EMP_TYPE9=2.
EXECUTE.
COMPUTE WORKER=2.
EXECUTE.


IF  (C10A=1 or C10B=1) EMP_TYPE1=1. 
EXECUTE.
IF  (C10A=2 or C10B=2) EMP_TYPE2=1. 
EXECUTE.
IF  (C10A=3 or C10B=3) EMP_TYPE3=1.
EXECUTE.
IF  (C10A=4 or C10B=4) EMP_TYPE4=1.
EXECUTE.
IF  (C10A=5 or C10B=5) EMP_TYPE5=1.
EXECUTE.
IF  (C10A=6 or C10B=6) EMP_TYPE6=1.
EXECUTE.
IF  (C10A=7 or C10B=7) EMP_TYPE7=1.
EXECUTE.
IF  (C10A=8 or C10B=8) EMP_TYPE8=1.
EXECUTE.
IF  (C10A=9 or C10B=9) EMP_TYPE9=1.
EXECUTE.
IF (EMP_TYPE1=1 or EMP_TYPE2=1 or EMP_TYPE3=1 or EMP_TYPE4=1 or EMP_TYPE5=1 or EMP_TYPE6=1 or EMP_TYPE7=1 or EMP_TYPE8=1 or EMP_TYPE9=1) WORKER=1.
EXECUTE. 
IF AgeCat1=1 WORKER=2.
EXECUTE.

SAVE OUTFILE='E:\AMS_Work\MeghaLamp\Meghalamp-HHR.sav'.

*Work participation by age group

GET 
  FILE='E:\AMS_Work\MeghaLamp\Meghalamp-HHR.sav'. 


*COMPUTE Filter_worker=(Worker=1).
*EXECUTE.
*FILTER BY Filter_worker.
*EXECUTE.

CTABLES 
/TABLE Agecat1 > Worker BY  IC > C4 [COUNT  COLPCT.COUNT]
/SIGTEST TYPE=CHISQUARE
/CATEGORIES VARIABLES=Worker C4 TOTAL=YES
 /TITLE TITLE="Table: Work Participation Rate".

*Work participation by education category

GET 
  FILE='E:\AMS_Work\MeghaLamp\Meghalamp-HHR.sav'. 


*COMPUTE Filter_worker=(Worker=1).
*EXECUTE.
*FILTER BY Filter_worker.
*EXECUTE.

CTABLES 
/TABLE Educat1 >Worker BY  IC > C4 [COUNT  COLPCT.COUNT]
/SIGTEST TYPE=CHISQUARE
/CATEGORIES VARIABLES=C4 TOTAL=YES
 /TITLE TITLE="Table: Work Participation Rate".

*FILTER OFF.
*USE ALL.
*EXECUTE.

*Work participation by social category

GET 
  FILE='E:\AMS_Work\MeghaLamp\Meghalamp-HHR.sav'. 


*COMPUTE Filter_worker=(Worker=1).
*EXECUTE.
*FILTER BY Filter_worker.
*EXECUTE.

CTABLES 
/TABLE Q111 > Worker BY  IC > C4 [COUNT  COLPCT.COUNT]
/SIGTEST TYPE=CHISQUARE
/CATEGORIES VARIABLES=Q111 C4 TOTAL=YES
 /TITLE TITLE="Table: Work Participation Rate".

*FILTER OFF.
*USE ALL.
*EXECUTE.


        *Migration

GET 
  FILE='E:\AMS_Work\MeghaLamp\Meghalamp-HHR.sav'. 

CTABLES 
/TABLE (AgeCat1+Q111+Q112)  BY  IC > C12 [COUNT  ROWPCT.COUNT]
/SIGTEST TYPE=CHISQUARE
/CATEGORIES VARIABLES=C12 TOTAL=YES
 /TITLE TITLE="Table: Migration".

CTABLES 
/TABLE AgeCat1 BY IC > C14 [COUNT ROWPCT.COUNT]
/SIGTEST TYPE=CHISQUARE
/CATEGORIES VARIABLES=C14 TOTAL=YES
 /TITLE TITLE="Table: Place of Migration".

RECODE C15 (0 thru 5=1) (6 thru 11=2) (12=3) INTO C15Cat.
EXECUTE.

CTABLES 
/TABLE AgeCat1 BY IC > C15Cat [COUNT ROWPCT.COUNT]
/TABLE EduCat1 BY IC > C15Cat [COUNT ROWPCT.COUNT]
/CATEGORIES VARIABLES=C15Cat TOTAL=YES
 /TITLE TITLE="Table: Duration of Migration".

CTABLES 
/TABLE (AgeCat1+EduCat1) BY IC >C15 [MEAN]
/TITLE TITLE="Table: Mean Duration of Migration".

CTABLES
/TABLE C13 [COLPCT.COUNT COUNT] BY IC
/CATEGORIES VARIABLES=IC TOTAL=YES.



        *Non-farm enterprises


GET 
  FILE='E:\AMS_Work\MeghaLamp\Meghalamp HH3.sav'.

CTABLES
/TABLE (Q111+Q112) BY IC> Q51 [COLPCT.COUNT COUNT]
/TITLE TITLE="Table: Engagement in Non-farm Enterprise". 

SORT CASES BY Q51.
SPLIT FILE SEPARATE BY Q51.
SHOW SPLIT FILE.


CTABLES
/TABLE Q512 BY IC [SUBTABLEPCT.TOTALN COUNT] 
/TITLES TITLE="Engagement with different types of microenterprises"
/TABLE (Q514+Q515+Q516)[MEAN] BY IC
/TITLES TITLE="Financial Status of Enterprises".

FREQUENCIES Q512.
SPLIT FILE OFF.


*5.2 Employment & Migration-2

COMPUTE Filter_Worker=(Worker=1).
EXECUTE.
Filter BY Filter_Worker.
EXECUTE.

CTABLES 
/TABLE AgeCat1 >  C4[ROWPCT.COUNT COUNT] BY IC > (EMP_TYPE1 + EMP_TYPE2 + EMP_TYPE3 + EMP_TYPE4 + EMP_TYPE5 + EMP_TYPE6 + EMP_TYPE7 + EMP_TYPE8 + EMP_TYPE9) 
 /TITLE TITLE="Table: Type of Employment (Age 15-59)- Age Category wise".

CTABLES 
/TABLE EduCat1 >  C4 [ROWPCT.COUNT COUNT] BY IC > (EMP_TYPE1 + EMP_TYPE2 + EMP_TYPE3 + EMP_TYPE4 + EMP_TYPE5 + EMP_TYPE6 + EMP_TYPE7 + EMP_TYPE8 + EMP_TYPE9) 
 /TITLE TITLE="Table: Type of Employment (Age 15-59)- Education Category wise".

CTABLES 
/TABLE Q111 >  C4 [ROWPCT.COUNT COUNT] BY IC > (EMP_TYPE1 + EMP_TYPE2 + EMP_TYPE3 + EMP_TYPE4 + EMP_TYPE5 + EMP_TYPE6 + EMP_TYPE7 + EMP_TYPE8 + EMP_TYPE9) 
 /TITLE TITLE="Table: Type of Employment (Age 15-59)- Social Category wise".

FILTER OFF.
USE ALL.
EXECUTE.



*6. Household Income

        *Computing agri_income 

GET 
  FILE='E:\AMS_Work\MeghaLamp\Meghalamp HHRI.sav'. 

COMPUTE UID=(LOC*100+SN).
EXECUTE.

COMPUTE Agri_income= (Q62F*Q62O).
EXECUTE.

TABLES
  /FORMAT BLANK MISSING('.')
  /OBSERVATION= Agri_income
  /GBASE=CASES
  /TABLE=UID BY Agri_income
  /STATISTICS
  Sum( Agri_income)
  Validn( Agri_income( NEQUAL5.0 )).

*Computing income from livestock

GET 
  FILE='E:\AMS_Work\MeghaLamp\Meghalamp HHR63.sav'. 

COMPUTE UID=(LOC*100+SN).
EXECUTE.

COMPUTE Livestock_income= (Q631B*Q631H).
EXECUTE.

TABLES
  /FORMAT BLANK MISSING('.')
  /OBSERVATION= Livestock_income
  /GBASE=CASES
  /TABLE=UID BY Livestock_income
  /STATISTICS
  Sum( Livestock_income)
  Validn( Livestock_income( NEQUAL5.0 )).


GET 
  FILE='E:\AMS_Work\MeghaLamp\Meghalamp HH3.sav'. 

COMPUTE Income_641 = (Q641B-Q641C).
EXECUTE.
COMPUTE Income_642 = (Q642B-Q642C).
EXECUTE.
COMPUTE Income_643 = (Q643B-Q643C).
EXECUTE.
COMPUTE Income_644 = (Q644B-Q644C).
EXECUTE.
COMPUTE Income_645 = (Q645B-Q645C).
EXECUTE.
COMPUTE Income_646 = (Q646B-Q646C).
EXECUTE.
COMPUTE Income_647 = (Q647B-Q647C).
EXECUTE.


COMPUTE Income_other= SUM(Income_641, Income_642+Income_643, Income_644, Income_645, Income_646, Income_647, Q648B, Q649B, Q6410B, Q6411B).
EXECUTE.


COMPUTE Income_payment_remittances = SUM(Q651, Q652, Q653, Q654, Q655, Q656, Q657).
EXECUTE.


*Computing Total Income


        *Bring agri income and livestock income in the main HH dataset from their respective roster files. This is to be done manually using Excel Look-ups.

 

COMPUTE TOT_Income= SUM(Agri_income, Livestock_income, Income_other, Income_payment_remittances).
EXECUTE.


GET 
  FILE='E:\AMS_Work\MeghaLamp\Meghalamp HH3.sav'. 

COMPUTE TOT_Income_M= (TOT_Income/12).
EXECUTE.

CTABLES
/TABLE (TOT_Income+TOT_Income_M) [PTILE 10] BY IC
/TABLE (TOT_Income+TOT_Income_M) [PTILE 20] BY IC 
/TABLE (TOT_Income+TOT_Income_M) [PTILE 30] BY IC
/TABLE (TOT_Income+TOT_Income_M) [PTILE 40] BY IC
/TABLE (TOT_Income+TOT_Income_M) [PTILE 50] BY IC
/TABLE (TOT_Income+TOT_Income_M) [PTILE 60] BY IC
/TABLE (TOT_Income+TOT_Income_M) [PTILE 70] BY IC
/TABLE (TOT_Income+TOT_Income_M) [PTILE 80] BY IC
/TABLE (TOT_Income+TOT_Income_M) [PTILE 90] BY IC
/TABLE (TOT_Income+TOT_Income_M) [PTILE 95] BY IC
/TABLE (TOT_Income+TOT_Income_M) [PTILE 99] BY IC.


        *Per capita income and related tables

GET 
  FILE='E:\AMS_Work\MeghaLamp\Meghalamp HH3.sav'. 

COMPUTE PCI= (TOT_Income/Members).
EXECUTE.

CTABLES
/TABLE (Q111) BY IC [COUNT] 
/TABLE (Q111) BY IC > (TOT_Income + PCI) [MEAN]
/CATEGORIES VARIABLES=Q111 TOTAL=YES
/TITLES TITLE= "Mean Household Income and Mean per capita Income of  Households across various socio-economic categories".
EXECUTE.

CTABLES
/TABLE (HHead_Edu) BY IC [COUNT] 
/TABLE (HHead_Edu) BY IC > (TOT_Income + PCI) [MEAN]
/CATEGORIES VARIABLES=HHead_Edu TOTAL=YES
/TITLES TITLE= "Mean Household Income and Mean per capita Income of  Households across various socio-economic categories".
EXECUTE.

        *Income from various sources

GET 
  FILE='E:\AMS_Work\MeghaLamp\Meghalamp HH3.sav'. 

COMPUTE V62=2.
IF (Agri_income>0)  V62=1.
EXECUTE.
COMPUTE V63=2.
IF (Livestock_Income>0)  V63=1.
EXECUTE.
COMPUTE V641=2.
IF (Q641B>0)  V641=1.
EXECUTE.
COMPUTE V642=2.
IF (Q642B>0)  V642=1.
EXECUTE.
COMPUTE V643=2.
IF (Q643B>0)  V643=1.
EXECUTE.
COMPUTE V644=2.
IF (Q644B>0)  V644=1.
EXECUTE.
COMPUTE V645=2.
IF (Q645B>0)  V645=1.
EXECUTE.
COMPUTE V646=2.
IF (Q646B>0)  V646=1.
EXECUTE.
COMPUTE V647=2.
IF (Q647B>0)  V647=1.
EXECUTE.
COMPUTE V648=2.
IF (Q648B>0)  V648=1.
EXECUTE.
COMPUTE V649=2.
IF (Q649B>0)  V649=1.
EXECUTE.
COMPUTE V6410=2.
IF (Q6410B>0)  V6410=1.
EXECUTE.
COMPUTE V6411=2.
IF (Q6411B>0)  V6411=1.
EXECUTE.
COMPUTE V65=2.
IF (Income_payment_remittances>0)  V65=1.
EXECUTE.


CTABLES
/TABLE (V62+V63+V641+V642+V643+V644+V645+V646+V647+V648+V649+V6410+V6411+V65) [COLPCT.COUNT COUNT] BY IC
/CATEGORIES VARIABLES= V62 V63 V641 V642 V643 V644 V645 V646 V647 V648 V649 V6410 V6411 V65 TOTAL=YES
/TITLES TITLE= " Proportion of HHs Earning from Various Sources".

SORT CASES BY IC.
SPLIT FILE SEPARATE BY IC.
CTABLES
/TABLE (Q111 + HHead_Edu) BY IC > (V62+V63+V641+V642+V643+V644+V645+V646+V647+V648+V649+V6410+V6411+V65) [ROWPCT.COUNT COUNT] 
/CATEGORIES VARIABLES= V62 V63 V641 V642 V643 V644 V645 V646 V647 V648 V649 V6410 V6411 V65 TOTAL=YES
/TITLES TITLE= " Proportion of HHs Earning from Various Sources".
SPLIT FILE OFF.



* 7. Consumption Expenditure  

         *Food expenses

RECODE Q711 Q712 Q713 Q714 Q715 Q716 Q717 Q718 Q719 Q7110 Q7111 Q7112 (MISSING=0). 
EXECUTE.
COMPUTE Food_Expenses= (Q711+Q712+Q713+Q714+Q715+Q716+Q717+Q718+Q719+Q7110+Q7111+Q7112).
EXECUTE.
EXAMINE Q711 Q712 Q713 Q714 Q715 Q716 
/STATISTICS DESCRIPTIVES.
EXAMINE Q717 Q718 Q719 Q7110 Q7111 Q7112 Food_Expenses
/STATISTICS DESCRIPTIVES.

         *Non-food expenses

RECODE Q721 Q722 Q723 Q724 Q725 Q726 Q727 Q728 (MISSING=0).
EXECUTE.
COMPUTE Non_Food_Expenses= (Q721+Q722+Q723+Q724+Q725+Q726+Q727+Q728).
EXECUTE.
EXAMINE Q721 Q722 Q723 Q724 Q725 Q726 Q727 Q728 Non_Food_Expenses
/STATISTICS DESCRIPTIVES.

         *Other annual expenses

RECODE Q731 Q732 Q733 Q734 Q735 Q736 (MISSING=0).
EXECUTE.
COMPUTE Other_Annual_Expenses= (Q731+Q732+Q733+Q734+Q735+Q736).
EXECUTE.
EXAMINE  Q731 Q732 Q733 Q734 Q735 Q736 Other_Annual_Expenses
/STATISTICS DESCRIPTIVES.

        *Contingency expenses

RECODE Q741 Q742 Q743 Q744 Q745 Q746 (MISSING=0).
EXECUTE.
COMPUTE Contingency_Expenses= (Q741+Q742+Q743+Q744+Q745+Q746).
EXECUTE.
EXAMINE  Q741 Q742 Q743 Q744 Q745 Q746 Contingency_Expenses
/STATISTICS DESCRIPTIVES.

        *Total Expenses

COMPUTE Total_Annual_Expenses = (Food_Expenses*12 + Non_Food_Expenses*12 + Other_Annual_Expenses + Contingency_Expenses).
EXECUTE. 
EXAMINE Total_Annual_Expenses
/STATISTICS DESCRIPTIVES.

        *MPCE and related calculations

COMPUTE MPCE= (Total_Annual_Expenses / (Members* 12)).
EXECUTE.

CTABLES
/TABLE MPCE [PTILE 10] BY IC
/TABLE MPCE [PTILE 20] BY IC
/TABLE MPCE [PTILE 30] BY IC
/TABLE MPCE [PTILE 40] BY IC
/TABLE MPCE [PTILE 50] BY IC
/TABLE MPCE [PTILE 60] BY IC
/TABLE MPCE [PTILE 70] BY IC
/TABLE MPCE [PTILE 80] BY IC
/TABLE MPCE [PTILE 90] BY IC
/TITLES TITLE = "Distribution of population MPCE".

CTABLES
/TABLE Q111 BY IC > MPCE [COUNT MEAN MEDIAN]
/CATEGORIES VARIABLES=Q111 TOTAL= YES
/TITLES TITLE= "Monthly Per Capita Consumer Expenditure (MPCE) in the last year by social category"
/TABLE HHead_Edu BY IC > MPCE [COUNT MEAN MEDIAN]
/CATEGORIES VARIABLES=HHead_Edu TOTAL= YES
/TITLES TITLE= "Monthly Per Capita Consumer Expenditure (MPCE) in the last year by education of the household head".

*Income Vs Expenditure

COMPUTE MPCI= PCI/12.
EXECUTE.

COMPUTE Tot_income2= Tot_income.
EXECUTE.
RECODE Tot_income2 (0=SYSMIS). 
EXECUTE.

COMPUTE MPCI2= (Tot_income2/(members*12)).
EXECUTE.
COMPUTE Exp_by_Inc =MPCE/MPCI.
EXECUTE.

CTABLES
/TABLE Q111 BY IC > (MPCI+ MPCE+Exp_by_Inc) [COUNT MEAN MEDIAN MAXIMUM MINIMUM MISSING]
/CATEGORIES VARIABLES=Q111 TOTAL=YES.

CTABLES
/TABLE Q111 BY IC > (MPCI2+ MPCE+Exp_by_Inc) [COUNT MEAN MEDIAN MAXIMUM MINIMUM MISSING]
/CATEGORIES VARIABLES=Q111 TOTAL=YES
/TABLE HHead_Edu BY IC > (MPCI2+ MPCE+Exp_by_Inc) [COUNT MEAN MEDIAN MAXIMUM MINIMUM MISSING]
/CATEGORIES VARIABLES=HHead_Edu TOTAL=YES.



*What should be used? MPCI2 or MPCI??????

COMPUTE Annual_Food_expenses= 12 * Food_expenses.
EXECUTE.
COMPUTE Monthly_non_food_expenses = (Total_Annual_Expenses - Annual_food_expenses) / 12.
EXECUTE.

        *Definitions ->
        *Food_expenses= monthly food expenses
        *Annual_Food_expenses=  annual food expenses


CTABLES
/TABLE Q111 BY IC > (Food_expenses + Monthly_non_food_expenses) [MEAN MEDIAN] 
/CATEGORIES VARIABLES=Q111 TOTAL=YES
/TABLE HHead_Edu BY IC > (Food_expenses + Monthly_non_food_expenses) [MEAN MEDIAN] 
/CATEGORIES VARIABLES=HHead_Edu TOTAL=YES.




*8. Savings
      

GET 
  FILE='E:\AMS_Work\MeghaLamp\Meghalamp HHR81.sav'.

COMPUTE UID= (LOC*100+SN).
EXECUTE.

*calculation of Saver households and number of savers in households, and exporting the data to HH file

GET 
  FILE='E:\AMS_Work\MeghaLamp\Meghalamp HH3.sav'.

CTABLES
/TABLE Q111 BY IC>Savers [COUNT ROWPCT.COUNT]
/CATEGORIES VARIABLES=Q111 TOTAL=YES
/TITLES TITLE= "Social Category-wise Distribution of Households that had made any savings in the past One Year"
/TABLE HHead_Edu BY IC > Savers [COUNT ROWPCT.COUNT]
/CATEGORIES VARIABLES=HHead_Edu TOTAL=YES
/TITLES TITLE= "HH Head Education Category-wise Distribution of Households that had made any savings in the past One Year".


GET 
  FILE='E:\AMS_Work\MeghaLamp\Meghalamp HHR81.sav'.

FREQUENCIES UID.

        * Distribution of Households with respect to number of members saving money

CTABLES
/TABLE Savers_no [COUNT COLPCT.COUNT] BY IC
/CATEGORIES VARIABLES=savers_no TOTAL=YES
/TITLES TITLE= " Distribution of Households with respect to number of members saving money".

        *Quantum of savings

CTABLES
/TABLE Q81D [MINIMUM MAXIMUM MEAN MEDIAN] BY IC
/TITLES TITLE= " Quantum of Savings made by  Intervention Households in the past one year preceding the survey".



*9. Investment & Insurance



COMPUTE Any_investment=2.
EXECUTE.
IF (Q821A=1 OR Q822A=1 OR Q823A=1 OR Q824A=1 OR Q825A=1 OR Q826A=1 OR Q827A=1 OR Q828A=1) Any_investment=1.
EXECUTE.

COMPUTE Total_investment= SUM(Q821D, Q822D, Q823D, Q824D, Q825D, Q826D, Q827D, Q828D).
EXECUTE.

CTABLES
/TABLE Q111  BY IC > Any_investment [COUNT ROWPCT.COUNT]
/CATEGORIES VARIABLES= Q111 TOTAL=YES 
/TITLES TITLE= "Distribution of households that made any investment in Last 1 year by social category"
/TABLE HHead_Edu  BY IC > Any_investment [COUNT ROWPCT.COUNT]
/CATEGORIES VARIABLES= HHead_Edu TOTAL=YES 
/TITLES TITLE= "Distribution of households that made any investment in Last 1 year by education of the head of the household".

CTABLES
/TABLE Q111 BY IC > (Q821A+Q822A+Q823A+Q824A+Q825A+Q826A+Q827A+Q828A) [COUNT ROWPCT.COUNT]
/CATEGORIES VARIABLES=Q111 TOTAL=YES
/TITLES TITLE= "Pattern of Investment by social category"
/TABLE HHead_Edu BY IC > (Q821A+Q822A+Q823A+Q824A+Q825A+Q826A+Q827A+Q828A) [COUNT ROWPCT.COUNT]
/CATEGORIES VARIABLES=HHead_Edu TOTAL=YES
/TITLES TITLE="Pattern of Investment by education of the head of the household".

CTABLES
/TABLE Q111 BY IC > Total_investment [COUNT MEAN MEDIAN]
/CATEGORIES VARIABLES=Q111 TOTAL= YES
/TITLES TITLE= "Pattern of Investment by social category- Investor HHs"
/TABLE HHead_Edu BY IC > Total_investment [COUNT MEAN MEDIAN]
/CATEGORIES VARIABLES=HHead_Edu TOTAL= YES
/TITLES TITLE= "Pattern of Investment by education of the head of the household- Investor HHs".

        *treatment of missing values in total investment variable

COMPUTE Total_investment2= Total_investment.
EXECUTE.
IF MISSING (Total_investment) Total_investment2=0.
EXECUTE. 


CTABLES
/TABLE Q111 BY IC > Total_investment2 [COUNT MEAN MEDIAN]
/CATEGORIES VARIABLES=Q111 TOTAL= YES
/TITLES TITLE= "Pattern of Investment by social category- All HHs"
/TABLE HHead_Edu BY IC > Total_investment2 [COUNT MEAN MEDIAN]
/CATEGORIES VARIABLES=HHead_Edu TOTAL= YES
/TITLES TITLE= "Pattern of Investment by education of the head of the household- All HHs".



        *Insurance


CTABLES
/TABLE Q111 [COUNT ROWPCT.COUNT] BY IC > (Q831 + Q832)
/CATEGORIES VARIABLES=Q111 TOTAL=YES
/TITLES TITLE = "Life Insurance & Health Insurance by social category"
/TABLE HHead_Edu [COUNT ROWPCT.COUNT] BY IC > (Q831 + Q832)
/CATEGORIES VARIABLES=HHead_Edu TOTAL=YES
/TITLES TITLE = "Life Insurance & Health Insurance by education of the head of the household".


*9. Food Security and Health 

CTABLES
/TABLE (Q91A+Q92A+Q93A+Q94A+Q95A+Q96A+Q97A+Q98A+Q99A) [COUNT COLPCT.COUNT] BY IC
/TITLES TITLE= "Incidence of Food Insecurity in Sampled Households in the Past 4 Weeks Preceding the Survey" 
/TABLE (Q91B+Q92B+Q93B+Q94B+Q95B+Q96B+Q97B+Q98B+Q99B) [COUNT COLPCT.COUNT] BY IC
/TITLES TITLE= "Incidence of Food Insecurity in the Past 4 Weeks Preceding the Survey". 

    *Anthro analysis to be done using WHO Anthropac

       
*10. Women Empowerment

GET 
  FILE='E:\AMS_Work\MeghaLamp\Meghalamp HH3.sav'.

CTABLES
/TABLE Q111 BY IC > (Q1011+Q1012+Q1013+Q1014+Q1015) [COUNT ROWPCT.COUNT]
/CATEGORIES VARIABLES=Q111 TOTAL=YES
/TITLES TITLE="Status of women mobility by social category"
/TABLE HHead_Edu BY IC > (Q1011+Q1012+Q1013+Q1014+Q1015) [COUNT ROWPCT.COUNT]
/TITLES TITLE="Status of women mobility by education status of the head of the household".


CTABLES
/TABLE (Q1021+Q1022+Q1023+Q1024+Q1025+Q1026+Q1027) [COUNT COLPCT.COUNT] BY IC 
/TITLES TITLE="Participation of Women in Household Decision Making in the Intervention Area".


*11. Livelihood Support Groups

CTABLES
/TABLE (Q111+Q112) > Q111_A BY IC [COUNT COLPCT.COUNT]
/CATEGORIES VARIABLES=Q111_A TOTAL=YES
/TITLES TITLE="Proportion of Households Registered at EFC".

        *Calculation of Q112 Roster

GET 
  FILE='E:\AMS_Work\MeghaLamp\Meghalamp HHR112.sav'.

IF (189>LOC) AND (LOC>100) IC=1.
IF (289>LOC) AND (LOC>200) IC=2.
EXECUTE.

MRSETS
/MCGROUP NAME=$Q112 LABEL ="Type of Assistance or Support Received" VARIABLES =Q112C1 Q112C2 Q112C3.
EXECUTE.
CTABLES
/TABLE $Q112 [COUNT COLPCT.COUNT] BY IC
/CATEGORIES VARIABLES=$Q112 TOTAL=YES
/TITLES TITLE= "Type of Assistance or Support Received".



*13. IBDLP and Basin Programme



*@@@ EXPERIMENT
*COMPUTE Filter_Worker=(Worker=1).
*EXECUTE.
*Filter BY Filter_Worker.
*EXECUTE.

*CTABLES 
/TABLE EduCat1 > C4 [TABLEPCT.COUNT COUNT] BY IC > C10A
/CATEGORIES VARIABLES= EduCat1 C4 IC C10A  TOTAL=YES 
/TITLE TITLE="Experiment Table".

*COMPUTE Filter_Q131=(LOC=175).
*EXECUTE.
*FILTER BY Filter_Q131.
*EXECUTE.

CTABLES
/TABLE Q131 BY IC [COUNT COLPCT.COUNT]
/CATEGORIES VARIABLES=Q131 TOTAL=YES
/TITLES TITLE= "Percentage of Respondents aware of the IBDLP/Basin Programme".


MRSETS 
/MCGROUP NAME =$Q132 LABEL ="How did you learn about IBDLP Basin Programme?" VARIABLES = Q132A Q132B Q132C Q132D.
EXECUTE.
CTABLES
/TABLE $Q132 BY IC [COUNT COLPCT.COUNT]
/CATEGORIES VARIABLES=$Q132 TOTAL= YES.

MRSETS 
/MCGROUP NAME =$Q133 LABEL ='Have you received any benefit by being associated with IDBLP Basin Programme?' VARIABLES = Q133A Q133B Q133C Q133D.
EXECUTE.
CTABLES
/TABLE $Q133 BY IC [COUNT COLPCT.COUNT]
/CATEGORIES VARIABLES=$Q133 TOTAL= YES
/TITLES TITLE= "Responent received following benefits by being associated with IBDLP/Basin Programme in intervention area".


COMPUTE Filter_IC=(IC=1).
EXECUTE.
FILTER BY Filter_IC.
EXECUTE.

FREQUENCIES Q1341 Q1342 Q136.

FILTER OFF.
USE ALL.
EXECUTE.

COMPUTE Filter_IC=(IC=2).
EXECUTE.
FILTER BY Filter_IC.
EXECUTE.

FREQUENCIES Q1341 Q1342 Q136.

FILTER OFF.
USE ALL.
EXECUTE.




MRSETS 
/MCGROUP NAME =$Q135 LABEL ='What support do you expect from IDBLP Basin Programme?' VARIABLES = Q135A Q135B Q135C Q135D.
EXECUTE.
CTABLES
/TABLE $Q135 BY IC [COUNT COLPCT.COUNT]
/CATEGORIES VARIABLES=$Q135 TOTAL= YES.

*Q136 covered earlier.



*+++++++++++++++EXTRAS+++++++++++++++++




*Housing Property

IF (Q24A>0) House=1.
IF MISSING(Q24A) House=2.
EXECUTE.
IF (Q24B>0) Homestead_plots=1.
IF MISSING(Q24B) Homestead_plots=2.
EXECUTE.

FREQUENCIES House Homestead_plots.

*Consumer Durables

IF (Q25A>0) Television=1.
IF MISSING(Q25A) Television=2.
EXECUTE.
IF (Q25B>0) Radio_Transistor=1.
IF MISSING(Q25B) Radio_Transistor=2.
EXECUTE.
IF (Q25C>0) Computer_laptop=1.
IF MISSING(Q25C) Computer_laptop=2.
EXECUTE.
IF (Q25D>0) Telephone_mobile=1.
IF MISSING(Q25D) Telephone_mobile=2.
EXECUTE.
IF (Q25E>0) Electric_Fan=1.
IF MISSING(Q25E) Electric_Fan=2.
EXECUTE.
IF (Q25F>0) Almirah=1.
IF MISSING(Q25F) Almirah=2.
EXECUTE.
IF (Q25G>0) Gas_stove=1.
IF MISSING(Q25G) Gas_stove=2.
EXECUTE.
IF (Q25H>0) Mixer_grinder=1.
IF MISSING(Q25H) Mixer_grinder=2.
EXECUTE.
IF (Q25I>0) Motorcycle_Scooter=1.
IF MISSING(Q25I) Motorcycle_Scooter=2.
EXECUTE.
IF (Q25J>0) Bicycle=1.
IF MISSING(Q25J) Bicycle=2.
EXECUTE.
IF (Q25K>0) Car=1.
IF MISSING(Q25K) Car=2.
EXECUTE.

FREQUENCIES Television Radio_transistor Computer_laptop Telephone_mobile Electric_fan Almirah Gas_stove Mixer_grinder Motorcycle_scooter Bicycle Car.

*@@@@@@@@ 3. Housing Amenities @@@@@@@@

*FREQUENCIES Q31 Q35 Q36 Q37 Q38.

*@@@@@@@@ 4.Occupation/ Employment Profile @@@@@@@@



 *Bank term deposit

FREQUENCIES Q821A.

COMPUTE Filter_Q821A=(Q821A=1).
FILTER BY Filter_Q821A.
EXECUTE.

DESCRIPTIVES VARIABLES Q821D
/STATISTICS MEAN RANGE.

FILTER OFF.
USE ALL.
EXECUTE.

        *Postal term deposit

FREQUENCIES Q822A.

COMPUTE Filter_Q822A=(Q822A=1).
FILTER BY Filter_Q822A.
EXECUTE.

DESCRIPTIVES VARIABLES Q822D
/STATISTICS MEAN RANGE.

FILTER OFF.
USE ALL.
EXECUTE.

        *Provident Fund

FREQUENCIES Q823A.

COMPUTE Filter_Q823A=(Q823A=1).
FILTER BY Filter_Q823A.
EXECUTE.

DESCRIPTIVES VARIABLES Q823D
/STATISTICS MEAN RANGE.

FILTER OFF.
USE ALL.
EXECUTE.

        *Chit fund

FREQUENCIES Q824A.

COMPUTE Filter_Q824A=(Q824A=1).
FILTER BY Filter_Q824A.
EXECUTE.

DESCRIPTIVES VARIABLES Q824D
/STATISTICS MEAN RANGE.

FILTER OFF.
USE ALL.
EXECUTE.

        *Jewellery

FREQUENCIES Q825A.

COMPUTE Filter_Q825A=(Q825A=1).
FILTER BY Filter_Q825A.
EXECUTE.

DESCRIPTIVES VARIABLES Q825D
/STATISTICS MEAN RANGE.

FILTER OFF.
USE ALL.
EXECUTE.

        *Land

FREQUENCIES Q826A.

COMPUTE Filter_Q826A=(Q826A=1).
FILTER BY Filter_Q826A.
EXECUTE.

DESCRIPTIVES VARIABLES Q826D
/STATISTICS MEAN RANGE.

FILTER OFF.
USE ALL.
EXECUTE.

        *Cattle

FREQUENCIES Q827A.

COMPUTE Filter_Q827A=(Q827A=1).
FILTER BY Filter_Q827A.
EXECUTE.

DESCRIPTIVES VARIABLES Q827D
/STATISTICS MEAN RANGE.

FILTER OFF.
USE ALL.
EXECUTE.

        *Equipment for farm business

FREQUENCIES Q828A.

COMPUTE Filter_Q828A=(Q828A=1).
FILTER BY Filter_Q828A.
EXECUTE.

DESCRIPTIVES VARIABLES Q828D
/STATISTICS MEAN RANGE.

FILTER OFF.
USE ALL.
EXECUTE.

*10. Women Empowerment
* Going alone to various places


FREQUENCIES Q1011 Q1012 Q1013 Q1014 Q1015 Q1016.
 
*Taking decision in the household

FREQUENCIES Q1021 Q1022 Q1023 Q1024 Q1025 Q1026 Q1027.

*Purchase of valuable assets

FREQUENCIES Q1028A Q1028B Q1028C Q1028D Q1028E Q1028F.
  
*Asset Ownership

FREQUENCIES Q103 Q104 Q105 Q106.


*@@@@@@@@@@ 8.3 Insurance @@@@@@@@@@@@

FREQUENCIES Q831 Q832 Q833 Q834.
