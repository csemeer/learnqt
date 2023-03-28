CREATE OR REPLACE PACKAGE BODY "CLPKS_SCHEDULES"
/*************************************************************************************************
**  This source is part of the FLEXCUBE-Corporate Banking Software System
**  and is copyrighted by Oracle Financial Services Software Limited.
**  All rights reserved.  No part of this work may be reproduced,
**  stored in a retrieval system, adopted or transmitted in any form or
**  by any means, electronic, mechanical, photographic, graphic,
**  optic recording or otherwise, translated in any language or
**  computer language, without the prior written permission of
**  Oracle Financial Services Software Limited.
**
**  Oracle Financial Services Software Limited.
**  10-11, SDF I, SEEPZ, Andheri (East),
**  MUMBAI - 400 096.
**  INDIA
**
**  Copyright ¿ 2004- 2010 by Oracle Financial Services Software Limited.
**  Oracle Financial Services Software Limited.
**
**************************************************************************************************
**  PACKAGE Name        : clpks_schedules
**  File Name           : CLPKSCH.SQL
**  Module              : CONSUMER LENDING
**  Description         : This package will have functions for creating/modifying and
                          rebuilding schedules.
**
**  Subroutines called  :
**  Written by          : Ravi Ranjan
**  Date of creation    : 01-OCT-2004
**  Description         :
**
**  Change Log
**    Log Number        : 1
**    Modified By       :Ravi Ranjan
**    Modified On       :09-Nov-2004
**    Modified Reason   :MTR1 SFR#57.
**
**    Log Number         : 2
**    Modified By        :Ravi Ranjan
**    Modified On        :10-nov-2004
**    Modified Reason    :MTR1 SFR#62
**
**    Log Number         :3
**    Modified By        :Ravi Ranjan
**    Modified On        :10-nov-2004
**    Modified Reason    :MTR1 SFR#63
**
**    Log Number         :4
**    Modified By        :Ravi Ranjan
**    Modified On        :17-nov-2004
**    Modified Reason    :MTR1 SFR#136

**    Log Number         :5
**    Modified By        :Ravi Ranjan
**    Modified On        :18-nov-2004
**    Modified Reason    :MTR1 SFR#136

**    Log Number         :6
**    Modified By        :Ravi Ranjan
**    Modified On        :18-nov-2004
**    Modified Reason    :MTR1 SFR#136
**
**    Log Number        : 7
**    Modified By       : Ravi Ranjan Tiwari
**    Modified On       : 21/Nov/2004
**    Modified Reason   : MTR1 SFR#165 - Error during calculation of charge.

**    Log Number        : 8
**    Modified By       : Ravi Ranjan Tiwari
**    Modified On       : 22/Nov/2004
**    Modified Reason   : MTR1 SFR#210 - Change in schedules calc logic

**    Log Number        : 9
**    Modified By       : Ravi Ranjan Tiwari
**    Modified On       : 23/Nov/2004
**    Modified Reason   : MTR1 SFR#98

**    Log Number        : 10
**    Modified By       : Ravi Ranjan Tiwari
**    Modified On       : 25/Nov/2004
**    Modified Reason   : MTR1 SFR#265

**    Log Number        : 11
**    Modified By       : Ravi Ranjan Tiwari
**    Modified On       : 25/Nov/2004
**    Modified Reason   : MTR1 SFR#270 AND MTR1 SFR#276

**    Log Number        : 12
**    Modified By       : Ravi Ranjan Tiwari
**    Modified On       : 25/Nov/2004
**    Modified Reason   : MTR1 SFR#287

**    Log Number        : 13
**    Modified By       : L Anantharaman
**    Modified On       : 29-Nov-2004
**    Modified Reason   : Against MTR1 SFR#260 Changing err code and error param as IN OUT params

**    Log Number        : 14
**    Modified By       : Ravi Ranjan
**    Modified On       : 03-Dec-2004
**    Modified Reason   : Against MTR1 SFR#360
**
**    Log Number          : 15
**    Modified By         : Padmini
**    Modified On         : 05-Dec-2004
**    Modified Reason     : Against SFR#260, Override Changes

**    Log Number          : 16
**    Modified By         : Ravi
**    Modified On         : 05-Dec-2004
**    Modified Reason     : Against SFR#397

**    Log Number          : 17
**    Modified By         : Ravi
**    Modified On         : 06-Dec-2004
**    Modified Reason     : Against SFR#397

**    Log Number          : 18
**    Modified By         : Ravi
**    Modified On         : 06-Dec-2004
**    Modified Reason     : Against SFR#397
**
**    Log Number          : 19
**    Modified By         : L Anantharaman
**    Modified On         : 09-Dec-2004
**    Modified Reason     : Against SFR#416 Roll over changes
**
**    Log Number          : 20
**    Modified By         : L Anantharaman
**    Modified On         : 10-Dec-2004
**    Modified Reason     : Against FCCCL1.0 MTR SFR#416. Added SCH_START_DATE in ORDER BY clause
**                            for l_cur_old_schedule_defns in fn_copy_schs_from_account
**    Log Number          : 21
**    Modified By         : Ravi Ranjan
**    Modified On         : 13-Dec-2004
**    Modified Reason     : Against SFR#471.
**
**    Log Number          : 22
**    Modified By         : L Anantharaman
**    Modified On         : 15-Dec-2004
**    Modified Reason     :  Against SFR#284. Changed "component_type"  being compared against '3' and '4' (Discounted and Truely Discounted)
**                                       to "formula type"
**
**    Log Number          : 23
**    Modified By         : R V Ramesh
**    Modified On         : 17-Dec-2004
**    Modified Reason     : Against SFR#481.
**
**    Log Number          : 24
**    Modified By         : Aakriti
**    Modified On         : 17-Dec-2004
**    Modified Reason     : Against SFR#491 MTR1
**
**    Log Number          : 25
**    Modified By         : Padmini
**    Modified On         : 19-Dec-2004
**    Modified Reason     : Against SFR#512
**
**    Log Number          : 26
**    Modified By         : A.Prasanna Kumar
**    Modified On         : 27-Dec-2004
**    Modified Reason     : Against SFR#014. MTR2 9NT252
**
**    Log Number          : 27
**    Modified By         : Ravi Ranjan
**    Modified On         : 07-Jan-2005
**    Modified Reason     : Against ITR1 SFR#043

**    Log Number          : 28
**    Modified By         : Anu
**    Modified On         : 10-01-2005
**    Modified Reason     : FCCCL1.0-Phase II NLS changes
                            Declared the following package level variables - PKG_PRINCIPAL, PKG_MAIN_INT and initialized in the pkg body
                            Replaced the references to SDE names 'PRINCIPAL' with  PKG_PRINCIPAL,
                            'MAIN_INT' with PKG_MAIN_INT
                             Functions/Procs affected are :FUNCTION fn_create_schedule, FUNCTION fn_validate_schedules
                             ,FUNCTION fn_populate_account_schedules,FUNCTION fn_split_schedules
                             ,FUNCTION fn_copy_schs_from_account, FUNCTION fn_prepare_dsbr_sch,FUNCTION fn_copy_schs_from_account,FUNCTION fn_reset_prin_amt
                              ,FUNCTION fn_fill_schedule_gaps.

**    Log Number          : 29
**    Modified By         : Ravi Ranjan
**    Modified On         : 17-Feb-2005
**    Modified Reason     : CL Phase II Corfo Related enhancements

**    Log Number          : 30
**    Modified By         : Sudharshan
**    Modified On         : 17-Feb-2005
**    Modified Reason     : CL Phase II BY-Pass Changes

**    Log Number          : 31
**    Modified By         : Ravi Ranjan
**    Modified On         : 25-Mar-2005
**    Modified Reason     : CL Phase II Schedule enhancements.

**    Log Number          : 32
**    Modified By         : Dips
**    Modified On         : 04-Apr-2005
**    Modified Reason     : Added function fn_create_call_sch to create Bullet schedules for Call loans.
**
**    Log Number          : 33
**    Modified By         : L Anantharaman
**    Modified On         : 11-Apr-2005
**    Modified Reason     : FCCCL1.0 PhaseII reduce tenor changes
**
**    Log Number          : 34
**    Modified By         : Ravi
**    Modified On         : 13-Apr-2005
**    Modified Reason     : IQA Support #61..change done in fn_compute_schedule_dates.
**
**    Log Number          : 35
**    Modified By         : A.Prasanna Kumar
**    Modified On         : 14-Apr-2005
**    Modified Reason     : FCCCL 1.0 Phase 2 Changes. IQA SFR#99, 'H','P','M' should include 'O' also.
**
**    Log Number          : 36
**    Modified By         : Ravi Ranjan
**    Modified On         : 15-Apr-2005
**    Modified Reason     : FCCCL 1.0 Phase 2 Changes. IQA Support
**                          SFR#103,When 'due dates on' flag is set as'31' ,dates in Feb were not coming properly.
**                          SFR#138,Changed the logic of function fn_calculat_maturity_date to consider all kind of
**                                  holiday treatment.
**
**    Log Number          : 37
**    Modified By         : Ravi Ranjan
**    Modified On         : 22-Apr-2005
**    Modified Reason     : FCCCL 1.0 Phase 2 Changes. IQA Support SFR#85..
**                            Change in holiday period treament logic.Due date after holiday period needs to be
**                            as on due dates(and not immediatly after end of Holiday Period)
**
**    Log Number          : 38
**    Modified By         : Ravi Ranjan
**    Modified On         : 26-Apr-2005
**    Modified Reason     : FCCCL 1.0 Phase 2 Changes. enahncements
**                          Added function fn_add_a_schedule for Increase Tenor Related Emhancements.
**                          FCCCL 1.0 Phase 2 Changes. IQA Support SFR#138..
**                          change done in fn_get_final_schedule_date for always getting a forward date in
**                          case of Deadlock situation.
**
**    Log Number          : 39
**    Modified By         : Sishir
**    Modified On         : 27-Apr-2005
**    Modified Reason     : FCCCL 1.0 Phase-2 IQA SFR#221 : Due dates on should not be present for bullet schedules
**
**    Log Number          : 40
**    Modified By         : Ravi
**    Modified On         : 29-Apr-2005
**    Modified Reason     : FCCCL 1.0 Phase-2 IQA Supp : NVL Handling for weekly schedules.
**
**    Log Number          : 41
**    Modified By         : Ravi
**    Modified On         : 02-May-2005
**    Modified Reason     : FCCCL 1.0 Phase-2 IQA Supp : Check added in fn_validate schedules
**
**
**    Log Number          : 42
**    Modified By         : Rajasekhar
**    Modified On         : 02-May-2005
**    Modified Reason     : Added a new column, Schedule_no, in cltb_account_schedules.
**                          Changes made to include this column in SELECT or INSERT stmts.
**
**                          also create a new function for generating schedule_numbers fn_gen_sch_no
**
**
**    Log Number          : 43
**    Modified By         : Ruchir/Rajasekhar
**    Modified On         : 05-May-2005
**    Modified Reason     : To calculate copmonents depending on the choice of Component_Ccy filed
**                 Added a new column, component_ccy, in cltb_account_components.
**                             Changes made to include this column in SELECT or INSERT stmts.
**
**
**    Log Number          : 44
**    Modified By         : Dips
**    Modified On         : 21-May-2005
**    Modified Reason     : FCCCL 1.1 MTR1 SFR#32. Due date generated has to be greater than the reference date.
**
**    Log Number          : 45
**    Modified By         : A.Prasanna Kumar
**    Modified On         : 24-May-2005
**    Modified Reason     : FCCCL 1.1 MTR1 SFR#58.
**
**    Log Number          : 46
**    Modified By         : L Anantharaman
**    Modified On         : 23-May-2005
**    Modified Reason     : FCCCL 1.1 SFR#1.
**                          Error description:
**                          VAMI change in interest rate is leading to incorrect "explode" of the
**                          principal repayment schedule. Also the VAMI is not being saved
**    Search string       : LOG#46 23-May-2005 SFR#1
**
**    Log Number          : 47
**    Modified By         : L Anantharaman
**    Modified On         : 25-May-2005
**    Modified Reason     : FCCCL 1.1 SFR#1.
**                          Error description:
**                          VAMI change in interest rate is leading to incorrect "explode" of the
**                          principal repayment schedule. Also the VAMI is not being saved
**    Search string       : LOG#47 25-May-2005 SFR#1
**
**    Log Number          : 48
**    Modified By         : Dips
**    Modified On         : 25-May-2005
**    Modified Reason     : FCCCL 1.1 SFR#84 - During recalc schedules, Assigning the hol perds to package variable.
**
**    Log Number          : 49
**    Modified By         : A.Prasanna Kumar
**    Modified On         : 01-Jun-2005
**    Modified Reason     : FCCCL 1.1 SFR#112 - Discounted First schedule due date logic changed for non-defaulting case.
**
**    Log Number          : 50
**    Modified By         : A.Prasanna Kumar
**    Modified On         : 02-Jun-2005
**    Modified Reason     : FCCCL 1.1 SFR#92 - First schedule due date comp sch should be derived based on new value date and not old first schedule due date.
**
**    Log Number          : 51
**    Modified By         : L Anantharaman, Biswajit
**    Modified On         : 06-Jun-2005
**    Modified Reason     : FCCCL 1.1 MTR1 SFR#124,SFR#105
**    Search string       : LOG#51 06-Jun-2005
**
**    Log Number          : 52
**    Modified By         : Biswajit
**    Modified On         : 09-Jun-2005
**    Modified Reason     : FCCCL 1.1 MTR1 SFR#133
**
**    Log Number          : 53
**    Modified By         : RaghuR
**    Modified On         : 09-Jun-2005
**    Modified Reason     : FCCCL 1.1 MTR1 SFR#94 --IF only 1 monthly schedule is defined in the product then during schedule creation
**                                                  it should be made to a bullet and the start and end dates should be made equal to the maturity date.
**
**    Log Number          : 54
**    Modified By         : RaghuR
**    Modified On         : 15-Jun-2005
**    Modified Reason     : FCCCL 1.1 MTR1 SFR #157--Even if the first schedule date falls in a holiday period it should
**                                                   be ignored in the case where global.x9$ is = 'CLPBDC'
**
**    Log Number          : 55
**    Modified By         : RaghuR
**    Modified On         : 24-Jun-2005
**    Modified Reason     : FCCCL 1.1 MTR2 SFR #4--For reasons not delved into deeply the call to function clpkss_util.fn_falls_in_holiday_period
**                          sometimes returns l_due_date as the next working day after the holiday period.So a check has been added to see whether the
**                          date returned is a working day or does it still fall in the holiday and the rest of the code proceeds accordingly. Hopefully
**                          it will work properly.
**    Search String       : Log#55 RaghuR 24-Jun-2005
**
**    Log Number          : 56
**    Modified By         : Biswajit
**    Modified On         : 28-Jun-2005
**    Modified Reason     : FCCCL 1.1 MTR2 SFR #26 : Due Date across Years was not Calculating Correctly during Rollover.
**
**    Log Number          : 57
**    Modified By         : Soumya H.
**    Modified On         : 07-Jul-2005
**    Modified Reason     : FCCCL 1.1 SFR #63 : Changed in fn_gen_schedule_no.ordered by schedule_due_date.
**
**    Log Number          : 58
**    Modified By         : RaghuR
**    Modified On         : 11-Jul-2005
**    Modified Reason     : FCCCL 1.1 BDC Testing - The bullet schedule due date should be made to maturity date.
**                          Also if due dates on is specified then for bullet schedule it should be made to null.
**    Search String       : Log#58 RaghuR 11-Jul-2005
**
**    Log Number          : 59
**    Modified By         : RaghuR
**    Modified On         : 13-Jul-2005
**    Modified Reason     : FCCCL 1.1 BDC Testing SFR#61- Due to the fix made in Log#44 when due dates on is specified as 31
**                          then it is skipping months which do not have 31 days.Another fix has been made for Log #44.
**                          A problem is caused when you have the value date of an account on the previous year of the first
**                          installment date. This problem has been fixed in FN_APPLY_CALENDER_PREFS.
**    Search String       : Log#59 RaghuR 13-Jul-2005
**
**    Log Number          : 60
**    Modified By         : RaghuR
**    Modified On         : 13-Jul-2005
**    Modified Reason     : FCCCL 1.1 BDC Testing SFR#61- Fixing the fix made in the above sfr as it was not giving correct results
**    Search String       : Log#60 RaghuR 15-Jul-2005
**
**    Log Number          : 61
**    Modified By         : Padmini
**    Modified On         : 01-AUG-2005
**    Modified Reason     : PERF CHANGES : Performance Changes
**
**    Log Number          : 62
**    Modified By         : Soumya H.
**    Modified On         : 23-AUG-2005
**    Modified Reason     : PERF CHANGES : Performance Changes
**
**    Log Number          : 63
**    Modified By         : RaghuR
**    Modified On         : 30-AUG-2005
**    Modified Reason     : When Daily schedule is given in the maturity date calculator with schedule start date
**                          then on defaulting the schedule start date was not getting calculated properly.
**    Search String       : Log#63 30-Aug-2005 RaghuR
**
**    Log Number          : 64
**    Modified By         : Sasmita
**    Modified On         : 19-Sep-2005
**    Modified Reason     : New Columns in Cltb_account_comp_sch
**    Search String       : Log#64
**
**    Log Number          : 65
**    Modified By         : RaghuR
**    Modified On         : 19-Sep-2005
**    Modified Reason     : CHANGES
**    Search String       : RaghuR 19-Sep-2005
**
**    Log Number          : 66
**    Modified By         : RaghuR
**    Modified On         : 28-Sep-2005
**    Modified Reason     : FCCCL 2.0 Dev -- column emi_amount added in comp sch
**    Search String       : Log#66
**
**    Log Number          : 67
**    Modified By         : Ravi
**    Modified On         : 28-Sep-2005
**    Modified Reason     : FCCCL 2.0 Dev -- column emi_amount added in comp sch
**    Search String       : Log#67
**
**    Log Number          : 68
**    Modified By         : Soumya H.
**    Modified On         : 07-OCT-2005.
**    Modified Reason     : FCCCL 2.0 ITR1  :  Against SFR#11.
**
**
**    Log Number          : 69
**    Modified By         : Sasmita Behera
**    Modified On         : 19-OCT-2005.
**    Modified Reason     : FCCCL 2.0 ITR1  :  Against SFR#73
**
**
**    Log Number          : 70
**    Modified By         : Prasanna/Debendra
**    Modified On         : 17-Nov-2005
**    Modified Reason     : FCC-CL 1.1.3 ITR2 SFR#87.
**
**      Log Number          : 71
**      Modified By         : A.Prasanna Kumar
**      Modified On         : 02-DEC-2005
**      Modified Reason     : SFR#AAL034-04.EXTRA HIGH ISSUE.
**
**      Log Number          : 72
**      Modified By         : Rajasekhar P
**      Modified On         : 13-01-2006
**      Modified Reason     : Retro from BDC
**
**    Log Number          :  85
**    Modified By         :  Bala Murali
**    Modified On         :  30-jan-2006
**    Modified Reason     :  BDC retros -Changed logic to populate rate revision schedules if floating rate is present for any of the effective dates
**    Search String       :  Log#85
**
**    Log Number          :  86
**    Modified By         :  Guhan Kumar.M
**    Modified On         :  31-jan-2006
**    Modified Reason     :  PERF CHANGES
**
**    Log Number          : 87
**    Modified By         : Soumya H.
**    Modified On         : 02-FEB-2006.
**    Modified Reason     : BDC RETRO.When a VAMI is done to change the schedule due date for a partly paid schedule
**                                    and all other pending schedules to Maturity date then the Amount partly
**                                    settled is not being considered for the new schedule created.
**
**    Log Number          :  88
**    Modified By         :  Guhan Kumar.M
**    Modified On         :  08-Feb-2006
**    Modified Reason     :  BDC RETRO Changes (REFERENCE TAG :: PHASE2UT0098)
**
**    Log Number          :  89
**    Modified By         :  Guhan Kumar.M
**    Modified On         :  11-Feb-2006
**    Modified Reason     :  BDC RETRO Changes (REFERENCE TAG :: PHASE2UT0176)
**
**    Log Number          :  90
**    Modified By         :  Guhan Kumar.M
**    Modified On         :  11-Feb-2006
**    Modified Reason     :  BDC RETRO Changes (REFERENCE TAG :: PHASE2UT0003)
**
**    Log Number          :  91
**    Modified By         :  Guhan Kumar.M
**    Modified On         :  11-Feb-2006
**    Modified Reason     :  BDC RETRO Changes (REFERENCE TAG :: PHASE2UT0171)
**
**    Log Number          :  92
**    Modified By         :  Guhan Kumar.M
**    Modified On         :  15-Feb-2006
**    Modified Reason     :  BDC RETRO Changes (REFERENCE TAG :: P2UATCRE0665 -- Log#88 RaghuR@CLPBDC)
**
**    Log Number          :  93
**    Modified By         :  Guhan Kumar.M
**    Modified On         :  15-Feb-2006
**    Modified Reason     :  BDC RETRO Changes (REFERENCE TAG :: P2UATCRE0665 -- Log#90 RaghuR@CLPBDC)
**
**    Log Number          :  94
**    Modified By         :  Guhan Kumar.M
**    Modified On         :  16-Feb-2006
**    Modified Reason     :  BDC RETRO Changes (REFERENCE TAG :: P2UATCRE0433 -- Log#65 )
**
**    Log Number          :  95
**    Modified By         :  Rajasekhar P.
**    Modified On         :  22-Feb-2006
**    Modified Reason     :  Changes against SFR#3   CL2.2 ITR1
**    Search String       :  spotfix@22-02-2006 CLITR1  SFR#3
**
**    Log Number          :  96
**    Modified By         :  Sasmita Behera
**    Modified On         :  3-Mar-2006
**    Modified Reason     :  Changes against SFR#28   CL2.2 ITR1
**    Search String       :  FCCCL 22 itr1 retros sfr#28 starts
**
**    Log Number          :  97
**    Modified By         :  Sasmita Behera
**    Modified On         :  7-Mar-2006
**    Modified Reason     :  Changes against SFR#28   CL2.2 ITR1
**    Search String       :  FCCCL 2.2 Retros Against SFR#56
**
**    Log Number          :  98
**    Modified By         :  Aarti
**    Modified On         :  25-Apr-2006
**    Modified Reason     :  LH - CL 3.0 Dev Changes
**    Search String       :  Log#98
**
**    Log Number          :  99
**    Modified By         :  Santosh Kumar Sinha
**    Modified On         :  20-May-2006
**    Modified Reason     :  Retro from Alpha Bank.
**    Search String       :  Log#99
**
**    Log Number          :  100
**    Modified By         :  Narendra
**    Modified On         :  23-May-2006
**    Modified Reason     :  For HC insert will be happen into cltb_account_schedules
**                           instead of cltb_account_comp_calc to improve performance.
**    Search String       :  log#100

**      Modified By         : Sasmita Behera
**      Modified On         : 18-APR-2006
**      Modified Reason     : Euro Bank Support requiremnet for Late Fee
**  Search String         : Late Fee Changes on 18 Apr '06 starts
**  Log Number              : 101
**      Log Number          : 102
**      Modified By         : Dinakar
**      Modified On         : 17-apr-2006
**      Modified Reason     : LOG#101 EUROBANK Billing Periodicity changes.
**  Search String         : LOG#101
**
**      Log Number          : 103
**      Modified By         : Dinakar
**      Modified On         : 01-jun-2006
**      Modified Reason     : euro bank retro changes LOG#103
**  Search String         : LOG#103
**
**      Log Number          : 104
**      Modified By         : Gunjan
**      Modified On         : 01-Jun-2006
**      Modified Reason     :  FCCL 3.0 IRR Enhancements.Code added to propagate IRR flag value
                               from cltb_account_components to cltb_account_schedules.
                               New column irr_applicable added in cltb_account_schedules.
**  Search String         : LOG#104
**
**      Log Number          : 105
**      Modified By         : R S Sajeesh.
**      Modified On         : 08-JUN-2006.
**      Modified Reason     : BDC RETRO (SOUMYA H. 12-APR-2006) Rollover was fialing if schedule basis is C. While defaulting schedules and comp sch from contract level it was failing.
**      Search String       : R S SAJEESH. 08-JUN-2006
**
**      Log Number          : 106
**      Modified By         : R S Sajeesh.
**      Modified On         : 08-JUN-2006.
**      Modified Reason     : BDC RETRO (Log#93) Storing susp amt due also while rebuilding the schedules.
**    Search String       : Log#106

**      Log Number          : 107
**      Modified By         : Dinakar
**      Modified On         : 08-JUN-2006.
**      Modified Reason     : account creation failing bec rate revision formula not maintained
**        Search String       : log#107 ITR1 SFR#52
**
**      Log Number          : 108
**      Modified By         : Rajasekhar P.
**      Modified On         : 13-JUN-2006.
**      Modified Reason     : Changes against SFR#92 ITR1 CL3.0
**        Search String       : log#108
**
**      Log Number          : 109
**      Modified By         : Rajasekhar P.
**      Modified On         : 14-JUN-2006.
**      Modified Reason     : Changes against SFR#108 ITR1 CL3.0 (Moratorium should happen for Non Amortized products also.
**        Search String       : log#109
**
**      Log Number          : 110
**      Modified By         : A.Prasanna Kumar
**      Modified On         : 21-JUL-2006
**      Modified Reason     : EURO-SERBIA. SFR#AAL054-04. Ignore Holidays unchecked - Billing dates not distributed correctly
**      Search String       : 21-JUL-2006

**     Log Number           : 111
**    Modified By           : Nitin Agarwal
**    Modified On           : 23-Apr-2007
**    Modified Reason       : ALPHA,OBBER,FHB Bank Retro.Schedule Number should be generated Component-wise not Date wise.
                              First due date not fall on holiday.

**    Retro Reference       : 15,19,34,42,45/ALPHA,FHB,OBBER/Site Retroes/CLRetroList.xls
**    Search String         : Log#111
**
**      Log Number          : 112
**      Modified By         : Raj Vadana
**      Modified On         : 23-Apr-2007
**      Modified Reason     : Retro -
**                          : 1. RUBHCFB SFR#I1483 - CL-SCH036 fn_validate_schedules error when we edit and explode a patricular
**                               record in schedule through VAMI in CL for account %7282. Added new error code for dsbr schdules missing for auto disbr loan
**                          : 2. FCCRUSSIA IMPSUPP SFR-310: Date Format related changes
**      Retro Reference     : 141,142/HC/HC Benchmark Retroes/CLRetroList.xls
**      Search String     : Log#112
**
**      Log Number          : 113
**      Modified By         : Abhishek Ranjan
**      Modified On         : 27-Apr-2007
**      Modified Reason     : Retro from Eurobank - Revision schedules related issues.
**      Retro Reference     : 285,286/EUROBANK/Site Retroes/CLRetroList.xls
**      Search String     : Log#113
**
**
**      Log Number          : 114
**      Modified By         : Anil
**      Modified On         : 27-Apr-2007
**      Modified Reason     : Retro for LH -.Day count Changes,Performance Changes
**      Retro Reference     : 49,169,170,LANDSHYPOTEK/Site Retroes/CLRetroList.xls
**      Search String     : Log#114


**      Log Number          : 115
**      Modified By         : ashutosh
**      Modified On         : 15-may-2007
**      Modified Reason     : Retro for Emi_amount against principal record should be null in schedules
**      Retro Reference     : 178 BDC/Site Retroes/CLRetroList.xls
**      Search String     : Log#115
**
**      Log Number          : 116
**      Modified By         : Karthik M
**      Modified On         : 22-May-2007
**      Modified Reason     : Retro for Moratorium End Date and Due date difference and handling of holiday periods
**      Retro Reference     : Sl.No 56 and 126 BDC/Site Retroes/CLRetroList.xls
**      Search String     : Log#116
**
**      Log Number          : 117
**      Modified By         : Kaushik Bashakarla
**      Modified On         : 07-Jun-2007
**      Modified Reason     : Internal Changes (backSlash is missing at the end).
**      Search String     : Log#117
**
**      Log Number          : 118
**      Modified By         : Tamshuk Saha
**      Modified On         : 27-FEB-2008
**      Modified Reason     : Retro for Allianz bank, DNBNord,OBERBank.
**      Retro Reference     : 19,74,87/Allianz,DNBNord,OBERBank/Site Retroes/CLRetroList4.2.xls!Santosh
**      Search String       : Log#118
**
**      Log Number          : 119
**      Modified By         : Veena H.
**      Modified On         : 3-Mar-2008
**      Modified Reason     : Retro from La Caixa, CTCB, Eurobank
**      Retro Reference     : 6,10,20,25,51,59,61,64,67,69/Allianz,DNBNord,OBERBank/Site Retroes/CLRetroList4.2.xls!Veena
**      Search String     : Log#119
**
**      Log Number          : 120
**      Modified By         : Abhishek Ranjan
**      Modified On         : 5-Mar-2008
**      Modified Reason     : RETRO CL42 CHANGES
                                1) While doing VAMI if we are changing the maturity date after liquidation of
                                second last schedule, during edit system is not allowing to modify or delete the bullet schedule for
                              2) While doing the VAMI for Principal/Tenor Increase, in the Components tab the
                                  VAMI changes are not reflected in the Principal and Profit component schedules. The same is the case
                                of VAMI for UDE (profit_rate change).
**      Retro Reference     : 18,15/IBA/Site Retroes/CLRetroList4.2.xls!Ravi
**      Search String     : Log#120
**
**      Log Number        : 121
**      Modified By       : Saravanan K
**      Modified On       : 29-APR-2008
**      Modified Reason   : LS Changes - Validation for Currency Holiday added
**      Search String     : Log#121 FC 10.1 LS Changes
**
**      Log Number        : 122
**      Modified By       : A.Prasanna Kumar
**      Modified On       : 09-AUG-2008
**      Modified Reason   : KERNEL 10.1 ITR2 SFR#111
**      Search String     : Log#122
**
**
**    Log Number          : 123
**    Modified By         : L.N.Lavanya
**    Modified On         : 09-Dec-2008
**    Modified Reason     : Principal bullet schedules were not allowed to edit in VAMI when a partial payment is done.
**    Retro Reference   : 10.3CLRetrolist.xls/Anil/UVBANK/23
**    Search String       : Log#123
**
**    Log Number          : 124
**    Modified By         : Reshmy R
**    Modified On         : 12-Dec-2008
**    Modified Reason     : Unicredit China, Rollover defaulting issue.
**    Retro Reference   : 10.3CLRetrolist.xls/Veena/Unicredit/89
**    Search String       : Log#124
**
**   Log Number          : 125
**   Modified By         : Arup Kundu
**   Modified On         : 20-Dec-2008
**   Modified Reason     : Alpha Bank. Account Generation was failining.
**   Retro Reference     : 10.3CLRetrolist.xls/Anil/ABA/18
**   Search String       : Log#125
**
**    Log Number         : 126
**    Modified By        : Suresh Sangapu
**    Modified On        : 22-Dec-2008
**    Modified Reason    : Changes to handle first_due_date in comp_sch and due_date in account_schedules not being in sync.
**    Retro Reference    : 10.3CLRetrolist.xls/Veena/DB-China/55
**    Search String      : Log#126

**    Log Number         : 127
**    Modified By        : L.N.Lavanya
**    Modified On        : 23-Dec-2008
**    Modified Reason    : Moratorium Schdule should be only applicable for MAIN Interest Component. DNBNord Latvia
                       Defaulting of Grace Days for Principal Schedules.
**    Retro Reference    : 10.3CLRetrolist.xls/Santhosh/DNBNORD/94
**    Search String      : Log#127

**    Log Number         : 128
**    Modified By        : L.N.Lavanya
**    Modified On        : 23-Dec-2008
**    Modified Reason    : Retro from ALLIANZ. VAMI Edit was giving error.
**    Retro Reference    : 10.3CLRetrolist.xls/Santhosh/DNBNORD/99
**    Search String      : Log#128

**    Log Number         : 129
**    Modified By        : L.N.Lavanya
**    Modified On        : 29-Dec-2008
**    Modified Reason    : 10.2 Validation for discounted product
**    Retro Reference    : 10.3CLRetrolist.xls/Demo/Acceleratorpack/14
**    Search String      : Log#129
**
**    Log Number         : 130
**    Modified By        : Arup Kundu
**    Modified On        : 31-Dec-2008
**    Modified Reason    : Alpha Bank Dual Formula issue
**    Retro Reference    : 10.3CLRetrolist.xls/Santosh/Santosh/68
**    Search String      : Log#130

**    Log Number             : 131
**    Modified By        : Nidhi Sachdeva
**    Modified On        : 06-Feb-2009
**    Modified Reason    : Retro from FC_UBS_V.UM_10.2.0.0.LoanOrigination.1.0
**    Search String          : FC_UBS_V.UM_10.2.0.0.LoanOrigination.1.0
**
**    Log Number             : 132
**    Modified By        : Santosh Sinha
**    Modified On        : 17-Mar-2009
**    Modified Reason    : FC10.3.ITR1 SFR#1345.
**                                               Product Level Capitalized option was checked for Moratorium schedules.
**                                               Account created using maturity Date screen. For Moratorium schedule capitalized option was not checked.
**    Search String          : Log#132

**      Log Number          :  133
**      Modified By         :  Arup Kundu
**      Modified On         :  03-APR-2009
**      Modified Reason     :  VAMI Change Tenor changes
**      Search String       :  LOG#133
**
**      Log Number          :  134
**      Modified By         :  Sunil Hande
**      Modified On         :  13-May-2009
**      Modified Reason     :  Principal Moratorium changes (Retroed from alphabank- bulgaria)
**      Search String       :  Log#134
**
**      Log Number          :  135
**      Modified By         :  Sunil Hande
**      Modified On         :  13-May-2009
**      Modified Reason     :  Changes to correct errors while Reducing Tenor for Loan PrePayment. (Retroed from alphabank- bulgaria)
**      Search String       :  Log#135

**      Log Number          :  136
**      Modified By         :  Bharat Kumar
**      Modified On         :  13-Jul-2009
**      Modified Reason     :  SFR No 970 FC 10.5 Kernel.Cascading Schedules not happening even at product level  cascade schedules is checked
**      Search String       :  Log#136

**       Log Number          :  137
**      Modified By         :  Bharat Kumar
**      Modified On         :  20-Jul-2009
**      Modified Reason     :  SFR No 1924 FC 10.5 Kernel.
**      Search String       :  Log#137

**      Log Number          :  138
**      Modified By         :  Jayanth S
**      Modified On         :  24-Jul-2009
**      Modified Reason     :  Changes to assign appropriate schedule dates for disbursement schedules
**      Search String       :  FC10.5 STR1 SFR# 1401

**       Log Number          :  139
**      Modified By         :  Bharat Kumar
**      Modified On         :  13-Aug-2009
**      Modified Reason     :  SFR No 3708 FC 10.5 Kernel. Allowing back dated vami Except Amortized loans.
**      Search String       :  Log#139

**      Log Number          :  140
**      Modified By         :  Suresh Sangapu
**      Modified On         :  20-Oct-2009
**      Modified Reason     :  9NT1316 FCUBS 11.0.0.0.0.0.0 Leasing changes for Advance and arrears schedules.
**      Search String       :  Log#140
**
**      Log Number          :  141
**      Modified By         :  Abhishek Ranjan
**      Modified On         :  10-Oct-2009
**      Modified Reason     :  FC11.0, Done to handle Principal Repayment holiday code
**      Search String       :  Log#141
**
**      Log Number          :  142
**      Modified By         :  Anub Mathew
**      Modified On         :  20-Oct-2009
**      Modified Reason     :  9NT1316 Linking CASA
**      Search String       :  Log#142 9NT1316 Linking CASA
**
**    Log Number	        	: 143
**    Modified By	    	    : Manohar Prasad
**    Modified On	    	    : 18-NOV-2009
**    Modified Reason       : FC110ITR1. SFR#480
**    Search String    	    : Log#143
**
**    Log Number	        	: 144
**    Modified By	    	    : Ajayma
**    Modified On	    	    : 19-NOV-2009
**    Modified Reason       : FC110ITR1. SFR#458
**    Search String    	    : Log#144
**
**    Log Number	    : 145
**    Modified By	    : Ritu Narang
**    Modified On	    : 20-NOV-2009
**    Modified Reason       : FC110ITR1. SFR#674
**    Search String    	    : Log#145
**
**    Log Number	        	: 145
**    Modified By	    	    : Saravanan K
**    Modified On	    	    : 20-NOV-2009
**    Modified Reason       : MO module handling
**    Search String    	    : Log#145
**
**    Log Number	        	: 146
**    Modified By	    	    : Abhishek Ranjan
**    Modified On	    	    : 20-NOV-2009
**    Modified Reason       : FC11.0 itr1, SFR#677 Handling Annuity Schedules for RML Product
**    Search String    	    : Log#146
**
**    Log Number	        	: 147
**    Modified By	    	    : Ajayma
**    Modified On	    	    : 21-NOV-2009
**    Modified Reason       : FC110ITR1. SFR#759
**    Search String    	    : Log#147
**
**    Log Number	          : 148
**    Modified By	          : Arup Kundu
**    Modified On	          : 24-NOV-2009
**    Modified Reason       : FC110ITR1. SFR#905
**    Search String    	    : Log#148
**
**    Log Number	        	: 149
**    Modified By	    	    : Abhishek Ranjan
**    Modified On	    	    : 01-Dec-2009
**    Modified Reason       : FC11.0 ITR1, SFR#1296 Handling Principal Repayment Holiday
**    Search String    	    : Log#149
**
**      Log Number          :  150
**      Modified By         :  Abhishek Ranjan
**      Modified On         :  07-Dec-2009
**      Modified Reason     :  SFR No 1682, FC 11.0, ERROR CODE IS WRONG
**      Search String       :  Log#150
**
**      Log Number          :  151
**      Modified By         :  Ritu Narang
**      Modified On         :  11-Dec-2009
**      Modified Reason     :  FC110ITR1 Sfr#1621 Changes of Log#145 Commented
**      Search String       :  Log#151
**
**      Log Number          :  152
**      Modified By         :  Suresh Sangapu
**      Modified On         :  11-Dec-2009
**      Modified Reason     :  FC110ITR1 Sfr#1184 Changes for subsidy component start date.
**      Search String       :  Log#152
**
**      Log Number          :  153
**      Modified By         :  ARUP KUNDU
**      Modified On         :  15-Dec-2009
**      Modified Reason     :  FC110ITR1 Sfr#1621
**      Search String       :  Log#153
**
**      Log Number          :  154
**      Modified By         :  Abhishek Ranjan
**      Modified On         :  16-Dec-2009
**      Modified Reason     :  SFR No 1979, FC 11.0, Failing in RML VAMI
**      Search String       :  Log#154
**
**      Log Number          :  155
**      Modified By         :  Yasser
**      Modified On         :  16-Dec-2009
**      Modified Reason     :  SFR No 1621, FC 11.0, Failing in Lease VAMI
**      Search String       :  SFR#1621
**
**      Log Number          :  156
**      Modified By         :  Suresh Sangapu
**      Modified On         :  16-Dec-2009
**      Modified Reason     :  SFR No 1979, FC 11.0 SFR#1621 operational lease advance edit expload.
**      Search String       :  Log#156
**
**      Log Number          :  157
**      Modified By         :  Abhishek Ranjan
**      Modified On         :  22-Dec-2009
**      Modified Reason     :  SFR No 33(ITR2), FC 11.0, Failing in RML VAMI
**      Search String       :  Log#157
**
**      Log Number          :  158
**      Modified By         :  Vijayagiri Sunil
**      Modified On         :  31-Dec-2009
**      Modified Reason     :  FC110ITR2 Sfr#360
**      Search String       :  Log#158
**
**      Log Number          :  159
**      Modified By         :  Arup Kundu
**      Modified On         :  30-Dec-2009
**      Modified Reason     :  FC110ITR2 Sfr#157
**      Search String       :  Log#159
**
**      Log Number          :  160
**      Modified By         :  Abhishek Ranjan
**      Modified On         :  30-Dec-2009
**      Modified Reason     :  FC110ITR2 Sfr#393
**      Search String       :  Log#160
**
**      Log Number          :  161
**      Modified By         :  Anub Mathew
**      Modified On         :  31-Dec-2009
**      Modified Reason     :  FC110ITR2 Sfr#342
**      Search String       :  Log#161

**      Log Number          :  162
**      Modified By         :  Ajay Yadav
**      Modified On         :  20-Jan-2010
**      Modified Reason     :  Changes for 11.1 Dev (Payment in Advance)
**      Search String       :  Log#162
**
**      Log Number          :  163
**      Modified By         :  Amit Singh Gehlot
**      Modified On         :  24-Feb-2010
**      Modified Reason     :  FC11.1 Retro for Site RESPB1022 SFR#31, To derive further schedule due dates correctly when the first due date moves to next month
**                          because of holidays.
**      Search String       :  Log#163

**
**    Log Number          : 164
**    Modified By         : Resmi Narayanan
**    Modified On         : 15-Mar-2010
**    Modified Reason     : FCUBS 11.1 : 9NT1368 - Changes for Open Line-Revolving Type Loan
**    Search String       : Log#164

**
**    Log Number          : 165
**    Modified By         : Ajay Yadav
**    Modified On         : 06-Apr-2010
**    Modified Reason     : Changes for 11.1 Dev (Payment in Advance)
**    Search String       : Log#165
**
**    Log Number          : 166
**    Modified By         : Satyakam Jena
**    Modified On         : 12-May-2010
**    Modified Reason     : FCUBS11.1 ITR1 SFR#1875
**    Search String       : FCUBS11.1 ITR1 SFR#1875
**
**    Log Number          : 167
**    Modified On         : 12-May-2010
**    Modified Reason     : FCUBS11.1 ITR1 SFR#1966
**    Search String       : SFR#1966

**    Log Number          : 168
**    Modified On         : 18-May-2010
**    Modified Reason     : FCUBS11.1 ITR1 SFR#1854
**    Search String       : FCUBS11.1 ITR1 SFR#1854

**    Log Number          : 169
**    Modified On         : 19-May-2010
**    Modified Reason     : FCUBS11.1 ITR1 SFR#3037
**    Search String       : FCUBS11.1 ITR1 SFR#3037

**    Log Number          : 170
**    Modified On         : 25-MAY-2010
**    Modified Reason     : FCUBS11.1 ITR1 SFR#3111
**    Search String       : FCUBS11.1 ITR1 SFR#3111

**    Log Number          : 171
**    Modified By         : Praveen Kumar D
**    Modified On         : 28-May-2010
**    Modified Reason     : FCUBS11.1 ITR1 SFR#3245
**    Search String       : SFR#3245
**    Log Number          : 172
**    Modified By         : Jai Mohan v
**    Modified On         : 31-May-2010
**    Modified Reason     : 9NT1368-ITR1-SFR#3883
**    Search String       : 9NT1368-ITR1-SFR#3883

**    Log Number          : 173
**    Modified By         : Vanitha
**    Modified On         : 2-June-2010
**    Modified Reason     : FCUBS11.1 ITR1 SFR#4124
**
**    Log Number          : 173
**    Modified By         : Veena H.
**    Modified On         : 10-Jun-2010
**    Modified Reason     : FCUBS11.1ITR1-SFR#3680 - Reduce tenor payment on a dual formula loan not rebuilding
**                          Comp_sch correctly.
**    Search String       : log#173
**
**    Log Number          : 174
**    Modified By         : Arun R Nath
**    Modified On         : 15-Jun-2010
**    Modified Reason     : While doing prepayment on a loan, cltb_account_comp_sch is not populated correctly.
**    Search String       : FCUBS ITR1 SFR#3680
**
**    Log Number          : 175
**    Modified By         : A Prasanna Kumar/Veena H.
**    Modified On         : 28-Jun-2010
**    Modified Reason     : FC11.1ITR1 SFR#6036- Past schedules of Include in EMI components getting nullified during VAMI.
**    Search String       : log#175

**    Log Number          : 176
**    Modified By         : gouri
**    Modified On         : 30-Jun-2010
**    Modified Reason     : FC11.1ITR1 SFR#4393- fields added in comp sch
**    Search String       : log#176

**    Log Number          : 177
**    Modified By         : Praveen Kumar R
**    Modified On         : 02-July-2010
**    Modified Reason     : FC11.1ITR1 SFR#6196
**    Search String       : log#177

**    Log Number          : 178
**    Modified By         : Ravi Kumar
**    Modified On         : 04-Aug-2010
**    Modified Reason     : FC11.1ITR2 SFR#977
**    Search String       : log#178
**
**    Log Number          : 179
**    Modified By         : A.Prasanna Kumar
**    Modified On         : 04-Aug-2010
**    Modified Reason     : FC11.1ITR2 1181. Incorrect bullet population during VAMI for Payment in advance.
**    Search String       : Log#179
**
**    Log Number          : 180
**    Modified By         : krishnarjuna
**    Modified On         : 29-Sep-2010
**    Modified Reason     : fc11.2 MB0765
**    Search String       : Log#180
**
**    Log Number          : 181
**    Modified By         : Veena H.
**    Modified On         : 19-Nov-2010
**    Modified Reason     : Don't allow to edit the partially settled bullet schedule.
**    Search String       : Log#181

**     Log Number              : 182
**     Modified By             : Abhishek Jain
**     Modified On             : 10-FEB-2011
**     Modified Reason         : Schedule First Due Date should not be checked if Due date on is maintained at Account level.
**     Retro Reference         : Retrolist.xls/Earlier than 10.5/FC10_IMPSUPP/FIMBANK/FIMB/155
**     Search String           : Log#182
**     Log Number              : 183
**     Modified By             : MuraliDharan R.
**     Modified On             : 25-Aug-2011
**     Modified Reason         : 9NT1474 Kernel 11.3 Patchset P01 for SFR FC11.1_IMPSUPP_404
       Error in schedule dates computation if "DD" part of First due date is in the next month and Due dates on specified.
**     Retro Reference         : [Blr_site_code--FCUBS11.1->IMPSUPP->RONBTR->SFR-404]/[RONBTRKFCC0041]
**     Search String           : Log#183 Changes

**   Log Number          : 182
**   Modified By         : Santosh Sinha
**   Modified On         : 11-Nov-2011
**   Modified Reason     : Harcoading of MAIN_INT is removed.
**   Search String       : 13374562

**    Log Number          : 184
**    Modified By         : Saswat Sahoo
**    Modified On         : 16-Feb-2012
**    Modified Reason     : RAKBANK Changes. FCUBS_113_13634866
**    Search String       : RAKBANK Changes FCUBS_113_13634866

Changed By : Raj
Description : System is not allowing to have first_due_date after 1 month from loan creation date, if schedule freequency is monthly.
Search String : NRAKAEFCC0247 14235943

*************************************************************************************************/
 IS

   ---
   --PERF CHANGES Starts, moved to SPEC
   --    --Phase II NLS changes start
   --    PKG_MAIN_INT   cltbs_account_schedules.component_name%type;
   --
   --    PKG_PRINCIPAL cltbs_account_schedules.component_name%type;
   --    --Phase II NLS changes end

   TYPE Ty_Schedule_Date IS TABLE OF DATE INDEX BY PLS_INTEGER;
   TYPE g_Ty_Tb_For_Disbr IS TABLE OF VARCHAR(100) INDEX BY PLS_INTEGER;

   -- Log#106 Start.
   --TYPE pkg_tb_amount_accrued IS TABLE of cltbs_account_schedules.accrued_amount%TYPE INDEX BY cltbs_account_schedules.component_name%TYPE;
   TYPE Ty_Rec_Amount_Accrued IS RECORD(
      Accrued_Amount   Cltbs_Account_Schedules.Accrued_Amount%TYPE,
      Susp_Amt_Due     Cltbs_Account_Schedules.Susp_Amt_Due%TYPE,
      Susp_Amt_Lcy     Cltbs_Account_Schedules.Susp_Amt_Lcy %TYPE,
      Susp_Amt_Settled Cltbs_Account_Schedules.Susp_Amt_Settled %TYPE);
   TYPE Pkg_Tb_Amount_Accrued IS TABLE OF Ty_Rec_Amount_Accrued INDEX BY Cltbs_Account_Schedules.Component_Name%TYPE;
   -- Log#106 End.
   g_Date_Flag       NUMBER := 0; ----log#73
   Pkg_Interest_Rate Cltms_Product_Components.Rate_To_Use%TYPE; -- log#119 changes
   --Pkg_lease_advance BOOLEAN:= FALSE;  --Log#145  ----lOG#151
   --======================================================================================================
   --   Forward Declaration begins
   --======================================================================================================
   --Log#141 Abhishek Ranjan for Principal Repyament Holiday 14.09.2009 Starts
      FUNCTION fn_regen_compsch_prinhol( p_account_rec       IN OUT NOCOPY clpkss_object.ty_rec_account
                                        ,p_action_code       IN            VARCHAR2
                                        ,p_start_redef_from  IN            DATE
                                        ,p_component         IN            cltbs_account_components.component_name%TYPE
                                        ,p_err_code          IN OUT        ertbs_msgs.err_code%TYPE
                                        ,p_err_param         IN OUT        ertbs_msgs.message%TYPE
                                       )
      RETURN BOOLEAN;
    --Log#141 Abhishek Ranjan for Principal Repyament Holiday 14.09.2009 Ends
   FUNCTION Fn_Get_Actual_Split_Date(p_Comp_Rec         IN OUT NOCOPY Clpkss_Object.Ty_Rec_Components
                                    ,p_Eff_Date         IN DATE
                                    ,p_Schedule_Type    IN Cltbs_Account_Comp_Sch.Schedule_Type%TYPE
                                    ,p_First_Split_Date OUT DATE
                                    ,p_Err_Code         IN OUT Ertbs_Msgs.Err_Code%TYPE)
      RETURN BOOLEAN;
   --CL PHASE II IQA SUPP SFR #85 starts
   /*FUNCTION fn_get_next_schedule_date(p_source_date     IN DATE,
                                      p_frequency_units IN cltms_product_dflt_schedules.frequency_unit%TYPE,
                                      p_frequency       IN cltms_product_dflt_schedules.frequency%TYPE)
   RETURN DATE;*/
   --CL PHASE II IQA SUPP SFR #85 ends
   --Log#121 FC 10.1 LS Changes starts
   /* FUNCTION fn_get_final_schedule_date(p_source_date        IN DATE,
                                       p_branch_code        IN cltbs_account_master.branch_code%TYPE,
                                       p_product_code       IN cltbs_account_master.product_code%TYPE,
                                       --Sudharshan : Mar 18,2005
                                       --p_ignore_holiday     IN cltbs_account_master.ignore_holidays%TYPE,
                                       p_ignore_holiday     IN cltms_product.ignore_holidays%TYPE,
                                       p_forward_backward   IN cltms_product.schedule_movement%TYPE,
                                       p_move_across_month  IN cltms_product.move_across_month%TYPE,
                                       --Sudharshan : Mar 18,2005
                                       p_value_date         IN cltbs_account_master.value_date%TYPE,
                                       p_maturity_date      IN cltbs_account_master.maturity_date%TYPE,
                                       --CL PHASE II IQA SUPP SFR #85 starts
                                       p_frequency          IN cltms_product_dflt_schedules.frequency%TYPE,
                                       p_frequency_unit     IN cltms_product_dflt_schedules.frequency_unit%TYPE,
                           --euro bank retro changes LOG#103 starts
                       -- LOG#102 EUROBANK Billing Periodicity changes start
                                       p_due_dates_on_acc   IN cltbs_account_master.due_dates_on%type,
                       -- LOG#102 EUROBANK Billing Periodicity changes end
                           --euro bank retro changes LOG#103 ends
                                       --CL PHASE II IQA SUPP SFR #85 ends
                                       --CL PHASE II IQA SUPP SFR #85 ends
                                       p_schedule_date      IN OUT cltbs_account_schedules.schedule_due_date%TYPE,
                                       p_error_code         IN OUT ertbs_msgs.err_code%TYPE,
                       -- Start Log#116
                                       p_schedule_type      IN cltms_product_dflt_schedules.schedule_type%TYPE DEFAULT 'P')
                       -- End Log#116
   RETURN BOOLEAN ;*/
   -- Log#121 FC 10.1 LS Changes ends

   FUNCTION Fn_Compute_Schedule_Dates(p_Start_Date      IN Cltbs_Account_Comp_Sch.Sch_Start_Date%TYPE
                                     ,p_Value_Date      IN Cltbs_Account_Master.Value_Date%TYPE
                                     ,p_Maturity_Date   IN Cltbs_Account_Master.Maturity_Date%TYPE
                                     ,p_Branch_Code     IN Cltbs_Account_Master.Branch_Code%TYPE
                                     ,p_Product_Code    IN Cltbs_Account_Master.Product_Code%TYPE
                                     ,p_Frequency       IN Cltms_Product_Dflt_Schedules.Frequency%TYPE
                                     ,p_Frequency_Units IN Cltms_Product_Dflt_Schedules.Frequency_Unit%TYPE
                                     ,p_No_Of_Schedules IN Cltbs_Account_Comp_Sch.No_Of_Schedules%TYPE
                                     ,
                                      --Sudharshan : Mar 18,2005
                                      --p_ignore_holiday     IN cltbs_account_master.ignore_holidays%TYPE,
                                      p_Ignore_Holiday    IN Cltms_Product.Ignore_Holidays%TYPE
                                     ,p_Forward_Backward  IN Cltms_Product.Schedule_Movement%TYPE
                                     ,p_Move_Across_Month IN Cltms_Product.Move_Across_Month%TYPE
                                     ,p_Cascade_Movement  IN Cltms_Product.Cascade_Schedules%TYPE
                                     ,p_Due_Dates_On      IN Cltms_Product_Dflt_Schedules.Due_Dates_On%TYPE
                                     ,
                                      --Sudharshan : Mar 18,2005
                                      -- LOG#102 EUROBANK  Periodicity changes start
                                      p_Due_Dates_On_Acc IN Cltbs_Account_Master.Due_Dates_On%TYPE
                                     ,
                                      --euro bank retro changes LOG#103 starts
                                      -- LOG#102 EUROBANK Billing Periodicity changes end
                                      --euro bank retro changes LOG#103 ends
                                      p_Ty_Schedule_Date IN OUT Ty_Schedule_Date
                                     ,p_Error_Code       IN OUT Ertbs_Msgs.Err_Code%TYPE
                                     ,
                                      --Start Log#116
                                      p_Schedule_Type IN Cltms_Product_Dflt_Schedules.Schedule_Type%TYPE)
   --End Log#116

    RETURN BOOLEAN;

   FUNCTION Fn_Add_Months(p_Date_In      IN DATE
                         ,p_Months_Shift IN NUMBER) RETURN DATE;

   FUNCTION Fn_Populate_Account_Schedules(p_Tb_Payment_Schedules IN Clpkss_Object.Ty_Tb_Account_Comp_Sch
                                         ,p_Account_No           IN Cltbs_Account_Master.Account_Number%TYPE
                                         ,p_Branch_Code          IN Cltbs_Account_Master.Branch_Code%TYPE
                                         ,p_Product_Code         IN Cltbs_Account_Master.Product_Code%TYPE
                                         ,p_Process_No           IN Cltbs_Account_Master.Process_No%TYPE
                                         ,p_Comp_Det             IN Cltbs_Account_Components%ROWTYPE
                                         ,p_Value_Date           IN Cltbs_Account_Master.Value_Date%TYPE
                                         ,p_Maturity_Date        IN Cltbs_Account_Master.Maturity_Date%TYPE
										 ,p_module_code        IN Cltbs_Account_Master.Module_code%TYPE   -- Log#162 Changes for 11.1 Dev (Payment in Advance)
                                         ,
                                          --Sudharshan : Mar 18,2005
                                          --p_ignore_holiday     IN cltbs_account_master.ignore_holidays%TYPE,
                                          p_Ignore_Holiday    IN Cltms_Product.Ignore_Holidays%TYPE
                                         ,p_Forward_Backward  IN Cltms_Product.Schedule_Movement%TYPE
                                         ,p_Move_Across_Month IN Cltms_Product.Move_Across_Month%TYPE
                                         ,p_Cascade_Movement  IN Cltms_Product.Cascade_Schedules%TYPE
                                         ,
                                          --Sudharshan : Mar 18,2005
                                          p_Out_Tb_Amt_Due    OUT Clpkss_Object.Ty_Tb_Amt_Due
                                         ,p_Out_Tb_Amort_Dues OUT Clpkss_Object.Ty_Tb_Amt_Due
                                         ,
                                          -- START L Anantharaman 11-Apr-2005 FCCCL1.0 PhaseII reduce tenor changes
                                          p_New_Amt_Dues      IN Clpkss_Object.Ty_Tb_Amt_Due
                                         ,p_New_Prin_Amt_Dues IN Clpkss_Object.Ty_Tb_Amt_Due
                                         , -- for amortized principal amount dues
                                          -- END L Anantharaman 11-Apr-2005 FCCCL1.0 PhaseII reduce tenor changes
                                          --START LOG#46 23-May-2005 SFR#1
                                          p_Build_Schs_From IN DATE
                                         ,
                                          --END LOG#46 23-May-2005 SFR#1
                                          --log#111 retro starts
                                          p_Action_Code IN VARCHAR2
                                         ,
                                          --log#111 retro ends

                                          p_Error_Code IN OUT Ertbs_Msgs.Err_Code%TYPE)
      RETURN BOOLEAN;

   FUNCTION Fn_Populate_Disbursments(p_Tb_Disbr_Schedules IN Clpkss_Object.Ty_Tb_Account_Comp_Sch
                                    ,p_Account_No         IN Cltbs_Account_Master.Account_Number%TYPE
                                    ,p_Branch_Code        IN Cltbs_Account_Master.Branch_Code%TYPE
                                    ,p_Product_Code       IN Cltbs_Account_Master.Product_Code%TYPE
                                    ,p_Comp_Det           IN Cltbs_Account_Components%ROWTYPE
                                    ,p_Value_Date         IN Cltbs_Account_Master.Value_Date%TYPE
                                    ,p_Maturity_Date      IN Cltbs_Account_Master.Maturity_Date%TYPE
                                    ,p_Principal          IN Cltbs_Account_Master.Amount_Financed%TYPE
                                    ,
                                     --Sudharshan : Mar 18,2005
                                     --p_ignore_holiday     IN cltbs_account_master.ignore_holidays%TYPE,
                                     p_Ignore_Holiday    IN Cltms_Product.Ignore_Holidays%TYPE
                                    ,p_Forward_Backward  IN Cltms_Product.Schedule_Movement%TYPE
                                    ,p_Move_Across_Month IN Cltms_Product.Move_Across_Month%TYPE
                                    ,p_Cascade_Movement  IN Cltms_Product.Cascade_Schedules%TYPE
                                    ,
                                     --Sudharshan : Mar 18,2005
                                     p_Out_Tb_Disbr_Schs OUT Clpkss_Object.Ty_Tb_Disbr_Schedules
                                    ,p_Error_Code        IN OUT Ertbs_Msgs.Err_Code%TYPE)

    RETURN BOOLEAN;
   FUNCTION Fn_Populate_Revisions(p_Tb_Revn_Schedules IN Clpkss_Object.Ty_Tb_Account_Comp_Sch
                                 ,p_Account_No        IN Cltbs_Account_Master.Account_Number%TYPE
                                 ,p_Branch_Code       IN Cltbs_Account_Master.Branch_Code%TYPE
                                 ,p_Product_Code      IN Cltbs_Account_Master.Product_Code%TYPE
                                 ,p_Comp_Det          IN Cltbs_Account_Components%ROWTYPE
                                 ,p_Value_Date        IN Cltbs_Account_Master.Value_Date%TYPE
                                 ,p_Maturity_Date     IN Cltbs_Account_Master.Maturity_Date%TYPE
                                 ,
                                  --Sudharshan : Mar 18,2005
                                  --p_ignore_holiday     IN cltbs_account_master.ignore_holidays%TYPE,
                                  p_Ignore_Holiday    IN Cltms_Product.Ignore_Holidays%TYPE
                                 ,p_Forward_Backward  IN Cltms_Product.Schedule_Movement%TYPE
                                 ,p_Move_Across_Month IN Cltms_Product.Move_Across_Month%TYPE
                                 ,p_Cascade_Movement  IN Cltms_Product.Cascade_Schedules%TYPE
                                 ,
                                  --Sudharshan : Mar 18,2005
                                  p_Out_Tb_Revn_Schs OUT Clpkss_Object.Ty_Tb_Revn_Schedules
                                 ,p_Error_Code       IN OUT Ertbs_Msgs.Err_Code%TYPE)
      RETURN BOOLEAN;

   FUNCTION Fn_Clear_Deleted_Schedules(p_Account_Rec IN OUT NOCOPY Clpkss_Object.Ty_Rec_Account
                                      ,p_Err_Code    IN OUT Ertbs_Msgs.Err_Code%TYPE
                                      ,p_Err_Param   IN OUT Ertbs_Msgs.Message%TYPE)
      RETURN BOOLEAN;
   FUNCTION Fn_Is_Within_Tolerance(p_Absoulte_Amt IN Cltbs_Account_Master.Amount_Financed%TYPE
                                  ,p_Rounded_Amt  IN Cltbs_Account_Master.Amount_Financed%TYPE
                                  ,p_No_Of_Units  IN Cltbs_Account_Comp_Sch.No_Of_Schedules%TYPE
                                  ,p_Ccy          IN Cytms_Ccy_Defn.Ccy_Code%TYPE
                                  ,p_Result       OUT VARCHAR2) RETURN BOOLEAN;
   FUNCTION Fn_Store_Amount_Accrued(p_Account_Rec IN OUT NOCOPY Clpkss_Object.Ty_Rec_Account
                                   ,
                                    --START Prasanna FCCCL 1.0 MTR1 SFR#524 9NT252 20-DEC-2004
                                    --p_eff_date           IN            cltbs_matdt_chg.effective_date%TYPE,
                                    p_Eff_Date IN DATE
                                   ,
                                    --END Prasanna FCCCL 1.0 MTR1 SFR#524 9NT252 20-DEC-2004
                                    p_Tb_Amount_Accrued OUT Clpks_Schedules.Pkg_Tb_Amount_Accrued
                                   ,p_Err_Code          IN OUT Ertbs_Msgs.Err_Code%TYPE
                                   ,p_Err_Param         IN OUT Ertbs_Msgs.Message%TYPE)
      RETURN BOOLEAN;

   FUNCTION Fn_Apply_Amt_Accrued(p_Account_Rec IN OUT NOCOPY Clpkss_Object.Ty_Rec_Account
                                ,
                                 --START Prasanna FCCCL 1.0 MTR1 SFR#524 9NT252 20-DEC-2004
                                 --p_eff_date          IN            cltbs_matdt_chg.effective_date%TYPE,
                                 p_Eff_Date IN DATE
                                ,
                                 --END Prasanna FCCCL 1.0 MTR1 SFR#524 9NT252 20-DEC-2004
                                 p_Tb_Amount_Accrued IN Clpks_Schedules.Pkg_Tb_Amount_Accrued
                                ,p_Err_Code          IN OUT Ertbs_Msgs.Err_Code%TYPE
                                ,p_Err_Param         IN OUT Ertbs_Msgs.Message%TYPE)
      RETURN BOOLEAN;
   FUNCTION Fn_Fill_Schedule_Gaps(p_Account_Rec IN OUT NOCOPY Clpkss_Object.Ty_Rec_Account
                                 ,
                                  --euro bank retro changes LOG#103 starts
                                  --LOG#102 EUROBANK Billing Periodicity changes start
                                  p_Due_Dates_On_Acc IN Cltbs_Account_Master.Due_Dates_On%TYPE
                                 ,
                                  --LOG#102 EUROBANK Billing Periodicity changes end
                                  --euro bank retro changes LOG#103 ends
                                  p_Err_Code  IN OUT Ertbs_Msgs.Err_Code%TYPE
                                 ,p_Err_Param IN OUT Ertbs_Msgs.Message%TYPE) RETURN BOOLEAN;

   FUNCTION Fn_Gen_Create_Schedule(p_Account_Rec    IN OUT NOCOPY Clpkss_Object.Ty_Rec_Account
                                  ,p_Action_Code    IN VARCHAR2
                                  ,p_Effective_Date IN DATE
                                  ,
                                   --euro bank retro changes LOG#103 starts
                                   -- start  month end periodicity log#102
                                   p_Due_Dates_On_Acc IN Cltbs_Account_Master.Due_Dates_On%TYPE
                                  ,
                                   -- end  month end periodicity log#102
                                   --euro bank retro changes LOG#103 ends
                                   p_Err_Code  IN OUT Ertbs_Msgs.Err_Code%TYPE
                                  ,p_Err_Param IN OUT Ertbs_Msgs.Message%TYPE)

    RETURN BOOLEAN;
   FUNCTION Fn_Gen_Validate_Schedules(p_Account_Rec IN OUT NOCOPY Clpkss_Object.Ty_Rec_Account
                                     ,p_Action_Code IN VARCHAR2
                                     ,p_Err_Code    IN OUT Ertbs_Msgs.Err_Code%TYPE
                                     ,p_Err_Param   IN OUT Ertbs_Msgs.Message%TYPE)
      RETURN BOOLEAN;
   FUNCTION Fn_Apply_Calender_Prefs(p_Ref_Date       IN Cltbs_Account_Schedules.Schedule_Due_Date%TYPE
                                   ,p_Due_Dates_On   IN Cltms_Product_Dflt_Schedules.Due_Dates_On%TYPE
                                   ,p_Start_Ref      IN Cltms_Product_Dflt_Schedules.Start_Reference%TYPE
                                   ,p_Frequency_Unit IN Cltms_Product_Dflt_Schedules.Frequency_Unit%TYPE
                                   ,p_Start_Date     IN Cltms_Product_Dflt_Schedules.Start_Date%TYPE
                                   ,p_Start_Month    IN Cltms_Product_Dflt_Schedules.Start_Month%TYPE
                                   ,

                                    --Start log#72
                                    p_Ins_Start_Date IN DATE
                                   ,
                                    --log#72

                                    p_Due_Date OUT Cltbs_Account_Schedules.Schedule_Due_Date%TYPE)
   --p_err_code         IN  OUT ertbs_msgs.err_code%TYPE,
      --p_err_param        IN  OUT ertbs_msgs.message%TYPE)
    RETURN BOOLEAN;

   FUNCTION Fn_Apply_Duedateson_Pref(p_Ref_Date       IN Cltbs_Account_Schedules.Schedule_Due_Date%TYPE
                                    ,p_Due_Dates_On   IN Cltms_Product_Dflt_Schedules.Due_Dates_On%TYPE
                                    ,p_Frequency_Unit IN Cltms_Product_Dflt_Schedules.Frequency_Unit%TYPE
                                    ,p_Due_Date       OUT Cltbs_Account_Schedules.Schedule_Due_Date%TYPE)
      RETURN BOOLEAN;
   --
   -- Log#87 Start.
   FUNCTION Fn_Get_Acc_Schs_For_a_Linkage(p_Out_Acc_Schs     IN OUT Clpkss_Object.Ty_Tb_Amt_Due
                                         ,p_Schedule_Linkage IN Cltbs_Account_Schedules.Schedule_Linkage%TYPE
                                         ,p_Error_Code       IN OUT Ertbs_Msgs.Err_Code%TYPE)
      RETURN BOOLEAN;
   FUNCTION Fn_Get_New_Split_Schedules(p_Eff_Comp_Sch_Rec       IN OUT Clpkss_Object.Ty_Rec_Account_Comp_Sch
                                      ,p_Eff_Sch_New_End_Dt     IN Cltbs_Account_Comp_Sch.Sch_End_Date%TYPE
                                      , --l_last_sch_end_dt
                                       p_Eff_Sch_New_Sch_Cnt    IN Cltbs_Account_Comp_Sch.No_Of_Schedules%TYPE
                                      , --l_past_sch_cnt           IN
                                       p_New_Sch_First_Due_Date IN Cltbs_Account_Comp_Sch.First_Due_Date%TYPE
                                      ,p_Cascade_Movement       IN Cltms_Product.Cascade_Schedules%TYPE
                                      , --l_next_sch_date
                                       p_New_Comp_Sch_Rec       OUT Clpkss_Object.Ty_Rec_Account_Comp_Sch
                                      ,p_Error_Code             IN OUT Ertbs_Msgs.Err_Code%TYPE)
      RETURN BOOLEAN;
   -- Log#87 End.
   --

   --======================================================================================================
   --   Forward Declaration ends
   --======================================================================================================

   PROCEDURE Dbg(p_Error_Msg IN VARCHAR2) IS
   BEGIN

      IF Debug.Pkg_Debug_On <> 2 THEN
         -- log#112 Retro - HP BENCHMARK CHANGES
         Debug.Pr_Debug('CL', 'clpks_schedules->' || p_Error_Msg);
      END IF; -- log#112 Retro - HP BENCHMARK CHANGES
   END Dbg;

   -- SCHEDULE CLEANUP. GET_AMT_SETTLED_FOR_A_SCHEDULE
   FUNCTION Fn_Get_Amt_Settled(p_Brn    VARCHAR2
                              ,p_Acc    VARCHAR2
                              ,p_Comp   VARCHAR2
                              ,p_Due_Dt DATE) RETURN NUMBER IS
      l_Amt NUMBER;
   BEGIN

      SELECT Nvl(SUM(Nvl(Amount_Paid, 0) + Nvl(Amount_Waived, 0) +
                      Nvl(Amount_Capitalized, 0))
                 ,0)
      INTO   l_Amt
      FROM   Cltb_Amount_Paid
      WHERE  Account_Number = p_Acc AND Branch_Code = p_Brn AND Component_Name = p_Comp AND
             Due_Date = p_Due_Dt; -- PERF CHANGES, inter changed brn and acc

      RETURN l_Amt;
   EXCEPTION
      WHEN OTHERS THEN
         Dbg('Failed to get Amt Settled as i failed with ' || SQLERRM);
         RETURN 0;
   END Fn_Get_Amt_Settled;

   FUNCTION Fn_Get_Schs_For_Comp(p_Product        IN Cltms_Product.Product_Code%TYPE
                                ,p_Component_Name IN Cltms_Product_Components.Component_Name%TYPE
                                ,p_Tb_Dflt_Schs   OUT NOCOPY Ty_Tb_Comp_Dflt_Schs
                                ,p_Err_Cd         IN OUT Ertbs_Msgs.Err_Code%TYPE
                                ,p_Err_Param      IN OUT Ertbs_Msgs.Message%TYPE)
      RETURN BOOLEAN IS
      l_Tb_Pmnt_Schs Ty_Tb_Comp_Dflt_Schs;
      l_Tb_Nonp_Schs Ty_Tb_Comp_Dflt_Schs;

      ---
      -- PERF CHANGES Log#86 Starts ON 31-Jan-2006
      --CURSOR cr_nonP_schs IS
      --    SELECT *
      --    FROM cltms_product_dflt_schedules
      --    WHERE PRODUCT_CODE = p_product
      --    AND component_name = p_component_name
      --    AND schedule_type <> 'P'
      --    ORDER BY schedule_type, seq_no;
      -- PERF CHANGES Log#86 Ends ON 31-Jan-2006
      ---

      CURSOR Cr_Pmnt_Schs IS
         SELECT *
         FROM   Cltms_Product_Dflt_Schedules
         WHERE  Product_Code = p_Product AND Component_Name = p_Component_Name AND
                Schedule_Type = 'P'
         ORDER  BY Seq_No;

      l_Chk PLS_INTEGER;

      PROCEDURE Pr_Merge_Tabs IS
         l_Indx PLS_INTEGER;
      BEGIN

         p_Tb_Dflt_Schs := l_Tb_Nonp_Schs;

         l_Indx := l_Tb_Pmnt_Schs.FIRST;

         IF l_Indx IS NULL THEN

            RETURN;
         ELSE

            WHILE l_Indx IS NOT NULL LOOP
               p_Tb_Dflt_Schs(Nvl(p_Tb_Dflt_Schs.LAST, 0) + 1) := l_Tb_Pmnt_Schs(l_Indx);
               l_Indx := l_Tb_Pmnt_Schs.NEXT(l_Indx);
            END LOOP;

         END IF;
      END Pr_Merge_Tabs;
   BEGIN
      Dbg('fn_get_schs_for_comp::just came in');
      ---
      -- PERF CHANGES Log#86 Starts on 31-Jan-2006
      --OPEN cr_nonP_schs;
      --FETCH cr_nonP_schs BULK COLLECT INTO l_tb_nonP_schs;
      --CLOSE cr_nonP_schs;

      l_Tb_Nonp_Schs := Clpkss_Cache.Fn_Get_Nonp_Schs(p_Product, p_Component_Name);

      -- PERF CHANGES Log#86 Ends on 31-Jan-2006
      ---

      -----31/Jan/2006 Dual formula changes ends*/

      -- log#114 Start
      /*
          IF g_tb_prd_dflt_schs.EXISTS(p_component_name)
          THEN
              l_tb_pmnt_schs := g_tb_prd_dflt_schs(p_component_name).g_tb_comp_dflt_schs;
          END IF;
      -----31/Jan/2006 Dual formula changes ends
      --

          IF  l_tb_pmnt_schs.COUNT = 0 THEN
              OPEN cr_pmnt_schs;
              FETCH cr_pmnt_schs BULK COLLECT INTO l_tb_pmnt_schs;
              CLOSE cr_pmnt_schs;
          END IF;
      */

      BEGIN
         l_Tb_Pmnt_Schs := g_Tb_Prd_Dflt_Schs(p_Component_Name).g_Tb_Comp_Dflt_Schs;
      EXCEPTION
         WHEN No_Data_Found THEN
            OPEN Cr_Pmnt_Schs;
            FETCH Cr_Pmnt_Schs BULK COLLECT
               INTO l_Tb_Pmnt_Schs;
            CLOSE Cr_Pmnt_Schs;
      END;
      -- log#114 End

      Pr_Merge_Tabs;

      Dbg('after merge ::total count is ' || p_Tb_Dflt_Schs.COUNT);
      l_Tb_Pmnt_Schs.DELETE;
      l_Tb_Nonp_Schs.DELETE;

      RETURN TRUE;

   EXCEPTION
      WHEN OTHERS THEN
         ---
         -- PERF CHANGES Log#86 Starts on 31-Jan-2006
         --IF cr_nonP_schs%ISOPEN THEN
         --     CLOSE cr_nonP_schs;
         -- END IF;
         --
         -- IF cr_nonP_schs%ISOPEN THEN
         --     CLOSE cr_nonP_schs;
         -- END IF;
         -- PERF CHANGES Log#86 Ends on 31-Jan-2006
         ---

         l_Tb_Pmnt_Schs.DELETE;
         l_Tb_Nonp_Schs.DELETE;
         p_Tb_Dflt_Schs.DELETE;

         RETURN FALSE;
   END Fn_Get_Schs_For_Comp;

   FUNCTION Fn_Create_Schedule(p_Account_Rec    IN OUT NOCOPY Clpkss_Object.Ty_Rec_Account
                              ,p_Action_Code    IN VARCHAR2
                              ,p_Effective_Date IN DATE
                              ,p_Err_Code       IN OUT Ertbs_Msgs.Err_Code%TYPE
                              ,p_Err_Param      IN OUT Ertbs_Msgs.Message%TYPE)

    RETURN BOOLEAN IS
   BEGIN
   Dbg('Here in Fn_Create_Schedule before exec Clpkss_Stream_Schedules');
      IF NOT Clpkss_Stream_Schedules.Fn_Pre_Create_Schedule(p_Account_Rec
                                                           ,p_Action_Code
                                                           ,p_Effective_Date
                                                           ,p_Err_Code
                                                           ,p_Err_Param) THEN
         RETURN FALSE;
      END IF;
	Dbg('Here in Fn_Create_Schedule before exec Fn_Ovrdn_Create_Schedule');
      IF Clpkss_Stream_Schedules.Fn_Ovrdn_Create_Schedule THEN
         IF NOT Clpkss_Stream_Schedules.Fn_Create_Schedule(p_Account_Rec
                                                          ,p_Action_Code
                                                          ,p_Effective_Date
                                                          ,p_Err_Code
                                                          ,p_Err_Param) THEN
            RETURN FALSE;
         END IF;
      ELSE
      Dbg('Here in Fn_Create_Schedule before exec Fn_Gen_Create_Schedule');
         IF NOT Fn_Gen_Create_Schedule(p_Account_Rec
                                      ,p_Action_Code
                                      ,p_Effective_Date
                                      ,
                                       --euro bank retro changes LOG#103 starts
                                       -- start  month end periodicity log#102
                                       NULL
                                      ,
                                       -- end  month end periodicity log#102
                                       --euro bank retro changes LOG#103 ends
                                       p_Err_Code
                                      ,p_Err_Param) THEN
            RETURN FALSE;
         END IF;

      END IF;
      IF NOT Clpkss_Stream_Schedules.Fn_Post_Create_Schedule(p_Account_Rec
                                                            ,p_Action_Code
                                                            ,p_Effective_Date
                                                            ,p_Err_Code
                                                            ,p_Err_Param) THEN
         RETURN FALSE;
      END IF;
      RETURN TRUE;

   EXCEPTION
      WHEN OTHERS THEN
         Clpkss_Logger.Pr_Log_Exception('');

         p_Err_Code  := 'CL-SCH036;';
         p_Err_Param := 'fn_create_schedules~;';
         Ovpkss.Pr_Appendtbl(p_Err_Code, p_Err_Param);

         Dbg('bombed in fn_create_schedule with ' || SQLERRM);

         RETURN FALSE;

   END Fn_Create_Schedule;

   /*============================================================================================
   Logic of fn_create_schedules:
   --gets called for action codes:
   1>DFLT: Read schedules from cltm_product_dflt_schedules and populates cltb_account_comp_sch
           Then calls routines to populate detail tables(account_schedules ,rev_schedules etc)
   2>NEW : when user changes schedule defns before auth.
           All detail tables are deleted(i.e. equivalent structure  in account object and not the actual tables)
           and
           recreated with new schedule defns(cltb_Account_comp_sch rows).
   3>ROLL: account schedules ,rev schedules are populated from given schedule defns.
   4>REDEF:comes with this action code when contract amendment happens.
           Detail schedule defintions are deleted for the schedules which are being redefined.
           Past schedules are not supposed to be deleted.
           for changed schedule definitions(comp_sch) detailed tables are again populated.

   ============================================================================================*/

   -- Rajasekhar log#42
   FUNCTION Fn_Gen_Sch_No(p_Account_Rec IN OUT NOCOPY Clpkss_Object.Ty_Rec_Account
                         ,p_Err_Code    IN OUT VARCHAR2
                         ,p_Err_Param   IN OUT VARCHAR2) RETURN BOOLEAN IS
      l_Indx      VARCHAR2(100);
      l_Idx       VARCHAR2(10);
      l_Comp_Indx VARCHAR2(100);
      l_Due_Indx  VARCHAR2(100);
      i           NUMBER := 1;
      l_Dt_Ext    BOOLEAN := FALSE;
      -- RUBHCFB SFR NO. 414 Log#999 starts
      l_Sch_Flg BOOLEAN := FALSE;
      -- RUBHCFB SFR NO. 414 Log#999 Ends
      ---
      -- PERF CHANGES Starts
      --l_ty_sch_dt              clpkss_object.ty_sch_dt;
      l_Ty_Sch_Dt Dbms_Sql.Number_Table;
      -- PERF CHANGES Ends
      ---

      --TYPE ty_sch_dt IS TABLE OF date INDEX BY pls_integer;

      --
      -- Log#57 Starts.
      l_Temp_Ty_Sch_Dt Clpkss_Object.Ty_Sch_Dt;
      l_Idx1           VARCHAR2(10);
      -- Log#57 Ends.
      --

   BEGIN
      Debug.Pr_Debug('CL', 'ENtering fn_gen_csh_no');
      l_Comp_Indx := p_Account_Rec.g_Tb_Components.FIRST;
      WHILE l_Comp_Indx IS NOT NULL LOOP
         l_Due_Indx := p_Account_Rec.g_Tb_Components(l_Comp_Indx).g_Tb_Amt_Due.FIRST;
         WHILE l_Due_Indx IS NOT NULL LOOP
            ---
            -- PERF CHANGES Starts
            --                l_idx := l_ty_sch_dt.first;
            --                              while l_idx is not NULL
            --                        loop
            --                               if l_ty_sch_dt(l_idx)= p_account_rec.g_tb_components(l_comp_indx).g_tb_amt_due(l_due_indx).
            --                                                                               g_amount_due.schedule_due_date then
            --                                   l_dt_ext:=TRUE;
            --                                end if;
            --                                exit when l_dt_ext=TRUE;
            --                                l_idx := l_ty_sch_dt.NEXT(L_IDX);
            --                        END LOOP;
            --                    if l_dt_ext = FALSE then
            --                  l_ty_sch_dt(i):=TO_DATE(p_account_rec.g_tb_components(l_comp_indx).g_tb_amt_due(l_due_indx).
            --                                                                             g_amount_due.schedule_due_date,'DD-MM-YY');
            --                         i:=i+1;
            --                    end if;
            --                       l_dt_ext:=FALSE;

            IF NOT l_Ty_Sch_Dt.EXISTS(l_Due_Indx) THEN
               l_Ty_Sch_Dt(l_Due_Indx) := 1; -- LOg#62.
               --i := i + 1;-- LOg#62.
            END IF;

            --p_account_rec.g_tb_components(l_comp_indx).g_tb_amt_due(l_due_indx).g_amount_due.schedule_no := l_ty_sch_dt(l_due_indx);-- LOg#62.

            -- PERF CHANGES Ends
            ---

            l_Due_Indx := p_Account_Rec.g_Tb_Components(l_Comp_Indx)
                         .g_Tb_Amt_Due.NEXT(l_Due_Indx);
         END LOOP;
         l_Comp_Indx := p_Account_Rec.g_Tb_Components.NEXT(l_Comp_Indx);
      END LOOP;
      --log#111 retro starts
      /***
      --
      --  Log#62 START.
      i := 0;
      l_due_indx := l_ty_sch_dt.FIRST;
      WHILE l_due_indx IS NOT NULL
      LOOP
          i := i + 1;
          l_comp_indx := p_account_rec.g_tb_components.FIRST;
          WHILE l_comp_indx IS NOT NULL
          LOOP
              IF p_ACcount_rec.g_tb_components(l_comp_indx).g_tb_amt_due.EXISTS(l_due_indx)
              THEN
                  p_account_rec.g_tb_components(l_comp_indx).g_tb_amt_due(l_due_indx).g_amount_due.schedule_no := i;
              END IF;
              l_comp_indx := p_account_rec.g_tb_components.NEXT(l_comp_indx);
          END LOOP;
          l_due_indx := l_ty_sch_dt.NEXT(l_due_indx);
      END LOOP;
      --  Log#62 END.
      --
      ***/
      l_Comp_Indx := p_Account_Rec.g_Tb_Components.FIRST;
      WHILE l_Comp_Indx IS NOT NULL LOOP
         i          := 0;
         l_Due_Indx := p_Account_Rec.g_Tb_Components(l_Comp_Indx).g_Tb_Amt_Due.FIRST;
         WHILE l_Due_Indx IS NOT NULL LOOP
            i := i + 1;
            p_Account_Rec.g_Tb_Components(l_Comp_Indx) .g_Tb_Amt_Due(l_Due_Indx) .g_Amount_Due.Schedule_No := i;
            l_Due_Indx := p_Account_Rec.g_Tb_Components(l_Comp_Indx)
                         .g_Tb_Amt_Due.NEXT(l_Due_Indx);
         END LOOP;
         l_Comp_Indx := p_Account_Rec.g_Tb_Components.NEXT(l_Comp_Indx);
      END LOOP;
      --log#111 ends

      /*debug.pr_debug('CL','middle');
      l_idx := l_ty_sch_dt.first;
      while l_idx is not null
      loop
      debug.pr_debug('CL','test'||l_ty_sch_dt(l_idx));
      l_idx := l_ty_sch_dt.NEXT(L_IDX);
      END LOOP;*/
      -- generating Schedule Numbers

      ---
      -- PERF CHANGES Starts
      --        --
      --        -- Log#57 Starts
      --        l_idx := l_ty_sch_dt.first;
      --        while l_idx is not null
      --        loop
      --            dbg('inside loop');
      --            IF l_idx <> l_ty_sch_dt.LAST
      --            THEN
      --                l_idx1 := l_ty_sch_dt.NEXT(l_idx);
      --                while l_idx1 is not null
      --                loop
      --                    dbg(' l_ty_sch_dt(l_idx) ::'||l_ty_sch_dt(l_idx)||' l_ty_sch_dt(l_idx1) ::'||l_ty_sch_dt(l_idx1));
      --                    IF l_ty_sch_dt(l_idx1) < l_ty_sch_dt(l_idx)
      --                    THEN
      --                        l_temp_ty_sch_dt(l_idx) := l_ty_sch_dt(l_idx);
      --                        l_ty_sch_dt(l_idx) := l_ty_sch_dt(l_idx1);
      --                        l_ty_sch_dt(l_idx1) := l_temp_ty_sch_dt(l_idx);
      --                    END IF;
      --                l_idx1 := l_ty_sch_dt.NEXT(l_idx1);
      --                END LOOP;
      --            END IF;
      --        l_idx := l_ty_sch_dt.NEXT(l_idx);
      --        END LOOP;
      --        -- Log#57 Ends.
      --        --
      --
      --
      --i:=1;
      --l_idx := l_ty_sch_dt.first;
      --    while l_idx is not null
      --    loop
      --        l_comp_indx := p_account_rec.g_tb_components.FIRST;
      --        WHILE l_comp_indx IS NOT NULL
      --        LOOP
      --            l_due_indx := p_ACcount_rec.g_tb_components(l_comp_indx).g_tb_amt_due.FIRST;
      --            WHILE l_due_indx IS NOT NULL
      --            LOOP
      ----                 if p_account_rec.g_tb_components(l_comp_indx).g_tb_amt_due(l_due_indx).g_amount_due.component_name IN ('PRINCIPAL','MAIN_INT') and
      --                 if p_account_rec.g_tb_components(l_comp_indx).g_tb_amt_due(l_due_indx).g_amount_due.schedule_due_date=l_ty_sch_dt(l_idx) then
      --                           p_account_rec.g_tb_components(l_comp_indx).g_tb_amt_due(l_due_indx).g_amount_due.schedule_no := i;
      --                 end if;
      --                l_due_indx:=p_ACcount_rec.g_tb_components(l_comp_indx).g_tb_amt_due.NEXT(l_due_indx);
      --            END LOOP;
      --            l_comp_indx := p_account_rec.g_tb_components.NEXT(l_comp_indx);
      --        END LOOP;
      --    l_idx := l_ty_sch_dt.NEXT(L_IDX);
      --  i := i + 1;
      --     END LOOP;

      -- PERF CHANGES Ends
      ---

      RETURN TRUE;
   END Fn_Gen_Sch_No;

   -- End log#42

   FUNCTION Fn_Gen_Create_Schedule(p_Account_Rec    IN OUT NOCOPY Clpkss_Object.Ty_Rec_Account
                                  ,p_Action_Code    IN VARCHAR2
                                  ,p_Effective_Date IN DATE
                                  ,
                                   --euro bank retro changes LOG#103 starts
                                   -- start  month end periodicity  log#102
                                   p_Due_Dates_On_Acc IN Cltbs_Account_Master.Due_Dates_On%TYPE
                                  ,
                                   -- end  month end periodicity log#102
                                   --euro bank retro changes LOG#103 ends
                                   p_Err_Code  IN OUT Ertbs_Msgs.Err_Code%TYPE
                                  ,p_Err_Param IN OUT Ertbs_Msgs.Message%TYPE)

    RETURN BOOLEAN IS
      --note: p_effective_date should be passed as value date
      --for defaulting in except when disbursement is Manual and
      --disbursment happens at p_effective_date.In that case Schedules will be calculated
      --after this date.
      --In case of CAMD this parameter would mean CAMD date.

      -- log#114 Start Performance Tuning
	  l_inst_in_advance           varchar2(1); -- Log#162 Changes for 11.1 Dev (Payment in Advance)
	  l_table_expr cltms_product_comp_frm_expr%ROWTYPE; -- Log#162 Changes for 11.1 Dev (Payment in Advance)
      Process_Next EXCEPTION;
      l_Tmp_Tb_Frm_Names Clpkss_Util.Ty_Tb_Frm_Names;
      l_Tmp_Tb_Comp_Sch  Clpks_Object.Ty_Tb_Account_Comp_Sch;
      -- log#114 end
      l_Tb_Payment_Schedules      Clpkss_Object.Ty_Tb_Account_Comp_Sch;
      l_Tb_Disbursement_Schedules Clpkss_Object.Ty_Tb_Account_Comp_Sch;
      l_Tb_Revision_Schedules     Clpkss_Object.Ty_Tb_Account_Comp_Sch;
      l_Ty_Tb_Account_Comp_Sch    Clpkss_Object.Ty_Tb_Account_Comp_Sch;
      l_Comp_Indx                 Cltbs_Account_Components.Component_Name%TYPE;
      l_Value_Date                Cltbs_Account_Master.Value_Date%TYPE;
      l_Maturity_Date             Cltbs_Account_Master.Maturity_Date%TYPE;
      --Sudharshan : Mar 18,2005
      --l_ignore_holiday            cltbs_account_master.ignore_holidays%TYPE;
      l_Ignore_Holiday    Cltms_Product.Ignore_Holidays%TYPE;
      l_Forward_Backward  Cltms_Product.Schedule_Movement%TYPE;
      l_Move_Across_Month Cltms_Product.Move_Across_Month%TYPE;
      l_Cascade_Movement  Cltms_Product.Cascade_Schedules%TYPE;
      --Sudharshan : Mar 18,2005
      l_Out_Tb_Amt_Due    Clpkss_Object.Ty_Tb_Amt_Due;
      l_Out_Tb_Disbr_Schs Clpkss_Object.Ty_Tb_Disbr_Schedules;
      l_Out_Tb_Revn_Schs  Clpkss_Object.Ty_Tb_Revn_Schedules;
      l_Account_No        Cltbs_Account_Master.Account_Number%TYPE;
      l_Branch_Code       Cltbs_Account_Master.Branch_Code%TYPE;
      l_Product_Code      Cltbs_Account_Master.Product_Code%TYPE;
      l_Bool              BOOLEAN;
      l_Component         Cltbs_Account_Components.Component_Name%TYPE;
      l_Comp_Det          Cltbs_Account_Components%ROWTYPE;
      l_Indx              VARCHAR2(100);
      l_Tb_For_Disbr      g_Ty_Tb_For_Disbr;
      l_Disb_Indx         PLS_INTEGER;
      l_No_Of_Disb_Schs   PLS_INTEGER;
      --Log#154 Starts
      l_No_idx            PLS_INTEGER;
      l_amount            cltbs_account_master.amount_financed%TYPE;
      --Log#154 Ends
      l_Reference_Date    DATE;
      l_Add_Months        NUMBER;
      l_Start_Date        Cltbs_Account_Comp_Sch.Sch_Start_Date%TYPE;
      l_Sch_Start_Date    Cltbs_Account_Comp_Sch.Sch_Start_Date%TYPE;
      l_Month             VARCHAR2(2);
      l_Temp_Date         DATE;
      l_Ref_Day           NUMBER;
      l_Start_Day         PLS_INTEGER;
      l_No_Of_Schedules   Cltbs_Account_Comp_Sch.No_Of_Schedules%TYPE;
      l_Ty_Schedule_Date  Clpks_Schedules.Ty_Schedule_Date;
      l_End_Date          Cltbs_Account_Comp_Sch.Sch_End_Date%TYPE;
      l_Comp_Sch_Row      Cltbs_Account_Comp_Sch%ROWTYPE;
      l_Bullet_Needed     VARCHAR2(3);
      l_Bullet_Start_Date Cltbs_Account_Comp_Sch.Sch_Start_Date%TYPE;
      l_Disbr_Sch_Amt     Cltbs_Account_Master.Amount_Financed%TYPE;
      l_Amount_Financed   Cltbs_Account_Master.Amount_Financed%TYPE;
      l_Currency          Cltbs_Account_Master.Currency%TYPE;
      l_Disbr_Sch_Rnd_Amt Cltbs_Account_Master.Amount_Financed%TYPE;
      l_Due_Indx          PLS_INTEGER;
      --l_event_seq_no              cltbs_account_master.latest_esn%TYPE;
      l_Bullet_Formula     Cltms_Product_Dflt_Schedules.Formula_Name%TYPE;
      l_Tb_Amort_Dues      Clpkss_Object.Ty_Tb_Amt_Due;
      l_Main_Component     Cltms_Product_Components.Component_Name%TYPE;
      l_Tb_Frm_Names       Clpkss_Util.Ty_Tb_Frm_Names;
      l_Last_Formula       Cltms_Product_Dflt_Schedules.Formula_Name%TYPE;
      l_Bullet_Capitalized Cltms_Product_Dflt_Schedules.Capitalized%TYPE;
      l_Process_No         Cltbs_Account_Master.Process_No%TYPE;
      l_First_Split_Date   Cltbs_Account_Schedules.Schedule_Due_Date%TYPE;
      l_Tb_Pmnt_Schs       Clpkss_Object.Ty_Tb_Amt_Due;
      l_Is_Main_Comp       Cltbs_Account_Components.Main_Component%TYPE;
      l_Formula            Cltbs_Account_Schedules.Formula_Name%TYPE;
      --l_last_disbr_date         cltbs_account_comp_sch.sch_end_date%TYPE;
      l_Frst_Dsbr_Date Cltbs_Account_Comp_Sch.Sch_End_Date%TYPE;
      l_Exc_Skip_This_Sch EXCEPTION;
      l_Done_With_The_Sch_Type Cltms_Product_Dflt_Schedules.Schedule_Type%TYPE;
      l_Bull_Reqd_For_Sec_Comp VARCHAR2(3) := 'NO';
      l_Start_Redef_p_From     Cltbs_Account_Comp_Sch.Sch_Start_Date%TYPE;
      l_Start_Redef_d_From     Cltbs_Account_Comp_Sch.Sch_Start_Date%TYPE;
      l_Start_Redef_r_From     Cltbs_Account_Comp_Sch.Sch_Start_Date%TYPE;
      l_Flag                   BOOLEAN; --RaghuR/ANANTH  2-June-2005 FCCCL 1.1 MTR1 SFR#94,101
      l_Rec_Account            Cltbs_Account_Master%ROWTYPE; --  Log#72.

      -- Ramesh Changes Starts 12-Feb-2005 Phase 2 Enhancement Maturity Date Calculation
      l_Frequency_Unit Cltbs_Account_Master.Frequency_Unit%TYPE;
      l_Frequency      Cltbs_Account_Master.Frequency%TYPE;
      l_Prin_Comp      Cltbs_Account_Components.Component_Name%TYPE;
      -- Ramesh Changes Ends 12-Feb-2005 Phase 2 Enhancement Maturity Date Calculation
      l_Sch_Indx     PLS_INTEGER; --log#94
      l_Cr_Indx      PLS_INTEGER;
      l_Tb_Dflt_Schs Ty_Tb_Comp_Dflt_Schs;
      Cr_Sch_Rec     Cltm_Product_Dflt_Schedules%ROWTYPE;
      --Log#130 START
      l_Cr_Indx_Next  PLS_INTEGER;
      Cr_Sch_Rec_Next Cltm_Product_Dflt_Schedules%ROWTYPE;
      --Log#130 END
      l_Tb_Amort_Pairs Clpkss_Cache.Ty_Tb_Amort_Pairs;
      ----->> Sudharshan Mar 18,2005
      l_Rec_Prod Cltm_Product%ROWTYPE;
      ----->> Sudharshan Mar 18,2005
      -- START L Anantharaman 11-Apr-2005 FCCCL1.0 PhaseII reduce tenor changes
      l_Tb_Dummy_Amt_Dues Clpkss_Object.Ty_Tb_Amt_Due; -- is to be filled up only in the case of shift schedules
      -- END L Anantharaman 11-Apr-2005 FCCCL1.0 PhaseII reduce tenor changes

      -- START LOG#51 06-Jun-2005 SFR#124
      l_Emi_Amount_Presevered    NUMBER;
      l_Next_To_Effective_Dt_Idx PLS_INTEGER;
      l_Hsh_Effective_Date       PLS_INTEGER;
      -- END LOG#51 06-Jun-2005 SFR#124
      l_Temp_Date_New DATE; --Log#125

      ---Log#64 Start
      l_Formula_Name      Cltbs_Account_Comp_Sch.Formula_Name%TYPE;
      l_Tb_Cltms_Comp_Frm Clpkss_Cache.Ty_Tb_Cltms_Comp_Frm;
      ---Log#64 End
      -- Bala Murali BDC retros 30-jan-2006 starts Log#85
      l_Prod_Comp_Row Cltms_Product_Components%ROWTYPE; --MPM
      -- Bala Murali BDC retros 30-jan-2006 ends Log#85
      --Start log#72
      l_Start_Ins_Date DATE := p_Account_Rec.Account_Det.First_Ins_Date;
      --End log#72
      --euro bank retro changes
      p_Due_Dates_On_Null NUMBER := NULL;
      --euro bank retro changes
      -- log#119 changes start
      l_Rate_To_Use Cltms_Product_Components.Rate_To_Use%TYPE;
      l_Tmp_Idx     PLS_INTEGER;
      Tmp_Sch_Rec   Cltms_Product_Dflt_Schedules%ROWTYPE;
      l_Not_Bullet  BOOLEAN := FALSE;
      --Log#140 Start changes for Advance and arrears schedules
      l_lastschDate      date;
      --Log#140 end changes for Advance and arrears schedules
      -- log#119 changes end

      -- FCUBS 11.1 : 9NT1368 - ITR1 - SFR#3245 - 25-May-2010 - Praveen Kumar D - Start
      l_Tb_Amt_Due    Clpkss_Object.Ty_Tb_Amt_Due;
      l_Prd			  Cltm_Product%ROWTYPE;

      l_Component_Name	Cltb_Account_Schedules.Component_Name%TYPE;
      l_Component_Name1	Cltb_Account_Schedules.Component_Name%TYPE;
      l_Pay_By_Date		Cltb_Account_Schedules.Pay_By_Date%TYPE;
      l_Due_Idx1		NUMBER;
      l_Sch_St_Date		Cltb_Account_Schedules.Schedule_St_Date%TYPE;
      l_Sch_St_Date1	Cltb_Account_Schedules.Schedule_St_Date%TYPE;
      l_Chg				VARCHAR2(100);
      l_Due_Idx			NUMBER;
      -- FCUBS 11.1 : 9NT1368 - ITR1 - SFR#3245 - 25-May-2010 - Praveen Kumar D - End

          -- Log#142 9NT1316 Linking CASA starts
          l_comp_indxx  CLTBS_ACCOUNT_COMPONENTS.COMPONENT_NAME%TYPE;
          l_sav_comp    CLTBS_ACCOUNT_COMPONENTS.COMPONENT_NAME%TYPE;
          l_comp_indxs  CLTBS_ACCOUNT_COMPONENTS.COMPONENT_NAME%TYPE;
          l_due_indxs   PLS_INTEGER;
          l_temp_tb_schedule_date       clpks_schedules.ty_schedule_date; --Log#Tempfix Abhishek Ranjan for Principal Repyament Holiday 14.09.2009
          -- Log#142 9NT1316 Linking CASA ends
      --MTR1 SFR#210 Cursor query changed to enable Processing for Principal first
      CURSOR Cr_Comps(p_Product Cltms_Product.Product_Code%TYPE) IS
         SELECT a.*, Decode(Component_Name, Pkg_Principal, 1, 2) DEC --Phase II NLS changes
         FROM   Cltms_Product_Components a
         WHERE  Product_Code = p_Product AND Nvl(Comp_Reporting_Type, '$$') <> 'AC'
         ORDER  BY DEC, a.Component_Name;
      CURSOR Cr_Sch(p_Product Cltms_Product.Product_Code%TYPE, p_Component_Name Cltms_Product_Components.Component_Name%TYPE) IS
         SELECT *
         FROM   Cltms_Product_Dflt_Schedules
         WHERE  Product_Code = p_Product AND Component_Name = p_Component_Name
         ORDER  BY Schedule_Type, Seq_No;

      --START Prasanna/Mourougan FCC-CL EURO BANK SFR#AAL013-02. 19-DEC-2005
      l_Tb_Amount_Accrued Clpks_Schedules.Pkg_Tb_Amount_Accrued;
      --END Prasanna/Mourougan FCC-CL EURO BANK SFR#AAL013-02. 19-DEC-2005
      l_last_dsbr_indx         PLS_INTEGER; --Log#146
      PROCEDURE Pr_Delete_Local_Tabs IS
      BEGIN
         l_Tb_Payment_Schedules.DELETE;
         l_Tb_Disbursement_Schedules.DELETE;
         l_Tb_Revision_Schedules.DELETE;
         l_Ty_Tb_Account_Comp_Sch.DELETE;
         l_Tb_For_Disbr.DELETE;
         l_Tb_Amort_Dues.DELETE;
         l_Tb_Pmnt_Schs.DELETE;
         l_Tb_Amort_Pairs.DELETE;
         l_Out_Tb_Amt_Due.DELETE;
         l_Out_Tb_Disbr_Schs.DELETE;
         l_Out_Tb_Revn_Schs.DELETE;
         -- START L Anantharaman 11-Apr-2005 FCCCL1.0 PhaseII reduce tenor changes
         l_Tb_Dummy_Amt_Dues.DELETE;
         -- END L Anantharaman 11-Apr-2005 FCCCL1.0 PhaseII reduce tenor changes
      END;
   BEGIN

      Dbg('welcome to fn_create_schedule');
      Dbg('p_action_code is ' || p_Action_Code);
       Dbg('p_effective_date is ' || p_Effective_Date);

      --START Prasanna/Mourougan FCC-CL EURO BANK SFR#AAL013-02. 19-DEC-2005
      l_Tb_Amount_Accrued.DELETE;

      --log#94 on 16-feb-2006
      Dbg('before storing the accrued amount if fn_create schedules');
      --log#114 start

      l_Comp_Indx := p_Account_Rec.g_Tb_Components.FIRST;
      WHILE l_Comp_Indx IS NOT NULL LOOP
         Dbg('for component ' || l_Comp_Indx);
         l_Sch_Indx := p_Account_Rec.g_Tb_Components(l_Comp_Indx).g_Tb_Amt_Due.FIRST;

         WHILE l_Sch_Indx IS NOT NULL LOOP
            Dbg('the schedule due date is ' ||
                p_Account_Rec.g_Tb_Components(l_Comp_Indx).g_Tb_Amt_Due(l_Sch_Indx)
                .g_Amount_Due.Schedule_Due_Date);
            Dbg('the accrued amount is ' || p_Account_Rec.g_Tb_Components(l_Comp_Indx)
                .g_Tb_Amt_Due(l_Sch_Indx).g_Amount_Due.Accrued_Amount);
            Dbg('the due amount is ' || p_Account_Rec.g_Tb_Components(l_Comp_Indx)
                .g_Tb_Amt_Due(l_Sch_Indx).g_Amount_Due.Amount_Due);
            --LOG#133 Start
            IF ((p_Account_Rec.g_Tb_Components(l_Comp_Indx).g_Tb_Amt_Due(l_Sch_Indx)
               .g_Amount_Due.Schedule_St_Date <= p_Effective_Date AND
                p_Account_Rec.g_Tb_Components(l_Comp_Indx).g_Tb_Amt_Due(l_Sch_Indx)
               .g_Amount_Due.Schedule_Due_Date >= p_Effective_Date) AND
               (p_Account_Rec.g_Tb_Components(l_Comp_Indx).g_Tb_Amt_Due(l_Sch_Indx)
               .g_Amount_Due.Component_Name = Pkg_Main_Int)) THEN
               Clpks_Context.g_Emi_Amount := p_Account_Rec.g_Tb_Components(l_Comp_Indx)
                                            .g_Tb_Amt_Due(l_Sch_Indx)
                                            .g_Amount_Due.Emi_Amount;
               Dbg('clpks_context.g_emi_amount' || Clpks_Context.g_Emi_Amount);
            END IF;
            --LOG#133 End
            l_Sch_Indx := p_Account_Rec.g_Tb_Components(l_Comp_Indx)
                         .g_Tb_Amt_Due.NEXT(l_Sch_Indx);
         END LOOP;
         l_Comp_Indx := p_Account_Rec.g_Tb_Components.NEXT(l_Comp_Indx);
      END LOOP;
      --log#94 on 16-feb-2006
      -- FCUBS 11.1 : 9NT1368 - ITR1 - SFR#3245 - 25-May-2010 - Praveen Kumar D - Start
      Dbg('Pay By Date for other Components starts here');
      l_Prd  := Clpks_Cache.Fn_Product(p_Account_Rec.Account_Det.Product_Code);
      Dbg('OLL Type : ' || l_Prd.Open_Line_Loan);
      IF Nvl(l_Prd.Open_Line_Loan,'N') = 'Y' AND Nvl(l_Prd.Revolving_Type,'N')= 'Y' THEN
		Dbg('Open Line Loan Category..');
		Dbg('My Comp Count : ' || p_Account_Rec.g_Tb_Components.COUNT);
		IF p_Account_Rec.g_Tb_Components.COUNT > 0 THEN
			l_Chg := p_Account_Rec.g_Tb_Components.FIRST;
			Dbg('l Chr : ' || l_Chg);
			WHILE l_Chg IS NOT NULL LOOP
			Dbg('Inside Loop 1');
			Dbg('My Sch Count 11: ' || p_Account_Rec.g_Tb_Components(l_Chg).g_Tb_Amt_Due.COUNT);
			IF p_Account_Rec.g_Tb_Components(l_Chg).g_Tb_Amt_Due.COUNT > 0 THEN
				Dbg('My Sch Count : ' || p_Account_Rec.g_Tb_Components(l_Chg).g_Tb_Amt_Due.COUNT);
				l_Due_Idx := p_Account_Rec.g_Tb_Components(l_Chg).g_Tb_Amt_Due.FIRST;
				Dbg('Due Index : ' || l_Due_Idx);
				WHILE l_Due_Idx IS NOT NULL LOOP
				Dbg('Inside Loop 2');
				Dbg('Component_Name : ' || p_Account_Rec.g_Tb_Components(l_Chg).g_Tb_Amt_Due(l_Due_Idx).g_Amount_Due.Component_Name);
				l_Component_Name := p_Account_Rec.g_Tb_Components(l_Chg).g_Tb_Amt_Due(l_Due_Idx).g_Amount_Due.Component_Name;
				l_Sch_St_Date := p_Account_Rec.g_Tb_Components(l_Chg).g_Tb_Amt_Due(l_Due_Idx).g_Amount_Due.Schedule_St_Date;
				--13374562 Changes Start
				--IF l_Component_Name NOT IN ('PRINCIPAL','MAIN_INT') THEN
				IF l_Component_Name NOT IN ('PRINCIPAL',Pkg_Main_Int) THEN
				--13374562 Changes End
					Dbg('Slow and Steady Wins the Race..');
					l_Pay_By_Date := p_Account_Rec.g_Tb_Components(l_Chg).g_Tb_Amt_Due(l_Due_Idx).g_Amount_Due.Pay_By_Date;
					Dbg('Pay By Date : ' || l_Pay_By_Date);
					IF l_Pay_By_Date IS NULL THEN
						Dbg('Pay By Date is NULL');
						l_Due_Idx1 := p_Account_Rec.g_Tb_Components(Pkg_Main_Int).g_Tb_Amt_Due.FIRST;	--13374562 Changes
						Dbg('Due Index 1 : ' || l_Due_Idx1);
						WHILE l_Due_Idx1 IS NOT NULL LOOP
							Dbg('Find Pay By Date for Main Int');
							l_Component_Name1 := p_Account_Rec.g_Tb_Components(Pkg_Main_Int).g_Tb_Amt_Due(l_Due_Idx1).g_Amount_Due.Component_Name;	--13374562 Changes
							l_Sch_St_Date1 := p_Account_Rec.g_Tb_Components(Pkg_Main_Int).g_Tb_Amt_Due(l_Due_Idx1).g_Amount_Due.Schedule_St_Date;	--13374562 Changes
							Dbg('Component Name : ' || l_Component_Name1);
							Dbg('Sch St Date : ' || l_Sch_St_Date);
							Dbg('Sch St Date 1 : ' || l_Sch_St_Date1);
							IF l_Component_Name1 = Pkg_Main_Int AND l_Sch_St_Date = l_Sch_St_Date1 THEN		--13374562 Changes
								Dbg('Almost thru..');
								l_Pay_By_Date := p_Account_Rec.g_Tb_Components(Pkg_Main_Int).g_Tb_Amt_Due(l_Due_Idx1).g_Amount_Due.Pay_By_Date;	--13374562 Changes
								Dbg('Pay By Date : ' || l_Pay_By_Date);
								EXIT;
							END IF;
							l_Due_Idx1 := p_Account_Rec.g_Tb_Components(Pkg_Main_Int).g_Tb_Amt_Due.NEXT(l_Due_Idx1);	--13374562 Changes
						END LOOP;
						p_Account_Rec.g_Tb_Components(l_Chg).g_Tb_Amt_Due(l_Due_Idx).g_Amount_Due.Pay_By_Date := l_Pay_By_Date;
					END IF;
				END IF;
				l_Due_Idx := p_Account_Rec.g_Tb_Components(l_Chg).g_Tb_Amt_Due.NEXT(l_Due_Idx);
				END LOOP;
			END IF;
			l_Chg := p_Account_Rec.g_Tb_Components.NEXT(l_Chg);
			END LOOP;
		END IF;
      END IF;
      -- FCUBS 11.1 : 9NT1368 - ITR1 - SFR#3245 - 25-May-2010 - Praveen Kumar D - End


      --log#114 end

      l_Bool := Fn_Store_Amount_Accrued(p_Account_Rec
                                       ,p_Effective_Date
                                       ,l_Tb_Amount_Accrued
                                       ,p_Err_Code
                                       ,p_Err_Param);
      IF NOT l_Bool THEN
         l_Tb_Amount_Accrued.DELETE;
         RETURN FALSE;
      END IF;
      --END Prasanna/Mourougan FCC-CL EURO BANK SFR#AAL013-02. 19-DEC-2005

      --MTR1 SFR#136
      g_Tb_Acc_Hol_Perds := p_Account_Rec.g_Hol_Perds;

      Dbg('total no of hoiliday period came in as ' || g_Tb_Acc_Hol_Perds.COUNT);

      l_Value_Date    := p_Account_Rec.Account_Det.Value_Date;
      l_Maturity_Date := Nvl(p_Account_Rec.Account_Det.Maturity_Date
                            ,Clpkss_Util.Pkg_Eternity);

      --Start Log#90 on 11-Feb-2006
      Dbg('Before review if the maturity date falls in holiday, the maturity date is ' ||
          l_Maturity_Date);
      --Start Bis @CLPBDC on 19-Dec-2005
      IF Pkg_Cldaccdt.Pkgfuncid NOT IN ('CLDVDAMD','MODVDAMD','LEDVDAMD')  -- Log#145 --17.12.2009 Ravi
     -- OR Pkg_Cldaccdt.Pkgfuncid <> 'LEDVDAMD'-- Log#143/*ADDED LEDVDAMD*/
       THEN
         --Start Bis @CLPBDC on 19-Dec-2005
         IF l_Maturity_Date <> Clpkss_Util.Pkg_Eternity THEN
            IF NOT Clpks_Schedules.Fn_Get_Maturity_Date(p_Account_Rec.Account_Det.Product_Code
                                                       ,p_Account_Rec.Account_Det.Branch_Code
                                                       ,l_Value_Date
                                                       , --P_VALUE_DATE
                                                        1
                                                       , --P_NO_OF_INSTALLMENTS  THIS IS A TRAP
                                                        1
                                                       , --P_FREQUENCY
                                                        'B'
                                                       , --P_FREQUENCY_UNIT
                                                        l_Maturity_Date
                                                       , --P_FIRST_INS_DATE
                                                        --euro bank retro changes start
                                                        p_Due_Dates_On_Null
                                                       ,
                                                        --euro bank retro changes ends
                                                        l_Maturity_Date
                                                       ,p_Err_Code
                                                       ,p_Err_Param) THEN
               p_Err_Code  := 'CL-SCH036;';
               p_Err_Param := p_Err_Param || 'fn_create_schedules~;';
               Ovpkss.Pr_Appendtbl(p_Err_Code, p_Err_Param);
            ELSE
               IF l_Maturity_Date <>
                  Nvl(p_Account_Rec.Account_Det.Maturity_Date, Clpkss_Util.Pkg_Eternity) THEN
                  Dbg('Maturity Date falls in holiday, Hence move to the working date defined at the product level' ||
                      l_Maturity_Date);
                  p_Account_Rec.Account_Det.Maturity_Date := l_Maturity_Date;
                  p_Err_Code                              := 'CL-SCH049;';
                  Ovpkss.Pr_Appendtbl(p_Err_Code, '');
               END IF;
               Dbg('After review if the maturity date falls in holiday, the maturity date is ' ||
                   l_Maturity_Date);
            END IF;
         END IF;
         --Start Bis @CLPBDC on 19-Dec-2005
      END IF;
      --End Bis @CLPBDC on 19-Dec-2005
      --End Log#90 on 11-Feb-2006
          --Log#140 Start changes for Advance and arrears schedules
               if   NVL(p_account_rec.ACCOUNT_DET.lease_payment_mode,'X') = 'A'
               and  NVL(p_action_code,'X') != 'DFLT'  then
               begin
               l_indx := p_account_rec.g_tb_components(clpks_nls.MAIN_INT).g_tb_comp_sch.first;
               while l_indx is not null
               loop
               if  p_account_rec.g_tb_components(clpks_nls.MAIN_INT).g_tb_comp_sch(l_indx).
               g_account_comp_sch. unit = 'B' then

			   l_maturity_date := NVL(p_account_rec.g_tb_components(clpks_nls.MAIN_INT).g_tb_comp_sch(l_indx)
                                   .g_account_comp_sch. sch_end_date,l_maturity_date);

                exit;
              end if;
              l_indx := p_account_rec.g_tb_components(clpks_nls.MAIN_INT).g_tb_comp_sch.next(l_indx);
              end loop;
              end;
              end if;
          --Log#140 End changes for Advance and arrears schedules
      ----------------------------------------------------->
      --->>Sudharshan :Mar 18,2005
      --l_ignore_holiday    := NVL(p_account_rec.ACCOUNT_DET.ignore_holidays,'Y');
      --l_forward_backward  := p_account_rec.ACCOUNT_DET.schedule_movement;
      --l_move_across_month := p_account_rec.ACCOUNT_DET.move_across_month;
      --l_cascade_movement  := p_account_rec.ACCOUNT_DET.cascade_schedules;

      l_Rec_Prod       := Clpks_Cache.Fn_Product(p_Account_Rec.Account_Det.Product_Code);
      l_Ignore_Holiday := Nvl(l_Rec_Prod.Ignore_Holidays, 'Y');
      Dbg('**IGNORE**');
      Dbg('l_ignore_holiday--1    :' || l_Ignore_Holiday);
      l_Forward_Backward  := l_Rec_Prod.Schedule_Movement;
      l_Move_Across_Month := l_Rec_Prod.Move_Across_Month;
      l_Cascade_Movement  := l_Rec_Prod.Cascade_Schedules;
      --->>Sudharshan :Mar 18,2005
      ----------------------------------------------------->
      l_Account_No      := p_Account_Rec.Account_Det.Account_Number;
      l_Branch_Code     := p_Account_Rec.Account_Det.Branch_Code;
      l_Product_Code    := p_Account_Rec.Account_Det.Product_Code;
      l_Amount_Financed := p_Account_Rec.Account_Det.Amount_Financed;
      l_Currency        := p_Account_Rec.Account_Det.Currency;
      l_Process_No      := p_Account_Rec.Account_Det.Process_No;

      --MTR1 SFR #136
      IF NOT Clpkss_Util.Fn_Get_Amortized_Formulae(l_Tb_Frm_Names, l_Product_Code) THEN
         p_Err_Code := 'CL-SCH037;';
         Ovpkss.Pr_Appendtbl(p_Err_Code, '');

         RETURN FALSE;
      END IF;
      IF NOT Clpkss_Cache.Fn_Get_Amort_Pairs(l_Product_Code, l_Tb_Amort_Pairs) THEN
         RETURN FALSE;
      END IF;
      ------------------------------------------------
      --Based on product default cltb_comp_sch is populated.
      ------------------------------------------------
      BEGIN
         IF (p_Action_Code = 'DFLT') THEN
            l_Comp_Indx := p_Account_Rec.g_Tb_Components.FIRST;
            WHILE l_Comp_Indx IS NOT NULL LOOP
               p_Account_Rec.g_Tb_Components(l_Comp_Indx) .g_Tb_Comp_Sch.DELETE;
               p_Account_Rec.g_Tb_Components(l_Comp_Indx) .g_Tb_Amt_Due.DELETE;

               p_Account_Rec.g_Tb_Components(l_Comp_Indx) .g_Tb_Disbr_Schedules.DELETE;

               p_Account_Rec.g_Tb_Components(l_Comp_Indx) .g_Tb_Revn_Schedules.DELETE;

               l_Comp_Indx := p_Account_Rec.g_Tb_Components.NEXT(l_Comp_Indx);

            END LOOP;

            FOR Cr_Comp_Rec IN Cr_Comps(l_Product_Code) LOOP
               l_No_Of_Disb_Schs        := 0;
               l_Disb_Indx              := 1;
               l_Bullet_Needed          := 'NO';
               l_Reference_Date         := NULL;
               l_Sch_Start_Date         := NULL;
               l_Start_Date             := NULL;
               l_Bullet_Start_Date      := NULL;
               l_End_Date               := NULL;
               l_Done_With_The_Sch_Type := NULL;
               l_Bull_Reqd_For_Sec_Comp := 'NO';

               Dbg('processing for component---->' || Cr_Comp_Rec.Component_Name || '<');
               Dbg(l_Product_Code);

               IF Nvl(Cr_Comp_Rec.Main_Component, 'N') = 'Y' THEN
                  l_Main_Component := Cr_Comp_Rec.Component_Name;
                  Dbg(' Main component is :' || Cr_Comp_Rec.Component_Name || '~flag:' ||
                      Cr_Comp_Rec.Main_Component);
               END IF;

               IF Nvl(Cr_Comp_Rec.Component_Type, '*') NOT IN ('H', 'O') THEN
                  -- log#114 Start Performance Tuning
                  --FOR cr_sch_rec IN cr_sch(l_product_code,
                  --                         cr_comp_rec.component_name)
                  IF NOT Fn_Get_Schs_For_Comp(l_Product_Code
                                             ,Cr_Comp_Rec.Component_Name
                                             ,l_Tb_Dflt_Schs
                                             ,p_Err_Code
                                             ,p_Err_Param) THEN
                     RETURN FALSE;
                  END IF;
                  Dbg('fn_get_schs_for_comp returned as ' || l_Tb_Dflt_Schs.COUNT);
                  --Log#141 Abhishek Ranjan for RML Maturity Calculator will define the DSBR Schedules Starts
                  IF c3pk#_prd_shell.fn_get_contract_info(p_Account_Rec.account_det.account_number, p_Account_Rec.account_det.branch_code
                                              ,'LOAN_TYPE',p_Account_Rec.account_det.product_code
                                             )='R'
                  THEN
                      IF cr_comp_rec.component_name= PKG_PRINCIPAL AND l_tb_dflt_schs.COUNT > 0
                      THEN
                          IF p_account_rec.account_det.no_of_installments IS NOT NULL
                             AND p_account_rec.account_det.frequency IS NOT NULL
                             AND p_account_rec.account_det.frequency_unit IS NOT NULL
                          THEN
                              FOR i IN l_tb_dflt_schs.FIRST .. l_tb_dflt_schs.LAST
                              LOOP
                                  IF l_tb_dflt_schs(i).schedule_type='D'
                                  THEN
                                      l_tb_dflt_schs(i).no_of_schedules := p_account_rec.account_det.no_of_installments;
                                      l_tb_dflt_schs(i).frequency       := p_account_rec.account_det.frequency;
                                      l_tb_dflt_schs(i).frequency_unit  := p_account_rec.account_det.frequency_unit;
                                      EXIT;
                                  END IF;
                              END LOOP;
                          END IF;
                      END IF;
                  END IF;
                  --Log#141 Abhishek Ranjan for RML Maturity Calculator will define the DSBR Schedules Ends
                  l_Cr_Indx := l_Tb_Dflt_Schs.FIRST;
               ELSE
                  l_Cr_Indx := NULL;
               END IF;
               -- log#114 end

               WHILE l_Cr_Indx IS NOT NULL LOOP
                  BEGIN
                     Cr_Sch_Rec := l_Tb_Dflt_Schs(l_Cr_Indx);
                     Dbg('Inside default schedules');

                     -- Ramesh Changes Starts 12-Feb-2005 Phase 2 Enhancement Maturity Date Calculation
                     --IF   cr_sch_rec.schedule_type = 'P'
                     --AND   p_account_rec.account_det.frequency_unit is not null
                     --THEN
                     --    l_frequency_unit         :=  p_account_rec.account_det.frequency_unit;
                     --    l_frequency              :=  p_account_rec.account_det.frequency;
                     --    l_no_of_schedules        :=  p_account_rec.account_det.no_of_installments;
                     --ELSE
                     l_Frequency_Unit  := Cr_Sch_Rec.Frequency_Unit;
                     l_Frequency       := Cr_Sch_Rec.Frequency;
                     l_No_Of_Schedules := Cr_Sch_Rec.No_Of_Schedules;
                     --END IF;
                     -- Ramesh Changes Ends 12-Feb-2005 Phase 2 Enhancement Maturity Date Calculation

                     Dbg('cltm_product_default_sch definition');
                     Dbg('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
                     Dbg('product_code    :' || Cr_Sch_Rec.Product_Code);
                     Dbg('component_name  :' || Cr_Sch_Rec.Component_Name);
                     Dbg('schedule_type   :' || Cr_Sch_Rec.Schedule_Type);
                     Dbg('start_reference :' || Cr_Sch_Rec.Start_Reference);
                     Dbg('frequency       :' || l_Frequency);
                     Dbg('frequency_unit  :' || l_Frequency_Unit);
                     Dbg('start_day       :' || Cr_Sch_Rec.Start_Day);
                     Dbg('start_date      :' || Cr_Sch_Rec.Start_Date);
                     Dbg('start_month     :' || Cr_Sch_Rec.Start_Month);
                     Dbg('no_of_schedules :' || l_No_Of_Schedules);
                     Dbg('formula_name    :' || Cr_Sch_Rec.Formula_Name);
                     Dbg('seq_no          :' || Cr_Sch_Rec.Seq_No);
                     Dbg('schedule_flag   :' || Cr_Sch_Rec.Schedule_Flag);
                     --dbg('capitalized     :' || cr_sch_rec.capitalized);
                     Dbg('<<<<<<<<<<<<<<<<<<<<');
                     l_Not_Bullet := FALSE; --Log#130
                     IF Nvl(l_Done_With_The_Sch_Type, '*') = Cr_Sch_Rec.Schedule_Type THEN
                        Dbg('skipping this schedule defn.');
                        RAISE l_Exc_Skip_This_Sch;
                     END IF;
                     l_Comp_Sch_Row := NULL;

                     --Discounted type of components should have a different
                     --processing

                     IF Cr_Comp_Rec.Formula_Type IN ('3', '4') THEN
                        Dbg('coming for formula type ' || Cr_Comp_Rec.Formula_Type);
                        l_Comp_Sch_Row.Account_Number  := l_Account_No;
                        l_Comp_Sch_Row.Branch_Code     := p_Account_Rec.Account_Det.Branch_Code;
                        l_Comp_Sch_Row.Component_Name  := Cr_Sch_Rec.Component_Name;
                        l_Comp_Sch_Row.Schedule_Type   := Cr_Sch_Rec.Schedule_Type;
                        l_Comp_Sch_Row.Schedule_Flag   := Cr_Sch_Rec.Schedule_Flag;
                        l_Comp_Sch_Row.Formula_Name    := Cr_Sch_Rec.Formula_Name;
                        l_Comp_Sch_Row.Sch_Start_Date  := Nvl(p_Effective_Date
                                                             ,l_Value_Date);
                        l_Comp_Sch_Row.First_Due_Date  := Nvl(p_Effective_Date
                                                             ,l_Value_Date);
                        l_Comp_Sch_Row.No_Of_Schedules := 1;
                        l_Comp_Sch_Row.Frequency       := 1;
                        l_Comp_Sch_Row.Unit            := l_Frequency_Unit;
                        l_Comp_Sch_Row.Sch_End_Date    := Nvl(p_Effective_Date
                                                             ,l_Value_Date);
                        l_Comp_Sch_Row.Amount          := 0;
                        l_Comp_Sch_Row.Payment_Mode    := NULL;
                        l_Comp_Sch_Row.Pmnt_Prod_Ac    := NULL;
                        l_Comp_Sch_Row.Payment_Details := NULL;
                        l_Comp_Sch_Row.Ben_Account     := NULL;
                        l_Comp_Sch_Row.Ben_Bank        := NULL;
                        l_Comp_Sch_Row.Ben_Name        := NULL;
                        l_Comp_Sch_Row.Capitalized     := Nvl(Cr_Sch_Rec.Capitalized, 'N');
                        l_Comp_Sch_Row.Waiver_Flag     := 'N';
                        l_Comp_Sch_Row.Due_Dates_On    := Cr_Sch_Rec.Due_Dates_On;

                        l_Indx := l_Comp_Sch_Row.Schedule_Type ||
                                  Clpkss_Util.Fn_Hash_Date(l_Comp_Sch_Row.First_Due_Date
                                                          ,NULL);
                        l_Ty_Tb_Account_Comp_Sch(l_Indx) .g_Account_Comp_Sch := l_Comp_Sch_Row;
                        l_Ty_Tb_Account_Comp_Sch(l_Indx) .g_Record_Rowid := NULL;
                        l_Ty_Tb_Account_Comp_Sch(l_Indx) .g_Action := 'I'; --new

                        EXIT;

                     END IF;

                     --MTR1 SFR#210..Calculation date will be starting from last disbr date
                     IF (Cr_Sch_Rec.Seq_No = 1) THEN
                        IF Cr_Sch_Rec.Schedule_Type = 'D' THEN
                           l_Reference_Date := Nvl(p_Effective_Date, l_Value_Date);
                        ELSE
                           --l_reference_date :=  l_last_disbr_date;
                           --CL Phase II changes
                           --Payment schedules to start only after first disbursment date.
                           IF l_Rec_Prod.Disbursement_Mode = 'A' THEN
                              l_Reference_Date := l_Frst_Dsbr_Date;
                           ELSE
                              l_Reference_Date := Nvl(p_Effective_Date, l_Value_Date);
                           END IF;
                        END IF;

                        l_Sch_Start_Date := Nvl(p_Effective_Date, l_Value_Date);

                     ELSE
                        l_Reference_Date := l_End_Date; --END date of last schedule becomes starting date of this schedule
                        l_Sch_Start_Date := l_End_Date;
                     END IF;
                     Dbg('l_reference_date IS ' || l_Reference_Date);
					 ---- Log#162 Changes for 11.1 Dev (Payment in Advance) Starts
                     dbg('Formula Name is :- '||Cr_Sch_Rec.Formula_Name);

                     l_inst_in_advance := 'N';
                      IF Cr_Comp_Rec.Formula_Type IN ('10', '11')
					  or ( Cr_Comp_Rec.Formula_Type is null AND cr_sch_rec.component_name = pkg_principal) --Log#165
					  THEN
                         l_inst_in_advance := 'Y';
                      ELSIF Cr_Comp_Rec.Formula_Type = '7' THEN
                         l_table_expr := clpkss_cache.fn_get_comp_formula_expr(p_account_rec.account_det.product_code,
						                                                                cr_sch_rec.component_name,
						                                                                Cr_Sch_Rec.Formula_Name);

	                        IF  (l_table_expr.RESULT LIKE '@AMORT_ADV%' OR l_table_expr.RESULT LIKE '@SIMPLE_ADV%') THEN
		                         l_inst_in_advance := 'Y';
                            ELSE
                             l_inst_in_advance := 'N';
                          END IF;
                      END IF;

                     dbg('l_inst_in_advance :- '||l_inst_in_advance);
                     ---- Log#162 Changes for 11.1 Dev (Payment in Advance) ends
                     --Log#140 Start changes for Advance and arrears schedules
                       IF  (NVL(p_account_rec.account_det.lease_type,'X') = 'F'
                       AND NVL(p_account_rec.account_det.lease_payment_mode,'X')   = 'A'
                       AND cr_sch_rec.component_name = Pkg_Main_Int -- SFR#759 Log#147
					   and nvl(p_account_rec.account_det.MODULE_CODE,'CL') = 'LE' -- Log#162 Changes for 11.1 Dev (Payment in Advance)
                       )
                       OR
                       (NVL(p_account_rec.account_det.lease_type,'X') = 'O'
                       AND NVL(p_account_rec.account_det.lease_payment_mode,'X')   = 'A'
                       AND cr_sch_rec.component_name = Pkg_Main_Int -- SFR#759 Log#147
					   and nvl(p_account_rec.account_det.MODULE_CODE,'CL') = 'LE' -- Log#162 Changes for 11.1 Dev (Payment in Advance)
                       -- AND cr_sch_rec.component_name <> PKG_PRINCIPAL -- Log#147
                       )
					    -- Log#162 Changes for 11.1 Dev (Payment in Advance) starts
						or
                       (NVL(p_account_rec.account_det.lease_type,'X') = 'F'
                       AND NVL(p_account_rec.account_det.lease_payment_mode,'X')   = 'A'
                       --AND cr_sch_rec.component_name in (Pkg_Main_Int
                       and nvl(p_account_rec.account_det.MODULE_CODE,'CL') = 'CL'
					   and nvl(l_inst_in_advance,'#')='Y'
                       )
					   -- Log#162 Changes for 11.1 Dev (Payment in Advance) ends
                       --Log#152 Start sfr1184
                       OR
					(Cr_Comp_Rec.INCLUDE_IN_EMI='Y'
                       AND NVL(p_account_rec.account_det.lease_payment_mode,'X')   = 'A'
                       )
                       -- Log#152 End sfr1184
                       THEN
                               l_start_date := l_reference_date;
                        ELSE
                        --Log#140 End changes for Advance and arrears schedules

                     IF l_Frequency_Unit = 'B' THEN
                        l_Start_Date := l_Maturity_Date;
                     ELSIF Cr_Sch_Rec.Start_Reference = 'V' THEN
                        l_Start_Date := Fn_Get_Next_Schedule_Date(l_Reference_Date
                                                                 ,l_Frequency_Unit
                                                                 ,l_Frequency);
                     ELSE
                        IF l_Frequency_Unit = 'D' THEN
                           --Log#63 30-Aug-2005 RaghuR Start
                           IF (Cr_Sch_Rec.Start_Date IS NULL AND
                              Cr_Sch_Rec.Start_Month IS NULL) THEN
                              l_Start_Date := Fn_Get_Next_Schedule_Date(l_Reference_Date
                                                                       ,l_Frequency_Unit
                                                                       ,l_Frequency);
                           ELSE
                              Dbg('start date and start month are not null');
                              l_Start_Date := To_Date(Nvl(To_Char(Cr_Sch_Rec.Start_Date)
                                                         ,To_Char(l_Reference_Date, 'DD')) || '-' ||
                                                      Nvl(To_Char(Cr_Sch_Rec.Start_Month)
                                                         ,To_Char(l_Reference_Date, 'MM')) || '-' ||
                                                      -- Log#112 Retro - FCCRUSSIA IMPSUPP SFR-310: Date Format related changes starts
                                                      --                                                 to_char(l_reference_date,'YYYY'),
                                                      --                                                 'DD-MM-YYYY');
                                                      To_Char(l_Reference_Date, 'RRRR')
                                                     ,'DD-MM-RRRR');
                              -- Log#112 till here.
                              WHILE l_Start_Date <= l_Reference_Date LOOP
                                 Dbg('l_start_date - l_reference_date ' || l_Start_Date || '- ' ||
                                     l_Reference_Date);
                                 l_Start_Date := l_Start_Date + 1;
                              END LOOP;
                              Dbg('the start date in the daily thing is got as ' ||
                                  l_Start_Date);
                           END IF;
                           --Log#63 30-Aug-2005 RaghuR End
                        ELSIF l_Frequency_Unit = 'W' THEN
                           --START Prasanna/Ravi FCCCL 1.1 MTR1 SFR#58. 24-May-2005
                           --Error Description
                           --When a schedule with payment in weeks is given, the principal component
                           --is always getting scheduled as a bullet payment.

                           --Schedule Start Date was considered as Value Date, when keyed in from the Maturity Date Calculator.
                           --I.e. l_start_date was calculated as 04-APR-2004, when loan value date was 04-APR-2004
                           --This should have been 11-APR-2004.

                           IF (Cr_Sch_Rec.Start_Date IS NULL AND
                              Cr_Sch_Rec.Start_Month IS NULL) THEN

                              l_Ref_Day   := To_Number(To_Char(l_Reference_Date, 'D'));
                              l_Start_Day := Nvl(To_Number(Cr_Sch_Rec.Start_Day)
                                                ,l_Ref_Day);

                              --IF l_start_day = l_ref_day
                              --THEN
                              --  l_start_date := l_reference_date;
                              IF l_Ref_Day < l_Start_Day THEN
                                 l_Start_Date := l_Reference_Date +
                                                 (l_Start_Day - l_Ref_Day);
                              ELSIF l_Ref_Day >= l_Start_Day THEN
                                 l_Start_Date := l_Reference_Date + 7 -
                                                 (l_Ref_Day - l_Start_Day);
                              END IF;
                           ELSE
                              l_Start_Date := To_Date(Nvl(To_Char(Cr_Sch_Rec.Start_Date)
                                                         ,To_Char(l_Reference_Date, 'DD')) || '-' ||
                                                      Nvl(To_Char(Cr_Sch_Rec.Start_Month)
                                                         ,To_Char(l_Reference_Date, 'MM')) || '-' ||
                                                      --Log#112 Retro - FCCRUSSIA IMPSUPP SFR-310: Date Format related changes starts
                                                      --to_char(l_reference_date,'YYYY'),'DD-MM-YYYY');
                                                      To_Char(l_Reference_Date, 'RRRR')
                                                     ,'DD-MM-RRRR');
                              --Log#112 till here
                              WHILE l_Start_Date <= l_Reference_Date LOOP
                                 Dbg('l_start_date - l_reference_date ' || l_Start_Date || '- ' ||
                                     l_Reference_Date);
                                 l_Start_Date := l_Start_Date + 7;
                              END LOOP;
                           END IF;

                           Dbg('$$$$$$$$$$l_start_date ' || l_Start_Date);

                        ELSE
                           IF NOT Fn_Apply_Calender_Prefs(l_Reference_Date
                                                         ,Cr_Sch_Rec.Due_Dates_On
                                                         ,Cr_Sch_Rec.Start_Reference
                                                         ,Cr_Sch_Rec.Frequency_Unit
                                                         ,Cr_Sch_Rec.Start_Date
                                                         ,Cr_Sch_Rec.Start_Month
                                                         ,
                                                          --Start log#72
                                                          l_Start_Ins_Date
                                                         ,
                                                          --End log#72
                                                          l_Start_Date) THEN
                              RETURN FALSE;
                           END IF;

                        END IF;
                     END IF;
                     END IF;  --Log#140 changes for Advance and arrears schedules
                     /*IF l_frequency_unit = 'D'
                     THEN
                         l_add_months := 0;
                     ELSIF l_frequency_unit = 'W'
                     THEN
                         l_add_months := 0;
                     ELSIF l_frequency_unit = 'M'
                     THEN
                         l_add_months := 1;
                     ELSIF l_frequency_unit = 'Q'
                     THEN
                         l_add_months := 3;
                     ELSIF l_frequency_unit = 'H'
                     THEN
                         l_add_months := 6;
                     ELSIF l_frequency_unit = 'Y'
                     THEN
                         l_add_months := 12;
                     ELSE
                         l_add_months := 0;
                     END IF;

                     -- Ramesh Changes Starts 12-Feb-2005 Phase 2 Enhancement Maturity Date Calculation
                     --IF p_account_rec.account_det.first_ins_date is not null
                     --THEN
                     --    l_start_date    :=  p_account_rec.account_det.first_ins_date;
                     --ELSE
                     -- Ramesh Changes Ends 12-Feb-2005 Phase 2 Enhancement Maturity Date Calculation
                         IF l_frequency_unit = 'B'
                         THEN
                           l_start_date := l_maturity_date;
                         ELSIF cr_sch_rec.start_reference = 'V'
                         THEN
                           l_start_date := fn_get_next_schedule_date(l_reference_date,
                                                       l_frequency_unit,
                                                       l_frequency);
                         ELSE
                           IF l_frequency_unit = 'D'
                           THEN
                             l_start_date := fn_get_next_schedule_date(l_reference_date,
                                                         l_frequency_unit,
                                                         l_frequency);
                           ELSE
                             IF nvl(cr_sch_rec.start_date,
                                  0) = 31
                             THEN
                                 IF l_frequency_unit = 'M'
                                 THEN
                                   l_month := to_char(l_reference_date,
                                                'MM');
                                 ELSE
                                   l_month := lpad(cr_sch_rec.start_month,
                                             2,
                                             '0');
                                 END IF;

                                 l_temp_date := to_date('01' || '-' ||
                                                l_month || '-' ||
                                                to_char(l_reference_date,
                                                      'YYYY'),
                                                'DD-MM-YYYY');
                                 l_temp_date := LAST_DAY(l_temp_date);

                                 l_start_date := l_temp_date;

                                 WHILE l_start_date <= l_reference_date
                                 LOOP
                                   --dbg('sd - st '||l_start_date||'- '||l_start_date);
                                   l_start_date := add_months(l_start_date,
                                                      l_Add_months);
                                 END LOOP;

                             ELSIF l_frequency_unit = 'M'
                             THEN
                                 BEGIN
                                   l_temp_date := to_date(to_char(cr_sch_rec.start_date) || '-' ||
                                                  to_char(l_reference_date,
                                                        'MM') || '-' ||
                                                  to_char(l_reference_date,
                                                        'YYYY'),
                                                  'DD-MM-YYYY');
                                 EXCEPTION
                                   WHEN OTHERS THEN
                                     l_temp_date := to_date('01' || '-' ||
                                                      to_char(l_reference_date,
                                                          'MM') || '-' ||
                                                      to_char(l_reference_date,
                                                          'YYYY'),
                                                      'DD-MM-YYYY');
                                     l_temp_date := LAST_DAY(l_temp_date);
                                 END;

                                 IF l_temp_date <= l_reference_date
                                 THEN
                                   l_start_date := fn_add_months(l_temp_date,
                                                       1);
                                 ELSE
                                   l_start_date := l_temp_date;
                                 END IF;
                             ELSIF l_frequency_unit = 'W'
                             THEN
                                 l_ref_day   := to_number(to_char(l_reference_date,
                                                      'D'));
                                 l_start_day := to_number(cr_sch_rec.start_day);
                                 IF l_start_day = l_ref_day
                                 THEN
                                   l_start_date := l_reference_date;
                                 ELSIF l_ref_day < l_start_day
                                 THEN
                                   l_start_date := l_reference_date +
                                             (l_start_day -
                                             l_ref_day);
                                 ELSIF l_ref_day > l_start_day
                                 THEN
                                   l_start_date := l_reference_date + 7 -
                                             (l_ref_day -
                                             l_start_day);
                                 END IF;

                             ELSE
                                 --PHASE II Corfo Changes..
                                 l_temp_date  := to_date(
                                                         NVL(to_char(cr_sch_rec.start_date),to_char(l_reference_date,'DD'))
                                                         || '-' ||
                                                         NVL(to_char(cr_sch_rec.start_month),to_char(l_reference_date,'MM'))
                                                         || '-' ||
                                                         to_char(l_reference_date,'YYYY'),
                                                 'DD-MM-YYYY');
                                 l_start_date := l_temp_date;
                                 WHILE l_start_date <= l_reference_date
                                 LOOP
                                   dbg('l_start_date - l_reference_date ' || l_start_date || '- ' ||
                                     l_reference_date);
                                   l_start_date := add_months(l_start_date,
                                                             l_Add_months);
                                 END LOOP;
                             END IF;
                           END IF;
                         END IF;*/
                     --END IF;
                     --Log#164 Starts
                      if nvl(l_Rec_Prod.OPEN_LINE_LOAN,'N')='Y' and l_Frequency_Unit!='B'
                        and Cr_Sch_Rec.Schedule_Type ='P'  AND cr_sch_rec.component_name IN (Pkg_Main_Int,PKG_PRINCIPAL) then
                        IF  p_Account_Rec.Account_Det.first_pay_by_date IS NULL THEN
                        p_Account_Rec.Account_Det.first_pay_by_date := l_Start_Date +  p_Account_Rec.Account_Det.Creditdays;
                        dbg('inside the IF condition of due date on');
                        ELSE
                        l_Start_Date :=  p_Account_Rec.Account_Det.first_pay_by_date - p_Account_Rec.Account_Det.Creditdays;
                        END IF;

                       IF l_Start_Date <= p_Account_Rec.Account_Det.value_date then
  	                   p_Err_Code := 'CL-ACC-299;';
                       p_Err_Param := p_Err_Param;
                       Ovpkss.Pr_Appendtbl(p_Err_Code, p_Err_Param);
                       dbg('First Schedule Date less than or equal to Contract Value Date. Please Change the First Pay By Date');
                       return false;
                       END if;

                        END IF;
                     -- Log#164 Ends
                     Dbg('schedule start calculated as ' || l_Start_Date);

                     IF (Cr_Sch_Rec.Seq_No = 1) AND Cr_Sch_Rec.Schedule_Type = 'D' THEN

                        Dbg('its disbursment sch...start date should be value date');
                        l_Start_Date := p_Effective_Date;
                     END IF;

                     -- Ramesh Changes Starts 12-Feb-2005 Phase 2 Enhancement Maturity Date Calculation
                     --l_no_of_schedules := cr_sch_rec.no_of_schedules;
                     -- Ramesh Changes Ends 12-Feb-2005 Phase 2 Enhancement Maturity Date Calculation

                     Dbg('the @@@@@@@@@@@ count' || g_Tb_Acc_Hol_Perds.COUNT);

                     --this call is necessary here to determine the schedule end date
                     --euro bank retro changes LOG#103 starts
                     --LOG#102 EUROBANK Billing Periodicity changes start
                     /*l_bool := fn_compute_schedule_dates(l_start_date,
                     l_value_date,
                     l_maturity_date,
                     l_branch_code,
                     l_product_code,
                     l_frequency,
                     l_frequency_unit,
                     l_no_of_schedules,
                     l_ignore_holiday,
                     l_forward_backward,
                     l_move_across_month,
                     l_cascade_movement,
                     cr_sch_rec.due_dates_on,
                     l_ty_schedule_date,
                     p_err_code);*/
                     --LOG#102 EUROBANK Billing Periodicity changes end
                     --euro bank retro changes LOG#103 ends

                     --euro bank retro changes LOG#103
                     --LOG#102 EUROBANK Billing Periodicity changes start

                     Dbg('@@@@@@cr_sch_rec.schedule_type ' || Cr_Sch_Rec.Schedule_Type);
                     -- Log#127 Start
                     IF p_Account_Rec.Account_Det.Due_Dates_On IS NOT NULL AND
                        Cr_Sch_Rec.Schedule_Type NOT IN ('D') AND
                        Cr_Sch_Rec.Schedule_Flag <> 'M'
                     --IF p_account_rec.account_det.due_dates_on is not null and cr_sch_rec.schedule_type not in ('D')  --EUROBANK Billing Periodicity changes log#102
                     -- Log#127 End
                      THEN
                        l_Bool := Fn_Compute_Schedule_Dates(p_Account_Rec.Account_Det.First_Ins_Date
                                                           ,p_Account_Rec.Account_Det.Value_Date
                                                           ,
                                                            -- log#119 changes start
                                                            --clpkss_util.pkg_eternity,
                                                            Nvl(p_Account_Rec.Account_Det.Maturity_Date
                                                               ,Clpkss_Util.Pkg_Eternity)
                                                           ,
                                                            -- log#119 changes end
                                                            p_Account_Rec.Account_Det.Branch_Code
                                                           ,p_Account_Rec.Account_Det.Product_Code
                                                           ,p_Account_Rec.Account_Det.Frequency
                                                           ,p_Account_Rec.Account_Det.Frequency_Unit
                                                           ,p_Account_Rec.Account_Det.No_Of_Installments
                                                           ,l_Ignore_Holiday
                                                           ,l_Forward_Backward
                                                           ,l_Move_Across_Month
                                                           ,l_Cascade_Movement
                                                           ,Cr_Sch_Rec.Due_Dates_On
                                                           ,
                                                            --euro bank retro changes LOG#103 starts
                                                            -- start  month end periodicity LOG#102
                                                            p_Account_Rec.Account_Det.Due_Dates_On
                                                           ,
                                                            -- end  month end periodicity LOG#102
                                                            --euro bank retro changes LOG#103 ends
                                                            l_Ty_Schedule_Date
                                                           ,p_Err_Code
                                                           ,
                                                            --Start Log#116
                                                            Cr_Sch_Rec.Schedule_Type);
                        --END Log#116

                     ELSE
                        l_Temp_Date_New := l_Start_Date; --Log#125
                        l_Bool          := Fn_Compute_Schedule_Dates(l_Start_Date
                                                                    ,l_Value_Date
                                                                    ,l_Maturity_Date
                                                                    ,l_Branch_Code
                                                                    ,l_Product_Code
                                                                    ,l_Frequency
                                                                    ,l_Frequency_Unit
                                                                    ,l_No_Of_Schedules
                                                                    ,l_Ignore_Holiday
                                                                    ,l_Forward_Backward
                                                                    ,l_Move_Across_Month
                                                                    ,l_Cascade_Movement
                                                                    ,Cr_Sch_Rec.Due_Dates_On
                                                                    ,
                                                                     --euro bank retro changes LOG#103 starts
                                                                     -- start  month end periodicity LOG#102
                                                                     NULL
                                                                    ,
                                                                     -- end  month end periodicity LOG#102
                                                                     --euro bank retro changes LOG#103 ends
                                                                     l_Ty_Schedule_Date
                                                                    ,p_Err_Code
                                                                    ,
                                                                     --Start Log#116
                                                                     Cr_Sch_Rec.Schedule_Type);
                        --END Log#116

                     END IF;
                     --LOG#102 EUROBANK Billing Periodicity changes end
                     --Log#146 Abhishek 20.11.2009 Starts
                     IF c3pk#_prd_shell.fn_get_contract_info(p_Account_Rec.account_det.account_number, p_Account_Rec.account_det.branch_code
                                                              ,'LOAN_TYPE',p_Account_Rec.account_det.product_code
                                                             )='R'
                     THEN
                        IF Cr_Sch_Rec.Schedule_Type='D'
                        THEN
                            l_last_dsbr_indx := l_Ty_Schedule_Date.LAST;
                            dbg('Last DSBR Schedule Date is '||l_Ty_Schedule_Date(l_last_dsbr_indx)||'~'||p_Account_Rec.account_det.maturity_date);
                            IF l_Ty_Schedule_Date(l_last_dsbr_indx) = p_Account_Rec.account_det.maturity_date
                            THEN
                                dbg('On Maturity Date Annuity Schedule should not be there so deleting this schedule date');
                                l_Ty_Schedule_Date.DELETE(l_last_dsbr_indx);
                            END IF;
                        END IF;
                     END IF;
                     dbg('Total No of DSBR Schedules is '||l_Ty_Schedule_Date.COUNT);
                     --Log#146 Abhishek 20.11.2009 Ends
                     --euro bank retro changes LOG#103 starts
                     IF l_Bool = FALSE THEN
                        Dbg('fn_compute_Schedule dates returned false');
                        l_Tb_For_Disbr.DELETE;
                        l_Ty_Schedule_Date.DELETE;
                        l_Ty_Tb_Account_Comp_Sch.DELETE;

                        RETURN FALSE;
                     ELSE
                        --case when for a particular formula NO schedule can be given
                        IF l_Ty_Schedule_Date.COUNT = 0 THEN
                           Dbg('not a single schedule is possible here..');
                           l_Done_With_The_Sch_Type := Cr_Sch_Rec.Schedule_Type;
                           l_No_Of_Schedules        := 0;
                           IF Cr_Sch_Rec.Schedule_Type = 'P' THEN
                              l_Bullet_Needed      := 'YES';
                              l_Bullet_Start_Date  := l_Reference_Date;
                              l_Bullet_Formula     := Cr_Sch_Rec.Formula_Name;
                              l_Bullet_Start_Date  := Nvl(l_End_Date, l_Reference_Date);
                              l_Bullet_Capitalized := 'N';
                           ELSE
                              l_Bullet_Needed := 'NO';
                           END IF;

                        END IF;
                        IF l_Ty_Schedule_Date.COUNT > 0 THEN
                           l_Start_Date := l_Ty_Schedule_Date(l_Ty_Schedule_Date.FIRST);
                           --Log#125 START
                           --Log#182 Start
                          -- IF (l_Frequency_Unit <> 'B' AND l_Temp_Date_New <> l_Start_Date)
                          IF (l_frequency_unit <> 'B' and l_temp_date_new <> l_start_date and p_account_rec.account_det.due_dates_on IS NULL)
                           --Log#182 End
                              THEN
                              l_Start_Date := l_Temp_Date_New;
                              Dbg('start date new :' || l_Start_Date);
                           END IF;
                           --Log#125 END
                           Dbg(' the new start date is ' || l_Start_Date); --Log#90
                           l_End_Date := l_Ty_Schedule_Date(l_Ty_Schedule_Date.LAST);
                           -----------------------------------------------------------
                           --readjustment for No.Of Schs happen here.
                           --also when the last non -bullet schedule falls on maturity
                           --it goes as bullet.e.g. 3 monthly schedules for a 3 month contract
                           --will go as 2 monthly and i bullet and not as 3 monthly sch
                           -----------------------------------------------------------

                           --RaghuR/ANANTH  2-June-2005 START FCCCL 1.1 MTR1 SFR#94,101
                           Dbg('l_end_date @@@@@' || l_End_Date || 'l_maturity_date ' ||
                               l_Maturity_Date || 'l_no_of_schedules ' ||
                               l_No_Of_Schedules || 'l_ty_schedule_date.COUNT ' ||
                               l_Ty_Schedule_Date.COUNT);
                           l_Flag := FALSE;
                           /* IF (l_ty_schedule_date.COUNT <> l_no_of_schedules)
                           THEN
                                l_no_of_schedules := l_ty_schedule_date.COUNT;
                                --l_flag := TRUE;
                           END IF; */

                           l_Flag := FALSE;
                           IF (l_End_Date < l_Maturity_Date) AND
							  (l_Ty_Schedule_Date.COUNT <> l_No_Of_Schedules) THEN
                              l_Flag := TRUE;
                           END IF;

                          --FCUBS11.1 ITR1 SFR#1854 Start
						   IF (l_End_Date < l_Maturity_Date) AND (l_Ty_Schedule_Date.COUNT <> l_No_Of_Schedules)
						   AND NVL(l_rec_prod.lease_payment_mode,'X')  = 'A' AND NVL(p_account_rec.account_det.module_code,'#')='CL' THEN
                              l_Flag := FALSE;
                           END IF;
						  --FCUBS11.1 ITR1 SFR#1854 End

                           IF (l_Ty_Schedule_Date.COUNT <> l_No_Of_Schedules) THEN
                              l_No_Of_Schedules := l_Ty_Schedule_Date.COUNT;
                           END IF;
                           --last schedules should always be bullet

                           /***

                           IF cr_sch_rec.schedule_type = 'P' AND l_frequency_unit <> 'B'
                           THEN
                               IF ( (l_end_date = l_maturity_date AND NOT l_flag)
                                   OR
                                   (l_end_date < l_maturity_date AND NOT l_flag)
                                   )
                               THEN
                                   IF l_no_of_schedules > 1
                                   THEN
                                       dbg('boundry case');
                                       l_no_of_schedules := l_no_of_schedules - 1;
                                       l_end_date        := l_ty_schedule_date(l_ty_schedule_date.COUNT - 1);
                                       l_bull_reqd_for_sec_comp := 'YES';
                                   ELSIF l_no_of_schedules = 1
                                   THEN
                                       dbg('1 yearly contract 1 year schedules case');
                                       l_frequency_unit := 'B';
                                   END IF;

                               ELSIF ( (l_end_date = l_maturity_date AND l_flag )
                                       OR
                                       (l_end_date < l_maturity_date AND l_flag)
                                     )
                               THEN
                                   dbg('^^^^^^^^^^^^l_end_date ' || l_end_date);
                                   dbg('^^^^^^^^^^^^l_maturity_date ' || l_maturity_date);
                                   dbg('^^^^^^^^^^^^l_no_of_schedules ' || l_no_of_schedules);

                                   IF l_no_of_schedules > 1
                                   THEN
                                       l_end_date := l_ty_schedule_date(l_ty_schedule_date.COUNT);
                                       l_bull_reqd_for_sec_comp := 'YES';
                                       dbg('the l_end_date is assigned to '||l_end_date);
                                   ELSIF l_no_of_schedules = 1
                                   THEN
                                       dbg('1 yearly contract 1 year schedules case');
                                       l_frequency_unit := 'B';
                                   END IF;
                               END IF;
                           END IF;

                           ***/
                           --Log#130 START.
                           l_Cr_Indx_Next  := NULL;
                           Cr_Sch_Rec_Next := NULL;
                           l_Cr_Indx_Next  := l_Tb_Dflt_Schs.NEXT(l_Cr_Indx);

                           IF l_Cr_Indx_Next IS NOT NULL THEN
                              Cr_Sch_Rec_Next := l_Tb_Dflt_Schs(l_Cr_Indx_Next);

                              IF Cr_Sch_Rec_Next.Component_Name =
                                 Cr_Sch_Rec.Component_Name AND
                                 Cr_Sch_Rec_Next.Schedule_Type = Cr_Sch_Rec.Schedule_Type AND
                                 Nvl(Cr_Sch_Rec_Next.Schedule_Flag, 'N') =
                                 Nvl(Cr_Sch_Rec.Schedule_Flag, 'N') AND
                                 Nvl(Cr_Sch_Rec_Next.Schedule_Flag, 'N') <> 'M' THEN
                                 l_Flag := TRUE;
                              END IF;
                           END IF;
                           --Log#130 END.
                           IF Cr_Sch_Rec.Schedule_Type = 'P' AND l_Frequency_Unit <> 'B' AND
                              Nvl(Cr_Sch_Rec.Schedule_Flag, 'N') <> 'M' --  Log#68.
                            THEN
                               l_lastschDate := l_ty_schedule_date(l_ty_schedule_date.count); --Log#140 changes for Advance and arrears schedules
                              IF NOT l_Flag THEN
                                 -- log#119 changes start
                                 l_Tmp_Idx := l_Tb_Dflt_Schs.NEXT(l_Cr_Indx);
                                 IF l_Tmp_Idx IS NOT NULL THEN
                                    Tmp_Sch_Rec := l_Tb_Dflt_Schs(l_Tmp_Idx);
                                    IF Tmp_Sch_Rec.Schedule_Type = 'P' AND
                                       Tmp_Sch_Rec.Frequency_Unit <> 'B' THEN
                                       l_Not_Bullet := TRUE;
                                    END IF;
                                 END IF;
                                 -- log#119 changes end
                                 IF l_No_Of_Schedules > 1 AND NOT l_Not_Bullet -- log#119 changes added l_not_nullet
                                  THEN
                                    Dbg('boundry case');

                                    l_No_Of_Schedules        := l_No_Of_Schedules - 1;
                                    l_End_Date               := l_Ty_Schedule_Date(l_Ty_Schedule_Date.COUNT - 1);
                                    l_Bull_Reqd_For_Sec_Comp := 'YES';
                                 ELSIF l_No_Of_Schedules = 1 THEN
                                    -- log#119 changes start
                                    IF NOT l_Not_Bullet THEN
                                       -- log#119 changes end
                                       Dbg('1 yearly contract 1 year schedules case');
                                       l_Frequency_Unit := 'B';
                                       l_Frequency      := 1; --Log#90 on 11-feb-2006
                                       --RaghuR 9-June-2005 Start Log 53
                                       --RaghuR 19-Sep-2005 Start
                                       --IF l_comp_sch_row.component_name IN (PKG_PRINCIPAL,PKG_MAIN_INT)--Log#58 RaghuR 30-Aug-2005 Start
                                       --log#114 start
                                       --While exploding schedule it populated the bullet schedule only for MAIN_INT and PRINCIPAL components.
                                       l_Prod_Comp_Row := Clpkss_Cache.Fn_Product_Components(p_Account_Rec.Account_Det.Product_Code
                                                                                            ,Cr_Sch_Rec.Component_Name);
                                       --While exploding schedule it populated the bullet schedule only for MAIN_INT and PRINCIPAL components.
                                       --log#114 end
                                       IF Cr_Sch_Rec.Component_Name IN
                                          (Pkg_Principal, Pkg_Main_Int) --Log#58 RaghuR 30-Aug-2005 Start
                                         --RaghuR 19-Sep-2005 End
                                         --log#114 Start
                                          OR Nvl(l_Prod_Comp_Row.Component_Type, 'L') IN
                                          ('I', 'L')
                                       --log#114 End
                                        THEN
                                          l_Start_Date := l_Maturity_Date;
                                          l_End_Date   := l_Maturity_Date;
                                       END IF; --Log#58 RaghuR 30-Aug-2005 End
                                       Dbg('l_start_date now is ' || l_Start_Date ||
                                           'l_end_date ' || l_End_Date);
                                       --RaghuR 9-June-2005 Start Log 53
                                    END IF; -- log#119 changes
                                 END IF;

                              ELSE
                                 Dbg('^^^^^^^^^^^^l_end_date ' || l_End_Date);
                                 Dbg('^^^^^^^^^^^^l_maturity_date ' || l_Maturity_Date);
                                 Dbg('^^^^^^^^^^^^l_no_of_schedules ' ||
                                     l_No_Of_Schedules);

                                 IF l_No_Of_Schedules > 1 OR
                                    (l_No_Of_Schedules = 1 AND
                                    l_End_Date < l_Maturity_Date) -- log#119 changes
                                  THEN
                                    l_End_Date               := l_Ty_Schedule_Date(l_Ty_Schedule_Date.COUNT);
                                    l_Bull_Reqd_For_Sec_Comp := 'YES';
                                    Dbg('the l_end_date is assigned to ' || l_End_Date);
                                 ELSIF l_No_Of_Schedules = 1 THEN
                                    Dbg('1 yearly contract 1 year schedules case');
                                    l_Frequency_Unit := 'B';
                                    --Log#58 RaghuR 30-Aug-2005 Start
                                    --RaghuR 19-Sep-2005 Start
                                    --IF l_comp_sch_row.component_name IN (PKG_PRINCIPAL,PKG_MAIN_INT)
                                    --log#114 Start
                                    --While exploding schedule it populated the bullet schedule only for MAIN_INT and PRINCIPAL components.
                                    l_Prod_Comp_Row := Clpkss_Cache.Fn_Product_Components(p_Account_Rec.Account_Det.Product_Code
                                                                                         ,Cr_Sch_Rec.Component_Name);
                                    --While exploding schedule it populated the bullet schedule only for MAIN_INT and PRINCIPAL components.
                                    --log#114 End
                                    IF Cr_Sch_Rec.Component_Name IN
                                       (Pkg_Principal, Pkg_Main_Int)
                                      --RaghuR 19-Sep-2005 End
                                      --Log#114 Start
                                       OR Nvl(l_Prod_Comp_Row.Component_Type, 'L') IN
                                       ('I', 'L')
                                    --Log#114 End
                                     THEN
                                       l_Start_Date := l_Maturity_Date;
                                       l_End_Date   := l_Maturity_Date;
                                    END IF;
                                    --Log#58 RaghuR 30-Aug-2005 End
                                 END IF;
                              END IF;
                           END IF;

                           /***IF (l_ty_schedule_date.COUNT <>
                                                                  l_no_of_schedules)
                                                               THEN
                                                                   l_no_of_schedules := l_ty_schedule_date.COUNT;
                                                               END IF;
                                                               --last schedules should always be bullet
                                                               IF l_end_date = l_maturity_date AND
                                                                  cr_sch_rec.schedule_type = 'P' AND
                                                                  l_frequency_unit <> 'B'
                                                               THEN
                                                                  IF l_no_of_schedules > 1
                                                                  THEN
                                                                       dbg('boundry case');
                                                                       l_no_of_schedules := l_no_of_schedules - 1;
                                                                       l_end_date        := l_ty_schedule_date(l_ty_schedule_date.COUNT - 1);
                                                                       l_bull_reqd_for_sec_comp := 'YES';
                                                                  ELSIF l_no_of_schedules = 1
                                                                  THEN
                                                                      dbg('1 yearly contract 1 year schedules case');
                                                                      l_frequency_unit := 'B';
                                                                  END IF;
                           END IF;****/
                           --RaghuR/ANANTH  2-June-2005 END FCCCL 1.1 MTR1 SFR#94,101

                        END IF;
                     END IF;
                     --l_ty_schedule_date.DELETE;
                     Dbg('*****************************************');
                     IF l_No_Of_Schedules > 0 THEN
                        Dbg('inserted a row here');
                        l_Comp_Sch_Row.Account_Number  := l_Account_No;
                        l_Comp_Sch_Row.Branch_Code     := p_Account_Rec.Account_Det.Branch_Code;
                        l_Comp_Sch_Row.Component_Name  := Cr_Sch_Rec.Component_Name;
                        l_Comp_Sch_Row.Schedule_Type   := Cr_Sch_Rec.Schedule_Type;
                        l_Comp_Sch_Row.Schedule_Flag   := Cr_Sch_Rec.Schedule_Flag;
                        l_Comp_Sch_Row.Formula_Name    := Cr_Sch_Rec.Formula_Name;
                        l_Comp_Sch_Row.Sch_Start_Date  := l_Sch_Start_Date; --new guy
                        l_Comp_Sch_Row.First_Due_Date  := l_Start_Date;
                        l_Comp_Sch_Row.No_Of_Schedules := l_No_Of_Schedules;
                        l_Comp_Sch_Row.Frequency       := l_Frequency;
                        l_Comp_Sch_Row.Unit            := l_Frequency_Unit;
                        l_Comp_Sch_Row.Sch_End_Date    := l_End_Date;
                        l_Comp_Sch_Row.Amount          := 0;
                        l_Comp_Sch_Row.Payment_Mode    := NULL;
                        l_Comp_Sch_Row.Pmnt_Prod_Ac    := NULL;
                        l_Comp_Sch_Row.Payment_Details := NULL;
                        l_Comp_Sch_Row.Ben_Account     := NULL;
                        l_Comp_Sch_Row.Ben_Bank        := NULL;
                        l_Comp_Sch_Row.Ben_Name        := NULL;
                        l_Comp_Sch_Row.Capitalized     := Nvl(Cr_Sch_Rec.Capitalized, 'N');
                        l_Comp_Sch_Row.Waiver_Flag     := 'N';
                        --Log#67
                        IF Nvl(p_Account_Rec.Account_Det.Emi_Amount, 0) <> 0 AND
                           l_Comp_Sch_Row.Component_Name = Pkg_Main_Int AND
                           l_Comp_Sch_Row.Sch_End_Date <> l_Maturity_Date THEN
                           IF NOT
                               Clpkss_Util.Fn_Round_Emi(p_Account_Rec.Account_Det.Emi_Amount
                                                       ,p_Account_Rec.Account_Det.Product_Code
                                                       ,p_Account_Rec.Account_Det.Currency) THEN
                              Dbg('Failed in rounding emi for account for :' ||
                                  p_Account_Rec.Account_Det.Product_Code || '~' ||
                                  p_Account_Rec.Account_Det.Emi_Amount);
                              RETURN FALSE;
                           END IF;
                           l_Comp_Sch_Row.Emi_Amount := p_Account_Rec.Account_Det.Emi_Amount;
                        END IF;
                        --Log#67
                        --Log#58 RaghuR 11-Jul-2005 Start
                        IF l_Frequency_Unit = 'B' THEN
                           l_Comp_Sch_Row.Due_Dates_On := NULL;
                        ELSE
                           l_Comp_Sch_Row.Due_Dates_On := Cr_Sch_Rec.Due_Dates_On;
                        END IF;
                        --Log#58 RaghuR 11-Jul-2005 Start
                        --euro bank retro changes LOG#103 ends
                        --start EUROBANK Billing Periodicity changes log#102
                        IF l_Comp_Sch_Row.Schedule_Type = 'R' THEN
                           Dbg('inside my if condition');
                           l_Comp_Sch_Row.Frequency := Nvl(l_Frequency
                                                          ,p_Account_Rec.Account_Det.Frequency);
                           l_Comp_Sch_Row.Unit      := Nvl(l_Frequency_Unit
                                                          ,p_Account_Rec.Account_Det.Frequency_Unit);
                           IF l_Frequency_Unit = 'B' THEN
                              l_Comp_Sch_Row.Due_Dates_On := NULL;
                           ELSE
                              l_Comp_Sch_Row.Due_Dates_On := Nvl(Cr_Sch_Rec.Due_Dates_On
                                                                ,p_Account_Rec.Account_Det.Due_Dates_On);
                           END IF;
                        END IF;
                        --end EUROBANK Billing Periodicity changes log#102
                        --euro bank retro changes LOG#103 ends
                        l_Indx := l_Comp_Sch_Row.Schedule_Type ||
                                  Clpkss_Util.Fn_Hash_Date(l_Comp_Sch_Row.First_Due_Date
                                                          ,NULL);
                        l_Ty_Tb_Account_Comp_Sch(l_Indx) .g_Account_Comp_Sch := l_Comp_Sch_Row;
                        l_Ty_Tb_Account_Comp_Sch(l_Indx) .g_Record_Rowid := NULL;
                        l_Ty_Tb_Account_Comp_Sch(l_Indx) .g_Action := 'I'; --new

                        IF (l_Comp_Sch_Row.Schedule_Type = 'D') AND
                           l_Comp_Sch_Row.Component_Name = Pkg_Principal
                        --Phase II NLS changes
                         THEN
                           l_No_Of_Disb_Schs := l_No_Of_Disb_Schs + l_No_Of_Schedules;
                           l_Tb_For_Disbr(l_Disb_Indx) := l_Indx;
                           l_Disb_Indx := l_Disb_Indx + 1;
                           --l_last_disbr_date   :=  l_comp_sch_row.sch_end_date;
                           --CL PHASE II changes
                           IF Cr_Sch_Rec.Seq_No = 1 THEN
                              l_Frst_Dsbr_Date := l_Comp_Sch_Row.First_Due_Date;
                           END IF;

                        END IF;
                        ----------------------------------------------------------------------
                        --All 'P' type schedules needs to have Bullet schedules.
                        --If bullet schedule is defines as part of default product definintion
                        --then it will happen in this loop itself.
                        --if not then it will happen outside loop.
                        --Also if at all it is defined at the Product level it will be the last
                        --defined schedule.

                        -------------------------------------------------------------------------
                        IF Cr_Sch_Rec.Schedule_Type = 'P' THEN
                           --NO forcing of bullet schedules for non Principal and non Main Int comp.
                           --Bullet will be put for these comps only when schedules were split for these e.g.
                           --4 month contract and 4 monthly schedule for even these comps should be 3 monthly and 1 bullet
                           IF (Cr_Comp_Rec.Component_Name = Pkg_Principal OR
                              Nvl(Cr_Comp_Rec.Main_Component, '*') = 'Y')
                             --Phase II NLS changes
                              OR Nvl(l_Bull_Reqd_For_Sec_Comp, 'NO') = 'YES' THEN
                              l_Bullet_Needed     := 'YES';
                              l_Bullet_Start_Date := l_End_Date;
                              l_Bullet_Formula    := Cr_Sch_Rec.Formula_Name;
                              --l_bullet_capitalized:= nvl(cr_sch_rec.capitalized,'N');
                              --Bullet schedules will never be capitalized.
                              l_Bullet_Capitalized := 'N';
                              Dbg('l_bullet_formula is going to be' || l_Bullet_Formula);
                              IF (l_Frequency_Unit = 'B') THEN
                                 l_Bullet_Needed := 'NO';
                              END IF;

                           END IF;
                        END IF;
                     END IF;
                     l_Ty_Schedule_Date.DELETE;
                     Dbg('l_bullet_needed IS ' || l_Bullet_Needed);
                  EXCEPTION
                     WHEN l_Exc_Skip_This_Sch THEN
                        Dbg('in l_exc_skip_this_sch for   schedule defn ' ||
                            Cr_Sch_Rec.Schedule_Type || ' having frquency unit' ||
                            l_Frequency_Unit);
                  END;
                  l_Cr_Indx := l_Tb_Dflt_Schs.NEXT(l_Cr_Indx);
               END LOOP;
               --------------------------------------------------------------------
               --Disbursments amount apportioning logic:
               --disbr sch amount = total amount/total no of disbursment schedules.
               --total no of Disb. schedules is considered irrespective of there frequency units
               ---------------------------------------------------------------------
               IF (l_No_Of_Disb_Schs >= 1 AND Cr_Comp_Rec.Component_Name = Pkg_Principal)
               --Phase II NLS changes
                THEN
                  Dbg('total disbursments schedules are ' || l_No_Of_Disb_Schs);
                  l_Disbr_Sch_Amt := l_Amount_Financed / l_No_Of_Disb_Schs;
                  Dbg('$$$$$$$$$$$$$$$After l_disbr_sch_amt ' || l_Disbr_Sch_Amt);
                  Dbg('$$$$$$$$$$$$$$$l_currency ' || l_Currency);

                  --START Prasanna EUROBANK TESTING. 07-APR-2006.
                  IF Cypkss.Ccytab.EXISTS(l_Currency) THEN
                     Dbg('$$$$$$$$Hurray. It exists');
                  ELSE
                     Dbg('$$$$$$$$Sorry. It does not exists');
                     --DO CACHING
                     Cypkss.Pr_Cache_Ccy(l_Currency, l_Currency);
                  END IF;
                  --END Prasanna EUROBANK TESTING. 07-APR-2006.

                  IF NOT
                      Cypkss.Fn_Amt_Round(l_Currency, l_Disbr_Sch_Amt, l_Disbr_Sch_Rnd_Amt) THEN
                     l_Tb_For_Disbr.DELETE;
                     l_Ty_Schedule_Date.DELETE;
                     l_Ty_Tb_Account_Comp_Sch.DELETE;
                     RETURN(FALSE);
                  END IF;
                  FOR i IN l_Tb_For_Disbr.FIRST .. l_Tb_For_Disbr.LAST LOOP
                     --log#114 Start
                     /*
                     IF (l_ty_tb_account_comp_sch.EXISTS(l_tb_for_disbr(i)))
                     THEN
                         l_ty_tb_account_comp_sch(l_tb_for_disbr(i)) .g_account_comp_sch.amount := l_disbr_sch_rnd_amt;
                     END IF;
                     */
                     BEGIN
                        l_Ty_Tb_Account_Comp_Sch(l_Tb_For_Disbr(i)) .g_Account_Comp_Sch.Amount := l_Disbr_Sch_Rnd_Amt;
                     EXCEPTION
                        WHEN No_Data_Found THEN
                           NULL;
                     END;
                     --log#114 End
                  END LOOP;
               END IF;

               --if bullet is not defined as a schedule then define a bullet schedule
               IF l_Bullet_Needed = 'YES' THEN
                 --Log#140 Start changes for Advance and arrears schedules
				 --Log#162 Changes for 11.1 Dev (Payment in Advance) Starts
					l_inst_in_advance := 'N';
                      IF Cr_Comp_Rec.Formula_Type IN ('10', '11')
					  or ( Cr_Comp_Rec.Formula_Type is null AND cr_sch_rec.component_name = pkg_principal) --Log#165
					  THEN
                         l_inst_in_advance := 'Y';
                      ELSIF Cr_Comp_Rec.Formula_Type = '7' THEN
                         l_table_expr := clpkss_cache.fn_get_comp_formula_expr(p_account_rec.account_det.product_code,
						                                                                cr_sch_rec.component_name,
						                                                                Cr_Sch_Rec.Formula_Name);

	                        IF  (l_table_expr.RESULT LIKE '@AMORT_ADV%' OR l_table_expr.RESULT LIKE '@SIMPLE_ADV%') THEN
		                         l_inst_in_advance := 'Y';
                            ELSE
                             l_inst_in_advance := 'N';
                          END IF;
                      END IF;
				 --FCUBS11.1 ITR1 SFR#3037 Changes Start
				 --Log#162 Changes for 11.1 Dev (Payment in Advance) ends
                   /*if  NVL(l_rec_prod.lease_payment_mode,'X')  = 'A'
				   --Log#162  Changes for 11.1 Dev (Payment in Advance) Starts
				   and nvl(p_account_rec.account_det.module_code,'#')='LE'
                    or
                   (nvl(p_account_rec.account_det.module_code,'#')='CL'
                   and nvl(l_inst_in_advance,'#')='Y')
				   --log#162  Changes for 11.1 Dev (Payment in Advance) ends
				   then
                    --FCUBS11.1 ITR1 SFR#1854 Start
					--l_maturity_date := NVL(l_lastschDate,l_maturity_date);
					l_maturity_date := NVL(l_lastschDate+1,l_maturity_date);
					--FCUBS11.1 ITR1 SFR#1854 End
					Dbg('l_maturity_date lease_payment_mode'||l_maturity_date);
                   end if;*/
                  --Log#140 End changes for Advance and arrears schedules

                  IF  NVL(l_rec_prod.lease_payment_mode,'X')  = 'A'
					  AND
					  nvl(p_account_rec.account_det.module_code,'#')='LE'
				  THEN
					l_maturity_date := NVL(l_lastschDate,l_maturity_date);
				  END IF;

				  IF nvl(p_account_rec.account_det.module_code,'#')='CL'
				     AND
				     nvl(l_inst_in_advance,'#')='Y' AND  NVL(l_rec_prod.lease_payment_mode,'X')  = 'A' --FCUBS11.1 ITR1 SFR#3111
				  THEN
					l_maturity_date := NVL(l_lastschDate+1,l_maturity_date);
				  END IF;

				  Dbg('Maturity Date is: '||l_maturity_date);
                  --FCUBS11.1 ITR1 SFR#3037 Changes End



                  Dbg('inserting one bullet schedule');
                  l_Comp_Sch_Row.Account_Number  := l_Account_No;
                  l_Comp_Sch_Row.Branch_Code     := l_Branch_Code;
                  l_Comp_Sch_Row.Component_Name  := Cr_Comp_Rec.Component_Name;
                  l_Comp_Sch_Row.Schedule_Type   := 'P';
                  l_Comp_Sch_Row.Schedule_Flag   := 'N';
                  l_Comp_Sch_Row.Formula_Name    := l_Bullet_Formula;
                  l_Comp_Sch_Row.Sch_Start_Date  := l_Bullet_Start_Date;
                  --FCUBS11.1 ITR1 SFR#1854 Start
                  IF (NVL(p_account_rec.account_det.lease_type,'X') = 'F'
                  AND NVL(p_account_rec.account_det.lease_payment_mode,'X')   = 'A'
                  AND nvl(p_account_rec.account_det.MODULE_CODE,'CL') = 'CL'
                  AND nvl(l_inst_in_advance,'#')='Y') THEN
                     l_Comp_Sch_Row.First_Due_Date  := l_lastschDate;
                  ELSE
                   l_Comp_Sch_Row.First_Due_Date  := l_Maturity_Date;
                  END IF;
                  --FCUBS11.1 ITR1 SFR#1854 End
                  l_Comp_Sch_Row.No_Of_Schedules := 1;
                  l_Comp_Sch_Row.Frequency       := 1;
                  l_Comp_Sch_Row.Unit            := 'B';
                  --FCUBS11.1 ITR1 SFR#1854 Start
				  IF (NVL(p_account_rec.account_det.lease_type,'X') = 'F'
                  AND NVL(p_account_rec.account_det.lease_payment_mode,'X')   = 'A'
                  AND nvl(p_account_rec.account_det.MODULE_CODE,'CL') = 'CL'
                  AND nvl(l_inst_in_advance,'#')='Y') THEN
                  l_Comp_Sch_Row.Sch_End_Date    := l_lastschDate;
                  ELSE
                  l_Comp_Sch_Row.Sch_End_Date    := l_Maturity_Date;
                  END IF;
				  --FCUBS11.1 ITR1 SFR#1854 End
                  l_Comp_Sch_Row.Amount          := 0;
                  l_Comp_Sch_Row.Payment_Mode    := NULL;
                  l_Comp_Sch_Row.Pmnt_Prod_Ac    := NULL;
                  l_Comp_Sch_Row.Payment_Details := NULL;
                  l_Comp_Sch_Row.Ben_Account     := NULL;
                  l_Comp_Sch_Row.Ben_Bank        := NULL;
                  l_Comp_Sch_Row.Ben_Name        := NULL;
                  l_Comp_Sch_Row.Capitalized     := l_Bullet_Capitalized;
                  l_Comp_Sch_Row.Waiver_Flag     := 'N';
                  --l_comp_sch_row.due_dates_on    := cr_sch_rec.due_dates_on;  --Sishir 27-Apr-2005
                  --Log#58 RaghuR 11-Jul-2005 Start
                  l_Comp_Sch_Row.Due_Dates_On := NULL;
                  --Log#58 RaghuR 11-Jul-2005 End
                  l_Indx := 'P' || Clpkss_Util.Fn_Hash_Date(l_Maturity_Date, NULL);
                  l_Ty_Tb_Account_Comp_Sch(l_Indx) .g_Account_Comp_Sch := l_Comp_Sch_Row;
                  l_Ty_Tb_Account_Comp_Sch(l_Indx) .g_Record_Rowid := NULL;
                  l_Ty_Tb_Account_Comp_Sch(l_Indx) .g_Action := 'I'; --new
               END IF;
               l_Tb_For_Disbr.DELETE;
               p_Account_Rec.g_Tb_Components(Cr_Comp_Rec.Component_Name) .g_Tb_Comp_Sch := l_Ty_Tb_Account_Comp_Sch;
               l_Ty_Tb_Account_Comp_Sch.DELETE;
            END LOOP; --cr_comp_rec

            --when last fomula is amortized then Principal bullet should be removed

            IF l_Main_Component IS NOT NULL THEN
               Dbg('main component is ' || l_Main_Component);
               l_Indx := 'P' || Clpkss_Util.Fn_Hash_Date(l_Maturity_Date, NULL);
               --log#114 Start
               /*
               IF p_account_rec.g_tb_components(l_main_component).g_tb_comp_sch.EXISTS(l_indx) THEN
                   l_last_formula  := p_account_rec.g_tb_components(l_main_component).
                                      g_tb_comp_sch(l_indx).g_account_comp_sch.formula_name;
                   dbg('last formula is  '||l_last_formula);
                   IF l_tb_frm_names.EXISTS(l_last_formula) THEN
                      --last formula is bullet ..delete principal bullet
                      dbg('removing bullet schedule for principal since amort bullet exists');
                      p_account_rec.g_tb_components(PKG_PRINCIPAL).g_tb_comp_sch.DELETE(l_indx);
                     --Phase II NLS changes
                   END IF;
               END IF;*/
               BEGIN

                  l_Last_Formula := p_Account_Rec.g_Tb_Components(l_Main_Component) .
                                    g_Tb_Comp_Sch(l_Indx).g_Account_Comp_Sch.Formula_Name;
                  BEGIN
                     l_Tmp_Tb_Frm_Names(1) := l_Tb_Frm_Names(l_Last_Formula);
                     p_Account_Rec.g_Tb_Components(Pkg_Principal) .g_Tb_Comp_Sch.DELETE(l_Indx);
                  EXCEPTION
                     WHEN No_Data_Found THEN
                        NULL;
                  END;

               EXCEPTION
                  WHEN No_Data_Found THEN
                     NULL;
               END;

               --log#114 End

               l_Tb_Frm_Names.DELETE;
            END IF;
            --IF NOT fn_fill_schedule_gaps(p_account_rec,p_err_code,p_err_param)
            Dbg('$$$$$$$$$$$BEFORE fn_fill_schedule_gaps');

            IF NOT Fn_Fill_Schedule_Gaps(p_Account_Rec
                                        ,
                                         --euro bank retro changes LOG#103 starts
                                         -- start  month end periodicity LOG#102
                                         p_Due_Dates_On_Acc
                                        ,
                                         -- end  month end periodicity LOG#102
                                         --euro bank retro changes LOG#103 ends
                                         p_Err_Code
                                        ,p_Err_Param) THEN
               Dbg('returned false from fn_fill_schedule_gaps');
               RETURN FALSE;
            END IF;

            ---LOG#64 START
            l_Comp_Indx := p_Account_Rec.g_Tb_Components.FIRST;
            WHILE l_Comp_Indx IS NOT NULL LOOP
               l_Indx := p_Account_Rec.g_Tb_Components(l_Comp_Indx).g_Tb_Comp_Sch.FIRST;
               WHILE l_Indx IS NOT NULL LOOP
                  --log#114 Start
                  /*
                  IF p_account_rec.g_tb_components(l_comp_indx).g_tb_comp_sch.EXISTS(l_indx)
                     AND p_account_rec.g_tb_components(l_comp_indx).comp_det.component_type <> 'L'
                     --AGAINST log#107 ITR1 SFR#52 START
                     AND
                     p_account_rec.g_tb_components(l_comp_indx).g_tb_comp_sch(l_indx).g_account_comp_sch.schedule_type <>'R'
                     --AGAINST log#107 ITR1 SFR#52 END

                  THEN
                  dbg('Component Name     ---->'|| l_comp_indx);
                  dbg('Schedule Index for '|| l_comp_indx ||'---->'||l_indx);
                  dbg('account no     ---->'||p_account_rec.g_tb_components(l_comp_indx).g_tb_comp_sch(l_indx).g_account_comp_sch.account_number);
                  l_formula_name                   := p_account_rec.g_tb_components(l_comp_indx).g_tb_comp_sch(l_indx).g_account_comp_sch.formula_name;
                  dbg('l_formula_name IS  '|| l_formula_name);
                  l_tb_cltms_comp_frm            := clpkss_cache.fn_cltms_product_comp_frm(p_ACcount_rec.account_det.product_code,l_comp_indx);
                  If p_account_rec.g_tb_components(l_comp_indx).g_tb_comp_sch(l_indx).g_account_comp_sch.compound_days IS NULL
                     AND  p_account_rec.g_tb_components(l_comp_indx).g_tb_comp_sch(l_indx).g_account_comp_sch.compound_months IS NULL
                     AND  p_account_rec.g_tb_components(l_comp_indx).g_tb_comp_sch(l_indx).g_account_comp_sch.compound_years IS NULL
                  THEN
                      p_account_rec.g_tb_components(l_comp_indx).g_tb_comp_sch(l_indx).g_account_comp_sch.compound_days   := l_tb_cltms_comp_frm(l_formula_name).compound_days;
                      p_account_rec.g_tb_components(l_comp_indx).g_tb_comp_sch(l_indx).g_account_comp_sch.compound_months := l_tb_cltms_comp_frm(l_formula_name).compound_months;
                      p_account_rec.g_tb_components(l_comp_indx).g_tb_comp_sch(l_indx).g_account_comp_sch.compound_years  := l_tb_cltms_comp_frm(l_formula_name).compound_years;

                  END IF;
                  END IF;
                  */

                  BEGIN
                     l_Tmp_Tb_Comp_Sch(1) := p_Account_Rec.g_Tb_Components(l_Comp_Indx)
                                            .g_Tb_Comp_Sch(l_Indx);

                     IF p_Account_Rec.g_Tb_Components(l_Comp_Indx)
                     .Comp_Det.Component_Type <> 'L' AND
                        p_Account_Rec.g_Tb_Components(l_Comp_Indx)
                     .g_Tb_Comp_Sch(l_Indx).g_Account_Comp_Sch.Schedule_Type <> 'R' THEN
                        l_Formula_Name      := p_Account_Rec.g_Tb_Components(l_Comp_Indx)
                                              .g_Tb_Comp_Sch(l_Indx)
                                              .g_Account_Comp_Sch.Formula_Name;
                        l_Tb_Cltms_Comp_Frm := Clpkss_Cache.Fn_Cltms_Product_Comp_Frm(p_Account_Rec.Account_Det.Product_Code
                                                                                     ,l_Comp_Indx);

                        IF p_Account_Rec.g_Tb_Components(l_Comp_Indx)
                        .g_Tb_Comp_Sch(l_Indx)
                        .g_Account_Comp_Sch.Compound_Days IS NULL AND
                           p_Account_Rec.g_Tb_Components(l_Comp_Indx)
                        .g_Tb_Comp_Sch(l_Indx)
                        .g_Account_Comp_Sch.Compound_Months IS NULL AND
                           p_Account_Rec.g_Tb_Components(l_Comp_Indx)
                        .g_Tb_Comp_Sch(l_Indx)
                        .g_Account_Comp_Sch.Compound_Years IS NULL THEN
                           p_Account_Rec.g_Tb_Components(l_Comp_Indx) .g_Tb_Comp_Sch(l_Indx) .g_Account_Comp_Sch.Compound_Days := l_Tb_Cltms_Comp_Frm(l_Formula_Name)
                                                                                                                                 .Compound_Days;
                           p_Account_Rec.g_Tb_Components(l_Comp_Indx) .g_Tb_Comp_Sch(l_Indx) .g_Account_Comp_Sch.Compound_Months := l_Tb_Cltms_Comp_Frm(l_Formula_Name)
                                                                                                                                   .Compound_Months;
                           p_Account_Rec.g_Tb_Components(l_Comp_Indx) .g_Tb_Comp_Sch(l_Indx) .g_Account_Comp_Sch.Compound_Years := l_Tb_Cltms_Comp_Frm(l_Formula_Name)
                                                                                                                                  .Compound_Years;

                        END IF;
                     END IF;
                  EXCEPTION
                     WHEN No_Data_Found THEN
                        NULL;
                  END;
                  --log#114 End
                  l_Indx := p_Account_Rec.g_Tb_Components(l_Comp_Indx)
                           .g_Tb_Comp_Sch.NEXT(l_Indx);
               END LOOP;
               l_Comp_Indx := p_Account_Rec.g_Tb_Components.NEXT(l_Comp_Indx);
            END LOOP;
            ---LOG#64 END

         END IF; --if p_Action = 'DFLT'

      EXCEPTION
         WHEN OTHERS THEN
            Clpkss_Logger.Pr_Log_Exception('');
            Dbg('in when others of create schedule while defaulting with ' || SQLERRM);

            l_Tb_For_Disbr.DELETE;
            l_Ty_Schedule_Date.DELETE;
            l_Ty_Tb_Account_Comp_Sch.DELETE;
            p_Err_Code  := 'CL-SCH036;';
            p_Err_Param := 'fn_create_schedules~;';
            Ovpkss.Pr_Appendtbl(p_Err_Code, p_Err_Param);
            RETURN FALSE;
      END;

      Dbg('done with defaulting');
      --Log#154 Starts
      dbg('p_Action_Code is '||p_Action_Code||'~p_Effective_Date~'||p_Effective_Date||'~'||p_Account_Rec.account_det.product_code);
      IF c3pk#_prd_shell.fn_get_contract_info( p_Account_Rec.account_det.Account_Number
                                              ,p_Account_Rec.account_det.Branch_Code
                                              ,'LOAN_TYPE'
                                              ,p_Account_Rec.account_det.Product_Code
                                              ) = 'R'
      THEN
        IF p_Action_Code IN ('REDEF', 'VAMI')
        THEN
            l_Indx := p_Account_Rec.g_tb_components(PKG_PRINCIPAL).g_tb_comp_sch.FIRST;
            WHILE l_Indx IS NOT NULL
            LOOP
              --Log#157 Starts
              /*IF p_Account_Rec.g_tb_components(PKG_PRINCIPAL).g_tb_comp_sch(l_Indx).g_account_comp_sch.sch_end_date < p_Effective_Date*/
              IF p_Account_Rec.g_tb_components(PKG_PRINCIPAL).g_tb_comp_sch(l_Indx).g_account_comp_sch.sch_end_date <= p_Effective_Date
              --Log#157 Ends
                 AND p_Account_Rec.g_tb_components(PKG_PRINCIPAL).g_tb_comp_sch(l_Indx).g_account_comp_sch.schedule_type ='D'
              THEN
                  l_Amount := 0;
                  l_No_idx := p_Account_Rec.g_tb_components(PKG_PRINCIPAL).g_tb_disbr_schedules.FIRST;
                  WHILE l_No_idx IS NOT NULL
                  LOOP
                      IF p_Account_Rec.g_tb_components(PKG_PRINCIPAL).g_tb_disbr_schedules(l_No_idx).g_disbr_sch.schedule_due_date >=
                         p_Account_Rec.g_tb_components(PKG_PRINCIPAL).g_tb_comp_sch(l_Indx).g_account_comp_sch.first_due_date
                         AND p_Account_Rec.g_tb_components(PKG_PRINCIPAL).g_tb_disbr_schedules(l_No_idx).g_disbr_sch.schedule_due_date <=
                         p_Account_Rec.g_tb_components(PKG_PRINCIPAL).g_tb_comp_sch(l_Indx).g_account_comp_sch.sch_end_date
                      THEN
                          dbg('Amount to DSBR is '||p_Account_Rec.g_tb_components(PKG_PRINCIPAL).g_tb_disbr_schedules(l_No_idx).g_disbr_sch.amount_to_disbr);
                          l_Amount := p_Account_Rec.g_tb_components(PKG_PRINCIPAL).g_tb_disbr_schedules(l_No_idx).g_disbr_sch.amount_to_disbr;
                      END IF;
                      l_No_idx := p_Account_Rec.g_tb_components(PKG_PRINCIPAL).g_tb_disbr_schedules.NEXT(l_No_idx);
                  END LOOP;
                  p_Account_Rec.g_tb_components(PKG_PRINCIPAL).g_tb_comp_sch(l_Indx).g_account_comp_sch.amount := l_Amount;
              END IF;
              l_Indx := p_Account_Rec.g_tb_components(PKG_PRINCIPAL).g_tb_comp_sch.NEXT(l_Indx);
            END LOOP;
        END IF;
      END IF;
      --Log#154 Ends
      -------defaulting logic ends here-----------------

      --START Prasanna/Ravi FCCCL Phase 2 Changes. 04-May-2005. IQA SFR#305
      IF p_Action_Code IN ('NEW', 'DFLT', 'REDEF', 'ROLL', 'VAMI')
      --END Prasanna/Ravi FCCCL Phase 2 Changes. 04-May-2005. IQA SFR#305
       THEN

         l_Comp_Indx := p_Account_Rec.g_Tb_Components.FIRST;
         WHILE l_Comp_Indx IS NOT NULL LOOP
            BEGIN
               l_Comp_Det  := p_Account_Rec.g_Tb_Components(l_Comp_Indx).Comp_Det;
               l_Component := p_Account_Rec.g_Tb_Components(l_Comp_Indx)
                             .Comp_Det.Component_Name;
               --MTR1 SFR #136
               l_Is_Main_Comp := Nvl(p_Account_Rec.g_Tb_Components(l_Comp_Indx)
                                     .Comp_Det.Main_Component
                                    ,'N');

               Dbg('processing FOR--->' || l_Component);

               --log#114 Start
               IF Nvl(l_Comp_Det.Component_Type, '*') IN ('H', 'O') OR
                  Nvl(l_Comp_Det.Waive, 'N') = 'Y' THEN
                  RAISE Process_Next;
               END IF;
               --log#114 End

               --Delete all schedules tables in Case its New 'coz its going to be repopulated.

               l_Tb_Pmnt_Schs := p_Account_Rec.g_Tb_Components(l_Comp_Indx).g_Tb_Amt_Due;

               --MTR1 SFR #136 ..logic of deletion of detail tables changed
               --START Ravi 21-Nov-2004. FCCCL 1.0 9NT252 MTR1 SFR#165
               ---Late Fee Changes on 18 Apr '06 starts log#101
               --IF NVL(l_comp_det.Component_Type,'*') NOT IN ('P','H','M','O')
               IF Nvl(l_Comp_Det.Component_Type, '*') NOT IN ('P', 'H', 'M', 'O', 'F')
               ---Late Fee Changes on 18 Apr '06 ends log#101
               --IF NVL(l_comp_det.Component_Type,'*') NOT IN ('P','H','M','O')
                THEN

                  IF p_Action_Code IN ('NEW', 'DFLT', 'ROLL') THEN

                     l_Due_Indx           := l_Tb_Pmnt_Schs.FIRST;
                     l_Start_Redef_p_From := p_Effective_Date;

                     --START Prasanna/Ravi FCCCL Phase 2 Changes. 04-May-2005. IQA SFR#305
                     --ELSIF p_action_code = 'REDEF' THEN
                  ELSIF p_Action_Code IN ('REDEF', 'VAMI') THEN
                     --END Prasanna/Ravi FCCCL Phase 2 Changes. 04-May-2005. IQA SFR#305
                     l_Bool := Fn_Get_Actual_Split_Date(p_Account_Rec.g_Tb_Components(l_Comp_Indx)
                                                       ,p_Effective_Date
                                                       ,'P'
                                                       ,l_First_Split_Date
                                                       ,p_Err_Code);
                     IF l_Bool = FALSE THEN
                        --delete the local pl-sql tables
                        l_Tb_Revision_Schedules.DELETE;
                        l_Tb_Disbursement_Schedules.DELETE;
                        l_Tb_Payment_Schedules.DELETE;

                        l_Out_Tb_Amt_Due.DELETE;
                        l_Tb_Amort_Dues.DELETE;
                        l_Out_Tb_Disbr_Schs.DELETE;
                        l_Out_Tb_Revn_Schs.DELETE;
                        l_Tb_Pmnt_Schs.DELETE;
                        RETURN FALSE;
                     END IF;

                     IF l_First_Split_Date IS NOT NULL THEN
                        l_Due_Indx           := Clpkss_Util.Fn_Hash_Date(l_First_Split_Date);
                        l_Start_Redef_p_From := p_Account_Rec.g_Tb_Components(l_Comp_Indx)
                                               .g_Tb_Amt_Due(l_Due_Indx)
                                               .g_Amount_Due.Schedule_St_Date;
                     ELSE
                        --Means either this schedule was over and new schedules are being defined
                        --or no schedule of this type was present.
                        IF p_Account_Rec.g_Tb_Components(l_Comp_Indx)
                        .g_Tb_Amt_Due.COUNT = 0 THEN
                           l_Start_Redef_p_From := l_Value_Date;
                        ELSE
                           l_Start_Redef_p_From := p_Account_Rec.g_Tb_Components(l_Comp_Indx)
                                                  .g_Tb_Amt_Due(p_Account_Rec.g_Tb_Components(l_Comp_Indx)
                                                                .g_Tb_Amt_Due.LAST) .
                                                   g_Amount_Due.Schedule_Due_Date;

                           -- Log#72 Start.
                           --l_rec_account := clpkss_cache.fn_account_master(p_account_rec.account_det.account_number,
                           --                                                p_account_rec.account_det.branch_code);
                           Dbg(' p_effective_date ::' || p_Effective_Date); --||' mat dt ::'||l_rec_account.maturity_date);
                           --IF p_effective_date > l_rec_account.maturity_date
                           --THEN
                           -- In this case bullet scheduel shld be deleted.
                           l_Due_Indx := Clpkss_Util.Fn_Hash_Date(l_Start_Redef_p_From);
                           --END IF;
                           -- Log#72 End.

                        END IF;

                     END IF;

                  END IF;

               END IF;

               Dbg('P type schedule redef will be done from start date ' ||
                   l_Start_Redef_p_From);
               --END Ravi 21-Nov-2004. FCCCL 1.0 9NT252 MTR1 SFR#165

               -- START LOG#51 06-Jun-2005 SFR#124
               -- If this is recalc and if the component is amortized retain the same emi for the schedule due date
               --  immediately next to 'p_effective_date' date
               -- This is required as the emi amount for the current schedule in which p_build_schs_from IS
               -- should be retained and the EMI has to be changed only from the next due date (next to the immediate due date)
               Dbg('p_effective_date = ' || p_Effective_Date);
               l_Hsh_Effective_Date := Clpkss_Util.Fn_Hash_Date(p_Effective_Date);

               -- l_start_redef_P_from will be less than p_effective_date only when the
               -- p_effective_date is falling inside a schedule and there has been  no prepayment for the
               -- schedule in which the p_effective_date falls in
               IF l_Start_Redef_p_From < p_Effective_Date THEN
                  Dbg('This p_effective_date is falling inside a payment schedule so dont  update the emi amount for this schedule as this is used by calc');
                  l_Next_To_Effective_Dt_Idx := p_Account_Rec.g_Tb_Components(l_Comp_Indx)
                                               .g_Tb_Amt_Due.NEXT(l_Hsh_Effective_Date);
                  IF l_Next_To_Effective_Dt_Idx IS NOT NULL THEN
                     l_Emi_Amount_Presevered := p_Account_Rec.g_Tb_Components(l_Comp_Indx)
                                               .g_Tb_Amt_Due(l_Next_To_Effective_Dt_Idx)
                                               .g_Amount_Due.Emi_Amount;
                  END IF; -- IF l_next_to_effective_dt_idx IS NOT NULL THEN
               END IF; -- IF  l_start_redef_P_from < p_effective_date THEN
               -- END LOG#51 06-Jun-2005 SFR#124

               ---
               -- PERF CHANGES Starts
               --
               --                WHILE l_due_indx IS NOT NULL
               --                LOOP
               --                    IF l_component = PKG_PRINCIPAL OR NVL(l_comp_det.Component_Type,'*') = 'L'
               --                    THEN
               --
               --                        --Phase II NLS changes
               --                        IF l_tb_pmnt_schs(l_due_indx).g_amount_due.schedule_type = 'P' THEN
               --                            dbg('clearing account schedules for Principal comp and due date '|| l_tb_pmnt_schs(l_due_indx).g_amount_due.schedule_due_date);
               --                            p_account_rec.g_tb_components(l_comp_indx) .g_tb_amt_due.DELETE(l_due_indx);
               --                        END IF;
               --
               --                        l_due_indx := l_tb_pmnt_schs.NEXT(l_due_indx);
               --                    ELSIF l_is_main_comp = 'Y' OR NVL(l_comp_det.Component_Type,'*') = 'I'
               --                    THEN
               --
               --                       l_formula := p_account_rec.g_tb_components(l_comp_indx) .g_tb_amt_due(l_due_indx).g_amount_due.formula_name;
               --
               --                       dbg('clearing account schedules for Main Int comp and due date '|| l_tb_pmnt_schs(l_due_indx).g_amount_due.schedule_due_date);
               --                       p_account_rec.g_tb_components(l_comp_indx) .g_tb_amt_due.DELETE(l_due_indx);
               --                        --Principal also needs to be deleted in case its amortized..
               --
               --                       IF l_tb_frm_names.COUNT > 0 AND l_tb_frm_names.EXISTS(l_formula)
               --                       THEN
               --                          l_prin_comp := l_tb_amort_pairs (l_product_code||l_comp_indx||l_formula);
               --                          dbg('clearing account schedules for AMort Prin comp '|| l_prin_comp ||' and due date '|| l_tb_pmnt_schs(l_due_indx).g_amount_due.schedule_due_date);
               --                          --p_account_rec.g_tb_components(PKG_PRINCIPAL) .g_tb_amt_due.DELETE(l_due_indx);
               --                          p_account_rec.g_tb_components(l_prin_comp) .g_tb_amt_due.DELETE(l_due_indx);
               --                         --Phase II NLS changes
               --
               --                       END IF;
               --                    ELSE
               --                       dbg('clearing account schedules other comp and due date '|| l_tb_pmnt_schs(l_due_indx).g_amount_due.schedule_due_date);
               --                       p_account_rec.g_tb_components(l_comp_indx) .g_tb_amt_due.DELETE(l_due_indx);
               --                    END IF;
               --                    l_due_indx := l_tb_pmnt_schs.NEXT(l_due_indx);
               --                END LOOP;

               IF l_Due_Indx IS NOT NULL THEN

                  IF l_Component = Pkg_Principal OR
                     Nvl(l_Comp_Det.Component_Type, '*') = 'L' THEN

                     WHILE l_Due_Indx IS NOT NULL LOOP

                        --Phase II NLS changes
                        IF l_Tb_Pmnt_Schs(l_Due_Indx).g_Amount_Due.Schedule_Type = 'P' THEN
                           Dbg('clearing account schedules for Principal comp and due date ' ||
                               l_Tb_Pmnt_Schs(l_Due_Indx).g_Amount_Due.Schedule_Due_Date);
                           p_Account_Rec.g_Tb_Components(l_Comp_Indx) .g_Tb_Amt_Due.DELETE(l_Due_Indx);
                        END IF;

                        l_Due_Indx := l_Tb_Pmnt_Schs.NEXT(l_Due_Indx);

                     END LOOP;
                  ELSIF l_Is_Main_Comp = 'Y' OR Nvl(l_Comp_Det.Component_Type, '*') = 'I' THEN

                     WHILE l_Due_Indx IS NOT NULL LOOP
                        l_Formula := p_Account_Rec.g_Tb_Components(l_Comp_Indx)
                                    .g_Tb_Amt_Due(l_Due_Indx).g_Amount_Due.Formula_Name;

                        Dbg('clearing account schedules for Main Int comp and due date ' ||
                            l_Tb_Pmnt_Schs(l_Due_Indx).g_Amount_Due.Schedule_Due_Date);
                        p_Account_Rec.g_Tb_Components(l_Comp_Indx) .g_Tb_Amt_Due.DELETE(l_Due_Indx);
                        --Principal also needs to be deleted in case its amortized..
                        --log#114 Start
                        /*
                        IF l_tb_frm_names.COUNT > 0 AND l_tb_frm_names.EXISTS(l_formula)
                        THEN
                            l_prin_comp := l_tb_amort_pairs (l_product_code||l_comp_indx||l_formula);
                            dbg('clearing account schedules for AMort Prin comp '|| l_prin_comp ||' and due date '|| l_tb_pmnt_schs(l_due_indx).g_amount_due.schedule_due_date);
                            --p_account_rec.g_tb_components(PKG_PRINCIPAL) .g_tb_amt_due.DELETE(l_due_indx);
                            p_account_rec.g_tb_components(l_prin_comp) .g_tb_amt_due.DELETE(l_due_indx);
                            --Phase II NLS changes

                        END IF;
                        */
                        IF l_Tb_Frm_Names.COUNT > 0 THEN

                           BEGIN
                              l_Tmp_Tb_Frm_Names(1) := l_Tb_Frm_Names(l_Formula);
                              l_Prin_Comp := l_Tb_Amort_Pairs(l_Product_Code ||
                                                              l_Comp_Indx || l_Formula);
                              p_Account_Rec.g_Tb_Components(l_Prin_Comp) .g_Tb_Amt_Due.DELETE(l_Due_Indx);
                           EXCEPTION
                              WHEN No_Data_Found THEN
                                 NULL;
                           END;

                        END IF;
                        --log#114 End
                        l_Due_Indx := l_Tb_Pmnt_Schs.NEXT(l_Due_Indx);

                     END LOOP;

                  ELSE

                     WHILE l_Due_Indx IS NOT NULL LOOP

                        Dbg('clearing account schedules other comp and due date ' ||
                            l_Tb_Pmnt_Schs(l_Due_Indx).g_Amount_Due.Schedule_Due_Date);
                        p_Account_Rec.g_Tb_Components(l_Comp_Indx) .g_Tb_Amt_Due.DELETE(l_Due_Indx);

                        l_Due_Indx := l_Tb_Pmnt_Schs.NEXT(l_Due_Indx);

                     END LOOP;

                  END IF;

               END IF;

               -- PERF CHANGES Ends
               ---
               --Delete Revision schedules
               IF p_Action_Code IN ('NEW', 'DFLT', 'ROLL') THEN
                  l_Due_Indx           := p_Account_Rec.g_Tb_Components(l_Comp_Indx)
                                         .g_Tb_Revn_Schedules.FIRST;
                  l_Start_Redef_r_From := p_Effective_Date;
                  --START Prasanna/Ravi FCCCL Phase 2 Changes. 04-May-2005. IQA SFR#305
                  --ELSIF p_action_code = 'REDEF' THEN
               ELSIF p_Action_Code IN ('REDEF', 'VAMI') THEN
                  --END Prasanna/Ravi FCCCL Phase 2 Changes. 04-May-2005. IQA SFR#305
                  --l_due_indx  := clpkss_util.fn_hash_date(p_effective_date);
                  l_Bool := Fn_Get_Actual_Split_Date(p_Account_Rec.g_Tb_Components(l_Comp_Indx)
                                                    ,p_Effective_Date
                                                    ,'R'
                                                    ,l_First_Split_Date
                                                    ,p_Err_Code);
                  IF l_Bool = FALSE THEN
                     --delete the local pl-sql tables
                     l_Tb_Revision_Schedules.DELETE;
                     l_Tb_Disbursement_Schedules.DELETE;
                     l_Tb_Payment_Schedules.DELETE;
                     l_Out_Tb_Amt_Due.DELETE;
                     l_Tb_Amort_Dues.DELETE;
                     l_Out_Tb_Disbr_Schs.DELETE;
                     l_Out_Tb_Revn_Schs.DELETE;
                     l_Tb_Pmnt_Schs.DELETE;
                     RETURN FALSE;
                  END IF;
                  IF l_First_Split_Date IS NOT NULL THEN
                     l_Due_Indx           := Clpkss_Util.Fn_Hash_Date(l_First_Split_Date);
                     l_Start_Redef_r_From := p_Account_Rec.g_Tb_Components(l_Comp_Indx)
                                            .g_Tb_Revn_Schedules(l_Due_Indx)
                                            .g_Revn_Schedules.Schedule_St_Date;
                  ELSE
                     --l_first_split_date having value NULL means two things
                     --: 1> no schedules was defined after effective date
                     --: 2> no schedules were defined at all for this component/Sch Type combination
                     --In case user is defining new schedules during CAMD then
                     IF p_Account_Rec.g_Tb_Components(l_Comp_Indx)
                     .g_Tb_Revn_Schedules.COUNT = 0 THEN
                        l_Start_Redef_r_From := l_Value_Date;
                     ELSE
                        l_Start_Redef_r_From := p_Account_Rec.g_Tb_Components(l_Comp_Indx)
                                               .g_Tb_Revn_Schedules(p_Account_Rec.g_Tb_Components(l_Comp_Indx)
                                                                    .g_Tb_Revn_Schedules.LAST)
                                               .g_Revn_Schedules.Schedule_Due_Date;
                     END IF;
                  END IF;
               END IF;
               WHILE l_Due_Indx IS NOT NULL LOOP
                  p_Account_Rec.g_Tb_Components(l_Comp_Indx) .g_Tb_Revn_Schedules.DELETE(l_Due_Indx);

                  l_Due_Indx := p_Account_Rec.g_Tb_Components(l_Comp_Indx)
                               .g_Tb_Revn_Schedules.NEXT(l_Due_Indx);
               END LOOP;

               --Delete for disbr schedules
               IF p_Action_Code IN ('NEW', 'DFLT', 'ROLL') THEN
                  l_Due_Indx           := p_Account_Rec.g_Tb_Components(l_Comp_Indx)
                                         .g_Tb_Disbr_Schedules.FIRST;
                  l_Start_Redef_d_From := p_Effective_Date;
                  --START Prasanna/Ravi FCCCL Phase 2 Changes. 04-May-2005. IQA SFR#305
                  --ELSIF p_action_code = 'REDEF' THEN
               ELSIF p_Action_Code IN ('REDEF', 'VAMI') THEN
                  --END Prasanna/Ravi FCCCL Phase 2 Changes. 04-May-2005. IQA SFR#305
                  --l_due_indx  := clpkss_util.fn_hash_date(p_effective_date);
                  l_Bool := Fn_Get_Actual_Split_Date(p_Account_Rec.g_Tb_Components(l_Comp_Indx)
                                                    ,p_Effective_Date
                                                    ,'D'
                                                    ,l_First_Split_Date
                                                    ,p_Err_Code);
                  IF l_Bool = FALSE THEN
                     --delete the local pl-sql tables
                     l_Tb_Revision_Schedules.DELETE;
                     l_Tb_Disbursement_Schedules.DELETE;
                     l_Tb_Payment_Schedules.DELETE;

                     l_Out_Tb_Amt_Due.DELETE;
                     l_Tb_Amort_Dues.DELETE;
                     l_Out_Tb_Disbr_Schs.DELETE;
                     l_Out_Tb_Revn_Schs.DELETE;
                     l_Tb_Pmnt_Schs.DELETE;
                     RETURN FALSE;
                  END IF;
                  dbg('l_First_Split_Date'||l_First_Split_Date);
                  IF l_First_Split_Date IS NOT NULL THEN
                     dbg('in side l_First_Split_Date if loop');
                     dbg('l_Due_Indx'||Clpkss_Util.Fn_Hash_Date(l_First_Split_Date));
                     l_Due_Indx           := Clpkss_Util.Fn_Hash_Date(l_First_Split_Date);
                     dbg('l_Due_Indx'||l_Due_Indx);
					 IF p_Account_Rec.g_Tb_Components(l_Comp_Indx)
                                            .g_Tb_Disbr_Schedules.EXISTS(l_Due_Indx) THEN--RAKBANK Changes and Fix added FCUBS_113_13634866
                     l_Start_Redef_d_From := p_Account_Rec.g_Tb_Components(l_Comp_Indx)
                                            .g_Tb_Disbr_Schedules(l_Due_Indx)
                                            .g_Disbr_Sch.Schedule_St_Date;
					END IF;--RAKBANK Changes and Fix added  FCUBS_113_13634866
                     dbg('l_Start_Redef_d_From'||l_Start_Redef_d_From);
                  END IF;
               END IF;
               dbg('123456');
               WHILE l_Due_Indx IS NOT NULL LOOP
               dbg('1234567');
                  p_Account_Rec.g_Tb_Components(l_Comp_Indx) .g_Tb_Disbr_Schedules.DELETE(l_Due_Indx);
               dbg('12345678');
                  l_Due_Indx := p_Account_Rec.g_Tb_Components(l_Comp_Indx)
                               .g_Tb_Disbr_Schedules.NEXT(l_Due_Indx);
                  dbg('l_Due_Indx2'||l_Due_Indx);
               END LOOP;
               --deletion of schedules over
               ------------------------------------------------------------------------------
               --repopulation of schedules starts
               ------------------------------------------------------------------------------
               Dbg('repopulation of schedules starts');

               Dbg('P type schedules will be repopulated from start date ' ||
                   l_Start_Redef_p_From);
               Dbg('R type schedules will be repopulated from start date ' ||
                   l_Start_Redef_r_From);
               Dbg('D type schedules will be repopulated from start date ' ||
                   l_Start_Redef_d_From);
                     --Log#141 Abhishek Ranjan for Principal Repyament Holiday 14.09.2009 Starts
                  IF NOT fn_regen_compsch_prinhol( p_account_rec
                                                  ,p_action_code
                                                  ,l_start_redef_P_from
                                                  ,l_comp_indx
                                                  ,p_err_code
                                                  ,p_err_param
                                                  )
                  THEN
                      dbg('Failed in fn_regen_compsch_prinhol with '||p_err_code||'~'||p_err_param);
                      RETURN FALSE;
                  END IF;
                  --Log#141 Abhishek Ranjan for Principal Repyament Holiday 14.09.2009 Ends
               l_Ty_Tb_Account_Comp_Sch := p_Account_Rec.g_Tb_Components(l_Comp_Indx)
                                          .g_Tb_Comp_Sch;
               l_Indx                   := l_Ty_Tb_Account_Comp_Sch.FIRST;
               WHILE l_Indx IS NOT NULL LOOP
                  --take schedules which have start date after effective date.
                  --IF l_ty_tb_account_comp_sch(l_indx).g_account_comp_sch.sch_start_date >=
                  --   p_effective_date
                  --THEN
                  IF (l_Ty_Tb_Account_Comp_Sch(l_Indx)
                     .g_Account_Comp_Sch.Schedule_Type = 'P')
                    -- START LOG#46 23-May-2005 SFR#1
                    --AND l_ty_tb_account_comp_sch(l_indx).g_account_comp_sch.sch_start_date >= NVL(l_start_redef_P_from,l_maturity_date)
                     AND l_Ty_Tb_Account_Comp_Sch(l_Indx)
                  .g_Account_Comp_Sch.Sch_End_Date >=
                     Nvl(l_Start_Redef_p_From, l_Maturity_Date)
                  -- END LOG#46 23-May-2005 SFR#1
                   THEN
                     Dbg('INTOTHELOOP FOR ' || l_Ty_Tb_Account_Comp_Sch(l_Indx)
                         .g_Account_Comp_Sch.Component_Name);
                     l_Tb_Payment_Schedules(l_Indx) := l_Ty_Tb_Account_Comp_Sch(l_Indx);
                  ELSIF (l_Ty_Tb_Account_Comp_Sch(l_Indx)
                        .g_Account_Comp_Sch.Schedule_Type = 'D') AND
                        l_Ty_Tb_Account_Comp_Sch(l_Indx)
                  .g_Account_Comp_Sch.Sch_Start_Date >=
                        Nvl(l_Start_Redef_d_From, l_Maturity_Date) THEN
                     l_Tb_Disbursement_Schedules(l_Indx) := l_Ty_Tb_Account_Comp_Sch(l_Indx);
                  ELSIF (l_Ty_Tb_Account_Comp_Sch(l_Indx)
                        .g_Account_Comp_Sch.Schedule_Type = 'R')
                       --Log#118 starts,
                       --AND l_ty_tb_account_comp_sch(l_indx).g_account_comp_sch.sch_start_date >= NVL(l_start_redef_R_from,l_maturity_date)
                        AND l_Ty_Tb_Account_Comp_Sch(l_Indx)
                  .g_Account_Comp_Sch.Sch_End_Date >=
                        Nvl(l_Start_Redef_r_From, l_Maturity_Date)
                  --Log#118 ends,
                   THEN
                     l_Tb_Revision_Schedules(l_Indx) := l_Ty_Tb_Account_Comp_Sch(l_Indx);
                  END IF;

                  --END IF;
                  l_Indx := l_Ty_Tb_Account_Comp_Sch.NEXT(l_Indx);
               END LOOP;
               IF l_Tb_Payment_Schedules.COUNT > 0 THEN
                  --call populate account schedules
                  --Log#140 Start changes for Advance and arrears schedules
		  if  NVL(l_rec_prod.lease_payment_mode,'X')  = 'A'  then
		  l_maturity_date := NVL(l_lastschDate,l_maturity_date);
		  end if;
                  --Log#140 End changes for Advance and arrears schedules
                  Dbg('will be calling fn_populate_account_schedules now');
                  l_Bool := Fn_Populate_Account_Schedules(l_Tb_Payment_Schedules
                                                         ,l_Account_No
                                                         ,l_Branch_Code
                                                         ,l_Product_Code
                                                         ,l_Process_No
                                                         ,l_Comp_Det
                                                         ,l_Value_Date
                                                         ,l_Maturity_Date
														 ,p_account_rec.account_det.module_code ---- Log#162 Changes for 11.1 Dev (Payment in Advance)
                                                         ,l_Ignore_Holiday
                                                         ,l_Forward_Backward
                                                         ,l_Move_Across_Month
                                                         ,l_Cascade_Movement
                                                         ,l_Out_Tb_Amt_Due
                                                         ,l_Tb_Amort_Dues
                                                         ,
                                                          -- START L Anantharaman 11-Apr-2005 FCCCL1.0 PhaseII reduce tenor changes
                                                          l_Tb_Dummy_Amt_Dues
                                                         , -- is to be filled up only in the case of shift schedules
                                                          l_Tb_Dummy_Amt_Dues
                                                         ,
                                                          -- END L Anantharaman 11-Apr-2005 FCCCL1.0 PhaseII reduce tenor changes
                                                          --START LOG#46 23-May-2005 SFR#1
                                                          l_Start_Redef_p_From
                                                         ,
                                                          --END LOG#46 23-May-2005 SFR#1
                                                          --log#111 retro starts
                                                          p_Action_Code
                                                         ,
                                                          --log#111 retro ends
                                                          p_Err_Code);
                  IF l_Bool = FALSE THEN
                     Dbg('fn_populate_account_schedules returned false');
                     l_Tb_Revision_Schedules.DELETE;
                     l_Tb_Disbursement_Schedules.DELETE;
                     l_Tb_Payment_Schedules.DELETE;

                     l_Out_Tb_Amt_Due.DELETE;
                     l_Tb_Amort_Dues.DELETE;
                     l_Out_Tb_Disbr_Schs.DELETE;
                     l_Out_Tb_Revn_Schs.DELETE;
                     l_Tb_Pmnt_Schs.DELETE;
                     RETURN FALSE;
                  ELSE
                     Dbg('hurrah');
                     Dbg('g_tb_amt_due.count - ' || l_Out_Tb_Amt_Due.COUNT);
                     IF p_Account_Rec.g_Tb_Components(l_Comp_Indx).g_Tb_Amt_Due.COUNT = 0 THEN
                        p_Account_Rec.g_Tb_Components(l_Comp_Indx) .g_Tb_Amt_Due := l_Out_Tb_Amt_Due;
                     ELSE
                        l_Due_Indx := l_Out_Tb_Amt_Due.FIRST;
                        -- START LOG#51 06-Jun-2005 SFR#124
                        IF l_Due_Indx IS NOT NULL THEN
                           p_Account_Rec.g_Tb_Components(l_Comp_Indx) .g_Tb_Amt_Due(l_Due_Indx) := l_Out_Tb_Amt_Due(l_Due_Indx);
                           p_Account_Rec.g_Tb_Components(l_Comp_Indx) .g_Tb_Amt_Due(l_Due_Indx) .g_Amount_Due.Emi_Amount := l_Emi_Amount_Presevered;
                           l_Due_Indx := l_Out_Tb_Amt_Due.NEXT(l_Due_Indx); -- Copy all from next record as it is in l_out_tb_amt_due
                        END IF; -- IF l_due_indx IS NOT NULL THEN
                        -- END LOG#51 06-Jun-2005 SFR#124
                        WHILE l_Due_Indx IS NOT NULL LOOP
                           p_Account_Rec.g_Tb_Components(l_Comp_Indx) .g_Tb_Amt_Due(l_Due_Indx) := l_Out_Tb_Amt_Due(l_Due_Indx);
                           l_Due_Indx := l_Out_Tb_Amt_Due.NEXT(l_Due_Indx);
                        END LOOP;
                     END IF;
                     Dbg('l_tb_amort_dues.count - ' || l_Tb_Amort_Dues.COUNT);
                     --populate account rec for amortized dues also.
                     l_Due_Indx := l_Tb_Amort_Dues.FIRST;
                     WHILE l_Due_Indx IS NOT NULL LOOP
                        --CL PHASE II Corfo Related Enahncements
                        -- p_account_rec.g_tb_components(PKG_PRINCIPAL).g_tb_amt_due(l_due_indx) := l_tb_amort_dues(l_due_indx);
                        p_Account_Rec.g_Tb_Components(l_Tb_Amort_Dues(l_Due_Indx) .g_Amount_Due.Component_Name) .g_Tb_Amt_Due(l_Due_Indx) := l_Tb_Amort_Dues(l_Due_Indx);
                        --Phase II NLS changes
                        -- Log#134 Changes Starts
                        -- l_due_indx := l_out_tb_amt_due.NEXT(l_due_indx);
                        l_Due_Indx := l_Tb_Amort_Dues.NEXT(l_Due_Indx);
                        --Log#134 Ends
                     END LOOP;
                  END IF;
               END IF;

               -- Raja start 29-04-05 log#42
               l_Bool := Fn_Gen_Sch_No(p_Account_Rec, p_Err_Code, p_Err_Param);
               IF l_Bool = FALSE THEN
                  Dbg('fn_gen__sch_no returned false');
               END IF;
               -- Raja End  log#42

               IF l_Tb_Disbursement_Schedules.COUNT > 0 THEN
                  --call populate disbursements
                  l_Bool := Fn_Populate_Disbursments(l_Tb_Disbursement_Schedules
                                                    ,l_Account_No
                                                    ,l_Branch_Code
                                                    ,l_Product_Code
                                                    ,l_Comp_Det
                                                    ,
                                                     --p_effective_date,
                                                     l_Value_Date
                                                    ,l_Maturity_Date
                                                    ,l_Amount_Financed
                                                    ,l_Ignore_Holiday
                                                    ,l_Forward_Backward
                                                    ,l_Move_Across_Month
                                                    ,l_Cascade_Movement
                                                    ,
                                                     --l_holiday_chk_failed,
                                                     l_Out_Tb_Disbr_Schs
                                                    ,p_Err_Code);
                  IF l_Bool = FALSE THEN
                     l_Tb_Revision_Schedules.DELETE;
                     l_Tb_Disbursement_Schedules.DELETE;
                     l_Tb_Payment_Schedules.DELETE;

                     l_Out_Tb_Amt_Due.DELETE;
                     l_Tb_Amort_Dues.DELETE;
                     l_Out_Tb_Disbr_Schs.DELETE;
                     l_Out_Tb_Revn_Schs.DELETE;
                     l_Tb_Pmnt_Schs.DELETE;
                     RETURN FALSE;
                  END IF;

                  --p_account_rec.g_tb_components(i) .g_tb_DISBR_SCHEDULES := l_out_tb_disbr_schs;

                  IF p_Account_Rec.g_Tb_Components(l_Comp_Indx)
                  .g_Tb_Disbr_Schedules.COUNT = 0 THEN
                     p_Account_Rec.g_Tb_Components(l_Comp_Indx) .g_Tb_Disbr_Schedules := l_Out_Tb_Disbr_Schs;
                  ELSE
                     l_Due_Indx := l_Out_Tb_Disbr_Schs.FIRST;

                     WHILE l_Due_Indx IS NOT NULL LOOP
                        p_Account_Rec.g_Tb_Components(l_Comp_Indx) .g_Tb_Disbr_Schedules(l_Due_Indx) := l_Out_Tb_Disbr_Schs(l_Due_Indx);
                        l_Due_Indx := l_Out_Tb_Disbr_Schs.NEXT(l_Due_Indx);
                     END LOOP;
                  END IF;
               END IF;
               --log#111 retro starts
                IF (Global.X9$ = 'CLPBDC') /*OR (GWPKS_CL_SERVICE.g_Websrv_Req = TRUE)) */THEN
                  --log#111 retro ends

                  -- Bala Murali BDC retros 30-jan-2006 start Log#85
                  --MPM Oct.20th, 2005
                  Dbg(' exit from l_comp_indx arn 2 ');
                  l_Prod_Comp_Row := Clpkss_Cache.Fn_Product_Components(p_Account_Rec.Account_Det.Product_Code
                                                                       ,l_Comp_Indx);
                  --l_prod_comp_row.rate_to_use;
                  IF l_Prod_Comp_Row.Rate_To_Use IS NOT NULL THEN
                     l_Indx := p_Account_Rec.g_Tb_Ude_Values(l_Prod_Comp_Row.Rate_To_Use)
                              .g_Tb_Ude_Val.FIRST;
                     --log#119 changes start
                     l_Rate_To_Use := l_Prod_Comp_Row.Rate_To_Use;
                     -- log#119 changes end
                  ELSE
                     --log#119 changes start
                     IF l_Comp_Indx = Pkg_Main_Int THEN
                        l_Indx        := p_Account_Rec.g_Tb_Ude_Values(Pkg_Interest_Rate)
                                        .g_Tb_Ude_Val.FIRST;
                        l_Rate_To_Use := Pkg_Interest_Rate;
                     ELSE
                        --log#119  changes end
                        l_Indx := NULL;
                        --log#119 changes start
                        l_Rate_To_Use := NULL;
                     END IF;
                     --log#119 changes end
                  END IF;
                  --PRANAV@CLPBDC CHANGES START
                  --                     L_FLAG := TRUE; -- this flag stop generation of REVNs
                  l_Flag := FALSE; -- this flag stop generation of REVNs
                  WHILE l_Indx IS NOT NULL LOOP
                     -- log#119 changes start
                     /***   dbg ( 'UDE_VALUE hash :' || p_account_rec.g_tb_ude_values(l_prod_comp_row.rate_to_use).g_tb_UDE_VAL(L_INDX).G_UDE_VALUES.UDE_VALUE || ' index:' || l_indx);
                      dbg ( 'rate_code hash : count ' ||  p_account_rec.g_tb_ude_values(l_prod_comp_row.rate_to_use).g_tb_UDE_VAL.COUNT || ' value: '  || p_account_rec.g_tb_ude_values(l_prod_comp_row.rate_to_use).g_tb_UDE_VAL(L_INDX).G_UDE_VALUES.RATE_CODE);
                      dbg ( 'code_usage hash: ' || p_account_rec.g_tb_ude_values(l_prod_comp_row.rate_to_use).g_tb_UDE_VAL(L_INDX).G_UDE_VALUES.CODE_USAGE);
                     ***/
                     -- log#119 changes end
                     /*
                                            IF ( ((p_account_rec.g_tb_ude_values(l_prod_comp_row.rate_to_use).g_tb_UDE_VAL(L_INDX).G_UDE_VALUES.UDE_VALUE = 0 OR p_account_rec.g_tb_ude_values(l_prod_comp_row.rate_to_use).g_tb_UDE_VAL(L_INDX).G_UDE_VALUES.UDE_VALUE IS NULL) AND p_account_rec.g_tb_ude_values(l_prod_comp_row.rate_to_use).g_tb_UDE_VAL(L_INDX).G_UDE_VALUES.RATE_CODE IS NULL) OR
                                               (p_account_rec.g_tb_ude_values(l_prod_comp_row.rate_to_use).g_tb_UDE_VAL(L_INDX).G_UDE_VALUES.UDE_VALUE > 0 AND p_account_rec.g_tb_ude_values(l_prod_comp_row.rate_to_use).g_tb_UDE_VAL(L_INDX).G_UDE_VALUES.RATE_CODE IS NULL) OR
                                               (p_account_rec.g_tb_ude_values(l_prod_comp_row.rate_to_use).g_tb_UDE_VAL(L_INDX).G_UDE_VALUES.UDE_VALUE >0 AND p_account_rec.g_tb_ude_values(l_prod_comp_row.rate_to_use).g_tb_UDE_VAL(L_INDX).G_UDE_VALUES.RATE_CODE IS NOT NULL AND p_account_rec.g_tb_ude_values(l_prod_comp_row.rate_to_use).g_tb_UDE_VAL(L_INDX).G_UDE_VALUES.CODE_USAGE <> 'P')
                                               )
                                            THEN
                                               L_FLAG := FALSE;
                                            END IF;
                     */
                     --log#119 starts
                     /*                     IF ( p_account_rec.g_tb_ude_values(l_prod_comp_row.rate_to_use).g_tb_UDE_VAL(L_INDX).G_UDE_VALUES.RATE_CODE IS NOT NULL
                                                AND p_account_rec.g_tb_ude_values(l_prod_comp_row.rate_to_use).g_tb_UDE_VAL(L_INDX).G_UDE_VALUES.CODE_USAGE = 'P')

                                            THEN
                                               L_FLAG := TRUE;
                                            END IF;
                     */
                     IF (p_Account_Rec.g_Tb_Ude_Values(l_Rate_To_Use).g_Tb_Ude_Val(l_Indx)
                        .g_Ude_Values.Rate_Code IS NOT NULL AND
                         p_Account_Rec.g_Tb_Ude_Values(l_Rate_To_Use).g_Tb_Ude_Val(l_Indx)
                        .g_Ude_Values.Code_Usage = 'P')

                      THEN
                        l_Flag := TRUE;
                     END IF;
                     --log#119 ends
                     --PRANAV@CLPBDC CHANGES ENDS

                     IF (l_Flag) THEN
                        Dbg('FLAG: TRUE');
                     ELSE
                        Dbg('FLAG: FALSE');
                     END IF;
                     --log#119 starts
                     --                     L_INDX := p_account_rec.g_tb_ude_values(l_prod_comp_row.rate_to_use).g_tb_UDE_VAL.NEXT(l_indx);
                     l_Indx := p_Account_Rec.g_Tb_Ude_Values(l_Rate_To_Use)
                              .g_Tb_Ude_Val.NEXT(l_Indx);
                     --log#119 ends
                  END LOOP;
                  --MPM

                  --Log#111 retro starts
               ELSE
                  l_Flag := TRUE;
               END IF;
               --Log#111 retro ends

               IF l_Tb_Revision_Schedules.COUNT > 0 AND l_Flag --MPM
               -- -- Bala Murali BDC retros 30-jan-2006 ends Log#85
                THEN
                  l_Bool := Fn_Populate_Revisions(l_Tb_Revision_Schedules
                                                 ,l_Account_No
                                                 ,l_Branch_Code
                                                 ,l_Product_Code
                                                 ,l_Comp_Det
                                                 ,
                                                  --p_effective_date,
                                                  l_Value_Date
                                                 ,l_Maturity_Date
                                                 ,l_Ignore_Holiday
                                                 ,l_Forward_Backward
                                                 ,l_Move_Across_Month
                                                 ,l_Cascade_Movement
                                                 ,
                                                  --l_holiday_chk_failed,
                                                  l_Out_Tb_Revn_Schs
                                                 ,p_Err_Code);
                  IF l_Bool = FALSE THEN
                     l_Tb_Revision_Schedules.DELETE;
                     l_Tb_Disbursement_Schedules.DELETE;
                     l_Tb_Payment_Schedules.DELETE;

                     l_Out_Tb_Amt_Due.DELETE;
                     l_Tb_Amort_Dues.DELETE;
                     l_Out_Tb_Disbr_Schs.DELETE;
                     l_Out_Tb_Revn_Schs.DELETE;
                     l_Tb_Pmnt_Schs.DELETE;
                     RETURN FALSE;
                  END IF;

                  --p_account_rec.g_tb_components(i) .g_tb_revn_schedules := l_out_tb_revn_schs;

                  IF p_Account_Rec.g_Tb_Components(l_Comp_Indx)
                  .g_Tb_Revn_Schedules.COUNT = 0 THEN
                     p_Account_Rec.g_Tb_Components(l_Comp_Indx) .g_Tb_Revn_Schedules := l_Out_Tb_Revn_Schs;
                  ELSE
                     l_Due_Indx := l_Out_Tb_Revn_Schs.FIRST;

                     WHILE l_Due_Indx IS NOT NULL LOOP
                        p_Account_Rec.g_Tb_Components(l_Comp_Indx) .g_Tb_Revn_Schedules(l_Due_Indx) := l_Out_Tb_Revn_Schs(l_Due_Indx);
                        l_Due_Indx := l_Out_Tb_Revn_Schs.NEXT(l_Due_Indx);
                     END LOOP;
                  END IF;

               END IF;

               l_Tb_Revision_Schedules.DELETE;
               l_Tb_Disbursement_Schedules.DELETE;
               l_Tb_Payment_Schedules.DELETE;

               l_Out_Tb_Amt_Due.DELETE;
               l_Tb_Amort_Dues.DELETE;
               l_Out_Tb_Disbr_Schs.DELETE;
               l_Out_Tb_Revn_Schs.DELETE;

               l_Tb_Pmnt_Schs.DELETE;

               l_Comp_Indx := p_Account_Rec.g_Tb_Components.NEXT(l_Comp_Indx);

               --log#114 Start
            EXCEPTION
               WHEN Process_Next THEN
                  Dbg('Comp Not Reqd. Move Next');
                  l_Comp_Indx := p_Account_Rec.g_Tb_Components.NEXT(l_Comp_Indx);
            END;
            --log#114 End

         END LOOP;

      END IF;

           -- Log#142 9NT1316 Linking CASA starts
           --Log#161
           IF Pkg_Cldaccdt.Pkgfuncid NOT IN ('CLDVDAMD','MODVDAMD','LEDVDAMD')
           THEN
          l_comp_indxx := p_account_rec.g_tb_components.FIRST;
          WHILE l_comp_indxx IS NOT NULL
          LOOP
          IF p_account_rec.g_tb_components(l_comp_indxx).comp_det.component_type = 'S'
          THEN
                l_sav_comp := p_account_rec.g_tb_components(l_comp_indxx).comp_det.component_name;
                l_comp_indxs := p_account_rec.g_tb_components.FIRST;
                WHILE l_comp_indxs IS NOT NULL
                LOOP

                    IF p_account_rec.g_tb_components(l_comp_indxs).comp_det.component_name = PKG_MAIN_INT
                    THEN
                        l_due_indxs := p_account_rec.g_tb_components(l_comp_indxs).g_tb_amt_due.FIRST;
                        WHILE l_due_indxs IS NOT NULL
                        LOOP
                            IF p_account_rec.g_tb_components(l_comp_indxs).g_tb_amt_due(l_due_indxs).g_amount_due.SCHEDULE_ST_DATE = p_account_rec.account_det.value_date
                            THEN
                                BEGIN
                                     SELECT formula_name
                                     INTO   l_formula_name
                                     FROM   cltm_product_comp_frm_expr
                                     WHERE  product_code = p_account_rec.account_det.product_code
                                     AND    component_name = l_sav_comp;
                                     dbg('formula ' || l_formula_name);
                                EXCEPTION
                                         WHEN OTHERS THEN
                                              dbg('Failed with ' || SQLERRM);
                                END;

                                dbg('amount due ' || p_account_rec.g_tb_components(l_comp_indxs).g_tb_amt_due(l_due_indxs).g_amount_due.AMOUNT_DUE);
                                dbg('LIST_AVG_AMT ' || p_account_rec.g_tb_components(l_comp_indxs).g_tb_amt_due(l_due_indxs).g_amount_due.LIST_AVG_AMT);
                                dbg('LIST_DAYS ' || p_account_rec.g_tb_components(l_comp_indxs).g_tb_amt_due(l_due_indxs).g_amount_due.LIST_DAYS);
                                p_account_rec.g_tb_components(l_sav_comp).g_tb_amt_due(l_due_indxs).g_amount_due.ACCOUNT_NUMBER         := p_account_rec.g_tb_components(l_comp_indxs).g_tb_amt_due(l_due_indxs).g_amount_due.ACCOUNT_NUMBER;
                                p_account_rec.g_tb_components(l_sav_comp).g_tb_amt_due(l_due_indxs).g_amount_due.BRANCH_CODE            := p_account_rec.g_tb_components(l_comp_indxs).g_tb_amt_due(l_due_indxs).g_amount_due.BRANCH_CODE;
                                p_account_rec.g_tb_components(l_sav_comp).g_tb_amt_due(l_due_indxs).g_amount_due.COMPONENT_NAME         := l_sav_comp;
                                p_account_rec.g_tb_components(l_sav_comp).g_tb_amt_due(l_due_indxs).g_amount_due.FORMULA_NAME           := l_formula_name;
                                p_account_rec.g_tb_components(l_sav_comp).g_tb_amt_due(l_due_indxs).g_amount_due.SCHEDULE_TYPE          := p_account_rec.g_tb_components(l_comp_indxs).g_tb_amt_due(l_due_indxs).g_amount_due.SCHEDULE_TYPE;
                                p_account_rec.g_tb_components(l_sav_comp).g_tb_amt_due(l_due_indxs).g_amount_due.SCHEDULE_ST_DATE       := p_account_rec.g_tb_components(l_comp_indxs).g_tb_amt_due(l_due_indxs).g_amount_due.SCHEDULE_ST_DATE;
                                p_account_rec.g_tb_components(l_sav_comp).g_tb_amt_due(l_due_indxs).g_amount_due.SCHEDULE_DUE_DATE      := p_account_rec.g_tb_components(l_comp_indxs).g_tb_amt_due(l_due_indxs).g_amount_due.SCHEDULE_DUE_DATE;
                                p_account_rec.g_tb_components(l_sav_comp).g_tb_amt_due(l_due_indxs).g_amount_due.GRACE_DAYS             := p_account_rec.g_tb_components(l_comp_indxs).g_tb_amt_due(l_due_indxs).g_amount_due.GRACE_DAYS;
                                p_account_rec.g_tb_components(l_sav_comp).g_tb_amt_due(l_due_indxs).g_amount_due.ORIG_AMOUNT_DUE        := p_account_rec.g_tb_components(l_comp_indxs).g_tb_amt_due(l_due_indxs).g_amount_due.ORIG_AMOUNT_DUE;
                                p_account_rec.g_tb_components(l_sav_comp).g_tb_amt_due(l_due_indxs).g_amount_due.AMOUNT_DUE             := p_account_rec.g_tb_components(l_comp_indxs).g_tb_amt_due(l_due_indxs).g_amount_due.AMOUNT_DUE;
                                p_account_rec.g_tb_components(l_sav_comp).g_tb_amt_due(l_due_indxs).g_amount_due.ADJ_AMOUNT             := p_account_rec.g_tb_components(l_comp_indxs).g_tb_amt_due(l_due_indxs).g_amount_due.ADJ_AMOUNT;
                                p_account_rec.g_tb_components(l_sav_comp).g_tb_amt_due(l_due_indxs).g_amount_due.AMOUNT_SETTLED         := p_account_rec.g_tb_components(l_comp_indxs).g_tb_amt_due(l_due_indxs).g_amount_due.AMOUNT_SETTLED;
                                p_account_rec.g_tb_components(l_sav_comp).g_tb_amt_due(l_due_indxs).g_amount_due.AMOUNT_OVERDUE         := p_account_rec.g_tb_components(l_comp_indxs).g_tb_amt_due(l_due_indxs).g_amount_due.AMOUNT_OVERDUE;
                                p_account_rec.g_tb_components(l_sav_comp).g_tb_amt_due(l_due_indxs).g_amount_due.ACCRUED_AMOUNT         := p_account_rec.g_tb_components(l_comp_indxs).g_tb_amt_due(l_due_indxs).g_amount_due.ACCRUED_AMOUNT;
                                p_account_rec.g_tb_components(l_sav_comp).g_tb_amt_due(l_due_indxs).g_amount_due.SETTLEMENT_CCY         := p_account_rec.g_tb_components(l_comp_indxs).g_tb_amt_due(l_due_indxs).g_amount_due.SETTLEMENT_CCY;
                                p_account_rec.g_tb_components(l_sav_comp).g_tb_amt_due(l_due_indxs).g_amount_due.LCY_EQUIVALENT         := p_account_rec.g_tb_components(l_comp_indxs).g_tb_amt_due(l_due_indxs).g_amount_due.LCY_EQUIVALENT;
                                p_account_rec.g_tb_components(l_sav_comp).g_tb_amt_due(l_due_indxs).g_amount_due.DLY_AVG_AMT            := p_account_rec.g_tb_components(l_comp_indxs).g_tb_amt_due(l_due_indxs).g_amount_due.DLY_AVG_AMT;
                                p_account_rec.g_tb_components(l_sav_comp).g_tb_amt_due(l_due_indxs).g_amount_due.EMI_AMOUNT             := p_account_rec.g_tb_components(l_comp_indxs).g_tb_amt_due(l_due_indxs).g_amount_due.EMI_AMOUNT;
                                p_account_rec.g_tb_components(l_sav_comp).g_tb_amt_due(l_due_indxs).g_amount_due.SCHEDULE_FLAG          := p_account_rec.g_tb_components(l_comp_indxs).g_tb_amt_due(l_due_indxs).g_amount_due.SCHEDULE_FLAG;
                                p_account_rec.g_tb_components(l_sav_comp).g_tb_amt_due(l_due_indxs).g_amount_due.WAIVER_FLAG            := p_account_rec.g_tb_components(l_comp_indxs).g_tb_amt_due(l_due_indxs).g_amount_due.WAIVER_FLAG;
                                p_account_rec.g_tb_components(l_sav_comp).g_tb_amt_due(l_due_indxs).g_amount_due.EVENT_SEQ_NO           := p_account_rec.g_tb_components(l_comp_indxs).g_tb_amt_due(l_due_indxs).g_amount_due.EVENT_SEQ_NO;
                                p_account_rec.g_tb_components(l_sav_comp).g_tb_amt_due(l_due_indxs).g_amount_due.SCHEDULE_LINKAGE       := p_account_rec.g_tb_components(l_comp_indxs).g_tb_amt_due(l_due_indxs).g_amount_due.SCHEDULE_LINKAGE;
                                p_account_rec.g_tb_components(l_sav_comp).g_tb_amt_due(l_due_indxs).g_amount_due.CAPITALIZED            := p_account_rec.g_tb_components(l_comp_indxs).g_tb_amt_due(l_due_indxs).g_amount_due.CAPITALIZED;
                                p_account_rec.g_tb_components(l_sav_comp).g_tb_amt_due(l_due_indxs).g_amount_due.PROCESS_NO             := p_account_rec.g_tb_components(l_comp_indxs).g_tb_amt_due(l_due_indxs).g_amount_due.PROCESS_NO;
                                p_account_rec.g_tb_components(l_sav_comp).g_tb_amt_due(l_due_indxs).g_amount_due.AMOUNT_READJUSTED      := p_account_rec.g_tb_components(l_comp_indxs).g_tb_amt_due(l_due_indxs).g_amount_due.AMOUNT_READJUSTED;
                                p_account_rec.g_tb_components(l_sav_comp).g_tb_amt_due(l_due_indxs).g_amount_due.ADJ_SETTLED            := p_account_rec.g_tb_components(l_comp_indxs).g_tb_amt_due(l_due_indxs).g_amount_due.ADJ_SETTLED;
                                p_account_rec.g_tb_components(l_sav_comp).g_tb_amt_due(l_due_indxs).g_amount_due.SCH_STATUS             := p_account_rec.g_tb_components(l_comp_indxs).g_tb_amt_due(l_due_indxs).g_amount_due.SCH_STATUS;
                                p_account_rec.g_tb_components(l_sav_comp).g_tb_amt_due(l_due_indxs).g_amount_due.ACCOUNT_GL             := p_account_rec.g_tb_components(l_comp_indxs).g_tb_amt_due(l_due_indxs).g_amount_due.ACCOUNT_GL;
                                p_account_rec.g_tb_components(l_sav_comp).g_tb_amt_due(l_due_indxs).g_amount_due.LAST_PMNT_VALUE_DATE   := p_account_rec.g_tb_components(l_comp_indxs).g_tb_amt_due(l_due_indxs).g_amount_due.LAST_PMNT_VALUE_DATE;
                                p_account_rec.g_tb_components(l_sav_comp).g_tb_amt_due(l_due_indxs).g_amount_due.RETRY_START_DATE       := p_account_rec.g_tb_components(l_comp_indxs).g_tb_amt_due(l_due_indxs).g_amount_due.RETRY_START_DATE;
                                p_account_rec.g_tb_components(l_sav_comp).g_tb_amt_due(l_due_indxs).g_amount_due.MORA_INT               := p_account_rec.g_tb_components(l_comp_indxs).g_tb_amt_due(l_due_indxs).g_amount_due.MORA_INT;
                                p_account_rec.g_tb_components(l_sav_comp).g_tb_amt_due(l_due_indxs).g_amount_due.SCHEDULE_NO            := p_account_rec.g_tb_components(l_comp_indxs).g_tb_amt_due(l_due_indxs).g_amount_due.SCHEDULE_NO;
                                p_account_rec.g_tb_components(l_sav_comp).g_tb_amt_due(l_due_indxs).g_amount_due.WRITEOFF_AMT           := p_account_rec.g_tb_components(l_comp_indxs).g_tb_amt_due(l_due_indxs).g_amount_due.WRITEOFF_AMT;
                                p_account_rec.g_tb_components(l_sav_comp).g_tb_amt_due(l_due_indxs).g_amount_due.READJ_SETTLED          := p_account_rec.g_tb_components(l_comp_indxs).g_tb_amt_due(l_due_indxs).g_amount_due.READJ_SETTLED;
                                p_account_rec.g_tb_components(l_sav_comp).g_tb_amt_due(l_due_indxs).g_amount_due.LAST_READJ_XRATE       := p_account_rec.g_tb_components(l_comp_indxs).g_tb_amt_due(l_due_indxs).g_amount_due.LAST_READJ_XRATE;
                                p_account_rec.g_tb_components(l_sav_comp).g_tb_amt_due(l_due_indxs).g_amount_due.SUSP_AMT_DUE           := p_account_rec.g_tb_components(l_comp_indxs).g_tb_amt_due(l_due_indxs).g_amount_due.SUSP_AMT_DUE;
                                p_account_rec.g_tb_components(l_sav_comp).g_tb_amt_due(l_due_indxs).g_amount_due.SUSP_AMT_SETTLED       := p_account_rec.g_tb_components(l_comp_indxs).g_tb_amt_due(l_due_indxs).g_amount_due.SUSP_AMT_SETTLED;
                                p_account_rec.g_tb_components(l_sav_comp).g_tb_amt_due(l_due_indxs).g_amount_due.SUSP_AMT_LCY           := p_account_rec.g_tb_components(l_comp_indxs).g_tb_amt_due(l_due_indxs).g_amount_due.SUSP_AMT_LCY;
                                p_account_rec.g_tb_components(l_sav_comp).g_tb_amt_due(l_due_indxs).g_amount_due.SUSP_READ_AMT          := p_account_rec.g_tb_components(l_comp_indxs).g_tb_amt_due(l_due_indxs).g_amount_due.SUSP_READ_AMT;
                                p_account_rec.g_tb_components(l_sav_comp).g_tb_amt_due(l_due_indxs).g_amount_due.SUSP_READ_SETTLED      := p_account_rec.g_tb_components(l_comp_indxs).g_tb_amt_due(l_due_indxs).g_amount_due.SUSP_READ_SETTLED;
                                p_account_rec.g_tb_components(l_sav_comp).g_tb_amt_due(l_due_indxs).g_amount_due.LAST_SUSP_XRATE        := p_account_rec.g_tb_components(l_comp_indxs).g_tb_amt_due(l_due_indxs).g_amount_due.LAST_SUSP_XRATE;
                                p_account_rec.g_tb_components(l_sav_comp).g_tb_amt_due(l_due_indxs).g_amount_due.AMOUNT_WAIVED          := p_account_rec.g_tb_components(l_comp_indxs).g_tb_amt_due(l_due_indxs).g_amount_due.AMOUNT_WAIVED;
                                p_account_rec.g_tb_components(l_sav_comp).g_tb_amt_due(l_due_indxs).g_amount_due.IRR_APPLICABLE         := p_account_rec.g_tb_components(l_comp_indxs).g_tb_amt_due(l_due_indxs).g_amount_due.IRR_APPLICABLE;
                                p_account_rec.g_tb_components(l_sav_comp).g_tb_amt_due(l_due_indxs).g_amount_due.LIST_DAYS              := p_account_rec.g_tb_components(l_comp_indxs).g_tb_amt_due(l_due_indxs).g_amount_due.LIST_DAYS;
                                p_account_rec.g_tb_components(l_sav_comp).g_tb_amt_due(l_due_indxs).g_amount_due.LIST_AVG_AMT           := p_account_rec.g_tb_components(l_comp_indxs).g_tb_amt_due(l_due_indxs).g_amount_due.LIST_AVG_AMT;

                            END IF;
                            l_due_indxs := p_account_rec.g_tb_components(l_comp_indxs).g_tb_amt_due.NEXT(l_due_indxs);
                        END LOOP;
                    END IF;
                    l_comp_indxs := p_account_rec.g_tb_components.NEXT(l_comp_indxs);
                END LOOP;
          END IF;
          l_comp_indxx := p_account_rec.g_tb_components.NEXT(l_comp_indxx);
          END LOOP;
          END IF; --Log#161
          -- Log#142 9NT1316 Linking CASA ends

        dbg('returning from fn_create_schedule');
      --just for debug...should be removed...
      -- log#112 Retro - starts  AVoid looping
      /*
              dbg('****************************************************');
              l_comp_indx := p_account_rec.g_tb_components.FIRST;
              WHILE l_comp_indx IS NOT NULL
              LOOP
                  l_indx     := p_ACcount_rec.g_tb_components(l_comp_indx).g_tb_comp_sch.FIRST;
                  WHILE l_indx IS NOT NULL
                  LOOP
                      dbg('account no     ---->'||p_account_rec.g_tb_components(l_comp_indx).g_tb_comp_sch(l_indx).g_account_comp_sch.account_number);
                      dbg('component name ---->'||p_account_rec.g_tb_components(l_comp_indx).g_tb_comp_sch(l_indx).g_account_comp_sch.component_name);
                      dbg('schedule type  ---->'||p_account_rec.g_tb_components(l_comp_indx).g_tb_comp_sch(l_indx).g_account_comp_sch.schedule_type);
                      dbg('sch start date ---->'||p_account_rec.g_tb_components(l_comp_indx).g_tb_comp_sch(l_indx).g_account_comp_sch.sch_start_date);
                      dbg('first due date ---->'||p_account_rec.g_tb_components(l_comp_indx).g_tb_comp_sch(l_indx).g_account_comp_sch.first_due_date);
                      dbg('sch end date   ---->'||p_account_rec.g_tb_components(l_comp_indx).g_tb_comp_sch(l_indx).g_account_comp_sch.sch_end_date);
                      dbg('no of schedules---->'||p_account_rec.g_tb_components(l_comp_indx).g_tb_comp_sch(l_indx).g_account_comp_sch.no_of_schedules);
                      dbg('frequency      ---->'||p_account_rec.g_tb_components(l_comp_indx).g_tb_comp_sch(l_indx).g_account_comp_sch.frequency);
                      dbg('unit           ---->'||p_account_rec.g_tb_components(l_comp_indx).g_tb_comp_sch(l_indx).g_account_comp_sch.unit);
                      dbg('amount         ---->'||p_account_rec.g_tb_components(l_comp_indx).g_tb_comp_sch(l_indx).g_account_comp_sch.amount);
                      dbg('');
                      dbg('');
                      l_indx := p_ACcount_rec.g_tb_components(l_comp_indx).g_tb_comp_sch.NEXT(l_indx);
                  END LOOP;
                  l_comp_indx := p_account_rec.g_tb_components.NEXT(l_comp_indx);
              END LOOP;
              dbg('amount dues');
              l_comp_indx := p_account_rec.g_tb_components.FIRST;
              WHILE l_comp_indx IS NOT NULL
              LOOP
                  l_due_indx := p_ACcount_rec.g_tb_components(l_comp_indx).g_tb_amt_due.FIRST;
                  WHILE l_due_indx IS NOT NULL
                  LOOP
                      dbg('index is           ---->'||l_due_indx);

                      dbg('component name      ---->'||p_account_rec.g_tb_components(l_comp_indx).g_tb_amt_due(l_due_indx).g_amount_due.component_name);
                      dbg('schedule type       ---->'||p_account_rec.g_tb_components(l_comp_indx).g_tb_amt_due(l_due_indx).g_amount_due.schedule_type);
                      dbg('schedule start date ---->'||p_account_rec.g_tb_components(l_comp_indx).g_tb_amt_due(l_due_indx).g_amount_due.schedule_st_date);
                      dbg('schedule due date   ---->'||p_account_rec.g_tb_components(l_comp_indx).g_tb_amt_due(l_due_indx).g_amount_due.schedule_due_date);
                      dbg('schedule linkage    ---->'||p_account_rec.g_tb_components(l_comp_indx).g_tb_amt_due(l_due_indx).g_amount_due.schedule_linkage);
                      dbg('amount_due          ---->'||p_account_rec.g_tb_components(l_comp_indx).g_tb_amt_due(l_due_indx).g_amount_due.amount_due);
                      dbg('');

                      l_due_indx := p_ACcount_rec.g_tb_components(l_comp_indx).g_tb_amt_due.NEXT(l_due_indx);
                  END LOOP;
                   l_comp_indx := p_account_rec.g_tb_components.NEXT(l_comp_indx);
              END LOOP;
              dbg('Disbursment schedules');
              l_comp_indx := p_account_rec.g_tb_components.FIRST;
              WHILE l_comp_indx IS NOT NULL
              LOOP
                  l_due_indx := p_ACcount_rec.g_tb_components(l_comp_indx).g_tb_disbr_schedules.FIRST;
                  WHILE l_due_indx IS NOT NULL
                  LOOP
                      dbg('component name      ---->'||p_account_rec.g_tb_components(l_comp_indx).g_tb_disbr_schedules(l_due_indx).g_disbr_sch.component_name);
                      dbg('schedule start date ---->'||p_account_rec.g_tb_components(l_comp_indx).g_tb_disbr_schedules(l_due_indx).g_disbr_sch.schedule_st_date);
                      dbg('schedule due date   ---->'||p_account_rec.g_tb_components(l_comp_indx).g_tb_disbr_schedules(l_due_indx).g_disbr_sch.schedule_due_date);
                      dbg('schedule linkage    ---->'||p_account_rec.g_tb_components(l_comp_indx).g_tb_disbr_schedules(l_due_indx).g_disbr_sch.schedule_linkage);
                      dbg('amount_to_disbr     ---->'||p_account_rec.g_tb_components(l_comp_indx).g_tb_disbr_schedules(l_due_indx).g_disbr_sch.amount_to_disbr);
                      dbg('');

                      l_due_indx := p_ACcount_rec.g_tb_components(l_comp_indx).g_tb_disbr_schedules.NEXT(l_due_indx);
                  END LOOP;
                   l_comp_indx := p_account_rec.g_tb_components.NEXT(l_comp_indx);
              END LOOP;
              dbg('Revision schedules ');
              l_comp_indx := p_account_rec.g_tb_components.FIRST;
              WHILE l_comp_indx IS NOT NULL
              LOOP
                  l_due_indx := p_ACcount_rec.g_tb_components(l_comp_indx).g_tb_revn_schedules.FIRST;
                  WHILE l_due_indx IS NOT NULL
                  LOOP
                      dbg('component name      ---->'||p_account_rec.g_tb_components(l_comp_indx).g_tb_revn_schedules(l_due_indx).g_revn_schedules.component_name);
                      dbg('schedule start date ---->'||p_account_rec.g_tb_components(l_comp_indx).g_tb_revn_schedules(l_due_indx).g_revn_schedules.schedule_st_date);
                      dbg('schedule due date   ---->'||p_account_rec.g_tb_components(l_comp_indx).g_tb_revn_schedules(l_due_indx).g_revn_schedules.schedule_due_date);
                      dbg('schedule linkage    ---->'||p_account_rec.g_tb_components(l_comp_indx).g_tb_revn_schedules(l_due_indx).g_revn_schedules.schedule_linkage);
                      dbg('applied_flag        ---->'||p_account_rec.g_tb_components(l_comp_indx).g_tb_revn_schedules(l_due_indx).g_revn_schedules.applied_flag);
                      dbg('');
                      l_due_indx := p_ACcount_rec.g_tb_components(l_comp_indx).g_tb_revn_schedules.NEXT(l_due_indx);
                  END LOOP;
                   l_comp_indx := p_account_rec.g_tb_components.NEXT(l_comp_indx);
              END LOOP;
              dbg('****************************************************');
              ---just for debug should be removed.....
      */
      -- Log#112 Retro till here
      --START Prasanna/Mourougan FCC-CL EURO BANK SFR#AAL013-02. 19-DEC-2005
      IF l_Tb_Amount_Accrued.COUNT > 0 THEN
         IF NOT Fn_Apply_Amt_Accrued(p_Account_Rec
                                    ,p_Effective_Date
                                    ,l_Tb_Amount_Accrued
                                    ,p_Err_Code
                                    ,p_Err_Param) THEN
            l_Tb_Amount_Accrued.DELETE;
            RETURN FALSE;
         END IF;
      END IF;

      l_Tb_Amount_Accrued.DELETE;
      --END Prasanna/Mourougan FCC-CL EURO BANK SFR#AAL013-02. 19-DEC-2005

      RETURN TRUE;
   EXCEPTION
      WHEN OTHERS THEN

         --START Prasanna/Mourougan FCC-CL EURO BANK SFR#AAL013-02. 19-DEC-2005
         l_Tb_Amount_Accrued.DELETE;
         --END Prasanna/Mourougan FCC-CL EURO BANK SFR#AAL013-02. 19-DEC-2005

         l_Tb_Revision_Schedules.DELETE;
         l_Tb_Payment_Schedules.DELETE;
         l_Tb_Disbursement_Schedules.DELETE;

         l_Out_Tb_Amt_Due.DELETE;
         l_Tb_Amort_Dues.DELETE;
         l_Out_Tb_Disbr_Schs.DELETE;
         l_Out_Tb_Revn_Schs.DELETE;
         l_Tb_Pmnt_Schs.DELETE;

         Clpkss_Logger.Pr_Log_Exception('');

         p_Err_Code  := 'CL-SCH036;';
         p_Err_Param := 'fn_create_schedules~;';
         Ovpkss.Pr_Appendtbl(p_Err_Code, p_Err_Param);

         Dbg('bombed in fn_create_schedule with ' || SQLERRM);

         RETURN FALSE;
   END Fn_Gen_Create_Schedule;

   FUNCTION Fn_Validate_Schedules(p_Account_Rec IN OUT NOCOPY Clpkss_Object.Ty_Rec_Account
                                 ,p_Action_Code IN VARCHAR2
                                 ,p_Err_Code    IN OUT Ertbs_Msgs.Err_Code%TYPE
                                 ,p_Err_Param   IN OUT Ertbs_Msgs.Message%TYPE)
      RETURN BOOLEAN IS
   BEGIN
      IF NOT Clpkss_Stream_Schedules.Fn_Pre_Validate_Schedules(p_Account_Rec
                                                              ,p_Action_Code
                                                              ,p_Err_Code
                                                              ,p_Err_Param) THEN
         RETURN FALSE;
      END IF;

      IF Clpkss_Stream_Schedules.Fn_Ovrdn_Validate_Schedules THEN
         IF NOT Clpkss_Stream_Schedules.Fn_Validate_Schedules(p_Account_Rec
                                                             ,p_Action_Code
                                                             ,p_Err_Code
                                                             ,p_Err_Param) THEN
            RETURN FALSE;
         END IF;
      ELSE
         IF NOT Fn_Gen_Validate_Schedules(p_Account_Rec
                                         ,p_Action_Code
                                         ,p_Err_Code
                                         ,p_Err_Param) THEN
            RETURN FALSE;
         END IF;
      END IF;
      IF NOT Clpkss_Stream_Schedules.Fn_Post_Validate_Schedules(p_Account_Rec
                                                               ,p_Action_Code
                                                               ,p_Err_Code
                                                               ,p_Err_Param) THEN
         RETURN FALSE;
      END IF;

      RETURN TRUE;
   EXCEPTION
      WHEN OTHERS THEN
         Clpkss_Logger.Pr_Log_Exception('');

         Debug.Pr_Debug('**'
                       ,'In When others of function fn_validate_schedules - ' || SQLERRM);
         p_Err_Code  := 'CL-SCH036;';
         p_Err_Param := 'fn_validate_schedules~;';
         Ovpkss.Pr_Appendtbl(p_Err_Code, p_Err_Param);
         RETURN FALSE;

   END Fn_Validate_Schedules;

   FUNCTION Fn_Gen_Validate_Schedules(p_Account_Rec IN OUT NOCOPY Clpkss_Object.Ty_Rec_Account
                                     ,p_Action_Code IN VARCHAR2
                                     ,p_Err_Code    IN OUT Ertbs_Msgs.Err_Code%TYPE
                                     ,p_Err_Param   IN OUT Ertbs_Msgs.Message%TYPE)
      RETURN BOOLEAN IS

      -- log#114 Start Performance Tuning
      Process_Next EXCEPTION;
      l_Tmp_Tb_Frm_Names        Clpkss_Util.Ty_Tb_Frm_Names;
      l_Tmp_Tb_Account_Comp_Sch Clpkss_Object.Ty_Tb_Account_Comp_Sch;
      -- log#114 End
      l_Tb_Schedule_Date    Clpks_Schedules.Ty_Schedule_Date;
      l_Tb_Account_Comp_Sch Clpkss_Object.Ty_Tb_Account_Comp_Sch;
      l_Account_No          Cltbs_Account_Master.Account_Number%TYPE;
      l_Product             Cltbs_Account_Master.Product_Code%TYPE;
      l_Value_Date          Cltbs_Account_Master.Value_Date%TYPE;
      l_Maturity_Date       Cltbs_Account_Master.Maturity_Date%TYPE;
      l_Currency            Cltbs_Account_Master.Currency%TYPE;
      l_Prev_End_Date       Cltbs_Account_Master.Maturity_Date%TYPE;
      l_End_Date            Cltbs_Account_Master.Maturity_Date%TYPE;
      l_Bullet_Date         Cltbs_Account_Master.Maturity_Date%TYPE;
      --l_amortise_st_date    cltbs_account_master.maturity_date%TYPE;
      --l_amortise_end_date   cltbs_account_master.maturity_date%TYPE;
      l_Branch_Code Cltbs_Account_Master.Branch_Code%TYPE;
      --Sudharshan : Mar 18,2005
      --l_ignore_holiday      cltbs_account_master.ignore_holidays%TYPE;
      l_Ignore_Holiday Cltms_Product.Ignore_Holidays%TYPE;
      --Sudharshan : Mar 18,2005
      l_Forward_Backward  Cltms_Product.Schedule_Movement%TYPE;
      l_Move_Across_Month Cltms_Product.Move_Across_Month%TYPE;
      l_Cascade_Movement  Cltms_Product.Cascade_Schedules%TYPE;
      l_Amount_Financed   Cltbs_Account_Master.Amount_Financed%TYPE;
      l_Cur_Amount        Cltbs_Account_Master.Amount_Financed%TYPE;
      l_Total_Amount      Cltbs_Account_Master.Amount_Financed%TYPE;
      l_Bal_Amount        Cltbs_Account_Master.Amount_Financed%TYPE;
      l_Calc_Amount       Cltbs_Account_Master.Amount_Financed%TYPE;
      l_No_Of_Schedules   Cltbs_Account_Comp_Sch.No_Of_Schedules%TYPE;
      l_Prev_Sch_Type     Cltbs_Account_Comp_Sch.Schedule_Type%TYPE;
      l_Formula_Name      Cltbs_Account_Comp_Sch.Formula_Name%TYPE;
      l_Payment_Mode      Cltbs_Account_Comp_Sch.Payment_Mode%TYPE;
      l_Pmnt_Prod_Ac      Cltbs_Account_Comp_Sch.Pmnt_Prod_Ac%TYPE;
      l_Payment_Details   Cltbs_Account_Comp_Sch.Payment_Details%TYPE;
      l_Ben_Account       Cltbs_Account_Comp_Sch.Ben_Account%TYPE;
      l_Ben_Bank          Cltbs_Account_Comp_Sch.Ben_Bank%TYPE;
      l_Ben_Name          Cltbs_Account_Comp_Sch.Ben_Name%TYPE;
      l_Bullet_Reqd       BOOLEAN;
      l_Cur_Rec           VARCHAR2(100);
      l_Bullet_Indx       VARCHAR2(100);
	  -- Log#162 Changes for 11.1 Dev (Payment in Advance)  starts
	  l_Prev_Sch_Freq_Type  VARCHAR2(1);
      l_Prev_Sch_Frequency  NUMBER;
      l_Prev_Sch_DueDatesOn NUMBER(2);
      l_Prev_Sch_No_Of_Schedules NUMBER;
      l_Product_Code      Cltbs_Account_Master.Product_Code%TYPE;
      l_bool1 BOOLEAN;
	  --Log#162 Changes for 11.1 Dev (Payment in Advance) ends
      --l_amort_indx          VARCHAR2(100);
      l_Comp_Indx          Cltbs_Account_Comp_Sch.Component_Name%TYPE;
      l_Comp_Sch_Indx      VARCHAR2(100);
      l_Comp_Sch_Rec       Clpkss_Object.Ty_Rec_Account_Comp_Sch;
      l_Comp_Rec           Cltbs_Account_Components%ROWTYPE;
      l_Tb_Comp_Sch        Clpkss_Object.Ty_Tb_Account_Comp_Sch;
      l_Sch_Start_Date     Cltbs_Account_Comp_Sch.Sch_Start_Date%TYPE;
      l_Bullet_Start_Date  Cltbs_Account_Comp_Sch.Sch_Start_Date%TYPE;
      l_First_Due_Date     Cltbs_Account_Comp_Sch.First_Due_Date%TYPE;
      l_Flg_Amort_Exists   BOOLEAN;
      l_Tb_Frm_Names       Clpkss_Util.Ty_Tb_Frm_Names;
      l_Main_Int_Comp      Cltbs_Account_Comp_Sch.Component_Name%TYPE;
      l_Tb_Amort_Comp_Sch  Clpkss_Object.Ty_Tb_Account_Comp_Sch;
      l_Mat_Date_Indx      VARCHAR2(100);
      l_Is_Last_Form_Amort BOOLEAN;
      --l_prin_start_dt       cltbs_account_comp_sch.sch_start_date%TYPE;
      --l_prin_end_dt         cltbs_account_comp_sch.sch_end_date%TYPE;
      l_Capitalized Cltbs_Account_Comp_Sch.Capitalized%TYPE;
      l_Waiver_Flag Cltbs_Account_Comp_Sch.Waiver_Flag%TYPE;
      ---Log#64 Start
      l_Compound_Days   Cltbs_Account_Comp_Sch.Compound_Days%TYPE;
      l_Compound_Months Cltbs_Account_Comp_Sch.Compound_Months%TYPE;
      l_Compound_Years  Cltbs_Account_Comp_Sch.Compound_Years%TYPE;
      ---Log#64 End
      --Log#66 Start
      l_Emi_Amount Cltbs_Account_Comp_Sch.Emi_Amount%TYPE;
      --Log#66 End
      l_No_Of_Disb_Schs        PLS_INTEGER := 0;
      l_No_Of_Revn_Schs        PLS_INTEGER;
      l_Prod_Comp_Row          Cltms_Product_Components%ROWTYPE;
      l_Indx                   PLS_INTEGER;
      l_Start_Sch_Calc_From    Cltbs_Account_Comp_Sch.Sch_Start_Date%TYPE;
      l_Disbr_Mode             Cltms_Product.Disbursement_Mode%TYPE;
      l_Tb_For_Disbr           g_Ty_Tb_For_Disbr;
      l_Total_Amt_Disbr        Cltbs_Account_Master.Amount_Financed%TYPE := 0;
      l_Total_Undsbr_Schs      Cltbs_Account_Comp_Sch.No_Of_Schedules%TYPE := 0;
      l_Disbr_Sch_Rnd_Amt      Cltbs_Account_Master.Amount_Financed%TYPE := 0;
      l_Disbr_Sch_Amt          Cltbs_Account_Master.Amount_Financed%TYPE := 0;
      l_Disb_Indx              PLS_INTEGER;
      l_Result                 VARCHAR2(1);
      l_Bull_Reqd_For_Sec_Comp BOOLEAN := FALSE;
      l_Tb_Amort_Pairs         Clpkss_Cache.Ty_Tb_Amort_Pairs;
      --->>Sudharshan :Mar 18,2005
      l_Rec_Prod Cltm_Product%ROWTYPE;
      --->>Sudharshan :Mar 18,2005
      l_Frst_Dsbr_Date    DATE;
      l_Holiday           VARCHAR2(1); --Santosh 17-Aug-2006. Serbia UAT support.
      l_Next_Working_Date DATE; -- Log#128
      l_Cnt_Dsb_Sch       PLS_INTEGER := 0; -- log#119 changes
	  l_old_first_due         date; -- Log#163

	  l_tmp_mat_date		  DATE;--Log#179.

      FUNCTION Fn_Validate_Amort_Pairs RETURN BOOLEAN IS
         l_Frm               Cltbs_Account_Comp_Sch.Formula_Name%TYPE;
         l_Tb_Prin_Sch       Clpkss_Object.Ty_Tb_Account_Comp_Sch;
         l_Tb_Comp_Sch       Clpkss_Object.Ty_Tb_Account_Comp_Sch;
         l_Prin_Indx         VARCHAR2(100);
         l_Prin_Start_Dt     Cltbs_Account_Comp_Sch.Sch_Start_Date%TYPE;
         l_Prin_End_Dt       Cltbs_Account_Comp_Sch.Sch_End_Date%TYPE;
         l_Prin_Comp         Cltbs_Account_Schedules.Component_Name%TYPE;
         l_Amortise_St_Date  Cltbs_Account_Master.Maturity_Date%TYPE;
         l_Amortise_End_Date Cltbs_Account_Master.Maturity_Date%TYPE;
         l_Comp_Sch_Indx     VARCHAR2(100);
      BEGIN
         Dbg('will validate amort pairs now');
         l_Comp_Indx := p_Account_Rec.g_Tb_Components.FIRST;

         WHILE l_Comp_Indx IS NOT NULL LOOP
            Dbg('Name and Type = ' || p_Account_Rec.g_Tb_Components(l_Comp_Indx)
                .Comp_Det.Component_Type || ' *AND* ' ||
                p_Account_Rec.g_Tb_Components(l_Comp_Indx).Comp_Det.Component_Name);

            IF Nvl(p_Account_Rec.g_Tb_Components(l_Comp_Indx).Comp_Det.Component_Type
                  ,'*') = 'I' THEN
               /*
               --29.09.2005 Log#67 EMI Changes Start
               IF p_account_rec.g_tb_components(l_comp_indx).g_tb_comp_sch.emi_amount IS NOT NULL
               THEN
                           IF NOT clpkss_util.fn_round_emi(p_account_rec.g_tb_components(l_comp_indx).g_tb_comp_sch.emi_amount,p_account_rec.account_det.product_code,p_account_rec.account_det.currency)
                           THEN
                                     dbg('Failed in rounding emi in fn_validate_amort_pairs for account for :'||p_account_rec.account_det.product_code||'~'||p_account_rec.account_det.emi_amount);
                                     RETURN FALSE;
                    END IF;
               END IF;
               --29.09.2005 Log#67 EMI Changes End
               */

               l_Tb_Comp_Sch := p_Account_Rec.g_Tb_Components(l_Comp_Indx).g_Tb_Comp_Sch;

               l_Comp_Sch_Indx := l_Tb_Comp_Sch.FIRST;

               WHILE l_Comp_Sch_Indx IS NOT NULL LOOP
                  l_Tb_Prin_Sch.DELETE;

                  IF l_Tb_Comp_Sch(l_Comp_Sch_Indx)
                  .g_Account_Comp_Sch.Schedule_Type = 'P' THEN
                     l_Frm := l_Tb_Comp_Sch(l_Comp_Sch_Indx)
                             .g_Account_Comp_Sch.Formula_Name;

                     --log#114 Start
                     /*IF l_tb_frm_names.EXISTS(l_frm)
                     THEN*/
                     BEGIN
                        l_Tmp_Tb_Frm_Names(1) := l_Tb_Frm_Names(l_Frm);
                        --log#114 End
                        l_Prin_Comp := l_Tb_Amort_Pairs(l_Product || l_Comp_Indx || l_Frm);

                        IF l_Prin_Comp IS NULL THEN
                           RETURN FALSE;
                        ELSE
                           Dbg('l_prin_comp is ' || l_Prin_Comp);

                           l_Amortise_St_Date  := l_Tb_Comp_Sch(l_Comp_Sch_Indx)
                                                 .g_Account_Comp_Sch.Sch_Start_Date;
                           l_Amortise_End_Date := l_Tb_Comp_Sch(l_Comp_Sch_Indx)
                                                 .g_Account_Comp_Sch.Sch_End_Date;

                           Dbg(l_Amortise_St_Date || '~~' || l_Amortise_End_Date);

                           l_Tb_Prin_Sch := p_Account_Rec.g_Tb_Components(l_Prin_Comp)
                                           .g_Tb_Comp_Sch;

                           IF l_Tb_Prin_Sch.COUNT > 0 THEN
                              l_Prin_Indx := l_Tb_Prin_Sch.FIRST;

                              WHILE l_Prin_Indx IS NOT NULL LOOP
                                 IF l_Tb_Prin_Sch(l_Prin_Indx)
                                 .g_Account_Comp_Sch.Schedule_Type = 'P' THEN

                                    l_Prin_Start_Dt := l_Tb_Prin_Sch(l_Prin_Indx)
                                                      .g_Account_Comp_Sch.Sch_Start_Date;
                                    l_Prin_End_Dt   := l_Tb_Prin_Sch(l_Prin_Indx)
                                                      .g_Account_Comp_Sch.Sch_End_Date;
                                    Dbg(l_Prin_Start_Dt || '~~' || l_Prin_End_Dt);
                                    IF l_Amortise_St_Date >= l_Prin_Start_Dt AND
                                       l_Amortise_St_Date <= l_Prin_End_Dt OR
                                       l_Amortise_End_Date >= l_Prin_Start_Dt AND
                                       l_Amortise_End_Date <= l_Prin_End_Dt THEN
                                       Dbg('Cannot have amortization and principal Repayment in the same schedule period');
                                       l_Tb_Comp_Sch.DELETE;
                                       l_Tb_Prin_Sch.DELETE;
                                       --check the error code
                                       p_Err_Code := 'CL-SCH023;';
                                       Ovpkss.Pr_Appendtbl(p_Err_Code, '');
                                       RETURN FALSE;
                                    END IF;
                                 END IF;
                                 l_Prin_Indx := l_Tb_Prin_Sch.NEXT(l_Prin_Indx);
                              END LOOP;
                           END IF;
                        END IF; --IF l_prin_comp IS NULL
                        --log#114 Start
                        --END IF;--IF l_tb_frm_names.EXISTS(l_frm_name)
                     EXCEPTION
                        WHEN No_Data_Found THEN
                           NULL;
                     END;
                     --log#114 End
                  END IF; --IF l_tb_comp_sch(l_comp_sch_indx).g_account_comp_sch.schedule_type = 'P'
                  l_Comp_Sch_Indx := l_Tb_Comp_Sch.NEXT(l_Comp_Sch_Indx);
               END LOOP;
            END IF;
            l_Comp_Indx := p_Account_Rec.g_Tb_Components.NEXT(l_Comp_Indx);
         END LOOP;

         l_Tb_Comp_Sch.DELETE;
         l_Tb_Prin_Sch.DELETE;

         RETURN TRUE;
      EXCEPTION
         WHEN OTHERS THEN
            l_Tb_Comp_Sch.DELETE;
            l_Tb_Prin_Sch.DELETE;
            RETURN FALSE;
      END Fn_Validate_Amort_Pairs;

   BEGIN
      Dbg('Start of the function fn_validate_schedules');
      Dbg('action code came in as ' || p_Action_Code);

      --MTR1 SFR#136
      g_Tb_Acc_Hol_Perds := p_Account_Rec.g_Hol_Perds;

      IF NOT Fn_Clear_Deleted_Schedules(p_Account_Rec, p_Err_Code, p_Err_Param) THEN
         RETURN FALSE;
      END IF;

      l_Account_No      := p_Account_Rec.Account_Det.Account_Number;
      l_Product         := p_Account_Rec.Account_Det.Product_Code;
      l_Value_Date      := p_Account_Rec.Account_Det.Value_Date;
      l_Maturity_Date   := Nvl(p_Account_Rec.Account_Det.Maturity_Date
                              ,Clpkss_Util.Pkg_Eternity);
      l_Branch_Code     := p_Account_Rec.Account_Det.Branch_Code;
      l_Amount_Financed := p_Account_Rec.Account_Det.Amount_Financed;
      l_Currency        := p_Account_Rec.Account_Det.Currency;
      -------------------------------------------------------->
      --->>Sudharshan
      --l_ignore_holiday    := nvl(p_account_rec.account_det.ignore_holidays,'Y');
      --l_forward_backward  := nvl(p_account_rec.account_det.schedule_movement,'N');
      --l_move_across_month := nvl(p_account_rec.account_det.move_across_month,'Y');
      --l_cascade_movement  := nvl(p_account_rec.account_det.cascade_schedules,'N');

      l_Rec_Prod          := Clpks_Cache.Fn_Product(p_Account_Rec.Account_Det.Product_Code);
      l_Ignore_Holiday    := Nvl(l_Rec_Prod.Ignore_Holidays, 'Y');
      l_Forward_Backward  := Nvl(l_Rec_Prod.Schedule_Movement, 'N');
      l_Move_Across_Month := Nvl(l_Rec_Prod.Move_Across_Month, 'Y');
      l_Cascade_Movement  := Nvl(l_Rec_Prod.Cascade_Schedules, 'N');
      Dbg('**IGNORE**');
      Dbg('l_ignore_holiday--2    := ' || l_Ignore_Holiday);
      --->>Sudharshan
      -------------------------------------------------------->

      l_Mat_Date_Indx := Clpkss_Util.Fn_Hash_Date(l_Maturity_Date, NULL); --dont change this index

      IF NOT Clpkss_Util.Fn_Get_Amortized_Formulae(l_Tb_Frm_Names, l_Product) THEN
         p_Err_Code := 'CL-SCH037;';
         Ovpkss.Pr_Appendtbl(p_Err_Code, '');
         RETURN FALSE;
      END IF;

      IF NOT Clpkss_Cache.Fn_Get_Amort_Pairs(l_Product, l_Tb_Amort_Pairs) THEN
         RETURN FALSE;
      END IF;
      l_Flg_Amort_Exists   := FALSE;
      l_Is_Last_Form_Amort := FALSE;
      l_No_Of_Disb_Schs    := 0;
      l_No_Of_Revn_Schs    := 0;

      --Main Interest Component related Validations

      l_Comp_Indx := p_Account_Rec.g_Tb_Components.FIRST;

      WHILE l_Comp_Indx IS NOT NULL LOOP
         BEGIN
            Dbg('For each Component - ' || p_Account_Rec.g_Tb_Components(l_Comp_Indx)
                .Comp_Det.Component_Name);
            Dbg('Main component flag - ' || p_Account_Rec.g_Tb_Components(l_Comp_Indx)
                .Comp_Det.Main_Component);

            --log#114 Start
            IF Nvl(p_Account_Rec.g_Tb_Components(l_Comp_Indx).Comp_Det.Component_Type
                  ,'*') IN ('H', 'O') THEN
               RAISE Process_Next;
            END IF;
            --log#114 End
            IF Nvl(p_Account_Rec.g_Tb_Components(l_Comp_Indx).Comp_Det.Main_Component
                  ,'N') = 'Y'
              --Start Ravi FCCCL 1.0 Phase-2 IQA Supp SFR #256
               AND p_Account_Rec.g_Tb_Components(l_Comp_Indx).g_Tb_Comp_Sch.COUNT > 0
            --End Ravi FCCCL 1.0 Phase-2 IQA Supp SFR #256
             THEN
               l_Main_Int_Comp := p_Account_Rec.g_Tb_Components(l_Comp_Indx)
                                 .Comp_Det.Component_Name;
               Dbg('Getting the main component as - ' || l_Main_Int_Comp);
               l_Tb_Comp_Sch := p_Account_Rec.g_Tb_Components(l_Comp_Indx).g_Tb_Comp_Sch;
               Dbg('total entries for main int component is ' || l_Tb_Comp_Sch.COUNT);
               l_Comp_Sch_Indx := l_Tb_Comp_Sch.FIRST;
               WHILE l_Comp_Sch_Indx IS NOT NULL LOOP
                  IF l_Tb_Comp_Sch(l_Comp_Sch_Indx)
                  .g_Account_Comp_Sch.Schedule_Type = 'P' AND
                     Nvl(l_Tb_Comp_Sch(l_Comp_Sch_Indx).g_Account_Comp_Sch.Waiver_Flag
                        ,'N') = 'N' THEN
                     --log#114 Start
                     /*
                                 IF l_tb_frm_names.EXISTS(l_tb_comp_sch(l_comp_sch_indx).g_account_comp_sch.formula_name)
                                 THEN
                                     l_flg_amort_exists := TRUE;
                                     l_is_last_form_amort := TRUE;
                                     --MTR1 SFR#98
                                     --FOR DFLT store all amortized component here itself.
                                     --IF p_action_code = 'DFLT'
                                     --THEN
                                     --    l_tb_amort_comp_sch(l_comp_sch_indx).g_account_comp_sch := l_tb_comp_sch(l_comp_sch_indx).g_account_comp_sch;
                                     --END IF;
                                 ELSE
                                     --based on this flag it will be decided whther
                                     --to insert Principal Bullet or not.
                                     l_is_last_form_amort := FALSE;
                                 END IF;
                     */
                     BEGIN
                        l_Tmp_Tb_Frm_Names(1) := l_Tb_Frm_Names(l_Tb_Comp_Sch(l_Comp_Sch_Indx)
                                                                .g_Account_Comp_Sch.Formula_Name);
                        l_Flg_Amort_Exists := TRUE;
                        l_Is_Last_Form_Amort := TRUE;
                     EXCEPTION
                        WHEN No_Data_Found THEN
                           l_Is_Last_Form_Amort := FALSE;
                     END;
                     --log#114
                  ELSIF l_Tb_Comp_Sch(l_Comp_Sch_Indx)
                  .g_Account_Comp_Sch.Schedule_Type = 'R' THEN
                     l_No_Of_Revn_Schs := l_No_Of_Revn_Schs + Nvl(l_Tb_Comp_Sch(l_Comp_Sch_Indx)
                                                                  .g_Account_Comp_Sch.No_Of_Schedules
                                                                 ,0);
                  END IF;

                  l_Comp_Sch_Indx := l_Tb_Comp_Sch.NEXT(l_Comp_Sch_Indx);
               END LOOP;

               --If main comp is Disc/True Disc then Only one disbursement schedule
               --can be defined for the principal in that account
               l_Prod_Comp_Row := Clpkss_Cache.Fn_Product_Components(l_Product
                                                                    ,l_Comp_Indx);

               IF l_Prod_Comp_Row.Formula_Type IN ('3', '4') THEN
                  l_Tb_Comp_Sch := p_Account_Rec.g_Tb_Components(Pkg_Principal)
                                  .g_Tb_Comp_Sch;
                  --Phase II NLS changes
                  l_Comp_Sch_Indx := l_Tb_Comp_Sch.FIRST;
                  WHILE l_Comp_Sch_Indx IS NOT NULL LOOP
                     IF l_Tb_Comp_Sch(l_Comp_Sch_Indx)
                     .g_Account_Comp_Sch.Schedule_Type = 'D' THEN
                        l_No_Of_Disb_Schs := l_No_Of_Disb_Schs +
                                             Nvl(l_Tb_Comp_Sch(l_Comp_Sch_Indx)
                                                 .g_Account_Comp_Sch.No_Of_Schedules
                                                ,0);
                     END IF;
                     l_Comp_Sch_Indx := l_Tb_Comp_Sch.NEXT(l_Comp_Sch_Indx);
                  END LOOP;
                  IF l_No_Of_Disb_Schs > 1 THEN
                     p_Err_Code := 'CL-SCH038;';
                     Ovpkss.Pr_Appendtbl(p_Err_Code, '');
                     RETURN FALSE;
                  END IF;
                  --No rate revision schedules should be allowed for the component that is discounted/true discounted
                  IF l_No_Of_Revn_Schs > 0 THEN
                     p_Err_Code := 'CL-SCH039;';
                     Ovpkss.Pr_Appendtbl(p_Err_Code, '');
                     RETURN FALSE;
                  END IF;

                  --for Capitalization would discounted/true Discounted type Capitalization
                  --is not allowed
                  l_Comp_Sch_Indx := p_Account_Rec.g_Tb_Components(l_Comp_Indx)
                                    .g_Tb_Comp_Sch.FIRST;
                  l_Capitalized   := p_Account_Rec.g_Tb_Components(l_Comp_Indx)
                                    .g_Tb_Comp_Sch(l_Comp_Sch_Indx)
                                    .g_Account_Comp_Sch.Capitalized;
                  IF Nvl(l_Capitalized, 'N') = 'Y' THEN
                     Dbg('sorry..discounted are not supposed to be capitalized');
                     p_Err_Code := 'CL-SCH040;';
                     Ovpkss.Pr_Appendtbl(p_Err_Code, '');
                  END IF;

               END IF;

               EXIT;
            END IF;
            l_Comp_Indx := p_Account_Rec.g_Tb_Components.NEXT(l_Comp_Indx);
         EXCEPTION
            WHEN Process_Next THEN
               Dbg('Comp Not Reqd');
               l_Comp_Indx := p_Account_Rec.g_Tb_Components.NEXT(l_Comp_Indx);
         END;
      END LOOP;

      l_Tb_Comp_Sch.DELETE;

      --MTR SFR#98
      --logic for calculation of schedule dates is not needed in case of of 'DFLT'
      IF p_Action_Code IN ('NEW', 'REDEF', 'VAMI') THEN

         l_Disbr_Mode := Clpkss_Cache.Fn_Product(l_Product).Disbursement_Mode;

         IF Nvl(l_Disbr_Mode, 'A') = 'A' THEN
            IF p_Account_Rec.g_Tb_Components(Pkg_Principal)
            .g_Tb_Disbr_Schedules.FIRST IS NULL THEN
               -- RUBHCFB SFR#I1483 Log#112 STARTS
               p_Err_Code := 'CL-SCH048';
               Ovpkss.Pr_Appendtbl(p_Err_Code, '');
               Debug.Pr_Debug('**'
                             ,'Dibsbursement schedules missing for AUTO disbursement loan');
               Dbg('Dibsbursement schedules missing for AUTO disbursement loan');
               -- RUBHCFB SFR#I1483 Log#112 ENDS

               RETURN FALSE;
            ELSE

               --FCUBS11.1 ITR1 SFR#1875 Starts...
               /*l_Indx           := p_Account_Rec.g_Tb_Components(Pkg_Principal)
                                  .g_Tb_Disbr_Schedules.FIRST;
               l_Frst_Dsbr_Date := p_Account_Rec.g_Tb_Components(Pkg_Principal)
                                  .g_Tb_Disbr_Schedules(l_Indx)
                                  .g_Disbr_Sch.Schedule_Due_Date;*/
               Dbg('CIOUNT :' || p_Account_Rec.g_Tb_Components(Pkg_Principal).g_Tb_Disbr_Schedules.COUNT);
               l_Indx := p_Account_Rec.g_Tb_Components(Pkg_Principal).g_Tb_Disbr_Schedules.FIRST;

               WHILE (l_Indx IS NOT NULL) LOOP
                  IF l_Frst_Dsbr_Date IS NULL THEN
                     l_Frst_Dsbr_Date := p_Account_Rec.g_Tb_Components(Pkg_Principal).g_Tb_Disbr_Schedules(l_Indx).g_Disbr_Sch.Schedule_Due_Date;
                  ELSE
                     IF  p_Account_Rec.g_Tb_Components(Pkg_Principal).g_Tb_Disbr_Schedules(l_Indx).g_Disbr_Sch.Schedule_Due_Date < l_Frst_Dsbr_Date THEN
										    l_Frst_Dsbr_Date := p_Account_Rec.g_Tb_Components(Pkg_Principal).g_Tb_Disbr_Schedules(l_Indx).g_Disbr_Sch.Schedule_Due_Date;
										 END IF;
                  END IF;

                  l_Indx := p_Account_Rec.g_Tb_Components(Pkg_Principal).g_Tb_Disbr_Schedules.NEXT(l_Indx);
               END LOOP;
               Dbg('Minimim Disbursement Date :'||l_Frst_Dsbr_Date);
               --FCUBS11.1 ITR1 SFR#1875 Starts...
            END IF;
         END IF;

         l_Start_Sch_Calc_From := l_Value_Date;

         Dbg('schedules will be caculated from ' || l_Start_Sch_Calc_From);

         IF l_Start_Sch_Calc_From IS NULL THEN
            p_Err_Code := 'CL-SCH024;';
            Ovpkss.Pr_Appendtbl(p_Err_Code, '');
            RETURN FALSE;
         END IF;

         l_Comp_Indx := p_Account_Rec.g_Tb_Components.FIRST;

         Dbg('Entries in components table - ' || p_Account_Rec.g_Tb_Components.COUNT);

         -- This loop is for every component for the account
         WHILE l_Comp_Indx IS NOT NULL LOOP
            Dbg('Processing the component - ' || l_Comp_Indx);

	    dbg('l_Product  ~  l_Comp_Indx' ||  l_Product || ' ~ ' || l_Comp_Indx ) ;
	    l_Prod_Comp_Row := Clpkss_Cache.Fn_Product_Components(l_Product,l_Comp_Indx);

            l_Prev_Sch_Type := NULL;

            l_Comp_Rec := p_Account_Rec.g_Tb_Components(l_Comp_Indx).Comp_Det;

            l_Tb_Comp_Sch := p_Account_Rec.g_Tb_Components(l_Comp_Indx).g_Tb_Comp_Sch;

            l_Comp_Sch_Indx := l_Tb_Comp_Sch.FIRST;

            Dbg('No of schedule entries   - ' || l_Tb_Comp_Sch.COUNT);

            -- This indefinite loop is used to handle the schedules based on schedule type.
            -- Coz a component can have more than one schedule type.
            -- The inner loop will be restricted to process for a schedule type and ones it is over
            -- then the next schedule type will be processed from the outer loop.

            WHILE TRUE LOOP

		dbg(' 1002 ' ) ;
               EXIT WHEN l_Comp_Sch_Indx IS NULL;

               l_Bullet_Reqd   := FALSE;
               l_Bullet_Indx   := NULL;
               l_Bullet_Date   := NULL;
               l_Total_Amount  := NULL;
               l_Prev_End_Date := NULL;
               l_End_Date      := NULL;
               l_Cur_Amount    := 0;
               l_Calc_Amount   := 0;
               --l_calc_amount   := NULL;
               l_Disb_Indx              := 1;
               l_No_Of_Disb_Schs        := 0;
               l_Bull_Reqd_For_Sec_Comp := FALSE;

               l_Comp_Sch_Rec := l_Tb_Comp_Sch(l_Comp_Sch_Indx);

               --START Prasanna FCCCL 1.1 MTR2 SFR#23. 9NT296. 29-Jun-2005
               /* IF l_comp_sch_rec.g_account_comp_sch.schedule_type = 'P' AND
                  l_comp_sch_rec.g_account_comp_sch.component_name = PKG_PRINCIPAL
               --Phase II NLS changes
               THEN
                  --ITR1
                  --IF l_flg_amort_exists = FALSE
                  --THEN
                  -- dbg('flg amort exist is false');
                  -- l_total_amount := l_amount_financed;
                  --ELSE
                  -- dbg('set total amount to null');
                  -- l_total_amount := NULL;
                  --END IF;

                  l_total_amount := l_amount_financed;

                  IF l_flg_amort_exists OR l_disbr_mode = 'M'
                  THEN
                     l_total_amount := NULL;
                  END IF;

               ELSIF l_comp_sch_rec.g_account_comp_sch.schedule_type = 'D' AND */
               IF l_Comp_Sch_Rec.g_Account_Comp_Sch.Component_Name = Pkg_Principal
               --Phase II NLS changes
                THEN
                  IF l_Comp_Sch_Rec.g_Account_Comp_Sch.Schedule_Type = 'D' AND
                     Nvl(p_Action_Code, '*') <> 'VAMI' THEN
                     Dbg('Not Vami and Disbursemetn Schedule');
                     l_Total_Amount := l_Amount_Financed;
                  ELSE
                     Dbg('VAMI or Payment Schedule - Got Rid of All #@@$@#@$ checks during payment');
                     l_Total_Amount := NULL;
                  END IF;

                  /*--MTR1 SFR#98
                  --Disbr amount should not be validated in VAMI b'cos although amount financed
                  --changes(In case of Principal change) dibursment amounts dont change in schedules.

                  IF p_action_code = 'VAMI' THEN
                     l_total_amount := NULL;
                  END IF; */
               END IF;
               --END Prasanna FCCCL 1.1 MTR2 SFR#23. 9NT296. 29-Jun-2005

               -- Looping for the component and schedule type combination

               WHILE l_Comp_Sch_Indx IS NOT NULL LOOP
			 l_old_first_due := null ; -- Log#163
                  l_Comp_Sch_Rec := l_Tb_Comp_Sch(l_Comp_Sch_Indx);
		dbg(' 1001 EMI_AS_PERCENTAGE_SALARY '||l_Comp_Sch_Rec.g_Account_Comp_Sch.EMI_AS_PERCENTAGE_SALARY ) ;

                  --Primary Validations
                  IF l_Comp_Sch_Rec.g_Account_Comp_Sch.Schedule_Type IS NULL OR
                     l_Comp_Sch_Rec.g_Account_Comp_Sch.First_Due_Date IS NULL OR
                     l_Comp_Sch_Rec.g_Account_Comp_Sch.Frequency IS NULL OR
                     l_Comp_Sch_Rec.g_Account_Comp_Sch.Unit IS NULL OR
                     l_Comp_Sch_Rec.g_Account_Comp_Sch.No_Of_Schedules IS NULL THEN
                     Dbg('Schedule definitions are not proper..will return false');
                     --START log#70 Prasanna/Debendra FCC-CL 1.1.3 ITR2 SFR#87. 17-Nov-2005.
                     --p_err_code := 'CLSCH-042;';
                     p_Err_Code := 'CL-SCH042;';
                     --END log#70 Prasanna/Debendra FCC-CL 1.1.3 ITR2 SFR#87. 17-Nov-2005.
                     p_Err_Param := l_Comp_Sch_Rec.g_Account_Comp_Sch.Component_Name || '~;';
                     Ovpkss.Pr_Appendtbl(p_Err_Code, p_Err_Param);
                     RETURN FALSE;
                  END IF;
                  --Log#129 Starts
                  -- Log#147 ST
                  /*IF NOT (l_Prod_Comp_Row.Formula_Type IN ('3', '4' ,'9','A') AND --added 9,0 Log#140 changes for Advance and arrears schedules -- Log#144 A
                      l_Comp_Indx = l_Main_Int_Comp)
                      OR (l_Rec_Prod.LEASE_TYPE IN('F','O') AND NVL(l_Rec_Prod.LEASE_PAYMENT_MODE,'#')<>'A' AND l_Comp_Indx = l_Main_Int_Comp) -- Log#144
                      */
                   DBG('l_Prod_Comp_Row.Formula_Type ~  l_Comp_Indx ~ l_Main_Int_Comp ~ l_Comp_Sch_Rec.g_Account_Comp_Sch.First_Due_Date ~ p_Account_Rec.Account_Det.Value_Date ~ l_Comp_Sch_Rec.g_Account_Comp_Sch.Schedule_Type ');
                   DBG(l_Prod_Comp_Row.Formula_Type || ' ~ ' || l_Comp_Indx  || ' ~ ' ||  l_Main_Int_Comp  || ' ~ ' ||  l_Comp_Sch_Rec.g_Account_Comp_Sch.First_Due_Date  || ' ~ ' ||  p_Account_Rec.Account_Det.Value_Date  || ' ~ ' ||  l_Comp_Sch_Rec.g_Account_Comp_Sch.Schedule_Type );
                   IF NOT (l_Prod_Comp_Row.Formula_Type IN ('3', '4','9','10','11' ) AND -- Log#162 Changes for 11.1 Dev (Payment in Advance)
                      l_Comp_Indx = l_Main_Int_Comp) THEN
                      --Log#129 Ends
			     -- log#119 changes start
			IF NOT ( (nvl(l_Rec_Prod.LEASE_TYPE,'#' ) IN ( 'O','F')) AND NVL(l_Rec_Prod.LEASE_PAYMENT_MODE,'#') = 'A' ) THEN  ---- Log#162 Changes for 11.1 Dev (Payment in Advance)
			-- Log#147 ED
			IF NOT (NVL(l_Prod_Comp_Row.INCLUDE_IN_EMI,'N') = 'Y'  AND NVL(l_Rec_Prod.LEASE_PAYMENT_MODE,'#') = 'A') THEN  --Log#152 sfr1184 changes
			     IF l_Comp_Sch_Rec.g_Account_Comp_Sch.First_Due_Date =
					p_Account_Rec.Account_Det.Value_Date AND
					l_Comp_Sch_Rec.g_Account_Comp_Sch.Schedule_Type = 'P' THEN
					Dbg('First due date cannot be account value date ');
					p_Err_Code  := 'CL-SCH050;';
					p_Err_Param := l_Comp_Sch_Rec.g_Account_Comp_Sch.Component_Name || '~;';
					Ovpkss.Pr_Appendtbl(p_Err_Code, p_Err_Param);
					RETURN FALSE;
			     END IF;

			     -- log#119 changes end
			    END IF; --Log#152 sfr1184 changes
		     END IF ; -- Log#147
                     --Log#129 Starts
                  END IF;
                  --Log#129 Ends

                  --Santosh 17-Aug-2006 Starts. Serbia UAT support.
                  IF NOT Gwpkss_Cl_Rollservice.Pkg_Roll_Defaulting THEN
                     --Log#124 Starts
                     IF Nvl(l_Ignore_Holiday, '#') = 'N' AND
                        l_Comp_Sch_Rec.g_Account_Comp_Sch.Unit <> 'B' AND
                        l_Comp_Sch_Rec.g_Account_Comp_Sch.Schedule_Type = 'P' THEN
                        IF NOT Clpks_Util.Fn_Isholiday(l_Comp_Sch_Rec.g_Account_Comp_Sch.First_Due_Date
                                                      ,p_Account_Rec.Account_Det.Branch_Code
                                                      ,l_Holiday) THEN
                           p_Err_Code := 'CL-SCH014;';
                           Ovpkss.Pr_Appendtbl(p_Err_Code, '');
                           Dbg('bombed in LPKS_UTIL.fn_isholiday with ' || SQLERRM);
                           RETURN FALSE;
                        END IF;
                        IF Nvl(l_Holiday, 'W') = 'H' THEN
                           -- Log#128 Start
                           l_Next_Working_Date := Cepkss_Date_Addon.Fn_Branch_Working_Day(p_Account_Rec.Account_Det.Branch_Code
                                                                                         ,l_Comp_Sch_Rec.g_Account_Comp_Sch.First_Due_Date
                                                                                         ,1
                                                                                         ,l_Forward_Backward);
                           Dbg('Got the next working day as :' || l_Next_Working_Date);
						   l_old_first_due := l_comp_sch_rec.g_account_comp_sch.first_due_Date; -- Log#163
                           l_Comp_Sch_Rec.g_Account_Comp_Sch.First_Due_Date := l_Next_Working_Date;
                           /**
                           p_err_code := 'CL-SCH048;';
                           p_err_param := l_comp_sch_rec.g_account_comp_sch.component_name || '~;';
                           ovpkss.pr_appendTbl(p_err_code,p_err_param);
                           RETURN FALSE;
                           **/
                           -- Log#128 End

                        END IF;
                     END IF;
                  END IF; --Log#124 Ends
		--Log#140 Start changes for Advance and arrears schedules
		          Dbg('p_account_rec.account_det.lease_type ~ p_account_rec.account_det.lease_payment_mode ~ l_comp_sch_rec.g_account_comp_sch.component_name ~  l_main_int_comp ~ l_comp_sch_rec.g_account_comp_sch.unit ~ l_end_date ~ l_maturity_date ~ l_comp_sch_rec.g_account_comp_sch.first_due_date ~ l_comp_sch_rec.g_account_comp_sch.sch_start_date');
			  Dbg(p_account_rec.account_det.lease_type || ' ~ ' || p_account_rec.account_det.lease_payment_mode || ' ~ ' || l_comp_sch_rec.g_account_comp_sch.component_name || ' ~ ' ||  l_main_int_comp || ' ~ ' ||l_comp_sch_rec.g_account_comp_sch.unit || ' ~ ' || l_end_date || ' ~ ' || l_maturity_date || ' ~ ' || l_comp_sch_rec.g_account_comp_sch.first_due_date || ' ~ ' || l_comp_sch_rec.g_account_comp_sch.sch_start_date );

		          /* -- moving validation to service pkg
		          IF NVL(p_account_rec.account_det.lease_type,'X')  in ('F', 'O' )
		          AND NVL(p_account_rec.account_det.lease_payment_mode,'X')  = 'A'
		          AND l_comp_sch_rec.g_account_comp_sch.component_name = l_main_int_comp
		          AND l_comp_sch_rec.g_account_comp_sch.unit = 'B'
		          AND l_end_date = l_maturity_date
		          THEN
		          dbg('Bullet Schedule for MAIN_INT should not be on Maturity Date for Advance Lease');
		            p_err_code      := 'CL-ACC-203;';
		            p_err_param := l_comp_sch_rec.g_account_comp_sch.component_name || '~;';
		            ovpkss.pr_appendTbl(p_err_code,p_err_param);
		            l_tb_account_comp_sch.DELETE;
		        RETURN FALSE;
		       END IF;


		         IF NVL(p_account_rec.account_det.lease_type,'X') in ('F', 'O')
		         AND NVL(p_account_rec.account_det.lease_payment_mode,'X')  = 'A'
		         AND l_comp_sch_rec.g_account_comp_sch.unit <> 'B'
		         AND l_comp_sch_rec.g_account_comp_sch.component_name = l_main_int_comp
		         AND l_comp_sch_rec.g_account_comp_sch.first_due_date <> l_comp_sch_rec.g_account_comp_sch.sch_start_date -- Log#147
		         THEN
		        dbg('For Advance Lease first due date for MAIN_INT should be the value date');
		           p_err_code      := 'CL-ACC-204;';
		           p_err_param := l_comp_sch_rec.g_account_comp_sch.component_name || '~;';
		                                  ovpkss.pr_appendTbl(p_err_code,p_err_param);
		           l_tb_account_comp_sch.DELETE;
		         RETURN FALSE;
		         END IF;


                         IF NVL(p_account_rec.account_det.lease_type,'X') in ('F', 'O')
		         -- AND NVL(p_account_rec.account_det.lease_payment_mode,'X')  = 'A' -- Log#147
		         AND l_comp_sch_rec.g_account_comp_sch.unit <> 'B'
		         AND l_comp_sch_rec.g_account_comp_sch.component_name = l_main_int_comp
                         AND NVL(p_account_rec.account_det.FREQUENCY_UNIT,'X') <> NVL(l_comp_sch_rec.g_account_comp_sch.unit,p_account_rec.account_det.FREQUENCY_UNIT) -- Log#147
                         THEN
                           dbg('frquency should be unique');
		           p_err_code      := 'CL-ACC-205;';
		           p_err_param := l_comp_sch_rec.g_account_comp_sch.component_name || '~;';
		                                  ovpkss.pr_appendTbl(p_err_code,p_err_param);
		           l_tb_account_comp_sch.DELETE;
		         RETURN FALSE;
		         END IF;

		     IF NVL(p_account_rec.account_det.lease_type,'X') in ('F', 'O')
		     AND NVL(p_account_rec.account_det.lease_payment_mode,'X')  = 'R'
		     AND l_comp_sch_rec.g_account_comp_sch.unit <> 'B' -- Log#147
		     AND l_comp_sch_rec.g_account_comp_sch.component_name = l_main_int_comp
		     AND l_comp_sch_rec.g_account_comp_sch.first_due_date <> p_account_rec.account_det.FIRST_INS_DATE
		     THEN
			 dbg('For Payment in Arrears First Installment Date should not fall on Value Date');
			    p_err_code      := 'CL-ACC-206;';
			    p_err_param := l_comp_sch_rec.g_account_comp_sch.component_name || '~;';
			     ovpkss.pr_appendTbl(p_err_code,p_err_param);
			      l_tb_account_comp_sch.DELETE;
				RETURN FALSE;
		      END IF;
		       -- moving validation to service pkg */
                      --Log#140 End changes for Advance and arrears schedules
                  --Santosh 17-Aug-2006 Ends. Serbia UAT support.
                  IF l_First_Due_Date > l_Maturity_Date THEN
                     Dbg('Schedule Date falls beyond Maturity Date ');
                     p_Err_Code  := 'CL-SCH020;';
                     p_Err_Param := l_Comp_Sch_Rec.g_Account_Comp_Sch.Component_Name || '~;';
                     Ovpkss.Pr_Appendtbl(p_Err_Code, p_Err_Param);
                  END IF;
                  --Bullet schedule validations
                  IF l_Comp_Sch_Rec.g_Account_Comp_Sch.Unit = 'B' THEN
                     -- Bullet schedules should have the schedule due as maturity date
                     --except for discounted and true discounted

                     IF p_Account_Rec.Account_Det.module_code <> 'LE' AND l_Comp_Sch_Rec.g_Account_Comp_Sch.First_Due_Date <>
                        l_Maturity_Date THEN -- SFR#1621

                        -- L Anantharaman Changes start for SFR#284 15-Dec-2004
                        --IF NOT (l_comp_indx = l_main_int_comp AND l_prod_comp_row.component_type IN ('3','4'))
                        l_Prod_Comp_Row := Clpkss_Cache.Fn_Product_Components(l_Product
                                                                             ,l_Comp_Indx);
                        --Log#58 RaghuR 30-Aug-2005 End
                         --Log#140 Start changes for Advance and arrears schedules
                                IF  NVL(l_prod_comp_row.COMP_REPORTING_TYPE,'$$') <> 'IS'
                                THEN
                                if  nvl(p_account_rec.account_det.lease_payment_mode,'X') <> 'A' then
                                p_err_code := 'CL-SCH025;'; --First Bullet schedule must be maturity date.
                                End if;
                                END IF;
                        --Log#140 End changes for Advance and arrears schedules
                        Dbg('l_comp_indx~~l_main_int_comp~~l_prod_comp_row.FORMULA_TYPE ' ||
                            l_Comp_Indx || '~~' || l_Main_Int_Comp || '~~' ||
                            l_Prod_Comp_Row.Formula_Type);
                        IF NOT (l_Comp_Indx = l_Main_Int_Comp AND
                            l_Prod_Comp_Row.Formula_Type IN ('3', '4','10','11')) -- 3 Discounted, 4- Truly Discounted  -- Log#162 Changes for 11.1 Dev (Payment in Advance)
                         THEN
						 IF NOT ( (nvl(l_Rec_Prod.LEASE_TYPE,'#' ) in ('O','F')) AND NVL(l_Rec_Prod.LEASE_PAYMENT_MODE,'#') = 'A' ) THEN -- Log#162 Changes for 11.1 Dev (Payment in Advance)
                           -- L Anantharaman Changes end for SFR#284 15-Dec-2004
                           Dbg('first due  Date should be the maturity date for bullet schedule');
                           p_Err_Code := 'CL-SCH025;';
                           Ovpkss.Pr_Appendtbl(p_Err_Code, '');
                           RETURN FALSE;
						   END IF; -- Log#162 Changes for 11.1 Dev (Payment in Advance)
                        END IF;
                     END IF;

                     IF l_Comp_Sch_Rec.g_Account_Comp_Sch.No_Of_Schedules <> 1 THEN
                        Dbg('No of schedules cannot be more than 1 for bullet schedule');
                        p_Err_Code := 'CL-SCH026;';
                        Ovpkss.Pr_Appendtbl(p_Err_Code, '');
                        RETURN FALSE;
                     END IF;

                     IF Nvl(l_Comp_Sch_Rec.g_Account_Comp_Sch.Capitalized, 'N') = 'Y' THEN
                        Dbg('Bullet schedules are not supposed to be capitalized');
                        p_Err_Code := 'CL-SCH026;';
                        Ovpkss.Pr_Appendtbl(p_Err_Code, '');
                        RETURN FALSE;
                     END IF;

                  END IF;

                  l_First_Due_Date := l_Comp_Sch_Rec.g_Account_Comp_Sch.First_Due_Date;

                  Dbg('First due date is ' || l_First_Due_Date);

                  IF (l_Comp_Indx = l_Main_Int_Comp AND
                     l_Prod_Comp_Row.Formula_Type IN ('3', '4')) OR
                     (l_Comp_Indx = Pkg_Principal AND
                     l_Comp_Sch_Rec.g_Account_Comp_Sch.Schedule_Type = 'D')
                  --Phase II NLS changes
                   THEN
                     --log#119 changes start
                     IF (l_Comp_Indx = Pkg_Principal AND
                        l_Comp_Sch_Rec.g_Account_Comp_Sch.Schedule_Type = 'D') THEN
                        l_Cnt_Dsb_Sch := l_Cnt_Dsb_Sch + 1;
                     END IF;
                     -- log#119 changes end
                     IF l_First_Due_Date != l_Start_Sch_Calc_From THEN
                        IF l_Comp_Indx = l_Main_Int_Comp THEN
                           Dbg('disbursment/discounted and true disc. are supposed to due on value date itself');
                           p_Err_Code := 'CL-SCH043;';
                           Ovpkss.Pr_Appendtbl(p_Err_Code, '');
                           RETURN FALSE;
                        ELSE
                           -- log#119 changes start
                           IF l_Cnt_Dsb_Sch = 1 THEN
                              -- log#119 changes end
                              Dbg('Principal Disbr. schedules due date should be on value date');
                              p_Err_Code := 'CL-SCH044;';
                              Ovpkss.Pr_Appendtbl(p_Err_Code, '');
                              RETURN FALSE;
                           END IF; -- log#119 changes
                        END IF;
                     END IF;
                  END IF;

                  --CL Phase II enhancements
                  --Payment due date and first disbr sch date validations

                  IF l_Frst_Dsbr_Date IS NOT NULL AND
                     l_Comp_Sch_Rec.g_Account_Comp_Sch.Schedule_Type = 'P' THEN
                     IF l_Frst_Dsbr_Date > l_First_Due_Date THEN
                        Dbg('this is an override.Repayment Due date $1 for component $2 is earlier than first Disbursment Date!!Proceed?');
                        --Log#150 Starts
                        /*p_Err_Code  := 'CL-SCH048;';*/
                        p_Err_Code  := 'CL-SCH078;';
                        --Log#150 Ends
                        p_Err_Param := l_First_Due_Date || '~' ||
                                       l_Comp_Sch_Rec.g_Account_Comp_Sch.Component_Name || '~;';
                        Ovpkss.Pr_Appendtbl(p_Err_Code, p_Err_Param);
                     END IF;
                  END IF;

                  IF l_Prev_End_Date IS NULL THEN
                     l_Sch_Start_Date := l_Start_Sch_Calc_From;
                  ELSE
                     --FC10.5 STR1 SFR# 1401 begins
                     IF l_comp_sch_rec.g_account_comp_sch.schedule_type ='D' THEN
                           l_sch_start_date:=l_first_due_date;
                           dbg('dsbr schedule'||l_sch_start_date);
                     ELSE
                           l_sch_start_date   := l_prev_end_date;
                           dbg('payment schedule'||l_sch_start_date);
                     END IF;--FC10.5 STR1 SFR# 1401 ends

                     dbg('l_First_Due_Date: '||l_First_Due_Date||' l_Prev_End_Date: '||l_Prev_End_Date);--FC10.5
                     IF NOT NVL(p_account_rec.account_det.lease_payment_mode,'X')  = 'A' THEN		--Log#145
					 IF l_First_Due_Date <= l_Prev_End_Date THEN
                        Dbg('first due date $1 entered for component $2 and schedule type $3 is not valid');
                        p_Err_Code  := 'CL-SCH045;';
                        p_Err_Param := l_First_Due_Date || '~' ||
                                       l_Comp_Sch_Rec.g_Account_Comp_Sch.Component_Name || '~' ||
                                       l_Comp_Sch_Rec.g_Account_Comp_Sch.Schedule_Type || '~;';
                        Ovpkss.Pr_Appendtbl(p_Err_Code, p_Err_Param);
                        RETURN FALSE;
                     END IF;
                     end if ; --LOg#145
                  END IF;

                  l_Tb_Schedule_Date.DELETE;

                  -- This function call is to compute the schedule dates for the component

                  IF NOT
                      --Fn_Compute_Schedule_Dates(l_First_Due_Date	 --Log#163	code commented
						Fn_compute_schedule_dates(nvl(l_old_first_due,l_first_due_date) -- Log#163
                                               ,l_Value_Date
                                               ,l_Maturity_Date
                                               ,l_Branch_Code
                                               ,l_Product
                                               ,l_Comp_Sch_Rec.g_Account_Comp_Sch.Frequency
                                               ,l_Comp_Sch_Rec.g_Account_Comp_Sch.Unit
                                               ,l_Comp_Sch_Rec.g_Account_Comp_Sch.No_Of_Schedules
                                               ,l_Ignore_Holiday
                                               ,l_Forward_Backward
                                               ,l_Move_Across_Month
                                               ,l_Cascade_Movement
                                               ,l_Comp_Sch_Rec.g_Account_Comp_Sch.Due_Dates_On
                                               ,
                                                --euro bank retro changes LOG#103 starts
                                                -- start  month end periodicity LOG#102
                                                NULL
                                               ,
                                                -- end  month end periodicity LOG#102
                                                --euro bank retro changes LOG#103ends

                                                l_Tb_Schedule_Date
                                               ,p_Err_Code
                                               ,
                                                --Start Log#116
                                                l_Comp_Sch_Rec.g_Account_Comp_Sch.Schedule_Type)
                  --End Log#116

                   THEN
                     Dbg('Function fn_compute_schedule_dates failed - ' || SQLERRM);
                     RETURN FALSE;
                  END IF;

                  IF l_Tb_Schedule_Date.COUNT > 0 THEN
                     -- Setting the schedule end date for the component and schedule

                     l_End_Date := l_Tb_Schedule_Date(l_Tb_Schedule_Date.LAST);

                     l_No_Of_Schedules := l_Tb_Schedule_Date.COUNT;

                     -- calculated no of schedules Cannot be less than no of schedules input.

                     IF l_Comp_Sch_Rec.g_Account_Comp_Sch.No_Of_Schedules >
                        l_No_Of_Schedules THEN
                        Dbg('Schedule Date falls beyond Maturity Date ');
                        p_Err_Code  := 'CL-SCH020;';
                        p_Err_Param := l_Comp_Sch_Rec.g_Account_Comp_Sch.Component_Name || '~;';
                        Ovpkss.Pr_Appendtbl(p_Err_Code, p_Err_Param);
                        l_Tb_Account_Comp_Sch.DELETE;
                        --l_tb_comp_date.DELETE;
                        RETURN FALSE;
                     END IF;

                     -- Reset the no of schedules if there is no place for Bullet schedule
                     -- for repayment schedules.

                     IF l_End_Date = l_Maturity_Date AND
                        l_Comp_Sch_Rec.g_Account_Comp_Sch.Schedule_Type = 'P' AND
                        l_Comp_Sch_Rec.g_Account_Comp_Sch.Unit <> 'B' THEN
                        IF l_Tb_Schedule_Date.COUNT > 1 THEN
                           l_End_Date               := l_Tb_Schedule_Date(l_Tb_Schedule_Date.COUNT - 1);
                           l_No_Of_Schedules        := l_Tb_Schedule_Date.COUNT - 1;
                           l_Bull_Reqd_For_Sec_Comp := TRUE;
                        ELSE
                           -- If there is only one schedule and that is not bullet schedule
                           -- then that is error.
                           --Satrt log#72
                           p_Err_Code  := 'CL-SCH050;';
                           p_Err_Param := ';';
                           Ovpkss.Pr_Appendtbl(p_Err_Code, p_Err_Param);
                           --End log#72
                           Dbg('Final schedule has to be a bullet schedule');
                           l_Tb_Account_Comp_Sch.DELETE;
                           --l_tb_comp_date.DELETE;
                           RETURN FALSE;
                        END IF;
                     END IF;

                     l_Cur_Rec := l_Comp_Sch_Rec.g_Account_Comp_Sch.Schedule_Type ||
                                  Clpkss_Util.Fn_Hash_Date(l_First_Due_Date, NULL);

                     --log#114 Start
                     /*IF NOT l_tb_account_comp_sch.EXISTS(l_cur_rec)
                     THEN*/
                     BEGIN
                        l_Tmp_Tb_Account_Comp_Sch(1) := l_Tb_Account_Comp_Sch(l_Cur_Rec);
                     EXCEPTION
                        WHEN No_Data_Found THEN
                           --log#114 End
                           Dbg('schedule populated ||' || l_First_Due_Date);
                           l_Tb_Account_Comp_Sch(l_Cur_Rec) .g_Account_Comp_Sch.Account_Number := l_Comp_Sch_Rec.g_Account_Comp_Sch.Account_Number;
                           l_Tb_Account_Comp_Sch(l_Cur_Rec) .g_Account_Comp_Sch.Branch_Code := l_Comp_Sch_Rec.g_Account_Comp_Sch.Branch_Code;
                           l_Tb_Account_Comp_Sch(l_Cur_Rec) .g_Account_Comp_Sch.Component_Name := l_Comp_Sch_Rec.g_Account_Comp_Sch.Component_Name;
                           l_Tb_Account_Comp_Sch(l_Cur_Rec) .g_Account_Comp_Sch.Schedule_Type := l_Comp_Sch_Rec.g_Account_Comp_Sch.Schedule_Type;
                           l_Tb_Account_Comp_Sch(l_Cur_Rec) .g_Account_Comp_Sch.Schedule_Flag := l_Comp_Sch_Rec.g_Account_Comp_Sch.Schedule_Flag;
                           l_Tb_Account_Comp_Sch(l_Cur_Rec) .g_Account_Comp_Sch.Formula_Name := l_Comp_Sch_Rec.g_Account_Comp_Sch.Formula_Name;
                           l_Tb_Account_Comp_Sch(l_Cur_Rec) .g_Account_Comp_Sch.Sch_Start_Date := l_Sch_Start_Date;
                           l_Tb_Account_Comp_Sch(l_Cur_Rec) .g_Account_Comp_Sch.First_Due_Date := l_First_Due_Date;
                           l_Tb_Account_Comp_Sch(l_Cur_Rec) .g_Account_Comp_Sch.No_Of_Schedules := l_No_Of_Schedules;
                           l_Tb_Account_Comp_Sch(l_Cur_Rec) .g_Account_Comp_Sch.Frequency := l_Comp_Sch_Rec.g_Account_Comp_Sch.Frequency;
                           l_Tb_Account_Comp_Sch(l_Cur_Rec) .g_Account_Comp_Sch.Unit := l_Comp_Sch_Rec.g_Account_Comp_Sch.Unit;
                           l_Tb_Account_Comp_Sch(l_Cur_Rec) .g_Account_Comp_Sch.Amount := l_Comp_Sch_Rec.g_Account_Comp_Sch.Amount;
                           ---Log#64 Start
                           l_Tb_Account_Comp_Sch(l_Cur_Rec) .g_Account_Comp_Sch.Compound_Days := l_Comp_Sch_Rec.g_Account_Comp_Sch.Compound_Days;
                           l_Tb_Account_Comp_Sch(l_Cur_Rec) .g_Account_Comp_Sch.Compound_Months := l_Comp_Sch_Rec.g_Account_Comp_Sch.Compound_Months;
                           l_Tb_Account_Comp_Sch(l_Cur_Rec) .g_Account_Comp_Sch.Compound_Years := l_Comp_Sch_Rec.g_Account_Comp_Sch.Compound_Years;
                           ---Log#64 end
                           --log#176 start sfr#4393
                           --Changes for FLEXCUBE CL V.U.4.1.IS.1.0.0.0 Islamic Cluster LOT2<starts>
            l_tb_account_comp_sch(l_cur_rec) .g_account_comp_sch.DP_AMOUNT    := l_comp_sch_rec.g_account_comp_sch.DP_AMOUNT;
            l_tb_account_comp_sch(l_cur_rec) .g_account_comp_sch.PAY_MODE    := l_comp_sch_rec.g_account_comp_sch.PAY_MODE;
            l_tb_account_comp_sch(l_cur_rec) .g_account_comp_sch.PAYABLE_ACC    := l_comp_sch_rec.g_account_comp_sch.PAYABLE_ACC;
            l_tb_account_comp_sch(l_cur_rec) .g_account_comp_sch.EXCH_RATE    := l_comp_sch_rec.g_account_comp_sch.EXCH_RATE;
            l_tb_account_comp_sch(l_cur_rec) .g_account_comp_sch.PAYABLE_ACC_CCY    := l_comp_sch_rec.g_account_comp_sch.PAYABLE_ACC_CCY;
            --Changes for FLEXCUBE CL V.U.4.1.IS.1.0.0.0 Islamic Cluster LOT2<ends>
                           --log#176 end sfr#4393
                           --Log#66 Start
                           --29.09.2005 Log#67 EMI Changes Start
                           IF l_Comp_Sch_Rec.g_Account_Comp_Sch.Emi_Amount IS NOT NULL THEN
                              IF NOT
                                  Clpkss_Util.Fn_Round_Emi(l_Comp_Sch_Rec.g_Account_Comp_Sch.Emi_Amount
                                                          ,p_Account_Rec.Account_Det.Product_Code
                                                          ,p_Account_Rec.Account_Det.Currency) THEN
                                 Dbg('Failed in rounding emi in fn_validate_amort_pairs for account for :' ||
                                     p_Account_Rec.Account_Det.Product_Code || '~' ||
                                     l_Comp_Sch_Rec.g_Account_Comp_Sch.Emi_Amount);
                                 RETURN FALSE;
                              END IF;
                           END IF;
                           --29.09.2005 Log#67 EMI Changes End

                           l_Tb_Account_Comp_Sch(l_Cur_Rec) .g_Account_Comp_Sch.Emi_Amount := l_Comp_Sch_Rec.g_Account_Comp_Sch.Emi_Amount;
                           --Log#66 End

                           -- aakriti - changes for SFR#491 MTR1 - 17th december 2004
                           l_Prod_Comp_Row := Clpkss_Cache.Fn_Product_Components(l_Product
                                                                                ,l_Comp_Sch_Rec.g_Account_Comp_Sch.Component_Name);
                           IF l_Prod_Comp_Row.Formula_Type IN ('3', '4') THEN
                              l_Tb_Account_Comp_Sch(l_Cur_Rec) .g_Account_Comp_Sch.Sch_End_Date := l_First_Due_Date;
                           ELSE
                              l_Tb_Account_Comp_Sch(l_Cur_Rec) .g_Account_Comp_Sch.Sch_End_Date := l_End_Date;
                           END IF;
                           -- l_tb_account_comp_sch(l_cur_rec) .g_account_comp_sch.sch_end_date      := l_end_date;
                           l_Tb_Account_Comp_Sch(l_Cur_Rec) .g_Account_Comp_Sch.Payment_Mode := l_Comp_Sch_Rec.g_Account_Comp_Sch.Payment_Mode;
                           l_Tb_Account_Comp_Sch(l_Cur_Rec) .g_Account_Comp_Sch.Pmnt_Prod_Ac := l_Comp_Sch_Rec.g_Account_Comp_Sch.Pmnt_Prod_Ac;
                           l_Tb_Account_Comp_Sch(l_Cur_Rec) .g_Account_Comp_Sch.Payment_Details := l_Comp_Sch_Rec.g_Account_Comp_Sch.Payment_Details;
                           l_Tb_Account_Comp_Sch(l_Cur_Rec) .g_Account_Comp_Sch.Ben_Account := l_Comp_Sch_Rec.g_Account_Comp_Sch.Ben_Account;
                           l_Tb_Account_Comp_Sch(l_Cur_Rec) .g_Account_Comp_Sch.Ben_Bank := l_Comp_Sch_Rec.g_Account_Comp_Sch.Ben_Bank;
                           l_Tb_Account_Comp_Sch(l_Cur_Rec) .g_Account_Comp_Sch.Ben_Name := l_Comp_Sch_Rec.g_Account_Comp_Sch.Ben_Name;
                           l_Tb_Account_Comp_Sch(l_Cur_Rec) .g_Account_Comp_Sch.Capitalized := l_Comp_Sch_Rec.g_Account_Comp_Sch.Capitalized;
                           l_Tb_Account_Comp_Sch(l_Cur_Rec) .g_Account_Comp_Sch.Waiver_Flag := l_Comp_Sch_Rec.g_Account_Comp_Sch.Waiver_Flag;
                           l_Tb_Account_Comp_Sch(l_Cur_Rec) .g_Account_Comp_Sch.Due_Dates_On := l_Comp_Sch_Rec.g_Account_Comp_Sch.Due_Dates_On;
                           -- log#114 changes start
                           l_Tb_Account_Comp_Sch(l_Cur_Rec) .g_Account_Comp_Sch.Days_Mth := l_Comp_Sch_Rec.g_Account_Comp_Sch.Days_Mth;
                           l_Tb_Account_Comp_Sch(l_Cur_Rec) .g_Account_Comp_Sch.Days_Year := l_Comp_Sch_Rec.g_Account_Comp_Sch.Days_Year;
                           -- log#114 changes end
                           --Log#180 fc11.2 MB0765 starts
                           		dbg(' e33 EMI_AS_PERCENTAGE_SALARY '||l_Comp_Sch_Rec.g_Account_Comp_Sch.EMI_AS_PERCENTAGE_SALARY ) ;
                           l_Tb_Account_Comp_Sch(l_Cur_Rec) .g_Account_Comp_Sch.EMI_AS_PERCENTAGE_SALARY := l_Comp_Sch_Rec.g_Account_Comp_Sch.EMI_AS_PERCENTAGE_SALARY;
                             --Log#180 fc11.2 MB0765 end
                           l_Tb_Account_Comp_Sch(l_Cur_Rec) .g_Record_Rowid := l_Comp_Sch_Rec.g_Record_Rowid;
                           l_Tb_Account_Comp_Sch(l_Cur_Rec) .g_Action := 'I';

                           --store all amort components for validations

                           /*IF l_comp_sch_rec.g_account_comp_sch.component_name = l_main_int_comp AND
                              l_comp_sch_rec.g_account_comp_sch.schedule_type = 'P' AND
                              l_tb_frm_names.EXISTS(l_comp_sch_rec.g_account_comp_sch.formula_name)

                           THEN
                               l_tb_amort_comp_sch(l_cur_rec).g_account_comp_sch := l_tb_account_comp_sch(l_cur_rec).g_account_comp_sch;*/
                           --get the disbr. schedules index for disbr. apportioning
                           --ELSIF l_comp_sch_rec.g_account_comp_sch.component_name = PKG_PRINCIPAL AND
                           IF l_Comp_Sch_Rec.g_Account_Comp_Sch.Component_Name =
                              Pkg_Principal AND
                             --Phase II NLS changes
                              l_Comp_Sch_Rec.g_Account_Comp_Sch.Schedule_Type = 'D' THEN

                              l_Tb_For_Disbr(l_Disb_Indx) := l_Cur_Rec;

                              l_Disb_Indx := l_Disb_Indx + 1;

                              l_No_Of_Disb_Schs := l_No_Of_Disb_Schs +
                                                   l_Comp_Sch_Rec.g_Account_Comp_Sch.No_Of_Schedules;

                           END IF;
                           --log#114 start
                        --END IF;
                     END;
                     --log#114 end

                     IF l_Total_Amount IS NOT NULL --means amount is being validated
                      THEN
                        IF l_Comp_Sch_Rec.g_Account_Comp_Sch.Amount * l_No_Of_Schedules >
                           l_Total_Amount THEN

                           l_Result := 'N';

                           IF l_Comp_Sch_Rec.g_Account_Comp_Sch.Schedule_Type = 'D' THEN

                              IF NOT Fn_Is_Within_Tolerance(l_Total_Amount
                                                           ,l_Calc_Amount
                                                           ,l_No_Of_Disb_Schs
                                                           ,l_Currency
                                                           ,l_Result) THEN
                                 Dbg('fn_is_within_tolerance returned false');
                                 RETURN FALSE;
                              END IF;
                           END IF;

                           IF l_Result = 'Y' THEN

                              Dbg('total amount calculated for this row itself exceeded principal');
                              p_Err_Code  := 'CL-SCH032;';
                              p_Err_Param := l_Comp_Sch_Rec.g_Account_Comp_Sch.Component_Name || '~;';

                              Ovpkss.Pr_Appendtbl(p_Err_Code, p_Err_Param);

                              RETURN FALSE;
                           END IF;

                        END IF;

                        l_Calc_Amount := l_Calc_Amount + (l_Comp_Sch_Rec.g_Account_Comp_Sch.Amount *
                                         l_No_Of_Schedules);
                     END IF;

                     -- This check is for having bullet schedule
                     -- If it is already present then the index also will be stored.
                     -- Bullet schedule later will be updated with the balance amount to be paid.
                     -- Bullet schedule is required only for repayment schedules

                     --Log#99 Starts 22-May-2006 Retro from Alpha Bank
                     --While exploding schedule it populated the bullet schedule only for MAIN_INT and PRINCIPAL components.
                     l_Prod_Comp_Row := Clpkss_Cache.Fn_Product_Components(p_Account_Rec.Account_Det.Product_Code
                                                                          ,l_Comp_Sch_Rec.g_Account_Comp_Sch.Component_Name);
                     --While exploding schedule it populated the bullet schedule only for MAIN_INT and PRINCIPAL components.
                     --Log#99 Ends 22-May-2006 Retro from Alpha Bank

                     IF l_Comp_Sch_Rec.g_Account_Comp_Sch.Schedule_Type = 'P'

                      THEN
                        IF
                        --Log#99 Starts 22-May-2006 Retro from Alpha Bank
                        --l_comp_rec.component_name IN (l_main_int_comp,PKG_PRINCIPAL)
                        --Phase II NLS changes
                        --OR
                        --Log#99 Ends 22-May-2006 Retro from Alpha Bank
                         l_Bull_Reqd_For_Sec_Comp OR
                        --Log#99 Starts 22-May-2006 Retro from Alpha Bank
                        --While exploding schedule it populated the bullet schedule only for MAIN_INT and PRINCIPAL components.
                        --New condition is added to generate bullet schedule for Formula with Schedule and Schedule Without Formula components
                         Nvl(l_Prod_Comp_Row.Component_Type, 'L') IN ('I', 'L')
                        --New condition is added to generate bullet schedule for Formula with Schedule and Schedule Without Formula components
                        --While exploding schedule it populated the bullet schedule only for MAIN_INT and PRINCIPAL components.
                        --Log#99 Starts 22-May-2006 Retro from Alpha Bank
                         THEN
                           Dbg('Bullet date is going to be - ' || l_End_Date);

                           l_Bullet_Date       := l_Prev_End_Date;
                           l_Bullet_Reqd       := TRUE;
                           l_Bullet_Start_Date := l_End_Date;

                           IF l_Comp_Sch_Rec.g_Account_Comp_Sch.Unit = 'B' THEN
                              l_Bullet_Reqd       := FALSE;
                              l_Bullet_Indx       := l_Cur_Rec;
                              l_Bullet_Start_Date := l_End_Date;
                              Dbg('Bullet index - ' || l_Cur_Rec);
                           END IF;
                        END IF;
                     END IF;

                  ELSE
                     -- The output from the compute schedules function returns
                     -- the pl/sql table with no data.

                     Dbg('No schedules possible ');
                     p_Err_Code  := 'CL-SCH007;';
                     p_Err_Param := l_Comp_Sch_Rec.g_Account_Comp_Sch.Component_Name || '~;';
                     Ovpkss.Pr_Appendtbl(p_Err_Code, p_Err_Param);
                     RETURN FALSE;
                  END IF;

                  l_Prev_End_Date := l_End_Date;

                  l_Prev_Sch_Type := l_Comp_Sch_Rec.g_Account_Comp_Sch.Schedule_Type;
				  -- Log#162 Changes for 11.1 Dev (Payment in Advance) starts
				  l_Prev_Sch_Freq_Type:= l_Comp_Sch_Rec.g_Account_Comp_Sch.Unit;
                  l_Prev_Sch_Frequency:=l_Comp_Sch_Rec.g_Account_Comp_Sch.Frequency;
                  l_Prev_Sch_DueDatesOn:= l_Comp_Sch_Rec.g_Account_Comp_Sch.Due_Dates_On;
                  l_Prev_Sch_No_Of_Schedules:= l_Comp_Sch_Rec.g_Account_Comp_Sch.No_Of_Schedules;
				  -- Log#162 Changes for 11.1 Dev (Payment in Advance) ends

                  -- This will be used for the bullet schedule population.
                  -- The last schedule details will be copied to the bullet schedule.

                  l_Formula_Name    := l_Comp_Sch_Rec.g_Account_Comp_Sch.Formula_Name;
                  l_Payment_Mode    := l_Comp_Sch_Rec.g_Account_Comp_Sch.Payment_Mode;
                  l_Pmnt_Prod_Ac    := l_Comp_Sch_Rec.g_Account_Comp_Sch.Pmnt_Prod_Ac;
                  l_Payment_Details := l_Comp_Sch_Rec.g_Account_Comp_Sch.Payment_Details;
                  l_Ben_Account     := l_Comp_Sch_Rec.g_Account_Comp_Sch.Ben_Account;
                  l_Ben_Bank        := l_Comp_Sch_Rec.g_Account_Comp_Sch.Ben_Bank;
                  l_Ben_Name        := l_Comp_Sch_Rec.g_Account_Comp_Sch.Ben_Name;
                  --l_capitalized     := l_comp_sch_rec.g_account_comp_sch.capitalized;
                  --bullet schedule is never capitalized
                  l_Capitalized := 'N';
                  l_Waiver_Flag := l_Comp_Sch_Rec.g_Account_Comp_Sch.Waiver_Flag;
                  ---Log#64 Start
                  l_Compound_Days   := l_Comp_Sch_Rec.g_Account_Comp_Sch.Compound_Days;
                  l_Compound_Months := l_Comp_Sch_Rec.g_Account_Comp_Sch.Compound_Months;
                  l_Compound_Years  := l_Comp_Sch_Rec.g_Account_Comp_Sch.Compound_Years;
                  ----Log#64 end
                  --Log#66 Start
                  l_Emi_Amount := l_Comp_Sch_Rec.g_Account_Comp_Sch.Emi_Amount;
                  --Log#66 End
                  -- Verifying the change in the schedule type.
                  -- If there is then exit the inner loop and process for bullet schedule.

                  l_Comp_Sch_Indx := l_Tb_Comp_Sch.NEXT(l_Comp_Sch_Indx);

                  IF l_Comp_Sch_Indx IS NOT NULL THEN
                     IF l_Prev_Sch_Type <> l_Tb_Comp_Sch(l_Comp_Sch_Indx)
                     .g_Account_Comp_Sch.Schedule_Type THEN
                        -- End of processing for the schedule type l_prev_sch_type
                        EXIT;
                     END IF;
                  END IF;

               END LOOP;
               --bullet not required in these case

               IF l_Comp_Rec.Component_Name = Pkg_Principal
                 --Phase II NLS changes
                  AND l_Is_Last_Form_Amort = TRUE THEN
                  l_Bullet_Reqd := FALSE;
               END IF;

               IF Nvl(l_Comp_Rec.Main_Component, 'N') = 'Y' THEN
                  l_Prod_Comp_Row := Clpkss_Cache.Fn_Product_Components(l_Product
                                                                       ,l_Comp_Indx);
                  IF l_Prod_Comp_Row.Formula_Type IN ('3', '4') THEN
                     Dbg('no forcing of bullet for discounted');
                     l_Bullet_Reqd := FALSE;
                  END IF;
               END IF;

               Dbg('Total amount - ' || l_Total_Amount);
               Dbg('calc amount  - ' || l_Calc_Amount);
               IF l_Total_Amount IS NOT NULL AND l_Calc_Amount IS NOT NULL THEN
                  l_Result := 'N';
                  IF l_Prev_Sch_Type = 'D' THEN
                     IF NOT Fn_Is_Within_Tolerance(l_Total_Amount
                                                  ,l_Calc_Amount
                                                  ,l_No_Of_Disb_Schs
                                                  ,l_Currency
                                                  ,l_Result) THEN
                        Dbg('fn_is_within_tolerance returned false');
                        RETURN FALSE;
                     END IF;
                  END IF;

                  IF l_Calc_Amount >= l_Total_Amount AND l_Bullet_Reqd THEN
                     Dbg('Principal has beed exhausted before maturity');
                     --It means Principal has beed exhausted before maturity
                     p_Err_Code  := 'CL-SCH031;';
                     p_Err_Param := l_Comp_Sch_Rec.g_Account_Comp_Sch.Component_Name || '~;';
                     Ovpkss.Pr_Appendtbl(p_Err_Code, p_Err_Param);
                     RETURN FALSE;
                  END IF;

                  IF l_Calc_Amount > l_Total_Amount THEN
                     IF l_Result = 'N' THEN
                        Dbg('Total amount for $1 component exceeds the total Amount');
                        --Total amount for $1 component exceeds the total Amount
                        p_Err_Code  := 'CL-SCH032;';
                        p_Err_Param := l_Comp_Sch_Rec.g_Account_Comp_Sch.Component_Name || '~;';
                        Ovpkss.Pr_Appendtbl(p_Err_Code, p_Err_Param);
                        RETURN FALSE;
                     END IF;
                  ELSIF l_Calc_Amount < l_Total_Amount THEN
                     IF l_Bullet_Reqd THEN
                        l_Bal_Amount := l_Total_Amount - l_Calc_Amount;
                        --Insert a bullet schedule here.
                        l_Cur_Rec := l_Prev_Sch_Type || l_Mat_Date_Indx;
                        --l_cur_rec := l_prev_sch_type ||
                        --clpkss_util.fn_hash_date(l_maturity_date,NULL);

                        Dbg('Schedule type - ' || l_Prev_Sch_Type);
                        Dbg('l_cur_rec for bullet - ' || l_Cur_Rec);
                        /*IF NOT l_tb_account_comp_sch.EXISTS(l_cur_rec)
                        THEN*/
                        BEGIN
                           l_Tmp_Tb_Account_Comp_Sch(1) := l_Tb_Account_Comp_Sch(l_Cur_Rec);
                        EXCEPTION
                           WHEN No_Data_Found THEN
                              Dbg('inserting one bullet here..cos no bullet was given and has passed amount validations');

                              l_Tb_Account_Comp_Sch(l_Cur_Rec) .g_Account_Comp_Sch.Account_Number := l_Account_No;
                              l_Tb_Account_Comp_Sch(l_Cur_Rec) .g_Account_Comp_Sch.Branch_Code := l_Branch_Code;
                              l_Tb_Account_Comp_Sch(l_Cur_Rec) .g_Account_Comp_Sch.Component_Name := l_Comp_Rec.Component_Name;
                              l_Tb_Account_Comp_Sch(l_Cur_Rec) .g_Account_Comp_Sch.Schedule_Type := l_Prev_Sch_Type;
                              l_Tb_Account_Comp_Sch(l_Cur_Rec) .g_Account_Comp_Sch.Schedule_Flag := 'N';
                              l_Tb_Account_Comp_Sch(l_Cur_Rec) .g_Account_Comp_Sch.Formula_Name := l_Formula_Name; -- To be clarified
                              l_Tb_Account_Comp_Sch(l_Cur_Rec) .g_Account_Comp_Sch.Sch_Start_Date := l_Bullet_Start_Date;
                              l_Tb_Account_Comp_Sch(l_Cur_Rec) .g_Account_Comp_Sch.First_Due_Date := l_Maturity_Date;
                              l_Tb_Account_Comp_Sch(l_Cur_Rec) .g_Account_Comp_Sch.No_Of_Schedules := 1;
                              l_Tb_Account_Comp_Sch(l_Cur_Rec) .g_Account_Comp_Sch.Frequency := 1;
                              l_Tb_Account_Comp_Sch(l_Cur_Rec) .g_Account_Comp_Sch.Unit := 'B';
                              l_Tb_Account_Comp_Sch(l_Cur_Rec) .g_Account_Comp_Sch.Sch_End_Date := l_Maturity_Date;
                              l_Tb_Account_Comp_Sch(l_Cur_Rec) .g_Account_Comp_Sch.Amount := l_Bal_Amount;
                              l_Tb_Account_Comp_Sch(l_Cur_Rec) .g_Account_Comp_Sch.Payment_Mode := l_Payment_Mode;
                              l_Tb_Account_Comp_Sch(l_Cur_Rec) .g_Account_Comp_Sch.Pmnt_Prod_Ac := l_Pmnt_Prod_Ac;
                              l_Tb_Account_Comp_Sch(l_Cur_Rec) .g_Account_Comp_Sch.Payment_Details := l_Payment_Details;
                              l_Tb_Account_Comp_Sch(l_Cur_Rec) .g_Account_Comp_Sch.Ben_Account := l_Ben_Account;
                              l_Tb_Account_Comp_Sch(l_Cur_Rec) .g_Account_Comp_Sch.Ben_Bank := l_Ben_Bank;
                              l_Tb_Account_Comp_Sch(l_Cur_Rec) .g_Account_Comp_Sch.Ben_Name := l_Ben_Name;
                              l_Tb_Account_Comp_Sch(l_Cur_Rec) .g_Account_Comp_Sch.Capitalized := l_Capitalized;
                              l_Tb_Account_Comp_Sch(l_Cur_Rec) .g_Account_Comp_Sch.Waiver_Flag := l_Waiver_Flag;
                              ---Log#64 Start
                              l_Tb_Account_Comp_Sch(l_Cur_Rec) .g_Account_Comp_Sch.Compound_Days := l_Compound_Days;
                              l_Tb_Account_Comp_Sch(l_Cur_Rec) .g_Account_Comp_Sch.Compound_Months := l_Compound_Months;
                              l_Tb_Account_Comp_Sch(l_Cur_Rec) .g_Account_Comp_Sch.Compound_Years := l_Compound_Years;
                              ---Log#64 end
                              --Log#66 Start
                              l_Tb_Account_Comp_Sch(l_Cur_Rec) .g_Account_Comp_Sch.Emi_Amount := l_Emi_Amount;
                              --Log#66 End

                              l_Tb_Account_Comp_Sch(l_Cur_Rec) .g_Record_Rowid := NULL;
                              l_Tb_Account_Comp_Sch(l_Cur_Rec) .g_Action := 'I';

                           --log#114 Start
                           --END IF;
                        END;
                        --log#114 End
                     ELSE
                        IF l_Result = 'N' THEN
                           Dbg('Total amount for $1 component is less than the Total amount');
                           p_Err_Code  := 'CL-SCH033;';
                           p_Err_Param := l_Comp_Sch_Rec.g_Account_Comp_Sch.Component_Name || '~;';
                           Ovpkss.Pr_Appendtbl(p_Err_Code, p_Err_Param);
                           RETURN FALSE;
                        END IF;
                     END IF;

                  END IF;
               ELSIF l_Bullet_Reqd --if l_amount is null and bullet not present then default bullet
                THEN
                  l_Cur_Rec := l_Prev_Sch_Type || l_Mat_Date_Indx;
                  --clpkss_util.fn_hash_date(l_maturity_date,NULL);
                  Dbg('amount given is null and there is no bullet..so inserting one bullet');
                  l_Tb_Account_Comp_Sch(l_Cur_Rec) .g_Account_Comp_Sch.Account_Number := l_Account_No;
                  l_Tb_Account_Comp_Sch(l_Cur_Rec) .g_Account_Comp_Sch.Branch_Code := l_Branch_Code;
                  l_Tb_Account_Comp_Sch(l_Cur_Rec) .g_Account_Comp_Sch.Component_Name := l_Comp_Rec.Component_Name;
                  l_Tb_Account_Comp_Sch(l_Cur_Rec) .g_Account_Comp_Sch.Schedule_Type := l_Prev_Sch_Type;
                  l_Tb_Account_Comp_Sch(l_Cur_Rec) .g_Account_Comp_Sch.Schedule_Flag := 'N';
                  l_Tb_Account_Comp_Sch(l_Cur_Rec) .g_Account_Comp_Sch.Formula_Name := l_Formula_Name; -- To be clarified
                  l_Tb_Account_Comp_Sch(l_Cur_Rec) .g_Account_Comp_Sch.Sch_Start_Date := l_Bullet_Start_Date;
                  --l_Tb_Account_Comp_Sch(l_Cur_Rec) .g_Account_Comp_Sch.First_Due_Date := l_Maturity_Date; -- Log#162 Changes for 11.1 Dev (Payment in Advance) changes
                  l_Tb_Account_Comp_Sch(l_Cur_Rec) .g_Account_Comp_Sch.No_Of_Schedules := 1;
                  l_Tb_Account_Comp_Sch(l_Cur_Rec) .g_Account_Comp_Sch.Frequency := 1;
                  l_Tb_Account_Comp_Sch(l_Cur_Rec) .g_Account_Comp_Sch.Unit := 'B';
				  --Log#162  Changes for 11.1 Dev (Payment in Advance) changes start
				  l_Product_Code    := p_Account_Rec.Account_Det.Product_Code;
				  IF l_Tb_Schedule_Date.COUNT >0 THEN
                  l_Tb_Schedule_Date.DELETE;
                  END IF;
				  dbg('about to call Fn_Compute_Schedule_Dates from gen validate schedules--nnnn');
                   l_bool1  := Fn_Compute_Schedule_Dates(l_Bullet_Start_Date
                                                                ,l_Bullet_Start_Date
                                                                ,l_Maturity_Date
                                                                ,l_Branch_Code
                                                                ,l_Product_Code
                                                                ,l_Prev_Sch_Frequency
                                                                ,l_Prev_Sch_Freq_Type
                                                                ,2
                                                                ,l_Ignore_Holiday
                                                                ,l_Forward_Backward
                                                                ,l_Move_Across_Month
                                                                ,l_Cascade_Movement
                                                                ,l_Prev_Sch_DueDatesOn
                                                                ,NULL
                                                                ,l_Tb_Schedule_Date
                                                                ,p_Err_Code
                                                                ,l_Prev_Sch_Type);

					--Log#179
					IF NVL(p_account_rec.account_det.lease_payment_mode,'X') <> 'A' THEN
						l_Maturity_Date:=l_Tb_Schedule_Date(l_Tb_Schedule_Date.LAST);
						l_tmp_mat_date := l_Maturity_Date;
					ELSE
						l_tmp_mat_date := l_Tb_Schedule_Date(l_Tb_Schedule_Date.LAST);
					END IF;
					--Log#179

                  Dbg('l_Maturity_Date111 value is :-'||l_Maturity_Date);

                  --Log#179
				  --l_Tb_Account_Comp_Sch(l_Cur_Rec) .g_Account_Comp_Sch.First_Due_Date := l_Maturity_Date;
				  l_Tb_Account_Comp_Sch(l_Cur_Rec) .g_Account_Comp_Sch.First_Due_Date := l_tmp_mat_date;
				  --Log#179

				  --Log#162 Changes for 11.1 Dev (Payment in Advance) changes ends

				  --Log#179
                  --l_Tb_Account_Comp_Sch(l_Cur_Rec) .g_Account_Comp_Sch.Sch_End_Date := l_Maturity_Date;
                  l_Tb_Account_Comp_Sch(l_Cur_Rec) .g_Account_Comp_Sch.Sch_End_Date := l_tmp_mat_date;
                  --Log#179

                  l_Tb_Account_Comp_Sch(l_Cur_Rec) .g_Account_Comp_Sch.Amount := NULL;
                  l_Tb_Account_Comp_Sch(l_Cur_Rec) .g_Account_Comp_Sch.Payment_Mode := l_Payment_Mode;
                  l_Tb_Account_Comp_Sch(l_Cur_Rec) .g_Account_Comp_Sch.Pmnt_Prod_Ac := l_Pmnt_Prod_Ac;
                  l_Tb_Account_Comp_Sch(l_Cur_Rec) .g_Account_Comp_Sch.Payment_Details := l_Payment_Details;
                  l_Tb_Account_Comp_Sch(l_Cur_Rec) .g_Account_Comp_Sch.Ben_Account := l_Ben_Account;
                  l_Tb_Account_Comp_Sch(l_Cur_Rec) .g_Account_Comp_Sch.Ben_Bank := l_Ben_Bank;
                  l_Tb_Account_Comp_Sch(l_Cur_Rec) .g_Account_Comp_Sch.Ben_Name := l_Ben_Name;
                  l_Tb_Account_Comp_Sch(l_Cur_Rec) .g_Account_Comp_Sch.Capitalized := l_Capitalized;
                  l_Tb_Account_Comp_Sch(l_Cur_Rec) .g_Account_Comp_Sch.Waiver_Flag := l_Waiver_Flag;

                  ---Log#64 Start
                  l_Tb_Account_Comp_Sch(l_Cur_Rec) .g_Account_Comp_Sch.Compound_Days := l_Compound_Days;
                  l_Tb_Account_Comp_Sch(l_Cur_Rec) .g_Account_Comp_Sch.Compound_Months := l_Compound_Months;
                  l_Tb_Account_Comp_Sch(l_Cur_Rec) .g_Account_Comp_Sch.Compound_Years := l_Compound_Years;
                  ---Log#64 end
                  --Log#66 Start
                  l_Tb_Account_Comp_Sch(l_Cur_Rec) .g_Account_Comp_Sch.Emi_Amount := l_Emi_Amount;
                  --Log#66 End
                  l_Tb_Account_Comp_Sch(l_Cur_Rec) .g_Record_Rowid := NULL;
                  l_Tb_Account_Comp_Sch(l_Cur_Rec) .g_Action := 'I';
                  --store all amort components for validations
                  --IF l_comp_rec.main_component = 'Y' AND
                  --   l_prev_sch_type = 'P' AND
                  --   l_tb_frm_names.EXISTS(l_formula_name)
                  --THEN
                  --   l_tb_amort_comp_sch(l_cur_rec).g_account_comp_sch := l_tb_account_comp_sch(l_cur_rec).g_account_comp_sch;
                  --END IF;
               END IF;

               IF l_Total_Amount IS NOT NULL AND l_Prev_Sch_Type = 'D' AND
                  l_Calc_Amount IS NULL THEN
                  IF l_Tb_For_Disbr.COUNT > 0 THEN

                     FOR i IN l_Tb_For_Disbr.FIRST .. l_Tb_For_Disbr.LAST LOOP
                        Dbg('total no of disbr schesdule defn is ' ||
                            l_Tb_Account_Comp_Sch.COUNT);
                        IF l_Tb_Account_Comp_Sch.EXISTS(l_Tb_For_Disbr(i)) THEN
                           IF l_Tb_Account_Comp_Sch(l_Tb_For_Disbr(i))
                           .g_Account_Comp_Sch.Amount IS NOT NULL THEN
                              l_Total_Amt_Disbr := l_Total_Amt_Disbr +
                                                   l_Tb_Account_Comp_Sch(l_Tb_For_Disbr(i))
                                                  .g_Account_Comp_Sch.No_Of_Schedules *
                                                   Nvl(l_Tb_Account_Comp_Sch(l_Tb_For_Disbr(i))
                                                       .g_Account_Comp_Sch.Amount
                                                      ,0);
                           ELSE
                              l_Total_Undsbr_Schs := l_Total_Undsbr_Schs +
                                                     l_Tb_Account_Comp_Sch(l_Tb_For_Disbr(i))
                                                    .g_Account_Comp_Sch.No_Of_Schedules;
                           END IF;
                        END IF;
                     END LOOP;
                     Dbg('l_total_amt_disbr is ' || l_Total_Amt_Disbr);
                     Dbg('l_total_undsbr_schs is ' || l_Total_Undsbr_Schs);
                     --Log#141 Abhishek Ranjan for RML starts
                     IF c3pk#_prd_shell.fn_get_contract_info(p_Account_Rec.account_det.account_number, p_Account_Rec.account_det.branch_code
                                                ,'LOAN_TYPE',p_Account_Rec.account_det.product_code
                                               )<>'R'
                     THEN
                     --Log#141 Abhishek Ranjan for RML Ends
                         IF l_Total_Amt_Disbr != l_Total_Amount THEN
                            l_Disbr_Sch_Amt := (l_Total_Amount - l_Total_Amt_Disbr) /
                                               l_Total_Undsbr_Schs;

                            IF NOT Cypkss.Fn_Amt_Round(l_Currency
                                                      ,l_Disbr_Sch_Amt
                                                      ,l_Disbr_Sch_Rnd_Amt) THEN
                               l_Tb_For_Disbr.DELETE;
                               RETURN(FALSE);
                            END IF;

                            FOR i IN l_Tb_For_Disbr.FIRST .. l_Tb_For_Disbr.LAST LOOP
                               IF l_Tb_Account_Comp_Sch.EXISTS(l_Tb_For_Disbr(i)) THEN
                                  IF l_Tb_Account_Comp_Sch(l_Tb_For_Disbr(i))
                                  .g_Account_Comp_Sch.Amount IS NULL THEN
                                     l_Tb_Account_Comp_Sch(l_Tb_For_Disbr(i)) .g_Account_Comp_Sch.Amount := l_Disbr_Sch_Rnd_Amt;
                                  END IF;
                               END IF;
                            END LOOP;
                         END IF;
                     END IF; --Log#141 Abhishek Ranjan for RML
                  END IF;
               END IF;

            END LOOP;

            Dbg('At the end count - ' || l_Tb_Account_Comp_Sch.COUNT);
            p_Account_Rec.g_Tb_Components(l_Comp_Indx) .g_Tb_Comp_Sch := l_Tb_Account_Comp_Sch;

            l_Tb_Account_Comp_Sch.DELETE;
            l_Tb_Comp_Sch.DELETE;
            l_Tb_For_Disbr.DELETE;

            l_Comp_Indx := p_Account_Rec.g_Tb_Components.NEXT(l_Comp_Indx);
            Dbg('l_comp_indx is' || l_Comp_Indx);
            Dbg('finished the component - ' || l_Comp_Rec.Component_Name);

         END LOOP;
      END IF;

      Dbg('l_main_int_comp - ' || l_Main_Int_Comp);

      Dbg('came out of component loop');

      IF NOT Fn_Validate_Amort_Pairs THEN
         RETURN FALSE;
      END IF;

      /*  --verify here for all action code that amortized and principal schedules are not overlapping
      --with each other

      l_amort_indx := l_tb_amort_comp_sch.FIRST;

      WHILE l_amort_indx IS NOT NULL
      LOOP

         l_amortise_st_date  := l_tb_amort_comp_sch(l_amort_indx).g_account_comp_sch.sch_start_date;
         l_amortise_end_date    := l_tb_amort_comp_sch(l_amort_indx).g_account_comp_sch.sch_end_date;

         l_tb_comp_sch := p_account_rec.g_tb_components(PKG_PRINCIPAL).g_tb_comp_sch;
          --Phase II NLS changes
         l_comp_sch_indx := l_tb_comp_sch.FIRST;
         WHILE l_comp_sch_indx IS NOT NULL
         LOOP
             IF l_tb_comp_sch(l_comp_sch_indx).g_account_comp_sch.schedule_type = 'P' THEN
                 l_prin_start_dt := l_tb_comp_sch(l_comp_sch_indx).g_account_comp_sch.sch_start_date;
                 l_prin_end_dt   := l_tb_comp_sch(l_comp_sch_indx).g_account_comp_sch.sch_end_date;

                 IF l_amortise_st_date >= l_prin_start_dt AND l_amortise_st_date <= l_prin_end_dt
                    OR l_amortise_end_date >= l_prin_start_dt AND l_amortise_end_date <= l_prin_end_dt
                 THEN
                     dbg('Cannot have amortization and principal Repayment in the same schedule period');
                     l_tb_comp_sch.DELETE;
                     l_tb_amort_comp_sch.DELETE;
                     p_err_code := 'CL-SCH023;';
                      ovpkss.pr_appendTbl(p_err_code,'');
                     RETURN FALSE;
                 END IF;
             END IF;
             l_comp_sch_indx := l_tb_comp_sch.NEXT(l_comp_sch_indx);
         END LOOP;
          l_amort_indx := l_tb_amort_comp_sch.NEXT(l_amort_indx);
      END LOOP;*/

      Dbg('End of the function fn_validate_schedules');

      l_Tb_Comp_Sch.DELETE;
      l_Tb_For_Disbr.DELETE;

      RETURN TRUE;

   EXCEPTION
      WHEN OTHERS THEN

         l_Tb_Account_Comp_Sch.DELETE;
         l_Tb_Comp_Sch.DELETE;
         --l_tb_comp_date.DELETE;

         Clpkss_Logger.Pr_Log_Exception('');

         Debug.Pr_Debug('**'
                       ,'In When others of function fn_validate_schedules - ' || SQLERRM);
         p_Err_Code  := 'CL-SCH036;';
         p_Err_Param := 'fn_validate_schedules~;';
         Ovpkss.Pr_Appendtbl(p_Err_Code, p_Err_Param);
         RETURN FALSE;
   END Fn_Gen_Validate_Schedules;

   FUNCTION Fn_Add_Months(p_Date_In      IN DATE
                         ,p_Months_Shift IN NUMBER) RETURN DATE IS

      Return_Value DATE;
      Day_Of_Month VARCHAR2(2);
      Month_Year   VARCHAR2(6);
      End_Of_Month DATE;

   BEGIN
      Return_Value := Add_Months(p_Date_In, p_Months_Shift);
      IF p_Date_In = Last_Day(p_Date_In) THEN
         Day_Of_Month := Least(To_Char(Return_Value, 'DD'), To_Char(p_Date_In, 'DD'));
         --  Log#112 Retro - FCCRUSSIA IMPSUPP SFR-310: Date Format related changes
         --month_year   := TO_CHAR(return_value,'MMYYYY');
         --end_of_month := TO_DATE(month_year || day_of_month, 'MMYYYYDD');
         Month_Year   := To_Char(Return_Value, 'MMRRRR');
         End_Of_Month := To_Date(Month_Year || Day_Of_Month, 'MMRRRRDD');
         --  Log#112 till here
         Return_Value := Least(End_Of_Month, Return_Value);
      END IF;

      RETURN Return_Value;
   EXCEPTION
      WHEN OTHERS THEN
         Dbg('Error in function fn_add_months - ' || SQLERRM);
         RETURN NULL;
   END Fn_Add_Months;

   FUNCTION Fn_Get_Final_Schedule_Date(p_Source_Date  IN DATE
                                      ,p_Branch_Code  IN Cltbs_Account_Master.Branch_Code%TYPE
                                      ,p_Product_Code IN Cltbs_Account_Master.Product_Code%TYPE
                                      ,
                                       -- Sudharshan: Mar 17,2005
                                       --p_ignore_holiday     IN cltbs_account_master.ignore_holidays%TYPE,
                                       p_Ignore_Holiday IN Cltms_Product.Ignore_Holidays%TYPE
                                      ,
                                       -- Sudharshan: Mar 17,2005
                                       p_Forward_Backward  IN Cltms_Product.Schedule_Movement%TYPE
                                      ,p_Move_Across_Month IN Cltms_Product.Move_Across_Month%TYPE
                                      ,p_Value_Date        IN Cltbs_Account_Master.Value_Date%TYPE
                                      ,p_Maturity_Date     IN Cltbs_Account_Master.Maturity_Date%TYPE
                                      ,
                                       --CL PHASE II IQA SUPP SFR #85 starts
                                       p_Frequency      IN Cltms_Product_Dflt_Schedules.Frequency%TYPE
                                      ,p_Frequency_Unit IN Cltms_Product_Dflt_Schedules.Frequency_Unit%TYPE
                                      ,
                                       --CL PHASE II IQA SUPP SFR #85 ends
                                       --euro bank retro changes LOG#103 starts
                                       -- start  month end periodicity LOG#102
                                       p_Due_Dates_On_Acc IN Cltbs_Account_Master.Due_Dates_On%TYPE
                                      ,
                                       -- end  month end periodicity LOG#102
                                       --euro bank retro changes LOG#103 ends
                                       p_Schedule_Date IN OUT Cltbs_Account_Schedules.Schedule_Due_Date%TYPE
                                      ,p_Error_Code    IN OUT Ertbs_Msgs.Err_Code%TYPE
                                      ,
                                       --Start Log#116
                                       p_Schedule_Type IN Cltms_Product_Dflt_Schedules.Schedule_Type%TYPE DEFAULT 'P')
   --End Log#116

    RETURN BOOLEAN IS
      l_Bool_Lcl          BOOLEAN := FALSE;
      l_Bool_Hol_Prds     BOOLEAN := FALSE;
      l_Isholiday         VARCHAR2(1);
      l_Is_Prd_Holiday    VARCHAR2(1);
      l_Period_Start_Date DATE;
      l_Period_End_Date   DATE;
      Old_Month_Year      VARCHAR(4);
      New_Month_Year      VARCHAR(4);
      l_Past_Limit        BOOLEAN;
      l_Forward_Backward  VARCHAR2(1);
      --CL PHASE II IQA SUPP SFR #85 starts
      l_Due_Date    DATE;
      l_Dt_Attempt1 DATE;
      l_Dt_Attempt2 DATE;
      --CL PHASE II IQA SUPP SFR #85 ends

      l_Isholiday2 VARCHAR2(1); --Log#55 RaghuR 24-Jun-2005

      l_Rec_Prod Cltms_Product%ROWTYPE; -- Log#121 FC 10.1 LS Changes

   BEGIN
      p_Schedule_Date := p_Source_Date;
      IF Nvl(p_Ignore_Holiday, 'N') = 'N' THEN

         l_Rec_Prod := Clpkss_Cache.Fn_Product(p_Product_Code); -- Log#121 FC 10.1 LS Changes
         IF (l_Rec_Prod.Holiday_Check = 'L' AND l_Rec_Prod.Holiday_Ccy_Sch IS NULL) -- Log#121 FC 10.1 LS Changes
          THEN

            Dbg('checking for holidays');
            l_Bool_Lcl := Clpkss_Util.Fn_Isholiday(p_Source_Date
                                                  ,p_Branch_Code
                                                  ,l_Isholiday);
            Dbg('l_isholiday : ' || l_Isholiday);
            -- START Log#116
            IF p_Schedule_Type = 'P' THEN
               Dbg('Extra Param Added line No : 4495-Checking for P First Time');
               -- END Log#116

               l_Bool_Hol_Prds := Clpkss_Util.Fn_Falls_In_Holiday_Period(p_Source_Date
                                                                        ,p_Product_Code
                                                                        ,l_Period_Start_Date
                                                                        ,l_Period_End_Date
                                                                        ,
                                                                         --CL PHASE II IQA SUPP SFR #85 starts
                                                                         p_Frequency
                                                                        ,p_Frequency_Unit
                                                                        ,p_Maturity_Date
                                                                        ,l_Due_Date
                                                                        ,
                                                                         --CL PHASE II IQA SUPP SFR #85 ends
                                                                         l_Is_Prd_Holiday);
               -- START Log#116
            ELSE
               Dbg('Extra Param Added line No : 4508-Checking for NOT P First Time');
               l_Bool_Hol_Prds  := TRUE;
               l_Is_Prd_Holiday := '*';
            END IF;
            -- END Log#116

            IF (l_Bool_Lcl = FALSE OR l_Bool_Hol_Prds = FALSE) THEN
               Dbg('Result ' || l_Isholiday);
               p_Error_Code := 'CL-SCH001;';
               Ovpkss.Pr_Appendtbl(p_Error_Code, '');
               Dbg('Unable to get next working date for branch code = ' || p_Branch_Code ||
                   ' and source date = ' || p_Source_Date);
               RETURN(FALSE);
            END IF;

            --Log#55 RaghuR 24-Jun-2005 Start
            IF l_Is_Prd_Holiday = 'H' THEN
               l_Bool_Lcl := Clpkss_Util.Fn_Isholiday(l_Due_Date
                                                     ,p_Branch_Code
                                                     ,l_Isholiday2);
               Dbg('isholiday of holidayperiod due date ::' || l_Isholiday2);
               IF (l_Bool_Lcl = FALSE) THEN
                  Dbg('Result ' || l_Isholiday);
                  p_Error_Code := 'CL-SCH001;';
                  Ovpkss.Pr_Appendtbl(p_Error_Code, '');
                  Dbg('Unable to get next working date for branch code = ' ||
                      p_Branch_Code || ' and source date = ' || l_Due_Date);
                  RETURN(FALSE);
               END IF;
               p_Schedule_Date := l_Due_Date;
            ELSE
               l_Due_Date := p_Source_Date;
            END IF;
            --Log#55 RaghuR 24-Jun-2005 End

            IF l_Isholiday = 'H' OR l_Isholiday2 = 'H' --l_is_prd_holiday = 'H' --RaghuR
             THEN
               Dbg('its holiday so calling fn_getworkingday');
               p_Schedule_Date := Clpkss_Util.Fn_Getworkingday(p_Branch_Code
                                                              ,
                                                               -- p_source_date, --Log#55 RaghuR 24-Jun-2005
                                                               l_Due_Date
                                                              , --Log#55 RaghuR 24-Jun-2005
                                                               p_Product_Code
                                                              ,p_Forward_Backward
                                                              ,
                                                               --CL PHASE II IQA SUPP SFR #85 starts
                                                               p_Frequency
                                                              ,p_Frequency_Unit
                                                              ,p_Maturity_Date
                                                              ,
                                                               --CL PHASE II IQA SUPP SFR #85 ends
                                                               p_Value_Date + 1
                                                              ,p_Maturity_Date
                                                              ,l_Past_Limit);
               Dbg('fn_get_working date returned ' || p_Schedule_Date);
               l_Dt_Attempt1 := p_Schedule_Date;

               IF (p_Schedule_Date IS NULL) THEN
                  IF (NOT l_Past_Limit) THEN
                     p_Error_Code := 'CL-SCH002;';
                     Ovpkss.Pr_Appendtbl(p_Error_Code, '');
                     Dbg('Unable to get next working date for p_branch_code = ' ||
                         p_Branch_Code || ' and source date = ' || p_Source_Date ||
                         ' and FWD/BWD = ' || p_Forward_Backward);
                     RETURN(FALSE);
                  ELSE
                     p_Schedule_Date := p_Source_Date;
                     RETURN(TRUE);
                  END IF;
               END IF;
               IF (p_Move_Across_Month = 'N') THEN
                  Old_Month_Year := To_Char(p_Source_Date, 'MMYY');
                  New_Month_Year := To_Char(p_Schedule_Date, 'MMYY');

                  IF Old_Month_Year <> New_Month_Year THEN
                     p_Schedule_Date := p_Source_Date;

                     IF (p_Forward_Backward = 'N') THEN
                        l_Forward_Backward := 'P';
                     ELSE
                        l_Forward_Backward := 'N';
                     END IF;
                     Dbg('no moving across months..switching the movment flags and calling fn_getworkingday once again');
                     p_Schedule_Date := Clpkss_Util.Fn_Getworkingday(p_Branch_Code
                                                                    ,p_Source_Date
                                                                    ,p_Product_Code
                                                                    ,l_Forward_Backward
                                                                    ,
                                                                     --CL PHASE II IQA SUPP SFR #85 starts
                                                                     p_Frequency
                                                                    ,p_Frequency_Unit
                                                                    ,p_Maturity_Date
                                                                    ,
                                                                     --CL PHASE II IQA SUPP SFR #85 ends
                                                                     p_Value_Date + 1
                                                                    ,p_Maturity_Date
                                                                    ,l_Past_Limit);
                     l_Dt_Attempt2   := p_Schedule_Date;

                     Dbg('got ' || p_Schedule_Date || ' this time');

                     IF (p_Schedule_Date IS NULL) THEN
                        IF (NOT l_Past_Limit) THEN
                           --p_holiday_chk_failed := TRUE;
                           p_Error_Code := 'CL-SCH002;';
                           Ovpkss.Pr_Appendtbl(p_Error_Code, '');
                           Dbg('Unable to get next working date for p_branch_code ccy 4= ' ||
                               p_Branch_Code || ' and source date = ' || p_Source_Date ||
                               ' and FWD/BWD = ' || p_Forward_Backward);
                           RETURN(FALSE);
                        ELSE
                           p_Schedule_Date := p_Source_Date;
                           RETURN(TRUE);
                        END IF;
                     END IF;

                     Old_Month_Year := To_Char(p_Source_Date, 'MMYY');
                     New_Month_Year := To_Char(p_Schedule_Date, 'MMYY');
                     IF Old_Month_Year <> New_Month_Year THEN
                        --this is a deadlock situation.Has to move forward in this case
                        Dbg('Cornered!!!...Go forward now');
                        IF (p_Forward_Backward = 'N') THEN
                           p_Schedule_Date := l_Dt_Attempt1;
                        ELSE
                           p_Schedule_Date := l_Dt_Attempt2;
                        END IF;
                        Dbg('will return ' || p_Schedule_Date);
                     END IF;
                  END IF;
               END IF;
            END IF;

            -- Log#121 FC 10.1 LS Changes Starts
         ELSIF (l_Rec_Prod.Holiday_Check = 'C' AND l_Rec_Prod.Holiday_Ccy_Sch IS NOT NULL) OR
               (l_Rec_Prod.Holiday_Check = 'B' AND l_Rec_Prod.Holiday_Ccy_Sch IS NOT NULL) THEN
            IF NOT Cepkss_Date.Fn_Isholiday_Mccy('CCY'
                                                ,l_Rec_Prod.Holiday_Ccy_Sch
                                                ,l_Rec_Prod.Consider_Branch_Holiday_Sch
                                                ,p_Source_Date
                                                ,l_Isholiday) THEN
               Dbg('clpks_schedules. ->Result ' || l_Isholiday);

               p_Error_Code := 'CL-SCH001;';

               Dbg('clpks_schedules.fn_get_final_schedule_date->Unable to get next working date for holiday ccy = ' ||
                   l_Rec_Prod.Holiday_Ccy_Sch || ' and source date = ' || p_Source_Date);

               RETURN(FALSE);
            END IF;

            l_Bool_Hol_Prds := Clpkss_Util.Fn_Falls_In_Holiday_Period(p_Source_Date
                                                                     ,p_Product_Code
                                                                     ,l_Period_Start_Date
                                                                     ,l_Period_End_Date
                                                                     ,p_Frequency
                                                                     ,p_Frequency_Unit
                                                                     ,p_Maturity_Date
                                                                     ,l_Due_Date
                                                                     ,l_Is_Prd_Holiday);

            IF l_Is_Prd_Holiday = 'H' THEN
               l_Bool_Lcl := Clpkss_Util.Fn_Isholiday(l_Due_Date
                                                     ,p_Branch_Code
                                                     ,l_Isholiday2);
               Dbg('isholiday of holidayperiod due date ::' || l_Isholiday2);
               IF (l_Bool_Lcl = FALSE) THEN
                  Dbg('Result ' || l_Isholiday);
                  p_Error_Code := 'CL-SCH001;';
                  Ovpkss.Pr_Appendtbl(p_Error_Code, '');
                  Dbg('Unable to get next working date for branch code = ' ||
                      p_Branch_Code || ' and source date = ' || l_Due_Date);
                  RETURN(FALSE);
               END IF;
               p_Schedule_Date := l_Due_Date;
            ELSE
               l_Due_Date := p_Source_Date;
            END IF;

            IF l_Isholiday = 'H' OR l_Isholiday2 = 'H' THEN
               p_Schedule_Date := Cepkss_Date.Fn_Getworkingday_Mccy('CCY'
                                                                   ,l_Rec_Prod.Holiday_Ccy_Sch
                                                                   ,l_Rec_Prod.Consider_Branch_Holiday_Sch
                                                                   ,l_Due_Date
                                                                   ,p_Forward_Backward
                                                                   ,1
                                                                   ,p_Value_Date + 1
                                                                   ,p_Maturity_Date
                                                                   ,l_Past_Limit);

               Dbg('ldpks_schedules.fn_get_final_schedule_date->NWD 1' || '---> ' ||
                   p_Schedule_Date);
            ELSE
               Dbg('The schedule date is a working day.. so no change reqd.. ');
               RETURN TRUE;
            END IF;
            l_Dt_Attempt1 := p_Schedule_Date;

            IF (p_Schedule_Date IS NULL) THEN
               IF (NOT l_Past_Limit) THEN
                  p_Error_Code := 'CL-SCH002;';
                  Ovpkss.Pr_Appendtbl(p_Error_Code, '');
                  Dbg('Unable to get next working date for p_branch_code = ' ||
                      p_Branch_Code || ' and source date = ' || p_Source_Date ||
                      ' and FWD/BWD = ' || p_Forward_Backward);
                  RETURN(FALSE);
               ELSE
                  p_Schedule_Date := p_Source_Date;
                  RETURN(TRUE);
               END IF;
            END IF;

            IF (p_Move_Across_Month = 'N') THEN
               Old_Month_Year := To_Char(p_Source_Date, 'MMYY');
               New_Month_Year := To_Char(p_Schedule_Date, 'MMYY');

               IF Old_Month_Year <> New_Month_Year THEN
                  p_Schedule_Date := p_Source_Date;
                  IF (p_Forward_Backward = 'N') THEN
                     l_Forward_Backward := 'P';
                  ELSE
                     l_Forward_Backward := 'N';
                  END IF;
                  Dbg('no moving across months..switching the movment flags and calling fn_getworkingday once again');
                  p_Schedule_Date := Cepkss_Date.Fn_Getworkingday_Mccy('CCY'
                                                                      ,l_Rec_Prod.Holiday_Ccy_Sch
                                                                      ,l_Rec_Prod.Consider_Branch_Holiday_Sch
                                                                      ,p_Source_Date
                                                                      ,l_Forward_Backward
                                                                      ,1
                                                                      ,p_Value_Date + 1
                                                                      ,p_Maturity_Date
                                                                      ,l_Past_Limit);
                  l_Dt_Attempt2   := p_Schedule_Date;
                  Dbg('got ' || p_Schedule_Date || ' this time');

                  IF (p_Schedule_Date IS NULL) THEN
                     IF (NOT l_Past_Limit) THEN
                        p_Error_Code := 'CL-SCH002;';
                        Ovpkss.Pr_Appendtbl(p_Error_Code, '');
                        Dbg('Unable to get next working date for p_branch_code ccy 4= ' ||
                            p_Branch_Code || ' and source date = ' || p_Source_Date ||
                            ' and FWD/BWD = ' || p_Forward_Backward);
                        RETURN(FALSE);
                     ELSE
                        p_Schedule_Date := p_Source_Date;
                        RETURN(TRUE);
                     END IF;
                  END IF;

                  Old_Month_Year := To_Char(p_Source_Date, 'MMYY');
                  New_Month_Year := To_Char(p_Schedule_Date, 'MMYY');
                  IF Old_Month_Year <> New_Month_Year THEN
                     Dbg('Cornered!!!...Go forward now');
                     IF (p_Forward_Backward = 'N') THEN
                        p_Schedule_Date := l_Dt_Attempt1;
                     ELSE
                        p_Schedule_Date := l_Dt_Attempt2;
                     END IF;
                     Dbg('will return ' || p_Schedule_Date);
                  END IF;
               END IF;
            END IF;
         END IF;
         -- Log#121 FC 10.1 LS Changes Ends

      ELSE
         -- START Log#116
         IF p_Schedule_Type = 'P' THEN
            Dbg('Extra Param Added line No : 4664-Checking for P SECOND Time');
            -- END Log#116

            l_Bool_Hol_Prds := Clpkss_Util.Fn_Falls_In_Holiday_Period(p_Source_Date
                                                                     ,p_Product_Code
                                                                     ,l_Period_Start_Date
                                                                     ,l_Period_End_Date
                                                                     ,
                                                                      --CL PHASE II IQA SUPP SFR #85 starts
                                                                      p_Frequency
                                                                     ,p_Frequency_Unit
                                                                     ,p_Maturity_Date
                                                                     ,l_Due_Date
                                                                     ,
                                                                      --CL PHASE II IQA SUPP SFR #85 ends
                                                                      l_Is_Prd_Holiday);
            --START Log#116
         ELSE
            Dbg('Extra Param Added line No : 4677-Checking for NOT P SECOND Time');
            l_Bool_Hol_Prds  := TRUE;
            l_Is_Prd_Holiday := '*';
         END IF;
         -- END Log#116

         IF (l_Bool_Hol_Prds = FALSE) THEN
            Dbg('Result ' || l_Isholiday);
            p_Error_Code := 'CL-SCH001;';
            Ovpkss.Pr_Appendtbl(p_Error_Code, '');
            Dbg('Unable to get next working date for branch code = ' || p_Branch_Code ||
                ' and source date = ' || p_Source_Date);
            RETURN(FALSE);
         ELSE
            IF l_Is_Prd_Holiday = 'H' THEN
               --CL PHASE II IQA SUPP SFR #85 starts
               --p_schedule_date :=  (l_period_end_date + 1);
               p_Schedule_Date := l_Due_Date;
               --CL PHASE II IQA SUPP SFR #85 ends
            END IF;
         END IF;

      END IF;
      Dbg('End of fn_get_final_schedule_date..returning ' || p_Schedule_Date);
      RETURN TRUE;
   EXCEPTION
      WHEN OTHERS THEN
         Clpkss_Logger.Pr_Log_Exception('');
         Dbg('In When others of function fn_get_final_schedule_date - ' || SQLERRM);
         p_Error_Code := 'CL-SCH003;';
         Ovpkss.Pr_Appendtbl(p_Error_Code, '');
         RETURN FALSE;
   END Fn_Get_Final_Schedule_Date;

   FUNCTION Fn_Get_Next_Schedule_Date(p_Source_Date     IN DATE
                                     ,p_Frequency_Units IN Cltms_Product_Dflt_Schedules.Frequency_Unit%TYPE
                                     ,p_Frequency       IN Cltms_Product_Dflt_Schedules.Frequency%TYPE)
      RETURN DATE IS
      l_Schedule_Date DATE;
      l_Months        NUMBER;
   BEGIN
      IF p_Frequency_Units = 'D' THEN
         l_Schedule_Date := p_Source_Date + p_Frequency;
      ELSIF p_Frequency_Units = 'W' THEN
         l_Schedule_Date := p_Source_Date + p_Frequency * 7;
      ELSE
         IF p_Frequency_Units = 'M' THEN
            l_Months := p_Frequency;
         ELSIF p_Frequency_Units = 'Q' THEN
            l_Months := p_Frequency * 3;
         ELSIF p_Frequency_Units = 'H' THEN
            l_Months := p_Frequency * 6;
         ELSIF p_Frequency_Units = 'Y' THEN
            l_Months := p_Frequency * 12;
         END IF;
         l_Schedule_Date := Fn_Add_Months(p_Source_Date, l_Months);
      END IF;
      RETURN(l_Schedule_Date);
   EXCEPTION
      WHEN OTHERS THEN
         Dbg('Error in fn_get_next_schedule_date - ' || SQLERRM);
         RETURN NULL;
   END Fn_Get_Next_Schedule_Date;

   FUNCTION Fn_Compute_Schedule_Dates(p_Start_Date      IN Cltbs_Account_Comp_Sch.Sch_Start_Date%TYPE
                                     ,p_Value_Date      IN Cltbs_Account_Master.Value_Date%TYPE
                                     ,p_Maturity_Date   IN Cltbs_Account_Master.Maturity_Date%TYPE
                                     ,p_Branch_Code     IN Cltbs_Account_Master.Branch_Code%TYPE
                                     ,p_Product_Code    IN Cltbs_Account_Master.Product_Code%TYPE
                                     ,p_Frequency       IN Cltms_Product_Dflt_Schedules.Frequency%TYPE
                                     ,p_Frequency_Units IN Cltms_Product_Dflt_Schedules.Frequency_Unit%TYPE
                                     ,p_No_Of_Schedules IN Cltbs_Account_Comp_Sch.No_Of_Schedules%TYPE
                                     ,
                                      --Sudharshan Mar 18,2005
                                      --p_ignore_holiday     IN cltbs_account_master.ignore_holidays%TYPE,
                                      p_Ignore_Holiday IN Cltms_Product.Ignore_Holidays%TYPE
                                     ,
                                      --Sudharshan Mar 18,2005
                                      p_Forward_Backward  IN Cltms_Product.Schedule_Movement%TYPE
                                     ,p_Move_Across_Month IN Cltms_Product.Move_Across_Month%TYPE
                                     ,p_Cascade_Movement  IN Cltms_Product.Cascade_Schedules%TYPE
                                     ,p_Due_Dates_On      IN Cltms_Product_Dflt_Schedules.Due_Dates_On%TYPE
                                     ,
                                      --euro bank retro changes LOG#103 starts
                                      -- start month end periodicity LOG#102
                                      p_Due_Dates_On_Acc IN Cltbs_Account_Master.Due_Dates_On%TYPE
                                     ,
                                      -- end month end periodicity LOG#102
                                      --euro bank retro changes LOG#103 ends
                                      p_Ty_Schedule_Date IN OUT Ty_Schedule_Date
                                     ,p_Error_Code       IN OUT Ertbs_Msgs.Err_Code%TYPE
                                     ,
                                      --START Log#116
                                      p_Schedule_Type IN Cltms_Product_Dflt_Schedules.Schedule_Type%TYPE)
   --END Log#116

    RETURN BOOLEAN IS

      l_Schedule_Date DATE;
      --euro bank retro changes LOG#103 starts
      --start  month end periodicity LOG#102
      l_Schedule_Date_Out DATE;
      --end month end periodicity LOG#102
      --euro bank retro changes LOG#103 ends
      l_Final_Schedule_Date DATE;
      l_Source_Date         DATE;
      l_Ignore_Holiday      VARCHAR2(1);
      l_Frequency           NUMBER;
      l_Indx                PLS_INTEGER;
      i                     PLS_INTEGER := 1;
      l_Tb_Schedule_Dates   Ty_Schedule_Date;
      l_Start_Date          DATE;
      l_Flag_Exit           BOOLEAN := FALSE;

      --START Prasanna. EUROBANK. SFR#AAL054-04. 21-Jul-2006.
      --Ignore Holidays unchecked - Billing dates not distributed correctly
      Day_Of_Month VARCHAR2(2);
      Month_Year   VARCHAR2(6);
      End_Of_Month DATE;
      --END Prasanna. EUROBANK. SFR#AAL054-04. 21-Jul-2006.
	  l_update_schdt BOOLEAN := FALSE; --FC10.5STR1 SFR# 1401
	  l_Prd Cltm_Product%ROWTYPE;	--Log#164
	  l_Rec_Prod Cltm_Product%ROWTYPE; --FCUBS11.1 ITR1 SFR#1854
   BEGIN

      Dbg('fn_compute_schedule_dates >>> p_ignore_holiday    ' || p_Ignore_Holiday);
      Dbg('fn_compute_schedule_dates >>> p_forward_backward  ' || p_Forward_Backward);
      Dbg('fn_compute_schedule_dates >>> p_move_across_month ' || p_Move_Across_Month);
      Dbg('fn_compute_schedule_dates >>> p_cascade_movement  ' || p_Cascade_Movement);

      IF p_Frequency_Units = 'B'

        --Start Log#88 on 08-Feb-2006
         OR
         (p_Frequency_Units IN ('D', 'W', 'Q', 'H', 'M', 'Y') AND p_No_Of_Schedules = 1)
      --End Log#88 on 08-Feb-2006

       THEN
         p_Ty_Schedule_Date(1) := p_Maturity_Date;
         l_Ignore_Holiday := p_Ignore_Holiday; --Log#90 on 11-feb-2006
         --RETURN TRUE; --Log#90 on 11-feb-2006

         --RETURN TRUE;  spotfix@22-02-2006 CLITR1  SFR#3
      ELSE
         l_Ignore_Holiday := p_Ignore_Holiday;
      END IF;

      IF p_Start_Date > p_Maturity_Date THEN
         RETURN TRUE;
      END IF;
      --ravi change log # 34 starts
      --This change is for cases when duplicate dates are getting calculated due to holidays.
      --in that case actual number of schedules got will be lesser than p_no_of_schedules.
      --FOR i IN 1 .. p_no_of_schedules
      LOOP
         dbg('Inside Loop :'||i);
         IF i = 1 THEN
            Dbg('$$$$$$$$$$$$$$$$$$$$$$$$$$$$Here$$$$$$$$$$$$$$$$$$$$$');
            l_Schedule_Date := p_Start_Date;
            l_Start_Date    := p_Start_Date; --Log#90 on 11-Feb-2006

         ELSE

            --START Prasanna. EUROBANK. SFR#AAL054-04. 21-Jul-2006.
            --Ignore Holidays unchecked - Billing dates not distributed correctly
            IF p_Due_Dates_On_Acc IS NOT NULL AND
               p_Frequency_Units NOT IN ('B', 'W', 'D') THEN
               l_Schedule_Date := Fn_Get_Next_Schedule_Date(l_Source_Date
                                                           ,p_Frequency_Units
                                                           ,l_Frequency);
            ELSIF p_Due_Dates_On_Acc IS NULL AND p_Due_Dates_On IS NOT NULL AND
                  p_Frequency_Units NOT IN ('B', 'W', 'D') THEN
               l_Schedule_Date := Fn_Get_Next_Schedule_Date(l_Source_Date
                                                           ,p_Frequency_Units
                                                           ,l_Frequency);
            ELSE
               IF p_Frequency_Units NOT IN ('B', 'W', 'D') THEN

                 -- Log#136  Starts Here
                -- Day_Of_Month := To_Char(p_value_date, 'DD');
                  --Day_Of_Month := To_Char(l_Source_Date, 'DD');
                -- Log#136  Ends Here

                  --Log#137  Starts Here
                  IF p_Cascade_Movement = 'Y' THEN
                     Day_Of_Month := To_Char(l_Source_Date, 'DD');
                  ELSE
                       Day_Of_Month := To_Char(p_Value_Date, 'DD');
                  END IF;
                  --Log#137  Ends  Here

                  Month_Year := To_Char(l_Source_Date, 'MMYYYY');
                  BEGIN
                     End_Of_Month := To_Date(Month_Year || Day_Of_Month, 'MMYYYYDD');
                  EXCEPTION
                     WHEN OTHERS THEN
                        End_Of_Month := To_Date(Month_Year || '01', 'MMYYYYDD');
                        End_Of_Month := Last_Day(End_Of_Month);
                  END;

                  Dbg('----------end_of_month--------' || End_Of_Month);

                  l_Schedule_Date := Fn_Get_Next_Schedule_Date(End_Of_Month
                                                              ,p_Frequency_Units
                                                              ,l_Frequency);
               ELSE
                  l_Schedule_Date := Fn_Get_Next_Schedule_Date(l_Source_Date
                                                              ,p_Frequency_Units
                                                              ,l_Frequency);
               END IF;
            END IF;
            --END Prasanna. EUROBANK. SFR#AAL054-04. 21-Jul-2006.
         END IF;
         --euro bank retro changes LOG#103 starts
         --LOG#102 EUROBANK Billing Periodicity changes start
         /*IF p_due_dates_on IS NOT NULL AND p_frequency_units NOT IN ('B','W','D')
         THEN
             IF NOT fn_apply_dueDatesOn_pref(l_schedule_date
                                             ,p_due_dates_on,
                                              p_frequency_units,
                                              l_schedule_date)
             THEN
                 RETURN FALSE;
             END IF;
         END IF;*/
         --LOG#102 EUROBANK Billing Periodicity changes end
         --euro bank retro changes LOG#103 ends

         --euro bank retro changes LOG#103 starts
         --start month end periodicity changes LOG#102
         --if product level and account level due dates are specified then

         IF p_Due_Dates_On_Acc IS NOT NULL AND p_Frequency_Units NOT IN ('B', 'W', 'D') THEN
            g_Date_Flag := 1; ---log#73
            Dbg('inside if condition 1 29-mar-2006::::' || p_Due_Dates_On_Acc || '::::' ||
                p_Due_Dates_On);
            Dbg('printing l_schedule_date::' || l_Schedule_Date || ':' ||
                p_Frequency_Units || ':out:' || l_Schedule_Date);
            IF NOT Fn_Apply_Duedateson_Pref(l_Schedule_Date
                                           ,p_Due_Dates_On_Acc
                                           ,p_Frequency_Units
                                           ,l_Schedule_Date) THEN
               RETURN FALSE;
            END IF;

            --if product level due date is specified and account level due date is not specified then

         ELSIF p_Due_Dates_On_Acc IS NULL AND p_Due_Dates_On IS NOT NULL AND
               p_Frequency_Units NOT IN ('B', 'W', 'D') THEN
            Dbg('inside if condition 2 29-mar-2006::::' || p_Due_Dates_On_Acc || '::::' ||
                p_Due_Dates_On);
            IF NOT Fn_Apply_Duedateson_Pref(l_Schedule_Date
                                           ,p_Due_Dates_On
                                           ,p_Frequency_Units
                                           ,l_Schedule_Date) THEN
               RETURN FALSE;
            END IF;

            /*if l_schedule_date is not null
            then
            return true;
            end if;*/
         END IF;
         --end  month end periodicity changes LOG#102
         --euro bank retro changes LOG#103 ends
         Dbg('fn_compute_schedule_dates >>>l_schedule_date' || l_Schedule_Date);

         --Start Log#90 on 11-Feb-2006 Handle the holiday even if is the first installment.
         --RaghuR 15-Jun-2005 Start FCCCL 1.1 MTR1 SFR #157
         /*
         IF i = 1 AND global.X9$ = 'CLPBDC' AND p_frequency_units <> 'B' --Log#90 on 11-Feb-2006 Add the conditions for units <> 'B'
           THEN
              dbg('not going to check the holiday period as this is the first due date');
              l_final_schedule_date := l_schedule_date;
         --RaghuR 15-Jun-2005 END FCCCL 1.1 MTR1 SFR #157
         ELSE
         */
         --End Log#90 on 11-Feb-2006
           --Log#164  Starts
       l_Prd  := Clpks_Cache.Fn_Product(p_Product_Code);
       IF NVL(l_Prd.OPEN_LINE_LOAN,'N') <> 'Y' and NVL(l_Prd.REVOLVING_TYPE,'N')<> 'Y' THEN
       --Log#164  Ends

         IF NOT Fn_Get_Final_Schedule_Date(l_Schedule_Date
                                          ,p_Branch_Code
                                          ,p_Product_Code
                                          ,l_Ignore_Holiday
                                          ,p_Forward_Backward
                                          ,p_Move_Across_Month
                                          ,p_Value_Date
                                          ,p_Maturity_Date
                                          ,
                                           --CL PHASE II IQA SUPP SFR #85 starts
                                           p_Frequency
                                          ,p_Frequency_Units
                                          ,
                                           --CL PHASE II IQA SUPP SFR #85 ends
                                           --euro bank retro changes LOG#103 starts
                                           -- start month end periodicity LOG#102
                                           p_Due_Dates_On_Acc
                                          ,
                                           -- end month end periodicity LOG#102
                                           --euro bank retro changes LOG#103 ends
                                           l_Final_Schedule_Date
                                          ,p_Error_Code
                                          ,
                                           -- START Log#116
                                           p_Schedule_Type)
         -- END Log#116

          THEN
            RETURN(FALSE);
         END IF;
          --Log#164 Starts
         ELSE
       			l_Final_Schedule_Date := l_Schedule_Date;
         END IF;
          --Log#164  Ends

         --  END IF; --Log#90 on 11-Feb-2006

         Dbg('fn_compute_schedule_dates>>>l_schedule_date returned by fn_get_final_schedule_date ' ||
             l_Final_Schedule_Date);
         --final schedule date is possible on value date for 'D' types.
         IF l_Final_Schedule_Date < p_Value_Date THEN
            p_Error_Code := 'CL-SCH004;';
            Ovpkss.Pr_Appendtbl(p_Error_Code, '');
            p_Ty_Schedule_Date.DELETE;
            RETURN(FALSE);
         END IF;

         Dbg('@@@@@@@@@@@@@@@l_final_schedule_date ' || l_Final_Schedule_Date);
         Dbg('@@@@@@@@@@@@@@@p_maturity_date ' || p_Maturity_Date);
         Dbg('@@@@@@@@@@@@@@@l_tb_schedule_dates.COUNT ' || l_Tb_Schedule_Dates.COUNT);
         Dbg('@@@@@@@@@@@@@@@p_no_of_schedules ' || p_No_Of_Schedules);
	     ---FCUBS11.1 ITR1 SFR#1854 Start
	     l_Rec_Prod          := Clpks_Cache.Fn_Product(p_Product_Code);
	     Dbg('#######p_Product_Code ' || p_Product_Code);
	     Dbg('#######LEASE_TYPE ' || l_Rec_Prod.LEASE_TYPE);
	     Dbg('#######lease_payment_mode ' || l_Rec_Prod.lease_payment_mode);
	     Dbg('#######MODULE_CODE ' || l_Rec_Prod.MODULE_CODE);
		 ---FCUBS11.1 ITR1 SFR#1854 End


         IF l_Final_Schedule_Date > p_Maturity_Date OR
         ---FCUBS11.1 ITR1 SFR#1854 Start
            (l_Final_Schedule_Date = p_Maturity_Date AND
            (NVL(l_Rec_Prod.LEASE_TYPE,'X') = 'F'
            AND NVL(l_Rec_Prod.lease_payment_mode,'X')   = 'A'
            and nvl(l_Rec_Prod.MODULE_CODE,'CL') = 'CL')) OR
		---FCUBS11.1 ITR1 SFR#1854 End
			l_Tb_Schedule_Dates.COUNT = p_No_Of_Schedules OR
            (p_Frequency_Units = 'B' AND p_Frequency = 1) --Log#90 on 11-Feb-2006
          THEN
            Dbg('crossed maturity date ..no of iteration is ' || i);
			--FC10.5STR1 SFR# 1401 begins
			/*l_update_schdt := FALSE;
            IF NOT (l_Final_Schedule_Date >= p_Maturity_Date) THEN
               IF (l_Tb_Schedule_Dates.COUNT = p_No_Of_Schedules AND p_Frequency_Units <> 'B') THEN
                  --Even if the number of iterations have crossed the number of schedules
                  --specified, maturity date might not be reached. This happens in case of
                  --multiple disbursements. So, we will update the latest schedule date (which
                  --is not the maturity date) to the l_Tb_Schedule_Dates variable.
                  dbg('Setting l_update_schdt to true');
                  l_update_schdt := TRUE;
               END IF;
            END IF;*/
            --FC10.5STR1 SFR# 1401 ends
            --EXIT;
            l_Flag_Exit := TRUE;
         END IF;

         Dbg('fn_compute_schedule_dates>>>populating p_ty_schedule_date()' ||
             l_Final_Schedule_Date);
         dbg(p_Frequency_Units||';'||p_Frequency);
         -- Start Log#90 on 11-Feb-2006
         IF p_Frequency_Units = 'B' AND p_Frequency = 1 THEN
            l_Indx := Clpkss_Util.Fn_Hash_Date(l_Final_Schedule_Date);
            l_Tb_Schedule_Dates(l_Indx) := l_Final_Schedule_Date;
         END IF; --End Log#90 on 11-Feb-2006

         --l_indx                      := clpkss_util.fn_hash_date(l_final_schedule_date);
         --l_tb_schedule_dates(l_indx) := l_final_schedule_date;

         --Start LOG#90 on 11-Feb-2006
         /*
         IF i =1 THEN
           l_start_date :=  l_final_schedule_date;
         END IF;
          */
         --End LOG#90 on 11-Feb-2006

         IF p_Ignore_Holiday = 'N' AND p_Cascade_Movement = 'Y' THEN
            l_Source_Date := l_Final_Schedule_Date;
            l_Frequency   := p_Frequency;
         ELSE
            l_Source_Date := l_Start_Date;
            l_Frequency   := (i) * p_Frequency;
         END IF;

         --ravi change log # 34

		 --FC10.5STR1 SFR# 1401
         /*IF l_update_schdt THEN
            --Replacing the existing date in the index by the new schedule date
            --only if its not >= the maturity date.
            l_Tb_Schedule_Dates(l_Indx) := l_Final_Schedule_Date;
         END IF;*/

         EXIT WHEN l_Flag_Exit;

         l_Indx := Clpkss_Util.Fn_Hash_Date(l_Final_Schedule_Date);
         l_Tb_Schedule_Dates(l_Indx) := l_Final_Schedule_Date;

         i := i + 1;
      END LOOP;

      i      := 1;
      l_Indx := l_Tb_Schedule_Dates.FIRST;
      WHILE l_Indx IS NOT NULL LOOP
         p_Ty_Schedule_Date(i) := l_Tb_Schedule_Dates(l_Indx);
         ---
         -- PERF CHANGES Starts
         --            dbg('schedule no '|| i || ' is '||p_ty_schedule_date(i));
         -- PERF CHANGES Ends
         i      := i + 1;
         l_Indx := l_Tb_Schedule_Dates.NEXT(l_Indx);
      END LOOP;
      l_Tb_Schedule_Dates.DELETE;
      RETURN(TRUE);

   EXCEPTION
      WHEN OTHERS THEN
         p_Error_Code := 'CL-SCH005;';
         Ovpkss.Pr_Appendtbl(p_Error_Code, '');
         p_Ty_Schedule_Date.DELETE;
         l_Tb_Schedule_Dates.DELETE;
         Clpkss_Logger.Pr_Log_Exception('');

         Dbg('Bombed in wo of ldpks_schedules.fn_compute_schedule_dates  ' || SQLERRM);
         p_Ty_Schedule_Date.DELETE;
         RETURN FALSE;
   END Fn_Compute_Schedule_Dates;

   FUNCTION Fn_Apply_Amt_Paid(p_Account_Rec IN OUT NOCOPY Clpkss_Object.Ty_Rec_Account
                             ,
                              --START Prasanna FCCCL 1.0 MTR1 SFR#524 9NT252 20-DEC-2004
                              --p_eff_date       IN            cltbs_matdt_chg.effective_date%TYPE,
                              p_Eff_Date IN DATE
                             ,
                              --END Prasanna FCCCL 1.0 MTR1 SFR#524 9NT252 20-DEC-2004
                              p_Tb_Amount_Paid IN Clpks_Schedules.g_Ty_Tb_Amount_Paid
                             ,p_Err_Code       IN OUT Ertbs_Msgs.Err_Code%TYPE
                             ,p_Err_Param      IN OUT Ertbs_Msgs.Message%TYPE)
      RETURN BOOLEAN IS

      l_Tb_Account_Sch Clpkss_Object.Ty_Tb_Amt_Due;
      --l_component_name cltbs_account_schedules.component_name%TYPE;
      l_Amount_Paid    Cltbs_Account_Schedules.Amount_Settled%TYPE;
      l_Amount_Settled Cltbs_Account_Schedules.Amount_Settled%TYPE;
      l_Comp_Indx      Cltbs_Account_Comp_Sch.Component_Name%TYPE;
      l_Comp_Due_Indx  PLS_INTEGER;
      l_Eff_Date_Indx  PLS_INTEGER;
      --
      --  Log#87 Start.
      l_Indx               VARCHAR2(100);
      l_Sch_Due_Date       DATE;
      l_Past_Sch_Cnt       NUMBER;
      l_No_Of_Schedules    NUMBER;
      l_Last_Sch_End_Dt    DATE;
      l_Next_Sch_Date      DATE;
      l_First_Due_Date     DATE;
      l_Sch_End_Date       DATE;
      l_New_Rec_Indx       VARCHAR2(100);
      l_Comp_Sch_Indx      VARCHAR2(64);
      l_Due_Indx           VARCHAR2(64);
      l_Tb_Acct_Sch        Clpkss_Object.Ty_Tb_Amt_Due;
      l_Comp_Rec           Clpkss_Object.Ty_Rec_Components;
      l_First_Psplit_Date  DATE;
      l_Bool               BOOLEAN;
      l_Scheule_Linkage    Cltbs_Account_Schedules.Schedule_Linkage%TYPE;
      l_Eff_Comp_Sch_Rec   Clpkss_Object.Ty_Rec_Account_Comp_Sch;
      l_New_Comp_Sch_Rec   Clpkss_Object.Ty_Rec_Account_Comp_Sch;
      l_Part_Paid_Split_Dt DATE;
      l_Idx_Part_Date      PLS_INTEGER;
      l_Idx_Date           PLS_INTEGER;
      l_Sch_Dt             PLS_INTEGER;
      l_Cascade_Movement   Cltms_Product.Cascade_Schedules%TYPE;
      -- Log#87 End.
      --

   BEGIN
      Dbg('Start of the function fn_apply_amt_paid');

      l_Comp_Indx := p_Account_Rec.g_Tb_Components.FIRST;

      l_Eff_Date_Indx := Clpkss_Util.Fn_Hash_Date(p_Eff_Date);

      WHILE l_Comp_Indx IS NOT NULL LOOP
         -- Check the amount paid only in amount Due

         IF p_Tb_Amount_Paid.EXISTS(l_Comp_Indx) THEN
            --l_amount_paid := p_tb_amount_paid(l_comp_indx).amount_settled;  --  Log#87.
            l_Amount_Paid := p_Tb_Amount_Paid(l_Comp_Indx).Amount_Settled; --  Log#87.
         ELSE
            l_Amount_Paid := 0;
         END IF;

         IF l_Amount_Paid > 0 THEN
            --l_comp_due_indx := l_tb_account_sch.FIRST;
            l_Comp_Due_Indx := l_Eff_Date_Indx;

            l_Tb_Account_Sch := p_Account_Rec.g_Tb_Components(l_Comp_Indx).g_Tb_Amt_Due;
            IF NOT l_Tb_Account_Sch.EXISTS(l_Comp_Due_Indx) THEN
               l_Comp_Due_Indx := l_Tb_Account_Sch.NEXT(l_Comp_Due_Indx);
            END IF;

            WHILE l_Comp_Due_Indx IS NOT NULL LOOP
               IF Nvl(l_Tb_Account_Sch(l_Comp_Due_Indx).g_Amount_Due.Amount_Due, 0) >
                  Nvl(l_Tb_Account_Sch(l_Comp_Due_Indx).g_Amount_Due.Amount_Settled, 0) AND
                  l_Amount_Paid > 0 THEN
                  IF l_Amount_Paid > l_Tb_Account_Sch(l_Comp_Due_Indx)
                  .g_Amount_Due.Amount_Due THEN
                     l_Amount_Settled := l_Tb_Account_Sch(l_Comp_Due_Indx)
                                        .g_Amount_Due.Amount_Due;
                     l_Sch_Due_Date   := l_Tb_Account_Sch(l_Comp_Due_Indx)
                                        .g_Amount_Due.Schedule_Due_Date; --  Log#87.
                  ELSE
                     l_Amount_Settled := l_Amount_Paid;
                     l_Sch_Due_Date   := p_Tb_Amount_Paid(l_Comp_Indx).Schedule_Due_Date; --  Log#87.
                  END IF;

                  l_Tb_Account_Sch(l_Comp_Due_Indx) .g_Amount_Due.Amount_Settled := l_Amount_Settled;

                  -- Log#87 Start.
                  Dbg(' account sch due dt ::' || l_Tb_Account_Sch(l_Comp_Due_Indx)
                      .g_Amount_Due.Schedule_Due_Date || ' l_sch_due_date ::' ||
                      l_Sch_Due_Date);
                  IF l_Tb_Account_Sch(l_Comp_Due_Indx)
                  .g_Amount_Due.Schedule_Due_Date <> l_Sch_Due_Date THEN
                     l_Indx := l_Tb_Account_Sch(l_Comp_Due_Indx)
                              .g_Amount_Due.Schedule_Type ||
                               Clpkss_Util.Fn_Hash_Date(l_Tb_Account_Sch(l_Comp_Due_Indx)
                                                        .g_Amount_Due.Schedule_Linkage
                                                       ,NULL);
                     ---- FC_UBS_V.UM_10.2.0.0.LoanOrigination.1.0 change start
                     IF p_Account_Rec.g_Tb_Components(l_Comp_Indx)
                     .g_Tb_Comp_Sch.EXISTS(l_Indx) THEN
                        -- FC_UBS_V.UM_10.2.0.0.LoanOrigination.1.0 change ends
                        l_First_Psplit_Date := p_Account_Rec.g_Tb_Components(l_Comp_Indx)
                                              .g_Tb_Comp_Sch(l_Indx)
                                              .g_Account_Comp_Sch.First_Due_Date;
                        Dbg(' l_first_Psplit_date ::' || l_First_Psplit_Date);
                        l_Idx_Date := Clpkss_Util.Fn_Hash_Date(l_First_Psplit_Date);
                        -- for partially paid scheudles split again for VAMI.
                        -- log#126 changes start
                        IF NOT l_Tb_Account_Sch.EXISTS(l_Idx_Date) THEN
                           l_Idx_Date := l_Tb_Account_Sch.NEXT(l_Idx_Date);
                        END IF;
                        -- log#126 changes end
                        IF Nvl(l_Tb_Account_Sch(l_Idx_Date).g_Amount_Due.Amount_Settled
                              ,0) <> 0 AND l_Tb_Account_Sch(l_Idx_Date)
                        .g_Amount_Due.Amount_Due <>
                           Nvl(l_Tb_Account_Sch(l_Idx_Date).g_Amount_Due.Amount_Settled
                              ,0) THEN
                           l_Idx_Part_Date := l_Tb_Account_Sch.NEXT(l_Idx_Date);
                           IF l_Idx_Part_Date IS NOT NULL THEN
                              l_Part_Paid_Split_Dt := l_Tb_Account_Sch(l_Idx_Part_Date)
                                                     .g_Amount_Due.Schedule_Due_Date;
                           END IF;
                        END IF;
                        Dbg(' Got l_part_paid_split_dt ::' || l_Part_Paid_Split_Dt);
                        IF l_Part_Paid_Split_Dt IS NOT NULL THEN
                           Dbg('processing for P type ..l_part_paid_split_dt being ' ||
                               l_Part_Paid_Split_Dt);

                           l_Due_Indx := Clpkss_Util.Fn_Hash_Date(l_Part_Paid_Split_Dt);

                           l_Scheule_Linkage := p_Account_Rec.g_Tb_Components(l_Comp_Indx)
                                               .g_Tb_Amt_Due(l_Due_Indx)
                                               .g_Amount_Due.Schedule_Linkage;
                           Dbg(' Got l_scheule_linkage ::' || l_Scheule_Linkage);

                           IF l_Scheule_Linkage IS NULL THEN
                              l_Tb_Acct_Sch.DELETE;
                              p_Err_Code := 'CL-SCH030;';
                              Ovpkss.Pr_Appendtbl(p_Err_Code, '');
                              RETURN FALSE;
                           END IF;

                           l_Comp_Sch_Indx := 'P' ||
                                              Clpkss_Util.Fn_Hash_Date(l_Scheule_Linkage
                                                                      ,NULL);

                           --MTR1 SFR #136 ..change done to take Amortization into consideration
                           --For fully amortized components also P_split date will be returned for Principal,but
                           --there wont be any corresponding row in comp_Sch..need to be handled here..
                           ----CL PHASE II Corfo Related Enahncements
                           IF l_Comp_Indx = Pkg_Principal OR
                              Nvl(l_Comp_Rec.Comp_Det.Component_Type, '*') = 'L' THEN
                              --Phase II NLS changes

                              IF (p_Account_Rec.g_Tb_Components(l_Comp_Indx)
                                 .g_Tb_Amt_Due(l_Due_Indx)
                                 .g_Amount_Due.Schedule_Type IS NULL) THEN
                                 --get the first comp sch that belongs to Principal
                                 l_Comp_Sch_Indx := p_Account_Rec.g_Tb_Components(l_Comp_Indx)
                                                   .g_Tb_Comp_Sch.NEXT(l_Comp_Sch_Indx);
                              END IF;
                           END IF;
                           Dbg('Here entering with l_comp_sch_indx ::' ||
                               l_Comp_Sch_Indx);
                           IF l_Comp_Sch_Indx IS NOT NULL --In case of fully amortized/or amortize being the
                            THEN
                              --last formula there wont be any Principal
                              BEGIN
                                 l_Eff_Comp_Sch_Rec := p_Account_Rec.g_Tb_Components(l_Comp_Indx)
                                                      .g_Tb_Comp_Sch(l_Comp_Sch_Indx);
                                 l_First_Due_Date   := l_Eff_Comp_Sch_Rec.g_Account_Comp_Sch.First_Due_Date;
                                 l_Sch_End_Date     := l_Eff_Comp_Sch_Rec.g_Account_Comp_Sch.Sch_End_Date;
                                 l_No_Of_Schedules  := l_Eff_Comp_Sch_Rec.g_Account_Comp_Sch.No_Of_Schedules;

                              EXCEPTION
                                 WHEN No_Data_Found THEN
                                    p_Err_Code := 'CL-SCH030;';
                                    Ovpkss.Pr_Appendtbl(p_Err_Code, '');
                                    l_Tb_Acct_Sch.DELETE;
                                    RETURN FALSE;
                              END;

                              l_Tb_Acct_Sch := p_Account_Rec.g_Tb_Components(l_Comp_Indx)
                                              .g_Tb_Amt_Due;
                              --l_sch_dt := clpkss_util.fn_hash_date(l_first_due_date);
                              --l_tb_acct_sch(l_sch_dt).g_amount_due.schedule_linkage := l_first_due_date;
                              l_Bool := Fn_Get_Acc_Schs_For_a_Linkage(l_Tb_Acct_Sch
                                                                     ,l_First_Due_Date
                                                                     ,p_Err_Code);
                              IF l_Bool = FALSE THEN
                                 Dbg('fn_get_acc_schs_for_a_linkage returned false');
                                 l_Tb_Acct_Sch.DELETE;
                                 RETURN FALSE;
                              END IF;

                              IF l_Tb_Acct_Sch.COUNT = 0 THEN
                                 Dbg('NO data found in amount due');

                                 l_Tb_Acct_Sch.DELETE;
                                 RETURN FALSE;
                              END IF;

                              Dbg(' l_tb_acct_sch..count ::' || l_Tb_Acct_Sch.COUNT);
                              l_Due_Indx := l_Tb_Acct_Sch.FIRST;

                              l_Past_Sch_Cnt := 0;

                              WHILE l_Due_Indx IS NOT NULL LOOP
                                 IF l_Tb_Acct_Sch(l_Due_Indx)
                                 .g_Amount_Due.Schedule_Due_Date >= l_First_Psplit_Date -- Pick scheduels gretaer than this dat.
                                  THEN
                                    Dbg('Inside due - ' || l_Tb_Acct_Sch(l_Due_Indx)
                                        .g_Amount_Due.Schedule_Due_Date ||
                                        ' l_part_paid_split_dt ::' ||
                                        l_Part_Paid_Split_Dt);

                                    IF l_Tb_Acct_Sch(l_Due_Indx).g_Amount_Due.Schedule_Due_Date <
                                       l_Part_Paid_Split_Dt THEN
                                       -- Storing the last schedule due date which are settled.
                                       Dbg('schedule_due_date smaller than p_eff_date increase count');
                                       l_Past_Sch_Cnt    := l_Past_Sch_Cnt + 1;
                                       l_Last_Sch_End_Dt := l_Tb_Acct_Sch(l_Due_Indx)
                                                           .g_Amount_Due.Schedule_Due_Date;
                                       Dbg('l_past_sch_cnt is ' || l_Past_Sch_Cnt);
                                       --this will be the end date for the existing guy and start date for the next guy

                                    ELSE
                                       l_Next_Sch_Date := l_Tb_Acct_Sch(l_Due_Indx)
                                                         .g_Amount_Due.Schedule_Due_Date;
                                       --this should be the new first_due_date for added comp sch
                                       EXIT;
                                    END IF;
                                 END IF;

                                 l_Due_Indx := l_Tb_Acct_Sch.NEXT(l_Due_Indx);

                              END LOOP;

                              l_New_Comp_Sch_Rec := NULL;

                              Dbg(' l_past_sch_cnt ::' || l_Past_Sch_Cnt);
                              IF l_Past_Sch_Cnt > 0 THEN
                                 l_Bool := Fn_Get_New_Split_Schedules(l_Eff_Comp_Sch_Rec
                                                                     ,l_Last_Sch_End_Dt
                                                                     ,l_Past_Sch_Cnt
                                                                     ,l_Next_Sch_Date
                                                                     ,l_Cascade_Movement
                                                                     ,l_New_Comp_Sch_Rec
                                                                     ,p_Err_Code);

                                 IF l_Bool = FALSE THEN

                                    l_Tb_Acct_Sch.DELETE;

                                    RETURN FALSE;
                                 END IF;

                                 l_New_Rec_Indx := 'P' ||
                                                   Clpkss_Util.Fn_Hash_Date(l_New_Comp_Sch_Rec.g_Account_Comp_Sch.First_Due_Date
                                                                           ,NULL);

                                 p_Account_Rec.g_Tb_Components(l_Comp_Indx) .g_Tb_Comp_Sch.DELETE(l_Comp_Sch_Indx);
                                 p_Account_Rec.g_Tb_Components(l_Comp_Indx) .g_Tb_Comp_Sch(l_Comp_Sch_Indx) := l_Eff_Comp_Sch_Rec;
                                 p_Account_Rec.g_Tb_Components(l_Comp_Indx) .g_Tb_Comp_Sch(l_New_Rec_Indx) := l_New_Comp_Sch_Rec;
                              END IF;

                              l_Tb_Acct_Sch.DELETE;

                           END IF;

                        END IF;
                        -- FC_UBS_V.UM_10.2.0.0.LoanOrigination.1.0 change starts
                     END IF;
                     -- FC_UBS_V.UM_10.2.0.0.LoanOrigination.1.0 change ends
                     l_Tb_Acct_Sch.DELETE;
                     Dbg(' ammmmmmtttt due ::' || l_Tb_Account_Sch(l_Comp_Due_Indx)
                         .g_Amount_Due.Amount_Due || ' l_amount_settled ::' ||
                         l_Amount_Settled);
                     IF Nvl(l_Tb_Account_Sch(l_Comp_Due_Indx).g_Amount_Due.Amount_Settled
                           ,0) <> 0 AND l_Tb_Account_Sch(l_Comp_Due_Indx)
                     .g_Amount_Due.Amount_Due <>
                        Nvl(l_Tb_Account_Sch(l_Comp_Due_Indx).g_Amount_Due.Amount_Settled
                           ,0) THEN
                        l_Tb_Account_Sch(l_Comp_Due_Indx) .g_Amount_Due.Amount_Due := l_Tb_Account_Sch(l_Comp_Due_Indx)
                                                                                     .g_Amount_Due.Amount_Due +
                                                                                      l_Amount_Settled;
                        l_Tb_Account_Sch(l_Comp_Due_Indx) .g_Amount_Due.Schedule_Linkage := l_Tb_Account_Sch(l_Comp_Due_Indx)
                                                                                           .g_Amount_Due.Schedule_Due_Date;
                     END IF;
                     Dbg('comp ::' || l_Comp_Indx || ' sch flag ::' ||
                         l_Tb_Account_Sch(l_Comp_Due_Indx)
                         .g_Amount_Due.Schedule_Type || ' linkage date ::' ||
                         l_Tb_Account_Sch(l_Comp_Due_Indx).g_Amount_Due.Schedule_Linkage);
                     l_Indx := l_Tb_Account_Sch(l_Comp_Due_Indx)
                              .g_Amount_Due.Schedule_Type ||
                               Clpkss_Util.Fn_Hash_Date(l_Tb_Account_Sch(l_Comp_Due_Indx)
                                                        .g_Amount_Due.Schedule_Linkage
                                                       ,NULL);
                     Dbg(' l_indx ::' || l_Indx);
                     IF p_Account_Rec.g_Tb_Components(l_Comp_Indx)
                     .g_Tb_Comp_Sch.EXISTS(l_Indx) THEN
                        p_Account_Rec.g_Tb_Components(l_Comp_Indx) .g_Tb_Comp_Sch(l_Indx) .g_Account_Comp_Sch.Amount := Nvl(p_Account_Rec.g_Tb_Components(l_Comp_Indx)
                                                                                                                            .g_Tb_Comp_Sch(l_Indx)
                                                                                                                            .g_Account_Comp_Sch.Amount
                                                                                                                           ,0) +
                                                                                                                        l_Amount_Settled;
                     END IF;
                     --dbg(' comp sch amounttttt ::'||p_account_rec.g_tb_components(l_comp_indx).g_tb_comp_sch(l_indx).g_account_comp_sch.amount);                 -- FC_UBS_V.UM_10.2.0.0.LoanOrigination.1.0 change
                  END IF;
                  -- Log#87 End.

                  l_Amount_Paid := l_Amount_Paid - l_Amount_Settled;

                  EXIT WHEN l_Amount_Paid <= 0;

               END IF;

               l_Comp_Due_Indx := l_Tb_Account_Sch.NEXT(l_Comp_Due_Indx);

            END LOOP;

            p_Account_Rec.g_Tb_Components(l_Comp_Indx) .g_Tb_Amt_Due := l_Tb_Account_Sch;

            l_Tb_Account_Sch.DELETE;

         END IF;

         l_Comp_Indx := p_Account_Rec.g_Tb_Components.NEXT(l_Comp_Indx);

      END LOOP;

      Dbg('End of the function fn_apply_amt_paid ');

      RETURN TRUE;

   EXCEPTION
      WHEN OTHERS THEN
         Dbg('In when others of fn_apply_amt_paid - ' || SQLERRM);
         l_Tb_Account_Sch.DELETE;

         Clpkss_Logger.Pr_Log_Exception('');

         p_Err_Code := 'CL-SCH028;';
         Ovpkss.Pr_Appendtbl(p_Err_Code, '');
         RETURN FALSE;
   END Fn_Apply_Amt_Paid;

   FUNCTION Fn_Amount_Settled(p_Account_Rec IN OUT NOCOPY Clpkss_Object.Ty_Rec_Account
                             ,
                              --START Prasanna FCCCL 1.0 MTR1 SFR#524 9NT252 20-DEC-2004
                              --p_eff_date       IN cltbs_matdt_chg.effective_date%TYPE,
                              p_Eff_Date IN DATE
                             ,
                              --END Prasanna FCCCL 1.0 MTR1 SFR#524 9NT252 20-DEC-2004
                              p_Tb_Amount_Paid OUT Clpks_Schedules.g_Ty_Tb_Amount_Paid
                             ,p_Err_Code       IN OUT Ertbs_Msgs.Err_Code%TYPE
                             ,p_Err_Param      IN OUT Ertbs_Msgs.Message%TYPE)
      RETURN BOOLEAN IS

      l_Amount_Paid Cltbs_Account_Schedules.Amount_Settled%TYPE;
      l_Comp_Indx   Cltbs_Account_Schedules.Component_Name%TYPE;
      --l_comp_due_indx  VARCHAR2(100);
      l_Comp_Due_Indx    PLS_INTEGER;
      l_Comp_Rec         Clpkss_Object.Ty_Rec_Components;
      l_Bool             BOOLEAN;
      p_First_Split_Date DATE;
   BEGIN
      Dbg('Start of the function fn_amount_settled');
      --This function will get the amount settled for
      --first partially paid schedule after effective date
      -- + fully paid schedules

      l_Comp_Indx := p_Account_Rec.g_Tb_Components.FIRST;

      WHILE l_Comp_Indx IS NOT NULL LOOP
         l_Comp_Rec := p_Account_Rec.g_Tb_Components(l_Comp_Indx);

         l_Bool := Fn_Get_Actual_Split_Date(l_Comp_Rec
                                           ,p_Eff_Date
                                           ,'P'
                                           ,p_First_Split_Date
                                           ,p_Err_Code);
         IF l_Bool = FALSE THEN
            p_Tb_Amount_Paid.DELETE;
            RETURN FALSE;
         END IF;

         IF p_First_Split_Date IS NOT NULL THEN

            l_Comp_Due_Indx := Clpkss_Util.Fn_Hash_Date(p_First_Split_Date);

            l_Amount_Paid := 0;

            IF NOT p_Account_Rec.g_Tb_Components(l_Comp_Indx)
            .g_Tb_Amt_Due.EXISTS(l_Comp_Due_Indx) THEN
               --set error code and return false;
               p_Err_Code  := 'CL-SCH029;';
               p_Err_Param := l_Comp_Indx || '~;';
               Ovpkss.Pr_Appendtbl(p_Err_Code, p_Err_Param);
               RETURN FALSE;
            ELSE
               l_Amount_Paid := Nvl(p_Account_Rec.g_Tb_Components(l_Comp_Indx)
                                    .g_Tb_Amt_Due(l_Comp_Due_Indx)
                                    .g_Amount_Due.Amount_Settled
                                   ,0);
               --p_tb_amount_paid(l_comp_indx).amount_settled := l_amount_paid;  --  Log#87.
               p_Tb_Amount_Paid(l_Comp_Indx) .Amount_Settled := l_Amount_Paid; --  Log#87.
               p_Tb_Amount_Paid(l_Comp_Indx) .Schedule_Due_Date := p_Account_Rec.g_Tb_Components(l_Comp_Indx)
                                                                  .g_Tb_Amt_Due(l_Comp_Due_Indx)
                                                                  .g_Amount_Due.Schedule_Due_Date; --  Log#87.
            END IF;
         END IF;
         l_Comp_Indx := p_Account_Rec.g_Tb_Components.NEXT(l_Comp_Indx);
      END LOOP;

      Dbg('End of the function fn_amount_settled ');

      RETURN TRUE;

   EXCEPTION
      WHEN OTHERS THEN
         Dbg('In when others of fn_amount_settled - ' || SQLERRM);

         Clpkss_Logger.Pr_Log_Exception('');

         p_Err_Code := 'CL-SCH029;';
         Ovpkss.Pr_Appendtbl(p_Err_Code, '');

         RETURN FALSE;
   END Fn_Amount_Settled;

   FUNCTION Fn_Populate_Revisions(p_Tb_Revn_Schedules IN Clpkss_Object.Ty_Tb_Account_Comp_Sch
                                 ,p_Account_No        IN Cltbs_Account_Master.Account_Number%TYPE
                                 ,p_Branch_Code       IN Cltbs_Account_Master.Branch_Code%TYPE
                                 ,p_Product_Code      IN Cltbs_Account_Master.Product_Code%TYPE
                                 ,p_Comp_Det          IN Cltbs_Account_Components%ROWTYPE
                                 ,p_Value_Date        IN Cltbs_Account_Master.Value_Date%TYPE
                                 ,p_Maturity_Date     IN Cltbs_Account_Master.Maturity_Date%TYPE
                                 ,
                                  --Sudharshan Mar 18,2005
                                  --p_ignore_holiday     IN cltbs_account_master.ignore_holidays%TYPE,
                                  p_Ignore_Holiday IN Cltms_Product.Ignore_Holidays%TYPE
                                 ,
                                  --Sudharshan Mar 18,2005
                                  p_Forward_Backward  IN Cltms_Product.Schedule_Movement%TYPE
                                 ,p_Move_Across_Month IN Cltms_Product.Move_Across_Month%TYPE
                                 ,p_Cascade_Movement  IN Cltms_Product.Cascade_Schedules%TYPE
                                 ,p_Out_Tb_Revn_Schs  OUT Clpkss_Object.Ty_Tb_Revn_Schedules
                                 ,p_Error_Code        IN OUT Ertbs_Msgs.Err_Code%TYPE)
      RETURN BOOLEAN IS

      i                        VARCHAR2(100);
      l_Tb_Revn_Schs           Clpkss_Object.Ty_Tb_Revn_Schedules;
      l_Frequency              Cltbs_Account_Comp_Sch.Frequency%TYPE;
      l_Unit                   Cltbs_Account_Comp_Sch.Unit%TYPE;
      l_No_Of_Sch              Cltbs_Account_Comp_Sch.No_Of_Schedules%TYPE;
      l_Sch_Defn_Start_Date    DATE;
      l_Tb_Schedule_Date       Clpks_Schedules.Ty_Schedule_Date;
      l_Bool                   BOOLEAN;
      l_Schedule_Start_Date    DATE;
      l_Prev_Schedule_End_Date DATE;
      l_Indx                   PLS_INTEGER;
      l_Component              Cltbs_Account_Components.Component_Name%TYPE;
      l_First_Due_Date         DATE;
      l_Due_Dates_On           Cltms_Product_Dflt_Schedules.Due_Dates_On%TYPE;
   BEGIN
      Dbg('Start of the function fn_populate_revisions');

      l_Component := p_Comp_Det.Component_Name;
      i           := p_Tb_Revn_Schedules.FIRST;
      WHILE i IS NOT NULL LOOP

         l_Frequency           := p_Tb_Revn_Schedules(i).g_Account_Comp_Sch.Frequency;
         l_Unit                := p_Tb_Revn_Schedules(i).g_Account_Comp_Sch.Unit;
         l_No_Of_Sch           := p_Tb_Revn_Schedules(i)
                                 .g_Account_Comp_Sch.No_Of_Schedules;
         l_First_Due_Date      := p_Tb_Revn_Schedules(i)
                                 .g_Account_Comp_Sch.First_Due_Date;
         l_Sch_Defn_Start_Date := p_Tb_Revn_Schedules(i)
                                 .g_Account_Comp_Sch.Sch_Start_Date;
         l_Due_Dates_On        := p_Tb_Revn_Schedules(i).g_Account_Comp_Sch.Due_Dates_On;

         Dbg(l_Frequency || '~' || l_Unit || '~' || l_No_Of_Sch || '~' ||
             l_First_Due_Date);

         l_Bool := Fn_Compute_Schedule_Dates(l_First_Due_Date
                                            ,p_Value_Date
                                            ,p_Maturity_Date
                                            ,p_Branch_Code
                                            ,p_Product_Code
                                            ,l_Frequency
                                            ,l_Unit
                                            ,l_No_Of_Sch
                                            ,p_Ignore_Holiday
                                            ,p_Forward_Backward
                                            ,p_Move_Across_Month
                                            ,p_Cascade_Movement
                                            ,l_Due_Dates_On
                                            ,
                                             --euro bank retro changes LOG#103 starts
                                             -- start  month end periodicity LOG#102
                                             NULL
                                            ,
                                             -- end month end periodicity LOG#102
                                             --euro bank retro changes LOG#103 ends
                                             l_Tb_Schedule_Date
                                            ,p_Error_Code
                                            ,
                                             --START Log#116
                                             'R');
         --END Log#116

         IF l_Bool = FALSE THEN
            --error code as set by fn_compute_schedule_dates
            RETURN FALSE;
         END IF;

         FOR j IN l_Tb_Schedule_Date.FIRST .. l_Tb_Schedule_Date.LAST LOOP
            IF (j = 1) THEN
               l_Schedule_Start_Date := l_Sch_Defn_Start_Date;
            ELSE
               l_Schedule_Start_Date := l_Prev_Schedule_End_Date;
            END IF;
            l_Indx := Clpkss_Util.Fn_Hash_Date(l_Tb_Schedule_Date(j));
            l_Tb_Revn_Schs(l_Indx) .g_Revn_Schedules.Account_Number := p_Account_No;
            l_Tb_Revn_Schs(l_Indx) .g_Revn_Schedules.Branch_Code := p_Branch_Code;
            l_Tb_Revn_Schs(l_Indx) .g_Revn_Schedules.Component_Name := l_Component;
            l_Tb_Revn_Schs(l_Indx) .g_Revn_Schedules.Schedule_St_Date := l_Schedule_Start_Date;
            l_Tb_Revn_Schs(l_Indx) .g_Revn_Schedules.Schedule_Due_Date := l_Tb_Schedule_Date(j);
            l_Tb_Revn_Schs(l_Indx) .g_Revn_Schedules.Applied_Flag := NULL;
            l_Tb_Revn_Schs(l_Indx) .g_Revn_Schedules.Schedule_Linkage := l_First_Due_Date;
            l_Tb_Revn_Schs(l_Indx) .g_Record_Rowid := NULL;
            l_Tb_Revn_Schs(l_Indx) .g_Action := 'I';

            l_Prev_Schedule_End_Date := l_Tb_Schedule_Date(j);
         END LOOP;
         l_Tb_Schedule_Date.DELETE;
         i := p_Tb_Revn_Schedules.NEXT(i);
      END LOOP;

      p_Out_Tb_Revn_Schs := l_Tb_Revn_Schs;
      l_Tb_Revn_Schs.DELETE;

      Dbg('returning true from fn_populate_revisions');

      RETURN TRUE;
   EXCEPTION
      WHEN OTHERS THEN
         p_Error_Code := 'CL-SCH012;';
         Ovpkss.Pr_Appendtbl(p_Error_Code, '');
         l_Tb_Revn_Schs.DELETE;
         l_Tb_Schedule_Date.DELETE;

         Clpkss_Logger.Pr_Log_Exception('');

         Dbg('Error in function fn_populate_revisions - ' || SQLERRM);
         RETURN FALSE;
   END Fn_Populate_Revisions;

   FUNCTION Fn_Populate_Disbursments(p_Tb_Disbr_Schedules IN Clpkss_Object.Ty_Tb_Account_Comp_Sch
                                    ,p_Account_No         IN Cltbs_Account_Master.Account_Number%TYPE
                                    ,p_Branch_Code        IN Cltbs_Account_Master.Branch_Code%TYPE
                                    ,p_Product_Code       IN Cltbs_Account_Master.Product_Code%TYPE
                                    ,p_Comp_Det           IN Cltbs_Account_Components%ROWTYPE
                                    ,p_Value_Date         IN Cltbs_Account_Master.Value_Date%TYPE
                                    ,p_Maturity_Date      IN Cltbs_Account_Master.Maturity_Date%TYPE
                                    ,p_Principal          IN Cltbs_Account_Master.Amount_Financed%TYPE
                                    ,
                                     --Sudharshan :Mar 18,2005
                                     --p_ignore_holiday     IN cltbs_account_master.ignore_holidays%TYPE,
                                     p_Ignore_Holiday IN Cltms_Product.Ignore_Holidays%TYPE
                                    ,
                                     --Sudharshan :Mar 18,2005
                                     p_Forward_Backward  IN Cltms_Product.Schedule_Movement%TYPE
                                    ,p_Move_Across_Month IN Cltms_Product.Move_Across_Month%TYPE
                                    ,p_Cascade_Movement  IN Cltms_Product.Cascade_Schedules%TYPE
                                    ,p_Out_Tb_Disbr_Schs OUT Clpkss_Object.Ty_Tb_Disbr_Schedules
                                    ,p_Error_Code        IN OUT Ertbs_Msgs.Err_Code%TYPE)

    RETURN BOOLEAN IS
      i                        VARCHAR2(100);
      l_Tb_Disbr_Schs          Clpkss_Object.Ty_Tb_Disbr_Schedules;
      l_Frequency              Cltbs_Account_Comp_Sch.Frequency%TYPE;
      l_Unit                   Cltbs_Account_Comp_Sch.Unit%TYPE;
      l_No_Of_Sch              Cltbs_Account_Comp_Sch.No_Of_Schedules%TYPE;
      l_Sch_Defn_Start_Date    DATE;
      l_Tb_Schedule_Date       Clpks_Schedules.Ty_Schedule_Date;
      l_Bool                   BOOLEAN;
      l_Schedule_Start_Date    DATE;
      l_Prev_Schedule_End_Date DATE;
      l_Indx                   PLS_INTEGER;
      l_Component              Cltbs_Account_Components.Component_Name%TYPE;
      l_First_Due_Date         DATE;
      l_Amount                 Cltbs_Account_Comp_Sch.Amount%TYPE := 0;
      l_Total_Disbr_Amt        Cltbs_Account_Master.Amount_Financed%TYPE := 0;
      l_Diff_Amt               Cltbs_Account_Master.Amount_Financed%TYPE;
      l_Flg_Increase           BOOLEAN := FALSE;
      l_Due_Dates_On           Cltms_Product_Dflt_Schedules.Due_Dates_On%TYPE;
   BEGIN
      Dbg('Start of the function fn_populate_disbursments');
      l_Component := p_Comp_Det.Component_Name;
      i           := p_Tb_Disbr_Schedules.FIRST;
      WHILE i IS NOT NULL LOOP

         l_Frequency           := p_Tb_Disbr_Schedules(i).g_Account_Comp_Sch.Frequency;
         l_Unit                := p_Tb_Disbr_Schedules(i).g_Account_Comp_Sch.Unit;
         l_No_Of_Sch           := p_Tb_Disbr_Schedules(i)
                                 .g_Account_Comp_Sch.No_Of_Schedules;
         l_First_Due_Date      := p_Tb_Disbr_Schedules(i)
                                 .g_Account_Comp_Sch.First_Due_Date;
         l_Amount              := Nvl(p_Tb_Disbr_Schedules(i).g_Account_Comp_Sch.Amount
                                     ,0);
         l_Sch_Defn_Start_Date := p_Tb_Disbr_Schedules(i)
                                 .g_Account_Comp_Sch.Sch_Start_Date;

         l_Due_Dates_On := p_Tb_Disbr_Schedules(i).g_Account_Comp_Sch.Due_Dates_On;

         l_Total_Disbr_Amt := l_Total_Disbr_Amt + l_Amount * l_No_Of_Sch;

         Dbg(l_Frequency || '~' || l_Unit || '~' || l_No_Of_Sch || '~' ||
             l_First_Due_Date);

         l_Bool := Fn_Compute_Schedule_Dates(l_First_Due_Date
                                            ,p_Value_Date
                                            ,p_Maturity_Date
                                            ,p_Branch_Code
                                            ,p_Product_Code
                                            ,l_Frequency
                                            ,l_Unit
                                            ,l_No_Of_Sch
                                            ,p_Ignore_Holiday
                                            ,p_Forward_Backward
                                            ,p_Move_Across_Month
                                            ,p_Cascade_Movement
                                            ,l_Due_Dates_On
                                            ,
                                             --euro bank retro changes LOG#103 starts
                                             -- start month end periodicity LOG#102
                                             NULL
                                            ,
                                             -- end month end periodicity LOG#102
                                             --euro bank retro changes LOG#103 ends
                                             l_Tb_Schedule_Date
                                            ,p_Error_Code
                                            ,
                                             -- START Log#116
                                             'D');
         -- END Log#116

         IF l_Bool = FALSE THEN
            RETURN FALSE;
         END IF;

         dbg('l_Sch_Defn_Start_Date: '||l_Sch_Defn_Start_Date);
		 FOR j IN l_Tb_Schedule_Date.FIRST .. l_Tb_Schedule_Date.LAST LOOP
            IF (j = 1) THEN
               l_Schedule_Start_Date := l_Sch_Defn_Start_Date;
            ELSE
               l_Schedule_Start_Date := l_Prev_Schedule_End_Date;
            END IF;

			--FC10.5STR1 SFR# 1401 begins
			/*dbg('j: '||' l_Tb_Schedule_Date(j): '||l_Tb_Schedule_Date(j)||' l_Schedule_Start_Date: '||l_Schedule_Start_Date);
            IF j = 1 THEN
               l_Indx := Clpkss_Util.Fn_Hash_Date(l_Sch_Defn_Start_Date);
            ELSE
                --Taking the prev final sch date if j > 1
                l_Indx := Clpkss_Util.Fn_Hash_Date(l_Tb_Schedule_Date(j-1));
            END IF;
			dbg('l_Indx after: '||l_Indx);
            --FC10.5STR1 SFR# 1401 ends*/

            l_Indx := Clpkss_Util.Fn_Hash_Date(l_Tb_Schedule_Date(j)); --FC10.5STR1 SFR# 1401 - commented
            l_Tb_Disbr_Schs(l_Indx) .g_Disbr_Sch.Account_Number := p_Account_No;
            l_Tb_Disbr_Schs(l_Indx) .g_Disbr_Sch.Branch_Code := p_Branch_Code;
            l_Tb_Disbr_Schs(l_Indx) .g_Disbr_Sch.Component_Name := l_Component;
            l_Tb_Disbr_Schs(l_Indx) .g_Disbr_Sch.Schedule_St_Date := l_Schedule_Start_Date;
            l_Tb_Disbr_Schs(l_Indx) .g_Disbr_Sch.Schedule_Due_Date := l_Tb_Schedule_Date(j);
            l_Tb_Disbr_Schs(l_Indx) .g_Disbr_Sch.Amount_To_Disbr := Nvl(l_Amount, 0);
            l_Tb_Disbr_Schs(l_Indx) .g_Disbr_Sch.Schedule_Linkage := l_First_Due_Date;
            l_Tb_Disbr_Schs(l_Indx) .g_Record_Rowid := NULL;
            l_Tb_Disbr_Schs(l_Indx) .g_Action := 'I';
            l_Prev_Schedule_End_Date := l_Tb_Schedule_Date(j);
         END LOOP;
         l_Tb_Schedule_Date.DELETE;
         i := p_Tb_Disbr_Schedules.NEXT(i);
      END LOOP;
      --Log#154 Abhishek Starts 17.12.2009
      IF c3pk#_prd_shell.fn_get_contract_info(  p_Account_No
                                              , p_Branch_Code
      		                                    ,'LOAN_TYPE'
                                              ,NULL
      		                                    )<>'R'
      THEN
      --Log#154 Abhishek Ends 17.12.2009
          l_Diff_Amt := Abs(p_Principal - l_Total_Disbr_Amt);
          IF l_Total_Disbr_Amt < p_Principal THEN
             l_Flg_Increase := TRUE;
          END IF;
          IF l_Diff_Amt > 0 THEN
             l_Indx := l_Tb_Disbr_Schs.LAST;
             WHILE l_Indx IS NOT NULL LOOP
                EXIT WHEN l_Diff_Amt <= 0;
                IF l_Flg_Increase THEN
                   l_Tb_Disbr_Schs(l_Indx) .g_Disbr_Sch.Amount_To_Disbr := l_Tb_Disbr_Schs(l_Indx)
                                                                          .g_Disbr_Sch.Amount_To_Disbr +
                                                                           l_Diff_Amt;
                   EXIT;
                ELSE
                   IF l_Diff_Amt > l_Tb_Disbr_Schs(l_Indx).g_Disbr_Sch.Amount_To_Disbr THEN
                      l_Tb_Disbr_Schs(l_Indx) .g_Disbr_Sch.Amount_To_Disbr := 0;
                   ELSE
                      l_Tb_Disbr_Schs(l_Indx) .g_Disbr_Sch.Amount_To_Disbr := l_Tb_Disbr_Schs(l_Indx)
                                                                             .g_Disbr_Sch.Amount_To_Disbr -
                                                                              l_Diff_Amt;
                   END IF;
                   l_Diff_Amt := l_Diff_Amt - l_Tb_Disbr_Schs(l_Indx)
                                .g_Disbr_Sch.Amount_To_Disbr;
                END IF;
                l_Indx := l_Tb_Disbr_Schs.PRIOR(l_Indx);
             END LOOP;
          END IF;
      END IF;--Log#154 Abhishek Ranajn
      p_Out_Tb_Disbr_Schs := l_Tb_Disbr_Schs;

      l_Tb_Disbr_Schs.DELETE;
      l_Tb_Schedule_Date.DELETE;
      RETURN TRUE;
   EXCEPTION
      WHEN OTHERS THEN
         p_Error_Code := 'CL-SCH013;';
         Ovpkss.Pr_Appendtbl(p_Error_Code, '');

         l_Tb_Disbr_Schs.DELETE;
         l_Tb_Schedule_Date.DELETE;

         Clpkss_Logger.Pr_Log_Exception('');

         Dbg('in when others with ' || SQLERRM);
         RETURN FALSE;
   END Fn_Populate_Disbursments;

   FUNCTION Fn_Populate_Account_Schedules(p_Tb_Payment_Schedules IN Clpkss_Object.Ty_Tb_Account_Comp_Sch
                                         ,p_Account_No           IN Cltbs_Account_Master.Account_Number%TYPE
                                         ,p_Branch_Code          IN Cltbs_Account_Master.Branch_Code%TYPE
                                         ,p_Product_Code         IN Cltbs_Account_Master.Product_Code%TYPE
                                         ,p_Process_No           IN Cltbs_Account_Master.Process_No%TYPE
                                         ,p_Comp_Det             IN Cltbs_Account_Components%ROWTYPE
                                         ,p_Value_Date           IN Cltbs_Account_Master.Value_Date%TYPE
                                         ,p_Maturity_Date        IN Cltbs_Account_Master.Maturity_Date%TYPE
										 ,p_module_code          IN Cltbs_Account_Master.Module_code%TYPE    ---- Log#162 Changes for 11.1 Dev (Payment in Advance)
                                         ,
                                          --Sudharshan Mar 18,2005
                                          --p_ignore_holiday       IN cltbs_account_master.ignore_holidays%TYPE,
                                          p_Ignore_Holiday IN Cltms_Product.Ignore_Holidays%TYPE
                                         ,
                                          --Sudharshan Mar 18,2005
                                          p_Forward_Backward  IN Cltms_Product.Schedule_Movement%TYPE
                                         ,p_Move_Across_Month IN Cltms_Product.Move_Across_Month%TYPE
                                         ,p_Cascade_Movement  IN Cltms_Product.Cascade_Schedules%TYPE
                                         ,p_Out_Tb_Amt_Due    OUT Clpkss_Object.Ty_Tb_Amt_Due
                                         ,p_Out_Tb_Amort_Dues OUT Clpkss_Object.Ty_Tb_Amt_Due
                                         ,
                                          -- START L Anantharaman 11-Apr-2005 FCCCL1.0 PhaseII reduce tenor changes
                                          p_New_Amt_Dues      IN Clpkss_Object.Ty_Tb_Amt_Due
                                         ,p_New_Prin_Amt_Dues IN Clpkss_Object.Ty_Tb_Amt_Due
                                         , -- for amortized principal amount dues
                                          -- END L Anantharaman 11-Apr-2005 FCCCL1.0 PhaseII reduce tenor changes
                                          --START LOG#46 23-May-2005 SFR#1
                                          p_Build_Schs_From IN DATE
                                         ,
                                          --END LOG#46 23-May-2005 SFR#1
                                          --log#111 retro starts
                                          p_Action_Code IN VARCHAR2
                                         ,
                                          --log#111 retro ends
                                          p_Error_Code IN OUT Ertbs_Msgs.Err_Code%TYPE)
      RETURN BOOLEAN IS
      i                        VARCHAR2(100);
      l_Tb_Amt_Due             Clpkss_Object.Ty_Tb_Amt_Due;
      l_Frequency              Cltbs_Account_Comp_Sch.Frequency%TYPE;
      l_Unit                   Cltbs_Account_Comp_Sch.Unit%TYPE;
      l_No_Of_Sch              Cltbs_Account_Comp_Sch.No_Of_Schedules%TYPE;
      l_Sch_Defn_Start_Date    DATE;
      l_Tb_Schedule_Date       Clpks_Schedules.Ty_Schedule_Date;
      l_Bool                   BOOLEAN;
      l_Schedule_Start_Date    DATE;
      l_Prev_Schedule_End_Date DATE;
      l_Indx                   VARCHAR2(100);
      l_First_Due_Date         DATE;
      l_Frm_Name               Cltbs_Account_Comp_Sch.Formula_Name%TYPE;
      l_Amt_Due                Cltbs_Account_Comp_Sch.Amount%TYPE;
      l_Component              Cltbs_Account_Components.Component_Name%TYPE;
      l_Settle_Ccy             Cltbs_Account_Components.Settlement_Ccy%TYPE;
      l_Waive                  Cltbs_Account_Components.Waive%TYPE;
      l_Schedule_Type          Cltbs_Account_Comp_Sch.Schedule_Type%TYPE;
      l_Schedule_Flag          Cltbs_Account_Comp_Sch.Schedule_Flag%TYPE;
      l_Grace_Days             Cltms_Product_Components.Grace_Days%TYPE;
      l_Capitalized            Cltbs_Account_Schedules.Capitalized%TYPE;
      l_Tb_Frm_Names           Clpkss_Util.Ty_Tb_Frm_Names;
      l_Pop_For_Amort_Flg      BOOLEAN := FALSE;
      l_Prod_Comp_Row          Cltms_Product_Components%ROWTYPE;
      l_Formula_Type           Cltms_Product_Components.Formula_Type%TYPE;
      l_Sch_Defn_End_Date      Cltbs_Account_Comp_Sch.Sch_End_Date%TYPE;
      l_Sch_Due_Date           Cltbs_Account_Schedules.Schedule_Due_Date%TYPE;
      l_Prin_Comp              Cltbs_Account_Components.Component_Name%TYPE;
      l_Prin_Frm               Cltms_Product_Comp_Frm.Formula_Name%TYPE;
      l_Err_Param              Ertbs_Msgs.Message%TYPE;
      l_Tb_Amort_Pairs         Clpkss_Cache.Ty_Tb_Amort_Pairs;
      l_Due_Dates_On           Cltms_Product_Dflt_Schedules.Due_Dates_On%TYPE;
      -- START L Anantharaman 11-Apr-2005 FCCCL1.0 PhaseII reduce tenor changes
      l_Rec_Amt_Due Cltbs_Account_Schedules%ROWTYPE;
      -- END L Anantharaman 11-Apr-2005 FCCCL1.0 PhaseII reduce tenor changes -- Since this is never populated, It reduces amount_settled !
      l_Emi_Amount Cltbs_Account_Comp_Sch.Emi_Amount%TYPE := NULL; --29.09.2005 Log#67
      -- Log#127 start
      l_Prin_Grace_Days Cltm_Product_Components.Grace_Days%TYPE;
      -- Log#127 end
      --Log#140 Start changes for Advance and arrears schedules
      l_prd_rec      CLTMS_PRODUCT%ROWTYPE;
       --Log#140 Start changes for Advance and arrears schedules
        --Log#164  Starts
      l_Prd               Cltms_Product%ROWTYPE;
      l_pay_by_date                        Date;
      l_creditdays    cltm_product.creditdays%type;
  --Log#164  Ends

   BEGIN
      Dbg('entered fn_populate_account_schedules ');

      l_Component := p_Comp_Det.Component_Name;

      l_Settle_Ccy := p_Comp_Det.Settlement_Ccy;

      Dbg('component is  ' || l_Component);

      l_Prod_Comp_Row := Clpkss_Cache.Fn_Product_Components(p_Product_Code, l_Component);

      l_Grace_Days := l_Prod_Comp_Row.Grace_Days;

      l_Formula_Type := Nvl(l_Prod_Comp_Row.Formula_Type, '*');

      IF NOT Clpkss_Util.Fn_Get_Amortized_Formulae(l_Tb_Frm_Names, p_Product_Code) THEN
         p_Error_Code := 'CL-SCH037;';
         Ovpkss.Pr_Appendtbl(p_Error_Code, '');
         RETURN FALSE;
      END IF;

      IF NOT Clpkss_Cache.Fn_Get_Amort_Pairs(p_Product_Code, l_Tb_Amort_Pairs) THEN
         RETURN FALSE;
      END IF;

      i := p_Tb_Payment_Schedules.FIRST;
      --Start Log#156 SFR#1621
       l_prd_rec := clpkss_cache.fn_product(p_product_code);
        Dbg('l_prd_rec.LEASE_TYPE is  ' || l_prd_rec.LEASE_TYPE);
        Dbg('l_prd_rec.LEASE_payment_mode is  ' || l_prd_rec.LEASE_payment_mode);
        Dbg('p_Action_Code is  ' || p_Action_Code);

             IF nvl(l_prd_rec.module_code,'##')='LE'
              AND nvl(l_prd_rec.LEASE_TYPE,'#') ='O'  and nvl(l_prd_rec.LEASE_payment_mode,'#') = 'A'
               AND p_Action_Code IN('REDEF','VAMI')
                  THEN
                       Dbg('TEST TEST TEST ');
                      i := p_Tb_Payment_Schedules.NEXT(i);
             END IF ;
       --End Log#156  SFR#1621
      --START Prasanna/Ravi FCC-CL EURO BANK SFR#RAL044-03. 27-DEC-2005
      --WHILE i IS NOT NULL
      WHILE i IS NOT NULL AND p_Tb_Payment_Schedules(i)
      .g_Account_Comp_Sch.Schedule_Type = 'P'
      --END Prasanna/Ravi FCC-CL EURO BANK SFR#RAL044-03. 27-DEC-2005
       LOOP

         l_Frequency      := p_Tb_Payment_Schedules(i).g_Account_Comp_Sch.Frequency;
         l_Unit           := p_Tb_Payment_Schedules(i).g_Account_Comp_Sch.Unit;
         l_No_Of_Sch      := p_Tb_Payment_Schedules(i).g_Account_Comp_Sch.No_Of_Schedules;
         l_First_Due_Date := p_Tb_Payment_Schedules(i).g_Account_Comp_Sch.First_Due_Date;
         l_Frm_Name       := p_Tb_Payment_Schedules(i).g_Account_Comp_Sch.Formula_Name;

         Dbg('$$$$$$$$$$$$$l_frm_name ' || l_Frm_Name);

         l_Amt_Due       := Nvl(p_Tb_Payment_Schedules(i).g_Account_Comp_Sch.Amount, 0);
         l_Schedule_Type := p_Tb_Payment_Schedules(i).g_Account_Comp_Sch.Schedule_Type;

         Dbg('$$$$$$$$$l_schedule_type ' || l_Schedule_Type);

         l_Schedule_Flag       := p_Tb_Payment_Schedules(i)
                                 .g_Account_Comp_Sch.Schedule_Flag;
         l_Capitalized         := p_Tb_Payment_Schedules(i)
                                 .g_Account_Comp_Sch.Capitalized;
         l_Sch_Defn_Start_Date := p_Tb_Payment_Schedules(i)
                                 .g_Account_Comp_Sch.Sch_Start_Date;
         l_Waive               := Nvl(p_Tb_Payment_Schedules(i)
                                      .g_Account_Comp_Sch.Waiver_Flag
                                     ,'N');
         l_Sch_Defn_End_Date   := p_Tb_Payment_Schedules(i)
                                 .g_Account_Comp_Sch.Sch_End_Date;
         --Log#164  Starts
         dbg('assigning the value for due date is ');
            l_Prd  := Clpks_Cache.Fn_Product(p_Product_Code);
            Dbg('processing for first due date ' || l_First_Due_Date);
           if nvl(l_Prd.OPEN_LINE_LOAN,'N')='Y' and l_Unit!='B' and l_Schedule_Type ='P' then
           dbg('inside the IF condition of due date on');

            SELECT to_char(to_date(l_First_Due_Date,'dd-mm-yyyy'),'dd') into l_Due_Dates_On  from dual;
            ELSE
            dbg('inside the ELSE condition of due date on');
         l_Due_Dates_On        := p_Tb_Payment_Schedules(i)
                                 .g_Account_Comp_Sch.Due_Dates_On;

            end if;
             --Log#164  Ends

         Dbg('processing for first due date ' || l_First_Due_Date);

         IF l_Frm_Name IS NOT NULL THEN
            IF l_Tb_Frm_Names.EXISTS(l_Frm_Name) THEN

               l_Pop_For_Amort_Flg := TRUE;

               IF NOT l_Tb_Amort_Pairs.EXISTS(p_Product_Code || l_Component || l_Frm_Name) THEN
                  Dbg('amort pair absent ');
                  RETURN FALSE;
               ELSE
                  l_Prin_Comp := l_Tb_Amort_Pairs(p_Product_Code || l_Component ||
                                                  l_Frm_Name);
               END IF;

            ELSE
               l_Pop_For_Amort_Flg := FALSE;
            END IF;
            Dbg('Amort formula .has to populate for principal comp ' || l_Prin_Comp);
         END IF;

         Dbg(l_Frequency || '~' || l_Unit || '~' || l_No_Of_Sch || '~' ||
             l_First_Due_Date);

         l_Tb_Schedule_Date.DELETE;

         l_Bool := Fn_Compute_Schedule_Dates(l_First_Due_Date
                                            ,

                                             p_Value_Date
                                            ,p_Maturity_Date
                                            ,p_Branch_Code
                                            ,p_Product_Code
                                            ,l_Frequency
                                            ,l_Unit
                                            ,l_No_Of_Sch
                                            ,p_Ignore_Holiday
                                            ,p_Forward_Backward
                                            ,p_Move_Across_Month
                                            ,p_Cascade_Movement
                                            ,l_Due_Dates_On
                                            ,
                                             --euro bank retro changes LOG#103 starts
                                             -- start  month end periodicity LOG#102
                                             NULL
                                            ,
                                             -- end  month end periodicity LOG#102
                                             --euro bank retro changes LOG#103 ends
                                             l_Tb_Schedule_Date
                                            ,p_Error_Code
                                            ,
                                             --START Log#116
                                             l_Schedule_Type);
         --END Log#116

         IF l_Bool = FALSE THEN
            Dbg('fn_compute_schedule_dates returned false');
            RETURN FALSE;
         END IF;

         Dbg('l_formula_type' || l_Formula_Type);
         Dbg('l_prod_comp_row.main_component is ' || l_Prod_Comp_Row.Main_Component);

         --if component is main and type is discounted/true dicounted then
         --there will be only one schedule generated thats on the value date
         IF Nvl(l_Prod_Comp_Row.Main_Component, 'N') = 'Y' AND
            l_Formula_Type IN ('3', '4') THEN
            Dbg('discounted/true discounted..only on schedule on value date');
            l_Tb_Schedule_Date.DELETE;
            l_Tb_Schedule_Date(1) := p_Value_Date;
         END IF;
         --Log#135 Changes Starts
         IF l_Tb_Schedule_Date.COUNT > 0 THEN
            --Log#135 Ends
            FOR j IN l_Tb_Schedule_Date.FIRST .. l_Tb_Schedule_Date.LAST LOOP
               Dbg('computed due date is ' || j || ' ' || l_Tb_Schedule_Date(j));
               IF (j = 1) THEN
                  l_Schedule_Start_Date := l_Sch_Defn_Start_Date;
               ELSE
                  l_Schedule_Start_Date := l_Prev_Schedule_End_Date;
               END IF;
               IF j = l_Tb_Schedule_Date.LAST THEN
                  l_Sch_Due_Date := l_Sch_Defn_End_Date;
               ELSE
                  l_Sch_Due_Date := l_Tb_Schedule_Date(j);
               END IF;

               --Log#164 Starts

   Dbg('Fetching the data for open line loan and credit days.......');
   dbg('value for due dates on is '||l_Due_Dates_On);


   Dbg('open line loan = ' ||l_Prd.OPEN_LINE_LOAN ||'   and credit days'||l_creditdays);


  IF NVL(l_Prd.OPEN_LINE_LOAN,'N') = 'Y' and NVL(l_Prd.REVOLVING_TYPE,'N')= 'Y' THEN
       dbg('inside open line loan');
       dbg('l_Unit'||l_Unit);
       dbg('l_Schedule_Type'||l_Schedule_Type);
       dbg('l_Component'||l_Component);

       IF l_Unit <> 'B' and l_Schedule_Type = 'P'  then
            dbg('inside non-bullet, payment');
            IF  l_Component IN (Pkg_Main_Int,'PRINCIPAL')THEN	--13374562 Changes
                dbg('inside  maint_int/principal loop');
                l_pay_by_date := l_Sch_Due_Date +  Nvl(l_Prd.CREDITDAYS,0);
		--log#177 Starts
		IF l_pay_by_date > p_Maturity_Date THEN
	           l_pay_by_date := p_Maturity_Date;
		END IF;
		--log#177 Ends
            ELSE
                dbg('inside non maint_int/principal loop');

            END IF;
       ELSIF l_Unit = 'B' and l_Schedule_Type = 'P'  then
            dbg('inside bullet, payment, maint_int/principal loop');
            l_pay_by_date := p_Maturity_Date;
       END IF;

       dbg('pay by date = ' || l_pay_by_date);
       dbg('Before assigning index value for due date on' ||l_Due_Dates_On);
       dbg('schedule due date before holiday check is '||l_Sch_Due_Date);
       dbg('pay by date before holiday check is '||l_pay_by_date);

--       p_Ignore_Holiday := 'Y';
       IF NOT Fn_Get_Final_Schedule_Date(l_pay_by_date
                                        ,p_Branch_Code
                                        ,p_Product_Code
                                        ,p_Ignore_Holiday
                                        ,p_Forward_Backward
                                        ,p_Move_Across_Month
                                        ,p_Value_Date
                                        ,p_Maturity_Date
                                        ,l_Frequency
                                        ,l_Unit
                                        ,l_Due_Dates_On
                                        ,l_pay_by_date
                                        ,p_Error_Code
                                        ,l_Schedule_Type)  THEN

       RETURN(FALSE);
       END IF;

  END IF;
        dbg('schedule due date after holiday check is '||l_Sch_Due_Date);
        dbg('pay by date after holiday check is '||l_pay_by_date);
        dbg('SUCCESSFULLY OUT FROM HOLIDAY CHECK CONDITION');
        dbg('Open Line Loans 1.0 9NT1368-FCUBS 11.1 changes end in fn_POPULATE ACCOUNT SCHEDULES');
 --Log#164 Ends


               Dbg('$$$$$$$$$$$$$l_sch_due_date ' || l_Sch_Due_Date);
               Dbg('$$$$$$$$$$$$$p_build_schs_from ' || p_Build_Schs_From);

               --29.09.2005 Starts Log#67
               IF Nvl(l_Prod_Comp_Row.Main_Component, 'N') = 'Y' AND
                  l_Sch_Defn_End_Date <> p_Maturity_Date THEN
                  l_Emi_Amount := p_Tb_Payment_Schedules(i).g_Account_Comp_Sch.Emi_Amount;
               END IF;
               Dbg('@@@@@@ processing for component with emi amount :' || l_Emi_Amount);
               --29.09.2005 Starts Log#67

               -- START LOG#46 23-May-2005 SFR#1
               -- START LOG#47 25-May-2005 SFR#1
               --IF l_sch_due_date >= p_build_schs_from THEN
               l_prd_rec := clpkss_cache.fn_product(p_product_code); --Log#140 changes for Advance and arrears schedules
               IF l_Sch_Due_Date > p_Build_Schs_From OR
               		-- log#175 changes start
               		/***
                  (Nvl(l_Prod_Comp_Row.Main_Component, 'N') = 'Y' AND
                  l_Formula_Type IN ('3', '4'))
                  OR (p_module_code='LE' and l_prd_rec.LEASE_TYPE in ( 'O' , 'F')  and l_prd_rec.LEASE_payment_mode = 'A' and l_sch_due_date >= p_build_schs_from AND p_Action_Code<>'VAMI') --Log#140 changes for Advance and arrears schedules --Log#153 "p_Action_Code <> 'VAMI' " added -- Log#162 Changes for 11.1 Dev (Payment in Advance) module code added
				  OR (p_module_code='CL' and nvl(l_prd_rec.LEASE_TYPE,'#') ='F'  and nvl(l_prd_rec.LEASE_payment_mode,'#') = 'A' and l_sch_due_date >= p_build_schs_from) -- Log#162 Changes for 11.1 Dev (Payment in Advance)
                  OR (Nvl(l_Prod_Comp_Row.INCLUDE_IN_EMI, 'N')='Y' and l_prd_rec.LEASE_payment_mode = 'A' ) --Log#152 sfr1184 changes
                  ***/
                  p_Build_Schs_From = p_Value_Date
                  -- log#175 changes end
                  THEN
                  -- END LOG#47 25-May-2005 SFR#1
                  -- END LOG#46 23-May-2005 SFR#1

                  --log#72 start
                  --l_indx := clpkss_util.fn_hash_date(l_tb_schedule_date(j));
                  l_Indx := Clpkss_Util.Fn_Hash_Date(l_Sch_Due_Date);
                  --log#72 end

                  l_Tb_Amt_Due(l_Indx) .g_Amount_Due.Account_Number := p_Account_No;
                  l_Tb_Amt_Due(l_Indx) .g_Amount_Due.Branch_Code := p_Branch_Code;
                  l_Tb_Amt_Due(l_Indx) .g_Amount_Due.Component_Name := l_Component;
                  l_Tb_Amt_Due(l_Indx) .g_Amount_Due.Formula_Name := l_Frm_Name;

                  --Log#104 FCCL 3.0 IRR Enhancements Start
                  Dbg('$$$$l_tb_amt_due(l_indx) .g_amount_due.formula_name ' ||
                      l_Tb_Amt_Due(l_Indx).g_Amount_Due.Formula_Name);
                  Dbg('p_comp_det.IRR_APPLICABLE' || p_Comp_Det.Irr_Applicable);
                  l_Tb_Amt_Due(l_Indx) .g_Amount_Due.Irr_Applicable := p_Comp_Det.Irr_Applicable;
                  --Log#104 FCCL 3.0 IRR Enhancements End

                  l_Tb_Amt_Due(l_Indx) .g_Amount_Due.Schedule_Type := Nvl(l_Schedule_Type
                                                                         ,'P');
                  l_Tb_Amt_Due(l_Indx) .g_Amount_Due.Schedule_St_Date := l_Schedule_Start_Date;
                  l_Tb_Amt_Due(l_Indx) .g_Amount_Due.Schedule_Due_Date := l_Sch_Due_Date;
                  --Log#164  Starts
                  IF NVL(l_Prd.OPEN_LINE_LOAN,'N') = 'Y' and NVL(l_Prd.REVOLVING_TYPE,'N')= 'Y' THEN
                   dbg('ASSIGNING PAY BY DATE VALUE TO OBJECT');
                  l_Tb_Amt_Due(l_Indx) .g_Amount_Due.pay_by_date :=l_pay_by_date ;---assigned here for pay by date :
                  END IF;
                  --Log#164  Ends
                  l_Tb_Amt_Due(l_Indx) .g_Amount_Due.Grace_Days := Nvl(l_Grace_Days, 0);
                  l_Tb_Amt_Due(l_Indx) .g_Amount_Due.Sch_Status := 'NORM'; --RaghuR 25-May-2005 FCCCL 1.1 MTR1 SFR #53
                  --l_tb_amt_due(l_indx) .g_amount_due.settlement_ccy   := l_settle_ccy;

                  --RAJASEKHAR  log#43
                  l_Tb_Amt_Due(l_Indx) .g_Amount_Due.Settlement_Ccy := Nvl(p_Comp_Det.Component_Ccy
                                                                          ,l_Settle_Ccy); -- clpks_cache.fn_account_master(p_account_no,p_branch_code).currency);
                  --RAJASEKHAR  log#43

                  l_Tb_Amt_Due(l_Indx) .g_Amount_Due.Lcy_Equivalent := NULL;

                  -- START L Anantharaman 11-Apr-2005 FCCCL1.0 PhaseII reduce tenor changes
                  IF NOT p_New_Amt_Dues.EXISTS(l_Indx) THEN
                     l_Tb_Amt_Due(l_Indx) .g_Amount_Due.Orig_Amount_Due := NULL;
                     l_Tb_Amt_Due(l_Indx) .g_Amount_Due.Amount_Due := NULL;
                     l_Tb_Amt_Due(l_Indx) .g_Amount_Due.Adj_Amount := NULL;
                     l_Tb_Amt_Due(l_Indx) .g_Amount_Due.Amount_Waived := NULL; --Log#98 LH Changes
                     --l_tb_amt_due(l_indx) .g_amount_due.amount_settled   := NULL;
                     --log#111 retro starts
                     Dbg('$$$$$$$$$$$$$$$p_action_code :- ' || p_Action_Code);
--RAKBANK Changes FCUBS_113_13634866 starts
IF NOT (clpkss_cache.fn_product(p_product_code).vami_action = 'N' AND clpks_context.g_function_id  in ('CLDVDAMD','CIDVDAMD') ) THEN
--RAKBANK Changes FCUBS_113_13634866 ends
                     IF p_Action_Code IS NULL OR p_Action_Code NOT IN ('DFLT', 'NEW') THEN
                        --log#111 retro ends
                        l_Tb_Amt_Due(l_Indx) .g_Amount_Due.Amount_Settled := Fn_Get_Amt_Settled(p_Branch_Code
                                                                                               ,p_Account_No
                                                                                               ,l_Component
                                                                                               ,l_Sch_Due_Date);
                        --Log#111 retro Start
                     ELSE
                        l_Tb_Amt_Due(l_Indx) .g_Amount_Due.Amount_Settled := 0;
                     END IF;
--RAKBANK Changes FCUBS_113_13634866 starts
ELSE
 l_tb_amt_due(l_indx) .g_amount_due.amount_settled   := 0;
                     END IF;
--RAKBANK Changes  FCUBS_113_13634866 Ends
                     --Log#111 retro End
                     Dbg('GONE CASE................ ' || 'for ' || l_Sch_Due_Date ||
                         ' with ' || l_Tb_Amt_Due(l_Indx)
                         .g_Amount_Due.Amount_Settled || '~' || l_Emi_Amount);
                     l_Tb_Amt_Due(l_Indx) .g_Amount_Due.Amount_Overdue := NULL;
                     l_Tb_Amt_Due(l_Indx) .g_Amount_Due.Accrued_Amount := NULL;
                     l_Tb_Amt_Due(l_Indx) .g_Amount_Due.Dly_Avg_Amt := NULL;
                     --l_tb_amt_due(l_indx) .g_amount_due.emi_amount       := NULL;
                     l_Tb_Amt_Due(l_Indx) .g_Amount_Due.Emi_Amount := l_Emi_Amount; --29.09.2005 Log#67
                     --Log#100 Start. (Gunjan)
                     l_Tb_Amt_Due(l_Indx) .g_Amount_Due.List_Days := NULL;
                     l_Tb_Amt_Due(l_Indx) .g_Amount_Due.List_Avg_Amt := NULL;
                     --Log#100 End. (Gunjan)
                     --Log#104 FCCL 3.0 IRR Enhancements Start
                     --l_tb_amt_due(l_indx) .g_amount_due.IRR_APPLICABLE       :=null;  --log#108 commented
                     --Log#104 FCCL 3.0 IRR Enhancements End

                  ELSE
                     Dbg('shift schedules case');
                     l_Rec_Amt_Due := p_New_Amt_Dues(l_Indx).g_Amount_Due;
                     l_Tb_Amt_Due(l_Indx) .g_Amount_Due.Orig_Amount_Due := l_Rec_Amt_Due.Orig_Amount_Due;
                     l_Tb_Amt_Due(l_Indx) .g_Amount_Due.Amount_Due := l_Rec_Amt_Due.Amount_Due;
                     l_Tb_Amt_Due(l_Indx) .g_Amount_Due.Amount_Waived := l_Rec_Amt_Due.Amount_Waived; --Log#98 LH Changes
                     l_Tb_Amt_Due(l_Indx) .g_Amount_Due.Adj_Amount := l_Rec_Amt_Due.Adj_Amount;
                     l_Tb_Amt_Due(l_Indx) .g_Amount_Due.Amount_Settled := l_Rec_Amt_Due.Amount_Settled;
                     l_Tb_Amt_Due(l_Indx) .g_Amount_Due.Amount_Overdue := l_Rec_Amt_Due.Amount_Overdue;
                     l_Tb_Amt_Due(l_Indx) .g_Amount_Due.Accrued_Amount := l_Rec_Amt_Due.Accrued_Amount;
                     l_Tb_Amt_Due(l_Indx) .g_Amount_Due.Dly_Avg_Amt := l_Rec_Amt_Due.Dly_Avg_Amt;
                     l_Tb_Amt_Due(l_Indx) .g_Amount_Due.Emi_Amount := l_Rec_Amt_Due.Emi_Amount;
                     l_Tb_Amt_Due(l_Indx) .g_Amount_Due.Schedule_No := l_Rec_Amt_Due.Schedule_No; --Log#69
                     --Log#100 Start. (Gunjan)
                     l_Tb_Amt_Due(l_Indx) .g_Amount_Due.List_Days := l_Rec_Amt_Due.List_Days;
                     l_Tb_Amt_Due(l_Indx) .g_Amount_Due.List_Avg_Amt := l_Rec_Amt_Due.List_Avg_Amt;
                     --Log#100 End. (Gunjan)
                     --Log#104 FCCL 3.0 IRR Enhancements Start
                     l_Tb_Amt_Due(l_Indx) .g_Amount_Due.Irr_Applicable := l_Rec_Amt_Due.Irr_Applicable;
                     --Log#104 FCCL 3.0 IRR Enhancements End

                  END IF;
                  -- END L Anantharaman 11-Apr-2005 FCCCL1.0 PhaseII reduce tenor changes

                  l_Tb_Amt_Due(l_Indx) .g_Amount_Due.Schedule_Flag := l_Schedule_Flag;
                  l_Tb_Amt_Due(l_Indx) .g_Amount_Due.Waiver_Flag := l_Waive;
                  l_Tb_Amt_Due(l_Indx) .g_Amount_Due.Schedule_Linkage := l_First_Due_Date;
                  l_Tb_Amt_Due(l_Indx) .g_Amount_Due.Capitalized := l_Capitalized;
                  l_Tb_Amt_Due(l_Indx) .g_Amount_Due.Process_No := p_Process_No;
                  l_Tb_Amt_Due(l_Indx) .g_Record_Rowid := NULL;
                  l_Tb_Amt_Due(l_Indx) .g_Action := 'I';

                  IF l_Pop_For_Amort_Flg = TRUE THEN
                     p_Out_Tb_Amort_Dues(l_Indx) := l_Tb_Amt_Due(l_Indx);
                     p_Out_Tb_Amort_Dues(l_Indx) .g_Amount_Due.Component_Name := l_Prin_Comp;
                     p_Out_Tb_Amort_Dues(l_Indx) .g_Amount_Due.Schedule_Type := NULL;
                     p_Out_Tb_Amort_Dues(l_Indx) .g_Amount_Due.Formula_Name := NULL;
                     p_Out_Tb_Amort_Dues(l_Indx) .g_Amount_Due.Emi_Amount := NULL; --Log#115(retro change)
                     -- Log#127 start
                     l_Prod_Comp_Row := Clpkss_Cache.Fn_Product_Components(p_Product_Code
                                                                          ,l_Prin_Comp);
                     l_Prin_Grace_Days := l_Prod_Comp_Row.Grace_Days;
                     p_Out_Tb_Amort_Dues(l_Indx) .g_Amount_Due.Grace_Days := Nvl(l_Prin_Grace_Days
                                                                                ,0);
                     -- Log#127 end
                     p_Out_Tb_Amort_Dues(l_Indx) .g_Amount_Due.Amount_Settled := NULL; -- log#117 changes
                     p_Out_Tb_Amort_Dues(l_Indx) .g_Amount_Due.Amount_Settled := 0; -- log#119 changes

                     IF p_New_Prin_Amt_Dues.EXISTS(l_Indx) THEN
                        Dbg('shift schedules case');
                        l_Rec_Amt_Due := p_New_Prin_Amt_Dues(l_Indx).g_Amount_Due;
                        p_Out_Tb_Amort_Dues(l_Indx) .g_Amount_Due.Orig_Amount_Due := l_Rec_Amt_Due.Orig_Amount_Due;
                        p_Out_Tb_Amort_Dues(l_Indx) .g_Amount_Due.Amount_Due := l_Rec_Amt_Due.Amount_Due;
                        p_Out_Tb_Amort_Dues(l_Indx) .g_Amount_Due.Amount_Waived := l_Rec_Amt_Due.Amount_Waived; --Log#98 LH Changes
                        p_Out_Tb_Amort_Dues(l_Indx) .g_Amount_Due.Adj_Amount := l_Rec_Amt_Due.Adj_Amount;
                        p_Out_Tb_Amort_Dues(l_Indx) .g_Amount_Due.Amount_Settled := l_Rec_Amt_Due.Amount_Settled;
                        p_Out_Tb_Amort_Dues(l_Indx) .g_Amount_Due.Amount_Overdue := l_Rec_Amt_Due.Amount_Overdue;
                        p_Out_Tb_Amort_Dues(l_Indx) .g_Amount_Due.Accrued_Amount := l_Rec_Amt_Due.Accrued_Amount;
                        p_Out_Tb_Amort_Dues(l_Indx) .g_Amount_Due.Dly_Avg_Amt := NULL;
                        p_Out_Tb_Amort_Dues(l_Indx) .g_Amount_Due.Schedule_No := l_Rec_Amt_Due.Schedule_No; --Log#69
                        --p_out_tb_amort_dues(l_indx) .g_amount_due.emi_amount       := NULL;
                        p_Out_Tb_Amort_Dues(l_Indx) .g_Amount_Due.Emi_Amount := l_Emi_Amount; --29.09.2005 Log#67
                        --Log#100 Start. (Gunjan)
                        p_Out_Tb_Amort_Dues(l_Indx) .g_Amount_Due.List_Days := l_Rec_Amt_Due.List_Days;
                        p_Out_Tb_Amort_Dues(l_Indx) .g_Amount_Due.List_Avg_Amt := l_Rec_Amt_Due.List_Avg_Amt;
                        --Log#100 End. (Gunjan)
                        --Log#104 FCCL 3.0 IRR Enhancements Start
                        p_Out_Tb_Amort_Dues(l_Indx) .g_Amount_Due.Irr_Applicable := l_Rec_Amt_Due.Irr_Applicable;
                        --Log#104 FCCL 3.0 IRR Enhancements End

                     END IF;
                  END IF;
                  -- START LOG#46 23-May-2005 SFR#1
               END IF; -- IF l_sch_due_date >= p_build_schs_from THEN
               -- END LOG#46 23-May-2005 SFR#1
               l_Prev_Schedule_End_Date := l_Tb_Schedule_Date(j);
               --dbg('In schedules finally the emi amount is :'||p_out_tb_amort_dues(l_indx) .g_amount_due.emi_amount||'~'||l_tb_amt_due(l_indx) .g_amount_due.emi_amount);
               l_Emi_Amount := NULL; --29.09.2005 Log#67
            END LOOP;
         END IF; --Log#135
         l_Tb_Schedule_Date.DELETE;
         i := p_Tb_Payment_Schedules.NEXT(i);
      END LOOP;
      p_Out_Tb_Amt_Due := l_Tb_Amt_Due;

      l_Tb_Frm_Names.DELETE;
      l_Tb_Amt_Due.DELETE;

      RETURN TRUE;
   EXCEPTION
      WHEN OTHERS THEN

         l_Tb_Schedule_Date.DELETE;
         l_Tb_Frm_Names.DELETE;
         l_Tb_Amt_Due.DELETE;

         Clpkss_Logger.Pr_Log_Exception('');

         p_Error_Code := 'CL-SCH014;';
         Ovpkss.Pr_Appendtbl(p_Error_Code, '');
         Dbg('bombed in fn_populate_account_schedules with ' || SQLERRM);
         RETURN FALSE;
   END Fn_Populate_Account_Schedules;

   FUNCTION Fn_Gen_Rebuild_Schedule(p_Account_Rec       IN OUT NOCOPY Clpkss_Object.Ty_Rec_Account
                                   ,p_New_Maturity_Date IN Cltbs_Account_Master.Maturity_Date%TYPE
                                   ,p_Err_Code          IN OUT Ertbs_Msgs.Err_Code%TYPE
                                   ,p_Err_Param         IN OUT Ertbs_Msgs.Message%TYPE)
      RETURN BOOLEAN IS
      l_Old_Maturity_Date     Cltb_Account_Master.Maturity_Date%TYPE;
      l_Branch_Code           Cltbs_Account_Master.Branch_Code%TYPE;
      l_New_Mat_Indx          PLS_INTEGER;
      l_Comp_Indx             Cltbs_Account_Schedules.Component_Name%TYPE;
      l_Comp_Sch_Indx         VARCHAR2(100);
      l_Prev_Bull_Indx        PLS_INTEGER;
      l_Last_Acc_Sch_Rec      Cltbs_Account_Schedules%ROWTYPE;
      l_New_Acc_Sch_Rec       Cltbs_Account_Schedules%ROWTYPE;
      l_Old_Last_Comp_Sch_Row Cltbs_Account_Comp_Sch%ROWTYPE;
      l_New_Last_Comp_Sch_Row Cltbs_Account_Comp_Sch%ROWTYPE;
      l_Temp_Index            PLS_INTEGER;
      l_Delete_Accs_From      PLS_INTEGER;
      l_New_Schs              Cltbs_Account_Comp_Sch.No_Of_Schedules%TYPE;
      l_Old_Schedule_Linkage  Cltbs_Account_Schedules.Schedule_Linkage%TYPE;
      l_Account_No            Cltb_Account_Schedules.Account_Number%TYPE;
      l_Update_Count          NUMBER;
      l_Formula_Name          Cltbs_Account_Schedules.Formula_Name%TYPE;
      l_Comp_Sch_Row          Cltbs_Account_Comp_Sch%ROWTYPE;
      l_Indx                  PLS_INTEGER;
      l_Sch_Start_Date        Cltbs_Account_Comp_Sch.Sch_Start_Date%TYPE;
      l_Payment_Mode          Cltbs_Account_Comp_Sch.Payment_Mode%TYPE;
      l_Pmnt_Prod_Ac          Cltbs_Account_Comp_Sch.Pmnt_Prod_Ac%TYPE;
      l_Payment_Details       Cltbs_Account_Comp_Sch.Payment_Details%TYPE;
      l_Ben_Account           Cltbs_Account_Comp_Sch.Ben_Account%TYPE;
      l_Ben_Bank              Cltbs_Account_Comp_Sch.Ben_Bank%TYPE;
      l_Ben_Name              Cltbs_Account_Comp_Sch.Ben_Name%TYPE;
      l_Capitalized           Cltbs_Account_Comp_Sch.Capitalized%TYPE;
      l_Waiver_Flag           Cltbs_Account_Comp_Sch.Waiver_Flag%TYPE;
      l_Tb_Frm_Names          Clpkss_Util.Ty_Tb_Frm_Names;
      l_Product_Code          Cltbs_Account_Master.Product_Code%TYPE;
      l_Prin_Comp             Cltbs_Account_Schedules.Component_Name%TYPE;
      l_Tb_Amort_Pairs        Clpkss_Cache.Ty_Tb_Amort_Pairs;
      l_x_Index               VARCHAR2(1000); --27.12.2005
   BEGIN
      Dbg('fn_rebuild_schedule --> starts');

      l_Old_Maturity_Date := Nvl(p_Account_Rec.Account_Det.Maturity_Date
                                ,Clpkss_Util.Pkg_Eternity);
      l_Branch_Code       := p_Account_Rec.Account_Det.Branch_Code;
      l_Product_Code      := p_Account_Rec.Account_Det.Product_Code;
      l_Account_No        := p_Account_Rec.Account_Det.Account_Number;

      IF NOT Clpkss_Util.Fn_Get_Amortized_Formulae(l_Tb_Frm_Names, l_Product_Code) THEN
         p_Err_Code := 'CL-SCH037;';
         l_Tb_Frm_Names.DELETE;
         Ovpkss.Pr_Appendtbl(p_Err_Code, '');
         RETURN FALSE;
      END IF;
      IF NOT Clpkss_Cache.Fn_Get_Amort_Pairs(l_Product_Code, l_Tb_Amort_Pairs) THEN
         RETURN FALSE;
      END IF;
      l_Prev_Bull_Indx := Clpkss_Util.Fn_Hash_Date(l_Old_Maturity_Date);
      l_New_Mat_Indx   := Clpkss_Util.Fn_Hash_Date(p_New_Maturity_Date); --dont change it

      l_Comp_Indx := p_Account_Rec.g_Tb_Components.FIRST;

      WHILE l_Comp_Indx IS NOT NULL LOOP

         --START Prasanna/Ravi FCCCL Phase 2 SFR#305. 04-May-2005
         ---Late Fee Changes on 18 Apr '06 starts
         --IF nvl(p_account_rec.g_tb_components(l_comp_indx).comp_det.component_type,'L') NOT IN ('P','H','M','O')
         IF Nvl(p_Account_Rec.g_Tb_Components(l_Comp_Indx).Comp_Det.Component_Type, 'L') NOT IN
            ('P', 'H', 'M', 'O', 'F')
         ---Late Fee Changes on 18 Apr '06 ends
          THEN
            Dbg(' looping for component--> ' || l_Comp_Indx);
            IF p_New_Maturity_Date > l_Old_Maturity_Date THEN
               Dbg('its a maturity date increase');
               l_Last_Acc_Sch_Rec := NULL;
               l_New_Acc_Sch_Rec  := NULL;
               IF (p_Account_Rec.g_Tb_Components(l_Comp_Indx).g_Tb_Amt_Due.COUNT > 0) THEN
                  --l_bullet_indx      := p_account_rec.g_tb_components(l_comp_indx)
                  --                     .g_tb_amt_due.LAST;
                  IF p_Account_Rec.g_Tb_Components(l_Comp_Indx)
                  .g_Tb_Amt_Due.EXISTS(l_Prev_Bull_Indx) THEN
                     l_Last_Acc_Sch_Rec := p_Account_Rec.g_Tb_Components(l_Comp_Indx)
                                          .g_Tb_Amt_Due(l_Prev_Bull_Indx).g_Amount_Due;
                     l_New_Acc_Sch_Rec  := l_Last_Acc_Sch_Rec;
                     p_Account_Rec.g_Tb_Components(l_Comp_Indx) .g_Tb_Amt_Due.DELETE(l_Prev_Bull_Indx);

                     l_New_Acc_Sch_Rec.Schedule_Due_Date := p_New_Maturity_Date;
                     l_New_Acc_Sch_Rec.Schedule_Linkage  := p_New_Maturity_Date;

                     p_Account_Rec.g_Tb_Components(l_Comp_Indx) .g_Tb_Amt_Due(l_New_Mat_Indx) .g_Amount_Due := l_New_Acc_Sch_Rec;
                     p_Account_Rec.g_Tb_Components(l_Comp_Indx) .g_Tb_Amt_Due(l_New_Mat_Indx) .g_Record_Rowid := NULL;
                     p_Account_Rec.g_Tb_Components(l_Comp_Indx) .g_Tb_Amt_Due(l_New_Mat_Indx) .g_Record_Rowid := 'I';
                     --rebuild comp sch
                     l_Comp_Sch_Indx := 'P' || Clpkss_Util.Fn_Hash_Date(l_Old_Maturity_Date
                                                                       ,NULL);

                     IF NOT p_Account_Rec.g_Tb_Components(l_Comp_Indx)
                     .g_Tb_Comp_Sch.EXISTS(l_Comp_Sch_Indx) THEN
                        IF l_New_Acc_Sch_Rec.Schedule_Type IS NOT NULL --i.e. its a principal schedule bcos of amortization
                         THEN
                           Dbg('something very evil returning false.');
                           --wrong schedule definition.
                           RETURN FALSE;
                        END IF;
                     END IF;
                     IF l_New_Acc_Sch_Rec.Schedule_Type IS NOT NULL THEN
                        l_Old_Last_Comp_Sch_Row := p_Account_Rec.g_Tb_Components(l_Comp_Indx)
                                                  .g_Tb_Comp_Sch(l_Comp_Sch_Indx)
                                                  .g_Account_Comp_Sch;

                        l_New_Last_Comp_Sch_Row := l_Old_Last_Comp_Sch_Row;

                        p_Account_Rec.g_Tb_Components(l_Comp_Indx) .g_Tb_Comp_Sch.DELETE(l_Comp_Sch_Indx);

                        l_New_Last_Comp_Sch_Row.First_Due_Date := p_New_Maturity_Date;
                        l_New_Last_Comp_Sch_Row.Sch_End_Date   := p_New_Maturity_Date;

                        l_Comp_Sch_Indx := 'P' || Clpkss_Util.Fn_Hash_Date(p_New_Maturity_Date
                                                                          ,NULL);

                        p_Account_Rec.g_Tb_Components(l_Comp_Indx) .g_Tb_Comp_Sch(l_Comp_Sch_Indx) .g_Account_Comp_Sch := l_New_Last_Comp_Sch_Row;

                        p_Account_Rec.g_Tb_Components(l_Comp_Indx) .g_Tb_Comp_Sch(l_Comp_Sch_Indx) .g_Record_Rowid := NULL;
                        p_Account_Rec.g_Tb_Components(l_Comp_Indx) .g_Tb_Comp_Sch(l_Comp_Sch_Indx) .g_Action := 'I';
                     END IF;

                  END IF;
               END IF;

            ELSIF (p_New_Maturity_Date < l_Old_Maturity_Date) THEN
               Dbg('fn_rebuild_schedule --> its a maturity date decrease');
               --process  repayment schedules .
               IF (p_Account_Rec.g_Tb_Components(l_Comp_Indx).g_Tb_Amt_Due.COUNT > 0) THEN
                  l_Temp_Index := l_New_Mat_Indx; --this index to be used for manipulations

                  IF NOT p_Account_Rec.g_Tb_Components(l_Comp_Indx)
                  .g_Tb_Amt_Due.EXISTS(l_New_Mat_Indx) THEN
                     Dbg('fn_rebuild_schedule --> maturity date is not on a due date');

                     --new maturity falls between due dates ..increase index to get first due date after new mat
                     l_Temp_Index := p_Account_Rec.g_Tb_Components(l_Comp_Indx)
                                    .g_Tb_Amt_Due.NEXT(l_Temp_Index);

                     IF l_Temp_Index IS NULL AND
                        l_Comp_Indx IN (Pkg_Principal, Pkg_Main_Int)
                     --Phase II NLS changes
                      THEN
                        --whole component starts after this maturity date
                        RETURN FALSE;
                     END IF;

                     l_Delete_Accs_From := l_Temp_Index;
                     l_Update_Count     := 0;
                  ELSE
                     Dbg('new matrurity on a due date');
                     l_Delete_Accs_From := l_Temp_Index;
                     l_Delete_Accs_From := p_Account_Rec.g_Tb_Components(l_Comp_Indx)
                                          .g_Tb_Amt_Due.NEXT(l_Delete_Accs_From);
                     l_Update_Count     := 1;
                  END IF;

                  IF l_Temp_Index IS NOT NULL AND
                     p_Account_Rec.g_Tb_Components(l_Comp_Indx)
                  .g_Tb_Amt_Due(l_Temp_Index).g_Amount_Due.Schedule_Type IS NOT NULL THEN

                     --this is to get hold on corresponding cltb_account_comp_sch row,for which now no_of_schs needs
                     --to be reduced.

                     l_Old_Schedule_Linkage := p_Account_Rec.g_Tb_Components(l_Comp_Indx)
                                              .g_Tb_Amt_Due(l_Temp_Index)
                                              .g_Amount_Due.Schedule_Linkage;
                     l_Comp_Sch_Indx        := 'P' ||
                                               Clpkss_Util.Fn_Hash_Date(l_Old_Schedule_Linkage
                                                                       ,NULL);

                     Dbg('affected schedule defn is the one with first due date as ' ||
                         l_Old_Schedule_Linkage);

                     --update amount due row which is getting affected
                     p_Account_Rec.g_Tb_Components(l_Comp_Indx) .g_Tb_Amt_Due(l_New_Mat_Indx) := p_Account_Rec.g_Tb_Components(l_Comp_Indx)
                                                                                                .g_Tb_Amt_Due(l_Temp_Index);
                     --update due date
                     p_Account_Rec.g_Tb_Components(l_Comp_Indx) .g_Tb_Amt_Due(l_New_Mat_Indx) . g_Amount_Due.Schedule_Due_Date := p_New_Maturity_Date;
                     --update it for new due date and schedule linkage
                     p_Account_Rec.g_Tb_Components(l_Comp_Indx) .g_Tb_Amt_Due(l_New_Mat_Indx) .g_Amount_Due.Schedule_Linkage := p_New_Maturity_Date;

                     l_Formula_Name := p_Account_Rec.g_Tb_Components(l_Comp_Indx)
                                      .g_Tb_Amt_Due(l_Temp_Index)
                                      .g_Amount_Due.Formula_Name;

                     --If amortized then update for Principal amount dues as well.

                     IF l_Formula_Name IS NOT NULL THEN
                        IF l_Tb_Frm_Names.EXISTS(l_Formula_Name) THEN
                           --CL Phase II corfo change starts
                           --p_account_rec.g_tb_components(PKG_PRINCIPAL) .g_tb_amt_due(l_new_mat_indx) := p_account_rec.g_tb_components(PKG_PRINCIPAL)
                           --p_account_rec.g_tb_components(PKG_PRINCIPAL) .g_tb_amt_due(l_new_mat_indx) . g_amount_due.schedule_due_date := p_new_maturity_date;
                           --p_account_rec.g_tb_components(PKG_PRINCIPAL).g_tb_amt_due(l_new_mat_indx) .g_amount_due.schedule_linkage := p_new_maturity_date;

                           IF NOT l_Tb_Amort_Pairs.EXISTS(l_Product_Code || l_Comp_Indx ||
                                                          l_Formula_Name) THEN
                              Dbg('amort pair absent ');
                              RETURN FALSE;
                           ELSE
                              l_Prin_Comp := l_Tb_Amort_Pairs(l_Product_Code ||
                                                              l_Comp_Indx ||
                                                              l_Formula_Name);
                           END IF;
                           p_Account_Rec.g_Tb_Components(l_Prin_Comp) .g_Tb_Amt_Due(l_New_Mat_Indx) := p_Account_Rec.g_Tb_Components(l_Prin_Comp)
                                                                                                      .g_Tb_Amt_Due(l_Temp_Index);
                           p_Account_Rec.g_Tb_Components(l_Prin_Comp) .g_Tb_Amt_Due(l_New_Mat_Indx) . g_Amount_Due.Schedule_Due_Date := p_New_Maturity_Date;
                           p_Account_Rec.g_Tb_Components(l_Prin_Comp) .g_Tb_Amt_Due(l_New_Mat_Indx) .g_Amount_Due.Schedule_Linkage := p_New_Maturity_Date;
                           --CL Phase II corfo change ends
                        END IF;
                     END IF;

                     l_Sch_Start_Date := p_Account_Rec.g_Tb_Components(l_Comp_Indx)
                                        .g_Tb_Amt_Due(l_Temp_Index)
                                        .g_Amount_Due.Schedule_St_Date;

                     l_Payment_Mode    := p_Account_Rec.g_Tb_Components(l_Comp_Indx)
                                         .g_Tb_Comp_Sch(l_Comp_Sch_Indx)
                                         .g_Account_Comp_Sch.Payment_Mode;
                     l_Pmnt_Prod_Ac    := p_Account_Rec.g_Tb_Components(l_Comp_Indx)
                                         .g_Tb_Comp_Sch(l_Comp_Sch_Indx)
                                         .g_Account_Comp_Sch.Pmnt_Prod_Ac;
                     l_Payment_Details := p_Account_Rec.g_Tb_Components(l_Comp_Indx)
                                         .g_Tb_Comp_Sch(l_Comp_Sch_Indx)
                                         .g_Account_Comp_Sch.Payment_Details;
                     l_Ben_Account     := p_Account_Rec.g_Tb_Components(l_Comp_Indx)
                                         .g_Tb_Comp_Sch(l_Comp_Sch_Indx)
                                         .g_Account_Comp_Sch.Ben_Account;
                     l_Ben_Bank        := p_Account_Rec.g_Tb_Components(l_Comp_Indx)
                                         .g_Tb_Comp_Sch(l_Comp_Sch_Indx)
                                         .g_Account_Comp_Sch.Ben_Bank;
                     l_Ben_Name        := p_Account_Rec.g_Tb_Components(l_Comp_Indx)
                                         .g_Tb_Comp_Sch(l_Comp_Sch_Indx)
                                         .g_Account_Comp_Sch.Ben_Name;
                     --l_capitalized    := p_account_rec.g_tb_components(l_comp_indx).g_tb_comp_sch
                     --                    (l_comp_sch_indx).g_account_comp_sch.capitalized;
                     l_Capitalized := 'N';
                     l_Waiver_Flag := p_Account_Rec.g_Tb_Components(l_Comp_Indx)
                                     .g_Tb_Comp_Sch(l_Comp_Sch_Indx)
                                     .g_Account_Comp_Sch.Waiver_Flag;

                     --insert one bullet schedule
                     l_Comp_Sch_Row                 := NULL;
                     l_Comp_Sch_Row.Account_Number  := l_Account_No;
                     l_Comp_Sch_Row.Branch_Code     := l_Branch_Code;
                     l_Comp_Sch_Row.Component_Name  := l_Comp_Indx;
                     l_Comp_Sch_Row.Schedule_Type   := 'P';
                     l_Comp_Sch_Row.Schedule_Flag   := 'N';
                     l_Comp_Sch_Row.Formula_Name    := l_Formula_Name;
                     l_Comp_Sch_Row.Sch_Start_Date  := l_Sch_Start_Date;
                     l_Comp_Sch_Row.First_Due_Date  := p_New_Maturity_Date;
                     l_Comp_Sch_Row.No_Of_Schedules := 1;
                     l_Comp_Sch_Row.Frequency       := 1;
                     l_Comp_Sch_Row.Unit            := 'B';
                     l_Comp_Sch_Row.Sch_End_Date    := p_New_Maturity_Date;
                     l_Comp_Sch_Row.Amount          := 0;
                     l_Comp_Sch_Row.Payment_Mode    := l_Payment_Mode;
                     l_Comp_Sch_Row.Pmnt_Prod_Ac    := l_Pmnt_Prod_Ac;
                     l_Comp_Sch_Row.Payment_Details := l_Payment_Details;
                     l_Comp_Sch_Row.Ben_Account     := l_Ben_Account;
                     l_Comp_Sch_Row.Ben_Bank        := l_Ben_Bank;
                     l_Comp_Sch_Row.Ben_Name        := l_Ben_Name;
                     l_Comp_Sch_Row.Capitalized     := l_Capitalized;
                     l_Comp_Sch_Row.Waiver_Flag     := l_Waiver_Flag;

                     --insert records only after deletion is complete

                     --p_account_rec.g_tb_components(l_comp_indx) .g_tb_comp_sch('P' || clpkss_util.fn_hash_date(p_new_maturity_date,NULL))
                     --.g_account_comp_sch := l_comp_sch_row;

                     --delete account_schedules which falls after new_maturity_date
                     --also take a count of schedules of comp_sch row for which schedules need to be reduced
                     --l_update_count := 0;

                     Dbg('$$$$$$$$$$l_delete_accs_from ' || l_Delete_Accs_From);
                     Dbg('$$$$$$$$$$+++l_formula_name ' || l_Formula_Name);

                     WHILE l_Delete_Accs_From IS NOT NULL LOOP
                        IF p_Account_Rec.g_Tb_Components(l_Comp_Indx)
                        .g_Tb_Amt_Due(l_Delete_Accs_From)
                        .g_Amount_Due.Schedule_Linkage = l_Old_Schedule_Linkage THEN
                           l_Update_Count := l_Update_Count + 1;
                        END IF;
                        --DELETE acc schedules
                        ----CL PHASE II Corfo Related Enahncements
                        --IF nvl(p_account_rec.g_tb_components(l_comp_indx).comp_det.main_component,'N') = 'Y'

                        Dbg('$$$$$$$$$$p_account_rec.g_tb_components(l_comp_indx).comp_det.component_type ' ||
                            p_Account_Rec.g_Tb_Components(l_Comp_Indx)
                            .Comp_Det.Component_Type);

                        IF Nvl(p_Account_Rec.g_Tb_Components(l_Comp_Indx)
                               .Comp_Det.Component_Type
                              ,'*') = 'I' THEN
                           l_Formula_Name := p_Account_Rec.g_Tb_Components(l_Comp_Indx)
                                            .g_Tb_Amt_Due(l_Delete_Accs_From)
                                            .g_Amount_Due.Formula_Name;

                           Dbg('$$$$$$$$$$$$$l_formula_name ' || l_Formula_Name);

                           IF l_Formula_Name IS NOT NULL THEN
                              IF l_Tb_Frm_Names.EXISTS(l_Formula_Name) THEN

                                 Dbg('$$$$$$$$$$$$$l_tb_frm_names EXISTS ');

                                 IF NOT
                                     l_Tb_Amort_Pairs.EXISTS(l_Product_Code || l_Comp_Indx ||
                                                             l_Formula_Name) THEN
                                    Dbg('amort pair absent ');
                                    RETURN FALSE;
                                 ELSE
                                    l_Prin_Comp := l_Tb_Amort_Pairs(l_Product_Code ||
                                                                    l_Comp_Indx ||
                                                                    l_Formula_Name);
                                 END IF;

                                 Dbg('$$$$$$$$$$l_prin_comp ' || l_Prin_Comp);

                                 Dbg('deleting principal dues also since its an amortized one');
                                 --p_account_rec.g_tb_components(PKG_PRINCIPAL).g_tb_amt_due.DELETE(l_delete_accs_from);
                                 p_Account_Rec.g_Tb_Components(l_Prin_Comp) .g_Tb_Amt_Due.DELETE(l_Delete_Accs_From);

                              END IF;
                           END IF;
                        END IF;
                        p_Account_Rec.g_Tb_Components(l_Comp_Indx) .g_Tb_Amt_Due.DELETE(l_Delete_Accs_From);

                        l_Delete_Accs_From := p_Account_Rec.g_Tb_Components(l_Comp_Indx)
                                             .g_Tb_Amt_Due.NEXT(l_Delete_Accs_From);
                     END LOOP;

                     --Update the number of schedules for the comp sch row for which number of
                     --rows got reduced
                     l_Comp_Sch_Indx := 'P' || Clpkss_Util.Fn_Hash_Date(l_Old_Schedule_Linkage
                                                                       ,NULL);
                     l_New_Schs      := p_Account_Rec.g_Tb_Components(l_Comp_Indx)
                                       .g_Tb_Comp_Sch(l_Comp_Sch_Indx) . g_Account_Comp_Sch.No_Of_Schedules -
                                        l_Update_Count;

                     Dbg('l_update_count is ' || l_Update_Count);
                     l_New_Schs := Nvl(p_Account_Rec.g_Tb_Components(l_Comp_Indx)
                                       .g_Tb_Comp_Sch(l_Comp_Sch_Indx)
                                       .g_Account_Comp_Sch.No_Of_Schedules
                                      ,0);
                     IF l_New_Schs > 0 THEN
                        l_New_Schs := l_New_Schs - l_Update_Count;
                     END IF;
                     IF l_New_Schs <= 0 THEN
                        --START Prasanna/Ravi FCC-CL EURO BANK SFR#RAL044-03. 27-DEC-2005
                        IF p_Account_Rec.g_Tb_Components(l_Comp_Indx)
                        .g_Tb_Comp_Sch(l_Comp_Sch_Indx)
                        .g_Account_Comp_Sch.Schedule_Type = 'P' THEN
                           p_Account_Rec.g_Tb_Components(l_Comp_Indx) .g_Tb_Comp_Sch.DELETE(l_Comp_Sch_Indx);
                        END IF;
                        --END Prasanna/Ravi FCC-CL EURO BANK SFR#RAL044-03. 27-DEC-2005
                     ELSE
                        --update the no of schedules
                        Dbg('New no of schedule is ' || l_New_Schs ||
                            ' for sch start date ' || l_Old_Schedule_Linkage);
                        p_Account_Rec.g_Tb_Components(l_Comp_Indx) .g_Tb_Comp_Sch(l_Comp_Sch_Indx) .g_Account_Comp_Sch.No_Of_Schedules := l_New_Schs;

                        --updation of schedule end date
                        --find out start date for last account schedule row  ..that will be end date for thsi schedule defn.
                        l_Indx := p_Account_Rec.g_Tb_Components(l_Comp_Indx)
                                 .g_Tb_Amt_Due.LAST;
                        IF l_Indx IS NOT NULL THEN
                           p_Account_Rec.g_Tb_Components(l_Comp_Indx) .g_Tb_Comp_Sch(l_Comp_Sch_Indx) .g_Account_Comp_Sch.Sch_End_Date := p_Account_Rec.g_Tb_Components(l_Comp_Indx)
                                                                                                                                         .g_Tb_Amt_Due(l_Indx)
                                                                                                                                         .g_Amount_Due.Schedule_St_Date;
                        END IF;

                     END IF;

                     --delete schedule definitions which falls after maturity
                     --l_comp_sch_indx := 'P' || l_new_mat_indx;
                     --FCUBS ITR1 SFR#3680 Starts
                     --l_Comp_Sch_Indx := 'P' || Clpkss_Util.Fn_Hash_Date(l_Old_Schedule_Linkage,NULL);
                     l_Comp_Sch_Indx := 'P' || Clpkss_Util.Fn_Hash_Date(p_New_Maturity_Date,NULL);
                     --FCUBS ITR1 SFR#3680 Ends
                     l_Comp_Sch_Indx := p_Account_Rec.g_Tb_Components(l_Comp_Indx)
                                       .g_Tb_Comp_Sch.NEXT(l_Comp_Sch_Indx);

                     --Log#72 Start
                     --WHILE l_comp_sch_indx IS NOT NULL
                     WHILE l_Comp_Sch_Indx IS NOT NULL AND l_Comp_Sch_Indx LIKE 'P%'
                     --Log#72 End

                      LOOP
                        Dbg('deleting comp sch ' || l_Comp_Sch_Indx);
                        --START Prasanna/Ravi FCC-CL EURO BANK SFR#RAL044-03. 27-DEC-2005
                        IF p_Account_Rec.g_Tb_Components(l_Comp_Indx)
                        .g_Tb_Comp_Sch(l_Comp_Sch_Indx)
                        .g_Account_Comp_Sch.Schedule_Type = 'P' THEN
                           p_Account_Rec.g_Tb_Components(l_Comp_Indx) .g_Tb_Comp_Sch.DELETE(l_Comp_Sch_Indx);
                        END IF;
                        --END Prasanna/Ravi FCC-CL EURO BANK SFR#RAL044-03. 27-DEC-2005

                        l_Comp_Sch_Indx := p_Account_Rec.g_Tb_Components(l_Comp_Indx)
                                          .g_Tb_Comp_Sch.NEXT(l_Comp_Sch_Indx);
                     END LOOP;
                     --insert new record here.
                     p_Account_Rec.g_Tb_Components(l_Comp_Indx) .g_Tb_Comp_Sch('P' || Clpkss_Util.Fn_Hash_Date(p_New_Maturity_Date, NULL)) .g_Account_Comp_Sch := l_Comp_Sch_Row;
                  END IF;
               END IF;

               --process revision schedules
               --START Prasanna/Ravi FCC-CL EURO BANK SFR#RAL044-03. 27-DEC-2005
               --DO NOT TOUCH REVISION SCHEDULES
               /***
               IF (p_account_rec.g_tb_components(l_comp_indx).g_tb_revn_schedules.COUNT > 0)
               THEN
                   l_temp_index   := l_new_mat_indx; --this index to be used for manipulations

                   l_temp_index := p_account_rec.g_tb_components(l_comp_indx)
                                  .g_tb_revn_schedules.NEXT(l_temp_index);
                   IF l_temp_index IS NOT NULL THEN

                       l_delete_accs_from := l_temp_index;
                       l_update_count     := 0;


                       --l_old_schedule_linkage := p_account_rec.g_tb_components(l_comp_indx)
                                                --.g_tb_amt_due(l_temp_index)
                                                --.g_amount_due.schedule_linkage;


                        l_old_schedule_linkage :=  p_account_rec.g_tb_components(l_comp_indx)
                                            . g_tb_revn_schedules (l_temp_index). g_REVN_SCHEDULES.schedule_linkage;

                       dbg('old schedule linkage is ' || l_old_schedule_linkage);

                       WHILE l_delete_accs_from IS NOT NULL
                       LOOP
                           IF p_account_rec.g_tb_components(l_comp_indx)
                           .g_tb_revn_schedules(l_delete_accs_from)
                           .g_revn_schedules.schedule_linkage =
                              l_old_schedule_linkage
                           THEN
                               l_update_count := l_update_count + 1;
                           END IF;
                           --DELETE acc schedules
                           p_account_rec.g_tb_components(l_comp_indx) .g_tb_revn_schedules.DELETE(l_delete_accs_from);
                           l_delete_accs_from := p_account_rec.g_tb_components(l_comp_indx)
                                                .g_tb_revn_schedules.NEXT(l_delete_accs_from);
                       END LOOP;
                       --Update the number of schedules for the comp sch row for which number of
                       --rows got reduced
                       l_comp_sch_indx := 'R' ||
                                          clpkss_util.fn_hash_date(l_old_schedule_linkage, null);

                       dbg('$$$$$$$$$l_comp_sch_indx ' || l_comp_sch_indx);

                       dbg('%%%%%%%%%%%%%l_comp_sch_indx ' || l_comp_sch_indx);
                        l_x_index := p_account_rec.g_tb_components(l_comp_indx)
                                             .g_tb_comp_sch.FIRST;
                        WHILE l_x_index IS NOT NULL
                        LOOP
                               dbg('l_x_index:in rebuild'||l_x_index);
                               l_x_index :=p_account_rec.g_tb_components(l_comp_indx)
                                             .g_tb_comp_sch.next(l_x_index);
                        END LOOP;


                       l_new_schs      := p_account_rec.g_tb_components(l_comp_indx)
                                         .g_tb_comp_sch(l_comp_sch_indx) .
                                          g_account_comp_sch.no_of_schedules -
                                          l_update_count;

                       dbg('l_update_count is ' || l_update_count);
                       IF l_new_schs <= 0
                       THEN
                           IF p_account_rec.g_tb_components(l_comp_indx) .g_tb_comp_sch.EXISTS(l_comp_sch_indx)
                           THEN
                               --START Prasanna/Ravi FCC-CL EURO BANK SFR#RAL044-03. 27-DEC-2005
                               IF p_account_rec.g_tb_components(l_comp_indx) .g_tb_comp_sch(l_comp_sch_indx) .g_account_comp_sch.schedule_type = 'R' THEN
                                     p_account_rec.g_tb_components(l_comp_indx) .g_tb_comp_sch.DELETE(l_comp_sch_indx);
                               END IF;
                               --END Prasanna/Ravi FCC-CL EURO BANK SFR#RAL044-03. 27-DEC-2005
                           END IF;
                       ELSE
                           --update the no of schedules
                           dbg('reduced no of schedule for scheduele by ' ||
                               l_new_schs || ' for start date ' ||
                               NVL(l_old_schedule_linkage,NULL));
                           p_account_rec.g_tb_components(l_comp_indx) .g_tb_comp_sch(l_comp_sch_indx) .g_account_comp_sch.no_of_schedules := l_new_schs;

                           --updation of schedule end date
                           --find out last due date for this schedule defn in acc schedules ..that will be end date
                           l_indx := p_account_rec.g_tb_components(l_comp_indx)
                                    .g_tb_revn_schedules.LAST;

                           IF l_indx IS NOT NULL
                           THEN
                               --START Prasanna/Ravi FCC-CL EURO BANK SFR#RAL044-03. 27-DEC-2005
                               IF p_account_rec.g_tb_components(l_comp_indx) .g_tb_comp_sch.exists(l_comp_sch_indx) --27.12.2005
                               THEN
                                   p_account_rec.g_tb_components(l_comp_indx) .g_tb_comp_sch(l_comp_sch_indx) .g_account_comp_sch.sch_end_date
                                   := p_account_rec.g_tb_components(l_comp_indx) .g_tb_revn_schedules(l_indx).g_revn_schedules.schedule_st_date;
                               END IF;
                               --END Prasanna/Ravi FCC-CL EURO BANK SFR#RAL044-03. 27-DEC-2005
                           END IF;
                       END IF;
                   END IF;
               END IF;
               ***/
               --END Prasanna/Ravi FCC-CL EURO BANK SFR#RAL044-03. 27-DEC-2005

            END IF;

         END IF; --Component_Type not in ('H','P','M','O')
         --END Prasanna/Ravi FCCCL Phase 2 SFR#305. 04-May-2005

         l_Comp_Indx := p_Account_Rec.g_Tb_Components.NEXT(l_Comp_Indx);
      END LOOP;
      Dbg('fn_rebuild_schedules ..returning TRUE');
      RETURN TRUE;
   EXCEPTION
      WHEN OTHERS THEN

         p_Err_Code  := 'CL-SCH036;';
         p_Err_Param := 'fn_rebuild_schedules~;';
         Ovpkss.Pr_Appendtbl(p_Err_Code, p_Err_Param);

         Dbg('in when others of fn_rebuild_schedule with ' || SQLERRM);

         Clpkss_Logger.Pr_Log_Exception('');

         RETURN FALSE;
   END Fn_Gen_Rebuild_Schedule;
   FUNCTION Fn_Rebuild_Schedule(p_Account_Rec       IN OUT NOCOPY Clpkss_Object.Ty_Rec_Account
                               ,p_New_Maturity_Date IN Cltbs_Account_Master.Maturity_Date%TYPE
                               ,p_Err_Code          IN OUT Ertbs_Msgs.Err_Code%TYPE
                               ,p_Err_Param         IN OUT Ertbs_Msgs.Message%TYPE)
      RETURN BOOLEAN IS
   BEGIN
      IF NOT Clpkss_Stream_Schedules.Fn_Pre_Rebuild_Schedule(p_Account_Rec
                                                            ,p_New_Maturity_Date
                                                            ,p_Err_Code
                                                            ,p_Err_Param) THEN
         RETURN FALSE;
      END IF;

      IF Clpkss_Stream_Schedules.Fn_Ovrdn_Rebuild_Schedule THEN
         IF NOT Clpkss_Stream_Schedules.Fn_Rebuild_Schedule(p_Account_Rec
                                                           ,p_New_Maturity_Date
                                                           ,p_Err_Code
                                                           ,p_Err_Param) THEN
            RETURN FALSE;
         END IF;
      ELSE

         IF NOT Fn_Gen_Rebuild_Schedule(p_Account_Rec
                                       ,p_New_Maturity_Date
                                       ,p_Err_Code
                                       ,p_Err_Param) THEN
            RETURN FALSE;
         END IF;
      END IF;

      IF NOT Clpkss_Stream_Schedules.Fn_Post_Rebuild_Schedule(p_Account_Rec
                                                             ,p_New_Maturity_Date
                                                             ,p_Err_Code
                                                             ,p_Err_Param) THEN
         RETURN FALSE;
      END IF;

      RETURN TRUE;
   EXCEPTION
      WHEN OTHERS THEN

         p_Err_Code  := 'CL-SCH036;';
         p_Err_Param := 'fn_rebuild_schedules~;';
         Ovpkss.Pr_Appendtbl(p_Err_Code, p_Err_Param);
         Dbg('in when others of fn_rebuild_schedule with ' || SQLERRM);
         Clpkss_Logger.Pr_Log_Exception('');
         RETURN FALSE;
   END Fn_Rebuild_Schedule;

   FUNCTION Fn_Get_New_Split_Schedules(p_Eff_Comp_Sch_Rec       IN OUT Clpkss_Object.Ty_Rec_Account_Comp_Sch
                                      ,p_Eff_Sch_New_End_Dt     IN Cltbs_Account_Comp_Sch.Sch_End_Date%TYPE
                                      , --l_last_sch_end_dt
                                       p_Eff_Sch_New_Sch_Cnt    IN Cltbs_Account_Comp_Sch.No_Of_Schedules%TYPE
                                      , --l_past_sch_cnt           IN
                                       p_New_Sch_First_Due_Date IN Cltbs_Account_Comp_Sch.First_Due_Date%TYPE
                                      ,p_Cascade_Movement       IN Cltms_Product.Cascade_Schedules%TYPE
                                      , --l_next_sch_date
                                       p_New_Comp_Sch_Rec       OUT Clpkss_Object.Ty_Rec_Account_Comp_Sch
                                      ,p_Error_Code             IN OUT Ertbs_Msgs.Err_Code%TYPE)
      RETURN BOOLEAN IS
      l_First_Due_Date  Cltbs_Account_Comp_Sch.First_Due_Date%TYPE;
      l_No_Of_Schedules Cltbs_Account_Comp_Sch.No_Of_Schedules%TYPE;
      l_Sch_End_Date    Cltbs_Account_Comp_Sch.Sch_End_Date%TYPE;
   BEGIN

      p_New_Comp_Sch_Rec := p_Eff_Comp_Sch_Rec;

      BEGIN
         l_First_Due_Date  := p_Eff_Comp_Sch_Rec.g_Account_Comp_Sch.First_Due_Date;
         l_No_Of_Schedules := p_Eff_Comp_Sch_Rec.g_Account_Comp_Sch.No_Of_Schedules;
         l_Sch_End_Date    := p_Eff_Comp_Sch_Rec.g_Account_Comp_Sch.Sch_End_Date;
      EXCEPTION
         WHEN No_Data_Found THEN
            Dbg('failed in fn_get_new_split_schedules');
            p_Error_Code := 'CL-SCH030;';
            Ovpkss.Pr_Appendtbl(p_Error_Code, '');
            RETURN FALSE;
      END;
      p_Eff_Comp_Sch_Rec.g_Account_Comp_Sch.First_Due_Date  := l_First_Due_Date;
      p_Eff_Comp_Sch_Rec.g_Account_Comp_Sch.Sch_End_Date    := p_Eff_Sch_New_End_Dt;
      p_Eff_Comp_Sch_Rec.g_Account_Comp_Sch.No_Of_Schedules := p_Eff_Sch_New_Sch_Cnt;

      Dbg('targeted comp sch params ');
      Dbg('first due date is ' || p_Eff_Comp_Sch_Rec.g_Account_Comp_Sch.First_Due_Date);
      Dbg('sch_end_date is' || p_Eff_Comp_Sch_Rec.g_Account_Comp_Sch.Sch_End_Date);
      Dbg('no of schedules is ' || p_Eff_Comp_Sch_Rec.g_Account_Comp_Sch.No_Of_Schedules);

      Dbg('Cascade movement - ' || p_Cascade_Movement);
      Dbg('Past Schedule count - ' || p_Eff_Sch_New_Sch_Cnt);

      IF p_Cascade_Movement = 'Y' THEN
         IF p_New_Sch_First_Due_Date IS NOT NULL AND
            l_No_Of_Schedules > p_Eff_Sch_New_Sch_Cnt THEN
            -- New schedule after Split
            --l_new_rec_indx := 'P' || clpkss_util.fn_hash_date(p_new_sch_first_due_date,NULL);

            p_New_Comp_Sch_Rec.g_Account_Comp_Sch.Sch_Start_Date  := p_Eff_Sch_New_End_Dt;
            p_New_Comp_Sch_Rec.g_Account_Comp_Sch.First_Due_Date  := p_New_Sch_First_Due_Date;
            p_New_Comp_Sch_Rec.g_Account_Comp_Sch.Sch_End_Date    := l_Sch_End_Date;
            p_New_Comp_Sch_Rec.g_Account_Comp_Sch.No_Of_Schedules := l_No_Of_Schedules -
                                                                     p_Eff_Sch_New_Sch_Cnt;
         END IF;
      ELSE
         IF l_No_Of_Schedules > p_Eff_Sch_New_Sch_Cnt THEN
            -- New schedule after Split

            l_First_Due_Date := Clpks_Schedules.Fn_Get_Next_Schedule_Date(l_First_Due_Date
                                                                         ,p_Eff_Comp_Sch_Rec.g_Account_Comp_Sch.Unit
                                                                         ,p_Eff_Comp_Sch_Rec.g_Account_Comp_Sch.Frequency *
                                                                          p_Eff_Sch_New_Sch_Cnt);

            Dbg('populating new comp sch rec with l_first_due_date as ' ||
                l_First_Due_Date);

            --l_new_rec_indx := 'P' || clpkss_util.fn_hash_date(l_first_due_date,NULL);

            p_New_Comp_Sch_Rec .g_Account_Comp_Sch.Sch_Start_Date := p_Eff_Sch_New_End_Dt;
            /*IF Pkg_lease_advance THEN --Log#145 START --lOG#151 STARTS COMMENTING
              p_New_Comp_Sch_Rec .g_Account_Comp_Sch.First_Due_Date := p_Eff_Sch_New_End_Dt;
            p_New_Comp_Sch_Rec .g_Account_Comp_Sch.Sch_End_Date := l_Sch_End_Date;
            p_New_Comp_Sch_Rec .g_Account_Comp_Sch.No_Of_Schedules := l_No_Of_Schedules -
                                                                      p_Eff_Sch_New_Sch_Cnt+1;
            ELSE --Log#145 Ends
	    */ --lOG#151 ENDS COMMENTING
            p_New_Comp_Sch_Rec .g_Account_Comp_Sch.First_Due_Date := l_First_Due_Date;
            p_New_Comp_Sch_Rec .g_Account_Comp_Sch.Sch_End_Date := l_Sch_End_Date;
            p_New_Comp_Sch_Rec .g_Account_Comp_Sch.No_Of_Schedules := l_No_Of_Schedules -
                                                                      p_Eff_Sch_New_Sch_Cnt;
           -- END IF;  --Log#145 --lOG#151 COMMENTED.
            Dbg('new comp sch params ');
            Dbg('sch start date is  ' || p_New_Comp_Sch_Rec
                .g_Account_Comp_Sch.Sch_Start_Date);
            Dbg('first_due_date is  ' || p_New_Comp_Sch_Rec
                .g_Account_Comp_Sch.First_Due_Date);
            Dbg('sch_end_date is  ' || p_New_Comp_Sch_Rec
                .g_Account_Comp_Sch.Sch_End_Date);
            Dbg('no_of_schedules is  ' || p_New_Comp_Sch_Rec
                .g_Account_Comp_Sch.No_Of_Schedules);
            Dbg('insert into p_acc_rec now');

         END IF;
      END IF;
      RETURN TRUE;
   EXCEPTION
      WHEN OTHERS THEN

         Clpkss_Logger.Pr_Log_Exception('');

         RETURN FALSE;
   END Fn_Get_New_Split_Schedules;

   FUNCTION Fn_Get_Acc_Schs_For_a_Linkage(p_Out_Acc_Schs     IN OUT Clpkss_Object.Ty_Tb_Amt_Due
                                         ,p_Schedule_Linkage IN Cltbs_Account_Schedules.Schedule_Linkage%TYPE
                                         ,p_Error_Code       IN OUT Ertbs_Msgs.Err_Code%TYPE)
      RETURN BOOLEAN IS

      l_Tb_Whole_Acc_Sch Clpkss_Object.Ty_Tb_Amt_Due;
      l_Comp_Due_Indx    PLS_INTEGER;

   BEGIN

      l_Tb_Whole_Acc_Sch := p_Out_Acc_Schs;

      p_Out_Acc_Schs.DELETE;

      l_Comp_Due_Indx := Clpkss_Util.Fn_Hash_Date(p_Schedule_Linkage);

      WHILE l_Comp_Due_Indx IS NOT NULL LOOP

         -- log#118 start
         IF NOT l_Tb_Whole_Acc_Sch.EXISTS(l_Comp_Due_Indx) THEN
            l_Comp_Due_Indx := l_Tb_Whole_Acc_Sch.NEXT(l_Comp_Due_Indx);
         END IF;
         -- log#118 end
         IF l_Tb_Whole_Acc_Sch(l_Comp_Due_Indx)
         .g_Amount_Due.Schedule_Linkage != p_Schedule_Linkage THEN
            Dbg('schedule linkagehas changed..exit now');
            EXIT;
         END IF;

         p_Out_Acc_Schs(l_Comp_Due_Indx) .g_Amount_Due := l_Tb_Whole_Acc_Sch(l_Comp_Due_Indx)
                                                         .g_Amount_Due;

         l_Comp_Due_Indx := l_Tb_Whole_Acc_Sch.NEXT(l_Comp_Due_Indx);

      END LOOP;

      l_Tb_Whole_Acc_Sch.DELETE;

      RETURN TRUE;

   EXCEPTION
      WHEN OTHERS THEN
         l_Tb_Whole_Acc_Sch.DELETE;

         Clpkss_Logger.Pr_Log_Exception('');

         RETURN FALSE;
   END Fn_Get_Acc_Schs_For_a_Linkage;

   FUNCTION Fn_Get_Disb_Schs_For_a_Linkage(p_Out_Disb_Schs    IN OUT Clpkss_Object.Ty_Tb_Disbr_Schedules
                                          ,p_Schedule_Linkage IN Cltbs_Account_Schedules.Schedule_Linkage%TYPE
                                          ,p_Error_Code       IN OUT Ertbs_Msgs.Err_Code%TYPE)
      RETURN BOOLEAN IS

      l_Tb_Whole_Disb_Sch Clpkss_Object.Ty_Tb_Disbr_Schedules;
      l_Comp_Due_Indx     PLS_INTEGER;

   BEGIN

      l_Tb_Whole_Disb_Sch := p_Out_Disb_Schs;

      p_Out_Disb_Schs.DELETE;

      l_Comp_Due_Indx := Clpkss_Util.Fn_Hash_Date(p_Schedule_Linkage);

      WHILE l_Comp_Due_Indx IS NOT NULL LOOP
         -- start Log#118
         IF NOT l_Tb_Whole_Disb_Sch.EXISTS(l_Comp_Due_Indx) THEN
            l_Comp_Due_Indx := l_Tb_Whole_Disb_Sch.NEXT(l_Comp_Due_Indx);
         END IF;
         --end Log#118

         IF l_Tb_Whole_Disb_Sch(l_Comp_Due_Indx)
         .g_Disbr_Sch.Schedule_Linkage != p_Schedule_Linkage THEN
            Dbg('schedule linkagehas changed..exit now');
            EXIT;
         END IF;

         p_Out_Disb_Schs(l_Comp_Due_Indx) .g_Disbr_Sch := l_Tb_Whole_Disb_Sch(l_Comp_Due_Indx)
                                                         .g_Disbr_Sch;

         l_Comp_Due_Indx := l_Tb_Whole_Disb_Sch.NEXT(l_Comp_Due_Indx);

      END LOOP;

      l_Tb_Whole_Disb_Sch.DELETE;

      RETURN TRUE;

   EXCEPTION
      WHEN OTHERS THEN
         l_Tb_Whole_Disb_Sch.DELETE;

         Clpkss_Logger.Pr_Log_Exception('');

         RETURN FALSE;
   END Fn_Get_Disb_Schs_For_a_Linkage;

   FUNCTION Fn_Get_Revn_Schs_For_a_Linkage(p_Out_Revn_Schs    IN OUT Clpkss_Object.Ty_Tb_Revn_Schedules
                                          ,p_Schedule_Linkage IN Cltbs_Account_Schedules.Schedule_Linkage%TYPE
                                          ,p_Error_Code       IN OUT Ertbs_Msgs.Err_Code%TYPE)
      RETURN BOOLEAN IS

      l_Tb_Whole_Revn_Sch Clpkss_Object.Ty_Tb_Revn_Schedules;
      l_Comp_Due_Indx     PLS_INTEGER;

   BEGIN

      l_Tb_Whole_Revn_Sch := p_Out_Revn_Schs;

      p_Out_Revn_Schs.DELETE;

      l_Comp_Due_Indx := Clpkss_Util.Fn_Hash_Date(p_Schedule_Linkage);

      WHILE l_Comp_Due_Indx IS NOT NULL LOOP
         -- start Log#118
         IF NOT l_Tb_Whole_Revn_Sch.EXISTS(l_Comp_Due_Indx) THEN
            l_Comp_Due_Indx := l_Tb_Whole_Revn_Sch.NEXT(l_Comp_Due_Indx);
         END IF;
         --end Log#118

         IF l_Tb_Whole_Revn_Sch(l_Comp_Due_Indx)
         .g_Revn_Schedules.Schedule_Linkage != p_Schedule_Linkage THEN
            Dbg('schedule linkagehas changed..exit now');
            EXIT;
         END IF;

         p_Out_Revn_Schs(l_Comp_Due_Indx) .g_Revn_Schedules := l_Tb_Whole_Revn_Sch(l_Comp_Due_Indx)
                                                              .g_Revn_Schedules;

         l_Comp_Due_Indx := l_Tb_Whole_Revn_Sch.NEXT(l_Comp_Due_Indx);

      END LOOP;

      l_Tb_Whole_Revn_Sch.DELETE;

      RETURN TRUE;

   EXCEPTION
      WHEN OTHERS THEN
         l_Tb_Whole_Revn_Sch.DELETE;

         Clpkss_Logger.Pr_Log_Exception('');

         RETURN FALSE;
   END Fn_Get_Revn_Schs_For_a_Linkage;

   FUNCTION Fn_Get_Actual_Split_Date(p_Comp_Rec         IN OUT NOCOPY Clpkss_Object.Ty_Rec_Components
                                    ,p_Eff_Date         IN DATE
                                    ,p_Schedule_Type    IN Cltbs_Account_Comp_Sch.Schedule_Type%TYPE
                                    ,p_First_Split_Date OUT DATE
                                    ,p_Err_Code         IN OUT Ertbs_Msgs.Err_Code%TYPE)
      RETURN BOOLEAN IS
      l_Tb_Account_Sch   Clpkss_Object.Ty_Tb_Amt_Due;
      l_Tb_Disbr_Acc_Sch Clpkss_Object.Ty_Tb_Disbr_Schedules;
      l_Tb_Revn_Acc_Sch  Clpkss_Object.Ty_Tb_Revn_Schedules;
      l_Comp_Due_Indx    PLS_INTEGER;
      l_Eff_Dt_Indx      PLS_INTEGER;

   BEGIN
      Dbg('in fn_get_actual_split_date for  ' || p_Comp_Rec.Comp_Det.Component_Name);
      Dbg('and p_schedule_type is ' || p_Schedule_Type);
      l_Eff_Dt_Indx := Clpkss_Util.Fn_Hash_Date(p_Eff_Date); --dont change this

      IF p_Schedule_Type = 'P' THEN

         l_Comp_Due_Indx := l_Eff_Dt_Indx;

         l_Tb_Account_Sch := p_Comp_Rec.g_Tb_Amt_Due;

         --IF NOT l_tb_account_sch.EXISTS(l_comp_due_indx) THEN

         l_Comp_Due_Indx := l_Tb_Account_Sch.NEXT(l_Comp_Due_Indx);

         --END IF;

         WHILE l_Comp_Due_Indx IS NOT NULL LOOP
            --Log#72 Start
            IF Nvl(p_Comp_Rec.Comp_Det.Component_Type, '#') = 'P' THEN
               p_First_Split_Date := l_Tb_Account_Sch(l_Comp_Due_Indx)
                                    .g_Amount_Due.Schedule_St_Date;
            ELSE
               --Log#72 End
               p_First_Split_Date := l_Tb_Account_Sch(l_Comp_Due_Indx)
                                    .g_Amount_Due.Schedule_Due_Date;
            END IF; --Log#72

            /*   IF (nvl(l_tb_account_sch(l_comp_due_indx).g_amount_due.amount_due,0) <>
                nvl(l_tb_account_sch(l_comp_due_indx).g_amount_due.amount_settled,0)
                --Start log#72
                          AND
                          NVL(l_tb_account_sch(l_comp_due_indx).g_amount_due.amount_settled,0) = 0
                          )
            --End log#72
             THEN
                EXIT;
             END IF;*/
            --START Prasanna EURO BANK ISSUE. 09-Feb-2006.
            --In case of a Manual Disbursement account, if disbursement was not done
            --Payment Comp Sch was not allowed to be edited
            /***
            IF (nvl(l_tb_account_sch(l_comp_due_indx).g_amount_due.amount_due,0) <>
               nvl(l_tb_account_sch(l_comp_due_indx).g_amount_due.amount_settled,0)
               )
            ***/
            IF ((Nvl(l_Tb_Account_Sch(l_Comp_Due_Indx).g_Amount_Due.Amount_Due, 0) > 0 AND
               (Nvl(l_Tb_Account_Sch(l_Comp_Due_Indx).g_Amount_Due.Amount_Due, 0) <>
               Nvl(l_Tb_Account_Sch(l_Comp_Due_Indx).g_Amount_Due.Amount_Settled, 0))) OR
               (Nvl(l_Tb_Account_Sch(l_Comp_Due_Indx).g_Amount_Due.Amount_Due, 0) = 0))
            --END Prasanna EURO BANK ISSUE. 09-Feb-2006.
            --In case of a Manual Disbursement account, if disbursement was not done
            --Payment Comp Sch was not allowed to be edited
             THEN
               EXIT;
            END IF;

            l_Comp_Due_Indx := l_Tb_Account_Sch.NEXT(l_Comp_Due_Indx);
         END LOOP;
         Dbg('p_first_Psplit_date derived as  ' || p_First_Split_Date);
         l_Tb_Account_Sch.DELETE;
      END IF;
      --R type
      IF p_Schedule_Type = 'R' THEN
         l_Comp_Due_Indx := l_Eff_Dt_Indx;

         l_Tb_Revn_Acc_Sch := p_Comp_Rec.g_Tb_Revn_Schedules;

         --IF NOT l_tb_revn_acc_sch.EXISTS(l_comp_due_indx) THEN --Log#113 For RETRO EUROBANK

         l_Comp_Due_Indx := l_Tb_Revn_Acc_Sch.NEXT(l_Comp_Due_Indx);

         --END IF;   --Log#113 For RETRO EUROBANK
         IF l_Comp_Due_Indx IS NOT NULL THEN
            BEGIN
               p_First_Split_Date := l_Tb_Revn_Acc_Sch(l_Comp_Due_Indx)
                                    .g_Revn_Schedules.Schedule_Due_Date;
            EXCEPTION
               WHEN No_Data_Found THEN
                  p_First_Split_Date := NULL;
            END;
         END IF;
         Dbg('p_first_Rsplit_date is ' || p_First_Split_Date);
         l_Tb_Revn_Acc_Sch.DELETE;
      END IF;

      --D type
      IF p_Schedule_Type = 'D' THEN
         l_Comp_Due_Indx := l_Eff_Dt_Indx;

         l_Tb_Disbr_Acc_Sch := p_Comp_Rec.g_Tb_Disbr_Schedules;

         IF NOT l_Tb_Disbr_Acc_Sch.EXISTS(l_Comp_Due_Indx) THEN

            l_Comp_Due_Indx := l_Tb_Disbr_Acc_Sch.NEXT(l_Comp_Due_Indx);

         END IF;
         IF l_Comp_Due_Indx IS NOT NULL THEN
            BEGIN
               p_First_Split_Date := l_Tb_Disbr_Acc_Sch(l_Comp_Due_Indx)
                                    .g_Disbr_Sch.Schedule_Due_Date;
            EXCEPTION
               WHEN No_Data_Found THEN
                  p_First_Split_Date := NULL;
                  --Log#120 STARTS
                  IF l_Tb_Disbr_Acc_Sch.COUNT = 1 THEN
                     p_First_Split_Date := l_Tb_Disbr_Acc_Sch(l_Tb_Disbr_Acc_Sch.FIRST)
                                          .g_Disbr_Sch.Schedule_Due_Date;
                  END IF;
                  --Log#120 ENDS
            END;
            --Log#120 STARTS
         ELSE
            IF l_Tb_Disbr_Acc_Sch.COUNT = 1 THEN
               p_First_Split_Date := l_Tb_Disbr_Acc_Sch(l_Tb_Disbr_Acc_Sch.FIRST)
                                    .g_Disbr_Sch.Schedule_Due_Date;
            END IF;
            --Log#120 ENDS
         END IF;
         l_Tb_Disbr_Acc_Sch.DELETE;
         Dbg('p_first_Dsplit_date is ' || p_First_Split_Date);
      END IF;

      Dbg('returning from fn_get_actual_split_date ');

      RETURN TRUE;

   EXCEPTION
      WHEN OTHERS THEN
         Dbg('in when others of  fn_get_actual_split_date with ' || SQLERRM);

         l_Tb_Account_Sch.DELETE;
         l_Tb_Revn_Acc_Sch.DELETE;
         l_Tb_Disbr_Acc_Sch.DELETE;

         Clpkss_Logger.Pr_Log_Exception('');

         RETURN FALSE;

   END Fn_Get_Actual_Split_Date;

   FUNCTION Fn_Gen_Split_Schedules(p_Account_Rec IN OUT NOCOPY Clpkss_Object.Ty_Rec_Account
                                  ,p_Eff_Date    IN Cltbs_Account_Comp_Sch.Sch_Start_Date%TYPE
                                  ,
                                   --Start ravi for increase tenor changes
                                   p_Tb_Indicator IN OUT Clpks_Schedules.Ty_Tb_Indicator
                                  ,
                                   --End ravi for increase tenor changes
                                   p_Err_Code  IN OUT Ertbs_Msgs.Err_Code%TYPE
                                  ,p_Err_Param IN OUT Ertbs_Msgs.Message%TYPE)
      RETURN BOOLEAN IS

      l_Cascade_Movement  Cltms_Product.Cascade_Schedules%TYPE;
      l_Past_Sch_Cnt      NUMBER;
      l_No_Of_Schedules   NUMBER;
      l_Last_Sch_End_Dt   DATE;
      l_Next_Sch_Date     DATE;
      l_First_Due_Date    DATE;
      l_Sch_End_Date      DATE;
      l_New_Rec_Indx      VARCHAR2(100);
      l_Comp_Indx         VARCHAR2(64);
      l_Comp_Sch_Indx     VARCHAR2(64);
      l_Comp_Due_Indx     VARCHAR2(64);
      l_Tb_Account_Sch    Clpkss_Object.Ty_Tb_Amt_Due;
      l_Tb_Disbr_Acc_Sch  Clpkss_Object.Ty_Tb_Disbr_Schedules;
      l_Tb_Revn_Acc_Sch   Clpkss_Object.Ty_Tb_Revn_Schedules;
      l_Comp_Rec          Clpkss_Object.Ty_Rec_Components;
      l_First_Psplit_Date DATE;
      l_First_Dsplit_Date DATE;
      l_First_Rsplit_Date DATE;
      l_Bool              BOOLEAN;
      l_Scheule_Linkage   Cltbs_Account_Schedules.Schedule_Linkage%TYPE;
      l_Eff_Comp_Sch_Rec  Clpkss_Object.Ty_Rec_Account_Comp_Sch;
      l_New_Comp_Sch_Rec  Clpkss_Object.Ty_Rec_Account_Comp_Sch;
      --> Sudharshan: Mar 18,2005
      l_Rec_Prod Cltms_Product%ROWTYPE;
      --> Sudharshan: Mar 18,2005

      --START Prasanna/Kiran Nedbank Demo support. 28-Jan-2006.
      l_Continue BOOLEAN;
      --END Prasanna/Kiran Nedbank Demo support. 28-Jan-2006.
      --Starts Log#111
      Result        VARCHAR2(1);
      Linkage_Index PLS_INTEGER;
      --Ends Log#111
      --Log#160 Starts
      l_last_dsbrdate    cltbs_amount_recd.recd_date%TYPE;
      --Log#160 Ends
   BEGIN

      Dbg('Begin of the function fn_split_schedules');

      --MTR1 SFR#136
      g_Tb_Acc_Hol_Perds := p_Account_Rec.g_Hol_Perds;

      Dbg('input effective date is ' || p_Eff_Date);

      BEGIN
         -->Sudharshan: Mar 18,2005
         --l_rec_prod := clpks_cache.fn_product(p_account_rec.account_det.account_number); -- Commented L Anantharaman 12-Apr-2005 FCCCL1.0 PhaseII IQA
         l_Rec_Prod := Clpks_Cache.Fn_Product(p_Account_Rec.Account_Det.Product_Code); --  L Anantharaman 12-Apr-2005 FCCCL1.0 PhaseII IQA

         --l_cascade_movement := nvl(p_account_rec.account_det.cascade_schedules,'N');
         l_Cascade_Movement := Nvl(l_Rec_Prod.Cascade_Schedules, 'N');
         -->Sudharshan: Mar 18,2005
      EXCEPTION
         WHEN No_Data_Found THEN
            Dbg('no data found will return false');
            p_Err_Code := 'CL-SCH006;';
            Ovpkss.Pr_Appendtbl(p_Err_Code, '');
            RETURN FALSE;
      END;

      l_Comp_Indx := p_Account_Rec.g_Tb_Components.FIRST;

      WHILE l_Comp_Indx IS NOT NULL LOOP
         Dbg('Component is ' || l_Comp_Indx);
	 --  Log#139 Starts
	  if  p_Account_Rec.g_Tb_Components(l_Comp_Indx).comp_det.component_type in ('I','L') then
	  --Log#139 Ends

         l_Comp_Rec := p_Account_Rec.g_Tb_Components(l_Comp_Indx);

         l_Bool := Fn_Get_Actual_Split_Date(l_Comp_Rec
                                           ,p_Eff_Date
                                           ,'P'
                                           ,l_First_Psplit_Date
                                           ,p_Err_Code);
         IF l_Bool = FALSE THEN
            RETURN FALSE;
         END IF;

         --Process P types

dbg('l_Comp_Indx: '||l_Comp_Indx);
IF l_First_Psplit_Date IS NOT NULL THEN
            Dbg('processing for P type ..l_first_Psplit_date being ' ||
                l_First_Psplit_Date);

	    dbg('g_amount_due count: '||p_Account_Rec.g_Tb_Components(l_Comp_Indx)
                                .g_Tb_Amt_Due.count);

            l_Comp_Due_Indx := Clpkss_Util.Fn_Hash_Date(l_First_Psplit_Date);

            l_Scheule_Linkage := p_Account_Rec.g_Tb_Components(l_Comp_Indx)
                                .g_Tb_Amt_Due(l_Comp_Due_Indx)
                                .g_Amount_Due.Schedule_Linkage;

            IF l_Scheule_Linkage IS NULL THEN
               l_Tb_Account_Sch.DELETE;
               l_Tb_Revn_Acc_Sch.DELETE;
               l_Tb_Disbr_Acc_Sch.DELETE;
               p_Err_Code := 'CL-SCH030;';
               Ovpkss.Pr_Appendtbl(p_Err_Code, '');
               RETURN FALSE;
            END IF;

dbg('l_Scheule_Linkage: '||l_Scheule_Linkage);
l_Comp_Sch_Indx := 'P' || Clpkss_Util.Fn_Hash_Date(l_Scheule_Linkage, NULL);

            --MTR1 SFR #136 ..change done to take Amortization into consideration
            --For fully amortized components also P_split date will be returned for Principal,but
            --there wont be any corresponding row in comp_Sch..need to be handled here..
            ----CL PHASE II Corfo Related Enahncements
            IF l_Comp_Indx = Pkg_Principal OR
               Nvl(l_Comp_Rec.Comp_Det.Component_Type, '*') = 'L' THEN
               --Phase II NLS changes

               IF (p_Account_Rec.g_Tb_Components(l_Comp_Indx)
                  .g_Tb_Amt_Due(l_Comp_Due_Indx).g_Amount_Due.Schedule_Type IS NULL) THEN
                  --get the first comp sch that belongs to Principal
                  l_Comp_Sch_Indx := p_Account_Rec.g_Tb_Components(l_Comp_Indx)
                                    .g_Tb_Comp_Sch.NEXT(l_Comp_Sch_Indx);
               END IF;
            END IF;

            IF l_Comp_Sch_Indx IS NOT NULL --In case of fully amortized/or amortize being the
             THEN
               --last formula there wont be any Principal
               BEGIN
                  l_Eff_Comp_Sch_Rec := p_Account_Rec.g_Tb_Components(l_Comp_Indx)
                                       .g_Tb_Comp_Sch(l_Comp_Sch_Indx);
                  l_First_Due_Date   := l_Eff_Comp_Sch_Rec.g_Account_Comp_Sch.First_Due_Date;
                  l_Sch_End_Date     := l_Eff_Comp_Sch_Rec.g_Account_Comp_Sch.Sch_End_Date;
                  l_No_Of_Schedules  := l_Eff_Comp_Sch_Rec.g_Account_Comp_Sch.No_Of_Schedules;

               EXCEPTION
                  WHEN No_Data_Found THEN
                     p_Err_Code := 'CL-SCH030;';
                     Ovpkss.Pr_Appendtbl(p_Err_Code, '');
                     l_Tb_Account_Sch.DELETE;
                     l_Tb_Revn_Acc_Sch.DELETE;
                     l_Tb_Disbr_Acc_Sch.DELETE;

                     RETURN FALSE;
               END;

               l_Tb_Account_Sch := p_Account_Rec.g_Tb_Components(l_Comp_Indx)
                                  .g_Tb_Amt_Due;
               -- log#173 changes start
               if nvl(l_Rec_Prod.ignore_holidays,'N') = 'N'
               then
               -- log#173 changes end
               --Starts Log#111
               IF NOT Clpks_Util.Fn_Isholiday(l_First_Due_Date
                                             ,p_Account_Rec.Account_Det.Branch_Code
                                             ,Result) THEN
                  p_Err_Code := 'CL-SCH014;';
                  Ovpkss.Pr_Appendtbl(p_Err_Code, '');
                  Dbg('bombed in CLPKS_UTIL.fn_isholiday with ' || SQLERRM);
                  RETURN FALSE;
               END IF;
               IF Nvl(Result, 'W') = 'H' THEN

                  Linkage_Index    := p_Account_Rec.g_Tb_Components(l_Comp_Indx)
                                     .g_Tb_Amt_Due.FIRST;
                  l_First_Due_Date := p_Account_Rec.g_Tb_Components(l_Comp_Indx)
                                     .g_Tb_Amt_Due(Linkage_Index)
                                     .g_Amount_Due.Schedule_Due_Date;
               END IF;
               --Ends Log#111
			   end if; -- log#173 changes
               l_Bool := Fn_Get_Acc_Schs_For_a_Linkage(l_Tb_Account_Sch
                                                      ,l_First_Due_Date
                                                      ,p_Err_Code);
               IF l_Bool = FALSE THEN
                  Dbg('fn_get_acc_schs_for_a_linkage returned false');
                  l_Tb_Account_Sch.DELETE;
                  l_Tb_Revn_Acc_Sch.DELETE;
                  l_Tb_Disbr_Acc_Sch.DELETE;
                  RETURN FALSE;
               END IF;

               IF l_Tb_Account_Sch.COUNT = 0 THEN
                  Dbg('NO data found in amount due');

                  l_Tb_Account_Sch.DELETE;
                  l_Tb_Revn_Acc_Sch.DELETE;
                  l_Tb_Disbr_Acc_Sch.DELETE;

                  RETURN FALSE;
               END IF;

               l_Comp_Due_Indx := l_Tb_Account_Sch.FIRST;

               l_Past_Sch_Cnt := 0;

               WHILE l_Comp_Due_Indx IS NOT NULL LOOP
                  Dbg('Inside due - ' || l_Tb_Account_Sch(l_Comp_Due_Indx)
                      .g_Amount_Due.Schedule_Due_Date);

                  IF l_Tb_Account_Sch(l_Comp_Due_Indx)
                  .g_Amount_Due.Schedule_Due_Date < l_First_Psplit_Date THEN
                     -- Storing the last schedule due date which are settled.
                     Dbg('schedule_due_date smaller than p_eff_date increase count');
                     l_Past_Sch_Cnt    := l_Past_Sch_Cnt + 1;
                     l_Last_Sch_End_Dt := l_Tb_Account_Sch(l_Comp_Due_Indx)
                                         .g_Amount_Due.Schedule_Due_Date;
                     Dbg('l_past_sch_cnt is ' || l_Past_Sch_Cnt);
                     --this will be the end date for the existing guy and start date for the next guy

                  ELSE
                     l_Next_Sch_Date := l_Tb_Account_Sch(l_Comp_Due_Indx)
                                       .g_Amount_Due.Schedule_Due_Date;
                     --this should be the new first_due_date for added comp sch
                     EXIT;
                  END IF;

                  l_Comp_Due_Indx := l_Tb_Account_Sch.NEXT(l_Comp_Due_Indx);

               END LOOP;

               l_New_Comp_Sch_Rec := NULL;

               IF l_Past_Sch_Cnt > 0 THEN
               --Log#148   start
	       --LOG#151 STARTS COMMENTING
                 /* IF NVL(p_account_rec.account_det.lease_type,'X') ='F'
		                AND NVL(p_account_rec.account_det.lease_payment_mode,'X')  = 'A'
                   THEN
                   Pkg_lease_advance := TRUE;
               END IF;    */
	        --LOG#151 ENDS COMMENTING
               --Log#148 end
                  l_Bool := Fn_Get_New_Split_Schedules(l_Eff_Comp_Sch_Rec
                                                      ,l_Last_Sch_End_Dt
                                                      ,l_Past_Sch_Cnt
                                                      ,l_Next_Sch_Date
                                                      ,l_Cascade_Movement
                                                      ,l_New_Comp_Sch_Rec
                                                      ,p_Err_Code);

                  IF l_Bool = FALSE THEN

                     l_Tb_Account_Sch.DELETE;
                     l_Tb_Revn_Acc_Sch.DELETE;
                     l_Tb_Disbr_Acc_Sch.DELETE;

                     RETURN FALSE;
                  END IF;

                  l_New_Rec_Indx := 'P' || Clpkss_Util.Fn_Hash_Date(l_New_Comp_Sch_Rec.g_Account_Comp_Sch.First_Due_Date
                                                                   ,NULL);

				---- Log#162 Changes for 11.1 Dev (Payment in Advance) Start
                  IF nvl(p_Account_Rec.account_det.module_code,'#')='CL'
                  and nvl(l_Rec_Prod.lease_payment_mode,'#')='A'
                  and nvl(l_Rec_Prod.lease_type,'#')='F'
                  and l_Eff_Comp_Sch_Rec.g_Account_Comp_Sch.SCH_START_DATE = l_New_Comp_Sch_Rec.g_Account_Comp_Sch.SCH_START_DATE
                  and l_Eff_Comp_Sch_Rec.g_Account_Comp_Sch.SCH_START_DATE = p_Account_Rec.account_det.value_date
                  then
                      dbg('no Need to split');
                  else
                  --Log#162 Changes for 11.1 Dev (Payment in Advance) End
                  p_Account_Rec.g_Tb_Components(l_Comp_Indx) .g_Tb_Comp_Sch.DELETE(l_Comp_Sch_Indx);
                  p_Account_Rec.g_Tb_Components(l_Comp_Indx) .g_Tb_Comp_Sch(l_Comp_Sch_Indx) := l_Eff_Comp_Sch_Rec;
                  p_Account_Rec.g_Tb_Components(l_Comp_Indx) .g_Tb_Comp_Sch(l_New_Rec_Indx) := l_New_Comp_Sch_Rec;
				END IF; --Log#162 Changes for 11.1 Dev (Payment in Advance)
			   END IF;
               --populate indicator table
               --p_tb_indicator(l_comp_indx).g_schedule_type := 'P';
               --                  IF l_new_comp_sch_rec.g_account_comp_sch.unit <> 'B'  --  Log#72
               IF l_Eff_Comp_Sch_Rec.g_Account_Comp_Sch.Unit <> 'B' -- log#94 on 16-feb-2006
                THEN
                  --  Log#72.

                  --log#94
                  p_Tb_Indicator(l_Comp_Indx) .g_First_Editable_p_Due_Date := Nvl(l_New_Comp_Sch_Rec.g_Account_Comp_Sch.First_Due_Date
                                                                                 ,l_First_Due_Date);
               ELSIF p_Account_Rec.Account_Det.Maturity_Date >= Global.Application_Date
			-- log#181 changes start - undo log#123 changes
               AND
               NVL(p_account_rec.g_tb_components(l_comp_indx).g_tb_amt_due(p_account_rec.g_tb_components(l_comp_indx).g_tb_amt_due.FIRST).g_amount_due.amount_settled,0) = 0
               /***     --log#123 Changes start
                     AND ((Nvl(p_Account_Rec.g_Tb_Components(l_Comp_Indx)
                               .g_Tb_Amt_Due(p_Account_Rec.g_Tb_Components(l_Comp_Indx)
                                            .g_Tb_Amt_Due.FIRST).g_Amount_Due.Amount_Due
                              ,0) > 0 AND
                     (Nvl(p_Account_Rec.g_Tb_Components(l_Comp_Indx)
                                .g_Tb_Amt_Due(p_Account_Rec.g_Tb_Components(l_Comp_Indx)
                                             .g_Tb_Amt_Due.FIRST).g_Amount_Due.Amount_Due
                               ,0) <> Nvl(p_Account_Rec.g_Tb_Components(l_Comp_Indx)
                                                 .g_Tb_Amt_Due(p_Account_Rec.g_Tb_Components(l_Comp_Indx)
                                                              .g_Tb_Amt_Due.FIRST)
                                                 .g_Amount_Due.Amount_Settled
                                                ,0))) OR
                     (Nvl(p_Account_Rec.g_Tb_Components(l_Comp_Indx)
                               .g_Tb_Amt_Due(p_Account_Rec.g_Tb_Components(l_Comp_Indx)
                                            .g_Tb_Amt_Due.FIRST).g_Amount_Due.Amount_Due
                              ,0) = 0))
               --log#123 Changes end
               ***/
               -- log#181 changes end
                THEN
                  --log#94
                  p_Tb_Indicator(l_Comp_Indx) .g_First_Editable_p_Due_Date := Nvl(l_New_Comp_Sch_Rec.g_Account_Comp_Sch.First_Due_Date
                                                                                 ,l_First_Due_Date);
                END IF; --  Log#72.

               l_Tb_Account_Sch.DELETE;

            END IF;

         END IF;
         --process R type
         l_Bool := Fn_Get_Actual_Split_Date(l_Comp_Rec
                                           ,p_Eff_Date
                                           ,'R'
                                           ,l_First_Rsplit_Date
                                           ,p_Err_Code);
         IF l_Bool = FALSE THEN
            RETURN FALSE;
         END IF;

         IF l_First_Rsplit_Date IS NOT NULL THEN
            Dbg('processing for R type ..l_first_Rsplit_date being ' ||
                l_First_Rsplit_Date);
            l_Comp_Due_Indx := Clpkss_Util.Fn_Hash_Date(l_First_Rsplit_Date);

            l_Scheule_Linkage := p_Account_Rec.g_Tb_Components(l_Comp_Indx)
                                .g_Tb_Revn_Schedules(l_Comp_Due_Indx)
                                .g_Revn_Schedules.Schedule_Linkage;

            IF l_Scheule_Linkage IS NULL THEN
               p_Err_Code := 'CL-SCH030;';
               Ovpkss.Pr_Appendtbl(p_Err_Code, '');

               l_Tb_Account_Sch.DELETE;
               l_Tb_Revn_Acc_Sch.DELETE;
               l_Tb_Disbr_Acc_Sch.DELETE;

               RETURN FALSE;
            END IF;

            l_Comp_Sch_Indx := 'R' || Clpkss_Util.Fn_Hash_Date(l_Scheule_Linkage, NULL);

            BEGIN
               l_Eff_Comp_Sch_Rec := p_Account_Rec.g_Tb_Components(l_Comp_Indx)
                                    .g_Tb_Comp_Sch(l_Comp_Sch_Indx);
               l_First_Due_Date   := l_Eff_Comp_Sch_Rec.g_Account_Comp_Sch.First_Due_Date;
               l_Sch_End_Date     := l_Eff_Comp_Sch_Rec.g_Account_Comp_Sch.Sch_End_Date;
               l_No_Of_Schedules  := l_Eff_Comp_Sch_Rec.g_Account_Comp_Sch.No_Of_Schedules;

            EXCEPTION
               WHEN No_Data_Found THEN
                  l_Tb_Account_Sch.DELETE;
                  l_Tb_Revn_Acc_Sch.DELETE;
                  l_Tb_Disbr_Acc_Sch.DELETE;
                  p_Err_Code := 'CL-SCH030;';
                  Ovpkss.Pr_Appendtbl(p_Err_Code, '');
                  RETURN FALSE;
            END;

            l_Tb_Revn_Acc_Sch := p_Account_Rec.g_Tb_Components(l_Comp_Indx)
                                .g_Tb_Revn_Schedules;
		   -- log#173 changes start
		   if nvl(l_Rec_Prod.ignore_holidays,'N') = 'N'
		   then
		   -- log#173 changes end
            --SStarts  Log#111
            IF NOT Clpks_Util.Fn_Isholiday(l_First_Due_Date
                                          ,p_Account_Rec.Account_Det.Branch_Code
                                          ,Result) THEN
               p_Err_Code := 'CL-SCH014;';
               Ovpkss.Pr_Appendtbl(p_Err_Code, '');
               Dbg('bombed in CLPKS_UTIL.fn_isholiday with ' || SQLERRM);
               RETURN FALSE;
            END IF;
            IF Nvl(Result, 'W') = 'H' THEN
               --Log#118 Start
               /**
               linkage_index := p_account_rec.g_tb_components(l_comp_indx).g_tb_amt_due.FIRST;
               l_first_due_date := p_account_rec.g_tb_components(l_comp_indx).g_tb_amt_due(linkage_index).g_amount_due.SCHEDULE_DUE_DATE;
               **/
               Linkage_Index    := p_Account_Rec.g_Tb_Components(l_Comp_Indx)
                                  .g_Tb_Revn_Schedules.FIRST;
               l_First_Due_Date := p_Account_Rec.g_Tb_Components(l_Comp_Indx)
                                  .g_Tb_Revn_Schedules(Linkage_Index)
                                  .g_Revn_Schedules.Schedule_Due_Date;
               --Log#118 End
            END IF;
            --End Log#111
			end if; -- log#173 changes
            l_Bool := Fn_Get_Revn_Schs_For_a_Linkage(l_Tb_Revn_Acc_Sch
                                                    ,l_First_Due_Date
                                                    ,p_Err_Code);
            IF l_Bool = FALSE THEN
               Dbg('fn_get_acc_schs_for_a_linkage returned false');
               l_Tb_Account_Sch.DELETE;
               l_Tb_Revn_Acc_Sch.DELETE;
               l_Tb_Disbr_Acc_Sch.DELETE;
               RETURN FALSE;
            END IF;

            IF l_Tb_Revn_Acc_Sch.COUNT = 0 THEN
               Dbg('NO data found in amount due');
               RETURN FALSE;
            END IF;

            l_Comp_Due_Indx := l_Tb_Revn_Acc_Sch.FIRST;

            l_Past_Sch_Cnt := 0;

            WHILE l_Comp_Due_Indx IS NOT NULL LOOP
               Dbg('Inside due - ' || l_Tb_Revn_Acc_Sch(l_Comp_Due_Indx)
                   .g_Revn_Schedules.Schedule_Due_Date);

               IF l_Tb_Revn_Acc_Sch(l_Comp_Due_Indx)
               .g_Revn_Schedules.Schedule_Due_Date < l_First_Rsplit_Date THEN
                  -- Storing the last schedule due date which are settled.
                  Dbg('schedule_due_date smaller than p_eff_date increase count');
                  l_Past_Sch_Cnt    := l_Past_Sch_Cnt + 1;
                  l_Last_Sch_End_Dt := l_Tb_Revn_Acc_Sch(l_Comp_Due_Indx)
                                      .g_Revn_Schedules.Schedule_Due_Date;
                  Dbg('l_past_sch_cnt is ' || l_Past_Sch_Cnt);
                  --this will be the end date for the existing guy and start date for the next guy

               ELSE
                  l_Next_Sch_Date := l_Tb_Revn_Acc_Sch(l_Comp_Due_Indx)
                                    .g_Revn_Schedules.Schedule_Due_Date;
                  --this should be the new first_due_date for added comp sch
                  EXIT;
               END IF;

               l_Comp_Due_Indx := l_Tb_Revn_Acc_Sch.NEXT(l_Comp_Due_Indx);

            END LOOP;
            l_New_Comp_Sch_Rec := NULL;
            IF l_Past_Sch_Cnt > 0 THEN
               l_Bool := Fn_Get_New_Split_Schedules(l_Eff_Comp_Sch_Rec
                                                   ,l_Last_Sch_End_Dt
                                                   ,l_Past_Sch_Cnt
                                                   ,l_Next_Sch_Date
                                                   ,l_Cascade_Movement
                                                   ,l_New_Comp_Sch_Rec
                                                   ,p_Err_Code);
               IF l_Bool = FALSE THEN

                  l_Tb_Account_Sch.DELETE;
                  l_Tb_Revn_Acc_Sch.DELETE;
                  l_Tb_Disbr_Acc_Sch.DELETE;

                  RETURN FALSE;
               END IF;

               l_New_Rec_Indx := 'R' || Clpkss_Util.Fn_Hash_Date(l_New_Comp_Sch_Rec.g_Account_Comp_Sch.First_Due_Date
                                                                ,NULL);

				---- Log#162 Changes for 11.1 Dev (Payment in Advance) Start
                  IF nvl(p_Account_Rec.account_det.module_code,'#')='CL'
                  and nvl(l_Rec_Prod.lease_payment_mode,'#')='A'
                  and nvl(l_Rec_Prod.lease_type,'#')='F'
                  and l_Eff_Comp_Sch_Rec.g_Account_Comp_Sch.SCH_START_DATE = l_New_Comp_Sch_Rec.g_Account_Comp_Sch.SCH_START_DATE
                  and l_Eff_Comp_Sch_Rec.g_Account_Comp_Sch.SCH_START_DATE = p_Account_Rec.account_det.value_date
                  then
                      dbg('no Need to split');
                  else
                  ---- Log#162 Changes for 11.1 Dev (Payment in Advance) End
               p_Account_Rec.g_Tb_Components(l_Comp_Indx) .g_Tb_Comp_Sch.DELETE(l_Comp_Sch_Indx);
               p_Account_Rec.g_Tb_Components(l_Comp_Indx) .g_Tb_Comp_Sch(l_Comp_Sch_Indx) := l_Eff_Comp_Sch_Rec;
               p_Account_Rec.g_Tb_Components(l_Comp_Indx) .g_Tb_Comp_Sch(l_New_Rec_Indx) := l_New_Comp_Sch_Rec;
				END IF; -- Log#162 Changes for 11.1 Dev (Payment in Advance)
            END IF;
            --populate indicator table
            --p_tb_indicator(l_comp_indx).g_schedule_type := 'R';

            --Log#113 changes start
            /***
            p_tb_indicator(l_comp_indx).g_first_editable_d_due_date :=
              NVL(l_new_comp_sch_rec.g_account_comp_sch.first_due_date,l_first_due_date);
            ***/
            p_Tb_Indicator(l_Comp_Indx) .g_First_Editable_r_Due_Date := Nvl(l_New_Comp_Sch_Rec.g_Account_Comp_Sch.First_Due_Date
                                                                           ,l_First_Due_Date);
            --Log#113 changes end

            l_Tb_Revn_Acc_Sch.DELETE;

         END IF;

         --process D type
         --Log#99 Starts
         --START Prasanna/Santosh 03-MAY-2006. Issue while splitting for a Manual disbursement product.
         --ALPHABANK issue.
         IF Clpkss_Cache.Fn_Product(p_Account_Rec.Account_Det.Product_Code)
         .Disbursement_Mode = 'A' THEN

            l_Bool := Fn_Get_Actual_Split_Date(l_Comp_Rec
                                              ,p_Eff_Date
                                              ,'D'
                                              ,l_First_Dsplit_Date
                                              ,p_Err_Code);
            IF l_Bool = FALSE THEN
               RETURN FALSE;
            END IF;

            IF l_First_Dsplit_Date IS NOT NULL THEN

               Dbg('processing for D type ..l_first_Dsplit_date being ' ||
                   l_First_Dsplit_Date);

               --START Prasanna/Kiran Nedbank Demo support. 28-Jan-2006.
               l_Continue := TRUE;
               --END Prasanna/Kiran Nedbank Demo support. 28-Jan-2006.

               l_Comp_Due_Indx := Clpkss_Util.Fn_Hash_Date(l_First_Dsplit_Date);

               l_Scheule_Linkage := p_Account_Rec.g_Tb_Components(l_Comp_Indx)
                                   .g_Tb_Disbr_Schedules(l_Comp_Due_Indx)
                                   .g_Disbr_Sch.Schedule_Linkage;

               IF l_Scheule_Linkage IS NULL THEN
                  --START Prasanna/Kiran Nedbank Demo support. 28-Jan-2006.
                  /***
                  p_err_code := 'CL-SCH030;';
                   ovpkss.pr_appendTbl(p_err_code,'');
                  l_tb_account_sch.DELETE;
                  l_tb_revn_acc_sch.DELETE;
                  l_tb_disbr_acc_sch.DELETE;
                  RETURN FALSE;
                  ***/
                  l_Continue := FALSE;
                  --END Prasanna/Kiran Nedbank Demo support. 28-Jan-2006.
               END IF;

               --START Prasanna/Kiran Nedbank Demo support. 28-Jan-2006.
               IF l_Continue THEN

                  l_Comp_Sch_Indx := 'D' ||
                                     Clpkss_Util.Fn_Hash_Date(l_Scheule_Linkage, NULL);

                  BEGIN
                     l_Eff_Comp_Sch_Rec := p_Account_Rec.g_Tb_Components(l_Comp_Indx)
                                          .g_Tb_Comp_Sch(l_Comp_Sch_Indx);
                     l_First_Due_Date   := l_Eff_Comp_Sch_Rec.g_Account_Comp_Sch.First_Due_Date;
                     l_Sch_End_Date     := l_Eff_Comp_Sch_Rec.g_Account_Comp_Sch.Sch_End_Date;
                     l_No_Of_Schedules  := l_Eff_Comp_Sch_Rec.g_Account_Comp_Sch.No_Of_Schedules;

                  EXCEPTION
                     WHEN No_Data_Found THEN

                        --START Prasanna/Kiran Nedbank Demo support. 28-Jan-2006.
                        /***
                        l_tb_account_sch.DELETE;
                        l_tb_revn_acc_sch.DELETE;
                        l_tb_disbr_acc_sch.DELETE;
                        p_err_code := 'CL-SCH030;';
                         ovpkss.pr_appendTbl(p_err_code,'');

                        RETURN FALSE;
                        ***/
                        l_Continue := FALSE;
                        --END Prasanna/Kiran Nedbank Demo support. 28-Jan-2006.
                  END;

                  --START Prasanna/Kiran Nedbank Demo support. 28-Jan-2006.
                  IF l_Continue THEN

                     l_Tb_Disbr_Acc_Sch := p_Account_Rec.g_Tb_Components(l_Comp_Indx)
                                          .g_Tb_Disbr_Schedules;
				   -- log#173 changes start
				   if nvl(l_Rec_Prod.ignore_holidays,'N') = 'N'
				   then
				   -- log#173 changes end
                     --Starts  Log#111
                     IF NOT Clpks_Util.Fn_Isholiday(l_First_Due_Date
                                                   ,p_Account_Rec.Account_Det.Branch_Code
                                                   ,Result) THEN
                        p_Err_Code := 'CL-SCH014;';
                        Ovpkss.Pr_Appendtbl(p_Err_Code, '');
                        Dbg('bombed in CLPKS_UTIL.fn_isholiday with ' || SQLERRM);
                        RETURN FALSE;
                     END IF;
                     IF Nvl(Result, 'W') = 'H' THEN
                        --Log#118 Start
                        /**
                        linkage_index := p_account_rec.g_tb_components(l_comp_indx).g_tb_amt_due.FIRST;
                        l_first_due_date := p_account_rec.g_tb_components(l_comp_indx).g_tb_amt_due(linkage_index).g_amount_due.SCHEDULE_DUE_DATE;
                        **/
                        Linkage_Index    := p_Account_Rec.g_Tb_Components(l_Comp_Indx)
                                           .g_Tb_Disbr_Schedules.FIRST;
                        l_First_Due_Date := p_Account_Rec.g_Tb_Components(l_Comp_Indx)
                                           .g_Tb_Disbr_Schedules(Linkage_Index)
                                           .g_Disbr_Sch.Schedule_Due_Date;
                        --Log#118 End
                     END IF;
                     --Ends Log#111
				     end if; -- log#173 changes
                     l_Bool := Fn_Get_Disb_Schs_For_a_Linkage(l_Tb_Disbr_Acc_Sch
                                                             ,l_First_Due_Date
                                                             ,p_Err_Code);
                     IF l_Bool = FALSE THEN
                        Dbg('fn_get_acc_schs_for_a_linkage returned false');
                        l_Tb_Disbr_Acc_Sch.DELETE;
                        RETURN FALSE;
                     END IF;

                     IF l_Tb_Disbr_Acc_Sch.COUNT = 0 THEN
                        Dbg('NO data found in amount due');
                        RETURN FALSE;
                     END IF;

                     l_Comp_Due_Indx := l_Tb_Disbr_Acc_Sch.FIRST;

                     l_Past_Sch_Cnt := 0;
                     --Log#160 Starts
                      IF c3pk#_prd_shell.fn_get_contract_info(  p_Account_Rec.account_det.account_number
                                                              , p_Account_Rec.account_det.branch_code
                      		                                    , 'LOAN_TYPE'
                                                              , p_Account_Rec.account_det.product_code
                      		                                    )='R'
                      THEN
                           BEGIN
                                SELECT MAX(a.recd_date) INTO l_last_dsbrdate
                                  FROM cltbs_amount_recd a
                                WHERE a.account_number = p_Account_Rec.account_det.account_number
                                  AND a.branch_code    = p_Account_Rec.account_det.branch_code
                                  AND a.component_name = PKG_PRINCIPAL
                                  AND a.recd_type ='D'
                                  ;
                           EXCEPTION
                                WHEN NO_DATA_FOUND THEN
                                l_last_dsbrdate := NULL;
                           END;
                           dbg('l_last_dsbrdate'||l_last_dsbrdate||'~ l_First_Dsplit_Date ~'||l_First_Dsplit_Date);
                           IF l_last_dsbrdate IS NOT NULL
                           THEN
                               IF l_last_dsbrdate = l_First_Dsplit_Date
                               THEN
                                   l_First_Dsplit_Date := l_First_Dsplit_Date + 1;
                               END IF;
                           END IF;
                      END IF;
                     --Log#160 Ends
                     WHILE l_Comp_Due_Indx IS NOT NULL LOOP
                        Dbg('Inside due - ' || l_Tb_Disbr_Acc_Sch(l_Comp_Due_Indx)
                            .g_Disbr_Sch.Schedule_Due_Date);

                        IF l_Tb_Disbr_Acc_Sch(l_Comp_Due_Indx)
                        .g_Disbr_Sch.Schedule_Due_Date < l_First_Dsplit_Date
                        THEN
                           -- Storing the last schedule due date which are settled.
                           Dbg('schedule_due_date smaller than p_eff_date increase count');
                           l_Past_Sch_Cnt    := l_Past_Sch_Cnt + 1;
                           l_Last_Sch_End_Dt := l_Tb_Disbr_Acc_Sch(l_Comp_Due_Indx)
                                               .g_Disbr_Sch.Schedule_Due_Date;
                           Dbg('l_past_sch_cnt is ' || l_Past_Sch_Cnt);
                           --this will be the end date for the existing guy and start date for the next guy

                        ELSE
                           l_Next_Sch_Date := l_Tb_Disbr_Acc_Sch(l_Comp_Due_Indx)
                                             .g_Disbr_Sch.Schedule_Due_Date;
                           --this should be the new first_due_date for added comp sch
                           EXIT;
                        END IF;

                        l_Comp_Due_Indx := l_Tb_Disbr_Acc_Sch.NEXT(l_Comp_Due_Indx);

                     END LOOP;

                     l_New_Comp_Sch_Rec := NULL;

                     IF l_Past_Sch_Cnt > 0 THEN
                        l_Bool := Fn_Get_New_Split_Schedules(l_Eff_Comp_Sch_Rec
                                                            ,l_Last_Sch_End_Dt
                                                            ,l_Past_Sch_Cnt
                                                            ,l_Next_Sch_Date
                                                            ,l_Cascade_Movement
                                                            ,l_New_Comp_Sch_Rec
                                                            ,p_Err_Code);
                        IF l_Bool = FALSE THEN

                           l_Tb_Account_Sch.DELETE;
                           l_Tb_Revn_Acc_Sch.DELETE;
                           l_Tb_Disbr_Acc_Sch.DELETE;

                           RETURN FALSE;
                        END IF;

                        l_New_Rec_Indx := 'D' || Clpkss_Util.Fn_Hash_Date(l_New_Comp_Sch_Rec.g_Account_Comp_Sch.First_Due_Date
                                                                         ,NULL);

                        p_Account_Rec.g_Tb_Components(l_Comp_Indx) .g_Tb_Comp_Sch.DELETE(l_Comp_Sch_Indx);
                        p_Account_Rec.g_Tb_Components(l_Comp_Indx) .g_Tb_Comp_Sch(l_Comp_Sch_Indx) := l_Eff_Comp_Sch_Rec;
                        p_Account_Rec.g_Tb_Components(l_Comp_Indx) .g_Tb_Comp_Sch(l_New_Rec_Indx) := l_New_Comp_Sch_Rec;
                     END IF;
                     --populate indicator table
                     --p_tb_indicator(l_comp_indx).g_schedule_type := 'D';
                     p_Tb_Indicator(l_Comp_Indx) .g_First_Editable_d_Due_Date := Nvl(l_New_Comp_Sch_Rec.g_Account_Comp_Sch.First_Due_Date
                                                                                    ,l_First_Due_Date);

                     l_Tb_Disbr_Acc_Sch.DELETE;

                  END IF; --l_continue

               END IF; --l_continue
               --END Prasanna/Kiran Nedbank Demo support. 28-Jan-2006.

            END IF;
         END IF; --clpkss_cache.fn_product(p_account_rec.account_det.product_code).disbursement_mode
         --END Prasanna/Santosh 03-MAY-2006. Issue while splitting for a Manual disbursement product.
         --ALPHABANK issue.
         --Log#99 Ends
	 --  Log#139 Starts
	 END IF;
	 --  Log#139 Ends
         l_Comp_Indx := p_Account_Rec.g_Tb_Components.NEXT(l_Comp_Indx);

      END LOOP;

	  Dbg('End of the function fn_split_schedules');

      l_Tb_Account_Sch.DELETE;
      l_Tb_Revn_Acc_Sch.DELETE;
      l_Tb_Disbr_Acc_Sch.DELETE;

      RETURN TRUE;
   EXCEPTION
      WHEN OTHERS THEN
         Dbg('In when others of function fn_split_schedules - ' || SQLERRM);
         p_Err_Code  := 'CL-SCH030;';
         p_Err_Param := 'fn_split_schedules~;';
         Ovpkss.Pr_Appendtbl(p_Err_Code, p_Err_Param);
         Clpkss_Logger.Pr_Log_Exception('');
         l_Tb_Account_Sch.DELETE;
         l_Tb_Revn_Acc_Sch.DELETE;
         l_Tb_Disbr_Acc_Sch.DELETE;

         RETURN FALSE;
   END Fn_Gen_Split_Schedules;

   FUNCTION Fn_Split_Schedules(p_Account_Rec IN OUT NOCOPY Clpkss_Object.Ty_Rec_Account
                              ,p_Eff_Date    IN Cltbs_Account_Comp_Sch.Sch_Start_Date%TYPE
                              ,
                               --Start ravi for increase tenor changes
                               p_Tb_Indicator IN OUT Clpks_Schedules.Ty_Tb_Indicator
                              ,
                               --End ravi for increase tenor changes

                               p_Err_Code  IN OUT Ertbs_Msgs.Err_Code%TYPE
                              ,p_Err_Param IN OUT Ertbs_Msgs.Message%TYPE) RETURN BOOLEAN IS
   BEGIN
      IF NOT Clpkss_Stream_Schedules.Fn_Pre_Split_Schedules(p_Account_Rec
                                                           ,p_Eff_Date
                                                           ,p_Tb_Indicator
                                                           ,p_Err_Code
                                                           ,p_Err_Param) THEN
         RETURN FALSE;
      END IF;

      IF Clpkss_Stream_Schedules.Fn_Ovrdn_Split_Schedules THEN
         IF NOT Clpkss_Stream_Schedules.Fn_Split_Schedules(p_Account_Rec
                                                          ,p_Eff_Date
                                                          ,p_Tb_Indicator
                                                          ,p_Err_Code
                                                          ,p_Err_Param) THEN
            RETURN FALSE;
         END IF;
      ELSE
         IF NOT Fn_Gen_Split_Schedules(p_Account_Rec
                                      ,p_Eff_Date
                                      ,p_Tb_Indicator
                                      ,p_Err_Code
                                      ,p_Err_Param) THEN
            RETURN FALSE;
         END IF;
      END IF;
      IF NOT Clpkss_Stream_Schedules.Fn_Post_Split_Schedules(p_Account_Rec
                                                            ,p_Eff_Date
                                                            ,p_Tb_Indicator
                                                            ,p_Err_Code
                                                            ,p_Err_Param) THEN
         RETURN FALSE;
      END IF;

      RETURN TRUE;
   EXCEPTION
      WHEN OTHERS THEN
         Dbg('In when others of function fn_split_schedules - ' || SQLERRM);
         p_Err_Code  := 'CL-SCH030;';
         p_Err_Param := 'fn_split_schedules~;';
         Ovpkss.Pr_Appendtbl(p_Err_Code, p_Err_Param);
         Clpkss_Logger.Pr_Log_Exception('');

         RETURN FALSE;
   END Fn_Split_Schedules;

   FUNCTION Fn_Gen_Shift_Schedules(p_Account_Rec  IN OUT NOCOPY Clpkss_Object.Ty_Rec_Account
                                  ,p_New_Due_Date IN Cltbs_Account_Schedules.Schedule_Due_Date%TYPE
                                  ,p_Component    IN Cltb_Account_Components.Component_Name%TYPE
                                  ,p_Err_Code     IN OUT Ertbs_Msgs.Err_Code%TYPE
                                  ,p_Err_Param    IN OUT Ertbs_Msgs.Message%TYPE)
      RETURN BOOLEAN IS
      l_Acc_Sch_Indx  PLS_INTEGER;
      l_Sch_Linkage   Cltbs_Account_Schedules.Schedule_Linkage%TYPE;
      l_Comp_Sch_Indx VARCHAR2(100);
      l_Sch_Reduce    NUMBER;
      l_Temp_Sch_Indx PLS_INTEGER;
      -- Ramesh Changes Starts FCCCL 1.0 MTR1 9NT252 SFR#481 17-Dec-2004
      l_Bullet_Indx        PLS_INTEGER;
      l_Prev_Comp_Sch_Indx VARCHAR2(100);
      l_Emi_Amount         Cltbs_Account_Schedules.Emi_Amount%TYPE;
      l_Orig_Amt_Due       Cltbs_Account_Schedules.Orig_Amount_Due%TYPE;
      l_Amount_Due         Cltbs_Account_Schedules.Amount_Due%TYPE;
      l_Dly_Avg_Amt        Cltbs_Account_Schedules.Dly_Avg_Amt%TYPE;
      -- Ramesh Changes Ends FCCCL 1.0 MTR1 9NT252 SFR#481 17-Dec-2004
      l_Curr_Sch_Linkage  Cltbs_Account_Schedules.Schedule_Linkage%TYPE;
      l_Curr_Comp_Sch_Rec Cltbs_Account_Comp_Sch%ROWTYPE;
      l_Tb_Comp_Sch       Clpkss_Object.Ty_Tb_Account_Comp_Sch;
      l_Indx              VARCHAR2(100);
      l_Bool              BOOLEAN;
      l_First_Due_Date    Cltbs_Account_Comp_Sch.First_Due_Date%TYPE;
      l_Value_Date        Cltbs_Account_Master.Value_Date%TYPE;
      l_Maturity_Date     Cltbs_Account_Master.Maturity_Date%TYPE;
      --Sudharshan Mar 18,2005
      --l_ignore_holiday            cltbs_account_master.ignore_holidays%TYPE;
      l_Ignore_Holiday Cltms_Product.Ignore_Holidays%TYPE;
      --Sudharshan Mar 18,2005
      l_Forward_Backward  Cltms_Product.Schedule_Movement%TYPE;
      l_Move_Across_Month Cltms_Product.Move_Across_Month%TYPE;
      l_Cascade_Movement  Cltms_Product.Cascade_Schedules%TYPE;
      l_Account_No        Cltbs_Account_Master.Account_Number%TYPE;
      l_Branch_Code       Cltbs_Account_Master.Branch_Code%TYPE;
      l_Product_Code      Cltbs_Account_Master.Product_Code%TYPE;
      l_Prev_Sch_End_Date Cltbs_Account_Comp_Sch.Sch_End_Date%TYPE;
      l_Sch_End_Date      Cltbs_Account_Comp_Sch.Sch_End_Date%TYPE;
      l_Ty_Schedule_Date  Clpks_Schedules.Ty_Schedule_Date;
      l_Comp_Det          Cltbs_Account_Components%ROWTYPE;
      l_Out_Tb_Amt_Due    Clpkss_Object.Ty_Tb_Amt_Due;
      l_Due_Indx          PLS_INTEGER;
      l_Tb_Amort_Dues     Clpkss_Object.Ty_Tb_Amt_Due;
      l_Process_No        Cltbs_Account_Master.Process_No%TYPE;
      l_No_Of_Bullet_Days NUMBER;
      l_Prin_Comp         Cltbs_Account_Components.Component_Name%TYPE;
      l_Frm_Name          Cltbs_Account_Schedules.Formula_Name%TYPE;
      l_Tb_Amort_Pairs    Clpkss_Cache.Ty_Tb_Amort_Pairs;
      --->>Sudharshan : Mar 18,2005
      l_Rec_Prod Cltm_Product%ROWTYPE;
      --->>Sudharshan : Mar 18,2005
      l_Tb_Cltms_Comp_Frm Clpkss_Cache.Ty_Tb_Cltms_Comp_Frm; --Log#135 Changes

      -- START L Anantharaman 11-Apr-2005 FCCCL1.0 PhaseII reduce tenor changes
      l_Tb_New_Amt_Dues      Clpkss_Object.Ty_Tb_Amt_Due;
      l_Tb_New_Prin_Amt_Dues Clpkss_Object.Ty_Tb_Amt_Due;
      -- END L Anantharaman 11-Apr-2005 FCCCL1.0 PhaseII reduce tenor changes
      --Start ravi for increase tenor changes
      l_New_Due_Date DATE := p_New_Due_Date;
      --End ravi for increase tenor changes

      --START Prasanna/Ravi FCC-CL EURO BANK SFR#RAL044-03. 27-DEC-2005
      l_Indx_Type VARCHAR2(1);
      --END Prasanna/Ravi FCC-CL EURO BANK SFR#RAL044-03. 27-DEC-2005
   BEGIN
      Dbg('entered fn_shift_schedules');
      Dbg('p_new_due_date = ' || p_New_Due_Date);
      Dbg('p_component = ' || p_Component);
      --MTR1 SFR#136
      g_Tb_Acc_Hol_Perds := p_Account_Rec.g_Hol_Perds;

      l_Value_Date    := p_Account_Rec.Account_Det.Value_Date;
      l_Maturity_Date := Nvl(p_Account_Rec.Account_Det.Maturity_Date
                            ,Clpkss_Util.Pkg_Eternity);

      ------------------------------------------------------------------>
      --->>Sudharshan : Mar 18,2005
      --l_ignore_holiday    := p_account_rec.account_det.ignore_holidays;
      --l_forward_backward  := p_account_rec.account_det.schedule_movement;
      --l_move_across_month := p_account_rec.account_det.move_across_month;
      --l_cascade_movement  := p_account_rec.account_det.cascade_schedules;

      l_Rec_Prod       := Clpks_Cache.Fn_Product(p_Account_Rec.Account_Det.Product_Code);
      l_Ignore_Holiday := Nvl(l_Rec_Prod.Ignore_Holidays, 'Y');
      Dbg('**IGNORE**');
      Dbg('l_ignore_holiday--3' || l_Ignore_Holiday);
      l_Forward_Backward  := l_Rec_Prod.Schedule_Movement;
      l_Move_Across_Month := l_Rec_Prod.Move_Across_Month;
      l_Cascade_Movement  := l_Rec_Prod.Cascade_Schedules;
      --->>Sudharshan : Mar 18,2005
      ------------------------------------------------------------------>

      l_Account_No   := p_Account_Rec.Account_Det.Account_Number;
      l_Branch_Code  := p_Account_Rec.Account_Det.Branch_Code;
      l_Product_Code := p_Account_Rec.Account_Det.Product_Code;
      l_Process_No   := p_Account_Rec.Account_Det.Process_No;

      l_Comp_Det := p_Account_Rec.g_Tb_Components(p_Component).Comp_Det;

      --Start ravi for increase tenor changes
      --l_acc_sch_indx  :=   clpkss_util.fn_hash_date(p_new_due_date);
      l_Acc_Sch_Indx := Clpkss_Util.Fn_Hash_Date(l_New_Due_Date);
      dbg('BEFORE l_Acc_Sch_Indx ' || l_Acc_Sch_Indx);

     ---SFR#4124changes starts
  /*
      l_Acc_Sch_Indx := p_Account_Rec.g_Tb_Components(p_Component)
                       .g_Tb_Amt_Due.NEXT(l_Acc_Sch_Indx); */

      l_Acc_Sch_Indx := Nvl(p_Account_Rec.g_Tb_Components(p_Component)
                       .g_Tb_Amt_Due.NEXT(l_Acc_Sch_Indx),l_Acc_Sch_Indx);

     ---SFR#4124 changes ends

      dbg('after l_Acc_Sch_Indx ' || l_Acc_Sch_Indx);


      IF l_Acc_Sch_Indx IS NULL OR NOT p_Account_Rec.g_Tb_Components(p_Component)
      .g_Tb_Amt_Due.EXISTS(l_Acc_Sch_Indx) THEN
         Dbg('record not found for this due date in account schedules..return false');
         p_Err_Code := 'CL-SCH014;';
         Ovpkss.Pr_Appendtbl(p_Err_Code, '');
         RETURN FALSE;
      END IF;
      l_New_Due_Date := p_Account_Rec.g_Tb_Components(p_Component)
                       .g_Tb_Amt_Due(l_Acc_Sch_Indx).g_Amount_Due.Schedule_Due_Date;
      --End ravi for increase tenor changes

      l_Sch_Linkage := p_Account_Rec.g_Tb_Components(p_Component)
                      .g_Tb_Amt_Due(l_Acc_Sch_Indx).g_Amount_Due.Schedule_Linkage;

      l_Comp_Sch_Indx := 'P' || Clpkss_Util.Fn_Hash_Date(l_Sch_Linkage, NULL);

      IF NOT Clpkss_Cache.Fn_Get_Amort_Pairs(l_Product_Code, l_Tb_Amort_Pairs)

       THEN
         RETURN FALSE;
      END IF;

      Dbg('l_sch_linkage is ' || l_Sch_Linkage);

      IF NOT p_Account_Rec.g_Tb_Components(p_Component)
      .g_Tb_Amt_Due.EXISTS(l_Acc_Sch_Indx) THEN
         Dbg('record not found for this due date in account schedules..return false');
         p_Err_Code := 'CL-SCH014;';
         Ovpkss.Pr_Appendtbl(p_Err_Code, '');
         RETURN FALSE;
      END IF;

      l_Sch_Reduce    := 0;
      l_Temp_Sch_Indx := l_Acc_Sch_Indx;
      WHILE l_Temp_Sch_Indx IS NOT NULL LOOP
         l_Temp_Sch_Indx := p_Account_Rec.g_Tb_Components(p_Component).g_Tb_Amt_Due
                           .NEXT(l_Temp_Sch_Indx);

         IF l_Temp_Sch_Indx IS NOT NULL THEN
            l_Curr_Sch_Linkage := p_Account_Rec.g_Tb_Components(p_Component)
                                 .g_Tb_Amt_Due(l_Temp_Sch_Indx)
                                 .g_Amount_Due.Schedule_Linkage;
            IF l_Curr_Sch_Linkage <> l_Sch_Linkage THEN
               EXIT;
            END IF;
            l_Sch_Reduce := l_Sch_Reduce + 1;
            --l_new_sch_end_date := p_account_rec.g_tb_components(p_component).g_tb_amt_due
            --                      (l_temp_sch_indx).g_amount_due.schedule_due_date;
         END IF;

      END LOOP;
      Dbg('l_sch_reduce is ' || l_Sch_Reduce);
      --update current comp sch
      p_Account_Rec.g_Tb_Components(p_Component) .g_Tb_Comp_Sch(l_Comp_Sch_Indx) .g_Account_Comp_Sch.Sch_End_Date := p_New_Due_Date;
      p_Account_Rec.g_Tb_Components(p_Component) .g_Tb_Comp_Sch(l_Comp_Sch_Indx) .g_Account_Comp_Sch.No_Of_Schedules := p_Account_Rec.g_Tb_Components(p_Component)
                                                                                                                       .g_Tb_Comp_Sch(l_Comp_Sch_Indx)
                                                                                                                       .g_Account_Comp_Sch.No_Of_Schedules -
                                                                                                                        l_Sch_Reduce;
      l_Tb_Cltms_Comp_Frm := Clpkss_Cache.Fn_Cltms_Product_Comp_Frm(l_Product_Code
                                                                   ,p_Component); --Log#135
      --delete all amount dues
      l_Temp_Sch_Indx := l_Acc_Sch_Indx;
      l_Temp_Sch_Indx := p_Account_Rec.g_Tb_Components(p_Component).g_Tb_Amt_Due
                        .NEXT(l_Temp_Sch_Indx);
      Dbg('Before deletion');
      WHILE l_Temp_Sch_Indx IS NOT NULL LOOP
         Dbg('deleting amount due for amort int');
         -- START L Anantharaman 11-Apr-2005 FCCCL1.0 PhaseII reduce tenor changes
         l_Prin_Comp := NULL;
         -- END L Anantharaman 11-Apr-2005 FCCCL1.0 PhaseII reduce tenor changes
         l_Frm_Name := p_Account_Rec.g_Tb_Components(p_Component)
                      .g_Tb_Amt_Due(l_Temp_Sch_Indx).g_Amount_Due.Formula_Name;
         p_Account_Rec.g_Tb_Components(p_Component) .g_Tb_Amt_Due .DELETE(l_Temp_Sch_Indx);
         --CL PHASE II Corfo Related Enahncements

         IF NOT l_Tb_Amort_Pairs.EXISTS(l_Product_Code || p_Component || l_Frm_Name) THEN
            Dbg('amort pair absent ');
            -- RETURN FALSE;   -- Commented For Log#135
         ELSE
            l_Prin_Comp := l_Tb_Amort_Pairs(l_Product_Code || p_Component || l_Frm_Name);
         END IF;
         --Log#135 Changes Starts
         IF l_Prin_Comp IS NOT NULL THEN
            --Log#135 Ends
            --delete corresponding rows for principal also ,that are present due to amortized comp.
            IF p_Account_Rec.g_Tb_Components(l_Prin_Comp)
            .g_Tb_Amt_Due.EXISTS(l_Temp_Sch_Indx)
              --Phase II NLS changes
              AND p_Account_Rec.g_Tb_Components(l_Prin_Comp)
            .g_Tb_Amt_Due(l_Temp_Sch_Indx).g_Amount_Due.Schedule_Type IS NULL THEN
               Dbg('deleting for pricipal');
               p_Account_Rec.g_Tb_Components(l_Prin_Comp) .g_Tb_Amt_Due.DELETE(l_Temp_Sch_Indx);
               --Phase II NLS changes
            END IF;
         END IF; -- Log#135 Changes

         l_Temp_Sch_Indx := p_Account_Rec.g_Tb_Components(p_Component)
                           .g_Tb_Amt_Due.NEXT(l_Temp_Sch_Indx);
      END LOOP;
      Dbg('done with deleting amount dues');
      Dbg('After deletion');
      -- START L Anantharaman 11-Apr-2005 FCCCL1.0 PhaseII reduce tenor changes
      l_Tb_New_Amt_Dues := p_Account_Rec.g_Tb_Components(p_Component).g_Tb_Amt_Due;
      IF l_Prin_Comp IS NOT NULL THEN
         l_Tb_New_Prin_Amt_Dues := p_Account_Rec.g_Tb_Components(l_Prin_Comp)
                                  .g_Tb_Amt_Due;
         Dbg('printing for principal');
         --print_schedules(l_tb_new_prin_amt_dues);
      END IF;
      -- END L Anantharaman 11-Apr-2005 FCCCL1.0 PhaseII reduce tenor changes

      --re prepare comp sch..values changing will be sch start date,end date and
      --first due date.

      l_Prev_Sch_End_Date := p_New_Due_Date;

      l_Comp_Sch_Indx := p_Account_Rec.g_Tb_Components(p_Component)
                        .g_Tb_Comp_Sch.NEXT(l_Comp_Sch_Indx);

      --START Prasanna/Ravi FCC-CL EURO BANK SFR#RAL044-03. 27-DEC-2005
      WHILE l_Comp_Sch_Indx IS NOT NULL AND
            Nvl(p_Account_Rec.g_Tb_Components(p_Component).g_Tb_Comp_Sch(l_Comp_Sch_Indx)
                .g_Account_Comp_Sch.Schedule_Type
               ,'P') = 'P'
      --END Prasanna/Ravi FCC-CL EURO BANK SFR#RAL044-03. 27-DEC-2005
       LOOP
         l_Curr_Comp_Sch_Rec := p_Account_Rec.g_Tb_Components(p_Component)
                               .g_Tb_Comp_Sch(l_Comp_Sch_Indx).g_Account_Comp_Sch;

         IF l_Curr_Comp_Sch_Rec.Unit = 'B' THEN

            --START Prasanna/Ravi FCC-CL EURO BANK SFR#RAL044-03. 27-DEC-2005
            l_Indx_Type := l_Curr_Comp_Sch_Rec.Schedule_Type;
            l_Indx_Type := Nvl(l_Indx_Type, 'P');
            --END Prasanna/Ravi FCC-CL EURO BANK SFR#RAL044-03. 27-DEC-2005

            -- Ramesh Changes Starts FCCCL 1.0 MTR1 9NT252 SFR#481 17-Dec-2004
            /* l_no_of_bullet_days := l_curr_comp_sch_rec.sch_end_date -
                                   l_curr_comp_sch_rec.sch_start_date ;

            l_first_due_date   :=  l_prev_sch_end_date +  nvl(l_no_of_bullet_days , 0);
            l_sch_end_date     :=  l_prev_sch_end_date +  nvl(l_no_of_bullet_days , 0); */

            l_Bullet_Indx := p_Account_Rec.g_Tb_Components(p_Component).g_Tb_Amt_Due.LAST;

            Dbg('Amount due - ' || p_Account_Rec.g_Tb_Components(p_Component)
                .g_Tb_Amt_Due(l_Bullet_Indx).g_Amount_Due.Amount_Due);
            Dbg('Emi Amount - ' || p_Account_Rec.g_Tb_Components(p_Component)
                .g_Tb_Amt_Due(l_Bullet_Indx).g_Amount_Due.Emi_Amount);

            l_First_Due_Date    := l_Prev_Sch_End_Date;
            l_Prev_Sch_End_Date := p_Account_Rec.g_Tb_Components(p_Component)
                                  .g_Tb_Amt_Due(l_Bullet_Indx)
                                  .g_Amount_Due.Schedule_St_Date;

            l_Sch_End_Date := p_Account_Rec.g_Tb_Components(p_Component)
                             .g_Tb_Amt_Due(l_Bullet_Indx).g_Amount_Due.Schedule_Due_Date;

            l_Prev_Comp_Sch_Indx := p_Account_Rec.g_Tb_Components(p_Component)
                                   .g_Tb_Comp_Sch.PRIOR(l_Comp_Sch_Indx);

            IF l_Prev_Comp_Sch_Indx IS NULL THEN
               Dbg('No schedule exists other than bullet schedule');
               RETURN FALSE;
            ELSE
               p_Account_Rec.g_Tb_Components(p_Component) .g_Tb_Comp_Sch(l_Prev_Comp_Sch_Indx) .g_Account_Comp_Sch.No_Of_Schedules := p_Account_Rec.g_Tb_Components(p_Component)
                                                                                                                                     .g_Tb_Comp_Sch(l_Prev_Comp_Sch_Indx)
                                                                                                                                     .g_Account_Comp_Sch.No_Of_Schedules - 1;
               p_Account_Rec.g_Tb_Components(p_Component) .g_Tb_Comp_Sch(l_Prev_Comp_Sch_Indx) .g_Account_Comp_Sch.Sch_End_Date := l_Prev_Sch_End_Date;

            END IF;

            -- Ramesh Changes Ends FCCCL 1.0 MTR1 9NT252 SFR#481 17-Dec-2004

         ELSE

            l_First_Due_Date := Fn_Get_Next_Schedule_Date(l_Prev_Sch_End_Date
                                                         ,l_Curr_Comp_Sch_Rec.Unit
                                                         ,l_Curr_Comp_Sch_Rec.Frequency);

            IF l_First_Due_Date IS NULL THEN
               Dbg('first due date computes as null..returning false');
               p_Err_Code := 'CL-SCH014;';
               Ovpkss.Pr_Appendtbl(p_Err_Code, '');
               l_Ty_Schedule_Date.DELETE;
               l_Out_Tb_Amt_Due.DELETE;
               l_Tb_Amort_Dues.DELETE;

               RETURN FALSE;

            END IF;

            Dbg('l_first_due date is ' || l_First_Due_Date);

            --START Prasanna/Ravi FCC-CL EURO BANK SFR#RAL044-03. 27-DEC-2005
            l_Indx_Type := l_Curr_Comp_Sch_Rec.Schedule_Type;
            l_Indx_Type := Nvl(l_Indx_Type, 'P');
            --END Prasanna/Ravi FCC-CL EURO BANK SFR#RAL044-03. 27-DEC-2005

            l_Bool := Fn_Compute_Schedule_Dates(l_First_Due_Date
                                               ,l_Value_Date
                                               ,l_Maturity_Date
                                               ,l_Branch_Code
                                               ,l_Product_Code
                                               ,l_Curr_Comp_Sch_Rec.Frequency
                                               ,l_Curr_Comp_Sch_Rec.Unit
                                               ,l_Curr_Comp_Sch_Rec.No_Of_Schedules
                                               ,l_Ignore_Holiday
                                               ,l_Forward_Backward
                                               ,l_Move_Across_Month
                                               ,l_Cascade_Movement
                                               ,l_Curr_Comp_Sch_Rec.Due_Dates_On
                                               ,
                                                --euro bank retro changes LOG#103 starts
                                                -- start month end periodicity LOG#102
                                                NULL
                                               ,
                                                -- end month end periodicity LOG#102
                                                --euro bank retro changes LOG#103 ends
                                                l_Ty_Schedule_Date
                                               ,p_Err_Code
                                               ,
                                                -- START Log#116
                                                l_Curr_Comp_Sch_Rec.Schedule_Type);
            -- END Log#116

            IF l_Bool = FALSE THEN
               Dbg('fn_compute_Schedule dates returned false');
               RETURN FALSE;
            ELSE
               IF l_Ty_Schedule_Date.COUNT > 0 THEN
                  l_First_Due_Date := l_Ty_Schedule_Date(l_Ty_Schedule_Date.FIRST);
                  l_Sch_End_Date   := l_Ty_Schedule_Date(l_Ty_Schedule_Date.LAST);
               END IF;
            END IF;

         END IF;

         --START Prasanna/Ravi FCC-CL EURO BANK SFR#RAL044-03. 27-DEC-2005
         --l_indx := 'P' || clpkss_util.fn_hash_date(l_first_due_date,NULL);
         Dbg('$$$$$$$$$$$$$l_indx_type ' || l_Indx_Type);
         l_Indx := l_Indx_Type || Clpkss_Util.Fn_Hash_Date(l_First_Due_Date, NULL);

         --END Prasanna/Ravi FCC-CL EURO BANK SFR#RAL044-03. 27-DEC-2005

         l_Tb_Comp_Sch(l_Indx) .g_Account_Comp_Sch := l_Curr_Comp_Sch_Rec;

         l_Tb_Comp_Sch(l_Indx) .g_Account_Comp_Sch.Sch_Start_Date := l_Prev_Sch_End_Date;
         l_Tb_Comp_Sch(l_Indx) .g_Account_Comp_Sch.First_Due_Date := l_First_Due_Date;
         l_Tb_Comp_Sch(l_Indx) .g_Account_Comp_Sch.Sch_End_Date := l_Sch_End_Date;

         l_Prev_Sch_End_Date := l_Sch_End_Date;
         --delete
         p_Account_Rec.g_Tb_Components(p_Component) .g_Tb_Comp_Sch.DELETE(l_Comp_Sch_Indx);
		 l_Ty_Schedule_Date.DELETE; -- log#173 changes
         l_Comp_Sch_Indx := p_Account_Rec.g_Tb_Components(p_Component)
                           .g_Tb_Comp_Sch.NEXT(l_Comp_Sch_Indx);

      END LOOP;
      --call fn_populate sccount schedules for these guys
      IF l_Tb_Comp_Sch.COUNT > 0 THEN
         --populate account rec for all new comp schedules
         l_Indx := l_Tb_Comp_Sch.FIRST;
         WHILE l_Indx IS NOT NULL LOOP
            p_Account_Rec.g_Tb_Components(p_Component) .g_Tb_Comp_Sch(l_Indx) .g_Account_Comp_Sch := l_Tb_Comp_Sch(l_Indx)
                                                                                                    .g_Account_Comp_Sch;
            l_Indx := l_Tb_Comp_Sch.NEXT(l_Indx);
         END LOOP;

         --call populate account schedules

         Dbg('will be calling fn_populate_account_schedules now');
         l_Bool := Fn_Populate_Account_Schedules(l_Tb_Comp_Sch
                                                ,l_Account_No
                                                ,l_Branch_Code
                                                ,l_Product_Code
                                                ,l_Process_No
                                                ,l_Comp_Det
                                                ,l_Value_Date
                                                ,l_Sch_End_Date
												,p_account_rec.account_det.module_code ---- Log#162 Changes for 11.1 Dev (Payment in Advance)
                                                , --this is the new effective maturity date
                                                 --l_maturity_date,
                                                 l_Ignore_Holiday
                                                ,l_Forward_Backward
                                                ,l_Move_Across_Month
                                                ,l_Cascade_Movement
                                                ,
                                                 --l_holiday_chk_failed,
                                                 l_Out_Tb_Amt_Due
                                                ,l_Tb_Amort_Dues
                                                ,
                                                 -- START L Anantharaman 11-Apr-2005 FCCCL1.0 PhaseII reduce tenor changes
                                                 l_Tb_New_Amt_Dues
                                                ,l_Tb_New_Prin_Amt_Dues
                                                ,
                                                 -- END L Anantharaman 11-Apr-2005 FCCCL1.0 PhaseII reduce tenor changes
                                                 --START LOG#46 23-May-2005 SFR#1
                                                 p_Account_Rec.Account_Det.Value_Date
                                                ,
                                                 --END LOG#46 23-May-2005 SFR#1
                                                 --LOG#111 RETRO STARTS
                                                 NULL
                                                ,
                                                 --LOG#111 RETRO ENDS
                                                 p_Err_Code);
         IF l_Bool = FALSE THEN
            Dbg('fn_populate_account_schedules returned false');
            l_Ty_Schedule_Date.DELETE;
            l_Out_Tb_Amt_Due.DELETE;
            l_Tb_Amort_Dues.DELETE;
            -- START L Anantharaman 11-Apr-2005 FCCCL1.0 PhaseII reduce tenor changes
            l_Tb_New_Amt_Dues.DELETE;
            l_Tb_New_Prin_Amt_Dues.DELETE;
            -- END L Anantharaman 11-Apr-2005 FCCCL1.0 PhaseII reduce tenor changes

            RETURN FALSE;

         ELSE
            -- START L Anantharaman 11-Apr-2005 FCCCL1.0 PhaseII reduce tenor changes
            l_Tb_New_Amt_Dues.DELETE;
            l_Tb_New_Prin_Amt_Dues.DELETE;
            -- END L Anantharaman 11-Apr-2005 FCCCL1.0 PhaseII reduce tenor changes
            Dbg('l_out_tb_amt_due.COUNT ' || l_Out_Tb_Amt_Due.COUNT);
            Dbg('l_tb_amort_dues.COUNT ' || l_Tb_Amort_Dues.COUNT);

            l_Due_Indx := l_Out_Tb_Amt_Due.FIRST;

            WHILE l_Due_Indx IS NOT NULL LOOP
               -- Ramesh Changes Starts FCCCL 1.0 MTR1 9NT252 SFR#481 17-Dec-2004
               --l_emi_amount  :=    p_account_rec.g_tb_components(p_component) .g_tb_amt_due(l_due_indx).g_amount_due.emi_amount;
               --l_orig_amt_due:=    p_account_rec.g_tb_components(p_component) .g_tb_amt_due(l_due_indx).g_amount_due.orig_amount_due;
               --l_dly_avg_amt :=    p_account_rec.g_tb_components(p_component) .g_tb_amt_due(l_due_indx).g_amount_due.dly_avg_amt;
               --l_amount_due  :=    p_account_rec.g_tb_components(p_component) .g_tb_amt_due(l_due_indx).g_amount_due.amount_due;
               -- Ramesh Changes Ends FCCCL 1.0 MTR1 9NT252 SFR#481 17-Dec-2004

               p_Account_Rec.g_Tb_Components(p_Component) .g_Tb_Amt_Due(l_Due_Indx) := l_Out_Tb_Amt_Due(l_Due_Indx);

               -- Ramesh Changes Starts FCCCL 1.0 MTR1 9NT252 SFR#481 17-Dec-2004
               --p_account_rec.g_tb_components(p_component) .g_tb_amt_due(l_due_indx).g_amount_due.emi_amount := l_emi_amount;
               --p_account_rec.g_tb_components(p_component) .g_tb_amt_due(l_due_indx).g_amount_due.orig_amount_due := l_orig_amt_due;
               --p_account_rec.g_tb_components(p_component) .g_tb_amt_due(l_due_indx).g_amount_due.dly_avg_amt := l_dly_avg_amt;
               --p_account_rec.g_tb_components(p_component) .g_tb_amt_due(l_due_indx).g_amount_due.amount_due := l_amount_due;
               -- Ramesh Changes Ends FCCCL 1.0 MTR1 9NT252 SFR#481 17-Dec-2004

               l_Due_Indx := l_Out_Tb_Amt_Due.NEXT(l_Due_Indx);
            END LOOP;

            --populate for amort components..

            l_Due_Indx := l_Tb_Amort_Dues.FIRST;

            WHILE l_Due_Indx IS NOT NULL LOOP
               --Phase II NLS changes start
               -- Ramesh Changes Starts FCCCL 1.0 MTR1 9NT252 SFR#481 17-Dec-2004
               --l_emi_amount  :=    p_account_rec.g_tb_components(PKG_PRINCIPAL) .g_tb_amt_due(l_due_indx).g_amount_due.emi_amount;
               --l_orig_amt_due:=    p_account_rec.g_tb_components(PKG_PRINCIPAL) .g_tb_amt_due(l_due_indx).g_amount_due.orig_amount_due;
               --l_dly_avg_amt :=    p_account_rec.g_tb_components(PKG_PRINCIPAL) .g_tb_amt_due(l_due_indx).g_amount_due.dly_avg_amt;
               --l_amount_due  :=    p_account_rec.g_tb_components(PKG_PRINCIPAL) .g_tb_amt_due(l_due_indx).g_amount_due.amount_due;
               -- Ramesh Changes Ends FCCCL 1.0 MTR1 9NT252 SFR#481 17-Dec-2004

               p_Account_Rec.g_Tb_Components(Pkg_Principal) .g_Tb_Amt_Due(l_Due_Indx) := l_Tb_Amort_Dues(l_Due_Indx);

               -- Ramesh Changes Starts FCCCL 1.0 MTR1 9NT252 SFR#481 17-Dec-2004
               --p_account_rec.g_tb_components(PKG_PRINCIPAL) .g_tb_amt_due(l_due_indx).g_amount_due.emi_amount := l_emi_amount;
               --p_account_rec.g_tb_components(PKG_PRINCIPAL) .g_tb_amt_due(l_due_indx).g_amount_due.orig_amount_due := l_orig_amt_due;
               --p_account_rec.g_tb_components(PKG_PRINCIPAL) .g_tb_amt_due(l_due_indx).g_amount_due.dly_avg_amt := l_dly_avg_amt;
               --p_account_rec.g_tb_components(PKG_PRINCIPAL) .g_tb_amt_due(l_due_indx).g_amount_due.amount_due := l_amount_due;
               -- Ramesh Changes Ends FCCCL 1.0 MTR1 9NT252 SFR#481 17-Dec-2004

               -- Log#135 Changes Starts
               -- l_due_indx := l_out_tb_amt_due.NEXT(l_due_indx);
               l_Due_Indx := l_Tb_Amort_Dues.NEXT(l_Due_Indx);
               -- Log#135 Ends
            END LOOP;

            --Phase II NLS changes end

         END IF;
      END IF;
      --Start ravi for increase tenor changes
      IF p_Component = Pkg_Main_Int THEN
         IF NOT Fn_Gen_Rebuild_Schedule(p_Account_Rec
                                       ,l_New_Due_Date
                                       ,p_Err_Code
                                       ,p_Err_Param) THEN
            RETURN FALSE;
         END IF;

         Dbg('updating maturity date to ' || l_New_Due_Date);
         p_Account_Rec.Account_Det.Maturity_Date := l_New_Due_Date;

      END IF;
      --End ravi for increase tenor changes

      l_Ty_Schedule_Date.DELETE;
      l_Out_Tb_Amt_Due.DELETE;
      l_Tb_Amort_Dues.DELETE;
      Dbg('returning from shift schedules');
      RETURN TRUE;

   EXCEPTION
      WHEN OTHERS THEN
         Dbg('in when others of fn_shift_schedules with ' || SQLERRM);
         l_Ty_Schedule_Date.DELETE;
         l_Out_Tb_Amt_Due.DELETE;
         l_Tb_Amort_Dues.DELETE;

         Clpkss_Logger.Pr_Log_Exception('');

         p_Err_Code  := 'CL-SCH030;';
         p_Err_Param := 'fn_shift_schedules~;';
         Ovpkss.Pr_Appendtbl(p_Err_Code, p_Err_Param);

         RETURN FALSE;
   END Fn_Gen_Shift_Schedules;
   FUNCTION Fn_Shift_Schedules(p_Account_Rec  IN OUT NOCOPY Clpkss_Object.Ty_Rec_Account
                              ,p_New_Due_Date IN Cltbs_Account_Schedules.Schedule_Due_Date%TYPE
                              ,p_Component    IN Cltb_Account_Components.Component_Name%TYPE
                              ,p_Err_Code     IN OUT Ertbs_Msgs.Err_Code%TYPE
                              ,p_Err_Param    IN OUT Ertbs_Msgs.Message%TYPE) RETURN BOOLEAN IS
   BEGIN
      IF NOT Clpkss_Stream_Schedules.Fn_Pre_Shift_Schedules(p_Account_Rec
                                                           ,p_New_Due_Date
                                                           ,p_Component
                                                           ,p_Err_Code
                                                           ,p_Err_Param) THEN
         RETURN FALSE;
      END IF;

      IF Clpkss_Stream_Schedules.Fn_Ovrdn_Shift_Schedules THEN
         IF NOT Clpkss_Stream_Schedules.Fn_Shift_Schedules(p_Account_Rec
                                                          ,p_New_Due_Date
                                                          ,p_Component
                                                          ,p_Err_Code
                                                          ,p_Err_Param) THEN
            RETURN FALSE;
         END IF;
      ELSE
         IF NOT Fn_Gen_Shift_Schedules(p_Account_Rec
                                      ,p_New_Due_Date
                                      ,p_Component
                                      ,p_Err_Code
                                      ,p_Err_Param) THEN
            RETURN FALSE;
         END IF;
      END IF;

      IF NOT Clpkss_Stream_Schedules.Fn_Post_Shift_Schedules(p_Account_Rec
                                                            ,p_New_Due_Date
                                                            ,p_Component
                                                            ,p_Err_Code
                                                            ,p_Err_Param) THEN
         RETURN FALSE;
      END IF;

      RETURN TRUE;

   EXCEPTION
      WHEN OTHERS THEN
         Dbg('in when others of fn_shift_schedules with ' || SQLERRM);
         Clpkss_Logger.Pr_Log_Exception('');
         p_Err_Code  := 'CL-SCH030;';
         p_Err_Param := 'fn_shift_schedules~;';
         Ovpkss.Pr_Appendtbl(p_Err_Code, p_Err_Param);

         RETURN FALSE;
   END Fn_Shift_Schedules;

   FUNCTION Fn_Gen_Copy_Schs_From_Account(p_Account_Rec     IN OUT NOCOPY Clpkss_Object.Ty_Rec_Account
                                         ,p_Processing_Date IN Cltbs_Account_Master.Value_Date%TYPE
                                         ,p_Old_Value_Date  IN Cltbs_Account_Master.Value_Date%TYPE
                                         ,p_Err_Code        IN OUT Ertbs_Msgs.Err_Code%TYPE
                                         ,p_Err_Param       IN OUT Ertbs_Msgs.Message%TYPE)
      RETURN BOOLEAN IS

      l_Value_Date      Cltbs_Account_Master.Value_Date%TYPE;
      l_Maturity_Date   Cltbs_Account_Master.Maturity_Date%TYPE;
      l_Account_No      Cltbs_Account_Master.Account_Number%TYPE;
      l_Branch_Code     Cltbs_Account_Master.Branch_Code%TYPE;
      l_Amount_Financed Cltbs_Account_Master.Amount_Financed%TYPE;
      l_Currency        Cltbs_Account_Master.Currency%TYPE;
      l_Rec_Comp_Sch    Cltbs_Account_Comp_Sch%ROWTYPE;
      l_Indx            VARCHAR2(100);
      l_Disb_Indx       PLS_INTEGER := 1;
      l_First_Due_Date  DATE;
      l_Product_Code    Cltms_Product.Product_Code%TYPE;
      --Sudharshan Mar 18,2005
      --l_ignore_holidays   CLTBS_ACCOUNT_MASTER.IGNORE_HOLIDAYS%TYPE;
      l_Ignore_Holidays Cltms_Product.Ignore_Holidays%TYPE;
      --Sudharshan Mar 18,2005
      l_Forward_Backward        Cltms_Product.Schedule_Movement%TYPE;
      l_Move_Across_Month       Cltms_Product.Move_Across_Month%TYPE;
      l_Cascade_Movement        Cltms_Product.Cascade_Schedules%TYPE;
      l_Prev_Comp_Plus_Sch_Type VARCHAR2(100);
      l_Comp_Plus_Sch_Type      VARCHAR2(100);
      l_Sch_Start_Date          DATE;
      l_Is_First_Schedule       BOOLEAN;
      l_Tb_Sch_Dates            Ty_Schedule_Date;
      l_Tb_For_Disbr            g_Ty_Tb_For_Disbr;
      l_No_Of_Disb_Schs         PLS_INTEGER := 0;
      l_Disbr_Sch_Amt           Cltbs_Account_Comp_Sch.Amount%TYPE;
      l_Disbr_Sch_Rnd_Amt       Cltbs_Account_Comp_Sch.Amount%TYPE;
      l_Is_Discounted           BOOLEAN;
      l_Dsbr_Sch_Rec            Cltbs_Account_Comp_Sch%ROWTYPE;
      ---->> Sudharshan Mar 18,2005
      l_Rec_Prod Cltm_Product%ROWTYPE;
      ---->> Sudharshan Mar 18,2005

      l_Discounted CONSTANT VARCHAR2(1) := '3';
      l_True_Discounted CONSTANT VARCHAR2(1) := '4';

      -- R S SAJEESH. 08-JUN-2006 START.
      l_Skip               BOOLEAN := FALSE;
      l_Prev_Sch_Is_Bullet BOOLEAN := FALSE;
      -- R S SAJEESH. 08-JUN-2006 END.

      CURSOR l_Cur_Old_Schedule_Defns IS
         SELECT *
         FROM   Cltbs_Account_Comp_Sch t
         WHERE  t.Account_Number = p_Account_Rec.Account_Det.Account_Number AND
                t.Branch_Code = p_Account_Rec.Account_Det.Branch_Code AND
                Schedule_Type != 'D'
         ORDER  BY t.Component_Name, t.Schedule_Type
                   -- Changes Start for 10-Dec-2004 SFR#416 L Anantharaman
                  , t.Sch_Start_Date;
      -- Changes End for 10-Dec-2004 SFR#416 L Anantharaman

      FUNCTION Fn_Get_First_Due_Dt(p_Old_Start_Date     DATE
                                  ,p_Old_First_Due_Date DATE
                                  ,p_Cur_Start_Date     DATE
                                  ,p_Is_First_Schedule  BOOLEAN
                                  ,p_Unit               Cltbs_Account_Comp_Sch.Unit%TYPE
                                  ,p_Frequency          Cltbs_Account_Comp_Sch.Frequency%TYPE
                                  ,p_Is_Discounted      BOOLEAN -- To check whether the component is discounted or true discounted type
                                   )

       RETURN DATE IS
         l_Date       VARCHAR2(2);
         l_Month_Diff PLS_INTEGER;
         l_Year_Diff  PLS_INTEGER;
         l_Due_Date   DATE;

         l_Char_Date  VARCHAR2(2);
         l_Char_Month VARCHAR2(2);
         l_Char_Year  VARCHAR2(4);

         l_Char_Due_Date VARCHAR2(20);
         --Log#112 Retro FCCRUSSIA IMPSUPP SFR-310: Date Format related changes from here
         --L_DATE_FORMAT CONSTANT VARCHAR2(20) := 'DD-MM-YYYY';
         l_Date_Format CONSTANT VARCHAR2(20) := 'DD-MM-RRRR';
         --Log#112 till here
         -- START LOG#51 06-Jun-2005 SFR#105
         l_Day_Diff PLS_INTEGER;
         -- END LOG#51 06-Jun-2005 SFR#105
         --log#178 start
         l_last_day NUMBER;
         --log#178 end

      BEGIN

         --START Prasanna FCCCL 1.1 MTR1 SFR#92. 9NT296. 02-Jun-2005
         --First schedule due date comp sch should be derived based on new value date and not old first schedule due date
         --l_char_date := CLPKSS_UTIL.fn_date(p_old_first_due_date);
         --l_char_date   := LPAD(l_char_date,2,'0');
         --END Prasanna FCCCL 1.1 MTR1 SFR#92. 9NT296. 02-Jun-2005

         --START Prasanna FCCCL 1.1 MTR1 SFR#112. 9NT296. FCCCL 1.1. 01-Jun-2005
         --Discounted Interest to be treated seperately.
         IF p_Is_First_Schedule THEN

            IF p_Is_Discounted THEN
               l_Due_Date := l_Value_Date;
            ELSE

               Dbg('##########p_old_first_due_date ' || p_Old_First_Due_Date);
               Dbg('##########p_old_start_date ' || p_Old_Start_Date);

               l_Month_Diff := Months_Between(p_Old_First_Due_Date, p_Old_Start_Date);

               Dbg('##########l_month_diff ' || l_Month_Diff);

               -- START LOG#51 06-Jun-2005 SFR#105
               IF l_Month_Diff = 0 THEN
                  l_Day_Diff := p_Old_First_Due_Date - p_Old_Start_Date;
                  Dbg('##########l_day_diff ' || l_Day_Diff);
               ELSE

                  --Start LOG#89 on 11-Feb-2006
                  --l_day_diff := 0;
                  l_Day_Diff := Add_Months(p_Old_First_Due_Date, (-1) * l_Month_Diff) -
                                p_Old_Start_Date;
                  Dbg('##########l_day_diff ' || l_Day_Diff);
                  --End LOG#89 on 11-Feb-2006

               END IF;
               -- END LOG#51 06-Jun-2005 SFR#105

               --Start Log#56
               l_Year_Diff := Clpkss_Util.Fn_Year(p_Old_First_Due_Date) -
                              Clpkss_Util.Fn_Year(p_Old_Start_Date);
               IF l_Year_Diff > 0 THEN
                  l_Year_Diff := Trunc(Months_Between(p_Old_First_Due_Date
                                                     ,p_Old_Start_Date) / 12);
               END IF;
               --End LoG#56

               Dbg('##########l_year_diff ' || l_Year_Diff);

               --Start Log#52
               --l_due_date    :=  add_months(p_cur_start_date,l_month_diff);
               l_Due_Date := Add_Months(p_Cur_Start_Date, l_Month_Diff) + l_Day_Diff;
               --End Log#52

               Dbg('##########l_due_date ' || l_Due_Date);

               l_Char_Month := Clpkss_Util.Fn_Month(l_Due_Date);

               Dbg('##########l_char_month ' || l_Char_Month);

               l_Char_Year := Clpkss_Util.Fn_Year(l_Due_Date) + l_Year_Diff;

               Dbg('##########l_char_year ' || l_Char_Year);

               -- START LOG#51 06-Jun-2005 SFR#105
               --                 l_char_date := CLPKSS_UTIL.fn_date(p_cur_start_date);
               l_Char_Date := Clpkss_Util.Fn_Date(l_Due_Date);
               -- END LOG#51 06-Jun-2005 SFR#105
               l_Char_Date := Lpad(l_Char_Date, 2, '0');

               --START Prasanna FCCCL 1.1 MTR1 SFR#92. 9NT296. 02-Jun-2005
               --First schedule due date comp sch should be derived based on new value date and not old first schedule due date
               l_Char_Month := Lpad(l_Char_Month, 2, '0');
               l_Char_Year  := Lpad(l_Char_Year, 4, '0');

               Dbg('##########l_char_month ' || l_Char_Month);

               Dbg('##########l_char_year ' || l_Char_Year);

               BEGIN
                  l_Due_Date := To_Date(l_Char_Date || '-' || l_Char_Month || '-' ||
                                        l_Char_Year
                                       ,l_Date_Format);
               EXCEPTION
                  WHEN OTHERS THEN
                     l_Due_Date := To_Date('01' || '-' || l_Char_Month || '-' ||
                                           l_Char_Year
                                          ,l_Date_Format);
                     l_Due_Date := Last_Day(l_Due_Date);
               END;
               --END Prasanna FCCCL 1.1 MTR1 SFR#92. 9NT296. 02-Jun-2005

               Dbg('##########l_due_date ' || l_Due_Date);

               --START Prasanna FCCCL 1.0 MTR2 SFR#014 9NT252 27-Dec-2004
               WHILE l_Due_Date <= p_Cur_Start_Date LOOP

                  l_Char_Date := Clpkss_Util.Fn_Date(l_Due_Date);
                  l_Char_Date := Lpad(l_Char_Date, 2, '0');

                  l_Due_Date   := Fn_Get_Next_Schedule_Date(l_Due_Date
                                                           ,p_Unit
                                                           ,p_Frequency);
                  l_Char_Month := Clpkss_Util.Fn_Month(l_Due_Date);
                  l_Char_Year  := Clpkss_Util.Fn_Year(l_Due_Date);

                  l_Char_Month := Lpad(l_Char_Month, 2, '0');
                  l_Char_Year  := Lpad(l_Char_Year, 4, '0');

                  l_Due_Date := To_Date(l_Char_Date || '-' || l_Char_Month || '-' ||
                                        l_Char_Year
                                       ,l_Date_Format);

               END LOOP;
               --END Prasanna FCCCL 1.0 MTR2 SFR#014 9NT252 27-Dec-2004
            END IF; --Discounted
            --END Prasanna FCCCL 1.1 MTR1 SFR#112. 9NT296. FCCCL 1.1. 01-Jun-2005

         ELSE

            --START Prasanna FCCCL 1.1 MTR1 SFR#112. 9NT296. FCCCL 1.1. 01-Jun-2005
            l_Char_Date := Clpkss_Util.Fn_Date(p_Old_First_Due_Date);
            l_Char_Date := Lpad(l_Char_Date, 2, '0');
            --END Prasanna FCCCL 1.1 MTR1 SFR#112. 9NT296. FCCCL 1.1. 01-Jun-2005

            IF p_Unit = 'B' THEN
               IF p_Is_Discounted THEN
                  l_Due_Date := l_Value_Date;
               ELSE
                  l_Due_Date := l_Maturity_Date;
               END IF;

            ELSE
               l_Due_Date      := Fn_Get_Next_Schedule_Date(p_Cur_Start_Date
                                                           ,p_Unit
                                                           ,p_Frequency);
               --log#178 start
			   dbg('l_Due_Date '||l_Due_Date);
               SELECT substr(LAST_DAY(l_Due_Date),1,2) into l_last_day FROM dual;
               --log#178 end
               l_Char_Due_Date := To_Char(l_Due_Date, l_Date_Format);

               --Start Log#88 on 08-Feb-2006
               --l_char_due_date    := l_char_date||SUBSTR(l_char_date,3);
               --log#178 start
               dbg('l_Char_Date '||l_Char_Date);
               dbg('l_last_day '||l_last_day);
               IF l_last_day < l_Char_Date THEN
                  l_Char_Date := l_last_day;
               END IF;
               --log#178 end
               l_Char_Due_Date := l_Char_Date || Substr(l_Char_Due_Date, 3);
               --End Log#88 on 08-Feb-2006

               l_Due_Date := To_Date(l_Char_Due_Date, l_Date_Format);

               IF l_Due_Date <= p_Cur_Start_Date THEN
                  l_Due_Date := Add_Months(l_Due_Date, 1);
               END IF;
            END IF;
         END IF;

         RETURN l_Due_Date;
      END Fn_Get_First_Due_Dt;

      FUNCTION Fn_Prepare_Dsbr_Sch(p_Dsbr_Amt     IN Cltbs_Account_Comp_Sch.Amount%TYPE
                                  ,p_Dsbr_Sch_Rec OUT Cltbs_Account_Comp_Sch%ROWTYPE)
         RETURN BOOLEAN IS

      BEGIN

         p_Dsbr_Sch_Rec.Account_Number := l_Account_No;
         p_Dsbr_Sch_Rec.Branch_Code    := l_Branch_Code;
         p_Dsbr_Sch_Rec.Component_Name := Pkg_Principal;

         --Phase II NLS changes
         p_Dsbr_Sch_Rec.Schedule_Type   := 'D';
         p_Dsbr_Sch_Rec.Schedule_Flag   := 'N';
         p_Dsbr_Sch_Rec.Formula_Name    := NULL;
         p_Dsbr_Sch_Rec.Sch_Start_Date  := l_Value_Date;
         p_Dsbr_Sch_Rec.No_Of_Schedules := 1;
         p_Dsbr_Sch_Rec.Frequency       := 1;
         p_Dsbr_Sch_Rec.Unit            := 'D';
         p_Dsbr_Sch_Rec.Sch_End_Date    := l_Value_Date;
         p_Dsbr_Sch_Rec.Amount          := p_Dsbr_Amt;
         p_Dsbr_Sch_Rec.Capitalized     := 'N';
         p_Dsbr_Sch_Rec.First_Due_Date  := l_Value_Date;
         p_Dsbr_Sch_Rec.Waiver_Flag     := 'N';
         --l_dsbr_comp_sch.payment_mode :=
         --l_dsbr_comp_sch.pmnt_prod_ac
         --l_dsbr_comp_sch.payment_details
         --l_dsbr_comp_sch.ben_account
         --l_dsbr_comp_sch.ben_bank
         --l_dsbr_comp_sch.ben_name
         RETURN TRUE;
      END Fn_Prepare_Dsbr_Sch;
   BEGIN
      Dbg('fn_copy_schs_from_account --->just entered');

      l_Value_Date      := p_Account_Rec.Account_Det.Value_Date;
      l_Maturity_Date   := Nvl(p_Account_Rec.Account_Det.Maturity_Date
                              ,Clpkss_Util.Pkg_Eternity);
      l_Account_No      := p_Account_Rec.Account_Det.Account_Number;
      l_Branch_Code     := p_Account_Rec.Account_Det.Branch_Code;
      l_Amount_Financed := p_Account_Rec.Account_Det.Amount_Financed;
      l_Currency        := p_Account_Rec.Account_Det.Currency;
      l_Product_Code    := p_Account_Rec.Account_Det.Product_Code;

      ------------------------------------------------------------------->
      --->>Sudharshan
      --l_ignore_holidays   := p_account_rec.account_det.ignore_holidays;
      --l_forward_backward  := p_account_rec.ACCOUNT_DET.schedule_movement;
      --l_move_across_month := p_account_rec.ACCOUNT_DET.move_across_month;
      --l_cascade_movement  := p_account_rec.ACCOUNT_DET.cascade_schedules;
      --l_rec_prod                  cltm_product%rowtype;
      l_Rec_Prod        := Clpks_Cache.Fn_Product(p_Account_Rec.Account_Det.Product_Code);
      l_Ignore_Holidays := Nvl(l_Rec_Prod.Ignore_Holidays, 'Y');
      Dbg('**IGNORE**');
      Dbg('l_ignore_holidays    :4:' || l_Ignore_Holidays);
      l_Forward_Backward  := l_Rec_Prod.Schedule_Movement;
      l_Move_Across_Month := l_Rec_Prod.Move_Across_Month;
      l_Cascade_Movement  := l_Rec_Prod.Cascade_Schedules;
      --->>Sudharshan
      ------------------------------------------------------------------->

      Dbg('fn_copy_schs_from_account --->l_value_date ' || l_Value_Date);
      Dbg('fn_copy_schs_from_account --->l_maturity_date' || l_Maturity_Date);
      Dbg('fn_copy_schs_from_account --->l_amount_financed' || l_Amount_Financed);

      l_Sch_Start_Date := l_Value_Date;

      l_Prev_Comp_Plus_Sch_Type := '+';
      FOR Cur_Sch_Rec IN l_Cur_Old_Schedule_Defns LOOP
         l_Rec_Comp_Sch       := Cur_Sch_Rec;
         l_Comp_Plus_Sch_Type := (Cur_Sch_Rec.Component_Name || Cur_Sch_Rec.Schedule_Type);

         Dbg('$$$$$$$$$l_prev_comp_plus_sch_type ' || l_Prev_Comp_Plus_Sch_Type);
         Dbg('$$$$$$$$$l_comp_plus_sch_type ' || l_Comp_Plus_Sch_Type);
         --
         -- R S SAJEESH. 08-JUN-2006 START.
         l_Skip := FALSE;
         IF l_Prev_Comp_Plus_Sch_Type = l_Comp_Plus_Sch_Type AND l_Prev_Sch_Is_Bullet THEN
            l_Skip := TRUE;
         END IF;
         l_Prev_Sch_Is_Bullet := FALSE;

         IF NOT l_Skip THEN
            -- R S SAJEESH. 08-JUN-2006 END.
            --

            IF (l_Prev_Comp_Plus_Sch_Type != l_Comp_Plus_Sch_Type) THEN
               l_Prev_Comp_Plus_Sch_Type := l_Comp_Plus_Sch_Type;
               l_Is_First_Schedule       := TRUE;
               l_Sch_Start_Date          := l_Value_Date;

               Dbg('$$$$$$$$$$$Going inside to find whether it is Discounted');
               l_Is_Discounted := Clpkss_Cache.Fn_Product_Components(l_Product_Code
                                                                    ,Cur_Sch_Rec.Component_Name)
                                 .Formula_Type IN (l_Discounted, l_True_Discounted);
            ELSE
               l_Is_First_Schedule := FALSE;
            END IF;

            l_Rec_Comp_Sch.Sch_Start_Date := l_Sch_Start_Date;

            Dbg('*********l_rec_comp_sch.sch_start_date ' ||
                l_Rec_Comp_Sch.Sch_Start_Date);
            Dbg('*********cur_sch_rec.sch_start_date ' || Cur_Sch_Rec.Sch_Start_Date);
            Dbg('*********cur_sch_rec.first_due_date ' || Cur_Sch_Rec.First_Due_Date);
            Dbg('*********cur_sch_rec.unit ' || Cur_Sch_Rec.Unit);
            Dbg('*********cur_sch_rec.frequency ' || Cur_Sch_Rec.Frequency);

            l_First_Due_Date := Fn_Get_First_Due_Dt(Cur_Sch_Rec.Sch_Start_Date
                                                   ,Cur_Sch_Rec.First_Due_Date
                                                   ,l_Sch_Start_Date
                                                   ,l_Is_First_Schedule
                                                   ,Cur_Sch_Rec.Unit
                                                   ,Cur_Sch_Rec.Frequency
                                                   ,l_Is_Discounted);

            Dbg('*********l_first_due_date ' || l_First_Due_Date);

            --Start log#72
            IF Cur_Sch_Rec.Unit = 'B' AND l_First_Due_Date <> l_Maturity_Date THEN
               l_First_Due_Date := l_Maturity_Date;
            END IF;
            --End log#72
            --
            -- R S SAJEESH. 08-JUN-2006 START.
            Dbg(' l_rec_comp_sch.unit ::' || l_Rec_Comp_Sch.Unit);
            IF l_First_Due_Date = l_Maturity_Date AND l_Rec_Comp_Sch.Unit <> 'B' THEN
               l_Rec_Comp_Sch.Unit  := 'B';
               l_Prev_Sch_Is_Bullet := TRUE;
            END IF;
            -- R S SAJEESH. 08-JUN-2006 END.
            --

            l_Tb_Sch_Dates.DELETE; --SFR # 512

            IF NOT Fn_Compute_Schedule_Dates(l_First_Due_Date
                                            ,l_Value_Date
                                            ,l_Maturity_Date
                                            ,l_Branch_Code
                                            ,l_Product_Code
                                            ,Cur_Sch_Rec.Frequency
                                            ,Cur_Sch_Rec.Unit
                                            ,Cur_Sch_Rec.No_Of_Schedules
                                            ,l_Ignore_Holidays
                                            ,l_Forward_Backward
                                            ,l_Move_Across_Month
                                            ,l_Cascade_Movement
                                            ,Cur_Sch_Rec.Due_Dates_On
                                            ,
                                             --euro bank retro changes LOG#103 starts
                                             -- start month end periodicity LOG#102
                                             NULL
                                            ,
                                             -- end month end periodicity LOG#102
                                             --euro bank retro changes LOG#103 ends
                                             l_Tb_Sch_Dates
                                            ,p_Err_Code
                                            ,
                                             -- START Log#116
                                             Cur_Sch_Rec.Schedule_Type)
            -- END Log#116
             THEN
               Dbg('Failed in call to fn_compute_schedule_dates');
               RETURN FALSE;
            END IF;

            l_First_Due_Date              := l_Tb_Sch_Dates(1);
            l_Rec_Comp_Sch.First_Due_Date := l_First_Due_Date;
            l_Rec_Comp_Sch.Sch_End_Date   := l_Tb_Sch_Dates(l_Tb_Sch_Dates.LAST);
            l_Rec_Comp_Sch.Amount         := 0;
            l_Rec_Comp_Sch.Capitalized    := Nvl(Cur_Sch_Rec.Capitalized, 'N');
            l_Rec_Comp_Sch.Waiver_Flag    := Nvl(Cur_Sch_Rec.Waiver_Flag, 'N');

            l_Sch_Start_Date := l_Tb_Sch_Dates(l_Tb_Sch_Dates.LAST);

            --insert in p_account_rec
            IF NOT
                p_Account_Rec.g_Tb_Components.EXISTS(Nvl(Cur_Sch_Rec.Component_Name, '*')) THEN
               p_Err_Code := 'CL-SCH035;';
               Ovpkss.Pr_Appendtbl(p_Err_Code, '');
               l_Tb_For_Disbr.DELETE;
               RETURN FALSE;
            END IF;
            Dbg('fn_copy_schs_from_account --->populating account rec for first due date as ' ||
                l_Rec_Comp_Sch.First_Due_Date);
            l_Indx := l_Rec_Comp_Sch.Schedule_Type ||
                      Clpkss_Util.Fn_Hash_Date(l_Rec_Comp_Sch.First_Due_Date, NULL);

            p_Account_Rec.g_Tb_Components(l_Rec_Comp_Sch.Component_Name) .g_Tb_Comp_Sch(l_Indx) .g_Account_Comp_Sch := l_Rec_Comp_Sch;

            p_Account_Rec.g_Tb_Components(l_Rec_Comp_Sch.Component_Name) .g_Tb_Comp_Sch(l_Indx) .g_Record_Rowid := NULL;

            p_Account_Rec.g_Tb_Components(l_Rec_Comp_Sch.Component_Name) .g_Tb_Comp_Sch(l_Indx) .g_Action := 'I';

            --collect disbursment schedules index and no of schedules
            /*IF (cur_sch_rec.schedule_type = 'D') AND
               cur_sch_rec.component_name = PKG_PRINCIPAL
            THEN
                l_no_of_disb_schs := l_no_of_disb_schs +
                                      nvl(cur_sch_rec.no_of_schedules,0);
                l_tb_for_disbr(l_disb_indx) := l_indx;
                l_disb_indx := l_disb_indx + 1;
            END IF;*/
         END IF; --  R S SAJEESH. 08-JUN-2006.
      END LOOP;

      /*--distribute disbursment amount
      dbg('fn_copy_schs_from_account --->no of disbr schedules '||l_no_of_disb_schs);
      IF (l_no_of_disb_schs >= 1 ) THEN

          IF NOT p_account_rec.g_tb_components.EXISTS(PKG_PRINCIPAL) THEN

          --Phase II NLS changes
              l_tb_for_disbr.DELETE;
              p_err_code  := 'CL-SCH035;';
               ovpkss.pr_appendTbl(p_err_code,'');
              RETURN FALSE;
          END IF;

          l_disbr_sch_amt := l_amount_financed / l_no_of_disb_schs;


          IF NOT cypkss.fn_amt_round(l_currency,
                                     l_disbr_sch_amt,
                                     l_disbr_sch_rnd_amt)
          THEN
              l_tb_for_disbr.DELETE;
              RETURN(FALSE);
          END IF;
          dbg('fn_copy_schs_from_account --->l_disbr_sch_rnd_amt '||l_disbr_sch_rnd_amt);

          FOR i IN l_tb_for_disbr.FIRST .. l_tb_for_disbr.LAST
          LOOP
              IF (p_account_rec.g_tb_components(PKG_PRINCIPAL)
          --Phase II NLS changes
                  .g_tb_comp_sch.EXISTS(l_tb_for_disbr(i) ))
              THEN
                  p_account_rec.g_tb_components(PKG_PRINCIPAL).g_tb_comp_sch(l_tb_for_disbr(i))
      --Phase II NLS changes
                  .g_account_comp_sch.amount := l_disbr_sch_rnd_amt;
              END IF;
          END LOOP;
      END IF;*/

      l_Tb_For_Disbr.DELETE;
      --Log#118 Start
      IF Nvl(l_Rec_Prod.Disbursement_Mode, '#') = 'A' THEN
         --Log#118 End

         IF NOT Fn_Prepare_Dsbr_Sch(l_Amount_Financed, l_Dsbr_Sch_Rec) THEN
            RETURN FALSE;
         ELSE
            l_Indx := 'D' || Clpkss_Util.Fn_Hash_Date(l_Value_Date, NULL);

            p_Account_Rec.g_Tb_Components(Pkg_Principal) .g_Tb_Comp_Sch(l_Indx) .g_Account_Comp_Sch := l_Dsbr_Sch_Rec;

            p_Account_Rec.g_Tb_Components(Pkg_Principal) .g_Tb_Comp_Sch(l_Indx) .g_Record_Rowid := NULL;

            p_Account_Rec.g_Tb_Components(Pkg_Principal) .g_Tb_Comp_Sch(l_Indx) .g_Action := 'I';

            --Phase II NLS changes

         END IF;
         --Log#118 Start
      END IF;
      --Log#118 End

      Dbg('fn_copy_schs_from_account ---> done with schedules creation ..calling create now');
      --schedule definitions complete
      --call fn_create_schedules for populating detail tables.

      IF NOT
          Fn_Create_Schedule(p_Account_Rec, 'ROLL', l_Value_Date, p_Err_Code, p_Err_Param) THEN
         Dbg('fn_copy_schs_from_account --->fn_create_schedules returned False');
         RETURN FALSE;
      END IF;

      Dbg('fn_copy_schs_from_account --->returning true');

      RETURN TRUE;

   EXCEPTION
      WHEN OTHERS THEN
         Dbg('in when others of fn_copy_schs_from_account with ' || SQLERRM);
         l_Tb_For_Disbr.DELETE;

         Clpkss_Logger.Pr_Log_Exception('');

         p_Err_Code  := 'CL-SCH030;';
         p_Err_Param := 'fn_copy_schs_from_account~;';
         Ovpkss.Pr_Appendtbl(p_Err_Code, p_Err_Param);
         RETURN FALSE;
   END Fn_Gen_Copy_Schs_From_Account;
   -- Changes end for FCCCL1.0 SFR#416 L Anantharaman 09-Dec-2004

   FUNCTION Fn_Copy_Schs_From_Account(p_Account_Rec     IN OUT NOCOPY Clpkss_Object.Ty_Rec_Account
                                     ,p_Processing_Date IN Cltbs_Account_Master.Value_Date%TYPE
                                     ,p_Old_Value_Date  IN Cltbs_Account_Master.Value_Date%TYPE
                                     ,p_Err_Code        IN OUT Ertbs_Msgs.Err_Code%TYPE
                                     ,p_Err_Param       IN OUT Ertbs_Msgs.Message%TYPE)
      RETURN BOOLEAN IS
   BEGIN
      IF NOT Clpkss_Stream_Schedules.Fn_Pre_Copy_Schs_From_Account(p_Account_Rec
                                                                  ,p_Processing_Date
                                                                  ,p_Old_Value_Date
                                                                  ,p_Err_Code
                                                                  ,p_Err_Param) THEN
         RETURN FALSE;
      END IF;

      IF Clpkss_Stream_Schedules.Fn_Ovrdn_Copy_Schs THEN
         IF NOT Clpkss_Stream_Schedules.Fn_Copy_Schs_From_Account(p_Account_Rec
                                                                 ,p_Processing_Date
                                                                 ,p_Old_Value_Date
                                                                 ,p_Err_Code
                                                                 ,p_Err_Param) THEN
            RETURN FALSE;
         END IF;
      ELSE
         IF NOT Fn_Gen_Copy_Schs_From_Account(p_Account_Rec
                                             ,p_Processing_Date
                                             ,p_Old_Value_Date
                                             ,p_Err_Code
                                             ,p_Err_Param) THEN
            RETURN FALSE;
         END IF;
      END IF;
      IF NOT Clpkss_Stream_Schedules.Fn_Post_Copy_Schs_From_Account(p_Account_Rec
                                                                   ,p_Processing_Date
                                                                   ,p_Old_Value_Date
                                                                   ,p_Err_Code
                                                                   ,p_Err_Param) THEN
         RETURN FALSE;
      END IF;

      RETURN TRUE;
   EXCEPTION
      WHEN OTHERS THEN
         Dbg('in when others of fn_copy_schs_from_account with ' || SQLERRM);
         Clpkss_Logger.Pr_Log_Exception('');
         p_Err_Code  := 'CL-SCH030;';
         p_Err_Param := 'fn_copy_schs_from_account~;';
         Ovpkss.Pr_Appendtbl(p_Err_Code, p_Err_Param);
         RETURN FALSE;

   END Fn_Copy_Schs_From_Account;

   FUNCTION Fn_Gen_Recalc_Schedules(p_Account_Rec    IN OUT NOCOPY Clpkss_Object.Ty_Rec_Account
                                   ,p_Action_Code    IN VARCHAR2
                                   ,p_Effective_Date IN DATE
                                   ,p_To_Date        IN DATE
                                   ,p_Diff_Amt       IN NUMBER
                                   ,p_Emi_Calc_Reqd  IN BOOLEAN
                                   ,p_Err_Code       IN OUT Ertbs_Msgs.Err_Code%TYPE
                                   ,p_Err_Param      IN OUT Ertbs_Msgs.Message%TYPE)
      RETURN BOOLEAN IS

      l_Tb_Amount_Paid    g_Ty_Tb_Amount_Paid;
      l_Tb_Amount_Accrued Clpks_Schedules.Pkg_Tb_Amount_Accrued;
      l_Bool              BOOLEAN;

      --START Prasanna FCCCL Phase 2 SFR#305. 04-May-2005
      l_Ori_Amount_Financed Cltbs_Account_Master.Amount_Financed%TYPE;
      --END Prasanna FCCCL Phase 2 SFR#305. 04-May-2005

      --START Prasanna FCC-CL 2.1 EURO BANK SUPPORT.
      --SFR#AAL034-04.EXTRA HIGH ISSUE.
      --INSTEAD OF CALLING clpkss_calc.fn_recalc_components, clpkss_recalc.fn_recalc_for_an_account is called.
      --clpkss_recalc.fn_recalc_for_an_account has functionality to apply future rates.
      l_Tb_Calc_Dates Clpkss_Recalc.Ty_Tb_Calc_Dates;
      --END Prasanna FCC-CL 2.1 EURO BANK SUPPORT. FUTURE RATES WAS NOT GETTING APPLIED IN CASE OF MDSBR.
      --INSTEAD OF CALLING clpkss_calc.fn_recalc_components, clpkss_recalc.fn_recalc_for_an_account is called.
      --clpkss_recalc.fn_recalc_for_an_account has functionality to apply future rates.
      --END Prasanna FCC-CL 2.1 EURO BANK SUPPORT.
      --SFR#AAL034-04.EXTRA HIGH ISSUE.
       --Log#140 Start changes for Advance and arrears schedules
         l_sch_idx  pls_integer;
         l_newstdate date;
       --Log#140 End changes for Advance and arrears schedules
   BEGIN
      --call fn_validate_schedules

      --START Prasanna FCCCL Phase 2 SFR#305. 04-May-2005
      IF p_Action_Code = 'VAMI' THEN
         l_Ori_Amount_Financed                     := p_Account_Rec.Account_Det.Amount_Financed;
         p_Account_Rec.Account_Det.Amount_Financed := p_Account_Rec.Account_Det.Amount_Financed +
                                                      p_Diff_Amt;
      END IF;
      --END Prasanna FCCCL Phase 2 SFR#305. 04-May-2005

      l_Bool := Fn_Validate_Schedules(p_Account_Rec
                                     ,p_Action_Code
                                     ,p_Err_Code
                                     ,p_Err_Param);
      IF NOT l_Bool THEN
         RETURN FALSE;
      END IF;

      --call fn_amount_settled
      Clpkss_Schedules.g_Tb_Acc_Hol_Perds := p_Account_Rec.g_Hol_Perds; ---LOG#48

      l_Bool := Fn_Amount_Settled(p_Account_Rec
                                 ,p_Effective_Date
                                 ,l_Tb_Amount_Paid
                                 ,p_Err_Code
                                 ,p_Err_Param);
      IF NOT l_Bool THEN
         l_Tb_Amount_Paid.DELETE;
         RETURN FALSE;
      END IF;
--Log#140 Start changes for Advance and arrears schedules
        IF p_action_code = 'VAMI'  and NVL(p_account_rec.account_det.lease_type,'X') = 'F'  AND   NVL(p_account_rec.account_det.lease_payment_mode,'X') = 'A' AND p_account_rec.account_det.module_code='LE'  then -- Log#162 Changes for 11.1 Dev (Payment in Advance)
        begin
        if p_account_rec.g_tb_components.exists(PKG_PRINCIPAL) then
        l_sch_idx := p_account_rec.g_tb_components(PKG_PRINCIPAL).g_tb_amt_due.first;
        while  l_sch_idx is not null
        loop
        if  (nvl(p_account_rec.g_tb_components(PKG_PRINCIPAL).g_tb_amt_due(l_sch_idx).
        g_amount_due.amount_due,-1)  !=
        nvl(p_account_rec.g_tb_components(PKG_PRINCIPAL).g_tb_amt_due(l_sch_idx).
        g_amount_due.amount_settled,-2) )
        OR (nvl(p_account_rec.g_tb_components(PKG_PRINCIPAL).g_tb_amt_due(l_sch_idx).
        g_amount_due.amount_due,-1) = 0
        AND nvl(p_account_rec.g_tb_components(PKG_PRINCIPAL).g_tb_amt_due(l_sch_idx).
        g_amount_due.amount_settled,-2) = 0 )
        then
        l_newstdate := p_account_rec.g_tb_components(PKG_PRINCIPAL).g_tb_amt_due(l_sch_idx).
        g_amount_due.schedule_due_date ;
        exit;
        else
        l_sch_idx := p_account_rec.g_tb_components(PKG_PRINCIPAL).g_tb_amt_due.NEXT(l_sch_idx);
        end if;
        end loop;
        end if;
        end;
    --    end if; --17.12.2007 Ravi
     l_newstdate := NVL(l_newstdate,p_effective_date);
     l_bool := fn_create_schedule(p_account_rec   ,
                                      'REDEF',
                                      l_newstdate ,
                                       p_err_code   ,
                                       p_err_param ) ;
        IF NOT l_bool THEN
           l_tb_amount_paid.DELETE;
           l_tb_amount_accrued.DELETE;
           RETURN FALSE;
         END IF;
         END IF; --17.12l.2007 Ravi shifted the End if
        --Log#140 End changes for Advance and arrears schedules
      --store amount accrued
      l_Bool := Fn_Store_Amount_Accrued(p_Account_Rec
                                       ,p_Effective_Date
                                       ,l_Tb_Amount_Accrued
                                       ,p_Err_Code
                                       ,p_Err_Param);
      IF NOT l_Bool THEN
         l_Tb_Amount_Paid.DELETE;
         l_Tb_Amount_Accrued.DELETE;
         RETURN FALSE;
      END IF;
      --call fn_create
      --fn_create_schedules will be called with 'REDEF' only 'bcos processing does not differ
      --at all for REDEF and VAMI here.

      --START Prasanna FCCCL Phase 2 SFR#305. 04-May-2005
      IF p_Action_Code = 'VAMI' THEN
         --  p_account_rec.account_det.amount_financed := l_ori_amount_financed;
         Dbg('Commented Prasanna Change ' || p_Account_Rec.Account_Det.Amount_Financed);
         Dbg('ORI = ' || l_Ori_Amount_Financed);
      END IF;
      --END Prasanna FCCCL Phase 2 SFR#305. 04-May-2005

      l_Bool := Fn_Create_Schedule(p_Account_Rec
                                  ,
                                   --Log#120 Starts
                                   --'REDEF',
                                   p_Action_Code
                                  ,
                                   --Log#120 Ends
                                   p_Effective_Date
                                  ,p_Err_Code
                                  ,p_Err_Param);
      --call calc

      IF NOT l_Bool THEN
         l_Tb_Amount_Paid.DELETE;
         l_Tb_Amount_Accrued.DELETE;
         RETURN FALSE;
      END IF;

      --START EURO BANK SUPPORT CHANGES FOR MULTIPLE EMI CALCULATIONS.
      --SFR#AAL034-04.EXTRA HIGH ISSUE.
      Dbg('$$$$$$$$$$$p_action_code ' || p_Action_Code);
      IF p_Action_Code NOT IN ('REDEF', 'VAMI') THEN
         l_Bool := Clpkss_Calc.Fn_Recalc_Components(p_Account_Rec
                                                   ,p_Effective_Date
                                                   ,p_To_Date
                                                   ,p_Diff_Amt
                                                   , --0
                                                    p_Emi_Calc_Reqd
                                                   , --true
                                                    p_Err_Code
                                                   ,p_Err_Param);

         IF NOT l_Bool THEN
            l_Tb_Amount_Paid.DELETE;
            RETURN FALSE;
         END IF;

      ELSE
         Dbg('$$$$$$$$Going inside$$$$$$$$$$');

         l_Tb_Calc_Dates.DELETE;

         l_Tb_Calc_Dates(l_Tb_Calc_Dates.COUNT + 1) .Account_Number := p_Account_Rec.Account_Det.Account_Number;
         l_Tb_Calc_Dates(l_Tb_Calc_Dates.COUNT) .Branch_Code := p_Account_Rec.Account_Det.Branch_Code;
         l_Tb_Calc_Dates(l_Tb_Calc_Dates.COUNT) .Recalc_Action_Code := 'N'; -- This would have E/T for prepayment case and N for Normal Payment case
         l_Tb_Calc_Dates(l_Tb_Calc_Dates.COUNT) .Recalc_Date := p_Effective_Date;
         l_Tb_Calc_Dates(l_Tb_Calc_Dates.COUNT) .Process_No := p_Account_Rec.Account_Det.Process_No;
         l_Tb_Calc_Dates(l_Tb_Calc_Dates.COUNT) .Principal_Chg_Amt := p_Diff_Amt;

         Dbg(' Calling recalc with l_tb_calc_dates.COUNT :' || l_Tb_Calc_Dates.COUNT);
         -- Do re-calculation because the schedules might have been changed (in case of prepayment, there is an option provided to change the computation basis - i.e. to reduce EMI or to reduce tenor)
         IF NOT Clpkss_Recalc.Fn_Recalc_For_An_Account(p_Account_Rec
                                                      ,p_Effective_Date
                                                      ,l_Tb_Calc_Dates
                                                      ,'E'
                                                      ,p_Err_Code
                                                      ,p_Err_Param) THEN
            l_Tb_Amount_Paid.DELETE;
            RETURN FALSE;
            --LOG#133 Start
         ELSE
            l_Bool := Fn_Gen_Sch_No(p_Account_Rec, p_Err_Code, p_Err_Param);
            IF l_Bool = FALSE THEN
               Dbg('fn_gen__sch_no returned false');
            END IF;
            --LOG#133 End
         END IF;
      END IF;
      --END Prasanna FCC-CL 2.1 EURO BANK SUPPORT. FUTURE RATES WAS NOT GETTING APPLIED IN CASE OF MDSBR.
      --INSTEAD OF CALLING clpkss_calc.fn_recalc_components, clpkss_recalc.fn_recalc_for_an_account is called.
      --clpkss_recalc.fn_recalc_for_an_account has functionality to apply future rates.
      --END EURO BANK SUPPORT CHANGES FOR MULTIPLE EMI CALCULATIONS.
      --SFR#AAL034-04.EXTRA HIGH ISSUE.

      --call fn_apply_amt_paid.
      IF l_Tb_Amount_Paid.COUNT > 0 THEN
         l_Bool := Fn_Apply_Amt_Paid(p_Account_Rec
                                    ,p_Effective_Date
                                    ,l_Tb_Amount_Paid
                                    ,p_Err_Code
                                    ,p_Err_Param);
         IF NOT l_Bool THEN
            l_Tb_Amount_Paid.DELETE;
            l_Tb_Amount_Accrued.DELETE;
            RETURN FALSE;
         END IF;
      END IF;
      --call amount accrued
      IF l_Tb_Amount_Accrued.COUNT > 0 THEN
         l_Bool := Fn_Apply_Amt_Accrued(p_Account_Rec
                                       ,p_Effective_Date
                                       ,l_Tb_Amount_Accrued
                                       ,p_Err_Code
                                       ,p_Err_Param);
         IF NOT l_Bool THEN
            l_Tb_Amount_Paid.DELETE;
            l_Tb_Amount_Accrued.DELETE;
            RETURN FALSE;
         END IF;
      END IF;

      RETURN TRUE;

   EXCEPTION
      WHEN OTHERS THEN
         l_Tb_Amount_Paid.DELETE;
         l_Tb_Amount_Accrued.DELETE;
         p_Err_Code  := 'CL-SCH036;';
         p_Err_Param := 'fn_recalc_schedules~;';
         Ovpkss.Pr_Appendtbl(p_Err_Code, p_Err_Param);
         RETURN FALSE;
   END Fn_Gen_Recalc_Schedules;
   FUNCTION Fn_Recalc_Schedules(p_Account_Rec    IN OUT NOCOPY Clpkss_Object.Ty_Rec_Account
                               ,p_Action_Code    IN VARCHAR2
                               ,p_Effective_Date IN DATE
                               ,p_To_Date        IN DATE
                               ,p_Diff_Amt       IN NUMBER
                               ,p_Emi_Calc_Reqd  IN BOOLEAN
                               ,p_Err_Code       IN OUT Ertbs_Msgs.Err_Code%TYPE
                               ,p_Err_Param      IN OUT Ertbs_Msgs.Message%TYPE)
      RETURN BOOLEAN IS
   BEGIN
      IF NOT Clpkss_Stream_Schedules.Fn_Pre_Recalc_Schedules(p_Account_Rec
                                                            ,p_Action_Code
                                                            ,p_Effective_Date
                                                            ,p_To_Date
                                                            ,p_Diff_Amt
                                                            ,p_Emi_Calc_Reqd
                                                            ,p_Err_Code
                                                            ,p_Err_Param) THEN
         RETURN FALSE;
      END IF;
      IF Clpkss_Stream_Schedules.Fn_Ovrdn_Recalc_Schedules THEN
         IF NOT Clpkss_Stream_Schedules.Fn_Recalc_Schedules(p_Account_Rec
                                                           ,p_Action_Code
                                                           ,p_Effective_Date
                                                           ,p_To_Date
                                                           ,p_Diff_Amt
                                                           ,p_Emi_Calc_Reqd
                                                           ,p_Err_Code
                                                           ,p_Err_Param) THEN
            RETURN FALSE;
         END IF;
      ELSE
         IF NOT Fn_Gen_Recalc_Schedules(p_Account_Rec
                                       ,p_Action_Code
                                       ,p_Effective_Date
                                       ,p_To_Date
                                       ,p_Diff_Amt
                                       ,p_Emi_Calc_Reqd
                                       ,p_Err_Code
                                       ,p_Err_Param) THEN
            RETURN FALSE;
         END IF;
      END IF;
      IF NOT Clpkss_Stream_Schedules.Fn_Post_Recalc_Schedules(p_Account_Rec
                                                             ,p_Action_Code
                                                             ,p_Effective_Date
                                                             ,p_To_Date
                                                             ,p_Diff_Amt
                                                             ,p_Emi_Calc_Reqd
                                                             ,p_Err_Code
                                                             ,p_Err_Param) THEN
         RETURN FALSE;
      END IF;

      RETURN TRUE;

   EXCEPTION
      WHEN OTHERS THEN
         p_Err_Code  := 'CL-SCH036;';
         p_Err_Param := 'fn_recalc_schedules~;';
         Ovpkss.Pr_Appendtbl(p_Err_Code, p_Err_Param);
         RETURN FALSE;
   END Fn_Recalc_Schedules;

   FUNCTION Fn_Clear_Deleted_Schedules(p_Account_Rec IN OUT NOCOPY Clpkss_Object.Ty_Rec_Account
                                      ,p_Err_Code    IN OUT Ertbs_Msgs.Err_Code%TYPE
                                      ,p_Err_Param   IN OUT Ertbs_Msgs.Message%TYPE)
      RETURN BOOLEAN IS

      l_Comp_Indx     Cltbs_Account_Components.Component_Name%TYPE;
      l_Comp_Sch_Indx VARCHAR2(100);
      l_Tb_Comp_Sch   Clpkss_Object.Ty_Tb_Account_Comp_Sch;

   BEGIN
      l_Comp_Indx := p_Account_Rec.g_Tb_Components.FIRST;

      WHILE l_Comp_Indx IS NOT NULL LOOP
         l_Tb_Comp_Sch := p_Account_Rec.g_Tb_Components(l_Comp_Indx).g_Tb_Comp_Sch;

         l_Comp_Sch_Indx := l_Tb_Comp_Sch.FIRST;

         WHILE l_Comp_Sch_Indx IS NOT NULL LOOP
            IF Nvl(l_Tb_Comp_Sch(l_Comp_Sch_Indx).g_Action, '*') = 'D' THEN
               Dbg('in fn_clear_deleted_schedules deleting FOR comp ' || l_Comp_Indx ||
                   ' and schedule type ' || l_Tb_Comp_Sch(l_Comp_Sch_Indx)
                   .g_Account_Comp_Sch.Schedule_Type || ' and due date ' ||
                   l_Tb_Comp_Sch(l_Comp_Sch_Indx).g_Account_Comp_Sch.First_Due_Date);

               p_Account_Rec.g_Tb_Components(l_Comp_Indx) .g_Tb_Comp_Sch.DELETE(l_Comp_Sch_Indx);
            END IF;
            l_Comp_Sch_Indx := l_Tb_Comp_Sch.NEXT(l_Comp_Sch_Indx);
         END LOOP;

         l_Comp_Indx := p_Account_Rec.g_Tb_Components.NEXT(l_Comp_Indx);
      END LOOP;

      l_Tb_Comp_Sch.DELETE;

      RETURN TRUE;
   EXCEPTION
      WHEN OTHERS THEN
         p_Err_Code  := 'CL-SCH036;';
         p_Err_Param := 'fn_recalc_schedules~;';
         Ovpkss.Pr_Appendtbl(p_Err_Code, p_Err_Param);
         l_Tb_Comp_Sch.DELETE;
         RETURN FALSE;
   END Fn_Clear_Deleted_Schedules;

   FUNCTION Fn_Is_Within_Tolerance(p_Absoulte_Amt IN Cltbs_Account_Master.Amount_Financed%TYPE
                                  ,p_Rounded_Amt  IN Cltbs_Account_Master.Amount_Financed%TYPE
                                  ,p_No_Of_Units  IN Cltbs_Account_Comp_Sch.No_Of_Schedules%TYPE
                                  ,p_Ccy          IN Cytms_Ccy_Defn.Ccy_Code%TYPE
                                  ,p_Result       OUT VARCHAR2) RETURN BOOLEAN IS
      l_Ccy_Rec         Cytms_Ccy_Defn%ROWTYPE;
      l_Tolerance_Limit Cltbs_Account_Master.Amount_Financed%TYPE;
      l_Diff_Amt        Cltbs_Account_Master.Amount_Financed%TYPE;
   BEGIN
      p_Result   := 'Y';
      l_Diff_Amt := Abs(p_Absoulte_Amt - p_Rounded_Amt);
      IF Nvl(l_Diff_Amt, 0) = 0 THEN
         RETURN TRUE;
      END IF;
      Dbg('l_diff_amt is ' || l_Diff_Amt);
      l_Ccy_Rec := Clpkss_Cache.Fn_Cytm_Ccy_Defn(p_Ccy);

      l_Tolerance_Limit := p_No_Of_Units * Nvl((l_Ccy_Rec.Ccy_Round_Unit), 0);

      Dbg('tolerance_limit calculated is' || l_Tolerance_Limit);

      IF l_Diff_Amt > l_Tolerance_Limit THEN
         p_Result := 'N';
      END IF;

      RETURN TRUE;

   EXCEPTION
      WHEN OTHERS THEN
         Dbg('in when others of fn_get_tolerance with ' || SQLERRM);
         RETURN FALSE;
   END Fn_Is_Within_Tolerance;

   FUNCTION Fn_Store_Amount_Accrued(p_Account_Rec IN OUT NOCOPY Clpkss_Object.Ty_Rec_Account
                                   ,
                                    --START Prasanna FCCCL 1.0 MTR1 SFR#524 9NT252 20-DEC-2004
                                    --p_eff_date           IN            cltbs_matdt_chg.effective_date%TYPE,
                                    p_Eff_Date IN DATE
                                   ,
                                    --END Prasanna FCCCL 1.0 MTR1 SFR#524 9NT252 20-DEC-2004
                                    p_Tb_Amount_Accrued OUT Clpks_Schedules.Pkg_Tb_Amount_Accrued
                                   ,p_Err_Code          IN OUT Ertbs_Msgs.Err_Code%TYPE
                                   ,p_Err_Param         IN OUT Ertbs_Msgs.Message%TYPE)
      RETURN BOOLEAN IS

      l_Amount_Accrued   Cltbs_Account_Schedules.Accrued_Amount%TYPE;
      l_Comp_Indx        Cltbs_Account_Schedules.Component_Name%TYPE;
      l_Comp_Due_Indx    PLS_INTEGER;
      l_Comp_Rec         Clpkss_Object.Ty_Rec_Components;
      l_Bool             BOOLEAN;
      l_First_Split_Date DATE;
      -- Log#106 Start.
      l_Susp_Amt_Due     Cltbs_Account_Schedules.Susp_Amt_Due%TYPE;
      l_Susp_Amt_Lcy     Cltbs_Account_Schedules.Susp_Amt_Lcy%TYPE;
      l_Susp_Amt_Settled Cltbs_Account_Schedules.Susp_Amt_Settled%TYPE;
      -- Log#106 End.
   BEGIN
      Dbg('Start of the function fn_store_amount_accrued');

      l_Comp_Indx := p_Account_Rec.g_Tb_Components.FIRST;

      WHILE l_Comp_Indx IS NOT NULL LOOP
         l_Comp_Rec := p_Account_Rec.g_Tb_Components(l_Comp_Indx);

         IF Nvl(l_Comp_Rec.Comp_Det.Component_Type, '#') NOT IN ('H', 'O') THEN
            --log#114 Performance tuning
            l_Bool := Fn_Get_Actual_Split_Date(l_Comp_Rec
                                              ,p_Eff_Date
                                              ,'P'
                                              ,l_First_Split_Date
                                              ,p_Err_Code);
            IF l_Bool = FALSE THEN
               RETURN FALSE;
            END IF;

            --
            --Log#72 Start.

            IF l_First_Split_Date IS NULL AND
               p_Eff_Date <> p_Account_Rec.Account_Det.Value_Date -- which menas its not acct craetion.
              --AND NVL(l_comp_rec.comp_det.component_type,'#') <> 'P' -- not for penlty. --log#94 on 16-feb-2006

              --log#111 retro starts
              -- AND NVL(l_comp_rec.comp_det.component_type,'#') NOT IN ('P','M','H') -- not for penlty.
               AND Nvl(l_Comp_Rec.Comp_Det.Component_Type, '#') NOT IN
               ('P', 'M', 'H', 'O', 'F') --Log#126 added F.
            --log#111 retro ends

             THEN
               --Log#122
               IF p_Account_Rec.g_Tb_Components(l_Comp_Indx).g_Tb_Amt_Due.COUNT > 0 THEN
                  l_First_Split_Date := p_Account_Rec.g_Tb_Components(l_Comp_Indx)
                                       .g_Tb_Amt_Due(p_Account_Rec.g_Tb_Components(l_Comp_Indx)
                                                     .g_Tb_Amt_Due.LAST) .
                                        g_Amount_Due.Schedule_Due_Date;
               END IF;
               --Log#122
            END IF;

            Dbg(' l_first_split_date ::' || l_First_Split_Date);
            -- Log#72 End.
            --
         ELSE
            --log#114 Change
            l_First_Split_Date := NULL;
         END IF; --log#114 Change

         IF l_First_Split_Date IS NOT NULL THEN

            l_Comp_Due_Indx := Clpkss_Util.Fn_Hash_Date(l_First_Split_Date);

            l_Amount_Accrued := 0;
            -- Log#106 Start.
            l_Susp_Amt_Due     := 0;
            l_Susp_Amt_Lcy     := 0;
            l_Susp_Amt_Settled := 0;
            -- Log#106 End.
			--9NT1368-ITR1-SFR#3883  - Jai Mohan V - Begins
            /*IF NOT p_Account_Rec.g_Tb_Components(l_Comp_Indx)
            .g_Tb_Amt_Due.EXISTS(l_Comp_Due_Indx) THEN
               p_Err_Code  := 'CL-SCH029;';
               p_Err_Param := l_Comp_Indx || '~;';
               Ovpkss.Pr_Appendtbl(p_Err_Code, p_Err_Param);
               RETURN FALSE;
            ELSE*/
            --9NT1368-ITR1-SFR#3883  - Jai Mohan V - Ends
            IF p_Account_Rec.g_Tb_Components(l_Comp_Indx)
            .g_Tb_Amt_Due.EXISTS(l_Comp_Due_Indx) THEN
               l_Amount_Accrued := Nvl(p_Account_Rec.g_Tb_Components(l_Comp_Indx)
                                       .g_Tb_Amt_Due(l_Comp_Due_Indx)
                                       .g_Amount_Due.Accrued_Amount
                                      ,0);
               -- Log#106 Start.
               Dbg('susp_amt_due ::' || p_Account_Rec.g_Tb_Components(l_Comp_Indx)
                   .g_Tb_Amt_Due(l_Comp_Due_Indx).g_Amount_Due.Susp_Amt_Due);
               Dbg('susp_amt_lcy ::' || p_Account_Rec.g_Tb_Components(l_Comp_Indx)
                   .g_Tb_Amt_Due(l_Comp_Due_Indx).g_Amount_Due.Susp_Amt_Lcy);
               Dbg('susp_amt_settled ::' || p_Account_Rec.g_Tb_Components(l_Comp_Indx)
                   .g_Tb_Amt_Due(l_Comp_Due_Indx).g_Amount_Due.Susp_Amt_Settled);

               l_Susp_Amt_Due     := Nvl(p_Account_Rec.g_Tb_Components(l_Comp_Indx)
                                         .g_Tb_Amt_Due(l_Comp_Due_Indx)
                                         .g_Amount_Due.Susp_Amt_Due
                                        ,0);
               l_Susp_Amt_Lcy     := Nvl(p_Account_Rec.g_Tb_Components(l_Comp_Indx)
                                         .g_Tb_Amt_Due(l_Comp_Due_Indx)
                                         .g_Amount_Due.Susp_Amt_Lcy
                                        ,0);
               l_Susp_Amt_Settled := Nvl(p_Account_Rec.g_Tb_Components(l_Comp_Indx)
                                         .g_Tb_Amt_Due(l_Comp_Due_Indx)
                                         .g_Amount_Due.Susp_Amt_Settled
                                        ,0);

               --p_tb_amount_accrued(l_comp_indx) := l_amount_accrued;  -- Log#106 Commented.
               p_Tb_Amount_Accrued(l_Comp_Indx) .Accrued_Amount := l_Amount_Accrued;
               p_Tb_Amount_Accrued(l_Comp_Indx) .Susp_Amt_Due := l_Susp_Amt_Due;
               p_Tb_Amount_Accrued(l_Comp_Indx) .Susp_Amt_Lcy := l_Susp_Amt_Lcy;
               p_Tb_Amount_Accrued(l_Comp_Indx) .Susp_Amt_Settled := l_Susp_Amt_Settled;
               -- Log#106 End.
            END IF;
         END IF;
         l_Comp_Indx := p_Account_Rec.g_Tb_Components.NEXT(l_Comp_Indx);
      END LOOP;

      Dbg('End of the function fn_store_amount_accrued ');

      RETURN TRUE;

   EXCEPTION
      WHEN OTHERS THEN
         Dbg('In when others of fn_store_amount_accrued - ' || SQLERRM);

         Clpkss_Logger.Pr_Log_Exception('');

         p_Err_Code  := 'CL-SCH036;';
         p_Err_Param := 'fn_store_amount_accrued~;';

         Ovpkss.Pr_Appendtbl(p_Err_Code, p_Err_Param);

         RETURN FALSE;
   END Fn_Store_Amount_Accrued;

   FUNCTION Fn_Apply_Amt_Accrued(p_Account_Rec IN OUT NOCOPY Clpkss_Object.Ty_Rec_Account
                                ,
                                 --START Prasanna FCCCL 1.0 MTR1 SFR#524 9NT252 20-DEC-2004
                                 --p_eff_date          IN            cltbs_matdt_chg.effective_date%TYPE,
                                 p_Eff_Date IN DATE
                                ,
                                 --END Prasanna FCCCL 1.0 MTR1 SFR#524 9NT252 20-DEC-2004
                                 p_Tb_Amount_Accrued IN Clpks_Schedules.Pkg_Tb_Amount_Accrued
                                ,p_Err_Code          IN OUT Ertbs_Msgs.Err_Code%TYPE
                                ,p_Err_Param         IN OUT Ertbs_Msgs.Message%TYPE)
      RETURN BOOLEAN IS

      l_Tb_Account_Sch Clpkss_Object.Ty_Tb_Amt_Due;
      l_Amount_Accured Cltbs_Account_Schedules.Accrued_Amount%TYPE;
      l_Comp_Indx      Cltbs_Account_Comp_Sch.Component_Name%TYPE;
      l_Comp_Due_Indx  PLS_INTEGER;
      l_Eff_Date_Indx  PLS_INTEGER;
      -- Log#106 Start.
      l_Susp_Amt_Due     Cltbs_Account_Schedules.Susp_Amt_Due%TYPE;
      l_Susp_Amt_Lcy     Cltbs_Account_Schedules.Susp_Amt_Lcy%TYPE;
      l_Susp_Amt_Settled Cltbs_Account_Schedules.Susp_Amt_Settled%TYPE;
      -- Log#106 End.

   BEGIN
      Dbg('Start of the function fn_apply_amt_accrued');

      l_Comp_Indx := p_Account_Rec.g_Tb_Components.FIRST;

      l_Eff_Date_Indx := Clpkss_Util.Fn_Hash_Date(p_Eff_Date);

      WHILE l_Comp_Indx IS NOT NULL LOOP

         IF p_Tb_Amount_Accrued.EXISTS(l_Comp_Indx) THEN
            -- Log#106 Start.
            Dbg(' In exists');
            --l_amount_accured := p_tb_amount_accrued(l_comp_indx);
            l_Amount_Accured   := p_Tb_Amount_Accrued(l_Comp_Indx).Accrued_Amount;
            l_Susp_Amt_Due     := p_Tb_Amount_Accrued(l_Comp_Indx).Susp_Amt_Due;
            l_Susp_Amt_Lcy     := p_Tb_Amount_Accrued(l_Comp_Indx).Susp_Amt_Lcy;
            l_Susp_Amt_Settled := p_Tb_Amount_Accrued(l_Comp_Indx).Susp_Amt_Settled;
            -- Log#106 End.
         ELSE
            Dbg(' In not exists');
            l_Amount_Accured := 0;
            -- Log#106 Start.
            l_Susp_Amt_Due     := 0;
            l_Susp_Amt_Lcy     := 0;
            l_Susp_Amt_Settled := 0;
            -- Log#106 End.
         END IF;

         IF l_Amount_Accured > 0 THEN
            l_Comp_Due_Indx := l_Eff_Date_Indx;

            l_Tb_Account_Sch := p_Account_Rec.g_Tb_Components(l_Comp_Indx).g_Tb_Amt_Due;
            IF NOT l_Tb_Account_Sch.EXISTS(l_Comp_Due_Indx) THEN
               l_Comp_Due_Indx := l_Tb_Account_Sch.NEXT(l_Comp_Due_Indx);
            END IF;

            WHILE l_Comp_Due_Indx IS NOT NULL LOOP
               --past  schedules (paid/unpaid) will have all amount due = amount accrued.
               --START Prasanna/Mourougan FCC-CL EURO BANK SFR#AAL013-02. 19-DEC-2005
               IF Nvl(l_Tb_Account_Sch(l_Comp_Due_Indx).g_Amount_Due.Amount_Due, 0) >
                  Nvl(l_Tb_Account_Sch(l_Comp_Due_Indx)
                      --.g_amount_due.accrued_amount,0)
                      .g_Amount_Due.Accrued_Amount
                     ,-1)
               --END Prasanna/Mourougan FCC-CL EURO BANK SFR#AAL013-02. 19-DEC-2005
                THEN
                  l_Tb_Account_Sch(l_Comp_Due_Indx) .g_Amount_Due.Accrued_Amount := l_Amount_Accured;
                  -- Log#106 Start.
                  l_Tb_Account_Sch(l_Comp_Due_Indx) .g_Amount_Due.Susp_Amt_Due := l_Susp_Amt_Due;
                  l_Tb_Account_Sch(l_Comp_Due_Indx) .g_Amount_Due.Susp_Amt_Lcy := l_Susp_Amt_Lcy;
                  l_Tb_Account_Sch(l_Comp_Due_Indx) .g_Amount_Due.Susp_Amt_Settled := l_Susp_Amt_Settled;
                  -- Log#106 End.
                  EXIT;
               END IF;

               l_Comp_Due_Indx := l_Tb_Account_Sch.NEXT(l_Comp_Due_Indx);

            END LOOP;

            p_Account_Rec.g_Tb_Components(l_Comp_Indx) .g_Tb_Amt_Due := l_Tb_Account_Sch;

            l_Tb_Account_Sch.DELETE;

         END IF;

         l_Comp_Indx := p_Account_Rec.g_Tb_Components.NEXT(l_Comp_Indx);

      END LOOP;

      Dbg('End of the function fn_apply_amt_accrued ');
      RETURN TRUE;

   EXCEPTION
      WHEN OTHERS THEN
         Dbg('In when others of fn_apply_amt_accrued - ' || SQLERRM);

         l_Tb_Account_Sch.DELETE;

         Clpkss_Logger.Pr_Log_Exception('');

         p_Err_Code  := 'CL-SCH036;';
         p_Err_Param := 'fn_apply_amt_accrued~;';

         Ovpkss.Pr_Appendtbl(p_Err_Code, p_Err_Param);

         RETURN FALSE;

   END Fn_Apply_Amt_Accrued;

   FUNCTION Fn_Fill_Schedule_Gaps(p_Account_Rec IN OUT NOCOPY Clpkss_Object.Ty_Rec_Account
                                 ,
                                  --euro bank retro changes LOG#103 starts
                                  -- start month end periodicity LOG#102
                                  p_Due_Dates_On_Acc IN Cltbs_Account_Master.Due_Dates_On%TYPE
                                 ,
                                  -- end month end periodicity LOG#102
                                  --euro bank retro changes LOG#103 ends
                                  p_Err_Code  IN OUT Ertbs_Msgs.Err_Code%TYPE
                                 ,p_Err_Param IN OUT Ertbs_Msgs.Message%TYPE) RETURN BOOLEAN IS

      l_Branch_Code       Sttms_Branch.Branch_Code%TYPE;
      l_Tb_Pmnt_Schs      Clpkss_Object.Ty_Tb_Account_Comp_Sch;
      l_Prev_Sch_End_Date Cltbs_Account_Comp_Sch.Sch_End_Date%TYPE;
      l_Prev_Sch_Indx     VARCHAR2(100);
      l_Comp_Indx         Cltbs_Account_Components.Component_Name%TYPE;
      l_Sch_Indx          VARCHAR2(100);
      Skip_This_Sch EXCEPTION;
      l_Push_Down_Previous_Schedule BOOLEAN := FALSE;
      l_Pull_Up_Current_Schedule    BOOLEAN := FALSE;
      l_Add_New_Schedule            BOOLEAN := FALSE;
      l_Create_New_Schedule         BOOLEAN := FALSE;
      l_Frequency_Based             BOOLEAN := FALSE;
      l_Treat_As_Moratorium         BOOLEAN := FALSE;
      l_Mora_Exist                  BOOLEAN := FALSE;
      l_Last_Mora_Sch_Indx          VARCHAR2(100);
      l_New_Sch_Indx                VARCHAR2(100);
      l_New_Sch_Rec                 Cltbs_Account_Comp_Sch%ROWTYPE;
      l_No_Of_Days                  PLS_INTEGER := 0;
      l_Sch_St_Dt                   Cltbs_Account_Comp_Sch.Sch_Start_Date%TYPE;
      l_Calc_St_Dt                  Cltbs_Account_Comp_Sch.Sch_Start_Date%TYPE;
      l_Product                     Cltbs_Account_Master.Product_Code%TYPE;
      l_Value_Date                  Cltbs_Account_Master.Value_Date%TYPE;
      l_Maturity_Date               Cltbs_Account_Master.Maturity_Date%TYPE;
      --Sudharshan Mar 18,2005
      --l_ignore_holiday                        cltbs_account_master.ignore_holidays%TYPE;
      l_Ignore_Holiday Cltms_Product.Ignore_Holidays%TYPE;
      --Sudharshan Mar 18,2005
      l_Forward_Backward           Cltms_Product.Schedule_Movement%TYPE;
      l_Move_Across_Month          Cltms_Product.Move_Across_Month%TYPE;
      l_Calc_St_Dt_Holiday_Treated Cltbs_Account_Comp_Sch.Sch_Start_Date%TYPE;
      l_Mora_Frm                   Cltbs_Account_Comp_Sch.Formula_Name%TYPE;
      l_Schs_Have_Changed          BOOLEAN := FALSE;
      l_All_Sch_Flgs_Dflt          BOOLEAN := FALSE;
      ---->>Sudharshan
      l_Rec_Prod Cltm_Product%ROWTYPE;
      ---->>Sudharshan

      --Start Log#91 on 11-Feb-2006
      l_Is_Amortized   BOOLEAN := FALSE;
      l_Prod_Component Cltms_Product_Components%ROWTYPE;
      --End Log#91 on 11-Feb-2006

      PROCEDURE Pr_Set_Schedule_Flags IS

         l_Rec_Brn_Param Cltms_Branch_Parameters%ROWTYPE;
      BEGIN
         l_Rec_Brn_Param := Clpkss_Cache.Fn_Branch_Parameters(l_Branch_Code);
         Dbg('params are ');
         Dbg('schedule_structure ' || l_Rec_Brn_Param.Schedule_Structure);
         Dbg('treat_inter_gap_as ' || l_Rec_Brn_Param.Treat_Inter_Gap_As);
         Dbg('treat_init_gap_as ' || l_Rec_Brn_Param.Treat_Init_Gap_As);

         IF Nvl(l_Rec_Brn_Param.Schedule_Structure, 'N') = 'N' AND
            Nvl(l_Rec_Brn_Param.Treat_Inter_Gap_As, 'C') = 'C' AND
            Nvl(l_Rec_Brn_Param.Treat_Init_Gap_As, 'P') = 'P' THEN
            l_All_Sch_Flgs_Dflt := TRUE;
            RETURN;
         END IF;

         IF Nvl(l_Rec_Brn_Param.Schedule_Structure, 'N') = 'Y' THEN
            --frequency based
            l_Frequency_Based  := TRUE;
            l_Add_New_Schedule := TRUE;
            RETURN;
         END IF;

         IF Nvl(l_Rec_Brn_Param.Treat_Inter_Gap_As, 'C') = 'P' THEN
            --extend previous schedule
            l_Push_Down_Previous_Schedule := TRUE;
         ELSIF Nvl(l_Rec_Brn_Param.Treat_Inter_Gap_As, 'C') = 'N' THEN
            --add new schedule
            l_Add_New_Schedule := TRUE;
            Dbg('add_new_schedule set to true');
         ELSIF Nvl(l_Rec_Brn_Param.Treat_Inter_Gap_As, 'C') = 'C' THEN
            --advance current schedule
            l_Pull_Up_Current_Schedule := TRUE;
         END IF;
         IF Nvl(l_Rec_Brn_Param.Treat_Init_Gap_As, 'P') = 'M' THEN
            l_Treat_As_Moratorium := TRUE;
         END IF;
         RETURN;
      END;

      FUNCTION Fn_Get_Pmnt_Schs(p_Comp_Schs IN Clpkss_Object.Ty_Tb_Account_Comp_Sch
                               ,p_Pmnt_Schs OUT Clpkss_Object.Ty_Tb_Account_Comp_Sch)
         RETURN BOOLEAN IS
         l_Indx VARCHAR2(100);
      BEGIN
         --if component is main_int and Disounted ,True Discounted then
         --return null here;
         l_Indx := p_Comp_Schs.FIRST;
         WHILE l_Indx IS NOT NULL LOOP

            IF p_Comp_Schs(l_Indx).g_Account_Comp_Sch.Schedule_Type = 'P' THEN
               p_Pmnt_Schs(l_Indx) := p_Comp_Schs(l_Indx);
            END IF;
            l_Indx := p_Comp_Schs.NEXT(l_Indx);
         END LOOP;
         RETURN TRUE;
      END;

      FUNCTION Fn_Calc_Start_Date(p_Source_Date     IN Cltbs_Account_Comp_Sch.Sch_Start_Date%TYPE
                                 ,p_Frequency_Units IN Cltms_Product_Dflt_Schedules.Frequency_Unit%TYPE
                                 ,p_Frequency       IN Cltms_Product_Dflt_Schedules.Frequency%TYPE
                                 ,p_Start_Date      OUT Cltbs_Account_Comp_Sch.Sch_Start_Date%TYPE)
         RETURN BOOLEAN IS
         l_Sch_Start_Date Cltbs_Account_Comp_Sch.Sch_Start_Date%TYPE;
      BEGIN
         l_Sch_Start_Date := Fn_Get_Next_Schedule_Date(p_Source_Date
                                                      ,p_Frequency_Units
                                                      ,- (p_Frequency));
         IF l_Sch_Start_Date IS NULL THEN
            RETURN FALSE;
         END IF;
         IF NOT Fn_Get_Final_Schedule_Date(l_Sch_Start_Date
                                          ,l_Branch_Code
                                          ,l_Product
                                          ,l_Ignore_Holiday
                                          ,l_Forward_Backward
                                          ,l_Move_Across_Month
                                          ,l_Value_Date
                                          ,l_Maturity_Date
                                          ,
                                           --CL PHASE II IQA SUPP SFR #85 starts
                                           p_Frequency
                                          ,p_Frequency_Units
                                          ,
                                           --CL PHASE II IQA SUPP SFR #85 ends
                                           --euro bank retro changes LOG#103 starts
                                           -- start month end periodicity LOG#102
                                           p_Due_Dates_On_Acc
                                          ,
                                           -- end month end periodicity LOG#102
                                           --euro bank retro changes LOG#103 ends
                                           p_Start_Date
                                          ,p_Err_Code) THEN
            RETURN FALSE;
         END IF;
         p_Start_Date := l_Sch_Start_Date;
         Dbg('fn_fill_schedule_gaps --> returning start date as ' || p_Start_Date);
         RETURN TRUE;
      END;

      FUNCTION Fn_Reset_Prin_Amt RETURN BOOLEAN IS
         l_Tb_Prin_Schs Clpkss_Object.Ty_Tb_Account_Comp_Sch;

      BEGIN
         IF NOT
             Fn_Get_Pmnt_Schs(p_Account_Rec.g_Tb_Components(Pkg_Principal).g_Tb_Comp_Sch
                             ,
                              --Phase II NLS changes
                              l_Tb_Prin_Schs) THEN
            Dbg('failed to get pmnt schedules for principal');
            RETURN FALSE;
         END IF;
         l_Sch_Indx := l_Tb_Prin_Schs.FIRST;
         WHILE l_Sch_Indx IS NOT NULL LOOP
            p_Account_Rec.g_Tb_Components(Pkg_Principal) .g_Tb_Comp_Sch(l_Sch_Indx)
            --Phase II NLS changes
            .g_Account_Comp_Sch.Amount := NULL;

            l_Sch_Indx := l_Tb_Prin_Schs.NEXT(l_Sch_Indx);
         END LOOP;

         RETURN TRUE;
      END Fn_Reset_Prin_Amt;
   BEGIN
      Dbg('fn_fill_schedule_gaps -> came in');
      l_Branch_Code   := p_Account_Rec.Account_Det.Branch_Code;
      l_Product       := p_Account_Rec.Account_Det.Product_Code;
      l_Value_Date    := p_Account_Rec.Account_Det.Value_Date;
      l_Maturity_Date := Nvl(p_Account_Rec.Account_Det.Maturity_Date
                            ,Clpkss_Util.Pkg_Eternity);
      l_Branch_Code   := p_Account_Rec.Account_Det.Branch_Code;

      ------------------------------------------------------------------------------>
      --->>Sudharshan
      --l_ignore_holiday    := nvl(p_account_rec.account_det.ignore_holidays,'Y');
      --l_forward_backward  := nvl(p_account_rec.account_det.schedule_movement,'N');
      --l_move_across_month := nvl(p_account_rec.account_det.move_across_month,'Y');

      --l_rec_prod                  cltm_product%rowtype;
      l_Rec_Prod       := Clpks_Cache.Fn_Product(p_Account_Rec.Account_Det.Product_Code);
      l_Ignore_Holiday := Nvl(l_Rec_Prod.Ignore_Holidays, 'Y');
      Dbg('**IGNORE**');
      Dbg('l_ignore_holiday :5:' || l_Ignore_Holiday);
      l_Forward_Backward  := Nvl(l_Rec_Prod.Schedule_Movement, 'N');
      l_Move_Across_Month := Nvl(l_Rec_Prod.Move_Across_Month, 'Y');
      --->>Sudharshan
      ------------------------------------------------------------------------------>

      Pr_Set_Schedule_Flags;

      --If all flags are default then return true;

      IF l_All_Sch_Flgs_Dflt THEN
         Dbg('good..all flags are default..no need of processing');
         RETURN TRUE;
      END IF;

      l_Comp_Indx := p_Account_Rec.g_Tb_Components.FIRST;

      WHILE l_Comp_Indx IS NOT NULL LOOP
         Dbg('fn_fill_schedule_gaps -> processing for component ' || l_Comp_Indx);
         l_Tb_Pmnt_Schs.DELETE;
         l_Prev_Sch_End_Date  := NULL;
         l_Mora_Exist         := FALSE;
         l_Last_Mora_Sch_Indx := NULL;
         l_Sch_Indx           := NULL;
         l_Schs_Have_Changed  := FALSE;

         IF NOT Fn_Get_Pmnt_Schs(p_Account_Rec.g_Tb_Components(l_Comp_Indx).g_Tb_Comp_Sch
                                ,l_Tb_Pmnt_Schs) THEN
            l_Tb_Pmnt_Schs.DELETE;
            RETURN FALSE;
         END IF;

         l_Sch_Indx   := l_Tb_Pmnt_Schs.FIRST;
         l_Mora_Exist := FALSE;
         IF l_Sch_Indx IS NOT NULL THEN
            LOOP
               EXIT WHEN l_Tb_Pmnt_Schs(l_Sch_Indx) .g_Account_Comp_Sch.Schedule_Flag = 'N';
               l_Mora_Exist         := TRUE;
               l_Last_Mora_Sch_Indx := l_Sch_Indx;
               l_Sch_Indx           := l_Tb_Pmnt_Schs.NEXT(l_Sch_Indx);
            END LOOP;
         END IF;

         --This loop only for Non-Moratorium Repmnt. schedules

         -- Start Log#91 on 11-Feb-2006
         IF p_Account_Rec.g_Tb_Components(l_Comp_Indx).Comp_Det.Main_Component = 'Y' THEN
            l_Prod_Component := Clpks_Cache.Fn_Product_Components(p_Account_Rec.Account_Det.Product_Code
                                                                 ,l_Comp_Indx);
            IF l_Prod_Component.Formula_Type IN ('5', '6') OR Global.X9$ <> 'CLPBDC' THEN
               --log#109 added global.x9$ <> 'CLPBDC' condition    -- Amortized Rule 78 = 6 , Amortized Reducing = 5
               l_Is_Amortized := TRUE;
            END IF;
         END IF;
         -- End Log#91 on 11-Feb-2006

         WHILE l_Sch_Indx IS NOT NULL LOOP
            BEGIN
               Dbg('fn_fill_schedule_gaps ->' || l_Tb_Pmnt_Schs(l_Sch_Indx)
                   .g_Account_Comp_Sch.Sch_Start_Date || '~' ||
                   l_Tb_Pmnt_Schs(l_Sch_Indx).g_Account_Comp_Sch.First_Due_Date || '~' ||
                   l_Tb_Pmnt_Schs(l_Sch_Indx)
                   .g_Account_Comp_Sch.Sch_End_Date || '~' || l_Tb_Pmnt_Schs(l_Sch_Indx)
                   .g_Account_Comp_Sch.Unit || '~' || l_Tb_Pmnt_Schs(l_Sch_Indx)
                   .g_Account_Comp_Sch.Frequency);
               l_Sch_St_Dt := l_Tb_Pmnt_Schs(l_Sch_Indx)
                             .g_Account_Comp_Sch.Sch_Start_Date;

               IF l_Tb_Pmnt_Schs(l_Sch_Indx).g_Account_Comp_Sch.Unit = 'B' THEN
                  RAISE Skip_This_Sch;
               ELSE
                  IF NOT Fn_Calc_Start_Date(l_Tb_Pmnt_Schs(l_Sch_Indx)
                                            .g_Account_Comp_Sch.First_Due_Date
                                           , l_Tb_Pmnt_Schs(l_Sch_Indx)
                                            .g_Account_Comp_Sch.Unit
                                           , l_Tb_Pmnt_Schs(l_Sch_Indx)
                                            .g_Account_Comp_Sch.Frequency
                                           ,l_Calc_St_Dt) THEN
                     l_Tb_Pmnt_Schs.DELETE;
                     RETURN FALSE;
                  END IF;
               END IF;
               Dbg('l_sch_st_dt ' || l_Sch_St_Dt || '~l_calc_st_dt' || l_Calc_St_Dt);
               IF l_Calc_St_Dt = l_Sch_St_Dt THEN
                  Dbg('this schedule is proper');
                  RAISE Skip_This_Sch;

               ELSIF l_Calc_St_Dt < l_Sch_St_Dt THEN
                  IF l_Frequency_Based THEN
                     Dbg('fn_fill_schedule_gaps ->frequency based and schs overlap..returning false');
                     p_Err_Code  := 'CL-SCH046;';
                     p_Err_Param := l_Comp_Indx || '~;';

                     Ovpkss.Pr_Appendtbl(p_Err_Code, p_Err_Param);

                     l_Tb_Pmnt_Schs.DELETE;

                     RETURN FALSE;
                  END IF;

               ELSIF l_Calc_St_Dt > l_Sch_St_Dt AND l_Is_Amortized THEN
                  -- Log#91
                  Dbg('holes exist');
                  IF l_Prev_Sch_End_Date IS NULL THEN
                     Dbg('for first payment schedule');
                     IF l_Mora_Exist THEN
                        IF l_Treat_As_Moratorium THEN
                           p_Account_Rec.g_Tb_Components(l_Comp_Indx) .g_Tb_Comp_Sch(l_Last_Mora_Sch_Indx) .g_Account_Comp_Sch.Sch_End_Date := l_Calc_St_Dt;
                           -- Log#116 start
                           p_Account_Rec.g_Tb_Components(l_Comp_Indx) .g_Tb_Comp_Sch(l_Last_Mora_Sch_Indx) .g_Account_Comp_Sch.First_Due_Date := l_Calc_St_Dt;
                           p_Account_Rec.g_Tb_Components(l_Comp_Indx) .g_Tb_Comp_Sch(l_Last_Mora_Sch_Indx) .g_Account_Comp_Sch.Frequency := l_Calc_St_Dt -
                                                                                                                                            (p_Account_Rec.Account_Det.Value_Date);
                           -- Log#116 end
                           p_Account_Rec.g_Tb_Components(l_Comp_Indx) .g_Tb_Comp_Sch(l_Sch_Indx) .g_Account_Comp_Sch.Sch_Start_Date := l_Calc_St_Dt;
                        END IF;
                     ELSE
                        IF l_Treat_As_Moratorium THEN
                           Dbg('will create a sch defn for moratorium with dflt moratorium formula');
                           /*BEGIN
                                SELECT formula_name
                                INTO l_mora_frm
                                FROM cltms_product_comp_frm
                                WHERE product_code = l_product
                                AND nvl(dflt_moratorium_frm,'N')  = 'Y' ;
                           EXCEPTION
                                WHEN no_data_found THEN
                                     dbg('no data found for moratorium formula');
                                     p_err_code := 'CL-SCH047;';
                                     ovpkss.pr_appendTbl(p_err_code,'');

                                     l_tb_pmnt_schs.DELETE;
                                     RETURN FALSE;
                           END;*/
                           IF NOT Clpkss_Cache.Fn_Get_Mora_Frm(l_Product
                                                              ,l_Comp_Indx
                                                              ,l_Mora_Frm
                                                              ,p_Err_Code
                                                              ,p_Err_Param) THEN
                              RETURN FALSE;
                           END IF;
                           --update start date of current schedule definition.
                           p_Account_Rec.g_Tb_Components(l_Comp_Indx) .g_Tb_Comp_Sch(l_Sch_Indx) .g_Account_Comp_Sch.Sch_Start_Date := l_Calc_St_Dt;
                           --create a moratorium schedule with this default formula.
                           l_No_Of_Days   := l_Calc_St_Dt - l_Value_Date;
                           l_New_Sch_Indx := 'P' ||
                                             Clpkss_Util.Fn_Hash_Date(l_Calc_St_Dt, NULL);
                           l_New_Sch_Rec  := p_Account_Rec.g_Tb_Components(l_Comp_Indx)
                                            .g_Tb_Comp_Sch(l_Sch_Indx).g_Account_Comp_Sch;

                           l_New_Sch_Rec.Schedule_Flag   := 'M';
                           l_New_Sch_Rec.Sch_Start_Date  := l_Value_Date;
                           l_New_Sch_Rec.First_Due_Date  := l_Calc_St_Dt;
                           l_New_Sch_Rec.Sch_End_Date    := l_Calc_St_Dt;
                           l_New_Sch_Rec.Frequency       := l_No_Of_Days;
                           l_New_Sch_Rec.Unit            := 'D';
                           l_New_Sch_Rec.No_Of_Schedules := 1;
                           l_New_Sch_Rec.Formula_Name    := l_Mora_Frm;

                           p_Account_Rec.g_Tb_Components(l_Comp_Indx) .g_Tb_Comp_Sch(l_New_Sch_Indx) .g_Account_Comp_Sch := l_New_Sch_Rec;
                           p_Account_Rec.g_Tb_Components(l_Comp_Indx) .g_Tb_Comp_Sch(l_New_Sch_Indx) .g_Record_Rowid := NULL;
                           p_Account_Rec.g_Tb_Components(l_Comp_Indx) .g_Tb_Comp_Sch(l_New_Sch_Indx) .g_Action := 'I';
                        END IF;
                     END IF;
                  ELSE
                     IF l_Frequency_Based THEN
                        l_Create_New_Schedule := TRUE;
                     ELSE
                        IF l_Push_Down_Previous_Schedule THEN
                           --l_tb_pmnt_schs(l_sch_indx).g_account_comp_sch
                           Dbg('going to push_down_previous_schedule ');
                           p_Account_Rec.g_Tb_Components(l_Comp_Indx) .g_Tb_Comp_Sch(l_Prev_Sch_Indx) .g_Account_Comp_Sch.Sch_End_Date := l_Calc_St_Dt;

                           p_Account_Rec.g_Tb_Components(l_Comp_Indx) .g_Tb_Comp_Sch(l_Sch_Indx) .g_Account_Comp_Sch.Sch_Start_Date := l_Calc_St_Dt;

                           l_Schs_Have_Changed := TRUE;

                        ELSIF l_Pull_Up_Current_Schedule THEN
                           --this is what it comes with
                           Dbg('going to pull_up_current_schedule .its default');
                           NULL;
                        ELSIF l_Add_New_Schedule THEN
                           Dbg('going to  create new schedule');
                           l_Create_New_Schedule := TRUE;
                        END IF;
                     END IF;
                     IF l_Create_New_Schedule THEN

                        p_Account_Rec.g_Tb_Components(l_Comp_Indx) .g_Tb_Comp_Sch(l_Sch_Indx) .g_Account_Comp_Sch.Sch_Start_Date := l_Calc_St_Dt;

                        --create a new schedule
                        l_New_Sch_Indx := 'P' ||
                                          Clpkss_Util.Fn_Hash_Date(l_Calc_St_Dt, NULL);
                        l_New_Sch_Rec  := p_Account_Rec.g_Tb_Components(l_Comp_Indx)
                                         .g_Tb_Comp_Sch(l_Prev_Sch_Indx)
                                         .g_Account_Comp_Sch;

                        l_No_Of_Days := l_Calc_St_Dt - l_New_Sch_Rec.Sch_End_Date;

                        l_New_Sch_Rec.Sch_Start_Date  := l_New_Sch_Rec.Sch_End_Date;
                        l_New_Sch_Rec.First_Due_Date  := l_Calc_St_Dt;
                        l_New_Sch_Rec.Sch_End_Date    := l_Calc_St_Dt;
                        l_New_Sch_Rec.Frequency       := l_No_Of_Days;
                        l_New_Sch_Rec.Unit            := 'D';
                        l_New_Sch_Rec.No_Of_Schedules := 1;

                        p_Account_Rec.g_Tb_Components(l_Comp_Indx) .g_Tb_Comp_Sch(l_New_Sch_Indx) .g_Account_Comp_Sch := l_New_Sch_Rec;
                        p_Account_Rec.g_Tb_Components(l_Comp_Indx) .g_Tb_Comp_Sch(l_New_Sch_Indx) .g_Record_Rowid := NULL;
                        p_Account_Rec.g_Tb_Components(l_Comp_Indx) .g_Tb_Comp_Sch(l_New_Sch_Indx) .g_Action := 'I';

                        l_Schs_Have_Changed := TRUE;

                     END IF;

                  END IF;
               END IF;
            EXCEPTION
               WHEN Skip_This_Sch THEN
                  NULL;
            END;

            l_Prev_Sch_End_Date := l_Tb_Pmnt_Schs(l_Sch_Indx)
                                  .g_Account_Comp_Sch.Sch_End_Date;
            l_Prev_Sch_Indx     := l_Sch_Indx;

            l_Sch_Indx := l_Tb_Pmnt_Schs.NEXT(l_Sch_Indx);

         END LOOP;

         l_Tb_Pmnt_Schs.DELETE;

         IF l_Comp_Indx = Pkg_Principal AND l_Schs_Have_Changed
         --Phase II NLS changes
          THEN
            Dbg('principal amount have to be reset as null');
            IF NOT Fn_Reset_Prin_Amt THEN
               RETURN FALSE;
            END IF;
         END IF;

         l_Comp_Indx := p_Account_Rec.g_Tb_Components.NEXT(l_Comp_Indx);

      END LOOP;
      Dbg('fn_fill_schedule_gaps >>> returning true');
      RETURN TRUE;
   EXCEPTION
      WHEN OTHERS THEN
         Dbg('in when others of fn_fill_schedule_gaps with ' || SQLERRM);
         l_Tb_Pmnt_Schs.DELETE;

         Clpkss_Logger.Pr_Log_Exception('');

         p_Err_Code  := 'CL-SCH036;';
         p_Err_Param := 'fn_fill_schedule_gaps~;';

         Ovpkss.Pr_Appendtbl(p_Err_Code, p_Err_Param);

         RETURN FALSE;
   END Fn_Fill_Schedule_Gaps;
   --Ravi changes against log # 36 starts
   --logic changed for this function.Now fn_compute_schedule_dates will be called which will take care of
   --all holiday treatments.Commenting the original function.
   FUNCTION Fn_Gen_Get_Maturity_Date(p_Prod_Code          IN Cltms_Product.Product_Code%TYPE
                                    ,p_Branch_Code        IN Cltbs_Account_Master.Branch_Code%TYPE
                                    ,p_Value_Date         IN Cltbs_Account_Master.Value_Date%TYPE
                                    ,p_No_Of_Installments IN Cltbs_Account_Master.No_Of_Installments%TYPE
                                    ,p_Frequency          IN Cltbs_Account_Master.Frequency%TYPE
                                    ,p_Frequency_Unit     IN Cltbs_Account_Master.Frequency_Unit%TYPE
                                    ,p_First_Ins_Date     IN Cltbs_Account_Master.First_Ins_Date%TYPE
                                    ,
                                     --euro bank retro changes LOG#103 starts
                                     -- start month end periodicity LOG#102
                                     p_Due_Dates_On_Acc IN Cltbs_Account_Master.Due_Dates_On%TYPE
                                    ,
                                     -- end month end periodicity LOG#102
                                     --euro bank retro changes LOG#103 ends
                                     p_Maturity_Date OUT Cltbs_Account_Master.Maturity_Date%TYPE
                                    ,p_Err_Code      IN OUT VARCHAR2
                                    ,p_Err_Param     IN OUT VARCHAR2) RETURN BOOLEAN IS
      l_Prod_Rec Cltms_Product%ROWTYPE;
      --l_maturity_date         DATE;
      --l_add_months            NUMBER;
      --l_pastlimit             BOOLEAN;
      --l_no_of_installments    cltbs_account_master.no_of_installments%TYPE;
      l_Ty_Schedule_Date Clpks_Schedules.Ty_Schedule_Date;
   BEGIN
      ----FCCCL 2.2 Retros Against SFR#56 starts

      ---g_tb_acc_hol_perds.delete; --Log#55 RaghuR 24-Jun-2005

      ----FCCCL 2.2 Retros Against SFR#56 ends

      l_Prod_Rec := Clpks_Cache.Fn_Product(p_Prod_Code);

      Debug.Pr_Debug('CL', 'No of installments - ' || p_No_Of_Installments);
      Debug.Pr_Debug('CL', 'Frequency - ' || p_Frequency);
      Debug.Pr_Debug('CL', 'Frequency Unit - ' || p_Frequency_Unit);
      Debug.Pr_Debug('CL', 'First Installment Date - ' || p_First_Ins_Date);

      IF p_Frequency_Unit = 'B' THEN
         p_Maturity_Date := p_First_Ins_Date;
         -- RETURN TRUE; --LOG#90 on 11-Feb-2006
         RETURN TRUE; --spotfix@22-02-2006 CLITR1  SFR#3
      END IF;

      IF NOT Clpks_Object.Fn_Pop_Acc_Hol_Perds(p_Prod_Code, p_Err_Code, p_Err_Param) THEN
         RETURN FALSE;
      END IF;
      ----FCCCL 2.2 Retros Against SFR#56 starts
      g_Tb_Acc_Hol_Perds.DELETE;
      ----FCCCL 2.2 Retros Against SFR#56 ends
      Clpkss_Schedules.g_Tb_Acc_Hol_Perds := Clpkss_Object.g_Account.g_Hol_Perds;

      Clpkss_Object.g_Account.g_Hol_Perds.DELETE;

      IF NOT Fn_Compute_Schedule_Dates(p_First_Ins_Date
                                      ,p_Value_Date
                                      ,Clpkss_Util.Pkg_Eternity
                                      ,p_Branch_Code
                                      ,p_Prod_Code
                                      ,p_Frequency
                                      ,p_Frequency_Unit
                                      ,p_No_Of_Installments
                                      ,l_Prod_Rec.Ignore_Holidays
                                      ,l_Prod_Rec.Schedule_Movement
                                      ,l_Prod_Rec.Move_Across_Month
                                      ,l_Prod_Rec.Cascade_Schedules
                                      ,NULL
                                      , --due_dates_on,
                                       --euro bank retro changes LOG#103 starts
                                       -- start month end periodicity LOG#102
                                       p_Due_Dates_On_Acc
                                      ,
                                       -- end month end periodicity LOG#102
                                       --euro bank retro changes LOG#103 ends
                                       l_Ty_Schedule_Date
                                      ,p_Err_Code
                                      ,
                                       -- START Log#116
                                       'P') -- Check this
      -- END Log#116

       THEN
         RETURN FALSE;
      END IF;

      IF l_Ty_Schedule_Date.COUNT = 0 THEN
         RETURN FALSE;
      ELSE
         p_Maturity_Date := l_Ty_Schedule_Date(l_Ty_Schedule_Date.LAST);
      END IF;
      Dbg('maturity date calculated as ' || p_Maturity_Date);

	  ---FCUBS11.1 ITR1 SFR#1854 Start
        IF NVL(l_Prod_Rec.LEASE_TYPE,'X') = 'F'
        AND NVL(l_Prod_Rec.lease_payment_mode,'X')   = 'A'
        AND NVL(l_Prod_Rec.MODULE_CODE,'CL') = 'CL' THEN
            Dbg( 'Frequency Unit - ' || p_Frequency_Unit);
            Dbg( 'l_Ty_Schedule_Date(l_Ty_Schedule_Date.LAST)'||l_Ty_Schedule_Date(l_Ty_Schedule_Date.LAST));
         IF p_Frequency_Unit = 'D' THEN
            p_Maturity_Date := l_Ty_Schedule_Date(l_Ty_Schedule_Date.LAST) + 1;
         ELSIF p_Frequency_Unit = 'M' THEN
            p_Maturity_Date := Add_Months(l_Ty_Schedule_Date(l_Ty_Schedule_Date.LAST),1);
         ELSIF p_Frequency_Unit = 'Y' THEN
            p_Maturity_Date := Add_Months(l_Ty_Schedule_Date(l_Ty_Schedule_Date.LAST), 12);
         END IF;
        Dbg('maturity date calculated as for lease_payment_mode' || p_Maturity_Date);
        END IF;
	  ---FCUBS11.1 ITR1 SFR#1854 End

      l_Ty_Schedule_Date.DELETE;

      RETURN TRUE;

   EXCEPTION
      WHEN OTHERS THEN
         l_Ty_Schedule_Date.DELETE;
         Clpkss_Logger.Pr_Log_Exception('');

         p_Err_Code  := 'CL-SCH036;';
         p_Err_Param := 'fn_gen_get_maturity_date~;';

         Ovpkss.Pr_Appendtbl(p_Err_Code, p_Err_Param);
         RETURN FALSE;
   END Fn_Gen_Get_Maturity_Date;
   --Ravi changes against log # 36 ends
   /*-- Ramesh Changes Starts 12-Feb-2005 Phase 2 Enhancement Maturity Date Calculation\
   FUNCTION    fn_gen_get_maturity_date (
                                    p_prod_code         IN      cltms_product.product_code%TYPE,
                                    p_branch_code       IN      cltbs_account_master.branch_code%TYPE,
                                    p_no_of_installments    IN      cltbs_account_master.no_of_installments%TYPE,
                                    p_frequency         IN      cltbs_account_master.frequency%TYPE,
                                    p_frequency_unit        IN      cltbs_account_master.frequency_unit%TYPE,
                                    p_first_ins_date        IN      cltbs_account_master.first_ins_date%TYPE,
                                    p_maturity_date     OUT     cltbs_account_master.maturity_date%TYPE,
                                    p_err_code          IN OUT  VARCHAR2,
                                    p_err_param         IN OUT  VARCHAR2
                                    )
   RETURN BOOLEAN
   IS
   l_prod_rec      cltms_product%ROWTYPE;
   l_maturity_date DATE;
   l_add_months    NUMBER;
   l_pastlimit     BOOLEAN;
   l_no_of_installments    cltbs_account_master.no_of_installments%TYPE;
   BEGIN
       l_prod_rec  :=  clpks_cache.fn_product(p_prod_code);

       debug.pr_debug('CL','No of installments - '||p_no_of_installments);
       debug.pr_debug('CL','Frequency - '||p_frequency);
       debug.pr_debug('CL','Frequency Unit - '||p_frequency_unit);
       debug.pr_debug('CL','First Installment Date - '||p_first_ins_date);

       IF NOT clpks_object.fn_pop_acc_hol_perds
               (
               p_prod_code,
               p_err_code,
               p_err_param
               )
       THEN
           RETURN FALSE;
       END IF;

       clpkss_schedules.g_tb_acc_hol_perds :=  clpkss_object.g_account.g_hol_perds;

       clpkss_object.g_account.g_hol_perds.delete;

       l_no_of_installments    :=  p_no_of_installments - 1;

       IF l_prod_rec.cascade_schedules =   'N'
       THEN

           IF p_frequency_unit =   'B'
           THEN
               l_maturity_date :=  p_first_ins_date;
           ELSIF   p_frequency_unit    =   'D'
           THEN
               l_maturity_date :=  p_first_ins_date + (l_no_of_installments*p_frequency);
           ELSIF   p_frequency_unit    =   'W'
           THEN
               l_maturity_date :=  p_first_ins_date + (l_no_of_installments*p_frequency*7);
           ELSE
               IF p_frequency_unit =   'M'
               THEN
                   l_add_months    :=  1*l_no_of_installments*p_frequency;
               ELSIF p_frequency_unit  =   'Q'
               THEN
                   l_add_months    :=  3*l_no_of_installments*p_frequency;
               ELSIF p_frequency_unit  =   'H'
               THEN
                   l_add_months    :=  6*l_no_of_installments*p_frequency;
               ELSIF p_frequency_unit  =   'Y'
               THEN
                   l_add_months    :=  12*l_no_of_installments*p_frequency;
               END IF;

               l_maturity_date :=  fn_add_months(p_first_ins_date,l_add_months);
           END IF;

       ELSE
           l_maturity_date :=  p_first_ins_date;

           IF p_frequency_unit <>  'B'
           THEN
               IF l_no_of_installments <> 0
               THEN
                   FOR rec in 1..l_no_of_installments
                   LOOP
                       IF  p_frequency_unit    =   'D'
                       THEN
                           l_maturity_date :=  l_maturity_date + p_frequency;
                       ELSIF   p_frequency_unit    =   'W'
                       THEN
                           l_maturity_date :=  l_maturity_date + (p_frequency*7);
                       ELSE
                           IF p_frequency_unit =   'M'
                           THEN
                               l_add_months    :=  1*p_frequency;
                           ELSIF p_frequency_unit  =   'Q'
                           THEN
                               l_add_months    :=  3*p_frequency;
                           ELSIF p_frequency_unit  =   'H'
                           THEN
                               l_add_months    :=  6*p_frequency;
                           ELSIF p_frequency_unit  =   'Y'
                           THEN
                               l_add_months    :=  12*p_frequency;
                           END IF;

                           l_maturity_date :=  fn_add_months(l_maturity_date,l_add_months);
                       END IF;

                       IF l_prod_rec.ignore_holidays = 'N'
                       THEN
                           l_maturity_date := clpkss_util.fn_getworkingday
                                   (
                                   p_branch_code,
                                   l_maturity_date,
                                   l_prod_rec.product_code,
                                   l_prod_rec.schedule_movement,
                                   p_first_ins_date,
                                   null,
                                   l_pastlimit
                                   );

                           IF l_pastlimit
                           THEN
                               RETURN FALSE;
                           END IF;
                       END IF;

                       debug.pr_debug('CL','Maturity date - '||l_maturity_date);
                   END LOOP;
               END IF;
           END IF;

       END IF;

       IF l_prod_rec.ignore_holidays = 'N'
       THEN
           l_maturity_date := clpkss_util.fn_getworkingday
                               (
                               p_branch_code,
                               l_maturity_date,
                               l_prod_rec.product_code,
                               l_prod_rec.schedule_movement,
                               p_first_ins_date,
                               null,
                               l_pastlimit
                               );

           IF l_pastlimit
           THEN
               RETURN FALSE;
           END IF;

       END IF;

       p_maturity_date :=  l_maturity_date;

       RETURN TRUE;

   EXCEPTION
       WHEN OTHERS THEN
           RETURN FALSE;
   END fn_gen_get_maturity_date;
   */
   FUNCTION Fn_Get_Maturity_Date(p_Prod_Code   IN Cltms_Product.Product_Code%TYPE
                                ,p_Branch_Code IN Cltbs_Account_Master.Branch_Code%TYPE
                                ,
                                 --ravi changes start against log #6 starts
                                 p_Value_Date IN Cltbs_Account_Master.Value_Date%TYPE
                                ,
                                 --ravi changes start against log #6 ends
                                 p_No_Of_Installments IN Cltbs_Account_Master.No_Of_Installments%TYPE
                                ,p_Frequency          IN Cltbs_Account_Master.Frequency%TYPE
                                ,p_Frequency_Unit     IN Cltbs_Account_Master.Frequency_Unit%TYPE
                                ,p_First_Ins_Date     IN Cltbs_Account_Master.First_Ins_Date%TYPE
                                ,
                                 --euro bank retro changes LOG#103 starts
                                 -- start month end periodicity changes LOG#102
                                 p_Due_Dates_On_Acc IN Cltbs_Account_Master.Due_Dates_On%TYPE
                                ,
                                 -- end month end periodicity changes LOG#102
                                 --euro bank retro changes LOG#103 ends
                                 --Sudharshan : Mar 18,2005
                                 --p_maturity_date     OUT     cltbs_account_master.maturity_date%TYPE,
                                 p_Maturity_Date IN OUT Cltbs_Account_Master.Maturity_Date%TYPE
                                ,
                                 --Sudharshan : Mar 18,2005
                                 p_Err_Code  IN OUT VARCHAR2
                                ,p_Err_Param IN OUT VARCHAR2) RETURN BOOLEAN IS
   BEGIN
      IF NOT Clpkss_Stream_Schedules.Fn_Pre_Get_Maturity_Date(p_Prod_Code
                                                             ,p_Branch_Code
                                                             ,p_Value_Date
                                                             ,p_No_Of_Installments
                                                             ,p_Frequency
                                                             ,p_Frequency_Unit
                                                             ,p_First_Ins_Date
                                                             ,
                                                              --euro bank retro changes LOG#103 starts
                                                              --LOG#102 EUROBANK Billing Periodicity changes start
                                                              p_Due_Dates_On_Acc
                                                             ,
                                                              --LOG#102 EUROBANK Billing Periodicity changes ends
                                                              --euro bank retro changes LOG#103 ends
                                                              p_Maturity_Date
                                                             ,p_Err_Code
                                                             ,p_Err_Param) THEN
         RETURN FALSE;
      END IF;

      IF Clpkss_Stream_Schedules.Fn_Ovrdn_Get_Maturity_Date THEN
         IF NOT Clpkss_Stream_Schedules.Fn_Get_Maturity_Date(p_Prod_Code
                                                            ,p_Branch_Code
                                                            ,p_Value_Date
                                                            ,p_No_Of_Installments
                                                            ,p_Frequency
                                                            ,p_Frequency_Unit
                                                            ,p_First_Ins_Date
                                                            ,
                                                             --euro bank retro changes LOG#103 starts
                                                             --LOG#102 EUROBANK Billing Periodicity changes start
                                                             p_Due_Dates_On_Acc
                                                            ,
                                                             --LOG#102 EUROBANK Billing Periodicity changes ends
                                                             --euro bank retro changes LOG#103 ends
                                                             p_Maturity_Date
                                                            ,p_Err_Code
                                                            ,p_Err_Param) THEN
            RETURN FALSE;
         END IF;

      ELSE
         IF NOT Fn_Gen_Get_Maturity_Date(p_Prod_Code
                                        ,p_Branch_Code
                                        ,p_Value_Date
                                        ,p_No_Of_Installments
                                        ,p_Frequency
                                        ,p_Frequency_Unit
                                        ,p_First_Ins_Date
                                        ,
                                         --euro bank retro changes LOG#103 starts
                                         --LOG#102 EUROBANK Billing Periodicity changes start
                                         p_Due_Dates_On_Acc
                                        ,
                                         --LOG#102 EUROBANK Billing Periodicity changes ends
                                         --euro bank retro changes LOG#103 ends
                                         p_Maturity_Date
                                        ,p_Err_Code
                                        ,p_Err_Param) THEN
            RETURN FALSE;
         END IF;

      END IF;

      IF NOT Clpkss_Stream_Schedules.Fn_Post_Get_Maturity_Date(p_Prod_Code
                                                              ,p_Branch_Code
                                                              ,p_Value_Date
                                                              ,p_No_Of_Installments
                                                              ,p_Frequency
                                                              ,p_Frequency_Unit
                                                              ,p_First_Ins_Date
                                                              ,
                                                               --euro bank retro changes LOG#103 starts
                                                               --LOG#102 EUROBANK Billing Periodicity changes start
                                                               p_Due_Dates_On_Acc
                                                              ,
                                                               --LOG#102 EUROBANK Billing Periodicity changes ends
                                                               --euro bank retro changes LOG#103 ends
                                                               p_Maturity_Date
                                                              ,p_Err_Code
                                                              ,p_Err_Param) THEN
         RETURN FALSE;
      END IF;

      RETURN TRUE;

   EXCEPTION
      WHEN OTHERS THEN
         RETURN FALSE;
   END Fn_Get_Maturity_Date;

   -- Ramesh Changes Ends 12-Feb-2005 Phase 2 Enhancement Maturity Date Calculation

   FUNCTION Fn_Gen_Create_a_Mora_Sch(p_Product         IN Cltms_Product_Dflt_Schedules.Product_Code%TYPE
                                    ,p_Component       IN Cltms_Product_Dflt_Schedules.Component_Name%TYPE
                                    ,p_First_Pmnt_Date IN Cltbs_Account_Comp_Sch.First_Due_Date%TYPE
                                    ,p_Value_Date      IN Cltbs_Account_Master.Value_Date%TYPE
                                    ,p_Pmnt_Freq       IN Cltms_Product_Dflt_Schedules.Frequency%TYPE
                                    ,p_Pmnt_Freq_Units IN Cltms_Product_Dflt_Schedules.Frequency_Unit%TYPE
                                    ,p_Capitalize      IN BOOLEAN
                                    ,p_Mora_Sch_Rec    IN OUT Cltms_Product_Dflt_Schedules%ROWTYPE
                                    ,p_Err_Code        IN OUT Ertbs_Msgs.Err_Code%TYPE
                                    ,p_Err_Param       IN OUT Ertbs_Msgs.Message%TYPE)
      RETURN BOOLEAN IS
      l_Mora_Frm      Cltms_Product_Comp_Frm.Formula_Name%TYPE;
      l_Mora_Due_Date Cltbs_Account_Comp_Sch.First_Due_Date%TYPE;
      --Start Log#91 on 11-feb-2006
      l_Is_Amortized   BOOLEAN := FALSE;
      l_Prod_Component Cltms_Product_Components%ROWTYPE;
      -- End  Log#91 on 11-feb-2006

      --FCCCL 22 itr1 retros sfr#28 starts
      --TYPE TY_TB_DFLT_SCHS      IS TABLE OF CLTMS_PRODUCT_DFLT_SCHEDULES%ROWTYPE INDEX BY PLS_INTEGER;
      l_Tb_Dflt_Schs Ty_Tb_Comp_Dflt_Schs;
      l_Due_Dates_On Cltms_Product_Dflt_Schedules.Due_Dates_On%TYPE;
      l_Start_Ref    Cltms_Product_Dflt_Schedules.Start_Reference%TYPE;
      l_Start_Date   DATE;
      l_Indx         VARCHAR2(100);
      --FCCCL 22 itr1 retros sfr#28 ends
      --Log#132 Start
      l_Capitalize BOOLEAN := FALSE;
      --Log#132 End
   BEGIN
      Dbg('hello fn_create_a_mora_sch');
      /*
              IF  p_component <> PKG_PRINCIPAL THEN
                  IF NOT clpkss_cache.fn_get_mora_frm(p_product,
                                                      p_component,
                                                      l_mora_frm,
                                                      p_err_code,
                                                      p_err_param)
                  THEN
                      RETURN FALSE;
                  END IF;
              END IF;
      */

      IF p_Product IS NULL OR p_Component IS NULL OR p_First_Pmnt_Date IS NULL OR
         p_Value_Date IS NULL OR p_Pmnt_Freq IS NULL OR p_Pmnt_Freq_Units IS NULL THEN
         Dbg('Please pass all the IN params');
         RETURN FALSE;
      END IF;
      IF p_Pmnt_Freq_Units = 'B' THEN
         Dbg('frequency Unit Bullet would not be processed..return true..');
         RETURN TRUE;
      ELSE
         l_Mora_Due_Date := Fn_Get_Next_Schedule_Date(p_First_Pmnt_Date
                                                     ,p_Pmnt_Freq_Units
                                                     ,- (p_Pmnt_Freq));
         IF l_Mora_Due_Date IS NULL THEN
            Dbg('l_mora_due_date null ''');
            RETURN FALSE;
         END IF;
      END IF;

      Dbg('l_mora_due_date is ' || l_Mora_Due_Date);

      IF l_Mora_Due_Date <= p_Value_Date THEN
         Dbg('..no mora sh will be created');
         -- RETURN FALSE;--For obvious reasons --Sudharshan Mar,15 2005
         RETURN TRUE;
      END IF;

      --Start Log#91 on 11-Feb-2006
      l_Prod_Component := Clpks_Cache.Fn_Product_Components(p_Product, p_Component);
      IF l_Prod_Component.Main_Component = 'Y' THEN
         l_Prod_Component := Clpks_Cache.Fn_Product_Components(p_Product, p_Component);
         IF l_Prod_Component.Formula_Type NOT IN ('5', '6') AND Global.X9$ = 'CLPBDC' THEN
            --log#109 added global.x9$ = 'CLPBDC' condition   -- Amortized Rule 78 = 6 , Amortized Reducing = 5
            Dbg(' is not amortized formula,hence not need moratorium sch ...');
            RETURN TRUE;
         END IF;
      END IF;
      --End Log#91 on 11-Feb-2006

      --------------->
      --Sudharshan Changes Starts: Mar 17,2005
      IF p_Component <> Pkg_Principal THEN
         IF NOT Clpkss_Cache.Fn_Get_Mora_Frm(p_Product
                                            ,p_Component
                                            ,l_Mora_Frm
                                            ,p_Err_Code
                                            ,p_Err_Param) THEN
            RETURN FALSE;
         END IF;
         --END IF;  --  Log#68.
         Dbg('got mora frm as ' || l_Mora_Frm);
         --Sudharshan Changes Ends: Mar 17,2005

         ----FCCCL 22 itr1 retros sfr#28 starts
         ----------------->
         l_Tb_Dflt_Schs := Clpkss_Cache.Fn_Get_Dflt_Schs(p_Product, Pkg_Main_Int);

         IF l_Tb_Dflt_Schs.COUNT > 0 THEN
            l_Indx := l_Tb_Dflt_Schs.FIRST;
            WHILE l_Indx IS NOT NULL LOOP
               --Log#132 Start
               IF l_Tb_Dflt_Schs(l_Indx)
               .Formula_Name = l_Mora_Frm AND
                  Nvl(l_Tb_Dflt_Schs(l_Indx).Capitalized, '#') = 'Y' THEN
                  l_Capitalize := TRUE;
               END IF;
               --Log#132 End
               IF l_Tb_Dflt_Schs(l_Indx)
               .Formula_Name = l_Mora_Frm AND l_Tb_Dflt_Schs(l_Indx)
               .Due_Dates_On IS NOT NULL THEN
                  l_Due_Dates_On := l_Tb_Dflt_Schs(l_Indx).Due_Dates_On;
                  l_Start_Ref    := l_Tb_Dflt_Schs(l_Indx).Start_Reference;
                  EXIT;
               ELSE
                  l_Due_Dates_On := l_Tb_Dflt_Schs(l_Indx).Due_Dates_On;
                  l_Start_Ref    := l_Tb_Dflt_Schs(l_Indx).Start_Reference;

                  IF l_Due_Dates_On IS NOT NULL THEN
                     EXIT;
                  END IF;

               END IF;
               l_Indx := l_Tb_Dflt_Schs.NEXT(l_Indx);
            END LOOP;
         END IF;

         Dbg('Mora l_due_dates_on' || Nvl(l_Due_Dates_On, '56'));
         Dbg('Mora l_start_ref' || Nvl(l_Start_Ref, 'X'));

         l_Tb_Dflt_Schs.DELETE;

         IF l_Due_Dates_On IS NOT NULL THEN
            IF NOT Fn_Apply_Calender_Prefs(l_Mora_Due_Date
                                          ,l_Due_Dates_On
                                          ,l_Start_Ref
                                          ,p_Pmnt_Freq_Units
                                          ,NULL
                                          ,NULL
                                          ,NULL
                                          ,l_Start_Date) THEN
               RETURN FALSE;
            END IF;
            Dbg('the more l_start_date' || Nvl(l_Start_Date, p_Value_Date));
         ELSE
            l_Start_Date := l_Mora_Due_Date;
         END IF;
         ----FCCCL 22 itr1 retros sfr#28 ends
         ------------------->>>>>>>>>>>>>..

         p_Mora_Sch_Rec.Product_Code    := p_Product;
         p_Mora_Sch_Rec.Component_Name  := p_Component;
         p_Mora_Sch_Rec.Schedule_Type   := 'P';
         p_Mora_Sch_Rec.Start_Reference := 'V';
         ----FCCCL 22 itr1 retros sfr#28 starts
         --p_mora_sch_rec.FREQUENCY       := (l_mora_due_date - p_value_Date);
         p_Mora_Sch_Rec.Frequency := (l_Start_Date - p_Value_Date);
         ----FCCCL 22 itr1 retros sfr#28 ends
         p_Mora_Sch_Rec.Frequency_Unit  := 'D';
         p_Mora_Sch_Rec.Start_Day       := NULL;
         p_Mora_Sch_Rec.Start_Date      := NULL;
         p_Mora_Sch_Rec.Start_Month     := NULL;
         p_Mora_Sch_Rec.No_Of_Schedules := 1;
         p_Mora_Sch_Rec.Formula_Name    := l_Mora_Frm;
         p_Mora_Sch_Rec.Seq_No          := 1;
         p_Mora_Sch_Rec.Schedule_Flag   := 'M';
         --Log#132 Start
         --IF p_capitalize THEN
         IF l_Capitalize THEN
            --Log#132 End
            p_Mora_Sch_Rec.Capitalized := 'Y';
         ELSE
            p_Mora_Sch_Rec.Capitalized := 'N';
         END IF;
      END IF; --  Log#68.
      RETURN TRUE;
   EXCEPTION
      WHEN OTHERS THEN
         Dbg('I WO of fn_create_a_mora_sch ' || SQLERRM);
         RETURN FALSE;
   END Fn_Gen_Create_a_Mora_Sch;
   FUNCTION Fn_Create_a_Mora_Sch(p_Product         IN Cltms_Product_Dflt_Schedules.Product_Code%TYPE
                                ,p_Component       IN Cltms_Product_Dflt_Schedules.Component_Name%TYPE
                                ,p_First_Pmnt_Date IN Cltbs_Account_Comp_Sch.First_Due_Date%TYPE
                                ,p_Value_Date      IN Cltbs_Account_Master.Value_Date%TYPE
                                ,p_Pmnt_Freq       IN Cltms_Product_Dflt_Schedules.Frequency%TYPE
                                ,p_Pmnt_Freq_Units IN Cltms_Product_Dflt_Schedules.Frequency_Unit%TYPE
                                ,p_Capitalize      IN BOOLEAN
                                ,p_Mora_Sch_Rec    IN OUT Cltms_Product_Dflt_Schedules%ROWTYPE
                                ,p_Err_Code        IN OUT Ertbs_Msgs.Err_Code%TYPE
                                ,p_Err_Param       IN OUT Ertbs_Msgs.Message%TYPE)
      RETURN BOOLEAN IS
   BEGIN
      IF NOT Clpkss_Stream_Schedules.Fn_Pre_Create_a_Mora_Sch(p_Product
                                                             ,p_Component
                                                             ,p_First_Pmnt_Date
                                                             ,p_Value_Date
                                                             ,p_Pmnt_Freq
                                                             ,p_Pmnt_Freq_Units
                                                             ,p_Capitalize
                                                             ,p_Mora_Sch_Rec
                                                             ,p_Err_Code
                                                             ,p_Err_Param) THEN
         RETURN FALSE;
      END IF;

      IF Clpkss_Stream_Schedules.Fn_Ovrdn_Create_a_Mora_Sch THEN
         IF NOT Clpkss_Stream_Schedules.Fn_Create_a_Mora_Sch(p_Product
                                                            ,p_Component
                                                            ,p_First_Pmnt_Date
                                                            ,p_Value_Date
                                                            ,p_Pmnt_Freq
                                                            ,p_Pmnt_Freq_Units
                                                            ,p_Capitalize
                                                            ,p_Mora_Sch_Rec
                                                            ,p_Err_Code
                                                            ,p_Err_Param) THEN
            RETURN FALSE;
         END IF;
      ELSE
         IF NOT Fn_Gen_Create_a_Mora_Sch(p_Product
                                        ,p_Component
                                        ,p_First_Pmnt_Date
                                        ,p_Value_Date
                                        ,p_Pmnt_Freq
                                        ,p_Pmnt_Freq_Units
                                        ,p_Capitalize
                                        ,p_Mora_Sch_Rec
                                        ,p_Err_Code
                                        ,p_Err_Param) THEN
            RETURN FALSE;
         END IF;
      END IF;
      IF NOT Clpkss_Stream_Schedules.Fn_Post_Create_a_Mora_Sch(p_Product
                                                              ,p_Component
                                                              ,p_First_Pmnt_Date
                                                              ,p_Value_Date
                                                              ,p_Pmnt_Freq
                                                              ,p_Pmnt_Freq_Units
                                                              ,p_Capitalize
                                                              ,p_Mora_Sch_Rec
                                                              ,p_Err_Code
                                                              ,p_Err_Param) THEN
         RETURN FALSE;
      END IF;
      Dbg('returning with ' || p_Mora_Sch_Rec.Frequency || '~' || '~' ||
          p_Mora_Sch_Rec.Component_Name);
      RETURN TRUE;
   EXCEPTION
      WHEN OTHERS THEN
         Dbg('I WO of fn_create_a_mora_sch ' || SQLERRM);
         RETURN FALSE;
   END Fn_Create_a_Mora_Sch;

   ----------------------------------------------------------------------->
   --Function coded by R.V. Ramesh..
   --Included by Sudharshan
   -- BY-PASS changes

   FUNCTION Fn_Create_Acc_Dflt_Sch(
                                   --Start ravi for increase tenor changes
                                   --  p_account_rec       IN OUT  clpkss_object.ty_rec_account,
                                   p_Account_Rec IN OUT NOCOPY Clpkss_Object.Ty_Rec_Account
                                  ,
                                   --End  ravi for increase tenor changes
                                   p_Err_Code  IN OUT VARCHAR2
                                  ,p_Err_Param IN OUT VARCHAR2) RETURN BOOLEAN IS

      TYPE Ty_Tb_Pmnt_Schs IS TABLE OF Cltms_Product_Dflt_Schedules%ROWTYPE INDEX BY PLS_INTEGER;
      TYPE Ty_Tb_Comp_Pmnt_Schs IS TABLE OF Cltms_Product_Dflt_Schedules%ROWTYPE INDEX BY Cltms_Product_Dflt_Schedules.Component_Name%TYPE;

      l_Tb_Pmnt_Schs      Ty_Tb_Pmnt_Schs;
      l_Tb_Comp_Pmnt_Schs Ty_Tb_Comp_Pmnt_Schs;

      --l_sch_value_date        DATE;
      --l_add_months        NUMBER;

      l_Frequency          Cltbs_Account_Master.Frequency%TYPE;
      l_Frequency_Unit     Cltbs_Account_Master.Frequency_Unit%TYPE;
      l_No_Of_Installments Cltbs_Account_Master.No_Of_Installments%TYPE;
      l_First_Ins_Date     Cltbs_Account_Master.First_Ins_Date%TYPE;
      l_Comp_Name          Cltbs_Account_Components.Component_Name%TYPE;

      l_Indx PLS_INTEGER;
      --l_flag          BOOLEAN;
      l_Comp_Indx     VARCHAR2(100);
      l_Tb_Dflt_Sch   Clpkss_Schedules.Ty_Tb_Comp_Dflt_Schs;
      l_Mora_Dflt_Sch Cltms_Product_Dflt_Schedules%ROWTYPE;
      ----------->
      l_Final_Table Clpkss_Schedules.Ty_Tb_Prd_Dflt_Schs;
      --l_final_idx   PLS_INTEGER;
      ----------->
      l_Counter PLS_INTEGER;

      --Start log#91 on 11-feb-2006
      l_Is_Amortized   BOOLEAN := FALSE;
      l_Prod_Component Cltms_Product_Components%ROWTYPE;
      --End log#91 on 11-feb-2006
      --euro bank retro changes LOG#103 starts
      -- start month end periodicity LOG#102
      l_Due_Dates_On     Cltbs_Account_Master.Due_Dates_On%TYPE;
      l_Ty_Schedule_Date Ty_Schedule_Date;
      -- end month end periodicity LOG#102
      --euro bank retro changes LOG#103 ends
      PROCEDURE Pr_Delete_Local_Tabs IS
      BEGIN
         l_Tb_Comp_Pmnt_Schs.DELETE;
         l_Tb_Comp_Pmnt_Schs.DELETE;
         l_Tb_Dflt_Sch.DELETE;
      END;

   BEGIN

      Pr_Delete_Local_Tabs;

      Dbg('START OF THE FUNCTION FN_PREPARE_ACC_DFLT_SCH');

      l_Frequency          := p_Account_Rec.Account_Det.Frequency;
      l_Frequency_Unit     := p_Account_Rec.Account_Det.Frequency_Unit;
      l_No_Of_Installments := p_Account_Rec.Account_Det.No_Of_Installments;
      l_First_Ins_Date     := p_Account_Rec.Account_Det.First_Ins_Date;
      --euro bank retro changes LOG#103 starts
      -- start dinakar month end periodicity LOG#102
      l_Due_Dates_On := p_Account_Rec.Account_Det.Due_Dates_On;
      -- end dinakar month end periodicity LOG#102
      --euro bank retro changes LOG#103 starts

      SELECT * BULK COLLECT
      INTO   l_Tb_Pmnt_Schs
      FROM   Cltms_Product_Dflt_Schedules
      WHERE  Product_Code = p_Account_Rec.Account_Det.Product_Code AND
             Schedule_Type = 'P' AND Schedule_Flag = 'N';

      IF l_Tb_Pmnt_Schs.COUNT = 0 THEN
         Dbg('no schs defined');
         Pr_Delete_Local_Tabs;
         RETURN TRUE;
      ELSE
         --rebuild recs as indexed by component name.
         l_Counter := l_Tb_Pmnt_Schs.FIRST;

         WHILE l_Counter IS NOT NULL LOOP
            l_Comp_Name := l_Tb_Pmnt_Schs(l_Counter).Component_Name;
            Dbg('l_comp_name ' || l_Comp_Name);
            l_Tb_Comp_Pmnt_Schs(l_Comp_Name) := l_Tb_Pmnt_Schs(l_Counter);

            l_Counter := l_Tb_Pmnt_Schs.NEXT(l_Counter);
            --Only one shedule defn. to be taken per component(the first Pmnt sch).
            WHILE l_Counter IS NOT NULL LOOP
               EXIT WHEN l_Tb_Pmnt_Schs(l_Counter) .Component_Name != l_Comp_Name;
               l_Counter := l_Tb_Pmnt_Schs.NEXT(l_Counter);
            END LOOP;

         END LOOP;
      END IF;

      l_Tb_Pmnt_Schs.DELETE;

      l_Comp_Indx := p_Account_Rec.g_Tb_Components.FIRST;

      WHILE l_Comp_Indx IS NOT NULL LOOP

         l_Indx := 1;
         l_Tb_Dflt_Sch.DELETE;
         l_Mora_Dflt_Sch := NULL;
         -- Log#127 Start
         l_Is_Amortized := FALSE;
         -- Log#127 End
         l_Comp_Name := p_Account_Rec.g_Tb_Components(l_Comp_Indx)
                       .Comp_Det.Component_Name;

         IF Nvl(p_Account_Rec.g_Tb_Components(l_Comp_Indx).Comp_Det.Component_Type, 'L') IN
            ('L', 'I') THEN
            --Start Log#91 on 11-feb-2006
            Dbg('evaluted if is necessary moratorium schedule');
            IF p_Account_Rec.g_Tb_Components(l_Comp_Indx).Comp_Det.Main_Component = 'Y' THEN
               l_Prod_Component := Clpks_Cache.Fn_Product_Components(p_Account_Rec.Account_Det.Product_Code
                                                                    ,l_Comp_Indx);
               IF l_Prod_Component.Formula_Type IN ('5', '6') OR Global.X9$ <> 'CLPBDC' THEN
                  --log#109 added global.x9$ <> 'CLPBDC' condition   -- Amortized Rule 78 = 6 , Amortized Reducing = 5
                  l_Is_Amortized := TRUE;
               END IF;
            END IF;

            --log#114 Start
            --IF l_is_amortized THEN
            IF l_Is_Amortized AND Global.X9$ <> 'SEKLHB'
            AND Global.X9$ <> 'AEDRAK'  --NRAKAEFCC0247 14235943
            THEN
               --End Log#91 on 11-feb-2006
               --log#114 End

               Dbg('calling fn_create_a_mora_sch for component ' || l_Comp_Indx);
               IF NOT Clpks_Schedules.Fn_Create_a_Mora_Sch(p_Account_Rec.Account_Det.Product_Code
                                                          ,l_Comp_Indx
                                                          ,l_First_Ins_Date
                                                          ,p_Account_Rec.Account_Det.Value_Date
                                                          ,l_Frequency
                                                          ,l_Frequency_Unit
                                                          ,FALSE
                                                          ,l_Mora_Dflt_Sch
                                                          ,p_Err_Code
                                                          ,p_Err_Param) THEN
                  Pr_Delete_Local_Tabs;
                  RETURN FALSE;
               END IF;

               IF l_Mora_Dflt_Sch.Component_Name IS NOT NULL THEN
                  l_Tb_Dflt_Sch(l_Indx) := l_Mora_Dflt_Sch;
                  l_Tb_Dflt_Sch(l_Indx) .Seq_No := l_Indx;
                  l_Indx := l_Indx + 1;
               END IF;
            END IF; -- LOG#91 on 11-feb-2006

            --Build Payment Schs for this.
            IF l_Tb_Comp_Pmnt_Schs.EXISTS(l_Comp_Name) THEN

               l_Tb_Dflt_Sch(l_Indx) := l_Tb_Comp_Pmnt_Schs(l_Comp_Name);

               l_Tb_Dflt_Sch(l_Indx) .Schedule_Type := 'P';
               l_Tb_Dflt_Sch(l_Indx) .Start_Reference := 'C';
               l_Tb_Dflt_Sch(l_Indx) .Frequency := l_Frequency;
               l_Tb_Dflt_Sch(l_Indx) .Frequency_Unit := l_Frequency_Unit;
               l_Tb_Dflt_Sch(l_Indx) .Start_Day := NULL;
               l_Tb_Dflt_Sch(l_Indx) .Start_Date := To_Char(l_First_Ins_Date, 'DD');
               l_Tb_Dflt_Sch(l_Indx) .Start_Month := To_Char(l_First_Ins_Date, 'MM');
               l_Tb_Dflt_Sch(l_Indx) .No_Of_Schedules := l_No_Of_Installments;
               l_Tb_Dflt_Sch(l_Indx) .Seq_No := l_Indx;
               --euro bank retro changes LOG#103 starts
               --start dinakar month end periodicity LOG#102
               l_Tb_Dflt_Sch(l_Indx) .Due_Dates_On := l_Due_Dates_On;
               -- end dinkar month end periodicity LOG#102
               --euro bank retro changes LOG#103 ends
            END IF;

         END IF;

         l_Final_Table(l_Comp_Indx) .g_Tb_Comp_Dflt_Schs := l_Tb_Dflt_Sch;

         l_Comp_Indx := p_Account_Rec.g_Tb_Components.NEXT(l_Comp_Indx);
      END LOOP;

      Dbg('calling clpkss_site_schedules.fn_create_schedule_wrapper');

      IF NOT Clpkss_Site_Schedules.Fn_Create_Schedule_Wrapper(p_Account_Rec
                                                             ,'DFLT'
                                                             ,p_Account_Rec.Account_Det.Value_Date
                                                             ,l_Final_Table
                                                             ,p_Err_Code
                                                             ,p_Err_Param) THEN
         Debug.Pr_Debug('CL', 'Failed in clpkss_schedules.fn_create_schedule');
         Pr_Delete_Local_Tabs;
         RETURN FALSE;
      END IF;

      /*IF  l_frequency_unit    =   'D'
        THEN
            l_sch_value_date    :=  l_first_ins_date - (l_frequency);
        ELSIF   l_frequency_unit    =   'W'
        THEN
            l_sch_value_date    :=  l_first_ins_date - (l_frequency*7);
        ELSE
            IF l_frequency_unit =   'M'
            THEN
                l_add_months    :=  1*l_frequency;
            ELSIF l_frequency_unit  =   'Q'
            THEN
                l_add_months    :=  3*l_frequency;
            ELSIF l_frequency_unit  =   'H'
            THEN
                l_add_months    :=  6*l_frequency;
            ELSIF l_frequency_unit  =   'Y'
            THEN
                l_add_months    :=  12*l_frequency;
            END IF;

            l_sch_value_date        :=  fn_add_months(l_first_ins_date,(-1)*l_add_months);
        END IF;


        IF l_sch_value_date         <   p_account_rec.account_det.value_date
        THEN
            dbg('FIRST INSTALLMENT FALLS SHORT OF THE INSTALLMENT PERIOD.');
        dbg('Sch value date - '||l_sch_value_DatE);
        dbg('Value date - '||p_account_rec.account_det.value_datE);
            RETURN FALSE;
        END IF;

        IF l_frequency_unit =   'B'
        THEN
            l_sch_value_date    :=  p_account_rec.account_det.value_date;
        END IF;


        l_comp_indx :=  p_account_rec.g_tb_components.first;

        l_flag := FALSE;
      --l_indx  :=  0;

        WHILE l_comp_indx is not null
        LOOP
        dbg('inside the LOOP');
        l_flag := FALSE;
            l_comp_name :=  p_account_rec.g_tb_components(l_comp_indx).comp_det.component_name;
        l_indx  :=  1;
            l_tb_dflt_sch.delete;
        ----->
        l_final_idx := 0;
        ----->

            IF nvl(p_account_rec.g_tb_components(l_comp_indx).comp_det.component_type,'L') in ('L','I')
            THEN
          DBG('COMP TYPE IS L OR I');
                ---->
          l_final_idx := l_final_idx + 1;
          ----->
          IF NOT clpks_schedules.fn_create_a_mora_sch
                            (
                            p_account_rec.account_det.product_code,
                            l_comp_name,
                            l_first_ins_date,
                            p_account_rec.account_det.value_Date,
                            l_frequency,
                            l_frequency_unit,
                            FALSE,
                            l_mora_dflt_sch,
                            p_err_code,
                            p_err_param
                            )
                THEN
                    RETURN FALSE;
                END IF;

                IF l_mora_dflt_sch.component_name is not null
                THEN
            DBG( ' L_MORA_DFLT_SCH.COMPONENT_NAME IS NOT NULL');
                    --l_indx            :=  1;
            l_flag      :=  TRUE;
            DBG('L_FLAG SET TO TRUE');
                    l_tb_dflt_sch(l_indx)   :=  l_mora_dflt_sch;
                    l_tb_dflt_sch(l_indx).SEQ_NO := l_indx;
          --------------->
            L_FINAL_TABLE(l_comp_indx).G_TB_COMP_DFLT_SCHS(l_indx) := l_tb_dflt_sch(l_indx);
          --------------->


                END IF;

                IF l_flag
          THEN
          DBG(' L_FLAG IS TRUE');
          l_indx    :=  l_indx  +   1;
          DBG('L_INDX AFTER INCREASE :'||L_INDX);
          END IF;



                l_tb_dflt_sch(l_indx).product_code      :=  p_account_rec.account_det.product_code;
                l_tb_dflt_sch(l_indx).component_name    :=  l_comp_name;
                l_tb_dflt_sch(l_indx).schedule_type     :=  'P';
                l_tb_dflt_sch(l_indx).start_reference   :=  'V';
                l_tb_dflt_sch(l_indx).frequency         :=  l_frequency;
                l_tb_dflt_sch(l_indx).frequency_unit    :=  l_frequency_unit;
                l_tb_dflt_sch(l_indx).start_day         :=  null;
                l_tb_dflt_sch(l_indx).start_date        :=  to_char(l_sch_value_date,'DD');
                l_tb_dflt_sch(l_indx).start_month       :=  to_char(l_sch_value_date,'MM');
                l_tb_dflt_sch(l_indx).no_of_schedules   :=  l_no_of_installments;
                l_tb_dflt_sch(l_indx).formula_name      :=  null;
                l_tb_dflt_sch(l_indx).seq_no            :=  l_indx;
                l_tb_dflt_sch(l_indx).schedule_flag     :=  'N';
                l_tb_dflt_sch(l_indx).capitalized       :=  'N';


          --------------->
          L_FINAL_TABLE(l_comp_indx).G_TB_COMP_DFLT_SCHS(l_indx) := l_tb_dflt_sch(l_indx);
          --------------->

            END IF;

            l_tb_dflt_sch.delete;

            l_comp_indx :=  p_account_rec.g_tb_components.next(l_comp_indx);
        END LOOP;


      DBG('CALLING clpkss_SITE_schedules.FN_CREATE_SCHEDULE_WRAPPER');

        IF NOT clpkss_SITE_schedules.FN_CREATE_SCHEDULE_WRAPPER
                    (
                    p_account_rec,
                    'DFLT',
                    p_account_rec.account_det.value_date,
            l_final_table,
                    p_err_code,
                    p_err_param
                    )
        THEN
            debug.pr_debug('CL','Failed in clpkss_schedules.fn_create_schedule');
            RETURN FALSE;
        END IF;*/

      Dbg('End of the function fn_prepare_acc_dflt_sch');

      Pr_Delete_Local_Tabs;

      RETURN TRUE;

   EXCEPTION
      WHEN OTHERS THEN
         Pr_Delete_Local_Tabs;
         Dbg('Failed in defaulting the account schedules ');
         p_Err_Code  := 'CL-SCH-100;';
         p_Err_Param := '';
         RETURN FALSE;
   END Fn_Create_Acc_Dflt_Sch;

   -- CHANGE ENDS : SUDHARSHAN

   FUNCTION Fn_Create_Call_Sch(
                               --Start ravi for increase tenor changes
                               -- p_account_rec       IN OUT  clpkss_object.ty_rec_account,
                               p_Account_Rec IN OUT NOCOPY Clpkss_Object.Ty_Rec_Account
                              ,
                               --End ravi for increase tenor changes
                               p_Err_Code  IN OUT VARCHAR2
                              ,p_Err_Param IN OUT VARCHAR2) RETURN BOOLEAN IS
      CURSOR Cr_Formula(p_Product Cltm_Product_Comp_Frm.Product_Code%TYPE) IS
         SELECT DISTINCT Component_Name, Formula_Name
         FROM   Cltm_Product_Comp_Frm a
         WHERE  Product_Code = p_Product AND Book_Flag = 'Y' AND
                Formula_Name =
                (SELECT DISTINCT Formula_Name
                 FROM   Cltm_Product_Comp_Frm b
                 WHERE  b.Product_Code = a.Product_Code AND
                        b.Component_Name = a.Component_Name AND Rownum = 1);

      TYPE l_Tb_Formula IS TABLE OF Cltm_Product_Comp_Frm.Formula_Name%TYPE INDEX BY Cltm_Product_Comp_Frm.Component_Name%TYPE;
      l_Table_Formula l_Tb_Formula;

      l_Sch_Value_Date DATE;
      l_Comp_Name      Cltbs_Account_Components.Component_Name%TYPE;
      l_Indx           PLS_INTEGER;
      l_Flag           BOOLEAN;
      l_Comp_Indx      VARCHAR2(100);
      l_Tb_Dflt_Sch    Clpkss_Schedules.Ty_Tb_Comp_Dflt_Schs;
      ----------->
      l_Final_Table Clpkss_Schedules.Ty_Tb_Prd_Dflt_Schs;
      l_Final_Idx   PLS_INTEGER;
      ----------->

   BEGIN
      IF Nvl(p_Account_Rec.Account_Det.Maturity_Type, '#') <> 'C' THEN
         RETURN FALSE;
      END IF;
      l_Sch_Value_Date := p_Account_Rec.Account_Det.Value_Date;
      l_Comp_Indx      := p_Account_Rec.g_Tb_Components.FIRST;

      l_Flag := FALSE;

      FOR l_Formula IN Cr_Formula(p_Account_Rec.Account_Det.Product_Code) LOOP
         l_Table_Formula(l_Formula.Component_Name) := l_Formula.Formula_Name;
      END LOOP;

      WHILE l_Comp_Indx IS NOT NULL LOOP
         Dbg('inside the LOOP');
         l_Flag      := FALSE;
         l_Comp_Name := p_Account_Rec.g_Tb_Components(l_Comp_Indx)
                       .Comp_Det.Component_Name;
         l_Indx      := 1;
         l_Tb_Dflt_Sch.DELETE;
         ----->
         l_Final_Idx := 0;
         ----->

         IF Nvl(p_Account_Rec.g_Tb_Components(l_Comp_Indx).Comp_Det.Component_Type, 'L') IN
            ('L', 'I') THEN
            Dbg('COMP TYPE IS L OR I');
            l_Final_Idx := l_Final_Idx + 1;
            IF l_Flag THEN
               Dbg(' L_FLAG IS TRUE');
               l_Indx := l_Indx + 1;
               Dbg('L_INDX AFTER INCREASE :' || l_Indx);
            END IF;

            l_Tb_Dflt_Sch(l_Indx) .Product_Code := p_Account_Rec.Account_Det.Product_Code;
            l_Tb_Dflt_Sch(l_Indx) .Component_Name := l_Comp_Name;
            l_Tb_Dflt_Sch(l_Indx) .Schedule_Type := 'P';
            l_Tb_Dflt_Sch(l_Indx) .Start_Reference := 'V';
            l_Tb_Dflt_Sch(l_Indx) .Frequency := 1;
            l_Tb_Dflt_Sch(l_Indx) .Frequency_Unit := 'B';
            l_Tb_Dflt_Sch(l_Indx) .Start_Day := NULL;
            l_Tb_Dflt_Sch(l_Indx) .Start_Date := To_Char(l_Sch_Value_Date, 'DD');
            l_Tb_Dflt_Sch(l_Indx) .Start_Month := To_Char(l_Sch_Value_Date, 'MM');
            l_Tb_Dflt_Sch(l_Indx) .No_Of_Schedules := 1;
            IF l_Table_Formula.EXISTS(l_Comp_Name) THEN
               l_Tb_Dflt_Sch(l_Indx) .Formula_Name := l_Table_Formula(l_Comp_Name);
            END IF;
            l_Tb_Dflt_Sch(l_Indx) .Seq_No := l_Indx;
            l_Tb_Dflt_Sch(l_Indx) .Schedule_Flag := 'N';
            l_Tb_Dflt_Sch(l_Indx) .Capitalized := 'N';

            --------------->
            l_Final_Table(l_Comp_Indx) .g_Tb_Comp_Dflt_Schs(l_Indx) := l_Tb_Dflt_Sch(l_Indx);
            --------------->

         END IF;

         l_Tb_Dflt_Sch.DELETE;

         l_Comp_Indx := p_Account_Rec.g_Tb_Components.NEXT(l_Comp_Indx);
      END LOOP;

      Dbg('CALLING clpkss_SITE_schedules.FN_CREATE_SCHEDULE_WRAPPER');

      IF NOT Clpkss_Site_Schedules.Fn_Create_Schedule_Wrapper(p_Account_Rec
                                                             ,'DFLT'
                                                             ,p_Account_Rec.Account_Det.Value_Date
                                                             ,l_Final_Table
                                                             ,p_Err_Code
                                                             ,p_Err_Param) THEN
         Debug.Pr_Debug('CL', 'Failed in clpkss_schedules.fn_create_schedule');
         RETURN FALSE;
      END IF;

      Dbg('End of the function fn_prepare_acc_dflt_sch');

      RETURN TRUE;

   EXCEPTION
      WHEN OTHERS THEN
         Dbg('Failed in defaulting the account schedules ');
         p_Err_Code  := 'CL-SCH-100;';
         p_Err_Param := '';
         RETURN FALSE;
   END Fn_Create_Call_Sch;

   -------------------------------------------------------------------------------------->
   ---
   --This Function will apply calender preferences on a given date.
   --All other logic is left with calling functions.
   --
   FUNCTION Fn_Apply_Calender_Prefs(p_Ref_Date       IN Cltbs_Account_Schedules.Schedule_Due_Date%TYPE
                                   ,p_Due_Dates_On   IN Cltms_Product_Dflt_Schedules.Due_Dates_On%TYPE
                                   ,p_Start_Ref      IN Cltms_Product_Dflt_Schedules.Start_Reference%TYPE
                                   ,p_Frequency_Unit IN Cltms_Product_Dflt_Schedules.Frequency_Unit%TYPE
                                   ,p_Start_Date     IN Cltms_Product_Dflt_Schedules.Start_Date%TYPE
                                   ,p_Start_Month    IN Cltms_Product_Dflt_Schedules.Start_Month%TYPE
                                   ,
                                    --Start log#72
                                    p_Ins_Start_Date IN DATE
                                   ,
                                    --End log#72
                                    p_Due_Date OUT Cltbs_Account_Schedules.Schedule_Due_Date%TYPE)
   --p_err_code         IN  OUT ertbs_msgs.err_code%TYPE,
      --p_err_param        IN  OUT ertbs_msgs.message%TYPE)
    RETURN BOOLEAN IS
      l_Add_Months      PLS_INTEGER := 0;
      l_Force_Dates_On  NUMBER;
      l_Force_Months_On NUMBER;
      l_Temp_Date       DATE;
      l_Due_Date        DATE;
      l_Mm              NUMBER;

      FUNCTION Fn_Get_Treated_Date(p_Ref_Date  DATE
                                  ,p_Due_Date  NUMBER
                                  ,p_Due_Month NUMBER
                                  ,p_Out_Date  OUT DATE) RETURN BOOLEAN IS
         l_Month_Begin DATE;
         l_Month_End   DATE;
         l_Ref_Date    DATE := p_Ref_Date;
         l_Temp_Date   DATE;
      BEGIN
         --month treatmemnt

         IF p_Due_Month IS NOT NULL THEN
            -- Log#112 Retro - FCCRUSSIA IMPSUPP SFR-310: Date Format related changes from here
            --l_ref_date := trunc(l_ref_date,'YYYY');
            l_Ref_Date := Trunc(l_Ref_Date, 'RRRR');
            -- Log#112 till here
            l_Ref_Date := Add_Months(l_Ref_Date, Greatest(0, p_Due_Month - 1));
            --Log#59 RaghuR 13-Jul-2005 Start
            --Log#60 RaghuR 15-Jul-2005 Start
            l_Mm := To_Number(To_Char(p_Ref_Date, 'MM'));

            --IF l_ref_date <= p_ref_date
            IF p_Due_Month < l_Mm --Log#60 RaghuR 15-Jul-2005 END
             THEN
               l_Ref_Date := Add_Months(l_Ref_Date, 12);
            END IF;
            --Log#59 RaghuR 13-Jul-2005 End
         END IF;

         --DATE treatment

         l_Month_Begin := Trunc(l_Ref_Date, 'MM');

         l_Month_End := Last_Day(l_Month_Begin);

         IF l_Month_End - l_Month_Begin + 1 < p_Due_Date THEN
            p_Out_Date := l_Month_End;
         ELSE
            p_Out_Date := l_Month_Begin + (p_Due_Date - 1);
         END IF;

         --Start log#72
         IF p_Ins_Start_Date IS NOT NULL AND p_Ins_Start_Date <> p_Out_Date THEN
            p_Out_Date := p_Ins_Start_Date;
         END IF;
         --End log#72

         RETURN TRUE;
      END Fn_Get_Treated_Date;

      PROCEDURE Pr_Set_Add_Months IS
      BEGIN
         CASE p_Frequency_Unit
            WHEN 'D' THEN
               l_Add_Months := 0;
            WHEN 'W' THEN
               l_Add_Months := 0;
            WHEN 'M' THEN
               l_Add_Months := 1;
            WHEN 'Q' THEN
               l_Add_Months := 3;
            WHEN 'H' THEN
               l_Add_Months := 6;
            WHEN 'Y' THEN
               l_Add_Months := 12;
            ELSE
               l_Add_Months := 0;
         END CASE;
      END Pr_Set_Add_Months;

   BEGIN

      Dbg('in fn_apply_calender_prefs with');
      Dbg('p_ref_date~p_due_dates_on~p_start_ref ' || p_Ref_Date || '~' ||
          p_Due_Dates_On || '~' || p_Start_Ref);
      Dbg('p_frequency_unit~p_start_date~p_start_month ' || p_Frequency_Unit || '~' ||
          p_Start_Date || '~' || p_Start_Month);

      Pr_Set_Add_Months;

      IF p_Frequency_Unit IN ('D', 'W', 'B') THEN
         Dbg('not supposed to call for these');
         p_Due_Date := p_Ref_Date;
         RETURN TRUE;
      ELSE
         l_Force_Dates_On := Nvl(Nvl(p_Due_Dates_On, p_Start_Date)
                                ,To_Char(p_Ref_Date, 'DD'));

         --IF p_frequency_unit = 'M' OR p_start_ref = 'V' THEN
         IF p_Start_Ref = 'V' THEN
            l_Force_Months_On := NULL;
         ELSE
            l_Force_Months_On := Nvl(p_Start_Month, To_Char(p_Ref_Date, 'MM'));
         END IF;

         Dbg('l_force_dates_on ~  l_force_months_on ' || l_Force_Dates_On || '~' ||
             l_Force_Months_On);

         IF NOT Fn_Get_Treated_Date(p_Ref_Date
                                   ,l_Force_Dates_On
                                   ,l_Force_Months_On
                                   ,l_Temp_Date) THEN
            RETURN FALSE;
         END IF;

         Dbg('date post treatment is ' || l_Temp_Date);

         l_Due_Date := l_Temp_Date;
         --log # 36
         --getting forward dates should be happening only if treated date is lesser than ref date.
         --WHILE l_due_date <= p_ref_date
         -- WHILE l_due_date <= p_ref_date  ---Log#44 Changes Added = in the condition.
        -- IF g_Date_Flag <> 1 THEN --Log#183 Changes
            ----log#73
            --log#119 changes start
            IF p_Start_Ref = 'V' THEN
               --log#119 Changes end
               WHILE l_Due_Date < p_Ref_Date --Log#59 RaghuR 13-Jul-2005 Removed the = sign
                LOOP
                  Dbg('l_start_date - l_reference_date ' || l_Due_Date || '- ' ||
                      p_Ref_Date);
                  l_Due_Date := Add_Months(l_Due_Date, l_Add_Months);
                  IF l_Add_Months = 0 THEN
                     Dbg('l_Add_months IS 0..returning false');
                     RETURN FALSE;
                  END IF;
               END LOOP;
               --log#119 changes start
            ELSE
               Dbg('p_start_ref is not V');
               WHILE l_Due_Date <= p_Ref_Date LOOP
                  Dbg('l_start_date - l_reference_date ' || l_Due_Date || '- ' ||
                      p_Ref_Date);
                  l_Due_Date := Add_Months(l_Due_Date, l_Add_Months);
                  IF l_Add_Months = 0 THEN
                     Dbg('l_Add_months IS 0..returning false');
                     RETURN FALSE;
                  END IF;
               END LOOP;
            END IF;
            --log#119 changes end
            g_Date_Flag := 0; --log#73
         --END IF; --log#73  --Log#183 Changes
      END IF;

      p_Due_Date := l_Due_Date;

      RETURN TRUE;
   EXCEPTION
      WHEN OTHERS THEN
         Dbg('in when others of fn_apply_calender_prefs with ' || SQLERRM);
         RETURN FALSE;
   END Fn_Apply_Calender_Prefs;

   FUNCTION Fn_Apply_Duedateson_Pref(p_Ref_Date       IN Cltbs_Account_Schedules.Schedule_Due_Date%TYPE
                                    ,p_Due_Dates_On   IN Cltms_Product_Dflt_Schedules.Due_Dates_On%TYPE
                                    ,p_Frequency_Unit IN Cltms_Product_Dflt_Schedules.Frequency_Unit%TYPE
                                    ,p_Due_Date       OUT Cltbs_Account_Schedules.Schedule_Due_Date%TYPE)
      RETURN BOOLEAN IS
   BEGIN

      IF p_Ref_Date IS NULL OR p_Due_Dates_On IS NULL OR p_Frequency_Unit IS NULL THEN
         Dbg('params are null..will return false');
         RETURN FALSE;
      END IF;

      IF Trunc(p_Ref_Date, 'MM') + p_Due_Dates_On - 1 = p_Ref_Date THEN
         Dbg('already treated date');

         p_Due_Date := p_Ref_Date;

         RETURN TRUE;
      END IF;

      IF NOT Fn_Apply_Calender_Prefs(p_Ref_Date
                                    ,p_Due_Dates_On
                                    ,'V'
                                    ,p_Frequency_Unit
                                    ,NULL
                                    ,NULL
                                    ,
                                     --Start log#72
                                     NULL
                                    ,
                                     --End log#72
                                     p_Due_Date) THEN
         RETURN FALSE;
      END IF;

      RETURN TRUE;

   EXCEPTION
      WHEN OTHERS THEN
         RETURN FALSE;
   END Fn_Apply_Duedateson_Pref;

   --Start ravi for increase tenor changes
   FUNCTION Fn_Add_a_Schedule(p_Ref_Sch_Rec IN Cltbs_Account_Schedules%ROWTYPE
                             ,p_Account_Rec IN OUT NOCOPY Clpkss_Object.Ty_Rec_Account
                             ,p_Err_Code    IN OUT Ertbs_Msgs.Err_Code%TYPE
                             ,p_Err_Param   IN OUT Ertbs_Msgs.Message%TYPE) RETURN BOOLEAN IS

      l_Schedule_Linkage CONSTANT Cltbs_Account_Schedules.Schedule_Linkage%TYPE := p_Ref_Sch_Rec.Schedule_Linkage;
      l_Comp CONSTANT Cltbs_Account_Schedules.Component_Name%TYPE := p_Ref_Sch_Rec.Component_Name;
      l_Ref_Sch_Idx CONSTANT PLS_INTEGER := Clpkss_Util.Fn_Hash_Date(p_Ref_Sch_Rec.Schedule_Due_Date);
      l_Comp_Sch_Indx      VARCHAR2(100);
      l_Curr_Sch_Indx      VARCHAR2(100);
      l_Comp_Sch_Rec       Cltbs_Account_Comp_Sch%ROWTYPE;
      l_Comp_Sch_Rec_tmp   Cltbs_Account_Comp_Sch%ROWTYPE;      --Log#158
      l_New_Acc_Sch_Rec    Cltbs_Account_Schedules%ROWTYPE := p_Ref_Sch_Rec;
      l_Rec_Prod           Cltms_Product%ROWTYPE := Clpks_Cache.Fn_Product(p_Account_Rec.Account_Det.Product_Code);
      l_Tab_Comp_Schs      Clpkss_Object.Ty_Tb_Account_Comp_Sch;
      l_No_Of_Schs         Cltbs_Account_Comp_Sch.No_Of_Schedules%TYPE;
      l_Ref_Date           DATE;
      l_Start_Date         DATE;
      l_Increased_Days     PLS_INTEGER;
      l_New_Mat_Date       Cltbs_Account_Master.Maturity_Date%TYPE;
      l_Bullet_Indx        PLS_INTEGER;
      l_Eternity           DATE := Clpkss_Util.Pkg_Eternity;
      l_Due_Indx           PLS_INTEGER;
      l_Orig_Pmnt_End_Date DATE;
      l_Prev_Sch_End_Date  DATE;
      l_Tb_Schedule_Dates  Ty_Schedule_Date;
      l_Indx               VARCHAR2(100);
      l_Out_Tb_Amt_Due     Clpkss_Object.Ty_Tb_Amt_Due;
      l_New_Last_Rpmnt_Dt  DATE;
      l_Amort_Pair         Cltbs_Account_Schedules.Component_Name%TYPE;
      l_Tb_Amort_Dues      Clpkss_Object.Ty_Tb_Amt_Due;
      l_Tb_Dummy_Amt_Dues  Clpkss_Object.Ty_Tb_Amt_Due;
      l_Tb_Amort_Pairs     Clpkss_Cache.Ty_Tb_Amort_Pairs;
      l_Product_Code CONSTANT Cltbs_Account_Master.Product_Code%TYPE := p_Account_Rec.Account_Det.Product_Code;
      l_Mat_Sch_Idx VARCHAR2(100); --LOG#133
      FUNCTION Fn_Delete_Bullet_Sch RETURN BOOLEAN IS
         l_Due_Idx       PLS_INTEGER;
         l_Bull_Idx      VARCHAR2(100);
         l_Bull_Due_Date DATE;
         l_Frm_Name      Cltbs_Account_Schedules.Formula_Name%TYPE;
      BEGIN
         IF NOT Clpkss_Cache.Fn_Get_Amort_Pairs(l_Product_Code, l_Tb_Amort_Pairs) THEN
            RETURN FALSE;
         END IF;
         dbg('l_Comp' || l_Comp);
         DBG('ACCOUNT NUMBER' || p_Ref_Sch_Rec.ACCOUNT_NUMBER);
	 --Log#158 Starts
         --l_Bull_Idx := p_Account_Rec.g_Tb_Components(l_Comp).g_Tb_Comp_Sch.LAST;
         l_Bull_Idx := p_Account_Rec.g_Tb_Components(l_Comp).g_Tb_Comp_Sch.FIRST;
         WHILE l_Bull_Idx IS NOT NULL
         LOOP
	 --Log#158 Ends
          dbg('l_Bull_Idx' || l_Bull_Idx);
          DBG('p_Account_Rec.g_Tb_Components(l_Comp).g_Tb_Comp_Sch(l_Bull_Idx)
         .g_Account_Comp_Sch.Unit' || p_Account_Rec.g_Tb_Components(l_Comp).g_Tb_Comp_Sch(l_Bull_Idx)
         .g_Account_Comp_Sch.Unit);
         IF p_Account_Rec.g_Tb_Components(l_Comp).g_Tb_Comp_Sch(l_Bull_Idx)
         .g_Account_Comp_Sch.Unit = 'B' THEN
           dbg('HERE 1' || l_Comp);
            l_Bull_Due_Date := p_Account_Rec.g_Tb_Components(l_Comp)
                              .g_Tb_Comp_Sch(l_Bull_Idx)
                              .g_Account_Comp_Sch.First_Due_Date;
            DBG('l_Bull_Due_Date' || l_Bull_Due_Date);
            p_Account_Rec.g_Tb_Components(l_Comp) .g_Tb_Comp_Sch.DELETE(l_Bull_Idx);
         END IF;
         --Log#158 Starts
             l_Bull_Idx := p_Account_Rec.g_Tb_Components(l_Comp).g_Tb_Comp_Sch.NEXT(l_Bull_Idx);
         END LOOP;
         --Log#158 Ends
         DBG('l_Bull_Due_Date 1' || l_Bull_Due_Date);
         IF l_Bull_Due_Date IS NOT NULL THEN
            dbg('HERE 2' || l_Comp);
            l_Due_Idx := Clpkss_Util.Fn_Hash_Date(l_Bull_Due_Date);
             DBG('l_Due_Idx' || l_Due_Idx);
            IF p_Account_Rec.g_Tb_Components(l_Comp).g_Tb_Amt_Due.EXISTS(l_Due_Idx) THEN
               l_Frm_Name := p_Account_Rec.g_Tb_Components(l_Comp)
                            .g_Tb_Amt_Due(l_Due_Idx).g_Amount_Due.Formula_Name;
                            DBG('l_Frm_Name' || l_Frm_Name);
               p_Account_Rec.g_Tb_Components(l_Comp) .g_Tb_Amt_Due.DELETE(l_Due_Idx);
            END IF;
            IF l_Tb_Amort_Pairs.EXISTS(l_Product_Code || l_Comp || l_Frm_Name) THEN
             dbg('HERE 3' || l_Comp);
               p_Account_Rec.g_Tb_Components(l_Tb_Amort_Pairs(l_Product_Code || l_Comp ||
                                                              l_Frm_Name)) .g_Tb_Amt_Due.DELETE(l_Due_Idx);
            END IF;
         END IF;
         RETURN TRUE;
      END Fn_Delete_Bullet_Sch;
      PROCEDURE Pr_Delete_Tabs IS
      BEGIN
         l_Tb_Amort_Dues.DELETE;
         l_Out_Tb_Amt_Due.DELETE;
         l_Tab_Comp_Schs.DELETE;
         l_Tb_Dummy_Amt_Dues.DELETE;
      END Pr_Delete_Tabs;

   BEGIN
      Dbg('Inside fn_add_a_schedule');
      Dbg(l_Schedule_Linkage);
      IF NOT Fn_Delete_Bullet_Sch THEN
         RETURN FALSE;
      END IF;

      l_Comp_Sch_Indx := 'P' || Clpkss_Util.Fn_Hash_Date(l_Schedule_Linkage, NULL);

      l_Curr_Sch_Indx := l_Comp_Sch_Indx;
      WHILE l_Curr_Sch_Indx IS NOT NULL LOOP
         l_Comp_Sch_Rec := p_Account_Rec.g_Tb_Components(l_Comp)
                          .g_Tb_Comp_Sch(l_Curr_Sch_Indx).g_Account_Comp_Sch;
      dbg('Schedule_type :'||l_Comp_Sch_Rec.Schedule_type);
         IF l_Comp_Sch_Rec.schedule_type ='P' AND l_Comp_Sch_Rec.Unit<>'B' THEN --Log#158
         l_Comp_Sch_Rec_tmp := l_Comp_Sch_Rec;--Log#158
         IF l_Curr_Sch_Indx = l_Comp_Sch_Indx THEN
            l_No_Of_Schs := 1;
            l_Ref_Date   := p_Ref_Sch_Rec.Schedule_Due_Date;
         ELSE
            l_No_Of_Schs := l_Comp_Sch_Rec.No_Of_Schedules;
            l_Ref_Date   := l_Prev_Sch_End_Date;
         END IF;
         Dbg(l_Ref_Date || ' ### ' || l_Comp_Sch_Rec.Unit || ' ### ' ||
             l_Comp_Sch_Rec.Frequency);
         l_Start_Date := Fn_Get_Next_Schedule_Date(l_Ref_Date
                                                  ,l_Comp_Sch_Rec.Unit
                                                  ,l_Comp_Sch_Rec.Frequency);
         Dbg('calling fn_compute_schedule_dates with l_start_date as ' || l_Start_Date);
         IF NOT Fn_Compute_Schedule_Dates(l_Start_Date
                                         ,p_Account_Rec.Account_Det.Value_Date
                                         ,l_Eternity
                                         , --maturity_date
                                          p_Account_Rec.Account_Det.Branch_Code
                                         ,p_Account_Rec.Account_Det.Product_Code
                                         ,l_Comp_Sch_Rec.Frequency
                                         ,l_Comp_Sch_Rec.Unit
                                         ,l_No_Of_Schs
                                         ,l_Rec_Prod.Ignore_Holidays
                                         ,l_Rec_Prod.Schedule_Movement
                                         ,l_Rec_Prod.Move_Across_Month
                                         ,l_Rec_Prod.Cascade_Schedules
                                         ,l_Comp_Sch_Rec.Due_Dates_On
                                         ,
                                          --euro bank retro changes LOG#103 starts
                                          -- start dinakar month end periodicity LOG#102
                                          NULL
                                         ,
                                          -- end dinakar month end periodicity LOG#102
                                          --euro bank retro changes LOG#103 ends
                                          l_Tb_Schedule_Dates
                                         ,p_Err_Code
                                         ,
                                          --START Log#116
                                          l_Comp_Sch_Rec.Schedule_Type)
         --END Log#116

          THEN
            Pr_Delete_Tabs;
            RETURN FALSE;
         END IF;

         IF l_Curr_Sch_Indx = l_Comp_Sch_Indx THEN
            IF l_Tb_Schedule_Dates.COUNT <> 1 THEN
               Pr_Delete_Tabs;
               RETURN FALSE;
            END IF;
            l_Comp_Sch_Rec.No_Of_Schedules := l_Comp_Sch_Rec.No_Of_Schedules + 1;
            l_Comp_Sch_Rec.Sch_End_Date    := l_Tb_Schedule_Dates(l_Tb_Schedule_Dates.COUNT);

            l_Indx := l_Comp_Sch_Indx;
            --build account schedule rec
            l_New_Acc_Sch_Rec := p_Ref_Sch_Rec;
            Dbg('1');
            l_New_Acc_Sch_Rec.Schedule_St_Date  := p_Ref_Sch_Rec.Schedule_Due_Date;
            l_New_Acc_Sch_Rec.Schedule_Due_Date := l_Tb_Schedule_Dates(l_Tb_Schedule_Dates.COUNT);
            Dbg('2');
            l_New_Acc_Sch_Rec.Orig_Amount_Due := 0;
            l_New_Acc_Sch_Rec.Amount_Due := 0;
            l_New_Acc_Sch_Rec.Adj_Amount := 0;
            l_New_Acc_Sch_Rec.Amount_Settled := 0;
            l_New_Acc_Sch_Rec.Amount_Overdue := 0;
            l_New_Acc_Sch_Rec.Accrued_Amount := 0;
            l_New_Acc_Sch_Rec.Amount_Waived := 0; --Log#98 LH Changes
            p_Account_Rec.g_Tb_Components(l_Comp) .g_Tb_Amt_Due(Clpkss_Util.Fn_Hash_Date(l_New_Acc_Sch_Rec.Schedule_Due_Date)) .g_Amount_Due := l_New_Acc_Sch_Rec;
            IF l_Tb_Amort_Pairs.EXISTS(l_Product_Code || l_Comp ||
                                       l_New_Acc_Sch_Rec.Formula_Name) THEN
               l_New_Acc_Sch_Rec.Component_Name := l_Tb_Amort_Pairs(l_Product_Code ||
                                                                    l_Comp ||
                                                                    l_New_Acc_Sch_Rec.Formula_Name);
               l_New_Acc_Sch_Rec.Schedule_Type := NULL;
               l_New_Acc_Sch_Rec.Formula_Name := NULL;
               l_New_Acc_Sch_Rec.Emi_Amount := NULL;
               p_Account_Rec.g_Tb_Components(l_New_Acc_Sch_Rec.Component_Name) .g_Tb_Amt_Due(Clpkss_Util.Fn_Hash_Date(l_New_Acc_Sch_Rec.Schedule_Due_Date)) .g_Amount_Due := l_New_Acc_Sch_Rec;
            END IF;
            Dbg('3');
         ELSE
            l_Comp_Sch_Rec.Sch_Start_Date  := l_Prev_Sch_End_Date;
            l_Comp_Sch_Rec.First_Due_Date  := l_Tb_Schedule_Dates(l_Tb_Schedule_Dates.FIRST);
            l_Comp_Sch_Rec.No_Of_Schedules := l_Tb_Schedule_Dates.COUNT;
            l_Comp_Sch_Rec.Sch_End_Date    := l_Tb_Schedule_Dates(l_Tb_Schedule_Dates.COUNT);

            l_Indx := 'P' || Clpkss_Util.Fn_Hash_Date(l_Tb_Schedule_Dates(l_Tb_Schedule_Dates.FIRST)
                                                     ,NULL);

            l_Tab_Comp_Schs(l_Indx) .g_Account_Comp_Sch := l_Comp_Sch_Rec;

         END IF;
         Dbg('4');
         l_Prev_Sch_End_Date := l_Comp_Sch_Rec.Sch_End_Date;
         p_Account_Rec.g_Tb_Components(l_Comp) .g_Tb_Comp_Sch(l_Indx) .g_Account_Comp_Sch := l_Comp_Sch_Rec; --lOG#158
         END IF; --LOG#158

         l_Curr_Sch_Indx := p_Account_Rec.g_Tb_Components(l_Comp)
                           .g_Tb_Comp_Sch.NEXT(l_Curr_Sch_Indx);
         dbg('End of Loop'||l_Curr_Sch_Indx);
--         p_Account_Rec.g_Tb_Components(l_Comp) .g_Tb_Comp_Sch(l_Indx) .g_Account_Comp_Sch := l_Comp_Sch_Rec; --lOG#158
      END LOOP;
      dbg('Out of Loop');
      l_Comp_Sch_Rec := l_Comp_Sch_Rec_tmp;--Log#158
      --call fn_populate_account_schedules
      --LOG#133 Start
      Dbg(l_Tb_Schedule_Dates(l_Tb_Schedule_Dates.FIRST) || ' #### ' ||
          l_Comp_Sch_Rec.Unit || ' ### ' || l_Comp_Sch_Rec.Frequency);
      l_Start_Date := Fn_Get_Next_Schedule_Date(l_Tb_Schedule_Dates(l_Tb_Schedule_Dates.FIRST)
                                               ,l_Comp_Sch_Rec.Unit
                                               ,l_Comp_Sch_Rec.Frequency);
      Dbg('calling fn_compute_schedule_dates with start_date as ' || l_Start_Date);
      IF NOT Fn_Compute_Schedule_Dates(l_Start_Date
                                      ,p_Account_Rec.Account_Det.Value_Date
                                      ,l_Eternity
                                      ,p_Account_Rec.Account_Det.Branch_Code
                                      ,p_Account_Rec.Account_Det.Product_Code
                                      ,1
                                      ,'B'
                                      ,1
                                      ,l_Rec_Prod.Ignore_Holidays
                                      ,l_Rec_Prod.Schedule_Movement
                                      ,l_Rec_Prod.Move_Across_Month
                                      ,l_Rec_Prod.Cascade_Schedules
                                      ,l_Comp_Sch_Rec.Due_Dates_On
                                      ,NULL
                                      ,l_Tb_Schedule_Dates
                                      ,p_Err_Code
                                      ,'P') THEN
         Pr_Delete_Tabs;
         RETURN FALSE;
      END IF;
      dbg('l_Tb_Schedule_Dates.Count : '||l_Tb_Schedule_Dates.COUNT);
      FOR i IN l_Tb_Schedule_Dates.FIRST .. l_Tb_Schedule_Dates.LAST LOOP
         Dbg('l_tb_schedule_dates(l_tb_schedule_dates.COUNT)' || l_Tb_Schedule_Dates(i));
      END LOOP;
      l_Comp_Sch_Rec.No_Of_Schedules := 1;
      l_Comp_Sch_Rec.Sch_End_Date    := l_Tb_Schedule_Dates(l_Tb_Schedule_Dates.COUNT);
      l_Comp_Sch_Rec.Sch_Start_Date  := l_Prev_Sch_End_Date;
      l_Comp_Sch_Rec.First_Due_Date  := l_Tb_Schedule_Dates(l_Tb_Schedule_Dates.COUNT);
      l_Comp_Sch_Rec.Unit            := 'B';
      l_Comp_Sch_Rec.Frequency       := 1;
      l_Comp_Sch_Rec.Sch_End_Date    := l_Tb_Schedule_Dates(l_Tb_Schedule_Dates.COUNT);

      l_New_Acc_Sch_Rec := p_Ref_Sch_Rec;
      Dbg('1');
      l_New_Acc_Sch_Rec.Schedule_St_Date  := l_Tb_Schedule_Dates(l_Tb_Schedule_Dates.COUNT);
      l_New_Acc_Sch_Rec.Schedule_Due_Date := l_Tb_Schedule_Dates(l_Tb_Schedule_Dates.COUNT);
      Dbg('2');
      l_New_Acc_Sch_Rec.Orig_Amount_Due := 0;
      l_New_Acc_Sch_Rec.Amount_Due := 0;
      l_New_Acc_Sch_Rec.Adj_Amount := 0;
      l_New_Acc_Sch_Rec.Amount_Settled := 0;
      l_New_Acc_Sch_Rec.Amount_Overdue := 0;
      l_New_Acc_Sch_Rec.Accrued_Amount := 0;
      l_New_Acc_Sch_Rec.Amount_Waived := 0;
      l_Mat_Sch_Idx := 'P' || Clpkss_Util.Fn_Hash_Date(l_Tb_Schedule_Dates(l_Tb_Schedule_Dates.COUNT)
                                                      ,NULL);
      p_Account_Rec.g_Tb_Components(l_Comp) .g_Tb_Comp_Sch(l_Mat_Sch_Idx) .g_Account_Comp_Sch := l_Comp_Sch_Rec;
      p_Account_Rec.g_Tb_Components(l_Comp) .g_Tb_Amt_Due(Clpkss_Util.Fn_Hash_Date(l_New_Acc_Sch_Rec.Schedule_Due_Date)) .g_Amount_Due := l_New_Acc_Sch_Rec;
      IF l_Tb_Amort_Pairs.EXISTS(l_Product_Code || l_Comp ||
                                 l_New_Acc_Sch_Rec.Formula_Name) THEN
         l_New_Acc_Sch_Rec.Component_Name := l_Tb_Amort_Pairs(l_Product_Code || l_Comp ||
                                                              l_New_Acc_Sch_Rec.Formula_Name);
         l_New_Acc_Sch_Rec.Schedule_Type := NULL;
         l_New_Acc_Sch_Rec.Formula_Name := NULL;
         l_New_Acc_Sch_Rec.Emi_Amount := NULL;
         p_Account_Rec.g_Tb_Components(l_New_Acc_Sch_Rec.Component_Name) .g_Tb_Amt_Due(Clpkss_Util.Fn_Hash_Date(l_New_Acc_Sch_Rec.Schedule_Due_Date)) .g_Amount_Due := l_New_Acc_Sch_Rec;
      END IF;
      l_Indx := 'P' || Clpkss_Util.Fn_Hash_Date(l_Tb_Schedule_Dates(l_Tb_Schedule_Dates.COUNT)
                                               ,NULL);
      l_Tab_Comp_Schs(l_Indx) .g_Account_Comp_Sch := l_Comp_Sch_Rec;
      --LOG#133  End
      IF l_Tab_Comp_Schs.COUNT > 0 THEN
         Dbg('will call fn_populate_account_schedules now');
         IF NOT
             Fn_Populate_Account_Schedules(l_Tab_Comp_Schs
                                          ,p_Account_Rec.Account_Det.Account_Number
                                          ,p_Account_Rec.Account_Det.Branch_Code
                                          ,p_Account_Rec.Account_Det.Product_Code
                                          ,p_Account_Rec.Account_Det.Process_No
                                          ,p_Account_Rec.g_Tb_Components(l_Comp).Comp_Det
                                          ,p_Account_Rec.Account_Det.Value_Date
                                          ,l_Eternity
										  ,p_account_rec.account_det.module_code ---- Log#162 Changes for 11.1 Dev (Payment in Advance)
                                          , --maturity_date
                                           l_Rec_Prod.Ignore_Holidays
                                          ,l_Rec_Prod.Schedule_Movement
                                          ,l_Rec_Prod.Move_Across_Month
                                          ,l_Rec_Prod.Cascade_Schedules
                                          ,l_Out_Tb_Amt_Due
                                          ,l_Tb_Amort_Dues
                                          ,l_Tb_Dummy_Amt_Dues
                                          ,l_Tb_Dummy_Amt_Dues
                                          ,
                                           --START LOG#46 23-May-2005 SFR#1
                                           p_Account_Rec.Account_Det.Value_Date
                                          ,
                                           --END LOG#46 23-May-2005 SFR#1
                                           --LOG#111 retro starts
                                           NULL
                                          ,
                                           --log#111 retro ends
                                           p_Err_Code) THEN
            Pr_Delete_Tabs;
            RETURN FALSE;
         ELSE

            l_Due_Indx := l_Out_Tb_Amt_Due.FIRST;
            WHILE l_Due_Indx IS NOT NULL LOOP
               p_Account_Rec.g_Tb_Components(l_Comp) .g_Tb_Amt_Due(l_Due_Indx) := l_Out_Tb_Amt_Due(l_Due_Indx);
               l_Due_Indx := l_Out_Tb_Amt_Due.NEXT(l_Due_Indx);
            END LOOP;
            IF l_Tb_Amort_Dues.COUNT > 0 THEN

               l_Due_Indx   := l_Tb_Amort_Dues.FIRST;
               l_Amort_Pair := l_Tb_Amort_Dues(l_Due_Indx).g_Amount_Due.Component_Name;
               WHILE l_Due_Indx IS NOT NULL LOOP
                  p_Account_Rec.g_Tb_Components(l_Amort_Pair) .g_Tb_Amt_Due(l_Due_Indx) := l_Tb_Amort_Dues(l_Due_Indx);
                  l_Due_Indx := l_Out_Tb_Amt_Due.NEXT(l_Due_Indx);
               END LOOP;
            END IF;
         END IF;
      END IF;
      --find out the new maturity date.
       --log#159 start
      IF p_Account_Rec.Account_Det.module_code ='LE'
       THEN
       l_Due_Indx  := p_Account_Rec.g_Tb_Components(l_Comp).g_Tb_Amt_Due.LAST;
       IF p_Account_Rec.g_Tb_Components(l_Comp).g_Tb_Amt_Due(l_Due_Indx).g_Amount_Due.Schedule_Due_Date =Clpkss_Util.Pkg_Eternity THEN
       l_Due_Indx := p_Account_Rec.g_Tb_Components(l_Comp).g_Tb_Amt_Due.PRIOR(l_Due_Indx);
       DBG('I AM HERE FOR LE');
       END IF;
      ELSE
	 --log#159 end
      l_Due_Indx                              := p_Account_Rec.g_Tb_Components(l_Comp)
                                                .g_Tb_Amt_Due.LAST;
      END IF; --log#159
      l_New_Mat_Date                          := p_Account_Rec.g_Tb_Components(l_Comp)
                                                .g_Tb_Amt_Due(l_Due_Indx)
                                                .g_Amount_Due.Schedule_Due_Date;
      p_Account_Rec.Account_Det.Maturity_Date := l_New_Mat_Date;
      Dbg('new maturity date is going to be ' || p_Account_Rec.Account_Det.Maturity_Date);
      Pr_Delete_Tabs;
      Dbg('returning true for fn_add_a_schedule');
      RETURN TRUE;

   EXCEPTION
      WHEN OTHERS THEN
         Dbg('in when others of fn_add_a_schedule with ' || SQLERRM);
         Pr_Delete_Tabs;
         RETURN FALSE;
   END Fn_Add_a_Schedule;

   FUNCTION Fn_Rearrange_Schs(p_Account_Rec IN OUT NOCOPY Clpkss_Object.Ty_Rec_Account
                             ,p_Err_Code    IN OUT Ertbs_Msgs.Err_Code%TYPE
                             ,p_Err_Param   IN OUT Ertbs_Msgs.Message%TYPE) RETURN BOOLEAN IS
      l_Mat_Date CONSTANT Cltbs_Account_Master.Maturity_Date%TYPE := p_Account_Rec.Account_Det.Maturity_Date;
      l_Mat_Due_Idx CONSTANT PLS_INTEGER := Clpkss_Util.Fn_Hash_Date(l_Mat_Date);
      l_Mat_Sch_Idx CONSTANT VARCHAR2(100) := 'P' ||
                                              Clpkss_Util.Fn_Hash_Date(l_Mat_Date, NULL);
      l_Comp_Indx        Cltms_Product_Components.Component_Name%TYPE;
      l_Pre_Bull_Sch_Rec Cltbs_Account_Comp_Sch%ROWTYPE;
      l_Comp_Sch_Idx     VARCHAR2(100);
      l_Bullet_Amt       Cltbs_Account_Comp_Sch.Amount%TYPE;
   BEGIN
      l_Comp_Indx := p_Account_Rec.g_Tb_Components.FIRST;
      Dbg('rearrange schs');
      WHILE l_Comp_Indx IS NOT NULL LOOP
         Dbg('looping for component ' || l_Comp_Indx);
         IF p_Account_Rec.g_Tb_Components(l_Comp_Indx).g_Tb_Amt_Due.EXISTS(l_Mat_Due_Idx) THEN
            p_Account_Rec.g_Tb_Components(l_Comp_Indx) .g_Tb_Amt_Due(l_Mat_Due_Idx) .g_Amount_Due.Schedule_Linkage := l_Mat_Date;

            IF Nvl(p_Account_Rec.g_Tb_Components(l_Comp_Indx).Comp_Det.Component_Type
                  ,'L') = 'L' THEN
               l_Bullet_Amt := p_Account_Rec.g_Tb_Components(l_Comp_Indx)
                              .g_Tb_Amt_Due(l_Mat_Due_Idx).g_Amount_Due.Amount_Due;
            ELSE
               l_Bullet_Amt := NULL;
            END IF;
            Dbg('l_bullet_amt' || l_Bullet_Amt);
            IF p_Account_Rec.g_Tb_Components(l_Comp_Indx).g_Tb_Amt_Due(l_Mat_Due_Idx)
            .g_Amount_Due.Schedule_Type IS NOT NULL --will ensure that comp sch fopr amort prin comps dont get processed.
             THEN
               IF NOT p_Account_Rec.g_Tb_Components(l_Comp_Indx)
               .g_Tb_Comp_Sch.EXISTS(l_Mat_Sch_Idx) THEN
                  --create a new bullet schedules
                  l_Comp_Sch_Idx := l_Mat_Sch_Idx;
                  l_Comp_Sch_Idx := p_Account_Rec.g_Tb_Components(l_Comp_Indx)
                                   .g_Tb_Comp_Sch.PRIOR(l_Comp_Sch_Idx);
                  IF l_Comp_Sch_Idx IS NULL THEN
                     Dbg('false because l_comp_sch_idx IS NULL');
                     RETURN FALSE;
                  END IF;
                  --Reduce no of schedule by 1 and update sch end date
                  Dbg('1');
                  --START Prasanna FCC-CL EUROBANK TESTING. 22-Mar-2006.
                  IF p_Account_Rec.g_Tb_Components(l_Comp_Indx)
                  .g_Tb_Comp_Sch(l_Comp_Sch_Idx)
                  .g_Account_Comp_Sch.No_Of_Schedules - 1 = 0 THEN
                     EXIT;
                  END IF;
                  --END Prasanna FCC-CL EUROBANK TESTING. 22-Mar-2006.
                  p_Account_Rec.g_Tb_Components(l_Comp_Indx) .g_Tb_Comp_Sch(l_Comp_Sch_Idx) .g_Account_Comp_Sch.No_Of_Schedules := p_Account_Rec.g_Tb_Components(l_Comp_Indx)
                                                                                                                                  .g_Tb_Comp_Sch(l_Comp_Sch_Idx)
                                                                                                                                  .g_Account_Comp_Sch.No_Of_Schedules - 1;

                  IF p_Account_Rec.g_Tb_Components(l_Comp_Indx)
                  .g_Tb_Comp_Sch(l_Comp_Sch_Idx).g_Account_Comp_Sch.No_Of_Schedules = 0 THEN
                     Dbg('false because no of schs are 0');
                     RETURN FALSE;
                  END IF;
                  --update sch end date
                  p_Account_Rec.g_Tb_Components(l_Comp_Indx) .g_Tb_Comp_Sch(l_Comp_Sch_Idx) .g_Account_Comp_Sch.Sch_End_Date := p_Account_Rec.g_Tb_Components(l_Comp_Indx)
                                                                                                                               .g_Tb_Amt_Due(l_Mat_Due_Idx)
                                                                                                                               .g_Amount_Due.Schedule_St_Date;

                  Dbg('1');
                  l_Pre_Bull_Sch_Rec := p_Account_Rec.g_Tb_Components(l_Comp_Indx)
                                       .g_Tb_Comp_Sch(l_Comp_Sch_Idx).g_Account_Comp_Sch;
                  Dbg('got rec b4 bullet schs');
                  l_Pre_Bull_Sch_Rec.Schedule_Flag   := 'N';
                  l_Pre_Bull_Sch_Rec.Sch_Start_Date  := l_Pre_Bull_Sch_Rec.Sch_End_Date;
                  l_Pre_Bull_Sch_Rec.No_Of_Schedules := 1;
                  l_Pre_Bull_Sch_Rec.Frequency       := 1;
                  l_Pre_Bull_Sch_Rec.Unit            := 'B';
                  l_Pre_Bull_Sch_Rec.Sch_End_Date    := l_Mat_Date;
                  l_Pre_Bull_Sch_Rec.Capitalized     := 'N';
                  l_Pre_Bull_Sch_Rec.First_Due_Date  := l_Mat_Date;
                  l_Pre_Bull_Sch_Rec.Waiver_Flag     := 'N';
                  l_Pre_Bull_Sch_Rec.Due_Dates_On    := NULL;
                  l_Pre_Bull_Sch_Rec.Amount          := l_Bullet_Amt;
                  Dbg('will add a bullet schedules');
                  p_Account_Rec.g_Tb_Components(l_Comp_Indx) .g_Tb_Comp_Sch(l_Mat_Sch_Idx) .g_Account_Comp_Sch := l_Pre_Bull_Sch_Rec;
               END IF;
            END IF;
         END IF;
         l_Comp_Indx := p_Account_Rec.g_Tb_Components.NEXT(l_Comp_Indx);
      END LOOP;
      Dbg('returning from fn_rearrange_schs');
      RETURN TRUE;
   EXCEPTION
      WHEN OTHERS THEN
         Dbg('in when others of fn_rearrange_schs with ' || SQLERRM);
         RETURN FALSE;
   END Fn_Rearrange_Schs;

   --End  ravi for increase tenor changes
   --Log#141 Abhishek Ranjan for Principal Repyament Holiday 14.09.2009 Starts
      FUNCTION fn_regen_compsch_prinhol( p_account_rec       IN OUT NOCOPY clpkss_object.ty_rec_account
                                        ,p_action_code       IN            VARCHAR2
                                        ,p_start_redef_from  IN            DATE
                                        ,p_component         IN            cltbs_account_components.component_name%TYPE
                                        ,p_err_code          IN OUT        ertbs_msgs.err_code%TYPE
                                        ,p_err_param         IN OUT        ertbs_msgs.message%TYPE
                                       )
      RETURN BOOLEAN IS
          TYPE ty_tb_principal_holiday IS TABLE OF cltms_holiday_periods%ROWTYPE INDEX BY PLS_INTEGER;
          l_tb_principal_holiday            ty_tb_principal_holiday;
          l_tb_temp_payment_sch             clpks_element_types.ty_tb_acc_comp_sch;
          l_next_date                       cltbs_account_comp_sch.first_due_date%TYPE;
          l_first_date                      cltbs_account_comp_sch.first_due_date%TYPE;
          l_sch_st_date                     cltbs_account_comp_sch.first_due_date%TYPE;
          l_sch_end_date                    cltbs_account_comp_sch.first_due_date%TYPE;
          l_sch_count                       NUMBER;
          l_int_sch_count                   NUMBER;
          l_hol_flag                        BOOLEAN;
          l_hol_rec                         cltms_holiday_periods%ROWTYPE;
          l_sch_flag                        BOOLEAN;
          l_indx                            VARCHAR2(100);
          l_tmp_idx                         PLS_INTEGER;
          l_tb_payment_schedules            clpkss_object.ty_tb_account_comp_sch;
          l_maturity_date                   cltbs_account_master.maturity_date%TYPE;
          l_bullet_schstdt                  cltbs_account_master.maturity_date%TYPE;
          l_comp_indx                       cltbs_account_components.component_name%TYPE;
          l_rec_prod                        cltm_product%rowtype;
          l_tb_schedule_date                clpks_schedules.ty_schedule_date;
          l_ignore_holiday                  cltms_product.ignore_holidays%TYPE;
          l_forward_backward                cltms_product.schedule_movement%TYPE;
          l_move_across_month               cltms_product.move_across_month%TYPE;
          l_cascade_movement                cltms_product.cascade_schedules%TYPE;
          l_tb_cltms_comp_frm               clpks_cache.ty_tb_cltms_comp_frm;
          l_amortized_frm                   cltm_product_comp_frm_expr.formula_name%TYPE;
          l_non_amort_frm                   cltm_product_comp_frm_expr.formula_name%TYPE;
          l_count_schr                      NUMBER(2);
          l_mortgage_flag                   BOOLEAN := FALSE;
          l_account_rec                     cltbs_account_master%ROWTYPE;
          FUNCTION fn_falls_in_prin_holiday(
                                             p_tb_prin_hol_perds               ty_tb_principal_holiday
                                            ,p_test_date                       cltbs_account_master.value_date%TYPE
                                            ,p_mortgage_flag                   BOOLEAN
                                            ,p_flag                OUT         BOOLEAN
                                           )
          RETURN BOOLEAN IS
                 l_indx                             PLS_INTEGER;
                 l_temp_start_date                  cltms_holiday_periods.date_to%TYPE;
                 l_temp_end_date                    cltms_holiday_periods.date_to%TYPE;
          BEGIN
            p_flag := FALSE;
            --Log#149 Starts
            IF p_test_date < p_start_redef_from
            THEN
                dbg('This date is less than the Regeneration date '||p_start_redef_from ||' So no Holiday ');
                p_flag := FALSE;
                RETURN TRUE;
            END IF;
            --Log#149 Ends
            IF p_mortgage_flag
            THEN
                p_flag := TRUE;
                RETURN TRUE;
            END IF;
            IF p_tb_prin_hol_perds.COUNT > 0
            THEN
                FOR i IN p_tb_prin_hol_perds.FIRST .. p_tb_prin_hol_perds.LAST
                LOOP
                    IF (p_test_date >= p_tb_prin_hol_perds(i).date_from AND p_test_date <= p_tb_prin_hol_perds(i).date_to)
                    THEN
                        p_flag := TRUE;
                        EXIT;
                    ELSE
                        IF (p_tb_prin_hol_perds(i).anniversary_period = 'Y')
                        THEN
                            l_temp_start_date := p_tb_prin_hol_perds(i).date_from ;
                            l_temp_end_date   := p_tb_prin_hol_perds(i).date_to;
                            LOOP
                                EXIT WHEN l_temp_end_date > p_test_date AND l_temp_start_date > p_test_date;

                                l_temp_start_date := ADD_MONTHS(l_temp_start_date,12);
                                l_temp_end_date   := ADD_MONTHS(l_temp_end_date,12);
                                dbg('looping '||l_temp_start_date||'**' ||l_temp_end_date);
                                IF (p_test_date >= l_temp_start_date AND
                                   p_test_date <= l_temp_end_date)
                                THEN
                                    p_flag := TRUE;
                                    EXIT;
                                END IF;
                            END LOOP;
                        END IF;
                        IF p_flag
                        THEN
                            EXIT;
                        END IF;
                    END IF;
                END LOOP;
            END IF;
            RETURN TRUE;
          EXCEPTION
            WHEN OTHERS THEN
              dbg('Failed in fn_falls_in_prin_holiday with '||SQLERRM);
            RETURN FALSE;
          END fn_falls_in_prin_holiday;
      BEGIN
        dbg('Total Repayment Schedules under consideration is '||p_account_rec.g_tb_components(p_component).g_tb_comp_sch.COUNT||
                   '~'||g_tb_acc_hol_perds.COUNT||'~'||p_component||'~'||p_start_redef_from);
        dbg('Checking that if this loan is linked to Morgage Group Commitment linked or not and if its then....'||
                                                                                              p_account_rec.g_acc_linkages.COUNT);
        IF p_component NOT IN (PKG_MAIN_INT,PKG_PRINCIPAL)
        THEN
            dbg('Component is neither Principal nor MAIN_INT so nothing need to be done');
            RETURN TRUE;
        END IF;
        IF p_account_rec.g_acc_linkages.COUNT > 0
        THEN
            FOR i IN p_account_rec.g_acc_linkages.FIRST .. p_account_rec.g_acc_linkages.LAST
            LOOP
                IF p_account_rec.g_acc_linkages(i).acc_linkages_row.linkage_type = 'M'
                THEN
                    l_account_rec := clpkss_cache.fn_account_master(
                                                                     p_account_rec.g_acc_linkages(i).acc_linkages_row.linked_ref_no
                                                                    ,p_account_rec.g_acc_linkages(i).acc_linkages_row.linkage_branch
                                                                    );
                    IF NVL(l_account_rec.mortgage_group,'N') = 'Y'
                    THEN
                        dbg('Mortgage Group Commitment is linked to thie LOAN, so Principal Repayment Holiday will be there');
                        l_mortgage_flag := TRUE;
                        l_indx := p_account_rec.g_tb_events_diary.FIRST;
                        WHILE l_indx IS NOT NULL
                        LOOP
                            IF p_account_rec.g_tb_events_diary(l_indx).g_events_diary.event_code='SCHR'
                            THEN
                                dbg('SCHR has fired in the Contract, so no Principal Repayment Holiday');
                                l_mortgage_flag := FALSE;
                                EXIT;
                            END IF;
                            l_indx := p_account_rec.g_tb_events_diary.NEXT(l_indx);
                        END LOOP;
                        EXIT;
                    END IF;
                END IF;
            END LOOP;
        END IF;
        IF g_tb_acc_hol_perds.COUNT > 0
        THEN
            l_indx := g_tb_acc_hol_perds.FIRST;
            WHILE l_indx IS NOT NULL
            LOOP
              IF g_tb_acc_hol_perds(l_indx).g_acc_hol_perds.holiday_periods IS NOT NULL
                 AND NVL(g_tb_acc_hol_perds(l_indx).g_action, 'I')<>'D'
              THEN
                  l_hol_rec := clpkss_cache.fn_hol_periods(g_tb_acc_hol_perds(l_indx).g_acc_hol_perds.holiday_periods);
                  IF l_hol_rec.principal_repay_hol ='Y'
                  THEN
                      l_tb_principal_holiday(l_tb_principal_holiday.COUNT +1 ) := l_hol_rec;
                  END IF;
              END IF;
              l_indx := g_tb_acc_hol_perds.NEXT(l_indx);
            END LOOP;
        END IF;
        IF l_tb_principal_holiday.COUNT > 0  OR l_mortgage_flag
        THEN
            dbg('Abhishek COUT is @ '||'~'||p_component);
            l_indx := p_account_rec.g_tb_components(p_component).g_tb_comp_sch.FIRST;
            WHILE l_indx IS NOT NULL
            LOOP
                dbg(p_account_rec.g_tb_components(p_component).g_tb_comp_sch(l_indx).g_account_comp_sch.schedule_type||'~'||
                    p_account_rec.g_tb_components(p_component).g_tb_comp_sch(l_indx).g_account_comp_sch.sch_end_date||'~'||
                    NVL(p_start_redef_from,p_account_rec.account_det.value_date)||'~'||
                    p_account_rec.g_tb_components(p_component).g_tb_comp_sch(l_indx).g_account_comp_sch.unit||'~'||
                    p_account_rec.g_tb_components(p_component).g_tb_comp_sch(l_indx).g_account_comp_sch.sch_start_date
                   );
                IF (p_account_rec.g_tb_components(p_component).g_tb_comp_sch(l_indx).g_account_comp_sch.schedule_type = 'P')
                       AND p_account_rec.g_tb_components(p_component).g_tb_comp_sch(l_indx).g_account_comp_sch.sch_end_date >=
                           NVL(p_start_redef_from,p_account_rec.account_det.value_date)
                       AND p_account_rec.g_tb_components(p_component).g_tb_comp_sch(l_indx).g_account_comp_sch.unit <> 'B'
                THEN
                  l_tb_payment_schedules(l_indx) := p_account_rec.g_tb_components(p_component).g_tb_comp_sch(l_indx);
                    p_account_rec.g_tb_components(p_component).g_tb_comp_sch.DELETE(l_indx);

                    dbg('l_tb_payment_schedules.COUNT-->>>'||l_tb_payment_schedules.COUNT);

                END IF;
                l_indx := p_account_rec.g_tb_components(p_component).g_tb_comp_sch.NEXT(l_indx);
            END LOOP;
            l_tb_temp_payment_sch.DELETE;
            l_indx := l_tb_payment_schedules.FIRST;
            WHILE l_indx IS NOT NULL
            LOOP
                dbg('l_indx is '||l_indx||'~'||l_tb_payment_schedules.COUNT);
                IF l_tb_payment_schedules(l_indx).g_account_comp_sch.unit <> 'B'
                THEN
                  l_tmp_idx := clpkss_util.fn_hash_date(l_tb_payment_schedules(l_indx).g_account_comp_sch.first_due_date);
                  dbg('Deepti, first due date is : '|| l_tb_payment_schedules(l_indx).g_account_comp_sch.first_due_date);
                  l_tb_temp_payment_sch(l_tmp_idx) := l_tb_payment_schedules(l_indx).g_account_comp_sch;
                  l_tb_payment_schedules.DELETE(l_indx);
                END IF;
                l_indx := l_tb_payment_schedules.NEXT(l_indx);
            END LOOP;
            IF p_component = PKG_MAIN_INT
            THEN
                l_tb_cltms_comp_frm := clpks_cache.fn_cltms_product_comp_frm(p_account_rec.account_det.product_code,p_component);
                l_indx := l_tb_cltms_comp_frm.FIRST;
                WHILE l_indx IS NOT NULL
                LOOP
                    dbg('Formula Name is '||l_indx);
                    IF NVL(l_tb_cltms_comp_frm(l_indx).amortized,'N') = 'Y'
                    THEN
                        l_amortized_frm := l_indx;
                    ELSE
                        l_non_amort_frm := l_indx;
                    END IF;
                    l_indx := l_tb_cltms_comp_frm.NEXT(l_indx);
                END LOOP;
            END IF;
            l_rec_prod          := clpks_cache.fn_product(p_account_rec.account_det.product_code);
            l_ignore_holiday    := NVL(l_rec_prod.ignore_holidays,'Y');
            l_forward_backward  := l_rec_prod.schedule_movement;
            l_move_across_month := l_rec_prod.move_across_month;
            l_cascade_movement  := l_rec_prod.cascade_schedules;
            l_maturity_date := NVL(p_account_rec.account_det.maturity_date, clpkss_util.pkg_eternity);
            l_indx := l_tb_temp_payment_sch.FIRST;
            dbg('l_indx IS '||l_indx||'~'||l_tb_payment_schedules.COUNT||'~'||l_tb_temp_payment_sch.COUNT);
            WHILE l_indx IS NOT NULL
            LOOP
                IF l_tb_temp_payment_sch(l_indx).unit <>'B' AND
                   (    (p_component = PKG_MAIN_INT AND NVL(l_amortized_frm,'@@@@@@@')=l_tb_temp_payment_sch(l_indx).formula_name)
                     OR (p_component = PKG_PRINCIPAL)
                   )
                THEN
                    IF l_tb_schedule_date.COUNT = 0
                    THEN
                        dbg('Calling fn_compute_schedule_dates from fn_gen_validate_schedules for components '||p_component);
                        IF NOT fn_compute_schedule_dates( l_tb_temp_payment_sch(l_indx).first_due_date
                                                         ,p_account_rec.account_det.value_date
                                                         ,l_maturity_date
                                                         ,p_account_rec.account_det.branch_code
                                                         ,p_account_rec.account_det.product_code
                                                         ,l_tb_temp_payment_sch(l_indx).frequency
                                                         ,l_tb_temp_payment_sch(l_indx).unit
                                                         ,l_tb_temp_payment_sch(l_indx).no_of_schedules
                                                         ,l_ignore_holiday
                                                         ,l_forward_backward
                                                         ,l_move_across_month
                                                         ,l_cascade_movement
                                                         ,l_tb_temp_payment_sch(l_indx).due_dates_on
                                                         ,NULL
                                                         ,l_tb_schedule_date
                                                         ,p_err_code
                                                         ,l_tb_temp_payment_sch(l_indx).schedule_type
                                                          )
                        THEN
                            dbg('Function fn_compute_schedule_dates failed - ' ||SQLERRM);
                            p_err_code  := 'CL-PRHL-01;';
                            p_err_param := NULL;
                            ovpkss.pr_appendTbl(p_err_code,p_err_param);
                            RETURN FALSE;
                        END IF;
                        dbg('Total number of l_tb_schedule_date.COUNT is '||l_tb_schedule_date.COUNT);
                    END IF;
                    l_int_sch_count := 0;
                    l_sch_flag   := FALSE;
                    l_sch_count  := 0;
                    l_first_date := l_tb_temp_payment_sch(l_indx).first_due_date;
                    IF l_indx = l_tb_temp_payment_sch.FIRST
                    THEN
                        l_sch_st_date := l_tb_temp_payment_sch(l_indx).sch_start_date;
                        dbg('l_sch_st_date'||l_sch_st_date);
                    END IF;
                    l_tmp_idx := clpkss_util.fn_hash_date(l_first_date);
                    l_tb_payment_schedules('P'||lpad(l_tmp_idx,10,'0')).g_account_comp_sch := l_tb_temp_payment_sch(l_indx);
                    l_tb_payment_schedules('P'||lpad(l_tmp_idx,10,'0')).g_action := 'I';
                    dbg('l_indx IS '||l_indx||'~'||l_tb_payment_schedules.COUNT||'~'||'P'||lpad(l_tmp_idx,10,'0'));
                    l_tmp_idx := l_tb_temp_payment_sch.NEXT(l_indx);
                    IF l_tmp_idx IS NULL
                    THEN
                        l_next_date := l_maturity_date;
                    ELSE
                        l_next_date := l_tb_temp_payment_sch(l_tmp_idx).first_due_date;
                    END IF;
                    FOR i IN l_tb_schedule_date.FIRST .. l_tb_schedule_date.LAST
                    LOOP
                        IF l_tb_schedule_date(i) >= l_tb_temp_payment_sch(l_indx).first_due_date
                         AND l_tb_schedule_date(i) < l_next_date
                        THEN
                            dbg('Date is :'||l_tb_schedule_date(i));
                            IF NOT fn_falls_in_prin_holiday(
                                                             l_tb_principal_holiday
                                                            ,l_tb_schedule_date(i)
                                                            ,l_mortgage_flag
                                                            ,l_hol_flag
                                                            )
                            THEN
                                dbg('Failed in fn_falls_in_prin_holiday');
                                p_err_code  := 'CL-PRHL-01;';
                                p_err_param := NULL;
                                ovpkss.pr_appendTbl(p_err_code,p_err_param);
                                RETURN FALSE;
                            END IF;
                            IF NOT l_hol_flag
                            THEN
                                dbg('Abhishek p_component is '||p_component||'~'||l_int_sch_count);
                                IF p_component = PKG_MAIN_INT AND l_int_sch_count > 0
                                THEN
                                    l_tmp_idx := clpkss_util.fn_hash_date(l_first_date);
                                    IF NOT l_sch_flag
                                    THEN
                                        l_tb_payment_schedules.DELETE('P'||lpad(l_tmp_idx,10,'0'));
                                    END IF;
                                    l_tb_payment_schedules('P'||lpad(l_tmp_idx,10,'0')).g_action := 'I';
                                    l_tb_payment_schedules('P'||lpad(l_tmp_idx,10,'0')).g_account_comp_sch := l_tb_temp_payment_sch(l_indx);
                                    l_tb_payment_schedules('P'||lpad(l_tmp_idx,10,'0')).g_account_comp_sch.no_of_schedules := l_int_sch_count;
                                    l_tb_payment_schedules('P'||lpad(l_tmp_idx,10,'0')).g_account_comp_sch.first_due_date := l_first_date;
                                    l_tb_payment_schedules('P'||lpad(l_tmp_idx,10,'0')).g_account_comp_sch.sch_start_date := l_sch_st_date;
                                    l_tb_payment_schedules('P'||lpad(l_tmp_idx,10,'0')).g_account_comp_sch.sch_end_date := l_sch_end_date;
                                    l_tb_payment_schedules('P'||lpad(l_tmp_idx,10,'0')).g_account_comp_sch.formula_name := l_non_amort_frm;
                                    dbg('Abhishek l_indx IS '||l_indx||'~'||l_tb_payment_schedules.COUNT||'~'||'P'||lpad(l_tmp_idx,10,'0')||'~'||l_sch_end_date);
                                    l_first_date := l_tb_schedule_date(i);
                                    dbg('l_first_date is @'||l_first_date);
                                    l_int_sch_count := 0;
                                    l_sch_flag := TRUE;
                                    l_sch_st_date := l_sch_end_date;
                                END IF;
                                    l_sch_count := l_sch_count + 1;
                                    l_sch_end_date := l_tb_schedule_date(i);
                            ELSE
                                IF l_sch_count > 0
                                THEN
                                  l_tmp_idx := clpkss_util.fn_hash_date(l_first_date);
                                  IF NOT l_sch_flag
                                  THEN
                                      l_tb_payment_schedules.DELETE('P'||lpad(l_tmp_idx,10,'0'));
                                  END IF;
                                  l_tb_payment_schedules('P'||lpad(l_tmp_idx,10,'0')).g_action := 'I';
                                  l_tb_payment_schedules('P'||lpad(l_tmp_idx,10,'0')).g_account_comp_sch := l_tb_temp_payment_sch(l_indx);
                                  l_tb_payment_schedules('P'||lpad(l_tmp_idx,10,'0')).g_account_comp_sch.no_of_schedules := l_sch_count;
                                  l_tb_payment_schedules('P'||lpad(l_tmp_idx,10,'0')).g_account_comp_sch.first_due_date := l_first_date;
                                  l_tb_payment_schedules('P'||lpad(l_tmp_idx,10,'0')).g_account_comp_sch.sch_start_date := l_sch_st_date;
                                  l_tb_payment_schedules('P'||lpad(l_tmp_idx,10,'0')).g_account_comp_sch.sch_end_date := l_sch_end_date;
                                  l_sch_st_date := l_sch_end_date;
                                  dbg('Abhishek l_indx IS '||l_indx||'~'||l_tb_payment_schedules.COUNT||'~'||'P'||lpad(l_tmp_idx,10,'0')||'~'||l_sch_end_date);
                                  IF p_component = PKG_MAIN_INT
                                  THEN
                                     l_first_date := l_tb_schedule_date(i);
                                  ELSE
                                      l_tmp_idx := l_tb_schedule_date.NEXT(i);
                                      IF l_tmp_idx IS NOT NULL
                                      THEN
                                         l_first_date := l_tb_schedule_date(l_tmp_idx);
                                      ELSE
                                          l_first_date := NULL;
                                      END IF;
                                  END IF;
                                  dbg('l_first_date is #'||l_first_date);
                                  dbg('Abhishek '||l_sch_count||'~'||l_first_date);
                                  l_sch_count := 0;
                                  l_sch_flag := TRUE;
                                ELSE
                                  IF p_component <> PKG_MAIN_INT
                                  THEN
                                      l_tmp_idx := l_tb_schedule_date.NEXT(i);
                                      IF l_tmp_idx IS NOT NULL
                                      THEN
                                         l_first_date := l_tb_schedule_date(l_tmp_idx);
                                      ELSE
                                          l_first_date := NULL;
                                          IF NOT l_sch_flag
                                          THEN
                                              l_tb_payment_schedules.DELETE;
                                          END IF;
                                          dbg('Last Schedule has fallen on Holiday');
                                      END IF;
                                  END IF;
                                END IF;
                                IF p_component = PKG_MAIN_INT
                                THEN
                                    l_int_sch_count := l_int_sch_count + 1;
                                    l_sch_end_date  := l_tb_schedule_date(i);
                                END IF;
                            END IF;
                        END IF;
                    END LOOP;
                    dbg('Abhishek1');
                    IF     ((l_sch_flag AND l_sch_count > 0)OR( p_component = PKG_MAIN_INT AND l_int_sch_count > 0))
                       AND l_first_date IS NOT NULL
                    THEN
                      l_tmp_idx := clpkss_util.fn_hash_date(l_first_date);
                      l_tb_payment_schedules('P'||lpad(l_tmp_idx,10,'0')).g_action := 'I';
                      l_tb_payment_schedules('P'||lpad(l_tmp_idx,10,'0')).g_account_comp_sch := l_tb_temp_payment_sch(l_indx);
                      l_tb_payment_schedules('P'||lpad(l_tmp_idx,10,'0')).g_account_comp_sch.no_of_schedules := l_sch_count;
                      l_tb_payment_schedules('P'||lpad(l_tmp_idx,10,'0')).g_account_comp_sch.first_due_date := l_first_date;
                      l_tb_payment_schedules('P'||lpad(l_tmp_idx,10,'0')).g_account_comp_sch.sch_start_date := l_sch_st_date;
                      l_tb_payment_schedules('P'||lpad(l_tmp_idx,10,'0')).g_account_comp_sch.sch_end_date := l_sch_end_date;
                      l_sch_st_date := l_sch_end_date;
                      dbg('schedule Start date is '||l_sch_st_date);
                      IF l_int_sch_count > 0
                      THEN
                          l_tb_payment_schedules('P'||lpad(l_tmp_idx,10,'0')).g_account_comp_sch.no_of_schedules := l_int_sch_count;
                          l_tb_payment_schedules('P'||lpad(l_tmp_idx,10,'0')).g_account_comp_sch.formula_name := l_non_amort_frm;
                      END IF;
                      dbg('Abhishek Last is '||l_sch_count||'~'||l_first_date||'~'||l_tmp_idx||'~'||'P'||lpad(l_tmp_idx,10,'0')||'~'||l_sch_end_date);
                    END IF;
                    dbg('Abhishek2');
                ELSIF l_tb_temp_payment_sch(l_indx).unit <>'B' AND
                      (p_component = PKG_MAIN_INT AND NVL(l_amortized_frm,'@@@@@@@')<>l_tb_temp_payment_sch(l_indx).formula_name)
                THEN
                      l_tb_payment_schedules('P'||lpad(l_indx,10,'0')).g_action := 'I';
                      l_tb_payment_schedules('P'||lpad(l_indx,10,'0')).g_account_comp_sch := l_tb_temp_payment_sch(l_indx);
                      l_sch_st_date := l_tb_temp_payment_sch(l_indx).sch_end_date;
                END IF;
                l_tb_schedule_date.DELETE;
                l_indx := l_tb_temp_payment_sch.NEXT(l_indx);

            END LOOP;
            l_sch_st_date := NVL(l_sch_st_date,p_account_rec.account_det.value_date);
            IF l_tb_payment_schedules.COUNT > 0
            THEN
                l_bullet_schstdt := l_tb_payment_schedules(l_tb_payment_schedules.LAST).g_account_comp_sch.sch_end_date;
            ELSE
                l_bullet_schstdt := l_sch_st_date;
            END IF;
            dbg('l_sch_st_date'||l_sch_st_date);
            l_indx := p_account_rec.g_tb_components(p_component).g_tb_comp_sch.FIRST;
            WHILE l_indx IS NOT NULL
            LOOP
                IF (p_account_rec.g_tb_components(p_component).g_tb_comp_sch(l_indx).g_account_comp_sch.schedule_type = 'P')
                       AND p_account_rec.g_tb_components(p_component).g_tb_comp_sch(l_indx).g_account_comp_sch.sch_end_date >=
                           NVL(p_start_redef_from,l_maturity_date)
                THEN
                    dbg('This schedule is for UNIT type'||p_account_rec.g_tb_components(p_component).g_tb_comp_sch(l_indx).g_account_comp_sch.unit);
                    dbg('Old and New Bullet '||p_account_rec.g_tb_components(p_component).g_tb_comp_sch(l_indx).g_account_comp_sch.sch_start_date||'~'
                         ||l_bullet_schstdt
                       );
                    IF p_account_rec.g_tb_components(p_component).g_tb_comp_sch(l_indx).g_account_comp_sch.sch_start_date
                       <> l_bullet_schstdt
                    THEN
                       p_account_rec.g_tb_components(p_component).g_tb_comp_sch(l_indx).g_account_comp_sch.sch_start_date :=  l_bullet_schstdt;
                    END IF;
                END IF;
                l_indx := p_account_rec.g_tb_components(p_component).g_tb_comp_sch.NEXT(l_indx);
            END LOOP;
            l_indx := l_tb_payment_schedules.FIRST;
            WHILE l_indx IS NOT NULL
            LOOP
                p_account_rec.g_tb_components(p_component).g_tb_comp_sch(l_indx) := l_tb_payment_schedules(l_indx);
                l_indx := l_tb_payment_schedules.NEXT(l_indx);
            END LOOP;
        END IF;
        dbg('l_indx IS '||l_indx||'~'||l_tb_payment_schedules.COUNT);
        dbg('p_account_rec.g_tb_components(p_component).g_tb_comp_sch.COUNT'||p_account_rec.g_tb_components(p_component).g_tb_comp_sch.COUNT);
        dbg('p_component'||p_component);
        RETURN TRUE;
        EXCEPTION
           WHEN OTHERS THEN
            dbg('Failed in fn_regen_compsch_prinhol with '||SQLERRM);
            p_err_code  := 'CL-PRHL-01;';
            p_err_param := NULL;
            ovpkss.pr_appendTbl(p_err_code,p_err_param);
            RETURN FALSE;
        END fn_regen_compsch_prinhol;
    --Log#141 Abhishek Ranjan for Principal Repyament Holiday 14.09.2009 Ends

BEGIN
   --pkg Body
   -- Phase II NLS Changes start
   Pkg_Main_Int  := Clpks_Nls.Main_Int;
   Pkg_Principal := Clpks_Nls.Principal;
   -- Phase II NLS Changes end
   Pkg_Interest_Rate := Clpks_Nls.Interest_Rate; --log#119 changes
 --Sfr#1966 kernel11.1 changes starts
   IF clpkss_context.g_module_code='CI' THEN
   Pkg_Main_Int  :='PROFIT';
   Clpks_Nls.Main_Int := 'PROFIT';
   Clpkss_Nls.Main_Int := 'PROFIT';
Pkg_Interest_Rate:='PROFIT_RATE';
   --Sfr#1966 kernel11.1 changes ends
   END IF;

END;
--START AND END Log#117
