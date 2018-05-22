Same result in WPS and SAS (using all SAS datasets)

Using a transaction table to update  master table very simple code

stackoverflow sas;
https://tinyurl.com/ybzgrl24
https://stackoverflow.com/questions/50453598/how-can-i-consolidate-multiple-rows-into-one-rowstring


INPUT (master and transaction dataset)
======================================

WORK.MASTER total obs=3

 ID    FLG1    FLG2    FLG3    FLG4    FLG5

  1      .       .       1       1       .
  2      1       1       .       1       .
  3      1       .       .       1       .

WORK.TRANSACTION total obs=3

 ID    FLG1    FLG2    FLG3    FLG4    FLG5

  1      2       2       .       .       2
  2      .       .       2       .       2
  3      .       2       2       .       2


EXAMPLE OUTPUT  updated master

 WORK.MASTER total obs=3

 ID    FLG1    FLG2    FLG3    FLG4    FLG5

  1      2       2       1       1       2
  2      1       1       2       1       2
  3      1       2       2       1       2


PROCESS
=======

data master;
  update master transaction;
  by id;
run;quit;


OUTPUT
======

EXAMPLE OUTPUT  updated master

 WORK.MASTER total obs=3

 ID    FLG1    FLG2    FLG3    FLG4    FLG5

  1      2       2       1       1       2
  2      1       1       2       1       2
  3      1       2       2       1       2


*                _              _       _
 _ __ ___   __ _| | _____    __| | __ _| |_ __ _
| '_ ` _ \ / _` | |/ / _ \  / _` |/ _` | __/ _` |
| | | | | | (_| |   <  __/ | (_| | (_| | || (_| |
|_| |_| |_|\__,_|_|\_\___|  \__,_|\__,_|\__\__,_|

;

data master transaction;
  retain id cnt 0;
  call streaminit(1234);
  array flgs[5] flg1-flg5;
  do id=1 to 3;
    cnt=cnt+1;
    do bin=1 to 5;
      if rand('uniform')<.3 then flgs[bin]=1;
      else flgs[bin]=.;
    end;
    output master;
    do bin=1 to 5;
      if flgs[bin]=1 then flgs[bin]=.;
      else flgs[bin]=2;
    end;
    output transaction;
  end;
  drop cnt bin;
run;quit;

*          _       _   _
 ___  ___ | |_   _| |_(_) ___  _ __  ___
/ __|/ _ \| | | | | __| |/ _ \| '_ \/ __|
\__ \ (_) | | |_| | |_| | (_) | | | \__ \
|___/\___/|_|\__,_|\__|_|\___/|_| |_|___/

;

*SAS
data master;
  update master transaction;
  by id;
run;quit;

* WPS;
%utl_submit_wps64('
libname wrk sas7bdat "%sysfunc(pathname(work))";
data wrk.masterwps;
  update wrk.master wrk.transaction;
  by id;
run;quit;
');


