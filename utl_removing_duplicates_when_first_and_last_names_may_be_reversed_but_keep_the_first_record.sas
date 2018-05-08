Removing duplicates when first and last names may be reversed but keep the first record

Same results in WPS and SAS

  Two solutions

see github
https://tinyurl.com/y8l9r8wq
https://github.com/rogerjdeangelis/utl_removing_duplicates_when_first_and_last_names_may_be_reversed_but_keep_the_first_record

sas forum
https://tinyurl.com/yb4syfog
https://communities.sas.com/t5/General-SAS-Programming/SAS-programming-Remove-duplicates/m-p/460657#M56769

K Sharp profile
https://communities.sas.com/t5/user/viewprofilepage/user-id/18408

HASH by
Martin, Vincent (STATCAN/STATCAN)
vincent.martin@canada.ca

Yinglin (Max) Wu <yinglinwu@gmail.com>


data dups;
   if 0 then set have;
   declare hash h(ordered:'a');
   h.definekey ("first","last" );
   h.definedone();
   do until (dne);
      set have end=dne;
     if 0=h.check(key:first,key:last) or 0=h.check(key:last,key:first)then do;
              /* If the pair was found in any order in the hash, this current record is a duplicate
              The benefit to nesting the alternate OR condition into the ELSE is likely
              negligible since the lookup is O(1), it saves an extra programming statement and
              it would really only save the lookup if the data had tons of exact duplicates */
          output dups;
     end;
     else do;
       /* else this is the first record with the reversible pair so populate the hash */
     h.add();
     end;
    end;
    h.output(dataset: "dedupped");
run;

NON HASH

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

*                _               _       _
 _ __ ___   __ _| | _____     __| | __ _| |_ __ _
| '_ ` _ \ / _` | |/ / _ \   / _` |/ _` | __/ _` |
| | | | | | (_| |   <  __/  | (_| | (_| | || (_| |
|_| |_| |_|\__,_|_|\_\___|   \__,_|\__,_|\__\__,_|

;

data have;
input (first last) ($);
cards4;
JOE DOE
TED WON
WON TED
JOY JAN
MOE KOE
;;;;
run;quit;
*          _       _   _
 ___  ___ | |_   _| |_(_) ___  _ __
/ __|/ _ \| | | | | __| |/ _ \| '_ \
\__ \ (_) | | |_| | |_| | (_) | | | |
|___/\___/|_|\__,_|\__|_|\___/|_| |_|

;

for SAS see process

* WPS solution
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



