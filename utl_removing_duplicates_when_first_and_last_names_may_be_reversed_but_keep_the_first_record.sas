Removing duplicates when first and last names may be reversed but keep the first record

Same results in WPS and SAS

see github
https://tinyurl.com/y8l9r8wq
https://github.com/rogerjdeangelis/utl_removing_duplicates_when_first_and_last_names_may_be_reversed_but_keep_the_first_record

sas forum
https://tinyurl.com/yb4syfog
https://communities.sas.com/t5/General-SAS-Programming/SAS-programming-Remove-duplicates/m-p/460657#M56769

K Sharp profile
https://communities.sas.com/t5/user/viewprofilepage/user-id/18408


INPUT
=====

JOE DOE
TED WON   ** keep this one
WON TED   ** remove this one of these because of reversal
JOY JAN
MOE KOE


PROCESS
=======

data havRev;
 set have;
 savFirst = first;
 savLast  = last;
 call sortc(first,last);
run;quit;

proc sort data=havRev out=havSrt equals;
  by first last;
run;quit;

data want;
  set havSrt;
  by first last;
  if first.last then output;
  keep savFirst savLast;
run;quit;


OUTPUT
======

WORK.WANT total obs=4

Obs    SAVFIRST    SAVLAST

 1       JOE         DOE  ** do not reverse because most names are not reversed
 2       JOY         JAN
 3       MOE         KOE
 4       TED         WON


%utl_submit_wps64('
libname wrk sas7bdat "%sysfunc(pathname(work))";
data havRev;
 set wrk.have;
 savFirst = first;
 savLast  = last;
 call sortc(first,last);
run;quit;

proc sort data=havRev out=havSrt equals;
  by first last;
run;quit;

data wrk.want;
  set havSrt;
  by first last;
  if first.last then output;
  keep savFirst savLast;
run;quit;
run;quit;
');

