%let pgm=utl-how-to-create-a-sas-dataset-from-python-panda-dataframe-using-the-personal-altair-slc;

%stop_submission;

Create a sas dataset from python oanda dataframe using the personal altair slc

github
https://tinyurl.com/5n7jw3hh
https://github.com/rogerjdeangelis/utl-how-to-create-a-sas-dataset-from-python-panda-dataframe-using-the-personal-altair-slc

How to fix the export/import problem (untested)

SLC Python export/import fails with newer versions
Python 3.13.0
NumPy version: 2.1.3
Pandas version: 2.2.3

Need to down grade (not tested)
I have too many packages using the newer version

Your python installation is not supported by SLC 2025:
"SLC 2025 requires python ?3.12.9, numpy ?1.26.4 and pandas ?2.2.2"
I'd recommend downgrading python, numpy and panda

SOAPBOX ON

I am new to the ALtait SLC

Altair SLC, proc python, does NOT supprt export/import os sas datasets.
Altair proc R does supprt export/import os sas datasets.
However, python can export panda dataframes to R, using the rds format and
proc R can convert RDS files to sas datasets.

Too long to post here, see github

   CONTENTS
      1 Macro solution
        a. convert panda dataframe to R rds file
        b. macro wps_py2sastable ( R rds file from Python to SAS table)
      2 hardcode no macro
      3 macro & template on end


  SOME NOTES ON The Altair SLC

     Proc R cannot exist in a macro
     Proc R cannot be called using call execute
     Proc R cannot be called using dosubl or %dosubl (neither supported)
     Proc R cannot be called using a macro string (like &_init_;)

     Also looks like the SLC does not support parmcards4;
     ERROR: Expected a statement keyword : found "parmcards4"

     Final resolved prog R code can be included in a macro using %include?

SOPABOX OFF

/*                   _
(_)_ __  _ __  _   _| |_
| | `_ \| `_ \| | | | __|
| | | | | |_) | |_| | |_
|_|_| |_| .__/ \__,_|\__|
        |_|
*/

&_init_;
options
 validvarname=upcase;
libname sd1 sas7bdat "d:/sd1";
data sd1.have;
  input
    name$
    sex$ age;
cards4;
Alfred  M 14
Alice   F 13
Barbara F 13
Carol   F 14
Henry   M 14
James   M 12
;;;;
run;quit;

/*                                              _       _   _
/ |  _ __ ___   __ _  ___ _ __ ___    ___  ___ | |_   _| |_(_) ___  _ __
| | | `_ ` _ \ / _` |/ __| `__/ _ \  / __|/ _ \| | | | | __| |/ _ \| `_ \
| | | | | | | | (_| | (__| | | (_) | \__ \ (_) | | |_| | |_| | (_) | | | |
|_| |_| |_| |_|\__,_|\___|_|  \___/  |___/\___/|_|\__,_|\__|_|\___/|_| |_|

*/

/*--- COVERT PANDA DATAFRAME TO R RDS FILE ----*/

&_init_;
%utlfkil(d:/rds/pywant.rds);

libname sd1 sas7bdat "d:/sd1";
options noerrorabend;
options set=PYTHONHOME "D:\python310";
proc python;
submit;
import pyreadstat as ps
import pandas as pd
import pyreadr as pr
pywant,meta = ps.read_sas7bdat('d:/sd1/have.sas7bdat')
print(pywant)
pr.write_rds('d:/rds/pywant.rds',pywant)
endsubmit;
;quit;

/*---- CONVERT RDS FILE TO A SAS TABLE ----*/

&_init_;
options noerrorabend;
options set=RHOME "D:\d451";
%wps_py2sastable(
   inp=d:/rds/pywant.rds
  ,out=rwant );

proc print data=work.rwant;
run;quit;
/*           _               _
  ___  _   _| |_ _ __  _   _| |_
 / _ \| | | | __| `_ \| | | | __|
| (_) | |_| | |_| |_) | |_| | |_
 \___/ \__,_|\__| .__/ \__,_|\__|
                |_|
*/

WORK.RWANT

Altair SLC
Obs     NAME      SEX    AGE

 1     Alfred      M      14
 2     Alice       F      13
 3     Barbara     F      13
 4     Carol       F      14
 5     Henry       M      14
 6     James       M      12

/*
| | ___   __ _
| |/ _ \ / _` |
| | (_) | (_| |
|_|\___/ \__, |
         |___/
*/

4284      ODS _ALL_ CLOSE;
4285      FILENAME WPSWBHTM TEMP;
NOTE: Writing HTML(WBHTML) BODY file d:\wpswrk\_TD24756\#LN00161
4286      ODS HTML(ID=WBHTML) BODY=WPSWBHTM GPATH="d:\wpswrk\_TD24756";
4287      &_init_;
4288      %utlfkil(d:/rds/pywant.rds);
4289
4290      libname sd1 sas7bdat "d:/sd1";
NOTE: Library sd1 assigned as follows:
      Engine:        SAS7BDAT
      Physical Name: d:\sd1

4291      options noerrorabend;
4292      options set=PYTHONHOME "D:\python310";
4293      proc python;
4294      submit;
4295      import pyreadstat as ps
4296      import pandas as pd
4297      import pyreadr as pr
4298      pywant,meta = ps.read_sas7bdat('d:/sd1/have.sas7bdat')
4299      print(pywant)
4300      pr.write_rds('d:/rds/pywant.rds',pywant)
4301      endsubmit;

NOTE: Submitting statements to Python:


4302      ;quit;
NOTE: Procedure python step took :
      real time : 0.909
      cpu time  : 0.000


4303
4304      /*---- CONVERT RDS FILE TO A SAS TABLE ----*/
4305
4306      &_init_;
4307      options noerrorabend;
4308      %wps_py2sastable(
4309         inp=d:/rds/pywant.rds
4310        ,out=rwant );

NOTE: The infile 'c:\wpsoto\wps_py2rdataframe.sas' is:
      Filename='c:\wpsoto\wps_py2rdataframe.sas',
      Owner Name=T7610\Roger,
      File size (bytes)=902,
      Create Time=11:06:54 Sep 25 2025,
      Last Accessed=13:36:53 Sep 25 2025,
      Last Modified=13:30:59 Sep 25 2025,
      Lrecl=32767, Recfm=V

NOTE: The file 'c:\wpsoto\wps_py2rdataframeout.sas' is:
      Filename='c:\wpsoto\wps_py2rdataframeout.sas',
      Owner Name=T7610\Roger,
      File size (bytes)=0,
      Create Time=11:28:51 Sep 25 2025,
      Last Accessed=13:38:05 Sep 25 2025,
      Last Modified=13:38:05 Sep 25 2025,
      Lrecl=32767, Recfm=V

proc datasets lib=work
  nolist nodetails;
delete rwant;
run;quit;
proc r;
submit;
rwant <- readRDS("d:/rds/pywant.rds")
head(rwant)
endsubmit;
import data=rwant r=rwant;
;quit;run;
NOTE: 11 records were read from file 'c:\wpsoto\wps_py2rdataframe.sas'
      The minimum record length was 80
      The maximum record length was 80
NOTE: 11 records were written to file 'c:\wpsoto\wps_py2rdataframeout.sas'
      The minimum record length was 80
      The maximum record length was 94
NOTE: The data step took :
      real time : 0.001
      cpu time  : 0.015


Start of %INCLUDE(level 1) c:/wpsoto/wps_py2rdataframeout.sas
4311    +  proc datasets lib=work
4312    +    nolist nodetails;
4313    +  delete rwant;
4314    +  run;quit;
NOTE: Deleting "WORK.RWANT" (memtype="DATA")
NOTE: Procedure datasets step took :
      real time : 0.000
      cpu time  : 0.000


4315    +  proc r;
4316    +  submit;
4317    +  rwant <- readRDS("d:/rds/pywant.rds")
4318    +  head(rwant)
4319    +  endsubmit;
NOTE: Using R version 4.5.1 (2025-06-13 ucrt) from d:\r451

NOTE: Submitting statements to R:

> rwant <- readRDS("d:/rds/pywant.rds")

NOTE: Processing of R statements complete

> head(rwant)
4320    +  import data=rwant r=rwant;
NOTE: Creating data set 'WORK.rwant' from R data frame 'rwant'
NOTE: Data set "WORK.rwant" has 6 observation(s) and 3 variable(s)

4321    +  ;quit;run;
NOTE: Procedure r step took :
      real time : 0.280
      cpu time  : 0.000


NOTE: 6 observations were read from "WORK.rwant"
NOTE: Procedure print step took :
      real time : 0.005
      cpu time  : 0.000


End of %INCLUDE(level 1) c:/wpsoto/wps_py2rdataframeout.sas
4322
4323      proc print data=work.rwant;
4324      run;quit;
NOTE: 6 observations were read from "WORK.rwant"
NOTE: Procedure print step took :
      real time : 0.003
      cpu time  : 0.000


4325      quit; run;
4326      ODS _ALL_ CLOSE;
4327      FILENAME WPSWBHTM CLEAR;


/*___    _                   _               _
|___ \  | |__   __ _ _ __ __| | ___ ___   __| | ___   _ __   ___   _ __ ___   __ _  ___ _ __ ___
  __) | | `_ \ / _` | `__/ _` |/ __/ _ \ / _` |/ _ \ | `_ \ / _ \ | `_ ` _ \ / _` |/ __| `__/ _ \
 / __/  | | | | (_| | | | (_| | (_| (_) | (_| |  __/ | | | | (_) || | | | | | (_| | (__| | | (_) |
|_____| |_| |_|\__,_|_|  \__,_|\___\___/ \__,_|\___| |_| |_|\___/ |_| |_| |_|\__,_|\___|_|  \___/
*/


&_init_;
%utlfkil(d:/rds/pywant.rds);

libname sd1 sas7bdat "d:/sd1";
options noerrorabend;
options set=PYTHONHOME "D:\python310";
proc python;
submit;
import pyreadstat as ps
import pandas as pd
import pyreadr as pr
pywant,meta = ps.read_sas7bdat('d:/sd1/have.sas7bdat')
print(pywant)
pr.write_rds('d:/rds/pywant.rds',pywant)
endsubmit;
;quit;

proc datasets lib=work
  nolist nodetails;
delete rwant;
run;quit;


options set=RHOME "D:\d451";
proc r;
submit;
rwant <- readRDS("d:/rds/pywant.rds")
head(rwant)
endsubmit;
import data=rwant r=rwant;
;quit;run;

proc print data=work.rwant;
run;quit;

/*           _               _
  ___  _   _| |_ _ __  _   _| |_
 / _ \| | | | __| `_ \| | | | __|
| (_) | |_| | |_| |_) | |_| | |_
 \___/ \__,_|\__| .__/ \__,_|\__|
                |_|
*/

WORK.RWANT

Altair SLC
Obs     NAME      SEX    AGE

 1     Alfred      M      14
 2     Alice       F      13
 3     Barbara     F      13
 4     Carol       F      14
 5     Henry       M      14
 6     James       M      12

/*
| | ___   __ _
| |/ _ \ / _` |
| | (_) | (_| |
|_|\___/ \__, |
         |___/
*/

4284      ODS _ALL_ CLOSE;
4285      FILENAME WPSWBHTM TEMP;
NOTE: Writing HTML(WBHTML) BODY file d:\wpswrk\_TD24756\#LN00161
4286      ODS HTML(ID=WBHTML) BODY=WPSWBHTM GPATH="d:\wpswrk\_TD24756";
4287      &_init_;
4288      %utlfkil(d:/rds/pywant.rds);
4289
4290      libname sd1 sas7bdat "d:/sd1";
NOTE: Library sd1 assigned as follows:
      Engine:        SAS7BDAT
      Physical Name: d:\sd1

4291      options noerrorabend;
4292      options set=PYTHONHOME "D:\python310";
4293      proc python;
4294      submit;
4295      import pyreadstat as ps
4296      import pandas as pd
4297      import pyreadr as pr
4298      pywant,meta = ps.read_sas7bdat('d:/sd1/have.sas7bdat')
4299      print(pywant)
4300      pr.write_rds('d:/rds/pywant.rds',pywant)
4301      endsubmit;

NOTE: Submitting statements to Python:


4302      ;quit;
NOTE: Procedure python step took :
      real time : 0.909
      cpu time  : 0.000


4303
4304      /*---- CONVERT RDS FILE TO A SAS TABLE ----*/
4305
4306      &_init_;
4307      options noerrorabend;
4308      %wps_py2sastable(
4309         inp=d:/rds/pywant.rds
4310        ,out=rwant );

NOTE: The infile 'c:\wpsoto\wps_py2rdataframe.sas' is:
      Filename='c:\wpsoto\wps_py2rdataframe.sas',
      Owner Name=T7610\Roger,
      File size (bytes)=902,
      Create Time=11:06:54 Sep 25 2025,
      Last Accessed=13:36:53 Sep 25 2025,
      Last Modified=13:30:59 Sep 25 2025,
      Lrecl=32767, Recfm=V

NOTE: The file 'c:\wpsoto\wps_py2rdataframeout.sas' is:
      Filename='c:\wpsoto\wps_py2rdataframeout.sas',
      Owner Name=T7610\Roger,
      File size (bytes)=0,
      Create Time=11:28:51 Sep 25 2025,
      Last Accessed=13:38:05 Sep 25 2025,
      Last Modified=13:38:05 Sep 25 2025,
      Lrecl=32767, Recfm=V

proc datasets lib=work
  nolist nodetails;
delete rwant;
run;quit;
proc r;
submit;
rwant <- readRDS("d:/rds/pywant.rds")
head(rwant)
endsubmit;
import data=rwant r=rwant;
;quit;run;
NOTE: 11 records were read from file 'c:\wpsoto\wps_py2rdataframe.sas'
      The minimum record length was 80
      The maximum record length was 80
NOTE: 11 records were written to file 'c:\wpsoto\wps_py2rdataframeout.sas'
      The minimum record length was 80
      The maximum record length was 94
NOTE: The data step took :
      real time : 0.001
      cpu time  : 0.015


Start of %INCLUDE(level 1) c:/wpsoto/wps_py2rdataframeout.sas
4311    +  proc datasets lib=work
4312    +    nolist nodetails;
4313    +  delete rwant;
4314    +  run;quit;
NOTE: Deleting "WORK.RWANT" (memtype="DATA")
NOTE: Procedure datasets step took :
      real time : 0.000
      cpu time  : 0.000


4315    +  proc r;
4316    +  submit;
4317    +  rwant <- readRDS("d:/rds/pywant.rds")
4318    +  head(rwant)
4319    +  endsubmit;
NOTE: Using R version 4.5.1 (2025-06-13 ucrt) from d:\r451

NOTE: Submitting statements to R:

> rwant <- readRDS("d:/rds/pywant.rds")

NOTE: Processing of R statements complete

> head(rwant)
4320    +  import data=rwant r=rwant;
NOTE: Creating data set 'WORK.rwant' from R data frame 'rwant'
NOTE: Data set "WORK.rwant" has 6 observation(s) and 3 variable(s)

4321    +  ;quit;run;
NOTE: Procedure r step took :
      real time : 0.280
      cpu time  : 0.000


NOTE: 6 observations were read from "WORK.rwant"
NOTE: Procedure print step took :
      real time : 0.005
      cpu time  : 0.000


End of %INCLUDE(level 1) c:/wpsoto/wps_py2rdataframeout.sas
4322
4323      proc print data=work.rwant;
4324      run;quit;
NOTE: 6 observations were read from "WORK.rwant"
NOTE: Procedure print step took :
      real time : 0.003
      cpu time  : 0.000


4325      quit; run;
4326      ODS _ALL_ CLOSE;
4327      FILENAME WPSWBHTM CLEAR;

/*____                                     ___     _                       _       _
|___ /   _ __ ___   __ _  ___ _ __ ___    ( _ )   | |_ ___ _ __ ___  _ __ | | __ _| |_ ___
  |_ \  | `_ ` _ \ / _` |/ __| `__/ _ \   / _ \/\ | __/ _ \ `_ ` _ \| `_ \| |/ _` | __/ _ \
 ___) | | | | | | | (_| | (__| | | (_) | | (_>  < | ||  __/ | | | | | |_) | | (_| | ||  __/
|____/  |_| |_| |_|\__,_|\___|_|  \___/   \___/\/  \__\___|_| |_| |_| .__/|_|\__,_|\__\___|
                                                                    |_|
 _                       _       _                                        _               _
| |_ ___ _ __ ___  _ __ | | __ _| |_ ___  _   _ _ __  _ __ ___  ___  ___ | |_   _____  __| |  _ __ ___   __ _  ___ _ __ ___  ___
| __/ _ \ `_ ` _ \| `_ \| |/ _` | __/ _ \| | | | `_ \| `__/ _ \/ __|/ _ \| \ \ / / _ \/ _` | | `_ ` _ \ / _` |/ __| `__/ _ \/ __|
| ||  __/ | | | | | |_) | | (_| | ||  __/| |_| | | | | | |  __/\__ \ (_) | |\ V /  __/ (_| | | | | | | | (_| | (__| | | (_) \__ \
 \__\___|_| |_| |_| .__/|_|\__,_|\__\___| \__,_|_| |_|_|  \___||___/\___/|_| \_/ \___|\__,_| |_| |_| |_|\__,_|\___|_|  \___/|___/
                  |_|
*/

&_init_;
options noerrorabend;

/*--- SAVE THE R TEMPLATE IN YOUR AUTOCALL LIBRARY ---*/

%utlfkil(c:/wpsoto/wps_py2rdataframe.sas);

data _null_;
 file "c:/wpsoto/wps_py2rdataframe.sas";
 input;
 put _infile_;
 putlog _infile_;
datalines4;
proc datasets lib=work
  nolist nodetails;
delete &out;
run;quit;
options set=RHOME "D:\d451";
proc r;
submit;
&out <- readRDS("&inp")
head(&out)
endsubmit;
import data=&out r=&out;
;quit;run;
;;;;
run;quit;

/*                   _                             _  _            _           _
 _ __ ___  ___  ___ | |_   _____    __ _ _ __   __| |(_)_ __   ___| |_   _  __| | ___   _ __ ___   __ _  ___ _ __ ___
| `__/ _ \/ __|/ _ \| \ \ / / _ \  / _` | `_ \ / _` || | `_ \ / __| | | | |/ _` |/ _ \ | `_ ` _ \ / _` |/ __| `__/ _ \
| | |  __/\__ \ (_) | |\ V /  __/ | (_| | | | | (_| || | | | | (__| | |_| | (_| |  __/ | | | | | | (_| | (__| | | (_) |
|_|  \___||___/\___/|_| \_/ \___|  \__,_|_| |_|\__,_||_|_| |_|\___|_|\__,_|\__,_|\___| |_| |_| |_|\__,_|\___|_|  \___/


*/
&_init_;
options noerrorabend;
proc catalog catalog=work.sasmacr;
  delete macro_name.macro / et=macro;
run;
quit;

/*--- SAVE THE MACRO WITH WHICH INCLUDES THE RESOLVED FILE TEMPLATE ---*/

data _null_;
 file "c:/wpsoto/wps_py2sastable.sas";
 input;
 put _infile_;
 putlog _infile_;
datalines4;
%macro wps_py2sastable(
   inp=d:/rds/pywant.rds
  ,out=rwant )/des="convert py created R rds file to sas dataset";

  %utlfkil(c:/wpsoto/wps_py2rdataframeout.sas);

  data _null_;
    infile "c:/wpsoto/wps_py2rdataframe.sas";
    file "c:/wpsoto/wps_py2rdataframeout.sas";
    input;
    _infile_=resolve(_infile_);
    put _infile_;
    putlog _infile_;
  run;quit;

  %include "c:/wpsoto/wps_py2rdataframeout.sas";

proc print data=rwant(obs=5);
run;quit;

%mend wps_py2sastable;
;;;;
run;quit;

/*              _
  ___ _ __   __| |
 / _ \ `_ \ / _` |
|  __/ | | | (_| |
 \___|_| |_|\__,_|

*/
