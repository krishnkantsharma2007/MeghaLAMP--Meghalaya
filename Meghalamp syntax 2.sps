
*Defining Intervention & Control LOCs; 
*Defining "Hills" for ethnicity wise analysis as and when applicable

**GET 
  FILE='E:\AMS_Work\MeghaLamp\Meghalamp HH3.sav'.

IF (189>LOC) AND (LOC>100) IC=1.
IF (289>LOC) AND (LOC>200) IC=2.
EXECUTE.

VALUE LABELS IC 1 'Intervention Area' 2 'Control Area'.
EXECUTE.
RECODE LOC (101 thru 139=1) (140 thru 161=2) (162 thru 188=3) (201 thru 239=1) (240 thru 261=2) (262 thru 288=3) INTO Hills.
EXECUTE.

VALUE LABELS Hills 1 'Garo hills' 2 'Jaintia hills' 3 'Khasi hills'.
EXECUTE.

RECODE Q111 (1=1) (ELSE=99). 
EXECUTE.

*SAVE OUTFILE='E:\AMS_Work\MeghaLamp\Meghalamp HH3.sav'.
*NEW FILE.

*@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@   Socio-economic Profile of HHs  @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@


        *Calculation of No. of members in each household

**GET 
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


*GET 
  FILE='E:\AMS_Work\MeghaLamp\Meghalamp HH3.sav'.
COMPUTE UID=(LOC*100+SN).
EXECUTE.

        *Use Excel to export number of members in each UID


*Demographic Details


**GET 
  FILE='E:\AMS_Work\MeghaLamp\Meghalamp HH3.sav'.

CTABLES
/TABLE Hills>Q111 BY IC [COUNT COLPCT.COUNT] 
/CATEGORIES VARIABLES=Hills Q111 TOTAL=YES
/TABLE Hills > Q18 BY IC  [COUNT COLPCT.COUNT] 
/CATEGORIES VARIABLES=Hills Q18 TOTAL=YES
/TITLES TITLE='Distribution by Gender of the Head of the Household'
/TABLE Hills > Q112 BY IC  [COUNT COLPCT.COUNT]
/CATEGORIES VARIABLES=Hills Q112 TOTAL=YES
/TITLES TITLE='Distribution by Economic Category'.


CTABLES
/TABLE Hills > Members [MEAN] BY IC
/CATEGORIES VARIABLES=Hills Members TOTAL=YES
/TITLES TITLE='Average Household Size'.

*CTABLES
/TABLE Q111+Q18+Q112 BY IC [COUNT COLPCT.COUNT]
/CATEGORIES VARIABLES=Q111 Q18 Q112 TOTAL=YES
/TITLES TITLE="Socio-economic Categories Vs IC".
*CTABLES 
/VLABELS VARIABLES=Q111 Members IC DISPLAY=LABEL 
/TABLE Q111 > Members [S][MEAN] BY IC [C] 
/CATEGORIES VARIABLES=Q111 IC ORDER=A KEY=VALUE EMPTY=EXCLUDE.



*Recoding of education and age variables


**GET 
  FILE='E:\AMS_Work\MeghaLamp\Meghalamp-HHR.sav'.

RECODE C4 (0 thru 5=1) (6 thru 14=2) (15 thru 19=3) (20 thru 29=4) (30 thru 39=5) (40 thru 49=6) (50 thru 59=7) (60 thru 69=8) (70 thru 102=9) (103 thru 999=999) (MISSING=999) INTO AgeCat1.
EXECUTE.

RECODE C5 (1 thru 4=1) (5 thru 9=2) (10 thru 12=3) (13=4) (14=5) (15 thru 16=6) INTO EduCat1.
EXECUTE.

*3A Demographic Profile of the Population Covered

*Defining Intervention & Control LOCs in ROSTER; 
*Defining "Hills" for ethnicity wise analysis as and when applicable


IF (189>LOC) AND (LOC>100) IC=1.
IF (289>LOC) AND (LOC>200) IC=2.
EXECUTE.

RECODE LOC (101 thru 139=1) (140 thru 161=2) (162 thru 188=3) (201 thru 239=1) (240 thru 261=2) (262 thru 288=3) INTO Hills.
EXECUTE.

VALUE LABELS Hills 1 'Garo hills' 2 'Jaintia hills' 3 'Khasi hills'.
EXECUTE.

VALUE LABELS C3 1 'Male' 2 'Female'.
EXECUTE.
VALUE LABELS AgeCat1 1 '0 to 5 Years' 2 '6 to 14 years' 3 '15 to 19 years' 4 '20 to 29 years' 5 '30 to 39 years' 6 '40 to 49 years' 7 '50 to 59 years' 8 '60 to 69 years' 9 '70 years or more'.
EXECUTE.
VALUE LABELS EduCat1 1 '1st-4th Std' 2 '5th - 9th Std' 3 '10th - 12th Std' 4 'Graduate' 5 'Post-graduate' 6 'Illiterate/LNFE'.
EXECUTE.
VALUE LABELS C7 1 'Yes' 2 'No'.
EXECUTE.
VALUE LABELS C8 1 'Yes' 2 'No'.
EXECUTE.


CTABLES
/TABLE Hills > C3 [COUNT COLPCT.COUNT] BY IC
/CATEGORIES VARIABLES=Hills C3 TOTAL=YES
/TITLES TITLE='Gender Distribution in the Population'
/TABLE AgeCat1 [COUNT COLPCT.COUNT] BY IC > Hills
/CATEGORIES VARIABLES=Hills AgeCat1 TOTAL=YES
/TITLES TITLE='Age Distribution in the Population'.
/TABLE EduCat1 [COUNT COLPCT.COUNT] BY IC > Hills
/CATEGORIES VARIABLES=Hills EduCat1 TOTAL=YES
/TITLES TITLE='Education Distribution in the Population'
/TABLE Hills > C7 [COUNT COLPCT.COUNT] BY IC
/CATEGORIES VARIABLES=Hills C7 TOTAL=YES
/TITLES TITLE='Status of Vocational Training in the Population'
/TABLE Hills > C8 [COUNT COLPCT.COUNT] BY IC
/CATEGORIES VARIABLES=Hills C8 TOTAL=YES
/TITLES TITLE='Availability of  Job Card in the Population'.

*job card

RECODE C8 (0=SYSMIS) (ELSE=COPY) INTO C8A.
EXECUTE.
CTABLES
/TABLE Hills > C8A [COUNT COLPCT.COUNT] BY IC
/CATEGORIES VARIABLES=Hills C8A TOTAL=YES
/TITLES TITLE='Availability of  Job Card in the Population'.


*CTABLES
/TABLE C3+AgeCat1+EduCat1+C7+C8 BY IC [COUNT, COLPCT.COUNT]
/CATEGORIES VARIABLES=C3 AgeCat1 EduCat1 C7 C8 TOTAL=YES
/TITLES TITLE="Demographic Details Vs IC".



*3B Housing and other amenities

*GET 
  FILE='E:\AMS_Work\MeghaLamp\Meghalamp HH3.sav'. 

CTABLES 
/TABLE Hills> Q31 [COUNT COLPCT.COUNT] BY IC 
/CATEGORIES VARIABLES=Hills Q31 TOTAL=YES
/TITLES TITLE="Distribution of Households in Intervention & Control area by Type of House".

*CTABLES 
/TABLE Q31 BY IC [COUNT COLPCT.COUNT]
/CATEGORIES VARIABLES=IC TOTAL=YES
/TITLES TITLE="Distribution of Households in Intervention & Control area by Type of House".


*CTABLES
/TABLE Q111 BY IC > Q31 [COUNT ROWPCT.COUNT]
/CATEGORIES VARIABLES=Q111 IC TOTAL=YES
/TITLES TITLE= "Distribution by Social Category ".


        *Export HHead's Educat1 from HHR to HH- Manually using Excel file

*Distribution by Education Category

CTABLES
/TABLE Hills> HHead_Edu BY IC > Q31 [COUNT ROWPCT.COUNT]
/CATEGORIES VARIABLES=Hills HHead_Edu TOTAL=YES
/TITLES TITLE= "Distribution of Type of House by HH Head Education ".


*CTABLES
/TABLE HHead_Edu BY IC > Q31 [COUNT ROWPCT.COUNT]
/CATEGORIES VARIABLES=HHead_Edu IC TOTAL=YES
/TITLES TITLE= "Distribution by HH Head Education ".

*Electricity Connection

CTABLES
/TABLE Hills> HHead_Edu BY IC > Q35 [COUNT ROWPCT.COUNT]
/CATEGORIES VARIABLES=Hills HHead_Edu TOTAL=YES
/TITLES TITLE= "Distribution of Electricity by HH Head Education ".



*CTABLES
/TABLE Q111+HHead_Edu BY IC > Q35 [COUNT ROWPCT.COUNT]
/CATEGORIES VARIABLES=Q111 TOTAL=YES
/TITLES TITLE= "Electricity Distribution by Social Category and HH Head Education".

*Toilet availability and usage


RECODE Q361 (0=SYSMIS). 
EXECUTE.

CTABLES
/TABLE Hills> Q36 [COUNT COLPCT.COUNT] BY IC
/CATEGORIES VARIABLES=Hills Q36 TOTAL=YES
/TITLES TITLE= "Availability of Toilet"
/TABLE Hills> Q361 [COUNT COLPCT.COUNT] BY IC
/CATEGORIES VARIABLES=Hills Q361 TOTAL=YES
/TITLES TITLE= "Usage of Toilet".


*CTABLES
/TABLE Q36+Q361 BY IC [COUNT COLPCT.COUNT]
/CATEGORIES VARIABLES=IC TOTAL=YES
/TITLES TITLE= "Toilet availability and usage".

CTABLES
/TABLE Hills> HHead_Edu BY IC > Q36 [COUNT ROWPCT.COUNT]
/CATEGORIES VARIABLES=Hills HHead_Edu TOTAL=YES
/TITLES TITLE= "Toilet availability by education status of HH Head"
/TABLE Hills> HHead_Edu BY IC > Q361 [COUNT ROWPCT.COUNT]
/CATEGORIES VARIABLES=Hills HHead_Edu TOTAL=YES
/TITLES TITLE= "Toilet usage by education status of HH Head".

CTABLES
/TABLE HHead_Edu BY IC > Q36 [COUNT ROWPCT.COUNT]
/CATEGORIES VARIABLES=HHEad_Edu TOTAL=YES
/TITLES TITLE= "Toilet availability by education status of HH Head"
/TABLE HHead_Edu BY IC > Q361 [COUNT ROWPCT.COUNT]
/CATEGORIES VARIABLES= HHead_Edu TOTAL=YES
/TITLES TITLE= "Toilet usage by education status of HH Head".

*Location and Type of toilet

RECODE Q362 (0=SYSMIS).
EXECUTE.
CTABLES
/TABLE Hills BY IC > Q362 [COUNT ROWPCT.COUNT]
/CATEGORIES VARIABLES=Hills TOTAL=YES
/TITLES TITLE= "Location of Toilet".

RECODE Q363 (0=SYSMIS).
EXECUTE.

CTABLES
/TABLE Hills BY IC > Q363 [COUNT ROWPCT.COUNT]
/CATEGORIES VARIABLES=Hills TOTAL=YES
/TITLES TITLE= "Type of Toilet".


*Primary source of drinking water

CTABLES
/TABLE Hills> Q37 [COUNT COLPCT.COUNT] BY IC 
/CATEGORIES VARIABLES=Hills Q37 TOTAL=YES
/TITLES TITLE= "Primary source of drinking water"
/TABLE Hills> HHead_Edu BY IC > Q37 [COUNT ROWPCT.COUNT]
/CATEGORIES VARIABLES=Hills HHead_Edu TOTAL=YES
/TITLES TITLE= "Primary source of drinking water by education status of HH Head".



*CTABLES
/TABLE Q37 BY IC  [COUNT COLPCT.COUNT]
/CATEGORIES VARIABLES=IC TOTAL=YES
/TITLES TITLE= "Primary source of drinking water".

*CTABLES
/TABLE Q111+HHead_Edu BY IC > Q37  [COUNT ROWPCT.COUNT]
/CATEGORIES VARIABLES=Q111 TOTAL=YES
/TITLES TITLE= "Source of drinking water by social category and education status of HH Head".



            *Electricity Connection


CTABLES
/TABLE Hills > Q35 [COUNT COLPCT.COUNT] BY IC
/CATEGORIES VARIABLES=Hills TOTAL=YES
/TITLES TITLE= "Availability of Electricity Connection".

RECODE Q352 (999=SYSMIS).
EXECUTE.

CTABLES
/TABLE Hills > Q352 [COUNT MEAN MEDIAN] BY IC
/CATEGORIES VARIABLES= Hills TOTAL=YES
/TITLES TITLE= "Electricity Supply".

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

*GET 
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
 /TABLE Hills > OUTCOME [ COLPCT.COUNT  COUNT]  BY IC
 /CATEGORIES VARIABLES=Hills OUTCOME TOTAL=YES
 /TITLE TITLE="Table: Land ownership".



*CTABLES
 /TABLE Q111 [ ROWPCT.TOTALN  COUNT]  BY IC > (OUTCOME + OUTCOME1)
 /CATEGORIES VARIABLES=Q111 TOTAL=YES
 /TITLE TITLE="Table: Social Category Vs Total land owned".

CTABLES
 /TABLE Hills > (Landholding1+Landholding2+Landholding3+Landholding4+Landholding5) [MEAN] BY IC
 /CATEGORIES VARIABLES=Hills TOTAL =YES
 /TITLE TITLE="Table: Average Landholding and Average Irrigated Land (In Acres) per Household by Social Category".



*CTABLES
 /TABLE Q111 BY IC > (Landholding1+Landholding2+Landholding3+Landholding4+Landholding5) [MEAN]
 /CATEGORIES VARIABLES=Q111 TOTAL=YES
 /TITLE TITLE="Table: Average Landholding and Average Irrigated Land (In Acres) per Household by Social Category".



        *Agriculture Assets

IF (Q23A>0) Tractor=1.
IF MISSING(Q23A) OR (Q23A=0) Tractor=2.
EXECUTE.
IF (Q23B>0) Power_tiller=1.
IF MISSING(Q23B) OR (Q23B=0) Power_tiller=2.
EXECUTE.
IF (Q23C>0) Chaff_cutter=1.
IF MISSING(Q23C) OR (Q23C=0) Chaff_cutter=2.
EXECUTE.
IF (Q23D>0) Sprinkler=1.
IF MISSING(Q23D) OR (Q23D=0) Sprinkler=2.
EXECUTE.
IF (Q23E>0) Sprayer=1.
IF MISSING(Q23E) OR (Q23E=0) Sprayer=2.
EXECUTE.
IF (Q23F>0) Winnower=1.
IF MISSING(Q23F) OR (Q23F=0) Winnower=2.
EXECUTE.
IF (Q23G>0) Pumpset=1.
IF MISSING(Q23G) OR (Q23G=0) Pumpset=2.
EXECUTE.
IF (Q23H>0) Harvester=1.
IF MISSING(Q23H) OR (Q23H=0) Harvester=2.
EXECUTE.


CTABLES
/TABLE Hills BY IC > (Tractor+Power_tiller+Chaff_cutter+Sprinkler+Sprayer+Winnower+Pumpset+Harvester) [COUNT ROWPCT.COUNT]
/CATEGORIES VARIABLES= Hills TOTAL=YES
/TITLES TITLE= "Proportion of Households exhibiting Ownership of Agricultural Assets".

*CTABLES
 /TABLE Q111 BY IC > (Tractor+Power_tiller+Chaff_cutter+Sprinkler+Sprayer+Winnower+Pumpset+Harvester) [ROWPCT.COUNT COUNT]
 /CATEGORIES VARIABLES=Q111 TOTAL=YES
 /TITLE TITLE="Table: Proportion of Households exhibiting Ownership of Agricultural Assets".



        *Number of Animals Owned

IF (Q22A1>0) OR (Q22A2>0) Cow=1.
IF MISSING(Q22A1) & MISSING(Q22A2) Cow=2.
IF (Q22A1=0) AND (Q22A2=0) Cow=2.
EXECUTE.
IF (Q22B1>0) OR (Q22B2>0) Goat=1.
IF MISSING(Q22B1) & MISSING(Q22B2) Goat=2.
IF (Q22B1=0) AND (Q22B2=0) Goat=2.
EXECUTE.
IF (Q22C1>0) OR (Q22C2>0) Buffalo=1.
IF MISSING(Q22C1) & MISSING(Q22C2) Buffalo=2.
IF (Q22C1=0) AND (Q22C2=0) Buffalo=2.
EXECUTE.
IF (Q22D1>0) OR (Q22D2>0) Sheep=1.
IF MISSING(Q22D1) & MISSING(Q22D2) Sheep=2.
IF (Q22D1=0) AND (Q22D2=0) Sheep=2.
EXECUTE.
IF (Q22E1>0) OR (Q22E2>0) Pig=1.
IF MISSING(Q22E1) & MISSING(Q22E2) Pig=2.
IF (Q22E1=0) AND (Q22E2=0) Pig=2.
EXECUTE.
IF (Q22F1>0) OR (Q22F2>0) Poultry=1.
IF MISSING(Q22F1) & MISSING(Q22F2) Poultry=2.
IF (Q22F1=0) AND (Q22F2=0) Poultry=2.
EXECUTE.
IF (Q22G1>0) OR (Q22G2>0) Other_animals=1.
IF MISSING(Q22G1) & MISSING(Q22G2) Other_animals=2.
IF (Q22G1=0) AND (Q22G2=0) Other_animals=2.
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
 /TABLE Hills > Any_animal [COUNT COLPCT.COUNT ROWPCT.COUNT] BY IC 
 /CATEGORIES VARIABLES=Hills TOTAL=YES
 /TITLE TITLE="Ownership of Any Livestock Animal".



CTABLES
 /TABLE Hills > (Cattle+Small_ruminants+Pig) [COLPCT.COUNT COUNT] BY IC 
 /CATEGORIES VARIABLES=Hills TOTAL=YES
 /TITLE TITLE="Table:  Status of Households in terms of Ownership of Livestock".


        *Avg number of livestock calculations

COMPUTE CattleN = sum(Q22A1,Q22A2,Q22C1,Q22C2).
EXECUTE.
COMPUTE Small_ruminantsN =sum(Q22B1,Q22B2,Q22D1,Q22D2).
EXECUTE.
COMPUTE PigN=SUM(Q22E1,Q22E2).
EXECUTE.


CTABLES
 /TABLE Hills > (CattleN+Small_ruminantsN+PigN) [MEAN COUNT] BY IC 
 /CATEGORIES VARIABLES=Hills TOTAL=YES
 /TITLE TITLE="Table:  Avg no. of livestock per HH (Base: All HHs)".

RECODE CattleN (0=SYSMIS) (ELSE=COPY) INTO CattleN1.
EXECUTE.
RECODE Small_ruminantsN (0=SYSMIS) (ELSE=COPY) INTO Small_ruminantsN1.
EXECUTE.
RECODE PigN (0=SYSMIS) (ELSE=COPY) INTO PigN1.
EXECUTE.

CTABLES
 /TABLE Hills > (CattleN1+Small_ruminantsN1+PigN1) [MEAN COUNT] BY IC 
 /CATEGORIES VARIABLES=Hills TOTAL=YES
 /TITLE TITLE="Table:  Avg no. of livestock per HH (Base: HHs which have at least one animal in that category)".



*5.1 Employment & Migration- 1

*GET 
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
*IF (AgeCat1=1 OR AgeCat1=2 OR AgeCat1=8 OR AgeCat1=9) WORKER=MISSING.
*EXECUTE.

        *Make code 1,2 ,3, 4 for AgeCat missing in the Worker variable.

*SAVE OUTFILE='E:\AMS_Work\MeghaLamp\Meghalamp-HHR.sav'.

*Work participation by age group

*GET 
  FILE='E:\AMS_Work\MeghaLamp\Meghalamp-HHR.sav'. 


*COMPUTE Filter_worker=(Worker=1).
*EXECUTE.
*FILTER BY Filter_worker.
*EXECUTE.

SORT CASES BY Hills.
SPLIT FILE SEPARATE BY Hills.
CTABLES 
/TABLE Agecat1 > Worker BY  IC > C3 [COUNT  SUBTABLEPCT.COUNT]
/SIGTEST TYPE=CHISQUARE
/CATEGORIES VARIABLES=AgeCat1 C3 TOTAL=YES
 /TITLE TITLE="Table: Work Participation Rate".
SPLIT FILE OFF.




*Work participation by education category

*GET 
  FILE='E:\AMS_Work\MeghaLamp\Meghalamp-HHR.sav'. 


*COMPUTE Filter_worker=(Worker=1).
*EXECUTE.
*FILTER BY Filter_worker.
*EXECUTE.

SORT CASES BY Hills.
SPLIT FILE SEPARATE BY Hills.
CTABLES 
/TABLE Educat1 >Worker BY  IC > C3 [COUNT  SUBTABLEPCT.COUNT]
/SIGTEST TYPE=CHISQUARE
/CATEGORIES VARIABLES= EduCat1 C3 TOTAL=YES
 /TITLE TITLE="Table: Work Participation Rate: By Education Category".
SPLIT FILE OFF.

*FILTER OFF.
*USE ALL.
*EXECUTE.

*Work participation by social category

*GET 
  FILE='E:\AMS_Work\MeghaLamp\Meghalamp-HHR.sav'. 



*CTABLES 
/TABLE Q111 > Worker BY  IC > C3 [COUNT  COLPCT.COUNT]
/SIGTEST TYPE=CHISQUARE
/CATEGORIES VARIABLES=Q111 C3 TOTAL=YES
 /TITLE TITLE="Table: Work Participation Rate".

*FILTER OFF.
*USE ALL.
*EXECUTE.


        *Migration

*GET 
  FILE='E:\AMS_Work\MeghaLamp\Meghalamp-HHR.sav'. 

RECODE C12 (0=2).
EXECUTE.

*Calculate whether any member of a particulat HH is out migrating. Transfer the data using Excel look ups into the HH File.

CTABLES
/TABLE Hills  > Migration [COUNT COLPCT.COUNT] BY IC
/CATEGORIES VARIABLES=Hills TOTAL=YES
/TITLES TITLE='Migration'.

SORT CASES BY IC.
SPLIT FILE SEPARATE BY IC.
CTABLES
/TABLE Hills > C12 BY C3 [COUNT ROWPCT.COUNT]
/CATEGORIES VARIABLES=Hills TOTAL=YES
/TITLES TITLE= 'Migration By Gender'.
SPLIT FILE OFF.

CTABLES
/TABLE AgeCat1 BY IC > C12 [COUNT ROWPCT.COUNT]
/TITLES TITLE="Migration By AGe Category".
 

*CTABLES 
/TABLE (AgeCat1+Q111+Q112)  BY  IC > C12 [COUNT  ROWPCT.COUNT]
/SIGTEST TYPE=CHISQUARE
/CATEGORIES VARIABLES=C12 TOTAL=YES
 /TITLE TITLE="Table: Migration".

RECODE C14 (0=SYSMIS).
EXECUTE.

CTABLES
/TABLE Hills > C14 [COUNT COLPCT.COUNT] BY IC
/CATEGORIES VARIABLES=Hills TOTAL=YES
/TITLES TITLE="Place of Migration".

*CTABLES 
/TABLE AgeCat1 BY IC > C14 [COUNT ROWPCT.COUNT]
/SIGTEST TYPE=CHISQUARE
/CATEGORIES VARIABLES=C14 TOTAL=YES
 /TITLE TITLE="Table: Place of Migration".

RECODE C15 (0=SYSMIS) (1 thru 5=1) (6 thru 11=2) (12=3) INTO C15Cat.
EXECUTE.

CTABLES
/TABLE Hills > C15Cat [COUNT COLPCT.COUNT] BY IC
/CATEGORIES VARIABLES = Hills TOTAL=YES
/TITLES TITLE= "Duration of Migration".

*CTABLES 
/TABLE AgeCat1 BY IC > C15Cat [COUNT ROWPCT.COUNT]
/TABLE EduCat1 BY IC > C15Cat [COUNT ROWPCT.COUNT]
/CATEGORIES VARIABLES=C15Cat TOTAL=YES
 /TITLE TITLE="Table: Duration of Migration".

RECODE C15 (0=SYSMIS).
EXECUTE.
CTABLES
/TABLE Hills > C15 [COUNT MEAN] BY IC
/CATEGORIES VARIABLES = Hills TOTAL=YES
/TITLES TITLE= "Mean Duration of Migration".
RECODE C15 (SYSMIS=0).
EXECUTE.

*CTABLES 
/TABLE (AgeCat1+EduCat1) BY IC >C15 [MEAN]
/TITLE TITLE="Table: Mean Duration of Migration".

RECODE C13 (0=SYSMIS).
EXECUTE.
CTABLES
/TABLE Hills > C13 [COUNT COLPCT.COUNT] BY IC
/CATEGORIES VARIABLES = Hills TOTAL=YES
/TITLES TITLE= "Reasons of Migration".


*CTABLES
/TABLE C13 [COLPCT.COUNT COUNT] BY IC
/CATEGORIES VARIABLES=IC TOTAL=YES.


        *Non-farm enterprises


*GET 
  FILE='E:\AMS_Work\MeghaLamp\Meghalamp HH3.sav'.

CTABLES
/TABLE Hills > Q51 [COUNT COLPCT.COUNT] BY IC
/CATEGORIES VARIABLES= Hills TOTAL=YES
/TITLES TITLE= "Engagement in Non-farm Enterprises".

*CTABLES
/TABLE (Q111+Q112) BY IC> Q51 [COLPCT.COUNT COUNT]
/TITLE TITLE="Table: Engagement in Non-farm Enterprise". 

*SORT CASES BY Q51.
*SPLIT FILE SEPARATE BY Q51.
*SHOW SPLIT FILE.

RECODE Q512 (0=SYSMIS).
EXECUTE.
CTABLES
/TABLE Hills > Q512 [COUNT COLPCT.COUNT] BY IC
/CATEGORIES VARIABLES=Hills TOTAL= YES
/TITLES TITLE= "Engagement with different types of microenterprises".

RECODE Q514 Q515 Q516 (0=SYSMIS).
EXECUTE.
CTABLES
/TABLE Hills > (Q514+Q515+Q516) [VALIDN MEAN] BY IC
/CATEGORIES VARIABLES=Hills TOTAL=YES
/TITLES TITLE="Financial Status of Enterprises".

*CTABLES
/TABLE Q512 BY IC [SUBTABLEPCT.TOTALN COUNT] 
/TITLES TITLE="Engagement with different types of microenterprises"
/TABLE (Q514+Q515+Q516)[MEAN] BY IC
/TITLES TITLE="Financial Status of Enterprises".

*FREQUENCIES Q512.
*SPLIT FILE OFF.


*5.2 Employment & Migration-2

*COMPUTE Filter_Worker=(Worker=1).
*EXECUTE.
*Filter BY Filter_Worker.
*EXECUTE.

SORT CASES BY IC.
SPLIT FILE SEPARATE BY IC.
CTABLES
/TABLE Hills > AgeCat1 > C3 [ROWPCT.COUNT ] BY (EMP_TYPE1 + EMP_TYPE2 + EMP_TYPE3 + EMP_TYPE4 + EMP_TYPE5 + EMP_TYPE6 + EMP_TYPE7 + EMP_TYPE8 + EMP_TYPE9)
/CATEGORIES VARIABLES=Hills TOTAL=YES
/TITLES TITLE = "Type of Employment (Age 15-59)- Age Category wise"
/TABLE Hills > EduCat1 > C3 [ROWPCT.COUNT ] BY (EMP_TYPE1 + EMP_TYPE2 + EMP_TYPE3 + EMP_TYPE4 + EMP_TYPE5 + EMP_TYPE6 + EMP_TYPE7 + EMP_TYPE8 + EMP_TYPE9)
/CATEGORIES VARIABLES=Hills TOTAL=YES
/TITLES TITLE = "Type of Employment (Age 15-59)- Education Category wise".
SPLIT FILE OFF.

SORT CASES BY IC.
SPLIT FILE SEPARATE BY IC.
 CTABLES
/TABLE EduCat1 > C3[COUNT ROWPCT.COUNT ] BY (EMP_TYPE1 + EMP_TYPE2 + EMP_TYPE3 + EMP_TYPE4 + EMP_TYPE5 + EMP_TYPE6 + EMP_TYPE7 + EMP_TYPE8 + EMP_TYPE9)
/CATEGORIES VARIABLES=(EMP_TYPE1 EMP_TYPE2 EMP_TYPE3  EMP_TYPE4  EMP_TYPE5  EMP_TYPE6  EMP_TYPE7  EMP_TYPE8  EMP_TYPE9) TOTAL=YES
/TITLES TITLE = "Type of Employment (Age 15-59)- Education Category wise".
SPLIT FILE OFF.



*CTABLES 
/TABLE AgeCat1 >  C3[ROWPCT.COUNT COUNT] BY IC > (EMP_TYPE1 + EMP_TYPE2 + EMP_TYPE3 + EMP_TYPE4 + EMP_TYPE5 + EMP_TYPE6 + EMP_TYPE7 + EMP_TYPE8 + EMP_TYPE9) 
 /TITLE TITLE="Table: Type of Employment (Age 15-59)- Age Category wise".

*CTABLES 
/TABLE EduCat1 >  C3 [ROWPCT.COUNT COUNT] BY IC > (EMP_TYPE1 + EMP_TYPE2 + EMP_TYPE3 + EMP_TYPE4 + EMP_TYPE5 + EMP_TYPE6 + EMP_TYPE7 + EMP_TYPE8 + EMP_TYPE9) 
 /TITLE TITLE="Table: Type of Employment (Age 15-59)- Education Category wise".

*CTABLES 
/TABLE Q111 >  C3 [ROWPCT.COUNT COUNT] BY IC > (EMP_TYPE1 + EMP_TYPE2 + EMP_TYPE3 + EMP_TYPE4 + EMP_TYPE5 + EMP_TYPE6 + EMP_TYPE7 + EMP_TYPE8 + EMP_TYPE9) 
 /TITLE TITLE="Table: Type of Employment (Age 15-59)- Social Category wise".

*FILTER OFF.
*USE ALL.
*EXECUTE.

DO IF (AgeCat1 = 1 | AgeCat1 = 2 | AgeCat1 = 8 | AgeCat1 = 9). 
RECODE C10A (0=SYSMIS). 
END IF. 
EXECUTE.
RECODE C10A (0=SYSMIS).
EXECUTE.

SORT CASES BY IC.
SPLIT FILE SEPARATE BY IC.
CTABLES
/TABLE Hills > C3 BY C10A [ROWPCT.COUNT]
/CATEGORIES VARIABLES=Hills TOTAL = YES
/TITLES TITLE="Gender wise distribution of Primary Occupation".
SPLIT FILE OFF.

SORT CASES BY IC.
SPLIT FILE SEPARATE BY IC.
CTABLES
/TABLE EduCat1 > C3 BY C10A [COUNT ROWPCT.COUNT]
/CATEGORIES VARIABLES=EduCat1 TOTAL=YES
/TITLES TITLE="Education Category wise distribution of Primary Occupation".
SPLIT FILE OFF.

SORT CASES BY IC.
SPLIT FILE SEPARATE BY IC.
CTABLES
/TABLE Hills BY C10A [ROWPCT.COUNT]
/CATEGORIES VARIABLES=Hills TOTAL = YES
/TITLES TITLE="Distribution of Primary Occupation".
SPLIT FILE OFF.

*5.1 Income Security

RECODE Q5A11 (1 thru 12=1) (ELSE=SYSMIS) INTO Q5A11N.
EXECUTE.

RECODE Q5A12 (1 thru 12=1) (ELSE=SYSMIS) INTO Q5A12N.
EXECUTE.

RECODE Q5A13 (1 thru 12=1) (ELSE=SYSMIS) INTO Q5A13N.
EXECUTE.

RECODE Q5A14 (1 thru 12=1) (ELSE=SYSMIS) INTO Q5A14N.
EXECUTE.

RECODE Q5A15 (1 thru 12=1) (ELSE=SYSMIS) INTO Q5A15N.
EXECUTE.

RECODE Q5A16 (1 thru 12=1) (ELSE=SYSMIS) INTO Q5A16N.
EXECUTE.

RECODE Q5A17 (1 thru 12=1) (ELSE=SYSMIS) INTO Q5A17N.
EXECUTE.

RECODE Q5A18 (1 thru 12=1) (ELSE=SYSMIS) INTO Q5A18N.
EXECUTE.

RECODE Q5A19 (1 thru 12=1) (ELSE=SYSMIS) INTO Q5A19N.
EXECUTE.

RECODE Q5A110 (1 thru 12=1) (ELSE=SYSMIS) INTO Q5A110N.
EXECUTE.

RECODE Q5A111 (1 thru 12=1) (ELSE=SYSMIS) INTO Q5A111N.
EXECUTE.

RECODE Q5A112 (1 thru 12=1) (ELSE=SYSMIS) INTO Q5A112N.
EXECUTE.

COMPUTE EMP_MONTHS= SUM(Q5A11N, Q5A12N, Q5A13N, Q5A14N, Q5A15N, Q5A16N, Q5A17N, Q5A18N, Q5A19N, Q5A110N, Q5A111N, Q5A112N).
EXECUTE.
RECODE EMP_MONTHS (1 thru 4=1) (5 THRU 8=2) (9 THRU 12=3) (ELSE=1) INTO EMP_MONTHS1.
EXECUTE. 

CTABLES
/TABLE Hills > EMP_MONTHS1 [COUNT COLPCT.COUNT] BY IC
/CATEGORIES VARIABLES=Hills TOTAL=YES
/TITLES TITLE= "Engagement in gainful employemnt".

MRSETS
/MCGROUP NAME =$Q5A2 LABEL ="How does the household meet expenditure in the months when members are not gainfully employed" VARIABLES = Q5A21 Q5A22 Q5A23 Q5A24 .
EXECUTE.
CTABLES
/TABLE Hills > $Q5A2 [COUNT COLPCT.COUNT] BY IC
/CATEGORIES VARIABLES=Hills TOTAL=YES
/TITLES TITLE="How does the household meet expenditure in the months when members are not gainfully employed".

MRSETS
/MCGROUP NAME =$Q5A3 LABEL ="If the household has any emergency expenditure within the non-earning months how do they resolve the problem?" VARIABLES = Q5A31 Q5A32 Q5A33 Q5A34.
EXECUTE.
CTABLES
/TABLE Hills > $Q5A3 [COUNT COLPCT.COUNT] BY IC
/CATEGORIES VARIABLES=Hills TOTAL=YES
/TITLES TITLE="If the household has any emergency expenditure within the non-earning months, how do they resolve the problem?".

SORT CASES BY WORKER.
SPLIT FILE SEPARATE BY WORKER.
EXECUTE.

CTABLES
/TABLE Hills > EMP_MONTHS1 > C10A [COUNT COLPCT.COUNT] BY IC
/CATEGORIES VARIABLES=Hills TOTAL=YES.
SPLIT FILE OFF.



*6. Household Income

        *Computing agri_income 

*GET 
  FILE='E:\AMS_Work\MeghaLamp\Meghalamp HHRI.sav'. 

COMPUTE UID=(LOC*100+SN).
EXECUTE.


*HHRI

TABLES
  /FORMAT BLANK MISSING('.')
  /OBSERVATION= Agri_income
  /GBASE=CASES
  /TABLE=UID BY Agri_income
  /STATISTICS
  Sum( Agri_income)
  Validn( Agri_income( NEQUAL5.0 )).

*HHRI- Agri Expenses

TABLES
  /FORMAT BLANK MISSING('.')
  /OBSERVATION= Q62H
  /GBASE=CASES
  /TABLE=UID BY Q62H
  /STATISTICS
  Sum( Q62H)
  Validn( Q62H( NEQUAL5.0 )).


TABLES
  /FORMAT BLANK MISSING('.')
  /OBSERVATION= Q62I
  /GBASE=CASES
  /TABLE=UID BY Q62I
  /STATISTICS
  Sum( Q62I)
  Validn( Q62I( NEQUAL5.0 )).


TABLES
  /FORMAT BLANK MISSING('.')
  /OBSERVATION= Q62J
  /GBASE=CASES
  /TABLE=UID BY Q62J
  /STATISTICS
  Sum( Q62J)
  Validn( Q62J( NEQUAL5.0 )).


TABLES
  /FORMAT BLANK MISSING('.')
  /OBSERVATION= Q62K
  /GBASE=CASES
  /TABLE=UID BY Q62K
  /STATISTICS
  Sum( Q62K)
  Validn( Q62K( NEQUAL5.0 )).


TABLES
  /FORMAT BLANK MISSING('.')
  /OBSERVATION= Q62L
  /GBASE=CASES
  /TABLE=UID BY Q62L
  /STATISTICS
  Sum( Q62L)
  Validn( Q62L( NEQUAL5.0 )).

*Compute Agri_income from the outputs from syntax given above


*Computing income from livestock

*GET 
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

TABLES
  /FORMAT BLANK MISSING('.')
  /OBSERVATION= Q631D
  /GBASE=CASES
  /TABLE=UID BY Q631D
  /STATISTICS
  Sum( Q631D)
  Validn( Q631D( NEQUAL5.0 )).

TABLES
  /FORMAT BLANK MISSING('.')
  /OBSERVATION= Q631E
  /GBASE=CASES
  /TABLE=UID BY Q631E
  /STATISTICS
  Sum( Q631E)
  Validn( Q631E( NEQUAL5.0 )).

*GET 
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


*GET 
  FILE='E:\AMS_Work\MeghaLamp\Meghalamp HH3.sav'. 

COMPUTE TOT_Income_M= (TOT_Income/12).
EXECUTE.

RECODE TOT_Income (0=SYSMIS) (ELSE=COPY) INTO TOT_Income1.
EXECUTE.
RECODE TOT_Income_M  (0=SYSMIS) (ELSE=COPY) INTO TOT_Income_M1.
EXECUTE.

CTABLES
/TABLE Hills > (TOT_Income1+TOT_Income_M1) [PTILE 10 PTILE 20 PTILE 30 PTILE 40 PTILE 50 PTILE 60 PTILE 70 PTILE 80 PTILE 90 PTILE 95 PTILE 99] BY IC
/CATEGORIES VARIABLES=Hills TOTAL=YES
/TITLES TITLE="Total Income & Monthly Income Percentiles".


CTABLES
/TABLE HHead_Edu > (TOT_Income1+TOT_Income_M1) [PTILE 10 PTILE 20 PTILE 30 PTILE 40 PTILE 50 PTILE 60 PTILE 70 PTILE 80 PTILE 90 PTILE 95 PTILE 99] BY IC
/CATEGORIES VARIABLES=HHead_Edu TOTAL=YES
/TITLES TITLE= "Household Heads' Education Category wise total Income & Monthly Income Percentiles".

CTABLES
/TABLE  (TOT_Income1+TOT_Income_M1) [PTILE 10 PTILE 20 PTILE 30 PTILE 40 PTILE 50 PTILE 60 PTILE 70 PTILE 80 PTILE 90 PTILE 95 PTILE 99] BY IC
/TITLES TITLE="Total Income & Monthly Income Percentiles".


CTABLES
/TABLE (Agri_income+ Livestock_income+ Income_641+ Income_642+Income_643+Income_644+Income_645+Income_646+Income_647+Q648B+Q649B+Q6410B+Q6411B+Income_payment_remittances+TOT_Income+TOT_Income1) [COUNT MEAN MEDIAN] BY IC
/TITLES TITLE ="Contribution of various Income Sources to the Household Economy".

CTABLES
/TABLE Hills > Tot_income1 [COUNT MEAN MEDIAN] BY IC
/CATEGORIES VARIABLES=Hills TOTAL=YES
/TITLES TITLE="Average Household Income".

        *Per capita income and related tables

*GET 
  FILE='E:\AMS_Work\MeghaLamp\Meghalamp HH3.sav'. 

COMPUTE PCI= (TOT_Income/Members).
EXECUTE.

CTABLES
/TABLE Hills > Q112 > PCI [COUNT MEAN MEDIAN] BY IC
/CATEGORIES VARIABLES=Hills TOTAL=YES
/TITLES TITLE="Per capita Income- Economic Category Wise"
/TABLE Hills > HHead_Edu > PCI [COUNT MEAN MEDIAN] BY IC
/CATEGORIES VARIABLES=Hills TOTAL=YES
/TITLES TITLE="Per capita Income- household Heads' Education Wise".

CTABLES
/TABLE Hills > PCI [COUNT MEAN MEDIAN] BY IC
/CATEGORIES VARIABLES=Hills TOTAL=YES
/TITLES TITLE="Per capita IncomeDistribution".

CTABLES
/TABLE HHead_Edu > PCI [COUNT MEAN MEDIAN] BY IC
/CATEGORIES VARIABLES=HHEad_Edu TOTAL=YES
/TITLES TITLE="Per capita IncomeDistribution".



*CTABLES
/TABLE (Q111) BY IC [COUNT] 
/TABLE (Q111) BY IC > (TOT_Income + PCI) [MEAN]
/CATEGORIES VARIABLES=Q111 TOTAL=YES
/TITLES TITLE= "Mean Household Income and Mean per capita Income of  Households across various socio-economic categories".

*CTABLES
/TABLE (HHead_Edu) BY IC [COUNT] 
/TABLE (HHead_Edu) BY IC > (TOT_Income + PCI) [MEAN]
/CATEGORIES VARIABLES=HHead_Edu TOTAL=YES
/TITLES TITLE= "Mean Household Income and Mean per capita Income of  Households across various socio-economic categories".

        *Income from various sources

*GET 
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

COMPUTE V64N=2.
IF (V641=1 OR V642=1 OR V643=1 OR V644=1 OR V645=1 OR V646=1 OR V647=1) V64N=1.

CTABLES
/TABLE (V62+V63+V641+V642+V643+V644+V645+V646+V647+V648+V649+V6410+V6411+V65+V64N) [COLPCT.COUNT COUNT] BY IC
/TITLES TITLE= " Proportion of HHs Earning from Various Sources".


SORT CASES BY Hills.
SPLIT FILE SEPARATE BY Hills.
CTABLES
/TABLE (V62+V63+V641+V642+V643+V644+V645+V646+V647+V648+V649+V6410+V6411+V65) [COLPCT.COUNT COUNT] BY IC
/CATEGORIES VARIABLES= V62 V63 V641 V642 V643 V644 V645 V646 V647 V648 V649 V6410 V6411 V65 TOTAL=YES
/TITLES TITLE= " Proportion of HHs Earning from Various Sources".
SPLIT FILE OFF.

*CTABLES
/TABLE (Q111 + HHead_Edu) BY IC > (V62+V63+V641+V642+V643+V644+V645+V646+V647+V648+V649+V6410+V6411+V65) [ROWPCT.COUNT COUNT] 
/CATEGORIES VARIABLES= V62 V63 V641 V642 V643 V644 V645 V646 V647 V648 V649 V6410 V6411 V65 TOTAL=YES
/TITLES TITLE= " Proportion of HHs Earning from Various Sources".



* 7. Consumption Expenditure  

         *Food expenses

RECODE Q711 Q712 Q713 Q714 Q715 Q716 Q717 Q718 Q719 Q7110 Q7111 Q7112 (MISSING=0). 
EXECUTE.
COMPUTE Food_Expenses= (Q711+Q712+Q713+Q714+Q715+Q716+Q717+Q718+Q719+Q7110+Q7111+Q7112).
EXECUTE.
SORT CASES BY IC.
SPLIT FILE SEPARATE BY IC.
EXAMINE Q711 Q712 Q713 Q714 Q715 Q716 
/STATISTICS DESCRIPTIVES.
EXAMINE Q717 Q718 Q719 Q7110 Q7111 Q7112 Food_Expenses
/STATISTICS DESCRIPTIVES.
SPLIT FILE OFF.

         *Non-food expenses

RECODE Q721 Q722 Q723 Q724 Q725 Q726 Q727 Q728 (MISSING=0).
EXECUTE.
COMPUTE Non_Food_Expenses= (Q721+Q722+Q723+Q724+Q725+Q726+Q727+Q728).
EXECUTE.
SORT CASES BY IC.
SPLIT FILE SEPARATE BY IC.
EXAMINE Q721 Q722 Q723 Q724 Q725 Q726 Q727 Q728 Non_Food_Expenses
/STATISTICS DESCRIPTIVES.
SPLIT FILE OFF.

         *Other annual expenses

RECODE Q731 Q732 Q733 Q734 Q735 Q736 (MISSING=0).
EXECUTE.
COMPUTE Other_Annual_Expenses= (Q731+Q732+Q733+Q734+Q735+Q736).
EXECUTE.
SORT CASES BY IC.
SPLIT FILE SEPARATE BY IC. 
EXAMINE  Q731 Q732 Q733 Q734 Q735 Q736 Other_Annual_Expenses
/STATISTICS DESCRIPTIVES.
SPLIT FILE OFF.
        *Contingency expenses

RECODE Q741 Q742 Q743 Q744 Q745 Q746 (MISSING=0).
EXECUTE.
COMPUTE Contingency_Expenses= (Q741+Q742+Q743+Q744+Q745+Q746).
EXECUTE.
EXAMINE  Q741 Q742 Q743 Q744 Q745 Q746 Contingency_Expenses
/STATISTICS DESCRIPTIVES.

        *Total Expenses

COMPUTE Total_Consumption_Expenses= (Food_Expenses*12 + Non_Food_Expenses*12 + Other_Annual_Expenses).
EXECUTE.
COMPUTE Total_Annual_Expenses = (Food_Expenses*12 + Non_Food_Expenses*12 + Other_Annual_Expenses + Contingency_Expenses).
EXECUTE. 
EXAMINE Total_Annual_Expenses
/STATISTICS DESCRIPTIVES.


CTABLES
/TABLE Hills BY IC > Total_Consumption_Expenses [COUNT MEAN MEDIAN]
/CATEGORIES VARIABLES= Hills TOTAL=YES
/TITLES TITLE="Total Consumption Expenses".

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
      

*GET 
  FILE='E:\AMS_Work\MeghaLamp\Meghalamp HHR81.sav'.

COMPUTE UID= (LOC*100+SN).
EXECUTE.
COMPUTE UID1= (LOC*100000+SN*100+Q81SN).
EXECUTE.

*calculation of Saver households and number of savers in households, and exporting the data to HH file

RECODE Q81B Q81C Q81D (0=SYSMIS).
EXECUTE.

TABLES
  /FORMAT BLANK MISSING('.')
  /OBSERVATION= Q81D
  /GBASE=CASES
  /TABLE=UID BY Q81D
  /STATISTICS
  Sum( Q81D)
  Validn( Q81D( NEQUAL5.0 )).


*GET 
  FILE='E:\AMS_Work\MeghaLamp\Meghalamp HH3.sav'.


COMPUTE Saver_HH=2.
EXECUTE.
IF (No_Savers > 0) Saver_HH=1.
EXECUTE.

CTABLES
/TABLE Hills > Saver_HH [COUNT COLPCT.COUNT] BY IC
/CATEGORIES VARIABLES=Hills TOTAL=YES
/TITLES TITLE="Distribution of Households that had made any savings in the past One Year"
/TABLE Hills > HHead_Edu> Saver_HH [COUNT COLPCT.COUNT] BY IC
/CATEGORIES VARIABLES=Hills TOTAL=YES
/TITLES TITLE="Household Heads' Education wise distribution of households that had made any savings in the past one year"
/TABLE Hills > Q112 > Saver_HH [COUNT COLPCT.COUNT] BY IC
/CATEGORIES VARIABLES=Hills TOTAL=YES
/TITLES TITLE="Economic category wise distribution of households that had made any savings in the past one year".

CTABLES
/TABLE HHead_Edu> Saver_HH [COUNT COLPCT.COUNT] BY IC
/CATEGORIES VARIABLES=HHead_Edu TOTAL=YES
/TITLES TITLE="Household Heads' Education wise distribution of households that had made any savings in the past one year"
/TABLE Q112 > Saver_HH [COUNT COLPCT.COUNT] BY IC
/CATEGORIES VARIABLES=Q112 TOTAL=YES
/TITLES TITLE="Economic category wise distribution of households that had made any savings in the past one year".


*CTABLES
/TABLE Q111 BY IC>Savers [COUNT ROWPCT.COUNT]
/CATEGORIES VARIABLES=Q111 TOTAL=YES
/TITLES TITLE= "Social Category-wise Distribution of Households that had made any savings in the past One Year"
/TABLE HHead_Edu BY IC > Savers [COUNT ROWPCT.COUNT]
/CATEGORIES VARIABLES=HHead_Edu TOTAL=YES
/TITLES TITLE= "HH Head Education Category-wise Distribution of Households that had made any savings in the past One Year".


*GET 
  FILE='E:\AMS_Work\MeghaLamp\Meghalamp HHR81.sav'.

*FREQUENCIES UID.

        * Distribution of Households with respect to number of members saving money

RECODE No_Savers (0=SYSMIS) (ELSE=COPY) INTO No_savers1.
EXECUTE.
CTABLES
/TABLE Hills > No_Savers1 [COUNT COLPCT.COUNT] BY IC
/CATEGORIES VARIABLES=No_savers1 TOTAL=YES
/TITLES TITLE= " Distribution of Households with respect to number of members saving money".

CTABLES
/TABLE Hills > No_Savers1 [COUNT COLPCT.COUNT] BY IC
/CATEGORIES VARIABLES=Hills TOTAL=YES
/TITLES TITLE= " Distribution of Households with respect to number of members saving money".

*CTABLES
/TABLE Savers_no [COUNT COLPCT.COUNT] BY IC
/CATEGORIES VARIABLES=savers_no TOTAL=YES
/TITLES TITLE= " Distribution of Households with respect to number of members saving money".

        *Quantum of savings

RECODE Saving (99=0) (198=0) (ELSE=COPY) INTO Saving1.
EXECUTE.
CTABLES
/TABLE Hills > Saving1 [MINIMUM MAXIMUM MEAN MEDIAN] BY IC
/CATEGORIES VARIABLES=Hills TOTAL=YES
/TITLES TITLE="Quantum of Savings made by households in the past one year".

CTABLES
/TABLE Q81D [MINIMUM MAXIMUM MEAN MEDIAN] BY IC
/TITLES TITLE= " Quantum of Savings made by  Intervention Households in the past one year preceding the survey".

COMPUTE UID1= LOC*100000 + SN*100 + MSN.
EXECUTE.

DO IF (C4  < 15). 
RECODE Saving_Amount (ELSE=SYSMIS).
END IF. 
EXECUTE.
RECODE Saving_Amount (99=SYSMIS).
EXECUTE.

COMPUTE SAVING=2.
EXECUTE.
IF (Saving_Amount > 0) SAVING=1.
IF (C4 < 15) SAVING=3.
RECODE SAVING (3=SYSMIS).
EXECUTE.

CTABLES
/TABLE AgeCat1 > Saving [COUNT COLPCT.COUNT] BY IC
/CATEGORIES VARIABLES=AgeCat1 TOTAL=YES
/TITLES TITLE="Age Category wise Proportion of Savers".

CTABLES
/TABLE EduCat1 > Saving [COUNT COLPCT.COUNT] BY IC
/CATEGORIES VARIABLES=EduCat1 TOTAL=YES
/TITLES TITLE="Education Category wise Proportion of Savers".

CTABLES
/TABLE C3 > Saving [COUNT COLPCT.COUNT] BY IC
/CATEGORIES VARIABLES=C3 TOTAL=YES
/TITLES TITLE="Gender wise Proportion of Savers".

*9. Investment & Insurance



COMPUTE Any_investment=2.
EXECUTE.
IF (Q821A=1 OR Q822A=1 OR Q823A=1 OR Q824A=1 OR Q825A=1 OR Q826A=1 OR Q827A=1 OR Q828A=1) Any_investment=1.
EXECUTE.

COMPUTE Total_investment= SUM(Q821D, Q822D, Q823D, Q824D, Q825D, Q826D, Q827D, Q828D).
EXECUTE.

CTABLES
/TABLE Hills > Any_investment [COUNT COLPCT.COUNT] BY IC
/CATEGORIES VARIABLES=Hills TOTAL=YES
/TITLES TITLE="Geographical Region wise Distribution of Households that made any Investment in Last 1 year".

CTABLES
/TABLE HHead_Edu > Any_investment [COUNT COLPCT.COUNT] BY IC
/CATEGORIES VARIABLES=HHead_Edu TOTAL=YES
/TITLES TITLE="Household Heads' Education wise Distribution of Households that made any Investment in Last 1 year"
/TABLE Q112 > Any_investment [COUNT COLPCT.COUNT] BY IC
/CATEGORIES VARIABLES=Any_investment TOTAL=YES
/TITLES TITLE="Economic Category wise Distribution of Households that made any Investment in Last 1 year".

CTABLES
/TABLE Q111  BY IC > Any_investment [COUNT ROWPCT.COUNT]
/CATEGORIES VARIABLES= Q111 TOTAL=YES 
/TITLES TITLE= "Distribution of households that made any investment in Last 1 year by social category"
/TABLE HHead_Edu  BY IC > Any_investment [COUNT ROWPCT.COUNT]
/CATEGORIES VARIABLES= HHead_Edu TOTAL=YES 
/TITLES TITLE= "Distribution of households that made any investment in Last 1 year by education of the head of the household".

CTABLES
/TABLE Hills BY IC > (Q821A+Q822A+Q823A+Q824A+Q825A+Q826A+Q827A+Q828A) [COUNT ROWPCT.COUNT]
/CATEGORIES VARIABLES=Hills TOTAL=YES
/TITLES TITLE= "Pattern of Investment by Geographical Area"
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
/TABLE Hills [COUNT ROWPCT.COUNT] BY IC > (Q831 + Q832)
/CATEGORIES VARIABLES=Hills TOTAL=YES
/TITLES TITLE = "Life Insurance & Health Insurance by Geographical Region"
/TABLE Q112 [COUNT ROWPCT.COUNT] BY IC > (Q831 + Q832)
/CATEGORIES VARIABLES=Q112 TOTAL=YES
/TITLES TITLE = "Life Insurance & Health Insurance by Economic category"
/TABLE HHead_Edu [COUNT ROWPCT.COUNT] BY IC > (Q831 + Q832)
/CATEGORIES VARIABLES=HHead_Edu TOTAL=YES
/TITLES TITLE = "Life Insurance & Health Insurance by education of the head of the household".


*9. Food Security and Health 

CTABLES
/TABLE Hills > (Q91A+Q92A+Q93A+Q94A+Q95A+Q96A+Q97A+Q98A+Q99A) [COUNT COLPCT.COUNT] BY IC
/CATEGORIES VARIABLES=Hills TOTAL=YES
/TITLES TITLE= "Incidence of Food Insecurity".

RECODE  Q91B Q92B Q93B Q94B Q95B Q96B Q97B Q98B Q99B (0=SYSMIS).
EXECUTE.

CTABLES
/TABLE Hills > (Q91B+Q92B+Q93B+Q94B+Q95B+Q96B+Q97B+Q98B+Q99B) [COUNT COLPCT.COUNT] BY IC
/CATEGORIES VARIABLES=Hills TOTAL=YES
/TITLES TITLE="Frequency of Food Insecure Days".

*CTABLES
/TABLE (Q91A+Q92A+Q93A+Q94A+Q95A+Q96A+Q97A+Q98A+Q99A) [COUNT COLPCT.COUNT] BY IC
/TITLES TITLE= "Incidence of Food Insecurity in Sampled Households in the Past 4 Weeks Preceding the Survey" 
/TABLE (Q91B+Q92B+Q93B+Q94B+Q95B+Q96B+Q97B+Q98B+Q99B) [COUNT COLPCT.COUNT] BY IC
/TITLES TITLE= "Incidence of Food Insecurity in the Past 4 Weeks Preceding the Survey". 

MRSETS
/MCGROUP NAME =$Q91C LABEL ="How dId you resolve the crisis-1" VARIABLES =Q91C1 Q91C2 Q91C3 Q91C4.
EXECUTE.
CTABLES
/TABLE Hills > $Q91C [COUNT COLPCT.COUNT] BY IC
/CATEGORIES VARIABLES=Hillls TOTAL=YES 
/TITLES TITLE="How did you resolve the crisis-1".

*MRSETS
/MCGROUP NAME =$Q92C LABEL ="How dId you resolve the crisis-2" VARIABLES =Q92C1 Q92C2 Q92C3 Q92C4.
*EXECUTE.
CTABLES
/TABLE $Q92C [COUNT COLPCT.COUNT] BY IC
/TITLES TITLE="How did you resolve the crisis-2".
*/CATEGORIES VARIABLES=Hillls TOTAL=YES 

*MRSETS
/MCGROUP NAME =$Q93C LABEL ="How dId you resolve the crisis-3" VARIABLES =Q93C1 Q93C2 Q93C3 Q93C4.
*EXECUTE.
CTABLES
/TABLE $Q93C [COUNT COLPCT.COUNT] BY IC
/TITLES TITLE="How did you resolve the crisis-3".
*/CATEGORIES VARIABLES=Hillls TOTAL=YES 



*MRSETS
/MCGROUP NAME =$Q94C LABEL ="How dId you resolve the crisis-4" VARIABLES =Q94C1 Q94C2 Q94C3 Q94C4.
*EXECUTE.
CTABLES
/TABLE $Q94C [COUNT COLPCT.COUNT] BY IC
/TITLES TITLE="How did you resolve the crisis-4".
*/CATEGORIES VARIABLES=Hillls TOTAL=YES 

*MRSETS
/MCGROUP NAME =$Q95C LABEL ="How dId you resolve the crisis-5" VARIABLES =Q95C1 Q95C2 Q95C3 Q95C4.
*EXECUTE.
CTABLES
/TABLE $Q95C [COUNT COLPCT.COUNT] BY IC
 /TITLES TITLE="How did you resolve the crisis-5".
*/CATEGORIES VARIABLES=Hillls TOTAL=YES

*MRSETS
/MCGROUP NAME =$Q96C LABEL ="How dId you resolve the crisis-6" VARIABLES =Q96C1 Q96C2 Q96C3 Q96C4.
*EXECUTE.
CTABLES
/TABLE $Q96C [COUNT COLPCT.COUNT] BY IC
/TITLES TITLE="How did you resolve the crisis-6".
*/CATEGORIES VARIABLES=Hillls TOTAL=YES 

*MRSETS
/MCGROUP NAME =$Q97C LABEL ="How dId you resolve the crisis-7" VARIABLES =Q97C1 Q97C2 Q97C3 Q97C4.
*EXECUTE.
CTABLES
/TABLE $Q97C [COUNT COLPCT.COUNT] BY IC
/TITLES TITLE="How did you resolve the crisis-7".
*/CATEGORIES VARIABLES=Hillls TOTAL=YES 

*MRSETS
/MCGROUP NAME =$Q98C LABEL ="How dId you resolve the crisis-8" VARIABLES =Q98C1 Q98C2 Q98C3 Q98C4.
*EXECUTE.
CTABLES
/TABLE $Q98C [COUNT COLPCT.COUNT] BY IC
/TITLES TITLE="How did you resolve the crisis-8".
*/CATEGORIES VARIABLES=Hillls TOTAL=YES 

*MRSETS
/MCGROUP NAME =$Q99C LABEL ="How dId you resolve the crisis-9" VARIABLES =Q99C1 Q99C2 Q99C3 Q99C4.
*EXECUTE.
CTABLES
/TABLE $Q99C [COUNT COLPCT.COUNT] BY IC
/TITLES TITLE="How did you resolve the crisis-9".
*/CATEGORIES VARIABLES=Hillls TOTAL=YES 


CTABLES
/TABLE Hills > Q910 [COUNT COLPCT.COUNT] BY IC
/CATEGORIES VARIABLES=Hills TOTAL=YES
/TITLES TITLE="Q910-Was there ever any time when your household had any food scarcity".

MRSETS
/MCGROUP NAME =$Q9101 LABEL ="Q9101-How did your household cope up with such situation?" VARIABLES = Q9101A Q9101B Q9101C Q9101D. 
EXECUTE.
CTABLES
/TABLE Hills > $Q9101 [COUNT COLPCT.COUNT] BY IC
/CATEGORIES VARIABLES=Hills TOTAL=YES
/TITLES TITLE="Q9101-How did your household cope up with such situation?".

CTABLES
/TABLE Hills > Q911 [COUNT COLPCT.COUNT] BY IC
/CATEGORIES VARIABLES=Hills TOTAL=YES
/TITLES TITLE="For how many days in a year is food shortage in the household?".



    *Anthro analysis to be done using WHO Anthropac

       
*10. Women Empowerment



CTABLES
/TABLE (Q104+Q105+Q106) [COUNT COLPCT.COUNT] BY IC
/TITLES TITLE= "Ownership of Assets by Women".



*GET 
  FILE='E:\AMS_Work\MeghaLamp\Meghalamp HH3.sav'.

CTABLES
/TABLE Hills > (Q1011+Q1012+Q1013+Q1014+Q1015) [COUNT COLPCT.COUNT] BY IC 
/CATEGORIES VARIABLES=Hills TOTAL=YES
/TITLES TITLE="Status of women mobility".

SORT CASES BY IC.
SPLIT FILE SEPARATE BY IC.
CTABLES
/TABLE HHead_Edu > (Q1011+Q1012+Q1013+Q1014+Q1015) [COUNT COLPCT.COUNT] BY Hills
/CATEGORIES VARIABLES=Hills TOTAL=YES
/TITLES TITLE="Status of women mobility by education status of the head of the household".
SPLIT FILE OFF.


*CTABLES
/TABLE Q111 BY IC > (Q1011+Q1012+Q1013+Q1014+Q1015) [COUNT ROWPCT.COUNT]
/CATEGORIES VARIABLES=Q111 TOTAL=YES
/TITLES TITLE="Status of women mobility by social category"
/TABLE HHead_Edu BY IC > (Q1011+Q1012+Q1013+Q1014+Q1015) [COUNT ROWPCT.COUNT]
/TITLES TITLE="Status of women mobility by education status of the head of the household".

CTABLES
/TABLE Hills >Q1021 [COUNT COLPCT.COUNT] BY IC
/CATEGORIES VARIABLES=Hills TOTAL=YES
/TITLES TITLE='Participation of Women in Household Decision Making-1'
/TABLE Hills >Q1022 [COUNT COLPCT.COUNT] BY IC
/CATEGORIES VARIABLES=Hills TOTAL=YES
/TITLES TITLE='Participation of Women in Household Decision Making-2'
/TABLE Hills >Q1023 [COUNT COLPCT.COUNT] BY IC
/CATEGORIES VARIABLES=Hills TOTAL=YES
/TITLES TITLE='Participation of Women in Household Decision Making-3'
/TABLE Hills >Q1024 [COUNT COLPCT.COUNT] BY IC
/CATEGORIES VARIABLES=Hills TOTAL=YES
/TITLES TITLE='Participation of Women in Household Decision Making-4'
/TABLE Hills >Q1025 [COUNT COLPCT.COUNT] BY IC
/CATEGORIES VARIABLES=Hills TOTAL=YES
/TITLES TITLE='Participation of Women in Household Decision Making-5'
/TABLE Hills >Q1026 [COUNT COLPCT.COUNT] BY IC
/CATEGORIES VARIABLES=Hills TOTAL=YES
/TITLES TITLE='Participation of Women in Household Decision Making-6'
/TABLE Hills >Q1027 [COUNT COLPCT.COUNT] BY IC
/CATEGORIES VARIABLES=Hills TOTAL=YES
/TITLES TITLE='Participation of Women in Household Decision Making-7'.



*CTABLES
/TABLE (Q1021+Q1022+Q1023+Q1024+Q1025+Q1026+Q1027) [COUNT COLPCT.COUNT] BY IC 
/TITLES TITLE="Participation of Women in Household Decision Making in the Intervention Area".


*11. Livelihood Support Groups

CTABLES
/TABLE Hills > Q112 > Q111_A [COUNT COLPCT.COUNT] BY IC 
/CATEGORIES VARIABLES=Hills TOTAL=YES
/TITLES TITLE="Proportion of Households Registered at EFC".

CTABLES
/TABLE Hills > Q111_A [COUNT COLPCT.COUNT] BY IC 
/CATEGORIES VARIABLES=Hills TOTAL=YES
/TITLES TITLE="Proportion of Households Registered at EFC".



        *Calculation of Q112 Roster

*GET 
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
/TABLE EduCat1 > C3 [TABLEPCT.COUNT COUNT] BY IC > C10A
/CATEGORIES VARIABLES= EduCat1 C3 IC C10A  TOTAL=YES 
/TITLE TITLE="Experiment Table".

*COMPUTE Filter_Q131=(LOC=175).
*EXECUTE.
*FILTER BY Filter_Q131.
*EXECUTE.

*Awareness about IBDLP basin programme

CTABLES
/TABLE Hills > Q131 [COUNT COLPCT.COUNT] BY IC 
/CATEGORIES VARIABLES=Hills TOTAL=YES
/TITLES TITLE= "Percentage of Respondents aware of the IBDLP/Basin Programme".


*CTABLES
/TABLE Q131 BY IC [COUNT COLPCT.COUNT]
/CATEGORIES VARIABLES=Q131 TOTAL=YES
/TITLES TITLE= "Percentage of Respondents aware of the IBDLP/Basin Programme".


MRSETS 
/MCGROUP NAME =$Q132 LABEL ="How did you learn about IBDLP Basin Programme?" VARIABLES = Q132A Q132B Q132C Q132D.
EXECUTE.
CTABLES
/TABLE Hills > $Q132 [COUNT COLPCT.COUNT] BY IC 
/CATEGORIES VARIABLES=Hills TOTAL= YES.

MRSETS 
/MCGROUP NAME =$Q133 LABEL ='Have you received any benefit by being associated with IDBLP Basin Programme?' VARIABLES = Q133A Q133B Q133C Q133D.
EXECUTE.
CTABLES
/TABLE Hills > $Q133 [COUNT COLPCT.COUNT] BY IC 
/CATEGORIES VARIABLES=Hills TOTAL= YES
/TITLES TITLE= "Benefits received by being associated with IBDLP/Basin Programme in intervention area".


CTABLES
/TABLE Hills > Q134 [MEAN] BY IC
/CATEGORIES VARIABLES= Hills TOTAL= YES.

FREQUENCIES Q1341 Q1342 Q136.

FREQUENCIES Q1341 Q1342 Q136.


MRSETS 
/MCGROUP NAME =$Q135 LABEL ='What support do you expect from IBDLP Basin Programme?' VARIABLES = Q135A Q135B Q135C Q135D.
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


*@@@@@@@@@@ Landholding @@@@@@@@@@@@

COMPUTE Landholding= SUM(Landholding1,Landholding4,Landholding5).
EXECUTE.
RECODE Landholding (SYSMIS=0).
EXECUTE.
SORT CASES BY IC.
SPLIT FILE SEPARATE BY IC.
DESCRIPTIVES Landholding.
SPLIT FILE OFF.



FREQUENCIES Q831 Q832 Q833 Q834.

***** @@@@@@@ Remaining RFP Indicators @@@@@@@@************************


CTABLES
/TABLE Hills > Q114A [COUNT COLPCT.COUNT] BY IC
/CATEGORIES VARIABLES=Hills TOTAL=YES
/TITLES TITLE="Occupation of the Household".

*HHR- School going status

COMPUTE C6A=C6.
IF (C4> 14 OR C4<6) C6A= $SYSMIS.
EXECUTE.

RECODE C6A (5 thru 14= 1) (0=1).
EXECUTE.
CTABLES
/TABLE Hills > C6A [COUNT COLPCT.COUNT] BY IC
/CATEGORIES VARIABLES=Hills TOTAL=YES
/TITLES TITLE="School going status of the children".

*HH- Ethnicity

SORT CASES BY IC.
SPLIT FILE SEPARATE BY IC.
FREQUENCIES Q113.
SPLIT FILE OFF.

*HH- Housing details

CTABLES
/TABLE Q311 [COUNT COLPCT.COUNT] BY IC
/TABLE Q312 [COUNT COLPCT.COUNT] BY IC
/TABLE Q313 [COUNT COLPCT.COUNT] BY IC
/TABLE Q32 [COUNT MEAN] BY IC
/TITLES TITLE="Housing Details".

*HH- Water Supply 

CTABLES
/TABLE Q37 [COUNT COLPCT.COUNT] BY IC
/CATEGORIES VARIABLES=Q37 TOTAL=YES
/TITLES TITLE="Primary Source of Drinking Water".

FREQUENCIES Q37.

CTABLES
/TABLE Q371 [COUNT MEAN] BY IC
/TITLES TITLE="Distance of the Source of Drinking Water".

*HH- Toilet

CTABLES
/TABLE Q363 [COUNT COLPCT.COUNT] BY IC
/CATEGORIES VARIABLES=Q363 TOTAL=YES
/TITLES TITLE="Type of latrine"
/TABLE Q362 [COUNT COLPCT.COUNT] BY IC
/CATEGORIES VARIABLES=Q362 TOTAL=YES
/TITLES TITLE="Location of latrine".

*HH -Energy

CTABLES
/TABLE Q38 [COUNT COLPCT.COUNT] BY IC
/CATEGORIES VARIABLES = Q38 TOTAL =YES
/TITLES TITLE="Main Fuel used for Cooking" 
/TABLE Q35 [COUNT COLPCT.COUNT] BY IC
/CATEGORIES VARIABLES = Q35 TOTAL =YES
/TITLES TITLE="Availability of Electricity Connection"
/TABLE Q352 [COUNT MEAN] BY IC
/TITLES TITLE="Average No. of Hours of Electricity Supply". 
 
*HH- Income

CTABLES
/TABLE (Food_expenses + Q731 + Q732+ Q733 + Q734 + Q741 + Q742 + Q743 + Q744 + Q745) [COUNT MEAN] BY IC
/TITLES TITLE= "Expenses"
/TITLES CORNER= "Only Food expenses are monthly All other are annual expenses".

*HH- Assets


IF (Q25A>0) Television=1.
IF MISSING(Q25A) Television=2.
IF Q25A=0 Television=2.
EXECUTE.
IF (Q25B>0) Radio_Transistor=1.
IF MISSING(Q25B) Radio_Transistor=2.
IF Q25B=0 Radio_Transistor=2.
EXECUTE.
IF (Q25C>0) Computer_laptop=1.
IF MISSING(Q25C) Computer_laptop=2.
IF Q25C=0 Computer_laptop=2.
EXECUTE.
IF (Q25D>0) Telephone_mobile=1.
IF MISSING(Q25D) Telephone_mobile=2.
IF Q25D=0 Telephone_mobile=2.
EXECUTE.
IF (Q25E>0) Electric_Fan=1.
IF MISSING(Q25E) Electric_Fan=2.
IF Q25E=0 Electric_Fan=2.
EXECUTE.
IF (Q25F>0) Almirah=1.
IF MISSING(Q25F) Almirah=2.
IF Q25F=0 Almirah=2.
EXECUTE.
IF (Q25G>0) Gas_stove=1.
IF MISSING(Q25G) Gas_stove=2.
IF Q25G=0 Gas_stove=2.
EXECUTE.
IF (Q25H>0) Mixer_grinder=1.
IF MISSING(Q25H) Mixer_grinder=2.
IF Q25H=0 Mixer_grinder=2.
EXECUTE.
IF (Q25I>0) Motorcycle_Scooter=1.
IF MISSING(Q25I) Motorcycle_Scooter=2.
IF Q25I=0 Motorcycle_Scooter=2.
EXECUTE.
IF (Q25J>0) Bicycle=1.
IF MISSING(Q25J) Bicycle=2.
IF Q25J=0 Bicycle=2.
EXECUTE.
IF (Q25K>0) Car=1.
IF MISSING(Q25K) Car=2.
IF Q25K=0 Car=2.
EXECUTE.

CTABLES
/TABLE (Television+Radio_Transistor+Computer_laptop+Telephone_mobile+Electric_fan+Almirah+Gas_stove+Mixer_grinder+Motorcycle_scooter+Bicycle+Car) [COUNT COLPCT.COUNT] BY IC
/CATEGORIES VARIABLES=IC TOTAL=YES
/TITLES TITLE="Ownership of HH assets".


*HH - Livestock
*Ownership of different livestock

CTABLES
/TABLE (Cow+Goat+Buffalo+Sheep+Pig+Poultry+Other_animals) [COUNT COLPCT.COUNT] BY IC
/CATEGORIES VARIABLES=IC TOTAL=YES
/TITLES TITLE="Ownership of Different Livestock".

*HHR3

COMPUTE Filter_Q631A1=(Q631A=1).
EXECUTE.
FILTER BY Filter_Q631A1.
CTABLES
/TABLE Q631I [COUNT MEAN] BY IC
/TITLES TITLE="Livestock Products sales_Milk".
FILTER OFF.
USE ALL.

COMPUTE Filter_Q631A2=(Q631A=2).
EXECUTE.
FILTER BY Filter_Q631A2.
CTABLES
/TABLE Q631I [COUNT MEAN] BY IC
/TITLES TITLE="Livestock Products sales_Milk products".
FILTER OFF.
USE ALL.


COMPUTE Filter_Q631A3=(Q631A=3).
EXECUTE.
FILTER BY Filter_Q631A3.
CTABLES
/TABLE Q631I [COUNT MEAN] BY IC
/TITLES TITLE="Livestock Products sales_Meat and Flesh".
FILTER OFF.
USE ALL.

COMPUTE Filter_Q631A4=(Q631A=4).
EXECUTE.
FILTER BY Filter_Q631A4.
CTABLES
/TABLE Q631I [COUNT MEAN] BY IC
/TITLES TITLE="Livestock Products sales_Silk".
FILTER OFF.
USE ALL.

COMPUTE Filter_Q631A5=(Q631A=5).
EXECUTE.
FILTER BY Filter_Q631A5.
CTABLES
/TABLE Q631I [COUNT MEAN] BY IC
/TITLES TITLE="Livestock Products sales_Eggs".
FILTER OFF.
USE ALL.

COMPUTE Filter_Q631A6=(Q631A=6).
EXECUTE.
FILTER BY Filter_Q631A6.
CTABLES
/TABLE Q631I [COUNT MEAN] BY IC
/TITLES TITLE="Livestock Products sales_Fish".
FILTER OFF.
USE ALL.

COMPUTE Filter_Q631A7=(Q631A=7).
EXECUTE.
FILTER BY Filter_Q631A7.
CTABLES
/TABLE Q631I [COUNT MEAN] BY IC
/TITLES TITLE="Livestock Products sales_Chicken".
FILTER OFF.
USE ALL.

COMPUTE Filter_Q631A8=(Q631A=8).
EXECUTE.
FILTER BY Filter_Q631A8.
CTABLES
/TABLE Q631I [COUNT MEAN] BY IC
/TITLES TITLE="Livestock Products sales_Pork".
FILTER OFF.
USE ALL.

COMPUTE Filter_Q631A9=(Q631A=9).
EXECUTE.
FILTER BY Filter_Q631A9.
CTABLES
/TABLE Q631I [COUNT MEAN] BY IC
/TITLES TITLE="Livestock Products sales_Beef".
FILTER OFF.
USE ALL.

*HH

CTABLES
/TABLE Livestock_income [COUNT MEAN] BY IC
/TITLES TITLE= "Livestock Income".

*HHR3

CTABLES
/TABLE Q631D [COUNT MEAN] BY IC
/TITLES TITLE= "Livestock Input Expenses".

*HHRI
*Crop types

RECODE Q62A (0=SYSMIS) (ELSE=COPY) INTO Q62AA.
EXECUTE.
CTABLES
/TABLE Q62AA [COUNT COLPCT.COUNT] BY IC >Hills
/CATEGORIES VARIABLES=Hills TOTAL=YES
/TITLES TITLE= "Crops Produced".

*HH
Irrigation Source


COMPUTE Q214A=Q214.
EXECUTE.
IF (OUTCOME1=2) Q214A=$SYSMIS.
EXECUTE.
RECODE Q214A (0=SYSMIS).
EXECUTE.
CTABLES
/TABLE Hills> Q214A [COUNT COLPCT.COUNT] BY IC
/CATEGORIES VARIABLES=Hills TOTAL=YES
/TITLES TITLE= "Irrigation Source".

*HH
*Agri input expenses

CTABLES
/TABLE Hills> (Seeds+Fertilizers+Pesticides+Wages+Other_agri_expenses) [COUNT MEAN] BY IC
/CATEGORIES VARIABLES=Hills TOTAL=YES
/TITLES TITLE= "Agri-input Expenses".

********** Unforseen Expenses*******

*HH

COMPUTE Unforseen_Exp= SUM(Q741, Q742, Q743, Q744, Q745, Q746).
EXECUTE.

CTABLES
/TABLE Unforseen_Exp [COUNT MEAN MEDIAN] BY IC
/CATEGORIES VARIABLES=IC TOTAL=YES
/TITLES TITLE="Unforseen Expenses".

******** Agri Produce Sold ***************

*HHRI

COMPUTE FIlter_Q61=(Q61=1).
EXECUTE.

SORT CASES BY IC.
SPLIT FILE BY IC.
FILTER BY FIlter_Q61.
DESCRIPTIVES Q62P.
FILTER OFF.
USE ALL.
SPLIT FILE OFF.

SORT CASES BY IC.
SPLIT FILE BY IC.
DESCRIPTIVES Q62P.
SPLIT FILE OFF.

CTABLES
/TABLE UID BY Q61.

SORT CASES BY IC.
SPLIT FILE BY IC.
FREQUENCIES Q61N.
SPLIT FILE OFF.
USE ALL.

TABLES
  /FORMAT BLANK MISSING('.')
  /OBSERVATION= SN
  /GBASE=CASES
  /TABLE=UID BY SN
  /STATISTICS
  Sum( SN)
  Validn( SN( NEQUAL5.0 )).




****Livestock rearing***********

*HHRL

IF (189>LOC) AND (LOC>100) IC=1.
IF (289>LOC) AND (LOC>200) IC=2.
EXECUTE.

COMPUTE UID=(LOC*100+SN).
EXECUTE.

CTABLES
/TABLE UID BY Q63.


SORT CASES BY IC.
SPLIT FILE BY IC.
FREQUENCIES Q63N.
SPLIT FILE OFF.
USE ALL.

*Water Fetching ************

SORT CASES BY IC.
SPLIT FILE BY IC.
FREQUENCIES Q373.
SPLIT FILE OFF.
USE ALL.

SORT CASES BY IC.
SPLIT FILE BY IC.
FREQUENCIES Q374.
SPLIT FILE OFF.
USE ALL.

******* FUEL ************

SORT CASES BY IC.
SPLIT FILE BY IC.
FREQUENCIES Q38.
SPLIT FILE OFF.
USE ALL.


************ JOB CARD************

COMPUTE Filter_Adult=(C4>17).
EXECUTE.

FILTER BY Filter_Adult.
CTABLES
/TABLE C3 > C8 [COUNT COLPCT.COUNT ROWPCT.COUNT] BY IC
/CATEGORIES VARIABLES=C8 TOTAL=YES
/TITLES TITLE="Availability of Job Card".
FILTER OFF.
USE ALL.


******** illiterate **********


CTABLES
/TABLE C3 > EduCat1 [COUNT COLPCT.COUNT ROWPCT.COUNT] BY IC
/CATEGORIES VARIABLES=C8 TOTAL=YES
/TITLES TITLE="Educational Qualification".

***** Vocational Education **************

CTABLES
/TABLE C3 > C7 [COUNT COLPCT.COUNT ROWPCT.COUNT] BY IC
/CATEGORIES VARIABLES=C8 TOTAL=YES
/TITLES TITLE="Vocational Education".

****** School Going Children ************

DO IF (C4 < 6 OR C4 > 14). 
RECODE C6 (ELSE=SYSMIS). 
END IF. 
EXECUTE.

CTABLES
/TABLE C3 > C6 [COUNT COLPCT.COUNT ROWPCT.COUNT] BY IC
/CATEGORIES VARIABLES=C8 TOTAL=YES
/TITLES TITLE="School Going Status".

**** Homestead Plot ***********

CTABLES
/TABLE  Q24B [COUNT COLPCT.COUNT ROWPCT.COUNT] BY IC
/CATEGORIES VARIABLES=Q24B TOTAL=YES
/TITLES TITLE="Ownership of Homestead Plot".


************** Irrigated land *********

COMPUTE Land_I=Q62B.
EXECUTE.
IF (Q62C=1) Land_I = Q62B/107639.
EXECUTE.
IF (Q62C=2) Land_I = Q62B/2.47.
EXECUTE.
IF (Q62C=4) Land_I = Q62B/7.5.
EXECUTE.
SORT CASES BY IC.
SPLIT FILE BY IC.
EXAMINE Land_I.
SPLIT FILE OFF.
USE ALL.
