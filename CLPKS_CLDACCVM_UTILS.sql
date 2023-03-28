CREATE OR REPLACE PACKAGE BODY "CLPKS_CLDACCVM_UTILS" AS
   /*-----------------------------------------------------------------------------------------------------
   **
   ** File Name  : clpks_cldaccvm_utils.sql
   **
   ** Module     : Retail Lending
   **
   ** This source is part of the Oracle FLEXCUBE Software System and is copyrighted by Oracle Financial Services Software Limited.
   **
   **
   ** All rights reserved. No part of this work may be reproduced, stored in a retrieval system,
   ** adopted or transmitted in any form or by any means, electronic, mechanical, photographic,
   ** graphic, optic recording or otherwise, translated in any language or computer language,
   ** without the prior written permission of Oracle Financial Services Software Limited.
   **
   ** Oracle Financial Services Software Limited.
   ** 10-11, SDF I, SEEPZ, Andheri (East),
   ** Mumbai - 400 096.
   ** India
   ** Copyright ¿ 2008 - 2013 Oracle Financial Services Software Limited. All rights reserved.
   -------------------------------------------------------------------------------------------------------
   CHANGE HISTORY

   SFR Number         :
   Changed By         :
   Change Description :

      **
      **    Log Number        : 1
      **    Modified By       : Pankaj Sehgal
      **    Modified On       : 18-Mar-2010
      **    Modified Reason   : FC 11.1 Dev Accelarating/Decelerating EMI changes
      **    Search String     : Log#1

      **    Log Number        : 2
      **    Modified By       : Abhinav Bhardwaj
      **    Modified On       : 05-APR-2010
      **    Modified Reason   : Retro Changes included--Schedule Affected flag not getting set if comp_sch is changed.
      **    Retro Reference   : FC10_IMPSUPP/VRBVIECLS/SFR-49 !VeenaH
      **    Search String     : Log#2A

      **    Log Number        : 3
      **    Modified By       : Anuradha.H
      **    Modified On       : 07-Apr-2010
      **    Modified Reason   : FCUBS 11.1 MB0403 Repayment from guarantor a/c
      **    Search String     : Log#3

      **    Log Number        : 4
      **    Modified By       : Anubhav Jain
      **    Modified On       : 12-Apr-2010
      **    Modified Reason   : Centralization changes
      **    Search String     : 11.1 centralization changes

   **    Log Number          : 5
   **    Modified By         : Praveen Kumar D
   **    Modified On         : 10-May-2010
   **    Modified Reason     : FCUBS 11.1 : 9NT1368 - ITR1 - SFR#1692
   **    Search String       : Log#5

   **    Log Number          : 6
   **    Modified By         : Sharan Upadhyay
   **    Modified On         : 10-May-2010
   **    Modified Reason     : FCUBS 11.1 : 9NT1368 - ITR1 - SFR#2828
   **    Search String       : SFR#2826

   **    Log Number          : 7
   **    Modified By         : Abhishek jain
   **    Modified On         : 5-June-2010
   **    Modified Reason     : FCUBS 11.1 : ITR1 - SFR#4522
   **    Search String       : SFR#4522

   **    Log Number          : 8
   **    Modified By         : Abhishek jain
   **    Modified On         : 9-June-2010
   **    Modified Reason     : FCUBS 11.1 : ITR1 - SFR#4678
   **    Search String       : SFR#4678

   **    Log Number          : 9
   **    Modified By         : Abhishek jain
   **    Modified On         : 14-June-2010
   **    Modified Reason     : FCUBS 11.1 : ITR1 - SFR#3568
   **    Search String       : SFR#3568

   **    Log Number          : 10
   **    Modified By         : Arun R Nath
   **    Modified On         : 15-June-2010
   **    Modified Reason     : Code added to handle user defined exceptions..
   **    Search String       : FCUBS ITR1 SFR#3568

   **    Log Number          : 11
   **    Modified By         : S. ChandraMohan
   **    Modified On         : 15-June-2010
   **    Modified Reason     : FCUBS 11.1 : ITR1 - SFR#3543
   **    Search String       : FCUBS11.1:9NT1368 - SFR 3543
   **
   **    Log Number          :12
   **    Modified By         : Anub Mathew
   **    Modified On         : 30-June-2010/06-July-2010
   **    Modified Reason     : FCUBS11.1 9NT1368 SFR#6141
   **    Search String       : Log#12
   **
   **    Log Number          : 13
   **    Modified By         : Arun R Nath/ Satyakam Jena
   **    Modified On         : 03-Jul-2010
   **    Modified Reason     : Routing the call for Create Amendment and Spilt Schedules
                               from fn_subsys_pickup..
   **    Search String       : FCUBS11.1 ITR1 SFR#5950
   **
   **    Log Number          : 14
   **    Modified By         : Satyakam Jena
   **    Modified On         : 04-Aug-2010
   **    Modified Reason     : FCUBS11.1 ITR2 SFR#1085
   **    Search String       : FCUBS11.1 ITR2 SFR#1085
   **
   **    Log Number          : 15
   **    Modified By           : Jayanth
   **    Modified On           : 23-Feb-2011
   **    Modified Reason       : FCUBS11.1INFRA :: Events Screens Security Changes: The block for cltb_event_remarks is a multiple entry block.
                             In the code, it was being handled as a single entry block. Added a cursor to select from the table and populate the
                             block in the appropriate way.
   **    Search String         : FCUBS11.1INFRA Events Screens Security Changes

   **    Modified By           : Abhinav Bhardwaj
   **    Modified On           : 15-May-2011
   **    Modified Reason       : To handle multiple amendment before authorization
   **    Search String         : Kernel 11.3_RET_SFR_12401757

      **    Log Number          : 17
     **     Changed By         : Muralidharan R
     **  Modified on        :27-Aug-2011
     **  Change Reason      :  9NT1474 Kernel 11.3 patchset ext defect no FC11.1_IMPSUPP_483
	                            Changes done to allow delink of commitment linkage during VAMI
     **  Search string      :  RONBTR#FCC11.1#SFR483            //Pls refer Log no 18 also for this issue

**    Log Number          : 18
**     Changed By         : Muralidharan R
**  Modified on        :27-Aug-2011
**  Change Reason      :  9NT1474 Kernel 11.3 patchset ext defect no FC11.1_IMPSUPP_483
					 For non revolving commitment dlnk event should fire , if commitment linkages is removed during VAMI
**  Search string      :  Log#18 Changes

**    Changed By         : Rahul Gopinathan
**    Modified On        : 08-Aug-2012
**    Modified Reason    : If a future dated vami is done and authorised and the user wants to reverse the same, code added for the same, to delete the authorised future dated vami
**    Search String      : ASKARI-UP_14397581

**    Changed By         : ME - REGION
**    Modified On        : 01-Jul-2013
**    Modified Reason    : changed variable from number(3) to number
**    Search String      : NRAKAEFCC0028

    **   Modified By         : Priyanka S
    **   Modified On         : 22-Jan-2018
    **   Modified Reason     : Changes to set Rate change flag only if a UDE attached to an interest component is changed.
							   This will make sure that recalc won't happen because of changes to penal/provisioning etc.
	**   Search Tag          : 3-16663240851
	**   Referred Bugs       : 20307828:Fix Propagation to 12.1.0 ~ Retro from 17486709

   -------------------------------------------------------------------------------------------------------
   */
   Pkg_Principal      Cltb_Text_Desc.Eng_Text%TYPE;
   Pkg_Main_Int       Cltbs_Account_Schedules.Component_Name%TYPE;
   Pkg_Operation_Code Gwtm_Fcj_Functions.Operation_Code%TYPE;

   TYPE Ty_Rec_Vami_Det IS RECORD(
      l_Effdate                  DATE,
      l_Princchanged             VARCHAR2(1),
      l_Matdatechanged           VARCHAR2(1),
      l_Ratecodechanged          VARCHAR2(1),
      l_Ratechanged              VARCHAR2(1),
      l_Residual_Amt_Changed     VARCHAR2(1),
      l_Sub_Residual_Amt_Changed VARCHAR2(1),
      l_Schaffected              VARCHAR2(1));

   TYPE Ty_Tb_Rec_Vami_Rec IS TABLE OF Ty_Rec_Vami_Det INDEX BY BINARY_INTEGER;
   l_Chg_Vami Gwpks_Cl_Savevami.Ty_Tb_Rec_Vami_Rec;

   PROCEDURE Dbg(p_Msg VARCHAR2) IS
      l_Msg VARCHAR2(32767);
   BEGIN
      l_Msg := 'Clpks_Cldaccvm_Utils ==>' || p_Msg;
      Debug.Pr_Debug('CL', l_Msg);
   END Dbg;

   PROCEDURE Pr_Log_Error(p_Function_Id IN VARCHAR2
                         ,p_Source      VARCHAR2
                         ,p_Err_Code    VARCHAR2
                         ,p_Err_Params  VARCHAR2) IS
   BEGIN
      Cspks_Req_Utils.Pr_Log_Error(p_Source, p_Function_Id, p_Err_Code, p_Err_Params);
   END Pr_Log_Error;

   FUNCTION Fn_Check_Mandatory(p_Source           IN VARCHAR2
                              ,p_Source_Operation IN VARCHAR2
                              ,p_Function_Id      IN VARCHAR2
                              ,p_Action_Code      IN VARCHAR2
                              ,p_Child_Function   IN VARCHAR2
                              ,p_Pk_Or_Full       IN VARCHAR2 DEFAULT 'FULL'
                              ,p_Cldaccvm         IN Clpks_Cldaccvm_Main.Ty_Cldaccvm
                              ,p_Err_Code         IN OUT VARCHAR2
                              ,p_Err_Params       IN OUT VARCHAR2) RETURN BOOLEAN IS

      l_Blk VARCHAR2(50);
      l_Fld VARCHAR2(50);
   BEGIN
      Dbg('In Fn_Check_Mandatory..');

      IF Substr(p_Action_Code, 1, Length(Cspks_Req_Global.p_Enrich)) = Cspks_Req_Global.p_Enrich OR p_Action_Code = Cspks_Req_Global.p_Prddflt THEN
         l_Blk := 'CLTBS_ACCOUNT_MASTER';
         l_Fld := 'CLTBS_ACCOUNT_MASTER.PRODUCT_CODE';
         IF p_Cldaccvm.v_Cltbs_Account_Master.Product_Code IS NULL THEN
            Dbg('Mandatory column PRODUCT_CODE cannot be Null');
            Pr_Log_Error(p_Function_Id, p_Source, 'ST-MAND-001', '@' || l_Fld);
         END IF;
         l_Fld := 'CLTBS_ACCOUNT_MASTER.CUSTOMER_ID';
         IF p_Cldaccvm.v_Cltbs_Account_Master.Customer_Id IS NULL THEN
            Dbg('Mandatory column CUSTOMER_ID cannot be Null');
            Pr_Log_Error(p_Function_Id, p_Source, 'ST-MAND-001', '@' || l_Fld);
         END IF;
         l_Fld := 'CLTBS_ACCOUNT_MASTER.AMOUNT_FINANCED';
         IF p_Cldaccvm.v_Cltbs_Account_Master.Amount_Financed IS NULL THEN
            Dbg('Mandatory column AMOUNT_FINANCED cannot be Null');
            Pr_Log_Error(p_Function_Id, p_Source, 'ST-MAND-001', '@' || l_Fld);
         END IF;

         l_Fld := 'CLTBS_ACCOUNT_MASTER.CURRENCY';
         IF p_Cldaccvm.v_Cltbs_Account_Master.Currency IS NULL THEN
            Dbg('Mandatory column CURRENCY cannot be Null');
            Pr_Log_Error(p_Function_Id, p_Source, 'ST-MAND-001', '@' || l_Fld);
         END IF;
      END IF;

      Dbg('Returning  Success From Fn_Check_Mandatory..');
      RETURN TRUE;
   EXCEPTION
      WHEN OTHERS THEN
         Debug.Pr_Debug('**', 'In When Others of Clpks_Cldaccvm_Utils.Fn_Check_Mandatory ..');
         Debug.Pr_Debug('**', SQLERRM);
         p_Err_Code   := 'ST-OTHR-001';
         p_Err_Params := NULL;
         RETURN FALSE;
   END Fn_Check_Mandatory;

   FUNCTION Fn_Process_Charges(p_Source           IN VARCHAR2
                              ,p_Source_Operation IN VARCHAR2
                              ,p_Function_Id      IN VARCHAR2
                              ,p_Action_Code      IN VARCHAR2
                              ,p_Cldaccvm         IN Clpks_Cldaccvm_Main.Ty_Cldaccvm
                              ,p_Account_Obj      IN OUT Clpkss_Object.Ty_Rec_Account
                              ,p_Err_Code         IN OUT VARCHAR2
                              ,p_Err_Params       IN OUT VARCHAR2) RETURN BOOLEAN IS

      l_Eff_Date           DATE;
      l_Parents_List       VARCHAR2(32767);
      l_Parents_Format     VARCHAR2(32767);
      l_Ts_Tag_Names       VARCHAR2(32767);
      l_Ts_Tag_Values      VARCHAR2(32767);
      l_Ts_Tag_Format      VARCHAR2(32767);
      l_Ts_Clob_Tag_Names  CLOB;
      l_Ts_Clob_Tag_Values CLOB;
      l_Ts_Clob_Tag_Format CLOB;
      l_Res_Parents_List   VARCHAR2(32767);
      l_Res_Parents_Format VARCHAR2(32767);
      l_Res_Ts_Tag_Names   VARCHAR2(32767);
      l_Res_Ts_Tag_Values  VARCHAR2(32767);
      l_Err_Tbl            Ovpks.Tbl_Error;
      Error_Exception EXCEPTION;
      l_Accno       Cltb_Account_Apps_Master.Account_Number%TYPE;
      l_Is_Tag_Clob VARCHAR2(1);
      --l_Account_Obj               Clpkss_Object.Ty_Rec_Account;
      p_Roll_Obj                  Clpkss_Rollover_Object.Ty_Rec_Rollover;
      l_Tb_Chrg                   Clpkss_Element_Types.Ty_Tb_Schedules;
      l_Vamb_Esn                  Cltbs_Account_Master.Latest_Esn%TYPE;
      l_Tb_Cltms_Product_Comp_Frm Clpkss_Cache.Ty_Tb_Cltms_Comp_Frm;
      l_Index                     PLS_INTEGER;
      l_Prod_Comp                 Cltms_Product_Components%ROWTYPE;
      l_Rec_Schedule              Cltbs_Account_Schedules%ROWTYPE;
      --Log#11 Start
      CURSOR Cr_Comp_Schedules(p_Act_No Cltbs_Account_Master.Account_Number%TYPE, p_Brn_Code Cltbs_Account_Master.Branch_Code%TYPE) IS
         SELECT x.*, x.ROWID
         FROM   Cltbs_Account_Schedules x
         WHERE  x.Account_Number = p_Act_No
         AND    x.Branch_Code = p_Brn_Code
         AND    x.Component_Name = Pkg_Main_Int;

      TYPE Ty_Comp_Schedules IS TABLE OF Cr_Comp_Schedules%ROWTYPE INDEX BY PLS_INTEGER;

      l_Comp_Schedules    Cr_Comp_Schedules%ROWTYPE;
      l_Tb_Comp_Schedules Ty_Comp_Schedules;
      l_Amt_Due           PLS_INTEGER;
   BEGIN
      Dbg('In Fn_Process_Charges');
      l_Eff_Date := p_Cldaccvm.v_Cltbs_Account_Vamd.Effective_Date;

      IF NOT Clpkss_Ude.Fn_Resolve_Rates(p_Account_Obj
                                        ,p_Account_Obj.Account_Det.Value_Date
                                        ,Nvl(p_Account_Obj.Account_Det.Maturity_Date, Clpkss_Util.Pkg_Eternity)
                                        ,Gwpkss_Cl_Savevami.g_Effective_Date
                                        ,p_Err_Code
                                        ,p_Err_Params) THEN
         Dbg('clpkss_ude.fn_resolve_rates Failed :-(' || p_Err_Code || p_Err_Params);
         RETURN FALSE;
      END IF;

      IF Cr_Comp_Schedules%ISOPEN THEN
         CLOSE Cr_Comp_Schedules;
      END IF;

      --l_Account_Obj.Account_Det.Account_Number := p_Account_Obj.Account_Det.Account_Number;
      --l_Account_Obj.Account_Det.Product_Code   := p_Account_Obj.Account_Det.Product_Code;

      OPEN Cr_Comp_Schedules(p_Account_Obj.Account_Det.Account_Number, p_Account_Obj.Account_Det.Branch_Code);

      FETCH Cr_Comp_Schedules BULK COLLECT
         INTO l_Tb_Comp_Schedules;
      CLOSE Cr_Comp_Schedules;

      Dbg(' l_tb_comp_schedules.COUNT  ::' || l_Tb_Comp_Schedules.COUNT);
      IF l_Tb_Comp_Schedules.COUNT > 0 THEN
         FOR s IN l_Tb_Comp_Schedules.FIRST .. l_Tb_Comp_Schedules.LAST LOOP
            l_Comp_Schedules := l_Tb_Comp_Schedules(s);
            l_Amt_Due := Clpks_Util.Fn_Hash_Date(l_Comp_Schedules.Schedule_Due_Date);
            p_Account_Obj.g_Tb_Components(Pkg_Main_Int).g_Tb_Amt_Due(l_Amt_Due).g_Record_Rowid := l_Comp_Schedules.ROWID;
            p_Account_Obj.g_Tb_Components(Pkg_Main_Int).g_Tb_Amt_Due(l_Amt_Due).g_Amount_Due.Account_Number := p_Account_Obj.Account_Det.Account_Number;
            p_Account_Obj.g_Tb_Components(Pkg_Main_Int).g_Tb_Amt_Due(l_Amt_Due).g_Amount_Due.Branch_Code := p_Account_Obj.Account_Det.Branch_Code;
            p_Account_Obj.g_Tb_Components(Pkg_Main_Int).g_Tb_Amt_Due(l_Amt_Due).g_Amount_Due.Component_Name := l_Comp_Schedules.Component_Name;
            p_Account_Obj.g_Tb_Components(Pkg_Main_Int).g_Tb_Amt_Due(l_Amt_Due).g_Amount_Due.Formula_Name := l_Comp_Schedules.Formula_Name;
            p_Account_Obj.g_Tb_Components(Pkg_Main_Int).g_Tb_Amt_Due(l_Amt_Due).g_Amount_Due.Schedule_Type := l_Comp_Schedules.Schedule_Type;
            p_Account_Obj.g_Tb_Components(Pkg_Main_Int).g_Tb_Amt_Due(l_Amt_Due).g_Amount_Due.Schedule_St_Date := l_Comp_Schedules.Schedule_St_Date;
            p_Account_Obj.g_Tb_Components(Pkg_Main_Int).g_Tb_Amt_Due(l_Amt_Due).g_Amount_Due.Schedule_Due_Date := l_Comp_Schedules.Schedule_Due_Date;
            p_Account_Obj.g_Tb_Components(Pkg_Main_Int).g_Tb_Amt_Due(l_Amt_Due).g_Amount_Due.Schedule_No := l_Comp_Schedules.Schedule_No;
            p_Account_Obj.g_Tb_Components(Pkg_Main_Int).g_Tb_Amt_Due(l_Amt_Due).g_Amount_Due.List_Days := l_Comp_Schedules.List_Days;
            p_Account_Obj.g_Tb_Components(Pkg_Main_Int).g_Tb_Amt_Due(l_Amt_Due).g_Amount_Due.List_Avg_Amt := l_Comp_Schedules.List_Avg_Amt;
            p_Account_Obj.g_Tb_Components(Pkg_Main_Int).g_Tb_Amt_Due(l_Amt_Due).g_Amount_Due.Grace_Days := l_Comp_Schedules.Grace_Days;
            p_Account_Obj.g_Tb_Components(Pkg_Main_Int).g_Tb_Amt_Due(l_Amt_Due).g_Amount_Due.Orig_Amount_Due := l_Comp_Schedules.Orig_Amount_Due;
            p_Account_Obj.g_Tb_Components(Pkg_Main_Int).g_Tb_Amt_Due(l_Amt_Due).g_Amount_Due.Amount_Due := l_Comp_Schedules.Amount_Due;
            p_Account_Obj.g_Tb_Components(Pkg_Main_Int).g_Tb_Amt_Due(l_Amt_Due).g_Amount_Due.Adj_Amount := l_Comp_Schedules.Adj_Amount;
            p_Account_Obj.g_Tb_Components(Pkg_Main_Int).g_Tb_Amt_Due(l_Amt_Due).g_Amount_Due.Amount_Settled := l_Comp_Schedules.Amount_Settled;
            p_Account_Obj.g_Tb_Components(Pkg_Main_Int).g_Tb_Amt_Due(l_Amt_Due).g_Amount_Due.Amount_Overdue := l_Comp_Schedules.Amount_Overdue;
            p_Account_Obj.g_Tb_Components(Pkg_Main_Int).g_Tb_Amt_Due(l_Amt_Due).g_Amount_Due.Accrued_Amount := l_Comp_Schedules.Accrued_Amount;
            p_Account_Obj.g_Tb_Components(Pkg_Main_Int).g_Tb_Amt_Due(l_Amt_Due).g_Amount_Due.Settlement_Ccy := l_Comp_Schedules.Settlement_Ccy;
            p_Account_Obj.g_Tb_Components(Pkg_Main_Int).g_Tb_Amt_Due(l_Amt_Due).g_Amount_Due.Lcy_Equivalent := l_Comp_Schedules.Lcy_Equivalent;
            p_Account_Obj.g_Tb_Components(Pkg_Main_Int).g_Tb_Amt_Due(l_Amt_Due).g_Amount_Due.Dly_Avg_Amt := l_Comp_Schedules.Dly_Avg_Amt;
            p_Account_Obj.g_Tb_Components(Pkg_Main_Int).g_Tb_Amt_Due(l_Amt_Due).g_Amount_Due.Emi_Amount := l_Comp_Schedules.Emi_Amount;
            p_Account_Obj.g_Tb_Components(Pkg_Main_Int).g_Tb_Amt_Due(l_Amt_Due).g_Amount_Due.Schedule_Flag := l_Comp_Schedules.Schedule_Flag;
            p_Account_Obj.g_Tb_Components(Pkg_Main_Int).g_Tb_Amt_Due(l_Amt_Due).g_Amount_Due.Waiver_Flag := l_Comp_Schedules.Waiver_Flag;
            p_Account_Obj.g_Tb_Components(Pkg_Main_Int).g_Tb_Amt_Due(l_Amt_Due).g_Amount_Due.Event_Seq_No := l_Comp_Schedules.Event_Seq_No;
            p_Account_Obj.g_Tb_Components(Pkg_Main_Int).g_Tb_Amt_Due(l_Amt_Due).g_Amount_Due.Schedule_Linkage := l_Comp_Schedules.Schedule_Linkage;
            p_Account_Obj.g_Tb_Components(Pkg_Main_Int).g_Tb_Amt_Due(l_Amt_Due).g_Amount_Due.Capitalized := l_Comp_Schedules.Capitalized;
            p_Account_Obj.g_Tb_Components(Pkg_Main_Int).g_Tb_Amt_Due(l_Amt_Due).g_Amount_Due.Process_No := l_Comp_Schedules.Process_No;
            p_Account_Obj.g_Tb_Components(Pkg_Main_Int).g_Tb_Amt_Due(l_Amt_Due).g_Amount_Due.Amount_Readjusted := l_Comp_Schedules.Amount_Readjusted;
            p_Account_Obj.g_Tb_Components(Pkg_Main_Int).g_Tb_Amt_Due(l_Amt_Due).g_Amount_Due.Mora_Int := l_Comp_Schedules.Mora_Int;
            p_Account_Obj.g_Tb_Components(Pkg_Main_Int).g_Tb_Amt_Due(l_Amt_Due).g_Amount_Due.Last_Pmnt_Value_Date := l_Comp_Schedules.Last_Pmnt_Value_Date;
            p_Account_Obj.g_Tb_Components(Pkg_Main_Int).g_Tb_Amt_Due(l_Amt_Due).g_Amount_Due.Retry_Start_Date := l_Comp_Schedules.Retry_Start_Date;
            p_Account_Obj.g_Tb_Components(Pkg_Main_Int).g_Tb_Amt_Due(l_Amt_Due).g_Amount_Due.Sch_Status := l_Comp_Schedules.Sch_Status;
            p_Account_Obj.g_Tb_Components(Pkg_Main_Int).g_Tb_Amt_Due(l_Amt_Due).g_Amount_Due.Account_Gl := l_Comp_Schedules.Account_Gl;
            p_Account_Obj.g_Tb_Components(Pkg_Main_Int).g_Tb_Amt_Due(l_Amt_Due).g_Amount_Due.Schedule_No := l_Comp_Schedules.Schedule_No;
            p_Account_Obj.g_Tb_Components(Pkg_Main_Int).g_Tb_Amt_Due(l_Amt_Due).g_Amount_Due.Writeoff_Amt := l_Comp_Schedules.Writeoff_Amt;
            p_Account_Obj.g_Tb_Components(Pkg_Main_Int).g_Tb_Amt_Due(l_Amt_Due).g_Amount_Due.Readj_Settled := l_Comp_Schedules.Readj_Settled;
            p_Account_Obj.g_Tb_Components(Pkg_Main_Int).g_Tb_Amt_Due(l_Amt_Due).g_Amount_Due.Last_Readj_Xrate := l_Comp_Schedules.Last_Readj_Xrate;
            p_Account_Obj.g_Tb_Components(Pkg_Main_Int).g_Tb_Amt_Due(l_Amt_Due).g_Amount_Due.Susp_Amt_Due := l_Comp_Schedules.Susp_Amt_Due;
            p_Account_Obj.g_Tb_Components(Pkg_Main_Int).g_Tb_Amt_Due(l_Amt_Due).g_Amount_Due.Susp_Amt_Settled := l_Comp_Schedules.Susp_Amt_Settled;
            p_Account_Obj.g_Tb_Components(Pkg_Main_Int).g_Tb_Amt_Due(l_Amt_Due).g_Amount_Due.Susp_Amt_Lcy := l_Comp_Schedules.Susp_Amt_Lcy;
            p_Account_Obj.g_Tb_Components(Pkg_Main_Int).g_Tb_Amt_Due(l_Amt_Due).g_Amount_Due.Susp_Read_Amt := l_Comp_Schedules.Susp_Read_Amt;
            p_Account_Obj.g_Tb_Components(Pkg_Main_Int).g_Tb_Amt_Due(l_Amt_Due).g_Amount_Due.Susp_Read_Settled := l_Comp_Schedules.Susp_Read_Settled;
            p_Account_Obj.g_Tb_Components(Pkg_Main_Int).g_Tb_Amt_Due(l_Amt_Due).g_Amount_Due.Last_Susp_Xrate := l_Comp_Schedules.Last_Susp_Xrate;
            p_Account_Obj.g_Tb_Components(Pkg_Main_Int).g_Tb_Amt_Due(l_Amt_Due).g_Amount_Due.Irr_Applicable := l_Comp_Schedules.Irr_Applicable;
            p_Account_Obj.g_Tb_Components(Pkg_Main_Int).g_Tb_Amt_Due(l_Amt_Due).g_Amount_Due.Amount_Waived := l_Comp_Schedules.Amount_Waived;
            p_Account_Obj.g_Tb_Components(Pkg_Main_Int).g_Tb_Amt_Due(l_Amt_Due).g_Amount_Due.Adj_Settled := l_Comp_Schedules.Adj_Settled;

         END LOOP;
      END IF;
      --Log#11 End

      l_Vamb_Esn := p_Account_Obj.Account_Det.Latest_Esn + 1;
      IF NOT Clpkss_Charges.Fn_Process_Charges(p_Account_Obj
                                              ,'VAMB'
                                              --FCUBS11.1:9NT1368 - SFR 3543 - Starts
                                              --,p_Cldaccvm.v_Cltbs_Account_Vamd.Effective_Date
                                              ,global.application_date
                                              --FCUBS11.1:9NT1368 - SFR 3543 - Ends
                                              ,l_Vamb_Esn
                                              ,'S'
                                              ,l_Tb_Chrg
                                              ,p_Err_Code
                                              ,p_Err_Params) THEN
         Dbg(' Failed to process charges ::' || p_Err_Code);
         RETURN FALSE;
      END IF;
      IF l_Tb_Chrg.COUNT > 0 THEN
         FOR i IN l_Tb_Chrg.FIRST .. l_Tb_Chrg.LAST LOOP
            Dbg('VAMI charge Component ::' || l_Tb_Chrg(i).Component_Name);
            l_Prod_Comp                      := Clpkss_Cache.Fn_Product_Components(p_Account_Obj.Account_Det.Product_Code, l_Tb_Chrg(i).Component_Name);
            l_Rec_Schedule                   := NULL;
            l_Rec_Schedule.Account_Number    := p_Account_Obj.Account_Det.Account_Number;
            l_Rec_Schedule.Branch_Code       := p_Account_Obj.Account_Det.Branch_Code;
            l_Rec_Schedule.Component_Name    := l_Tb_Chrg(i).Component_Name;
            l_Rec_Schedule.Schedule_Type     := 'P';
            l_Rec_Schedule.Schedule_St_Date  := Global.Application_Date;
            l_Rec_Schedule.Schedule_Due_Date := Global.Application_Date;
            l_Rec_Schedule.Grace_Days        := 0;
            l_Rec_Schedule.Irr_Applicable    := l_Prod_Comp.Irr_Applicable;
            l_Rec_Schedule.Settlement_Ccy    := l_Tb_Chrg(i).Settlement_Ccy;
            l_Rec_Schedule.Amount_Due        := l_Tb_Chrg(i).Amount_Due;
            l_Tb_Cltms_Product_Comp_Frm      := Clpkss_Cache.Fn_Cltms_Product_Comp_Frm(p_Account_Obj.Account_Det.Product_Code, l_Rec_Schedule.Component_Name);
            l_Rec_Schedule.Formula_Name      := l_Tb_Cltms_Product_Comp_Frm(l_Tb_Cltms_Product_Comp_Frm.FIRST).Formula_Name;
            l_Rec_Schedule.Event_Seq_No      := l_Tb_Chrg(i).Event_Seq_No;
            l_Index                          := Clpkss_Util.Fn_Hash_Date(Global.Application_Date);
            p_Account_Obj.g_Tb_Components(l_Rec_Schedule.Component_Name) .g_Tb_Amt_Due.DELETE;
            p_Account_Obj.g_Tb_Components(l_Rec_Schedule.Component_Name).g_Tb_Amt_Due(l_Index).g_Amount_Due := l_Rec_Schedule;
         END LOOP;
      END IF;

      Dbg('Returning success from Fn_Process_Charges');
      RETURN TRUE;
   EXCEPTION
      WHEN OTHERS THEN
         Dbg('In when others in Fn_Process_Charges ' || SQLERRM);
         Dbg(Dbms_Utility.Format_Error_Backtrace);
         p_Err_Code   := 'ST-OTHR-001';
         p_Err_Params := NULL;
         RETURN FALSE;
   END Fn_Process_Charges;

   FUNCTION Fn_Explode_Schedules(p_Source           IN VARCHAR2
                                ,p_Source_Operation IN VARCHAR2
                                ,p_Function_Id      IN VARCHAR2
                                ,p_Action_Code      IN VARCHAR2
                                ,p_Cldaccvm         IN Clpks_Cldaccvm_Main.Ty_Cldaccvm
                                ,p_Account_Obj      IN OUT Clpkss_Object.Ty_Rec_Account
                                ,p_Err_Code         IN OUT VARCHAR2
                                ,p_Err_Params       IN OUT VARCHAR2) RETURN BOOLEAN IS

      l_Rec_Account_Master           Cltbs_Account_Master%ROWTYPE;
      l_Comp_Indx                    Cltbs_Account_Components.Component_Name%TYPE;
      l_Sch_Indx                     VARCHAR2(50);
      l_Rec_Prod                     Cltm_Product%ROWTYPE;
      l_Product_Code                 Cltbs_Account_Master.Product_Code%TYPE;
      l_Frm_Indx                     NUMBER;
      l_Source_Date                  Cltb_Account_Comp_Sch.Sch_Start_Date%TYPE;
      l_Frequency_Unit               Cltb_Account_Comp_Sch.Unit%TYPE;
      l_Frequency                    Cltb_Account_Comp_Sch.Frequency%TYPE;
      l_No_Of_Schedules              Cltb_Account_Comp_Sch.No_Of_Schedules%TYPE;
      l_Maturity_Date                Cltb_Account_Comp_Sch.Sch_End_Date%TYPE;
      l_Add_Months                   NUMBER;
      l_Interest_Period_Days         NUMBER := 0;
      l_Interest_Only_Period         NUMBER;
      l_Product_Interest_Period_Days NUMBER;
      l_Interest_Only_Unit           Cltb_Account_Comp_Sch.Unit%TYPE;
      Pind                           Clpkss_Schedules.Ty_Tb_Indicator;
      l_Interest_Only_Unit_Calc      NUMBER;
      l_Explode_Action               VARCHAR2(50) := 'NEW';
      l_Eff_Date                     DATE;
      l_Err_Msg_Type                 VARCHAR2(100);
      l_Parents_List                 VARCHAR2(32767);
      l_Parents_Format               VARCHAR2(32767);
      l_Ts_Tag_Names                 VARCHAR2(32767);
      l_Ts_Tag_Values                VARCHAR2(32767);
      l_Ts_Tag_Format                VARCHAR2(32767);
      l_Ts_Clob_Tag_Names            CLOB;
      l_Ts_Clob_Tag_Values           CLOB;
      l_Ts_Clob_Tag_Format           CLOB;
      l_Is_Tag_Clob                  VARCHAR2(1) := 'N';
      p_Key                          VARCHAR2(32767);
      p_Data                         VARCHAR2(32767);
      p_Parent                       VARCHAR2(32767);
      p_Format                       VARCHAR2(32767);
      Error_Exception EXCEPTION;
      l_Diff_Amt             NUMBER := 0;
      Pind                   Clpkss_Schedules.Ty_Tb_Indicator;
      l_Due_Indx             PLS_INTEGER;
      l_Ori_Amount_Financed  Cltbs_Account_Master.Amount_Financed%TYPE;
      l_Ude_Count            PLS_INTEGER;
      l_Dsbr_Indx            PLS_INTEGER;
      l_Rec_Ude_Values       Cltbs_Account_Ude_Values%ROWTYPE;
      l_Disbr_Sch            PLS_INTEGER;
      l_Roll_Obj             Clpkss_Rollover_Object.Ty_Rec_Rollover; --Log#12
      l_Vami_Effect_Dt       Cltbs_Account_Master.Value_Date%TYPE; --Log#59
      l_Rec_Account_Master   Cltbs_Account_Master%ROWTYPE; --Log#69 Vijay
      l_Idx_Parties          VARCHAR2(50) := NULL; --Log#96
      l_Frm_Indx             NUMBER; -- For Subsidy changes Log#446
      l_Source_Date          Cltb_Account_Comp_Sch.Sch_Start_Date%TYPE; -- For Subsidy changes Log#446
      l_Frequency_Unit       Cltb_Account_Comp_Sch.Unit%TYPE; -- For Subsidy changes Log#446
      l_Frequency            Cltb_Account_Comp_Sch.Frequency%TYPE; -- For Subsidy changes Log#446
      l_No_Of_Schedules      Cltb_Account_Comp_Sch.No_Of_Schedules%TYPE; -- For Subsidy changes Log#446
      l_Maturity_Date        Cltb_Account_Comp_Sch.Sch_End_Date%TYPE; -- For Subsidy changes Log#446
      l_Add_Months           NUMBER; -- For Subsidy changes Log#446
      l_Interest_Only_Period NUMBER; -- For Subsidy changes Log#446
      l_Interest_Only_Unit   Cltb_Account_Comp_Sch.Unit%TYPE; -- For Subsidy changes Log#446
      l_Product_Code         Cltbs_Account_Master.Product_Code%TYPE; -- For Subsidy changes Log#446
      l_Product_Components   Cltm_Product_Components%ROWTYPE; -- For Subsidy changes Log#446
      --Log#473 Abhishek for Putting Validation for Interest Only Period tenor Validation Starts
      l_Principal_p_Tenor NUMBER := 0;
      l_Interest_p_Tenor  NUMBER := 0;
      l_Tb_Cltms_Comp_Frm Clpks_Cache.Ty_Tb_Cltms_Comp_Frm;
      l_Comple_Indx       Cltbs_Account_Components.Component_Name%TYPE; -----Log#496
      --Log#473 Abhishek for Putting Validation for Interest Only Period tenor Validation Ends
      -- Log#481 chagned for VAMI starts
      l_Unit             VARCHAR2(1); -- Yastemp
      l_Account_Old_Obj  Clpkss_Object.Ty_Rec_Account;
      l_Is_Schedule_Date NUMBER := 0; -- Yastemp
      -- Log#492 SFR#1621 changes Start
      l_Emi_Anount1   Cltb_Account_Schedules.Emi_Amount%TYPE;
      l_Amount        NUMBER := 0;
      l_No_Of_Install NUMBER := 0;
      --Log#492 SFR#1621 changes End
      l_Total_Amount        NUMBER := 0; --Log#497 SFR#143itr2 changes
      l_Cltb_Account_Master Cltb_Account_Master%ROWTYPE;
   BEGIN
      Dbg('In Fn_Explode_schedules');

      l_Eff_Date := p_Cldaccvm.v_Cltbs_Account_Vamd.Effective_Date;

      Clpkss_Account.Pr_Set_Vami(l_Eff_Date);
      IF NOT Pkgs_Cldaccdt.Fn_Pop_Tables(p_Account_Obj) THEN
         Dbg('Failed in fn_pop_tables');
         RETURN FALSE;
      END IF;

      SELECT *
      INTO   l_Cltb_Account_Master
      FROM   Cltb_Account_Master
      WHERE  Account_Number = p_Account_Obj.Account_Det.Account_Number
      AND    Branch_Code = p_Account_Obj.Account_Det.Branch_Code;
      IF (l_Cltb_Account_Master.Amount_Financed <> p_Account_Obj.Account_Det.Amount_Financed) OR
         (l_Cltb_Account_Master.Loan_To_Value <> p_Account_Obj.Account_Det.Loan_To_Value) OR
         (l_Cltb_Account_Master.Maturity_Date <> p_Account_Obj.Account_Det.Maturity_Date) THEN
         l_Explode_Action := 'VAMI';
      ELSE
         l_Explode_Action := 'REDEF';
      END IF;
      p_Account_Obj.Account_Det.Recalc_Action_Code := 'V';
      l_Ori_Amount_Financed                        := p_Account_Obj.Account_Det.Amount_Financed;

      --Log#497 SFR#143itr2 changes End

      Clpkss_Account.Pr_Set_Vami(l_Eff_Date);
      IF NOT Pkgs_Cldaccdt.Fn_Pop_Tables(p_Account_Obj) THEN
         Dbg('Failed in fn_pop_tables');
         RETURN FALSE;
      END IF;
      p_Account_Obj.Account_Det.Recalc_Action_Code := 'V';
      l_Ori_Amount_Financed                        := p_Account_Obj.Account_Det.Amount_Financed;

      -- Log#481 chagned for VAMI starts
      -- Yastemp start

      Dbg('Yasser pkg_cldaccdt.pkgfuncid ==> ' || Pkg_Cldaccdt.Pkgfuncid);
      Dbg('   p_Account_Obj.account_det.frequency_unit  ' || p_Account_Obj.Account_Det.Frequency_Unit);

      l_Account_Old_Obj.Account_Det := Clpkss_Cache.Fn_Account_Master(p_Account_Obj.Account_Det.Account_Number, p_Account_Obj.Account_Det.Branch_Code);
      Dbg('   p_Account_Obj.account_det.maturity_date  ' || p_Account_Obj.Account_Det.Maturity_Date);
      Dbg('   p_Account_Obj.account_det.lease_extend_by  ' || p_Account_Obj.Account_Det.Lease_Extend_By);
      Dbg('   p_Account_Obj.account_det.amount_financed  ' || p_Account_Obj.Account_Det.Amount_Financed);
      Dbg('   l_account_old_obj.account_det.amount_financed  ' || l_Account_Old_Obj.Account_Det.Amount_Financed);
      Dbg('   p_Account_Obj.account_det.downpayment_amount  ' || p_Account_Obj.Account_Det.Downpayment_Amount);
      Dbg('   l_account_old_obj.account_det.downpayment_amount  ' || l_Account_Old_Obj.Account_Det.Downpayment_Amount);
      Dbg('   p_Account_Obj.account_det.residual_amount  ' || p_Account_Obj.Account_Det.Residual_Amount);
      Dbg('   l_account_old_obj.account_det.residual_amount  ' || l_Account_Old_Obj.Account_Det.Residual_Amount);

      -- Log#481 chagned for VAMI ends

      --FC10.5STR2 SFR# 1227 begins
      Dbg('p_Account_Obj.account_det.amount_financed: ' || p_Account_Obj.Account_Det.Amount_Financed);
      Clpks_Calc.g_New_Amtfin := p_Account_Obj.Account_Det.Amount_Financed;
      Dbg('clpks_calc.g_new_amtfin: ' || Clpks_Calc.g_New_Amtfin);
      --FC10.5STR2 SFR# 1227 ends

      IF Clpkss_Cache.Fn_Product(p_Account_Obj.Account_Det.Product_Code).Disbursement_Mode = 'A' OR Nvl(p_Account_Obj.Account_Det.Lease_Type, '#') = 'O' -- Log#483 added for Operaional lease
       THEN
         l_Diff_Amt := p_Account_Obj.Account_Det.Amount_Financed -
                       Clpkss_Cache.Fn_Account_Master(p_Account_Obj.Account_Det.Account_Number, p_Account_Obj.Account_Det.Branch_Code).Amount_Financed;
      ELSE
         p_Account_Obj.Account_Det.Amount_Financed := Clpkss_Cache.Fn_Account_Master(p_Account_Obj.Account_Det.Account_Number
                                                                                    ,p_Account_Obj.Account_Det.Branch_Code).Amount_Financed;
         l_Diff_Amt                                := 0;
      END IF;
      Dbg('Final Amt = ' || l_Diff_Amt);

      p_Account_Obj.Account_Det.Amount_Disbursed := p_Account_Obj.Account_Det.Amount_Disbursed + l_Diff_Amt;
      Dbg('Amount disbursed  = ' || p_Account_Obj.Account_Det.Amount_Disbursed);

      Dbg('calling clpks_account.fn_explode_schedules');
      IF NOT Clpkss_Ude.Fn_Resolve_Rates(p_Account_Obj
                                        ,p_Account_Obj.Account_Det.Value_Date
                                        ,Nvl(p_Account_Obj.Account_Det.Maturity_Date, Clpkss_Util.Pkg_Eternity)
                                        ,l_Eff_Date --Log#15
                                        ,p_Err_Code
                                        ,p_Err_Params) THEN
         Clpkss_Account.Pr_Reset_Vami;
         Dbg('clpkss_ude.fn_resolve_rates Failed :-(' || p_Err_Code || p_Err_Params);
         Ovpkss.Pr_Appendtbl(p_Err_Code, p_Err_Params);
         RAISE Error_Exception;
      END IF;

      FOR Each_Rec IN (SELECT a.*, a.ROWID
                       FROM   Cltbs_Account_Ude_Values a
                       WHERE  Account_Number = p_Account_Obj.Account_Det.Account_Number
                       AND    Branch_Code = p_Account_Obj.Account_Det.Branch_Code
                       AND    Nvl(Maint_Rslv_Flag, 'M') = 'R'
                       AND    NOT EXISTS (SELECT 1
                               FROM   Cltbs_Account_Ude_Eff_Dates b
                               WHERE  b.Account_Number = p_Account_Obj.Account_Det.Account_Number
                               AND    b.Branch_Code = p_Account_Obj.Account_Det.Branch_Code
                               AND    b.Effective_Date = a.Effective_Date)) LOOP
         Dbg('$$$$$$$$$$$$Inside patching up account ude values');

         l_Ude_Count := Clpks_Util.Fn_Hash_Date(Each_Rec.Effective_Date);

         IF p_Account_Obj.g_Tb_Ude_Values.EXISTS(Each_Rec.Ude_Id) THEN
            IF NOT p_Account_Obj.g_Tb_Ude_Values(Each_Rec.Ude_Id).g_Tb_Ude_Val.EXISTS(l_Ude_Count) THEN

               Dbg('$$$$$$$$$$$$Inside 2');

               p_Account_Obj.g_Tb_Ude_Values(Each_Rec.Ude_Id).g_Tb_Ude_Val(l_Ude_Count).g_Record_Rowid := Each_Rec.ROWID;
               p_Account_Obj.g_Tb_Ude_Values(Each_Rec.Ude_Id).g_Ude_Id := Each_Rec.Ude_Id;

               l_Rec_Ude_Values.Account_Number  := Each_Rec.Account_Number;
               l_Rec_Ude_Values.Branch_Code     := Each_Rec.Branch_Code;
               l_Rec_Ude_Values.Effective_Date  := Each_Rec.Effective_Date;
               l_Rec_Ude_Values.Ude_Id          := Each_Rec.Ude_Id;
               l_Rec_Ude_Values.Ude_Value       := Each_Rec.Ude_Value;
               l_Rec_Ude_Values.Rate_Code       := Each_Rec.Rate_Code;
               l_Rec_Ude_Values.Code_Usage      := Each_Rec.Code_Usage;
               l_Rec_Ude_Values.Maint_Rslv_Flag := Each_Rec.Maint_Rslv_Flag;
               l_Rec_Ude_Values.Resolved_Value  := Each_Rec.Resolved_Value;

               Dbg('$$$$$$$$$$$$$$$$$$l_rec_ude_values.resolved_value ' || l_Rec_Ude_Values.Resolved_Value);

               p_Account_Obj.g_Tb_Ude_Values(Each_Rec.Ude_Id).g_Tb_Ude_Val(l_Ude_Count).g_Ude_Values := l_Rec_Ude_Values;
            END IF;
         END IF;
      END LOOP;

      IF Nvl(p_Account_Obj.Account_Det.Lease_Type, '#') <> 'O' THEN
         -- Log#468
         IF p_Account_Obj.g_Tb_Components(Pkg_Principal).g_Tb_Disbr_Schedules.COUNT = 0 THEN
            FOR l_Disbr_Schedules IN (SELECT a.*, a.ROWID
                                      FROM   Cltbs_Disbr_Schedules a
                                      WHERE  Account_Number = p_Account_Obj.Account_Det.Account_Number
                                      AND    Branch_Code = p_Account_Obj.Account_Det.Branch_Code) LOOP
               Dbg('$$$$$$$$$$$$$$$$Filling up schedules');
               l_Disbr_Sch := Clpkss_Util.Fn_Hash_Date(l_Disbr_Schedules.Schedule_Due_Date);
               p_Account_Obj.g_Tb_Components(Pkg_Principal).g_Tb_Disbr_Schedules(l_Disbr_Sch).g_Record_Rowid := l_Disbr_Schedules.ROWID;
               p_Account_Obj.g_Tb_Components(Pkg_Principal).g_Tb_Disbr_Schedules(l_Disbr_Sch).g_Disbr_Sch.Account_Number := p_Account_Obj.Account_Det.Account_Number;
               p_Account_Obj.g_Tb_Components(Pkg_Principal).g_Tb_Disbr_Schedules(l_Disbr_Sch).g_Disbr_Sch.Branch_Code := p_Account_Obj.Account_Det.Branch_Code;
               p_Account_Obj.g_Tb_Components(Pkg_Principal).g_Tb_Disbr_Schedules(l_Disbr_Sch).g_Disbr_Sch.Component_Name := l_Disbr_Schedules.Component_Name;
               p_Account_Obj.g_Tb_Components(Pkg_Principal).g_Tb_Disbr_Schedules(l_Disbr_Sch).g_Disbr_Sch.Schedule_St_Date := l_Disbr_Schedules.Schedule_St_Date;
               p_Account_Obj.g_Tb_Components(Pkg_Principal).g_Tb_Disbr_Schedules(l_Disbr_Sch).g_Disbr_Sch.Schedule_Due_Date := l_Disbr_Schedules.Schedule_Due_Date;
               p_Account_Obj.g_Tb_Components(Pkg_Principal).g_Tb_Disbr_Schedules(l_Disbr_Sch).g_Disbr_Sch.Amount_To_Disbr := l_Disbr_Schedules.Amount_To_Disbr;
               p_Account_Obj.g_Tb_Components(Pkg_Principal).g_Tb_Disbr_Schedules(l_Disbr_Sch).g_Disbr_Sch.Schedule_Linkage := l_Disbr_Schedules.Schedule_Linkage;
               --Log#455 12.11.2009 Starts
               p_Account_Obj.g_Tb_Components(Pkg_Principal).g_Tb_Disbr_Schedules(l_Disbr_Sch).g_Disbr_Sch.Dtype := l_Disbr_Schedules.Dtype;
               p_Account_Obj.g_Tb_Components(Pkg_Principal).g_Tb_Disbr_Schedules(l_Disbr_Sch).g_Disbr_Sch.Manual_Amt_Dsbr := l_Disbr_Schedules.Manual_Amt_Dsbr;
               --Log#455 12.11.2009 Ends
            END LOOP;
         END IF;
      END IF; -- Log#468

      IF NOT Clpkss_Account.Fn_Explode_Schedule(l_Explode_Action, p_Account_Obj, p_Err_Code, p_Err_Params) THEN
         p_Account_Obj.Account_Det.Amount_Disbursed := p_Account_Obj.Account_Det.Amount_Disbursed - l_Diff_Amt;
         p_Account_Obj.Account_Det.Amount_Financed  := l_Ori_Amount_Financed;
         Dbg('Failed in overloaded fn_explode with ::' || p_Err_Code);
         Ovpkss.Pr_Appendtbl(p_Err_Code, p_Err_Params);
         RAISE Error_Exception;
      END IF;
      --Log#473 Abhishek for Putting Validation for Interest Only Period tenor Validation Starts
      /*
      In interest only period Main Int component will have always Non-Amortized formula, so if sum of all Payment schedule of maint int component
      , where main int component formula type is Non Amortized Tenor is exceeding sum of Payment Schedule Tenor of Principal Component then
      Contract is having Principal Repayment Holiday. If difference of these two components payment schedule Tenors(Main_Int - Principal) is more
      than the "Interest Only Period" set at Product level then its a bug, what we are checking here.
      */
      Dbg('For Account number ' || p_Account_Obj.Account_Det.Account_Number || ' Product Code is ' || p_Account_Obj.Account_Det.Product_Code);
      l_Rec_Prod := Clpkss_Cache.Fn_Product(p_Account_Obj.Account_Det.Product_Code);
      Dbg('Interest Only Period is ' || l_Rec_Prod.Interest_Only_Period || '~' || l_Rec_Prod.Interest_Only_Unit);
      l_Principal_p_Tenor := 0;
      l_Interest_p_Tenor  := 0;
      IF l_Rec_Prod.Interest_Only_Unit = 'D' THEN
         l_Interest_Only_Unit_Calc := 1;
      ELSIF l_Rec_Prod.Interest_Only_Unit = 'M' THEN
         l_Interest_Only_Unit_Calc := 30;
      ELSIF l_Rec_Prod.Interest_Only_Unit = 'Y' THEN
         l_Interest_Only_Unit_Calc := 365;
      END IF;
      l_Product_Interest_Period_Days := l_Rec_Prod.Interest_Only_Period * l_Interest_Only_Unit_Calc;
      Dbg('l_product_interest_period_days is ' || l_Product_Interest_Period_Days);
      IF Nvl(l_Product_Interest_Period_Days, 0) > 0 THEN
         l_Comp_Indx := p_Account_Obj.g_Tb_Components.FIRST;
         WHILE l_Comp_Indx IS NOT NULL LOOP
            Dbg('Component name is ' || p_Account_Obj.g_Tb_Components(l_Comp_Indx).Comp_Det.Component_Name);
            IF p_Account_Obj.g_Tb_Components(l_Comp_Indx).Comp_Det.Component_Name IN (Pkg_Principal, Pkg_Main_Int) THEN
               l_Sch_Indx := p_Account_Obj.g_Tb_Components(l_Comp_Indx).g_Tb_Comp_Sch.FIRST;
               WHILE l_Sch_Indx IS NOT NULL LOOP
                  Dbg('Sch End Date is ' || p_Account_Obj.g_Tb_Components(l_Comp_Indx).g_Tb_Comp_Sch(l_Sch_Indx).g_Account_Comp_Sch.Sch_End_Date);
                  Dbg('Sch Start Date is ' || p_Account_Obj.g_Tb_Components(l_Comp_Indx).g_Tb_Comp_Sch(l_Sch_Indx).g_Account_Comp_Sch.Sch_Start_Date);
                  Dbg('l_principal_p_tenor is ' || l_Principal_p_Tenor);
                  Dbg('l_interest_p_tenor is ' || l_Interest_p_Tenor);
                  IF p_Account_Obj.g_Tb_Components(l_Comp_Indx).Comp_Det.Component_Type = 'L' AND p_Account_Obj.g_Tb_Components(l_Comp_Indx)
                  .g_Tb_Comp_Sch(l_Sch_Indx).g_Account_Comp_Sch.Schedule_Type = 'P' AND p_Account_Obj.g_Tb_Components(l_Comp_Indx).g_Tb_Comp_Sch(l_Sch_Indx)
                  .g_Account_Comp_Sch.Unit <> 'B' THEN
                     l_Principal_p_Tenor := l_Principal_p_Tenor + (p_Account_Obj.g_Tb_Components(l_Comp_Indx).g_Tb_Comp_Sch(l_Sch_Indx)
                                            .g_Account_Comp_Sch.Sch_End_Date - p_Account_Obj.g_Tb_Components(l_Comp_Indx)
                                            .g_Tb_Comp_Sch(l_Sch_Indx).g_Account_Comp_Sch.Sch_Start_Date);
                     Dbg('l_principal_p_tenor is ' || l_Principal_p_Tenor);
                  END IF;
                  IF p_Account_Obj.g_Tb_Components(l_Comp_Indx).Comp_Det.Component_Type = 'I' AND p_Account_Obj.g_Tb_Components(l_Comp_Indx)
                  .g_Tb_Comp_Sch(l_Sch_Indx).g_Account_Comp_Sch.Schedule_Type = 'P' AND p_Account_Obj.g_Tb_Components(l_Comp_Indx).g_Tb_Comp_Sch(l_Sch_Indx)
                  .g_Account_Comp_Sch.Unit <> 'B' THEN
                     l_Tb_Cltms_Comp_Frm := Clpkss_Cache.Fn_Cltms_Product_Comp_Frm(p_Account_Obj.Account_Det.Product_Code
                                                                                  ,p_Account_Obj.g_Tb_Components(l_Comp_Indx).Comp_Det.Component_Name);
                     Dbg('Formula Name is ' || p_Account_Obj.g_Tb_Components(l_Comp_Indx).g_Tb_Comp_Sch(l_Sch_Indx).g_Account_Comp_Sch.Formula_Name);
                     IF Nvl(l_Tb_Cltms_Comp_Frm(p_Account_Obj.g_Tb_Components(l_Comp_Indx).g_Tb_Comp_Sch(l_Sch_Indx).g_Account_Comp_Sch.Formula_Name).Amortized
                           ,'N') = 'N' THEN
                        l_Interest_p_Tenor := l_Interest_p_Tenor + (p_Account_Obj.g_Tb_Components(l_Comp_Indx).g_Tb_Comp_Sch(l_Sch_Indx)
                                              .g_Account_Comp_Sch.Sch_End_Date - p_Account_Obj.g_Tb_Components(l_Comp_Indx)
                                              .g_Tb_Comp_Sch(l_Sch_Indx).g_Account_Comp_Sch.Sch_Start_Date);
                     END IF;
                     Dbg('l_interest_p_tenor is ' || l_Interest_p_Tenor);
                  END IF;
                  l_Sch_Indx := p_Account_Obj.g_Tb_Components(l_Comp_Indx).g_Tb_Comp_Sch.NEXT(l_Sch_Indx);
               END LOOP;
            END IF;
            l_Comp_Indx := p_Account_Obj.g_Tb_Components.NEXT(l_Comp_Indx);
         END LOOP;
         l_Interest_Period_Days := l_Interest_p_Tenor - l_Principal_p_Tenor;
         Dbg('l_interest_period_days is ' || l_Interest_Period_Days);
         IF l_Interest_Period_Days > l_Product_Interest_Period_Days THEN
            Dbg('Principal Repayment Holiday period is more than Interest Only Period');
            Ovpkss.Pr_Appendtbl('CL-SCH077', p_Err_Params);
            RAISE Error_Exception;
         END IF;
         Dbg('after error in explode schedules1');
      END IF;
      --Log#473 Abhishek for Putting Validation for Interest Only Period tenor Validation Ends
      --IF NVL(gwpkss_ls_accountservice.g_module_code,'@#') <> 'LE' THEN -- Log#463 -- Commented for Log#503
      --Log#450 For RML Starts 31.10.2009
      Dbg('after error in explode schedules2');
      IF C3pk#_Prd_Shell.Fn_Get_Contract_Info(p_Account_Obj.Account_Det.Account_Number
                                             ,p_Account_Obj.Account_Det.Branch_Code
                                             ,'LOAN_TYPE'
                                             ,p_Account_Obj.Account_Det.Product_Code) <> 'R' THEN
         --Log#450 For RML Ends 31.10.2009

         p_Account_Obj.Account_Det.Amount_Financed := l_Ori_Amount_Financed; -- log#86
      END IF;
      Dbg('after error in explode schedules3');
      --Log#450 For RML 31.10.2009
      --END IF ; -- Log#463 -- Commented for Log#503
      Dbg('p_Account_Obj.account_det.amount_financed~' || p_Account_Obj.Account_Det.Amount_Financed);
      Dbg('After overloaded fn_explode_schedule..with :.' || Gwpkss_Cl_Account_Ts_To_Ty.g_Actcode || '~' || Clpkss_Context.g_Function_Id);

      l_Comp_Indx := p_Account_Obj.g_Tb_Components.FIRST;
      WHILE l_Comp_Indx IS NOT NULL LOOP
         l_Due_Indx := p_Account_Obj.g_Tb_Components(l_Comp_Indx).g_Tb_Amt_Due.FIRST;
         WHILE l_Due_Indx IS NOT NULL LOOP
            IF p_Account_Obj.g_Tb_Components(l_Comp_Indx).g_Tb_Amt_Due(l_Due_Indx).g_Action = 'D' THEN
               p_Account_Obj.g_Tb_Components(l_Comp_Indx).g_Tb_Amt_Due(l_Due_Indx).g_Action := 'N';
            END IF;
            l_Due_Indx := p_Account_Obj.g_Tb_Components(l_Comp_Indx).g_Tb_Amt_Due.NEXT(l_Due_Indx);
         END LOOP;
         l_Dsbr_Indx := p_Account_Obj.g_Tb_Components(l_Comp_Indx).g_Tb_Disbr_Schedules.FIRST;

         WHILE l_Dsbr_Indx IS NOT NULL LOOP
            IF p_Account_Obj.g_Tb_Components(l_Comp_Indx).g_Tb_Disbr_Schedules(l_Dsbr_Indx).g_Action = 'D' THEN
               p_Account_Obj.g_Tb_Components(l_Comp_Indx).g_Tb_Disbr_Schedules(l_Dsbr_Indx).g_Action := 'N';
            END IF;
            l_Dsbr_Indx := p_Account_Obj.g_Tb_Components(l_Comp_Indx).g_Tb_Disbr_Schedules.NEXT(l_Dsbr_Indx);
         END LOOP;

         l_Comp_Indx := p_Account_Obj.g_Tb_Components.NEXT(l_Comp_Indx);
      END LOOP;

      IF NOT Clpkss_Object.Fn_Clear_Acc_Object(p_Account_Obj, p_Err_Code, p_Err_Params) THEN
         Dbg('Failed in clearing account object ::' || p_Err_Code);
         RETURN FALSE;
      END IF;
      Clpkss_Account.Pr_Reset_Vami;

      Dbg('Returning success from Fn_Explode_schedules');
      RETURN TRUE;
   EXCEPTION
   --FCUBS ITR1 SFR#3568 Starts
      when error_exception then
      rollback;
      return false;
   --FCUBS ITR1 SFR#3568 Ends
      WHEN OTHERS THEN
         Dbg('In when others in Fn_Explode_schedules ' || SQLERRM);
         p_Err_Code   := 'ST-OTHR-001';
         p_Err_Params := NULL;
         RETURN FALSE;
   END Fn_Explode_Schedules;

   FUNCTION Fn_Create_Amendment(p_Source           IN VARCHAR2
                               ,p_Source_Operation IN VARCHAR2
                               ,p_Function_Id      IN VARCHAR2
                               ,p_Action_Code      IN VARCHAR2
                               ,p_Cldaccvm         IN Clpks_Cldaccvm_Main.Ty_Cldaccvm
                               ,p_Prev_Cldaccvm    IN OUT Clpks_Cldaccvm_Main.Ty_Cldaccvm
                               ,p_Wrk_Cldaccvm     IN OUT Clpks_Cldaccvm_Main.Ty_Cldaccvm
                               ,p_Account_Obj      IN OUT Clpkss_Object.Ty_Rec_Account
                               ,p_Err_Code         IN OUT VARCHAR2
                               ,p_Err_Params       IN OUT VARCHAR2) RETURN BOOLEAN IS

      l_Pickup       BOOLEAN := TRUE;
      l_Pickedup     BOOLEAN := TRUE;
      l_Subsys       VARCHAR2(500);
      l_Subsys_Stat  VARCHAR2(500);
      l_Stat         VARCHAR2(1);
      l_Module       VARCHAR2(10) := 'CL';
      l_Event_Seq_No NUMBER; --NRAKAEFCC0028 changed variable from number(3) to number
      l_Pos          NUMBER;
      l_Account_Obj  Clpkss_Object.Ty_Rec_Account;
      l_Eff_Date     DATE;
      l_Acc_No       VARCHAR2(100);
      l_Branch       VARCHAR2(100);
      l_Ind_Tbl      Clpkss_Schedules.Ty_Tb_Indicator;

   BEGIN
      Dbg('In Fn_Create_Amendment');

      l_Acc_No := p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd.Account_Number;
      l_Branch := p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd.Branch_Code;

      l_Eff_Date := p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd.Effective_Date;
      p_Account_Obj.g_Tb_Account_Roll_Comp.DELETE;
      IF NOT Pkgs_Cldaccdt.Fn_Populate_Amendment(l_Acc_No, l_Branch, l_Eff_Date, p_Account_Obj, p_Err_Code, p_Err_Params) THEN
         Dbg('Error in populating the object for VAMI. Returning False');
         RETURN FALSE;
      END IF;
      --FCUBS11.1 ITR1 SFR#5950 Starts
      /*IF NOT Clpkss_Schedules.Fn_Split_Schedules(p_Account_Obj, l_Eff_Date, l_Ind_Tbl, p_Err_Code, p_Err_Params) THEN
         Dbg('Failed in split schedules :' || p_Err_Code);
         RETURN FALSE;
      END IF;*/
      --FCUBS11.1 ITR1 SFR#5950 Ends

      Dbg('Returning success from Fn_Create_Amendment');
      RETURN TRUE;
   EXCEPTION
      WHEN OTHERS THEN
         Dbg('In when others in Fn_Create_Amendment ' || SQLERRM);
         p_Err_Code   := 'ST-OTHR-001';
         p_Err_Params := NULL;
         RETURN FALSE;
   END Fn_Create_Amendment;

   --FCUBS11.1 ITR1SFR#5950 Starts
   FUNCTION Fn_Edit_Schedules(p_Source           IN VARCHAR2
                             ,p_Source_Operation IN VARCHAR2
                             ,p_Function_Id      IN VARCHAR2
                             ,p_Action_Code      IN VARCHAR2
                             ,p_Cldaccvm         IN Clpks_Cldaccvm_Main.Ty_Cldaccvm
                             ,p_Prev_Cldaccvm    IN OUT Clpks_Cldaccvm_Main.Ty_Cldaccvm
                             ,p_Wrk_Cldaccvm     IN OUT Clpks_Cldaccvm_Main.Ty_Cldaccvm
                             ,p_Account_Obj      IN OUT Clpkss_Object.Ty_Rec_Account
                             ,p_Err_Code         IN OUT VARCHAR2
                             ,p_Err_Params       IN OUT VARCHAR2) RETURN BOOLEAN IS

      l_Account_Obj Clpkss_Object.Ty_Rec_Account;
      l_Eff_Date    DATE;
      l_Acc_No      VARCHAR2(100);
      l_Branch      VARCHAR2(100);
      l_Ind_Tbl     Clpkss_Schedules.Ty_Tb_Indicator;
      l_Idx_Comp    Cltbs_Account_Components.Component_Name%TYPE;
      l_Idx_Compsch VARCHAR2(35);
      j             NUMBER := 0;

   BEGIN
      Dbg('In Fn_Edit_Schedules');

      Dbg('Converting into Account Object..');

      l_Acc_No := p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd.Account_Number;
      l_Branch := p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd.Branch_Code;

      l_Eff_Date := p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd.Effective_Date;
      p_Account_Obj.g_Tb_Account_Roll_Comp.DELETE;

      IF NOT Clpkss_Schedules.Fn_Split_Schedules(p_Account_Obj, l_Eff_Date, l_Ind_Tbl, p_Err_Code, p_Err_Params) THEN
         Dbg('Failed in split schedules :' || p_Err_Code);
         RETURN FALSE;
      END IF;

      p_Wrk_Cldaccvm.v_Ui_Columns___Comp_Sch.DELETE;
      l_Idx_Comp := p_Account_Obj.g_Tb_Components.FIRST;
      Dbg('p_Account_Obj.g_Tb_Components.COUNT' || p_Account_Obj.g_Tb_Components.COUNT);
      WHILE l_Idx_Comp IS NOT NULL LOOP
         Dbg('l_idx_comp' || l_Idx_Comp);
         l_Idx_Compsch := p_Account_Obj.g_Tb_Components(l_Idx_Comp).g_Tb_Comp_Sch.FIRST;
         Dbg('l_idx_compsch' || l_Idx_Compsch);
         WHILE l_Idx_Compsch IS NOT NULL LOOP
            j := j + 1;
            p_Wrk_Cldaccvm.v_Ui_Columns___Comp_Sch(j) .Char_Field1 := p_Account_Obj.g_Tb_Components(l_Idx_Comp) . g_Tb_Comp_Sch(l_Idx_Compsch)
                                                                    .g_Account_Comp_Sch.Account_Number;
            p_Wrk_Cldaccvm.v_Ui_Columns___Comp_Sch(j) .Char_Field2 := p_Account_Obj.g_Tb_Components(l_Idx_Comp) . g_Tb_Comp_Sch(l_Idx_Compsch)
                                                                    .g_Account_Comp_Sch.Branch_Code;
            p_Wrk_Cldaccvm.v_Ui_Columns___Comp_Sch(j) .Char_Field3 := p_Account_Obj.g_Tb_Components(l_Idx_Comp) . g_Tb_Comp_Sch(l_Idx_Compsch)
                                                                    .g_Account_Comp_Sch.Component_Name;
            p_Wrk_Cldaccvm.v_Ui_Columns___Comp_Sch(j) .Date_Field1 := p_Account_Obj.g_Tb_Components(l_Idx_Comp) . g_Tb_Comp_Sch(l_Idx_Compsch)
                                                                    .g_Account_Comp_Sch.Sch_Start_Date;
            p_Wrk_Cldaccvm.v_Ui_Columns___Comp_Sch(j) .Char_Field4 := p_Account_Obj.g_Tb_Components(l_Idx_Comp) . g_Tb_Comp_Sch(l_Idx_Compsch)
                                                                    .g_Account_Comp_Sch.Schedule_Type;
            p_Wrk_Cldaccvm.v_Ui_Columns___Comp_Sch(j) .Date_Field2 := p_Account_Obj.g_Tb_Components(l_Idx_Comp) . g_Tb_Comp_Sch(l_Idx_Compsch)
                                                                    .g_Account_Comp_Sch.First_Due_Date;
            p_Wrk_Cldaccvm.v_Ui_Columns___Comp_Sch(j) .Char_Field6 := 'N';
            l_Idx_Compsch := p_Account_Obj.g_Tb_Components(l_Idx_Comp).g_Tb_Comp_Sch.NEXT(l_Idx_Compsch);
         END LOOP;
         l_Idx_Comp := p_Account_Obj.g_Tb_Components.NEXT(l_Idx_Comp);
      END LOOP;

      if p_Account_Obj.account_det.maturity_date > l_Eff_Date then
        l_Idx_Comp := p_Account_Obj.g_Tb_Components.FIRST;
        WHILE l_Idx_Comp IS NOT NULL LOOP
           IF l_Ind_Tbl.EXISTS(l_Idx_Comp) THEN

              FOR i IN p_Wrk_Cldaccvm.v_Ui_Columns___Comp_Sch.FIRST .. p_Wrk_Cldaccvm.v_Ui_Columns___Comp_Sch.LAST LOOP
                 IF p_Wrk_Cldaccvm.v_Ui_Columns___Comp_Sch(i).Char_Field3 = l_Idx_Comp THEN
                    IF p_Wrk_Cldaccvm.v_Ui_Columns___Comp_Sch(i).Char_Field4 = 'D' AND p_Wrk_Cldaccvm.v_Ui_Columns___Comp_Sch(i)
                    .Date_Field2 >= l_Ind_Tbl(l_Idx_Comp).g_First_Editable_d_Due_Date THEN

                       p_Wrk_Cldaccvm.v_Ui_Columns___Comp_Sch(i) .Char_Field6 := 'Y';

                    ELSIF p_Wrk_Cldaccvm.v_Ui_Columns___Comp_Sch(i).Char_Field4 = 'P' AND p_Wrk_Cldaccvm.v_Ui_Columns___Comp_Sch(i)
                    .Date_Field2 >= l_Ind_Tbl(l_Idx_Comp).g_First_Editable_p_Due_Date THEN

                       p_Wrk_Cldaccvm.v_Ui_Columns___Comp_Sch(i) .Char_Field6 := 'Y';

                    ELSIF p_Wrk_Cldaccvm.v_Ui_Columns___Comp_Sch(i).Char_Field4 = 'R' AND p_Wrk_Cldaccvm.v_Ui_Columns___Comp_Sch(i)
                    .Date_Field2 >= l_Ind_Tbl(l_Idx_Comp).g_First_Editable_r_Due_Date THEN--Second Time replaced to >=

                       p_Wrk_Cldaccvm.v_Ui_Columns___Comp_Sch(i) .Char_Field6 := 'Y';
                    END IF;
                 END IF;
                 Dbg('l_Idx_Comp' || l_Idx_Comp);
                 Dbg('Char_Field6' || p_Wrk_Cldaccvm.v_Ui_Columns___Comp_Sch(i).Char_Field6);
              END LOOP;

           END IF;
           l_Idx_Comp := p_Account_Obj.g_Tb_Components.NEXT(l_Idx_Comp);
        END LOOP;
      end if;
      Dbg('Returning success from Fn_Edit_Schedules');
      RETURN TRUE;
   EXCEPTION
      WHEN OTHERS THEN
         Dbg('In when others in Fn_Edit_Schedules ' || SQLERRM);
         p_Err_Code   := 'ST-OTHR-001';
         p_Err_Params := NULL;
         RETURN FALSE;
   END Fn_Edit_Schedules;
   --FCUBS11.1 ITR1SFR#5950 Ends

   FUNCTION Fn_Subsys_Pickup(p_Source           IN VARCHAR2
                            ,p_Source_Operation IN VARCHAR2
                            ,p_Function_Id      IN VARCHAR2
                            ,p_Action_Code      IN VARCHAR2
                            ,p_Cldaccvm         IN Clpks_Cldaccvm_Main.Ty_Cldaccvm
                            ,p_Prev_Cldaccvm    IN OUT Clpks_Cldaccvm_Main.Ty_Cldaccvm
                            ,p_Wrk_Cldaccvm     IN OUT Clpks_Cldaccvm_Main.Ty_Cldaccvm
                            ,p_Err_Code         IN OUT VARCHAR2
                            ,p_Err_Params       IN OUT VARCHAR2) RETURN BOOLEAN IS

      l_Pickup       BOOLEAN := TRUE;
      l_Pickedup     BOOLEAN := TRUE;
      l_Subsys       VARCHAR2(500);
      l_Subsys_Stat  VARCHAR2(500);
      l_Stat         VARCHAR2(1);
      l_Module       VARCHAR2(10) := 'CL';
      l_Event_Seq_No NUMBER; --NRAKAEFCC0028 changed variable from number(3) to number
      l_Pos          NUMBER;
      l_Account_Obj  Clpkss_Object.Ty_Rec_Account;
      l_Ind_Tbl      Clpkss_Schedules.Ty_Tb_Indicator;
      l_Wrk_Cldaccvm Clpks_Cldaccvm_Main.Ty_Cldaccvm;--FCUBS11.1 ITR1 SFR#5950
   BEGIN
      Dbg('In Fn_Subsys_Pickup');
      l_Subsys_Stat  := p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd.Subsystemstat;
      l_Event_Seq_No := p_Wrk_Cldaccvm.v_Cltbs_Account_Master.Latest_Esn;

      Dbg('l_Subsys_Stat ' || l_Subsys_Stat);
      IF p_Action_Code = Cspks_Req_Global.p_Hold THEN
         l_Pos := Instr(l_Subsys_Stat, ':U');
         Dbg('l_Pos' || l_Pos);
         IF l_Pos > 0 THEN
            l_Pickup := TRUE;
         ELSE
            l_Pickup := FALSE;
         END IF;
      END IF;

      --FCUBS11.1 ITR2 SFR#1085 Starts..
      IF p_Source <> 'FLEXCUBE' THEN
         l_Pickup := FALSE;
      END IF;
      --FCUBS11.1 ITR2 SFR#1085 Ends..

      IF l_Pickup THEN
         l_Pickedup := TRUE;
         l_Subsys   := 'CREATEAMEND';
         l_Stat     := Clpks_Cldaccvm_Utils_1.Fn_Get_Subsys_Stat(p_Source, l_Subsys, l_Subsys_Stat);
         Dbg('Subsystem Status  ' || l_Subsys || '/' || l_Stat);

         IF l_Stat = 'R' THEN
			Pr_Log_Error(p_Function_Id, p_Source, 'CL-ACC-RDF', NULL); --SFR#2826
         END IF;

         IF l_Stat IN ('D', 'R', 'U') THEN
            Dbg('Calling Fn_Create_Amendment');
            IF NOT Fn_Create_Amendment(p_Source
                                      ,p_Source_Operation
                                      ,p_Function_Id
                                      ,p_Action_Code
                                      ,p_Cldaccvm
                                      ,p_Prev_Cldaccvm
                                      ,p_Wrk_Cldaccvm
                                      ,l_Account_Obj
                                      ,p_Err_Code
                                      ,p_Err_Params) THEN
               Dbg('Failed in fn_product_default');
               Pr_Log_Error(p_Function_Id, p_Source, p_Err_Code, p_Err_Params);
               l_Pickedup := FALSE;
               RETURN FALSE;
            END IF;
            l_Subsys_Stat := 'CREATEAMEND:S;ENRICH:D;EDITSCH:S;HOLPERIODS:S;UDEVALS:S;COMPSCH:S;CHARGES:D;EXPLODE:S;MICTRMIS:S;';

         ELSE

            IF NOT Clpks_Cldaccvm_Utils_1.Fn_Set_Dependant_Subsystems(p_Source
                                                                     ,p_Source_Operation
                                                                     ,p_Function_Id
                                                                     ,p_Action_Code
                                                                     ,p_Cldaccvm
                                                                     ,p_Wrk_Cldaccvm
                                                                     ,p_Err_Code
                                                                     ,p_Err_Params) THEN
               Dbg('Failed in Clpks_Cldaccvm_Utils_1.Fn_Set_Dependant_Subsystems...');
               RETURN FALSE;
            END IF;

            l_Subsys_Stat := p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd.Subsystemstat;

            Dbg('Converting into Account Object..');
            IF NOT Clpks_Cldaccvm_Type_Conv.Fn_Build_Acc_Obj(l_Account_Obj, p_Wrk_Cldaccvm, p_Err_Code, p_Err_Params) THEN
               Dbg('Failed in Clpks_Cldaccvm_Type_Conv.Fn_Build_Acc_Obj..');
               RETURN FALSE;
            END IF;

            --FCUBS11.1 ITR1SFR#5950 Starts
            l_Subsys := 'EDITSCH';
            l_Stat   := Clpks_Cldaccvm_Utils_1.Fn_Get_Subsys_Stat(p_Source, l_Subsys, l_Subsys_Stat);
            Dbg('Subsystem Status  ' || l_Subsys || '/' || l_Stat);

            IF l_Stat IN ('D', 'R', 'U') THEN
               IF NOT Fn_Edit_Schedules(p_Source
                                       ,p_Source_Operation
                                       ,p_Function_Id
                                       ,p_Action_Code
                                       ,p_Cldaccvm
                                       ,p_Prev_Cldaccvm
                                       ,p_Wrk_Cldaccvm
                                       ,l_Account_Obj
                                       ,p_Err_Code
                                       ,p_Err_Params) THEN
                  Dbg('failed in Fn_Process_Charges..');
                  RETURN FALSE;
               END IF;
               l_Subsys_Stat := Clpks_Cldaccvm_Utils_1.Fn_Upd_Subsys_Stat('EDITSCH', 'S', l_Subsys_Stat);
            END IF;

            Dbg('p_Wrk_Cldaccvm.v_Ui_Columns__Comp_Sch.COUNT111' || p_Wrk_Cldaccvm.v_Ui_Columns___Comp_Sch.COUNT);
            l_Wrk_Cldaccvm.v_Ui_Columns___Comp_Sch := p_Wrk_Cldaccvm.v_Ui_Columns___Comp_Sch;
             --FCUBS11.1 ITR1SFR#5950 Ends

            l_Subsys := 'CHARGES';
            l_Stat   := Clpks_Cldaccvm_Utils_1.Fn_Get_Subsys_Stat(p_Source, l_Subsys, l_Subsys_Stat);
            Dbg('Subsystem Status  ' || l_Subsys || '/' || l_Stat);

            IF l_Stat = 'R' THEN
               Pr_Log_Error(p_Function_Id, p_Source, 'CL-CHG-RDF', NULL);
            END IF;

            IF l_Stat IN ('D', 'R', 'U') THEN
               IF NOT Fn_Process_Charges(p_Source, p_Source_Operation, p_Function_Id, p_Action_Code, p_Cldaccvm, l_Account_Obj, p_Err_Code, p_Err_Params) THEN
                  Dbg('failed in Fn_Process_Charges..');
                  RETURN FALSE;
               END IF;
               l_Subsys_Stat := Clpks_Cldaccvm_Utils_1.Fn_Upd_Subsys_Stat('CHARGES', 'S', l_Subsys_Stat);
            END IF;

            l_Subsys := 'EXPLODE';
            l_Stat   := Clpks_Cldaccvm_Utils_1.Fn_Get_Subsys_Stat(p_Source, l_Subsys, l_Subsys_Stat);
            Dbg('Subsystem Status  ' || l_Subsys || '/' || l_Stat);

            IF l_Stat = 'R' THEN
               Pr_Log_Error(p_Function_Id, p_Source, 'CL-SCH-RDF', NULL);
            END IF;

            IF l_Stat IN ('D', 'R', 'U') THEN
               IF NOT Fn_Explode_Schedules(p_Source, p_Source_Operation, p_Function_Id, p_Action_Code, p_Cldaccvm, l_Account_Obj, p_Err_Code, p_Err_Params) THEN
                  Dbg('failed in Fn_Explode_Schedules..');
                  RETURN FALSE;
               END IF;
               l_Subsys_Stat := Clpks_Cldaccvm_Utils_1.Fn_Upd_Subsys_Stat('EXPLODE', 'S', l_Subsys_Stat);
            END IF;

            l_Subsys := 'MICTRMIS';
            l_Stat   := Clpks_Cldaccvm_Utils_1.Fn_Get_Subsys_Stat(p_Source, l_Subsys, l_Subsys_Stat);
            Dbg('Subsystem Status  ' || l_Subsys || '/' || l_Stat);
            l_Subsys_Stat := Clpks_Cldaccvm_Utils_1.Fn_Upd_Subsys_Stat('MICTRMIS', 'S', l_Subsys_Stat);
            IF l_Pickedup AND l_Stat = 'U' AND p_Wrk_Cldaccvm.Ty_Mictrmis.v_Mitbs_Class_Mapping.Unit_Ref_No IS NOT NULL THEN
               Dbg('Calling Mipks_Mictrmis_Utils.Fn_Validate....');
               IF NOT Mipks_Mictrmis_Utils.Fn_Validate(p_Source
                                                      ,l_Module
                                                      ,p_Action_Code
                                                      ,p_Function_Id
                                                      ,p_Wrk_Cldaccvm.v_Cltbs_Account_Master.Product_Code
                                                      ,p_Wrk_Cldaccvm.v_Cltbs_Account_Master.Account_Number
                                                      ,l_Event_Seq_No
                                                      ,p_Wrk_Cldaccvm.Ty_Mictrmis
                                                      ,p_Err_Code
                                                      ,p_Err_Params) THEN
                  Dbg('Failed in Mipks_Mictrmis_Utils.Fn_Validate...');
                  RETURN FALSE;
               END IF;

               Dbg('Calling  Mipks_mictrmis_utils.Fn_Upload..');
               IF NOT Mipks_Mictrmis_Utils.Fn_Upload(p_Source
                                                    ,l_Module
                                                    ,p_Action_Code
                                                    ,p_Function_Id
                                                    ,p_Wrk_Cldaccvm.v_Cltbs_Account_Master.Product_Code
                                                    ,p_Wrk_Cldaccvm.v_Cltbs_Account_Master.Account_Number
                                                    ,l_Event_Seq_No
                                                    ,p_Wrk_Cldaccvm.Ty_Mictrmis
                                                    ,p_Err_Code
                                                    ,p_Err_Params) THEN
                  Dbg('Failed in mipks_mictrmis_utils.Fn_Upload..');
                  RETURN FALSE;
               END IF;
            END IF;

         END IF;

	 --FCUBS11.1 ITR2 SFR#1085 Starts..
	 p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd.Subsystemstat := l_Subsys_Stat;
	 Dbg('Converting Back To Type...:' || p_Wrk_Cldaccvm.v_Cltbs_Account_Master.Subsystemstat);
	 IF NOT Clpks_Cldaccvm_Type_Conv.Fn_Build_Type(p_Wrk_Cldaccvm, l_Account_Obj, p_Err_Code, p_Err_Params) THEN
	    Dbg('Failed in Clpks_Cldaccvm_Type_Conv.Fn_Build_Acc_Obj..');
	    RETURN FALSE;
	 END IF;
         --FCUBS11.1 ITR2 SFR#1085 Ends..
      END IF;

      p_Wrk_Cldaccvm.v_Ui_Columns___Comp_Sch := l_Wrk_Cldaccvm.v_Ui_Columns___Comp_Sch;--FCUBS11.1 ITR1 SFR#5950
      Dbg('Returning success from Fn_Subsys_Pickup');
      RETURN TRUE;
   EXCEPTION
      WHEN OTHERS THEN
         Dbg('In when others in Fn_Subsys_Pickup ' || SQLERRM);
         p_Err_Code   := 'ST-OTHR-001';
         p_Err_Params := NULL;
         RETURN FALSE;
   END Fn_Subsys_Pickup;

   FUNCTION Fn_Delete_Account(p_Source           IN VARCHAR2
                             ,p_Source_Operation IN VARCHAR2
                             ,p_Function_Id      IN VARCHAR2
                             ,p_Action_Code      IN VARCHAR2
                             ,p_Cldaccvm         IN OUT Clpks_Cldaccvm_Main.Ty_Cldaccvm
                             ,p_Err_Code         IN OUT VARCHAR2
                             ,p_Err_Params       IN OUT VARCHAR2) RETURN BOOLEAN IS
      l_Account_Obj      Clpkss_Object.Ty_Rec_Account;	 --RONBTR#FCC11.1#SFR483
      l_Account_Number   Cltbs_Account_Master.Account_Number%TYPE;
      l_Auth_Stat        VARCHAR2(1);
      l_Function_Id      Smtb_Menu.Function_Id%TYPE;
      l_Rec_Account_Vamd Cltbs_Account_Vamd%ROWTYPE;
      l_Esn              Cltbs_Account_Vamd.Vamb_Esn%TYPE;
      --RONBTR#FCC11.1#SFR483 Starts
     TYPE Ty_Tb_Linkage IS TABLE OF Cltb_Account_Linkages%ROWTYPE INDEX BY PLS_INTEGER;
      l_Tb_Linkage  Ty_Tb_Linkage;
      l_Indx_Link   PLS_INTEGER;
      l_Link_Count1 NUMBER;

     CURSOR Cur_Acc_Vamicom(p_Account_No Cltb_Account_Linkages.Account_Number%TYPE, p_Branch_Code Cltb_Account_Linkages.Branch_Code%TYPE) IS
         SELECT *
         FROM   Cltb_Account_Linkages
         WHERE  Account_Number = p_Account_No AND Branch_Code = p_Branch_Code AND Linkage_Type = 'M';
       --RONBTR#FCC11.1#SFR483 Ends
   BEGIN
      Dbg('In Fn_Delete_Account');
      l_Function_Id := Clpks_Cldaccvm_Type_Conv.Fn_Get_Context_Fid(p_Function_Id);

      IF p_Cldaccvm.v_Cltbs_Account_Master.Account_Number IS NULL THEN
         l_Account_Number := p_Cldaccvm.v_Cltbs_Account_Master.Alt_Acc_No;
         IF NOT Cspkss_Validate_Unit.Fn_Get_Cl_Acno(p_Cldaccvm.v_Cltbs_Account_Master.Branch_Code, l_Account_Number) THEN
            Dbg('fn_resolve_account_no failed with');
            RETURN FALSE;
         END IF;
         Dbg('After fn_resolve_account_no, Resolved Account No::' || l_Account_Number);
      END IF;

      BEGIN
         SELECT *
         INTO   l_Rec_Account_Vamd
         FROM   Cltbs_Account_Vamd
         WHERE  Account_Number = p_Cldaccvm.v_Cltbs_Account_Master.Account_Number
         AND    Branch_Code = p_Cldaccvm.v_Cltbs_Account_Master.Branch_Code
         AND    Auth_Stat = 'U';
         Dbg('Validating delete');
         BEGIN
            SELECT MAX(Event_Seq_No)
            INTO   l_Esn
            FROM   Cltbs_Account_Events_Diary
            WHERE  Account_Number = p_Cldaccvm.v_Cltbs_Account_Master.Account_Number
            AND    Branch_Code = p_Cldaccvm.v_Cltbs_Account_Master.Branch_Code
            AND    Event_Code = 'VAMB';
         EXCEPTION
            WHEN No_Data_Found THEN
               Dbg('No VAMB is done yet in this account, so returning false');
               RETURN FALSE;
         END;

         IF l_Esn IS NOT NULL THEN
            Dbg('Checking for auth stat');
            SELECT Auth_Stat
            INTO   l_Auth_Stat
            FROM   Cltbs_Account_Vamd
            WHERE  Account_Number = p_Cldaccvm.v_Cltbs_Account_Master.Account_Number
            AND    Branch_Code = p_Cldaccvm.v_Cltbs_Account_Master.Branch_Code
            AND    Amend_Applied = 'N' --Log#1 changes
            AND    Vamb_Esn = l_Esn;

         END IF;
         IF Nvl(l_Auth_Stat, '*') = 'A' THEN
            Dbg('Loan is authorized, so it can not be deleted');
            p_Err_Code   := 'CL-IFACE03;';
            p_Err_Params := p_Cldaccvm.v_Cltbs_Account_Master.Account_Number || '~;';
            RETURN FALSE;
         END IF;

         Dbg('Calling clpkss_vd_amendment.fn_delete_vami_account');
         IF NOT Clpkss_Vd_Amendment.Fn_Delete_Vami_Account(l_Rec_Account_Vamd.Branch_Code
                                                          ,l_Rec_Account_Vamd.Account_Number
                                                          ,l_Rec_Account_Vamd.Effective_Date
                                                          ,l_Rec_Account_Vamd.Auth_Stat
                                                          ,p_Err_Code
                                                          ,p_Err_Params) THEN
            Dbg('clpkss_vd_amendment.fn_delete_vami_account Failed with :-( ' || p_Err_Code || ':' || p_Err_Params);
            RETURN FALSE;
         END IF;
         --RONBTR#FCC11.1#SFR483 Starts
         Dbg('Converting into Account Object..');
          IF NOT Clpks_Cldaccvm_Type_Conv.Fn_Build_Acc_Obj(l_Account_Obj, p_Cldaccvm, p_Err_Code, p_Err_Params) THEN
         Dbg('Failed in Clpks_Cldaccvm_Type_Conv.Fn_Build_Acc_Obj..');
         RETURN FALSE;
         END IF;

        OPEN Cur_Acc_Vamicom( l_Account_Obj.Account_Det.Account_Number, l_Account_Obj.Account_Det.Branch_Code);
         FETCH Cur_Acc_Vamicom BULK COLLECT
            INTO l_Tb_Linkage;
         CLOSE Cur_Acc_Vamicom;
          Dbg('Count of Linakage '|| l_Tb_Linkage.COUNT);
          IF l_Tb_Linkage.COUNT > 0 THEN
            l_Indx_Link := l_Tb_Linkage.FIRST;
            WHILE l_Indx_Link IS NOT NULL LOOP
              dbg('l_Account_Obj.g_Acc_Linkages.COUNT' ||l_Account_Obj.g_Acc_Linkages.COUNT);
              IF l_Account_Obj.g_Acc_Linkages.COUNT = 0 THEN
                  BEGIN
                     SELECT COUNT(*)
                     INTO   l_Link_Count1
                     FROM   Cltbs_Commit_Utils
                     WHERE  Commit_Contract_No = l_Tb_Linkage(l_Indx_Link).Linked_Ref_No AND Commit_Brn_Code = l_Tb_Linkage(l_Indx_Link)
                     .Linkage_Branch AND Commit_Event = 'LINK';
      EXCEPTION
                     WHEN OTHERS THEN
                        l_Link_Count1 := 0;
                  END;
                  dbg(' l_Tb_Linkage(l_Indx_Link).linkage_amount' ||l_Tb_Linkage(l_Indx_Link).linkage_amount);
                  IF nvl(l_Tb_Linkage(l_Indx_Link).linkage_amount,0) > 0
                  THEN
                     Dbg(' Clpkss_Commitment.fn_process_link');
                     IF NOT Clpkss_Commitment.Fn_Process_Link(l_Account_Obj
                                                              ,'VAMI'
                                                              ,l_Rec_Account_Vamd.Effective_Date
                                                              ,l_Tb_Linkage(l_Indx_Link).linkage_amount
                                                              ,p_Err_Code
                                                              ,p_Err_Params
                                                              ,'D') THEN
                     Dbg('Clpkss_Commitment.fn_process_link failed with :-( ' || p_Err_Code || ':' || p_Err_Params);
                     RETURN FALSE;
                     END IF;
                  END IF;
              END IF;
            l_Indx_Link := l_Tb_Linkage.NEXT(l_Indx_Link);
          END LOOP;
       END IF;
  -- --RONBTR#FCC11.1#SFR483 Starts


      EXCEPTION
         WHEN No_Data_Found THEN
            Dbg('No Amendment to delete');
            Dbg('No Account Found.');
            p_Err_Code   := 'IS-VLD018;';
            p_Err_Params := '~';
      END;

      Dbg('Success from Fn_Delete_Account');
      RETURN TRUE;
   EXCEPTION
      WHEN OTHERS THEN
         Dbg('In when others in Fn_Delete_Account ' || SQLERRM);
         p_Err_Code   := 'ST-OTHR-001';
         p_Err_Params := NULL;
         RETURN FALSE;
   END Fn_Delete_Account;

   FUNCTION Fn_Modify_Account(p_Source           IN VARCHAR2
                             ,p_Source_Operation IN VARCHAR2
                             ,p_Function_Id      IN VARCHAR2
                             ,p_Action_Code      IN VARCHAR2
                             ,p_Cldaccvm         IN OUT Clpks_Cldaccvm_Main.Ty_Cldaccvm
                             ,p_Err_Code         IN OUT VARCHAR2
                             ,p_Err_Params       IN OUT VARCHAR2) RETURN BOOLEAN IS
      l_Is_In_Msg_Clob     VARCHAR2(1);
      l_Err_Msg_Type       VARCHAR2(100);
      l_Parents_List       VARCHAR2(32767);
      l_Parents_Format     VARCHAR2(32767);
      l_Ts_Tag_Names       VARCHAR2(32767);
      l_Ts_Tag_Values      VARCHAR2(32767);
      l_Ts_Tag_Format      VARCHAR2(32767);
      l_Ts_Clob_Tag_Names  CLOB;
      l_Ts_Clob_Tag_Values CLOB;
      l_Ts_Clob_Tag_Format CLOB;
      l_Res_Parents_List   VARCHAR2(32767);
      l_Res_Parents_Format VARCHAR2(32767) := '1';
      l_Res_Ts_Tag_Names   VARCHAR2(32767);
      l_Res_Ts_Tag_Values  VARCHAR2(32767);
      p_Key                VARCHAR2(32767);
      p_Data               VARCHAR2(32767);
      p_Parent             VARCHAR2(32767);
      p_Format             VARCHAR2(32767);
      l_Is_Tag_Clob        VARCHAR2(1);
      p_Rowid              ROWID;
      Error_Exception EXCEPTION;
      l_Account_Obj    Clpkss_Object.Ty_Rec_Account;
      l_Err_Tbl        Ovpks.Tbl_Error;
      l_Status         VARCHAR2(1) := 'A';
      l_Simulation     BOOLEAN := FALSE;
      l_Calc_Gp        BOOLEAN := FALSE;
      l_Rec_Upload_Mis Mitbs_Upload_Class_Mapping%ROWTYPE;
      --l_Udf_Obj         Gwpks_Cl_Account_Ts_To_Ty.Ty_Tb_Udf_Details;
      l_Praties_Flag       BOOLEAN;
      l_Ude_Value          Cltbs_Account_Ude_Values.Ude_Value%TYPE;
      l_Rate_Code          Cltbs_Account_Ude_Values.Rate_Code%TYPE;
      l_Amount_Financed    Cltbs_Account_Master.Amount_Financed%TYPE;
      l_Maturity_Date      Cltbs_Account_Master.Maturity_Date%TYPE;
      l_Account_Obj_Temp   Clpkss_Object.Ty_Rec_Account;
      l_Ude_Id             Cltbs_Account_Ude_Values.Ude_Id%TYPE;
      l_Idx                PLS_INTEGER;
      l_Idx_Ude_Dt         PLS_INTEGER;
      l_Idxrate            VARCHAR2(35);
      l_Ude_Val            VARCHAR2(35);
      l_Comp_Name          VARCHAR2(35);
      l_Comp_Sch           VARCHAR2(35);
      l_Comp               VARCHAR2(35);
      l_Spl_Int            NUMBER;
      l_Rollback           VARCHAR2(1) := 'N';
      l_Process_Status     VARCHAR2(1) := 'S';
      l_Contract_Ref_No    Cltbs_Account_Master.Account_Number%TYPE;
      l_Tb_Event_Ovd       Clpks_Util.Ty_Tb_Event_Ovd;
      l_Tb_Cl_Event_Ovd    Clpks_Dml.Ty_Tb_Event_Ovd;
      Lmsg                 VARCHAR2(200);
      Ltype                VARCHAR2(10);
      l_Accno              Cltb_Account_Apps_Master.Account_Number%TYPE;
      l_Brn                Cltb_Account_Apps_Master.Branch_Code%TYPE;
      l_Effdt              DATE;
      l_Effdtd             DATE;
      l_Account_Objs       Clpkss_Object.Ty_Rec_Account;
      l_Roll_Obj           Clpkss_Rollover_Object.Ty_Rec_Rollover;
      g_Fmt_Count          NUMBER := 0;
      g_Fmt_Count1         NUMBER := 0;
      l_Party              Cltb_Account_Parties.Customer_Id%TYPE;
      l_Defer_Flag         VARCHAR2(1) := 'N';
      l_Key                VARCHAR2(32767);
      l_Account_Rec        Cltbs_Account_Master%ROWTYPE;
      l_Rate               NUMBER;
      l_Amount_Scy         NUMBER;
      l_Simulated          BOOLEAN := FALSE;
      l_Party1             Cltb_Account_Parties.Customer_Id%TYPE;
      l_Cust_Found         BOOLEAN; --FC10.5 STR1 SFR# 3606
      l_Downpayment_Amount Cltb_Account_Master.Downpayment_Amount%TYPE; -- Yastemp
      l_Unit               VARCHAR2(1); -- Yastemp
      l_Lease_Type         VARCHAR2(1); -- Yastemp
      --RONBTR#FCC11.1#SFR483 Starts
     TYPE Ty_Tb_Linkage IS TABLE OF Cltb_Account_Linkages%ROWTYPE INDEX BY PLS_INTEGER;
      l_Tb_Linkage  Ty_Tb_Linkage;
      l_Indx_Link   PLS_INTEGER;
      l_Link_Count1 NUMBER;
      --RONBTR#FCC11.1#SFR483 Ends

      CURSOR Sch_Dates IS
         SELECT Schedule_Due_Date
         FROM   Cltb_Account_Schedules
         WHERE  Account_Number = l_Accno
         AND    Schedule_Due_Date != Clpks_Util.Pkg_Eternity; -- Yastemp
      l_Is_Schedule_Date NUMBER := 0; -- Yastemp
      l_Module           VARCHAR2(2); -- Yastemp
      l_Residual_Amt     NUMBER; -- Yastemp
      l_Sub_Res_Amt      NUMBER; -- Yastemp
      --Log#28 changes starts
      Indx         PLS_INTEGER;
      Indx2        PLS_INTEGER;
      l_Hol_Period BOOLEAN := FALSE;
      l_Eff_Date   DATE;
      --Log#28 changes ends
      --Log#27 Starts
      CURSOR c_Linked_Account(p_Linked_Contract Cltbs_Account_Master.Account_Number%TYPE, p_Linked_Branch Cltbs_Account_Master.Branch_Code%TYPE) IS
         SELECT a.*
         FROM   Cltb_Account_Linkages a
         WHERE  a.Linked_Ref_No = p_Linked_Contract
         AND    a.Linkage_Branch = p_Linked_Branch
         AND    a.Linkage_Type = 'M';
      --RONBTR#FCC11.1#SFR483 Starts
     CURSOR Cur_Acc_Vamicom(p_Account_No Cltb_Account_Linkages.Account_Number%TYPE, p_Branch_Code Cltb_Account_Linkages.Branch_Code%TYPE) IS
         SELECT *
         FROM   Cltb_Account_Linkages
         WHERE  Account_Number = p_Account_No AND Branch_Code = p_Branch_Code AND Linkage_Type = 'M';
       --RONBTR#FCC11.1#SFR483 Ends
      l_Loan_To_Value     Cltbs_Account_Master.Loan_To_Value%TYPE;
      l_Acc_Maturity_Date Cltbs_Account_Master.Maturity_Date%TYPE := '01-JAN-1900';
      l_Rec_Account       Cltbs_Account_Master%ROWTYPE;
      Nls_Dt_Format       VARCHAR2(40);
      l_Acc_Max_Sch_Dt    Cltb_Disbr_Schedules.Schedule_Due_Date%TYPE; --Log#31
      --Log#27 Ends
	-- 3-16663240851 starts
	 l_prior_dt   PLS_INTEGER;
	 TYPE ty_tb_comp_elems is TABLE of PLS_INTEGER INDEX by cltms_product_comp_frm_elems.component_name%TYPE;
	 l_tb_comp_elems ty_tb_comp_elems;
	-- 3-16663240851 ends
   BEGIN
      Dbg('In Fn_Modify_account');
 -- Kernel 11.3_RET_SFR_12401757 changes starts
       IF p_Cldaccvm.v_cltbs_account_master.AMOUNT_DISBURSED > p_Cldaccvm.v_cltbs_account_master.AMOUNT_FINANCED
             THEN
             p_Cldaccvm.v_cltbs_account_master.AMOUNT_DISBURSED:=p_Cldaccvm.v_cltbs_account_master.AMOUNT_FINANCED;
             END IF;
        dBG('p_Cldaccvm.v_Cltbs_Account_Vamd.AUTH_STAT:'||p_Cldaccvm.v_Cltbs_Account_Vamd.AUTH_STAT);
        IF p_Source_Operation = 'CLDACCVM_MODIFY' AND p_Cldaccvm.v_Cltbs_Account_Vamd.AUTH_STAT='U' THEN
                          IF NOT CLPKS_VD_AMENDMENT.fn_delete_vami_account(p_Cldaccvm.v_Cltbs_Account_Vamd.branch_code
                                  ,p_Cldaccvm.v_Cltbs_Account_Vamd.ACCOUNT_NUMBER
                                  ,p_Cldaccvm.v_Cltbs_Account_Vamd.Effective_Date
                                  ,'U'
                                  ,p_Err_Code
                                  ,p_Err_Params)
                          THEN
                          DBG('FAILED TO DELETE VAMI');
                          END IF;
         END IF;
      -- Kernel 11.3_RET_SFR_12401757 ends
      l_Chg_Vami(1).l_Princchanged := 'N';
      l_Chg_Vami(1).l_Matdatechanged := 'N';
      l_Chg_Vami(1).l_Ratecodechanged := 'N';
      l_Chg_Vami(1).l_Schaffected := 'N';
      l_Chg_Vami(1).l_Ratechanged := 'N'; --Log#1 changes
      l_Chg_Vami(1).l_Residual_Amt_Changed := 'N'; -- Yastemp
      l_Chg_Vami(1).l_Sub_Residual_Amt_Changed := 'N'; -- Yastemp changes for VAMI

      Dbg('Converting into Account Object..');
      IF NOT Clpks_Cldaccvm_Type_Conv.Fn_Build_Acc_Obj(l_Account_Obj, p_Cldaccvm, p_Err_Code, p_Err_Params) THEN
         Dbg('Failed in Clpks_Cldaccvm_Type_Conv.Fn_Build_Acc_Obj..');
         RETURN FALSE;
      END IF;

      l_Eff_Date := p_Cldaccvm.v_Cltbs_Account_Vamd.Effective_Date;

      SELECT Amount_Financed, Maturity_Date, Nvl(Downpayment_Amount, 0), -- Yastemp -- Log#36
             Lease_Type, -- Yastemp
             Module_Code, -- YaStemp
             Frequency_Unit, -- Yastemp
             Nvl(Residual_Value, 0), -- Yastemp -- Log#36
             Nvl(Residual_Subsidy_Value, 0) -- Yastemp -- Log#36
            , Loan_To_Value --Log#26
      INTO   l_Amount_Financed, l_Maturity_Date, l_Downpayment_Amount, -- Yastemp
             l_Lease_Type, -- Yastemp
             l_Module, -- Yastemp
             l_Unit, -- Yastemp
             l_Residual_Amt, -- Yastemp
             l_Sub_Res_Amt -- Yastemp
            , l_Loan_To_Value --Log#26
      FROM   Cltbs_Account_Master
      WHERE  Account_Number = l_Account_Obj.Account_Det.Account_Number
      AND    Branch_Code = l_Account_Obj.Account_Det.Branch_Code;

      Dbg('Doing for Principal change');
      Dbg('l_amount_financed ' || l_Amount_Financed);
      Dbg('Yasser pkg_cldaccdt.pkgfuncid ==> ' || Pkg_Cldaccdt.Pkgfuncid);

      IF C3pk#_Prd_Shell.Fn_Get_Contract_Info(l_Account_Obj.Account_Det.Account_Number
                                             ,l_Account_Obj.Account_Det.Branch_Code
                                             ,'LOAN_TYPE'
                                             ,l_Account_Obj.Account_Det.Product_Code) <> 'R' THEN
         --Log#26 Ends

         IF Clpkss_Cache.Fn_Product(l_Account_Obj.Account_Det.Product_Code)
         .Disbursement_Mode = 'A' AND Nvl(l_Amount_Financed, 0) <> Nvl(l_Account_Obj.Account_Det.Amount_Financed, 0) --Log#2 changes
          THEN
            l_Chg_Vami(1).l_Princchanged := 'Y';
            Dbg('l_chg_vami(1) .l_princchanged is : ' || l_Chg_Vami(1).l_Princchanged);

            --START Prasanna/Saravanan. FCC-CL 4.0. ITR2. SFR#1106. 14-Sep-2007. Log#5
            l_Account_Obj.Account_Det.Net_Principal := Nvl(l_Account_Obj.Account_Det.Amount_Financed, 0);
            --END Prasanna/Saravanan. FCC-CL 4.0. ITR2. SFR#1106. 14-Sep-2007. Log#5
         ELSIF Clpkss_Cache.Fn_Product(l_Account_Obj.Account_Det.Product_Code)
         .Disbursement_Mode = 'M' AND Nvl(l_Amount_Financed, 0) <> Nvl(l_Account_Obj.Account_Det.Amount_Financed, 0) --Log#2 changes
          THEN
            IF Nvl(l_Account_Obj.Account_Det.Lease_Type, '#') <> 'O' THEN
               -- Log#30 added newly -- log#33 OL VAMI
               l_Chg_Vami(1).l_Princchanged := 'N';
               -- Log#30 added newly STARTS
            ELSE
               l_Chg_Vami(1).l_Princchanged := 'Y';
            END IF;
            -- Log#30 added newly STARTS
            Dbg('l_chg_vami(1) .l_princchanged is ELSE  : ' || l_Chg_Vami(1).l_Princchanged);
         END IF;
         --Log#26 Starts
      ELSE
         IF Clpkss_Cache.Fn_Product(l_Account_Obj.Account_Det.Product_Code)
         .Disbursement_Mode = 'A' AND Nvl(l_Loan_To_Value, 0) <> Nvl(l_Account_Obj.Account_Det.Loan_To_Value, 0) THEN
            l_Chg_Vami(1).l_Princchanged := 'Y';
         ELSE
            l_Chg_Vami(1).l_Princchanged := 'N';
         END IF;
      END IF;

      --Log#27 Starts
      IF Nvl(l_Account_Rec.Mortgage_Group, 'N') = 'Y' THEN
         Dbg('Its a case of Mortgage Group Maturity Date Change');
         IF c_Linked_Account%ISOPEN THEN
            CLOSE c_Linked_Account;
         END IF;
         FOR Linked_Acc IN c_Linked_Account(l_Account_Obj.Account_Det.Account_Number, l_Account_Obj.Account_Det.Branch_Code) LOOP
            Dbg('This Commitment is Linked to ' || Linked_Acc.Account_Number || '~' || Linked_Acc.Branch_Code);
            l_Rec_Account := Clpkss_Cache.Fn_Account_Master(Linked_Acc.Account_Number, Linked_Acc.Branch_Code);
            Dbg('Maturity date for ' || l_Rec_Account.Account_Number || ' is ' || l_Rec_Account.Maturity_Date);
            IF l_Acc_Maturity_Date < l_Rec_Account.Maturity_Date THEN
               l_Acc_Maturity_Date := l_Rec_Account.Maturity_Date;
            END IF;
         END LOOP;
         Dbg('Linked Loan Highest Maturity Date is ' || l_Acc_Maturity_Date);
         Nls_Dt_Format := Global.Get_Nls_Dt_Format;
         IF l_Acc_Maturity_Date > l_Account_Obj.Account_Det.Maturity_Date THEN
            p_Err_Code   := 'CL-MOG-02;';
            p_Err_Params := l_Account_Obj.Account_Det.Account_Number || '~' || To_Char(l_Acc_Maturity_Date, Nls_Dt_Format) || '~;';
            Ovpkss.Pr_Appendtbl(p_Err_Code, p_Err_Params);
            RAISE Error_Exception;
         END IF;
         IF l_Acc_Maturity_Date > l_Account_Obj.g_Rec_Comm_Preference.g_Comm_Preference.Maturity_Dt THEN
            p_Err_Code   := 'CL-MOG-03;';
            p_Err_Params := l_Account_Obj.Account_Det.Account_Number || '~' || To_Char(l_Acc_Maturity_Date, Nls_Dt_Format) || '~;';
            Ovpkss.Pr_Appendtbl(p_Err_Code, p_Err_Params);
            RAISE Error_Exception;
         END IF;
         --Log#31 Starts
         SELECT MAX(Schedule_Due_Date)
         INTO   l_Acc_Max_Sch_Dt
         FROM   Cltb_Disbr_Schedules
         WHERE  (Account_Number, Branch_Code) IN (SELECT Account_Number, Branch_Code
                                                  FROM   Cltb_Account_Linkages a
                                                  WHERE  a.Linked_Ref_No = l_Account_Obj.Account_Det.Account_Number
                                                  AND    a.Linkage_Branch = l_Account_Obj.Account_Det.Branch_Code
                                                  AND    a.Linkage_Type = 'M');
         Dbg('l_acc_max_sch_dt is ' || l_Acc_Max_Sch_Dt || '~' || l_Account_Obj.g_Rec_Comm_Preference.g_Comm_Preference.Last_Dsbr_Dt);
         IF l_Acc_Max_Sch_Dt > l_Account_Obj.g_Rec_Comm_Preference.g_Comm_Preference.Last_Dsbr_Dt THEN
            Dbg('Mortgage Group Commitment contract $1 can not have Last Available Date less than $2.');
            p_Err_Code   := 'CL-MOG-04;';
            p_Err_Params := l_Account_Obj.Account_Det.Account_Number || '~' || To_Char(l_Acc_Max_Sch_Dt, Nls_Dt_Format) || '~;';
            Ovpkss.Pr_Appendtbl(p_Err_Code, p_Err_Params);
            RAISE Error_Exception;
         END IF;
         --Log#31 Ends
      END IF;
      --Log#27 Ends
      --RONBTR#FCC11.1#SFR483 Starts

        OPEN Cur_Acc_Vamicom( l_Account_Obj.Account_Det.Account_Number, l_Account_Obj.Account_Det.Branch_Code);
         FETCH Cur_Acc_Vamicom BULK COLLECT
            INTO l_Tb_Linkage;
         CLOSE Cur_Acc_Vamicom;
          Dbg('Count of Linakage '|| l_Tb_Linkage.COUNT);
          IF l_Tb_Linkage.COUNT > 0 THEN
            l_Indx_Link := l_Tb_Linkage.FIRST;
            WHILE l_Indx_Link IS NOT NULL LOOP
            IF l_Account_Obj.g_Acc_Linkages.COUNT = 0 THEN
                  BEGIN
                     SELECT COUNT(*)
                     INTO   l_Link_Count1
                     FROM   Cltbs_Commit_Utils
                     WHERE  Commit_Contract_No = l_Tb_Linkage(l_Indx_Link).Linked_Ref_No AND Commit_Brn_Code = l_Tb_Linkage(l_Indx_Link)
                     .Linkage_Branch AND Commit_Event = 'LINK';
                  EXCEPTION
                     WHEN OTHERS THEN
                        l_Link_Count1 := 0;
                  END;

                  IF nvl(l_Tb_Linkage(l_Indx_Link).linkage_amount,0) > 0
                  THEN
                  Dbg(' Clpkss_Commitment.fn_process_dlnk');
				  g_is_remove_commitment := true; --Log#18 Changes
                      IF NOT Clpkss_Commitment.Fn_Process_Dlnk(l_Account_Obj
                                                    ,'VAMI'
                                                    ,l_Eff_Date
                                                    ,l_Tb_Linkage(l_Indx_Link).linkage_amount
                                                     ,p_Err_Code
                                                    ,p_Err_Params) THEN
                   Dbg('Clpkss_Commitment.fn_process_dlnk failed with :-( ' || p_Err_Code || ':' || p_Err_Params);
                   RETURN FALSE;
                  END IF;
				  g_is_remove_commitment := false; --Log#18 Changes
           END IF;
         END IF;
         l_Indx_Link := l_Tb_Linkage.NEXT(l_Indx_Link);
        END LOOP;
   END IF;
    --RONBTR#FCC11.1#SFR483 Ends
      IF Clpkss_Cache.Fn_Product(l_Account_Obj.Account_Det.Product_Code).Disbursement_Mode = 'A' AND l_Maturity_Date <> l_Account_Obj.Account_Det.Maturity_Date THEN
         l_Chg_Vami(1).l_Matdatechanged := 'Y';
         Dbg('l_chg_vami(1) .l_matdatechanged is : ' || l_Chg_Vami(1).l_Matdatechanged);
      ELSIF Clpkss_Cache.Fn_Product(l_Account_Obj.Account_Det.Product_Code)
      .Disbursement_Mode = 'M' AND l_Maturity_Date <> l_Account_Obj.Account_Det.Maturity_Date THEN

         IF Nvl(l_Account_Obj.Account_Det.Lease_Type, '#') <> 'O' THEN
            -- Log#30 added newly -- log#33 OL VAMI
            l_Chg_Vami(1).l_Matdatechanged := 'N';
            -- Log#30 added newly STARTS
         ELSE
            l_Chg_Vami(1).l_Matdatechanged := 'Y';
         END IF;
         -- Log#30 added newly STARTS
         Dbg('l_chg_vami(1) .l_matdatechanged is  ELSE: ' || l_Chg_Vami(1).l_Matdatechanged);
      END IF;

      -- Yastemp
      IF Nvl(l_Account_Obj.Account_Det.Lease_Type, '#') IN ('F', 'O') THEN
         -- Log#30 added newly -- log#33 OL VAMI
         IF l_Residual_Amt <> l_Account_Obj.Account_Det.Residual_Amount THEN
            -- log#33 OL VAMI
            l_Chg_Vami(1) . l_Residual_Amt_Changed := 'Y';
            Dbg('l_chg_vami(1) .l_residual_amt_changed is   ' || l_Chg_Vami(1).l_Residual_Amt_Changed);
         END IF;
         -- Yastemp changes for VAMI
         IF l_Sub_Res_Amt <> l_Account_Obj.Account_Det.Residual_Subsidy_Value THEN
            l_Chg_Vami(1) . l_Sub_Residual_Amt_Changed := 'Y';
            Dbg('l_chg_vami(1) .l_sub_residual_amt_changed is   ' || l_Chg_Vami(1).l_Sub_Residual_Amt_Changed);
         END IF;
      END IF;
      -- Yastemp changes for VAMI

      IF Nvl(l_Account_Obj.Account_Det.Lease_Type, '#') <> 'O' THEN
         -- Log#29 ends
         -- commenting for Log#36 starts
         /* IF l_sub_res_amt <> l_Account_Obj.Account_Det.residual_subsidy_value THEN
           UPDATE CLTB_ACCOUNT_SCHEDULES
              SET amount_due        = l_Account_Obj.Account_Det.residual_value - l_Account_Obj.Account_Det.residual_subsidy_value
            WHERE account_number    = l_Account_Obj.Account_Det.account_number
              AND component_name    = 'PRINCIPAL'
              AND schedule_due_date = CLPKS_UTIL.pkg_eternity;
         END IF; */ -- commenting for Log#36 ends
         Dbg('Financial Lease'); -- Log#36
         -- Log#29 starts
      ELSIF Nvl(l_Account_Obj.Account_Det.Lease_Type, '#') = 'O' THEN
         IF l_Sub_Res_Amt <> l_Account_Obj.Account_Det.Residual_Subsidy_Value THEN
            UPDATE Cltb_Account_Schedules
            SET    Amount_Due = l_Account_Obj.Account_Det.Residual_Value - l_Account_Obj.Account_Det.Residual_Subsidy_Value
            WHERE  Account_Number = l_Account_Obj.Account_Det.Account_Number
            AND    Component_Name = 'MAIN_INT'
            AND    Schedule_Due_Date = Clpks_Util.Pkg_Eternity;
         END IF;
      END IF;
      -- Log#29 ends
      -- Yastemp

      l_Account_Obj.Account_Det.Funded_Status := 1000;

      -- log#6 changes start
      IF Nvl(l_Amount_Financed, 0) >= Nvl(l_Account_Obj.Account_Det.Amount_Financed, 0) THEN
         IF l_Account_Obj.g_Tb_Event_Adv.COUNT > 0 THEN
            FOR i IN 1 .. l_Account_Obj.g_Tb_Event_Adv.COUNT LOOP
               IF l_Account_Obj.g_Tb_Event_Adv(i).Events_Advices_Det.Msg_Type = 'PAYMENT_MESSAGE' THEN
                  l_Account_Obj.g_Tb_Event_Adv(i).Events_Advices_Det.Suppress := 'Y';
               END IF;
            END LOOP;
         END IF;
      END IF;
      -- Log#29 starts
      IF Nvl(l_Account_Obj.Account_Det.Lease_Type, '#') <> 'O' THEN
         -- Log#29 ends
         IF l_Account_Obj.g_Tb_Settl_Dtls.g_Acc_Settl_Details.Account_Number IS NOT NULL THEN
            l_Account_Obj.g_Tb_Settl_Dtls.g_Acc_Settl_Details.Account        := l_Account_Obj.g_Tb_Components(Pkg_Principal).Comp_Det.Cr_Prod_Ac;
            l_Account_Obj.g_Tb_Settl_Dtls.g_Acc_Settl_Details.Acc_Branch     := l_Account_Obj.g_Tb_Components(Pkg_Principal).Comp_Det.Cr_Acc_Brn;
            l_Account_Obj.g_Tb_Settl_Dtls.g_Acc_Settl_Details.Acc_Ccy        := l_Account_Obj.g_Tb_Components(Pkg_Principal).Comp_Det.Settlement_Ccy;
            l_Account_Obj.g_Tb_Settl_Dtls.g_Acc_Settl_Details.Value_Date     := l_Eff_Date;
            l_Account_Obj.g_Tb_Settl_Dtls.g_Acc_Settl_Details.Settlement_Amt := Nvl(l_Account_Obj.Account_Det.Amount_Financed, 0) - Nvl(l_Amount_Financed, 0);
            -- FC10.5 CL changes start
            IF l_Account_Obj.Account_Det.Currency <> l_Account_Obj.g_Tb_Settl_Dtls.g_Acc_Settl_Details.Acc_Ccy THEN
               IF NOT Clpkss_Util.Fn_Amt1_To_Amt2(l_Account_Obj.Account_Det.Branch_Code
                                                 ,l_Account_Obj.Account_Det.Account_Number
                                                 ,l_Account_Obj.Account_Det.Product_Code
                                                 ,l_Account_Obj.Account_Det.Currency
                                                 ,l_Account_Obj.g_Tb_Settl_Dtls.g_Acc_Settl_Details.Acc_Ccy
                                                 ,l_Account_Obj.g_Tb_Settl_Dtls.g_Acc_Settl_Details.Settlement_Amt
                                                 ,'Y'
                                                 ,l_Amount_Scy
                                                 ,l_Rate
                                                 ,p_Err_Code
                                                 ,NULL
                                                 ,'B') THEN
                  Dbg('Failed in the function cypkss.fn_amt1_to_amt2');
                  RAISE Error_Exception;
               END IF;
               l_Account_Obj.g_Tb_Settl_Dtls.g_Acc_Settl_Details.Settlement_Amt := l_Amount_Scy;
            END IF;
            -- FC10.5 CL changes end
         END IF;
         -- Log#29 starts
      ELSIF Nvl(l_Account_Obj.Account_Det.Lease_Type, '#') = 'O' THEN
         IF l_Account_Obj.g_Tb_Settl_Dtls.g_Acc_Settl_Details.Account_Number IS NOT NULL THEN
            l_Account_Obj.g_Tb_Settl_Dtls.g_Acc_Settl_Details.Account        := l_Account_Obj.g_Tb_Components(Pkg_Main_Int).Comp_Det.Cr_Prod_Ac;
            l_Account_Obj.g_Tb_Settl_Dtls.g_Acc_Settl_Details.Acc_Branch     := l_Account_Obj.g_Tb_Components(Pkg_Main_Int).Comp_Det.Cr_Acc_Brn;
            l_Account_Obj.g_Tb_Settl_Dtls.g_Acc_Settl_Details.Acc_Ccy        := l_Account_Obj.g_Tb_Components(Pkg_Main_Int).Comp_Det.Settlement_Ccy;
            l_Account_Obj.g_Tb_Settl_Dtls.g_Acc_Settl_Details.Value_Date     := l_Eff_Date;
            l_Account_Obj.g_Tb_Settl_Dtls.g_Acc_Settl_Details.Settlement_Amt := Nvl(l_Account_Obj.Account_Det.Amount_Financed, 0) - Nvl(l_Amount_Financed, 0);
            -- FC10.5 CL changes start
            IF l_Account_Obj.Account_Det.Currency <> l_Account_Obj.g_Tb_Settl_Dtls.g_Acc_Settl_Details.Acc_Ccy THEN
               IF NOT Clpkss_Util.Fn_Amt1_To_Amt2(l_Account_Obj.Account_Det.Branch_Code
                                                 ,l_Account_Obj.Account_Det.Account_Number
                                                 ,l_Account_Obj.Account_Det.Product_Code
                                                 ,l_Account_Obj.Account_Det.Currency
                                                 ,l_Account_Obj.g_Tb_Settl_Dtls.g_Acc_Settl_Details.Acc_Ccy
                                                 ,l_Account_Obj.g_Tb_Settl_Dtls.g_Acc_Settl_Details.Settlement_Amt
                                                 ,'Y'
                                                 ,l_Amount_Scy
                                                 ,l_Rate
                                                 ,p_Err_Code
                                                 ,NULL
                                                 ,'B') THEN
                  Dbg('Failed in the function cypkss.fn_amt1_to_amt2');
                  RAISE Error_Exception;
               END IF;
               l_Account_Obj.g_Tb_Settl_Dtls.g_Acc_Settl_Details.Settlement_Amt := l_Amount_Scy;
            END IF;
            -- FC10.5 CL changes end
         END IF;
      END IF;

      IF NOT Clpkss_Object.Fn_Clear_Acc_Object(l_Account_Obj_Temp, p_Err_Code, p_Err_Params) THEN
         Dbg('Failed in clearing account object :: ' || p_Err_Code);
         RAISE Error_Exception;
      END IF;

      IF NOT Clpkss_Object.Fn_Create_Acct_Object(l_Account_Obj.Account_Det.Account_Number
                                                ,l_Account_Obj.Account_Det.Branch_Code
                                                ,l_Account_Obj_Temp
                                                ,p_Err_Code
                                                ,p_Err_Params) THEN
         Dbg('Failed in creating dflt account ::' || p_Err_Code);
         RAISE Error_Exception;
      END IF;

      l_Party := l_Account_Obj_Temp.g_Tb_Parties.FIRST;
      WHILE l_Party IS NOT NULL LOOP
         l_Cust_Found := FALSE;
         IF l_Account_Obj_Temp.g_Tb_Parties(l_Party).g_Parties.Responsibility = 'BRW' THEN
            Dbg('Inside for Primary Borrower');

            --FC10.5 STR1 SFR# 3606 begins
            /*IF NOT l_Account_Obj.g_Tb_Parties.EXISTS(l_Party) THEN
               Dbg('Primay borrower does not exists');
               p_Err_Code  := 'CL-PR-001;';
               p_Err_Params := '~';
               Ovpkss.Pr_Appendtbl(p_Err_Code, p_Err_Params);
               Dbg('returning false here');
               RAISE Error_Exception;
            END IF;*/

            l_Party1 := l_Account_Obj.g_Tb_Parties.FIRST;
            WHILE l_Party1 IS NOT NULL LOOP
               Dbg('l_party1: ' || l_Party1 || 'Custid1: ' || l_Account_Obj_Temp.g_Tb_Parties(l_Party)
                   .g_Parties.Customer_Id || ' Custid2: ' || l_Account_Obj.g_Tb_Parties(l_Party1).g_Parties.Customer_Id);
               IF Nvl(l_Account_Obj_Temp.g_Tb_Parties(l_Party).g_Parties.Customer_Id, '##') =
                  Nvl(l_Account_Obj.g_Tb_Parties(l_Party1).g_Parties.Customer_Id, '##') THEN
                  l_Cust_Found := TRUE;
                  EXIT;
               END IF;
               l_Party1 := l_Account_Obj.g_Tb_Parties.NEXT(l_Party1);
            END LOOP;

            IF NOT l_Cust_Found THEN
               Dbg('Primay borrower does not exists');
               l_Cust_Found := FALSE;
               p_Err_Code   := 'CL-PR-001;';
               p_Err_Params := '~';
               Ovpkss.Pr_Appendtbl(p_Err_Code, p_Err_Params);
               Dbg('returning false here');
               RAISE Error_Exception;
            END IF;
            --FC10.5 STR1 SFR# 3606 ends
         END IF;
         l_Party := l_Account_Obj_Temp.g_Tb_Parties.NEXT(l_Party);
      END LOOP;
      -- Log#10 ends

      Dbg('l_account_obj.g_tb_ude_values.COUNT is ' || l_Account_Obj.g_Tb_Ude_Values.COUNT);
      Dbg('l_Account_Obj_Temp.g_tb_ude_values.COUNT is     ' || l_Account_Obj_Temp.g_Tb_Ude_Values.COUNT);
      Dbg('l_Account_Obj_Temp.g_tb_ude_values.COUNT is     ' || l_Account_Obj_Temp.g_Tb_Ude_Values.COUNT);
      Dbg('l_account_obj.g_tb_ude_values.COUNT is ' || l_Account_Obj.g_Tb_Ude_Values.COUNT);
      IF Nvl(l_Account_Obj.g_Eff_Date.COUNT, 0) <> Nvl(l_Account_Obj_Temp.g_Eff_Date.COUNT, 0) --Log#4 changes
       THEN
         --l_Chg_Vami(1).l_Ratechanged := 'Y'; -- 3-16663240851 commented
         l_Chg_Vami(1).l_Ratecodechanged := 'Y';
         Dbg('fine here');
      END IF;
      IF l_Account_Obj.g_Eff_Date.COUNT > 0 THEN
         FOR i IN l_Account_Obj.g_Eff_Date.FIRST .. l_Account_Obj.g_Eff_Date.LAST --Log#4 changes
          LOOP
            l_Account_Obj.g_Eff_Date(i).g_Action := 'I';
            Dbg('l_account_obj.g_eff_date(i).g_action ' || l_Account_Obj.g_Eff_Date(i).g_Action);
         END LOOP;
      END IF;
	  -- 3-16663240851 starts
	 for l_rec in(select a.elem_id ude_id from cltm_product_comp_frm_elems a, cltms_product_components b
				   where a.product_code = l_Account_Obj.account_det.product_code
				   and   a.product_code = b.product_code
				   and   a.component_name = b.component_name
				   and   a.elem_type ='U'
				   and   b.component_type='I')
	  loop
			l_tb_comp_elems(l_rec.ude_id) := 1;
	  end loop;
	 -- 3-16663240851 ends
      IF l_Chg_Vami(1).l_Ratechanged = 'N' THEN
         l_Ude_Val := l_Account_Obj.g_Tb_Ude_Values.FIRST;
         WHILE l_Ude_Val IS NOT NULL LOOP
            Dbg('inside l_ude_val loop');
			-- 3-16663240851 starts
			if l_tb_comp_elems.exists(l_Ude_Val)
			then
			-- 3-16663240851 ends
            IF NOT l_Account_Obj_Temp.g_Tb_Ude_Values.EXISTS(l_Ude_Val) THEN
               l_Chg_Vami(1).l_Ratechanged := 'Y';
               l_Chg_Vami(1).l_Ratecodechanged := 'Y';
               Dbg('secong exit');
               EXIT;
            END IF;

            l_Idx_Ude_Dt := l_Account_Obj.g_Tb_Ude_Values(l_Ude_Val).g_Tb_Ude_Val.FIRST;
            WHILE l_Idx_Ude_Dt IS NOT NULL LOOP
               Dbg('inside l_idx_ude_dt loop');
               IF NOT l_Account_Obj_Temp.g_Tb_Ude_Values(l_Ude_Val).g_Tb_Ude_Val.EXISTS(l_Idx_Ude_Dt) THEN
				  -- 3-16663240851 starts
--l_Chg_Vami(1).l_Ratechanged := 'Y';
				  l_prior_dt := l_Account_Obj_Temp.g_Tb_Ude_Values(l_Ude_Val).g_Tb_Ude_Val.prior(l_Idx_Ude_Dt);
						if l_prior_dt IS NOT NULL
						then
							if nvl(l_Account_Obj_Temp.g_Tb_Ude_Values(l_Ude_Val).g_Tb_Ude_Val(l_prior_dt).g_Ude_Values.resolved_value,0)
								<> nvl(l_Account_Obj.g_Tb_Ude_Values(l_Ude_Val).g_Tb_Ude_Val(l_Idx_Ude_Dt).g_Ude_Values.resolved_value,0)
							OR
								Nvl(l_Account_Obj.g_Tb_Ude_Values(l_Ude_Val).g_Tb_Ude_Val(l_Idx_Ude_Dt).g_Ude_Values.Rate_Code, '#') <>
								Nvl(l_Account_Obj_Temp.g_Tb_Ude_Values(l_Ude_Val).g_Tb_Ude_Val(l_prior_dt).g_Ude_Values.Rate_Code, '#')
						    OR
							  Nvl(l_Account_Obj.g_Tb_Ude_Values(l_Ude_Val).g_Tb_Ude_Val(l_Idx_Ude_Dt).g_Ude_Values.Ude_Value, 0) <>
							  Nvl(l_Account_Obj_Temp.g_Tb_Ude_Values(l_Ude_Val).g_Tb_Ude_Val(l_prior_dt).g_Ude_Values.Ude_Value, 0)
							then
								l_Chg_Vami(1).l_Ratechanged := 'Y';
							end if;
						end if;
						-- 3-16663240851 ends
                  l_Chg_Vami(1).l_Ratecodechanged := 'Y';
                  Dbg('third exit');
 --EXIT; -- 3-16663240851 moved down
 END IF;
			   -- 3-16663240851 starts
			   if l_Chg_Vami(1).l_Ratechanged ='Y'
					then
						EXIT;
					end if;
					if l_Account_Obj_Temp.g_Tb_Ude_Values(l_Ude_Val).g_Tb_Ude_Val.exists(l_Idx_Ude_Dt)
					then
				-- 3-16663240851 ends

               Dbg('b4 if');
               Dbg('rate in acc ' || l_Account_Obj.g_Tb_Ude_Values(l_Ude_Val).g_Tb_Ude_Val(l_Idx_Ude_Dt).g_Ude_Values.Ude_Value);
               Dbg('rate in vami ' || l_Account_Obj_Temp.g_Tb_Ude_Values(l_Ude_Val).g_Tb_Ude_Val(l_Idx_Ude_Dt).g_Ude_Values.Ude_Value);
               IF (Nvl(l_Account_Obj.g_Tb_Ude_Values(l_Ude_Val).g_Tb_Ude_Val(l_Idx_Ude_Dt).g_Ude_Values.Rate_Code, '#') <>
                  Nvl(l_Account_Obj_Temp.g_Tb_Ude_Values(l_Ude_Val).g_Tb_Ude_Val(l_Idx_Ude_Dt).g_Ude_Values.Rate_Code, '#') OR
                  Nvl(l_Account_Obj.g_Tb_Ude_Values(l_Ude_Val).g_Tb_Ude_Val(l_Idx_Ude_Dt).g_Ude_Values.Ude_Value, 0) <>
                  Nvl(l_Account_Obj_Temp.g_Tb_Ude_Values(l_Ude_Val).g_Tb_Ude_Val(l_Idx_Ude_Dt).g_Ude_Values.Ude_Value, 0)) --Log#2 changes
                THEN
                  l_Chg_Vami(1).l_Ratechanged := 'Y';
                  l_Chg_Vami(1).l_Ratecodechanged := 'Y';
                  Dbg('fourth exit');
                  EXIT;
               END IF;
			  end if;-- 3-16663240851
               l_Idx_Ude_Dt := l_Account_Obj.g_Tb_Ude_Values(l_Ude_Val).g_Tb_Ude_Val.NEXT(l_Idx_Ude_Dt);
            END LOOP;
            IF l_Chg_Vami(1).l_Ratechanged = 'Y' THEN
               Dbg('fifth exit');
               EXIT;
            END IF;
		end if; --3-16663240851
            l_Ude_Val := l_Account_Obj.g_Tb_Ude_Values.NEXT(l_Ude_Val);
         END LOOP;
		 -- 3-16663240851 changes start
         l_Ude_Val := l_Account_Obj_Temp.g_Tb_Ude_Values.FIRST;
         WHILE l_Ude_Val IS NOT NULL LOOP
            Dbg('inside l_ude_val loop');
			if l_tb_comp_elems.exists(l_Ude_Val)
			then
				IF NOT l_Account_Obj.g_Tb_Ude_Values.EXISTS(l_Ude_Val) THEN
				   l_Chg_Vami(1).l_Ratechanged := 'Y';
				   l_Chg_Vami(1).l_Ratecodechanged := 'Y';
				   Dbg('secong exit');
				   EXIT;
				END IF;

				l_Idx_Ude_Dt := l_Account_Obj_Temp.g_Tb_Ude_Values(l_Ude_Val).g_Tb_Ude_Val.FIRST;

				WHILE l_Idx_Ude_Dt IS NOT NULL LOOP
				   Dbg('inside l_idx_ude_dt loop');
				   IF NOT l_Account_Obj.g_Tb_Ude_Values(l_Ude_Val).g_Tb_Ude_Val.EXISTS(l_Idx_Ude_Dt) THEN
						l_prior_dt := l_Account_Obj.g_Tb_Ude_Values(l_Ude_Val).g_Tb_Ude_Val.prior(l_Idx_Ude_Dt);
						if l_prior_dt IS NOT NULL
						then
							if nvl(l_Account_Obj.g_Tb_Ude_Values(l_Ude_Val).g_Tb_Ude_Val(l_prior_dt).g_Ude_Values.resolved_value,0)
								<> nvl(l_Account_Obj_Temp.g_Tb_Ude_Values(l_Ude_Val).g_Tb_Ude_Val(l_Idx_Ude_Dt).g_Ude_Values.resolved_value,0)
							OR
								Nvl(l_Account_Obj.g_Tb_Ude_Values(l_Ude_Val).g_Tb_Ude_Val(l_prior_dt).g_Ude_Values.Rate_Code, '#') <>
								Nvl(l_Account_Obj_Temp.g_Tb_Ude_Values(l_Ude_Val).g_Tb_Ude_Val(l_Idx_Ude_Dt).g_Ude_Values.Rate_Code, '#')
						    OR
							  Nvl(l_Account_Obj.g_Tb_Ude_Values(l_Ude_Val).g_Tb_Ude_Val(l_prior_dt).g_Ude_Values.Ude_Value, 0) <>
							  Nvl(l_Account_Obj_Temp.g_Tb_Ude_Values(l_Ude_Val).g_Tb_Ude_Val(l_Idx_Ude_Dt).g_Ude_Values.Ude_Value, 0)
							then
								l_Chg_Vami(1).l_Ratechanged := 'Y';
                dbg('entring new code and setting');
							end if;
						end if;
						l_Chg_Vami(1).l_Ratecodechanged := 'Y';
						Dbg('third exit');
				   END IF;
					if l_Chg_Vami(1).l_Ratechanged ='Y'
					then
						EXIT;
					end if;
				   l_Idx_Ude_Dt := l_Account_Obj_Temp.g_Tb_Ude_Values(l_Ude_Val).g_Tb_Ude_Val.NEXT(l_Idx_Ude_Dt);
				END LOOP;
			end if;
			IF l_Chg_Vami(1).l_Ratechanged = 'Y' THEN
			   Dbg('fifth exit');
			   EXIT;
			END IF;
            l_Ude_Val := l_Account_Obj_Temp.g_Tb_Ude_Values.NEXT(l_Ude_Val);
         END LOOP;
         -- 3-16663240851 changes end
  END IF;
	  	l_tb_comp_elems.delete;-- 3-16663240851
      IF l_Account_Obj_Temp.g_Tb_Components.COUNT <> l_Account_Obj.g_Tb_Components.COUNT THEN
         l_Chg_Vami(1).l_Schaffected := 'Y';
      END IF;

      IF l_Chg_Vami(1).l_Schaffected = 'N' THEN
         l_Comp_Name := l_Account_Obj.g_Tb_Components.FIRST;
         WHILE l_Comp_Name IS NOT NULL LOOP
            IF NOT l_Account_Obj_Temp.g_Tb_Components.EXISTS(l_Comp_Name) THEN
               l_Chg_Vami(1).l_Schaffected := 'Y';
               Dbg('sch 1 exit');
               EXIT;
            END IF;

            l_Comp_Sch := l_Account_Obj.g_Tb_Components(l_Comp_Name).g_Tb_Comp_Sch.FIRST;
            WHILE l_Comp_Sch IS NOT NULL LOOP
               IF NOT l_Account_Obj_Temp.g_Tb_Components(l_Comp_Name).g_Tb_Comp_Sch.EXISTS(l_Comp_Sch) THEN
                  l_Chg_Vami(1).l_Schaffected := 'Y';
                  Dbg('sch 2 exit');
                  EXIT;
               END IF;

               -- Log#2A changes start
               IF ((Nvl(l_Account_Obj_Temp.g_Tb_Components(l_Comp_Name).g_Tb_Comp_Sch(l_Comp_Sch).g_Account_Comp_Sch.Formula_Name, '%%%') <>
                  Nvl(l_Account_Obj.g_Tb_Components(l_Comp_Name).g_Tb_Comp_Sch(l_Comp_Sch).g_Account_Comp_Sch.Formula_Name, '%%%')) OR
                  (Nvl(l_Account_Obj_Temp.g_Tb_Components(l_Comp_Name).g_Tb_Comp_Sch(l_Comp_Sch).g_Account_Comp_Sch.Frequency, 0) <>
                  Nvl(l_Account_Obj.g_Tb_Components(l_Comp_Name).g_Tb_Comp_Sch(l_Comp_Sch).g_Account_Comp_Sch.Frequency, 0)) OR
                  (Nvl(l_Account_Obj_Temp.g_Tb_Components(l_Comp_Name).g_Tb_Comp_Sch(l_Comp_Sch).g_Account_Comp_Sch.Unit, '%') <>
                  Nvl(l_Account_Obj.g_Tb_Components(l_Comp_Name).g_Tb_Comp_Sch(l_Comp_Sch).g_Account_Comp_Sch.Unit, '%')) OR
                  (Nvl(l_Account_Obj_Temp.g_Tb_Components(l_Comp_Name).g_Tb_Comp_Sch(l_Comp_Sch).g_Account_Comp_Sch.Amount, 0) <>
                  Nvl(l_Account_Obj.g_Tb_Components(l_Comp_Name).g_Tb_Comp_Sch(l_Comp_Sch).g_Account_Comp_Sch.Amount, 0)) OR
                  (Nvl(l_Account_Obj_Temp.g_Tb_Components(l_Comp_Name).g_Tb_Comp_Sch(l_Comp_Sch).g_Account_Comp_Sch.Capitalized, '%') <>
                  Nvl(l_Account_Obj.g_Tb_Components(l_Comp_Name).g_Tb_Comp_Sch(l_Comp_Sch).g_Account_Comp_Sch.Capitalized, '%')) OR
                  (Nvl(l_Account_Obj_Temp.g_Tb_Components(l_Comp_Name).g_Tb_Comp_Sch(l_Comp_Sch).g_Account_Comp_Sch.Emi_Amount, 0) <>
                  Nvl(l_Account_Obj.g_Tb_Components(l_Comp_Name).g_Tb_Comp_Sch(l_Comp_Sch).g_Account_Comp_Sch.Emi_Amount, 0)) OR
                  (Nvl(l_Account_Obj_Temp.g_Tb_Components(l_Comp_Name).g_Tb_Comp_Sch(l_Comp_Sch).g_Account_Comp_Sch.Due_Dates_On, 0) <>
                  Nvl(l_Account_Obj.g_Tb_Components(l_Comp_Name).g_Tb_Comp_Sch(l_Comp_Sch).g_Account_Comp_Sch.Due_Dates_On, 0)) OR
                  (Nvl(l_Account_Obj_Temp.g_Tb_Components(l_Comp_Name).g_Tb_Comp_Sch(l_Comp_Sch).g_Account_Comp_Sch.Days_Mth, '%') <>
                  Nvl(l_Account_Obj.g_Tb_Components(l_Comp_Name).g_Tb_Comp_Sch(l_Comp_Sch).g_Account_Comp_Sch.Days_Mth, '%')) OR
                  (Nvl(l_Account_Obj_Temp.g_Tb_Components(l_Comp_Name).g_Tb_Comp_Sch(l_Comp_Sch).g_Account_Comp_Sch.Days_Year, '%') <>
                  Nvl(l_Account_Obj.g_Tb_Components(l_Comp_Name).g_Tb_Comp_Sch(l_Comp_Sch).g_Account_Comp_Sch.Days_Year, '%')) OR
                  (Nvl(l_Account_Obj_Temp.g_Tb_Components(l_Comp_Name).g_Tb_Comp_Sch(l_Comp_Sch).g_Account_Comp_Sch.Compound_Days, 0) <>
                  Nvl(l_Account_Obj.g_Tb_Components(l_Comp_Name).g_Tb_Comp_Sch(l_Comp_Sch).g_Account_Comp_Sch.Compound_Days, 0)) OR
                  (Nvl(l_Account_Obj_Temp.g_Tb_Components(l_Comp_Name).g_Tb_Comp_Sch(l_Comp_Sch).g_Account_Comp_Sch.Compound_Months, 0) <>
                  Nvl(l_Account_Obj.g_Tb_Components(l_Comp_Name).g_Tb_Comp_Sch(l_Comp_Sch).g_Account_Comp_Sch.Compound_Months, 0)) OR
                  (Nvl(l_Account_Obj_Temp.g_Tb_Components(l_Comp_Name).g_Tb_Comp_Sch(l_Comp_Sch).g_Account_Comp_Sch.Compound_Years, 0) <>
                  Nvl(l_Account_Obj.g_Tb_Components(l_Comp_Name).g_Tb_Comp_Sch(l_Comp_Sch).g_Account_Comp_Sch.Compound_Years, 0)) OR
                  (Nvl(l_Account_Obj_Temp.g_Tb_Components(l_Comp_Name).g_Tb_Comp_Sch(l_Comp_Sch).g_Account_Comp_Sch.No_Of_Schedules, 0) <>
                  Nvl(l_Account_Obj.g_Tb_Components(l_Comp_Name).g_Tb_Comp_Sch(l_Comp_Sch).g_Account_Comp_Sch.No_Of_Schedules, 0))) THEN
                  l_Chg_Vami(1).l_Schaffected := 'Y';
                  EXIT;
               END IF;
               -- Log#2A changes end
               l_Comp_Sch := l_Account_Obj.g_Tb_Components(l_Comp_Name).g_Tb_Comp_Sch.NEXT(l_Comp_Sch);
            END LOOP;
            IF l_Chg_Vami(1).l_Schaffected = 'Y' THEN
               Dbg('sch 3 exit');
               EXIT;
            END IF;
            l_Comp_Name := l_Account_Obj.g_Tb_Components.NEXT(l_Comp_Name);
         END LOOP;
      END IF;

      l_Comp := l_Account_Obj.g_Tb_Components.FIRST;
      WHILE l_Comp IS NOT NULL LOOP
         IF NOT l_Account_Obj_Temp.g_Tb_Components.EXISTS(l_Comp) THEN
            l_Chg_Vami(1).l_Schaffected := 'Y';
            Dbg('det 1 exit');
            EXIT;
         END IF;

         Dbg('l_comp is ' || l_Comp);
         Dbg('in vami' || l_Account_Obj.g_Tb_Components(l_Comp).Comp_Det.Spl_Interest_Amt);
         Dbg('in acc' || l_Account_Obj_Temp.g_Tb_Components(l_Comp).Comp_Det.Spl_Interest_Amt);

         IF Nvl(l_Account_Obj.g_Tb_Components(l_Comp).Comp_Det.Spl_Interest_Amt, 0) <>
            Nvl(l_Account_Obj_Temp.g_Tb_Components(l_Comp).Comp_Det.Spl_Interest_Amt, 0) THEN
            l_Chg_Vami(1).l_Schaffected := 'Y';
            Dbg('det 2 exit');
            EXIT;
         END IF;
         l_Comp := l_Account_Obj.g_Tb_Components.NEXT(l_Comp);
      END LOOP;
      --Log#1 changes ends
      --Log#28 changes starts

      Dbg('l_Account_Obj_Temp.g_hol_perds.COUNT::    ' || l_Account_Obj_Temp.g_Hol_Perds.COUNT);
      Dbg('l_Account_Obj.g_hol_perds.COUNT::    ' || l_Account_Obj.g_Hol_Perds.COUNT);
      IF Nvl(l_Chg_Vami(1).l_Schaffected, 'N') <> 'Y' THEN
         IF l_Account_Obj_Temp.g_Hol_Perds.COUNT <> l_Account_Obj.g_Hol_Perds.COUNT THEN
            Dbg('Counts Different so, schedule is affected');
            l_Chg_Vami(1).l_Schaffected := 'Y';
         END IF;
         IF Nvl(l_Chg_Vami(1).l_Schaffected, 'N') <> 'Y' THEN
            IF l_Account_Obj.g_Hol_Perds.COUNT > 0 THEN
               Indx := l_Account_Obj.g_Hol_Perds.FIRST;
               WHILE Indx IS NOT NULL LOOP
                  Indx2        := l_Account_Obj_Temp.g_Hol_Perds.FIRST;
                  l_Hol_Period := FALSE;
                  WHILE Indx2 IS NOT NULL LOOP
                     Dbg(l_Account_Obj.g_Hol_Perds(Indx).g_Acc_Hol_Perds.Holiday_Periods || '~' || l_Account_Obj_Temp.g_Hol_Perds(Indx2)
                         .g_Acc_Hol_Perds.Holiday_Periods);
                     IF l_Account_Obj.g_Hol_Perds(Indx).g_Acc_Hol_Perds.Holiday_Periods = l_Account_Obj_Temp.g_Hol_Perds(Indx2).g_Acc_Hol_Perds.Holiday_Periods THEN
                        l_Hol_Period := TRUE;
                     END IF;
                     Indx2 := l_Account_Obj_Temp.g_Hol_Perds.NEXT(Indx2);
                  END LOOP;
                  IF NOT l_Hol_Period THEN
                     l_Chg_Vami(1).l_Schaffected := 'Y';
                     EXIT;
                  END IF;
                  Indx := l_Account_Obj.g_Hol_Perds.NEXT(Indx);
               END LOOP;
            END IF;
         END IF;
      END IF;
      --Log#28 changes ends

      Dbg('l_chg_vami (1).l_PrincChanged ::    ' || l_Chg_Vami(1).l_Princchanged);
      Dbg('l_chg_vami (1).l_MatDateChanged ::  ' || l_Chg_Vami(1).l_Matdatechanged);
      Dbg('l_chg_vami (1).l_RateCodeChanged :: ' || l_Chg_Vami(1).l_Ratecodechanged);
      Dbg('l_chg_vami (1).l_SchAffected ::     ' || l_Chg_Vami(1).l_Schaffected);
      Dbg('l_chg_vami(1) .l_ratechanged ::     ' || l_Chg_Vami(1).l_Ratechanged); --Log#1 changes

      --l_chg_vami(1) .l_effdate := clpkss_account.pkg_vami_eff_date;
      l_Chg_Vami(1).l_Effdate := l_Eff_Date;
      Dbg('l_chg_vami(1).l_effdate is ' || l_Chg_Vami(1).l_Effdate);
      --Log#26 starts
      Dbg(' l_Chg_Vami(1).l_Effdate' || l_Chg_Vami(1).l_Effdate);
      IF l_Chg_Vami(1).l_Effdate IS NOT NULL THEN
         Dbg('l_Chg_Vami(1).l_Effdate');
         l_Ude_Val := l_Account_Obj_Temp.g_Tb_Ude_Values.FIRST;
         Dbg('inside ' || l_Ude_Val);
         WHILE l_Ude_Val IS NOT NULL LOOP
            IF l_Account_Obj.g_Tb_Ude_Values.EXISTS(l_Ude_Val) THEN
               l_Idx_Ude_Dt := l_Account_Obj_Temp.g_Tb_Ude_Values(l_Ude_Val).g_Tb_Ude_Val.FIRST;
               WHILE l_Idx_Ude_Dt IS NOT NULL LOOP
                  IF l_Account_Obj.g_Tb_Ude_Values(l_Ude_Val).g_Tb_Ude_Val.EXISTS(l_Idx_Ude_Dt) THEN
                     Dbg('effECTIVE date is ' || l_Account_Obj.g_Tb_Ude_Values(l_Ude_Val).g_Tb_Ude_Val(l_Idx_Ude_Dt).g_Ude_Values.Effective_Date);
                     Dbg('VAMI effECTIVE date is ' || l_Chg_Vami(1).l_Effdate);
                     IF l_Account_Obj.g_Tb_Ude_Values(l_Ude_Val).g_Tb_Ude_Val(l_Idx_Ude_Dt).g_Ude_Values.Effective_Date < l_Chg_Vami(1)
                     .l_Effdate AND Nvl(l_Account_Obj.g_Tb_Ude_Values(l_Ude_Val).g_Tb_Ude_Val(l_Idx_Ude_Dt).g_Ude_Values.Rate_Code, '#') <>
                        Nvl(l_Account_Obj_Temp.g_Tb_Ude_Values(l_Ude_Val).g_Tb_Ude_Val(l_Idx_Ude_Dt).g_Ude_Values.Rate_Code, '#') AND
                        Nvl(l_Account_Obj.g_Tb_Ude_Values(l_Ude_Val).g_Tb_Ude_Val(l_Idx_Ude_Dt).g_Ude_Values.Ude_Value, 0) <> --Log#37 changed value # to 0
                        Nvl(l_Account_Obj_Temp.g_Tb_Ude_Values(l_Ude_Val).g_Tb_Ude_Val(l_Idx_Ude_Dt).g_Ude_Values.Ude_Value, 0) --Log#37 changed value # to 0
                      THEN
                        Dbg('Back dated rate change is not allowed !');
                        p_Err_Code   := 'CL-UDE-01' || ';';
                        p_Err_Params := ';';
                        Ovpkss.Pr_Appendtbl(p_Err_Code, p_Err_Params);
                        RAISE Error_Exception;
                     END IF;
                  END IF;
                  l_Idx_Ude_Dt := l_Account_Obj_Temp.g_Tb_Ude_Values(l_Ude_Val).g_Tb_Ude_Val.NEXT(l_Idx_Ude_Dt);
               END LOOP;
            END IF;
            l_Ude_Val := l_Account_Obj_Temp.g_Tb_Ude_Values.NEXT(l_Ude_Val);
         END LOOP;
      END IF;
      --Log#26 ends



      IF p_Source = 'FLEXCUBE' --Log#4 changes
       THEN
         --Log#3 starts
         IF NOT Clpks_Change_Log.Fn_Log_Changes_For_Ui(Clpkss_Context.g_Function_Id, l_Account_Obj, p_Err_Code, p_Err_Params) THEN
            Dbg('clpkss_account.fn_save failed with :-( ' || p_Err_Code || ':' || p_Err_Params);
            Ovpkss.Pr_Appendtbl(p_Err_Code, p_Err_Params);
            RAISE Error_Exception;
         END IF;

         SAVEPOINT Sp_Save_Account; --Log#3 ends
      END IF;

      --FC 10.5 STR1 SFR-3606 Starts
      IF Pkg_Cldaccdt.Pkgfuncid = 'CLDSIMVD' THEN
         l_Simulated := TRUE;
      ELSE
         l_Simulated := FALSE;
      END IF;
      --FC 10.5 STR1 SFR-3606 Ends

      --FCUBS11.1 ITR2 SFR#1085 Starts..
      SELECT Latest_Esn
      INTO  l_Account_Obj.Account_Det.Latest_Esn
      FROM CLTB_ACCOUNT_APPS_MASTER
      WHERE Account_Number = l_Account_Obj.Account_Det.Account_Number
      AND Branch_Code = l_Account_Obj.Account_Det.Branch_Code;
      --FCUBS11.1 ITR2 SFR#1085 Ends..

      IF NOT Gwpks_Cl_Loan_Amendment.Fn_Save_Amendment(l_Account_Obj
                                                      ,NULL
                                                      ,NULL
                                                      ,l_Simulated --FALSE  --FC 10.5 STR1 SFR-3606 Added l_Simulated flag
                                                      ,l_Chg_Vami
                                                      ,p_Rowid
                                                      ,'V'
                                                      ,p_Err_Code
                                                      ,p_Err_Params) THEN
         Dbg('Gwpks_loan_amendment.fn_save_amendment RETURNED FALSE' || p_Err_Code || '******' || p_Err_Params);
         --ROLLBACK TO Sp_Vami; -- Log#8 FC 10.1 LS Changes
         ROLLBACK ; --SFR#3568
         RAISE Error_Exception;
      END IF;

      IF p_Source = 'FLEXCUBE' --Log#4 changes
       THEN
         --Log#3 Start
         IF Ovpks.Gl_Tblerror.COUNT > 0 THEN
            l_Tb_Event_Ovd.DELETE;
            Clpks_Util.Pr_Format_Messages(l_Tb_Event_Ovd);
            Dbg('Count of ovd ::' || l_Tb_Event_Ovd.COUNT);
            IF l_Tb_Event_Ovd.COUNT > 0 THEN
               FOR i IN 1 .. l_Tb_Event_Ovd.COUNT LOOP
                  --Log#27 FC 10.1 LS Changes Starts
                  IF l_Tb_Event_Ovd(i).Ovd_Type = 'E' THEN
                     RAISE Error_Exception;
                  END IF;
                  --Log#27 FC 10.1 LS Changes Ends
                  l_Tb_Cl_Event_Ovd(i).Account_Number := l_Account_Obj.Account_Det.Account_Number;
                  l_Tb_Cl_Event_Ovd(i).Branch_Code := l_Account_Obj.Account_Det.Branch_Code;
                  l_Tb_Cl_Event_Ovd(i).Event_Seq_No := l_Account_Obj.Account_Det.Latest_Esn;
                  l_Tb_Cl_Event_Ovd(i).Ovd_Seq_No := l_Tb_Event_Ovd(i).Ovd_Seq_No;
                  l_Tb_Cl_Event_Ovd(i).Err_Code := l_Tb_Event_Ovd(i).Err_Code;
                  l_Tb_Cl_Event_Ovd(i).Message := l_Tb_Event_Ovd(i).Message;
                  l_Tb_Cl_Event_Ovd(i).Online_Auth_Id := l_Tb_Event_Ovd(i).Online_Auth_Id;
                  l_Tb_Cl_Event_Ovd(i).Auth_By := l_Tb_Event_Ovd(i).Auth_By;
                  l_Tb_Cl_Event_Ovd(i).Auth_Dt_Stamp := l_Tb_Event_Ovd(i).Auth_Dt_Stamp;
                  l_Tb_Cl_Event_Ovd(i).Ovd_Status := l_Tb_Event_Ovd(i).Ovd_Status;
                  l_Tb_Cl_Event_Ovd(i).Confirmed := l_Tb_Event_Ovd(i).Confirmed;
                  l_Tb_Cl_Event_Ovd(i).Ovd_Type := l_Tb_Event_Ovd(i).Ovd_Type;
                  l_Tb_Cl_Event_Ovd(i).Remarks := l_Tb_Event_Ovd(i).Remarks;
                  l_Tb_Cl_Event_Ovd(i).Amount := l_Tb_Event_Ovd(i).Amount;
               END LOOP;
               IF NOT Clpks_Dml.Fn_Store_Overrides(l_Tb_Cl_Event_Ovd, Lmsg, Ltype) THEN
                  Dbg('Failed in store overrides::' || Lmsg);
                  RAISE Error_Exception;
               END IF;
            END IF;
         END IF;
         --Log#3 End
      END IF;

      Dbg('Success from Fn_Modify_account');
      RETURN TRUE;
   EXCEPTION
   --FCUBS ITR1 SFR#3568 Starts
      when error_exception then
      rollback;
      return false;
   --FCUBS ITR1 SFR#3568 Ends

      WHEN OTHERS THEN
         Dbg('In when others in Fn_Modify_account ' || SQLERRM);
         p_Err_Code   := 'ST-OTHR-001';
         p_Err_Params := NULL;
         RETURN FALSE;
   END Fn_Modify_Account;

   FUNCTION Fn_Auth_Account(p_Source           IN VARCHAR2
                           ,p_Source_Operation IN VARCHAR2
                           ,p_Function_Id      IN VARCHAR2
                           ,p_Action_Code      IN VARCHAR2
                           ,p_Cldaccvm         IN OUT Clpks_Cldaccvm_Main.Ty_Cldaccvm
                           ,p_Err_Code         IN OUT VARCHAR2
                           ,p_Err_Params       IN OUT VARCHAR2) RETURN BOOLEAN IS
      l_Pickup           BOOLEAN := TRUE;
      l_Pickedup         BOOLEAN := TRUE;
      l_Subsys           VARCHAR2(500);
      l_Subsys_Stat      VARCHAR2(500);
      l_Stat             VARCHAR2(1);
      l_Module           VARCHAR2(10) := 'CL';
      l_Event_Seq_No     NUMBER; --NRAKAEFCC0028 changed variable from number(3) to number
      l_Pos              NUMBER;
      l_Account_Obj      Clpkss_Object.Ty_Rec_Account;
      l_Eff_Date         DATE;
      l_Acc_No           VARCHAR2(100);
      l_Branch           VARCHAR2(100);
      l_Ind_Tbl          Clpkss_Schedules.Ty_Tb_Indicator;
      l_Account_Obj      Clpkss_Object.Ty_Rec_Account;
      l_Err_Tbl          Ovpks.Tbl_Error;
      l_Account_Number   Cltbs_Account_Master.Account_Number%TYPE;
      l_Rec_Account_Vamd Cltbs_Account_Vamd%ROWTYPE;
      l_Is_Tag_Clob      VARCHAR2(1);
      l_Maker_Id         VARCHAR2(35);
      l_Auth_Stat        VARCHAR2(1);
      l_Process_Status   VARCHAR2(1) := 'S';
      CURSOR Cr_Authchk IS
         SELECT Maker_Id, Auth_Stat
         FROM   Cltbs_Account_Master
         WHERE  Account_Number = l_Rec_Account_Vamd.Account_Number
         AND    Branch_Code = l_Rec_Account_Vamd.Branch_Code;

   BEGIN
      Dbg('In Fn_Auth_Account');

      l_Acc_No   := p_Cldaccvm.v_Cltbs_Account_Vamd.Account_Number;
      l_Branch   := p_Cldaccvm.v_Cltbs_Account_Vamd.Branch_Code;
      l_Eff_Date := p_Cldaccvm.v_Cltbs_Account_Vamd.Effective_Date;

      BEGIN

         SELECT *
         INTO   l_Rec_Account_Vamd
         FROM   Cltbs_Account_Vamd
         WHERE  Account_Number = l_Acc_No
         AND    Branch_Code = l_Branch
         AND    Auth_Stat = 'U';

         Dbg('Got Account Vamd Record');

         OPEN Cr_Authchk;
         FETCH Cr_Authchk
            INTO l_Maker_Id, l_Auth_Stat;
         IF Cr_Authchk%NOTFOUND THEN
            Dbg('Status Change Record Not found');
            p_Err_Code   := 'CL-STCH21';
            p_Err_Params := '~';
            CLOSE Cr_Authchk;
            RETURN FALSE;
         END IF;
         CLOSE Cr_Authchk;

         IF l_Maker_Id = Global.User_Id THEN
            Dbg('Maker Id is same as Checker Id. Cannot Authorise');
            p_Err_Code   := 'CS-NAV-021';
            p_Err_Params := Substr(SQLERRM, 1, 100) || '~';
            Ovpkss.Pr_Appendtbl(p_Err_Code, p_Err_Params);
            RETURN FALSE;
         END IF;

         IF l_Auth_Stat = 'U' AND l_Maker_Id <> Global.User_Id THEN
            Dbg('Clpkss_vd_amendment.fn_auth_vami_account');
            IF NOT Clpkss_Vd_Amendment.Fn_Auth_Vami_Account(l_Rec_Account_Vamd.Branch_Code
                                                           ,l_Rec_Account_Vamd.Account_Number
                                                           ,l_Rec_Account_Vamd.Active_Status
                                                           ,l_Rec_Account_Vamd.Effective_Date
                                                           ,p_Err_Code
                                                           ,p_Err_Params) THEN
               Dbg('clpkss_vd_amendment.fn_auth_vami_account Failed with :-( ' || p_Err_Code || ':' || p_Err_Params);
               --FCSTR1 SFR#4047 Starts
               Ovpkss.Pr_Appendtbl(p_Err_Code, p_Err_Params);
               RETURN FALSE;
               --FCSTR1 SFR#4047 Ends

            END IF;
         END IF;
         Dbg('clpkss_vd_amendment.fn_auth_vami_account');

      EXCEPTION
         WHEN No_Data_Found THEN
            Dbg('No Amendment to Authorize');
            Dbg('No Account Found.');
            p_Err_Code   := 'IS-VLD018;';
            p_Err_Params := '~';
            Ovpkss.Pr_Appendtbl(p_Err_Code, p_Err_Params);
            RETURN FALSE;
      END;

      Dbg('Success from Fn_Auth_Account');
      RETURN TRUE;
   EXCEPTION
      WHEN OTHERS THEN
         Dbg('In when others in Fn_Auth_Account ' || SQLERRM);
         p_Err_Code   := 'ST-OTHR-001';
         p_Err_Params := NULL;
         RETURN FALSE;
   END Fn_Auth_Account;

   FUNCTION Fn_Credit_Score(p_Source           IN VARCHAR2
                           ,p_Source_Operation IN VARCHAR2
                           ,p_Function_Id      IN VARCHAR2
                           ,p_Action_Code      IN VARCHAR2
                           ,p_Cldaccvm         IN OUT Clpks_Cldaccvm_Main.Ty_Cldaccvm
                           ,p_Err_Code         IN OUT VARCHAR2
                           ,p_Err_Params       IN OUT VARCHAR2) RETURN BOOLEAN IS
      l_Account_Obj Clpkss_Object.Ty_Rec_Account;
      l_Eff_Date    DATE;

   BEGIN
      Dbg('In fn_credit_score');
      IF NOT Clpks_Cldaccvm_Type_Conv.Fn_Build_Acc_Obj(l_Account_Obj, p_Cldaccvm, p_Err_Code, p_Err_Params) THEN
         Dbg('Failed in fn_buildobj');
         Pr_Log_Error(p_Function_Id, p_Source, p_Err_Code, p_Err_Params);
         RETURN FALSE;
      END IF;
      l_Eff_Date := l_Account_Obj.Account_Det.Value_Date;
      IF NOT C3pk#_Prd_Shell.Fn_Get_Credit_Score_Rule(l_Account_Obj, l_Eff_Date, p_Err_Code, p_Err_Params) THEN
         Dbg('Error Code	#### ' || p_Err_Code);
         Dbg('Error Message ##### ' || p_Err_Params);
         Pr_Log_Error(p_Function_Id, p_Source, p_Err_Code, p_Err_Params);
         RETURN FALSE;
      END IF;
      IF NOT Clpks_Cldaccvm_Type_Conv.Fn_Build_Type(p_Cldaccvm, l_Account_Obj, p_Err_Code, p_Err_Params) THEN
         Dbg('Failed In Clpks_Cldaccvm_Type_Conv.Fn_Build_Type');
         Pr_Log_Error(p_Function_Id, p_Source, p_Err_Code, p_Err_Params);
         RETURN FALSE;
      END IF;
      Dbg('Returning Success from fn_credit_score');
      RETURN TRUE;
   EXCEPTION
      WHEN OTHERS THEN
         Dbg('In when others in fn_credit_score ' || SQLERRM);
         p_Err_Code   := 'ST-OTHR-001';
         p_Err_Params := NULL;
         RETURN FALSE;
   END Fn_Credit_Score;

   FUNCTION Fn_Unlock(p_Source           IN VARCHAR2
                     ,p_Source_Operation IN VARCHAR2
                     ,p_Function_Id      IN VARCHAR2
                     ,p_Action_Code      IN OUT VARCHAR2
                     ,p_Cldaccvm         IN Clpks_Cldaccvm_Main.Ty_Cldaccvm
                     ,p_Err_Code         IN OUT VARCHAR2
                     ,p_Err_Params       IN OUT VARCHAR2) RETURN BOOLEAN IS

      l_Multi_Trip_Id NUMBER(10);
      l_Request_No    VARCHAR2(500);
      l_Account_Rec   Cltb_Account_Master%ROWTYPE;
      l_Event_Rec     Cltb_Account_Events_Diary%ROWTYPE;
      l_Auth_Count    PLS_INTEGER := 0;   --SFR#4678
      l_Acc_Num       Cltbs_Account_Master.Account_Number%TYPE;
      l_Cont_Exists   BOOLEAN := TRUE;
      l_Status        CHAR(1);
      l_Cldaccvm      Clpks_Cldaccvm_Main.Ty_Cldaccvm := p_Cldaccvm;

   BEGIN
      Dbg('In Fn_Unlock = ' || p_Action_Code);

      l_Multi_Trip_Id := Cspks_Req_Global.Fn_Get_Req_No;
      l_Request_No    := Cspks_Req_Global.Fn_Get_Multi_Trip_Id;

      IF Substr(p_Action_Code, 1, Length(Cspks_Req_Global.p_Enrich)) = Cspks_Req_Global.p_Enrich THEN
         p_Action_Code := Substr(p_Action_Code, Length(Cspks_Req_Global.p_Enrich) + 2);

      ELSIF Substr(p_Action_Code, 1, Length(Cspks_Req_Global.p_Subsyspickup)) = Cspks_Req_Global.p_Subsyspickup THEN
         p_Action_Code := Substr(p_Action_Code, Length(Cspks_Req_Global.p_Subsyspickup) + 2);
      END IF;

      IF (Substr(p_Action_Code, 1, Length(Cspks_Req_Global.p_Enrich)) <> Cspks_Req_Global.p_Enrich) AND p_Action_Code <> Cspks_Req_Global.p_Prddflt THEN

         l_Acc_Num := p_Cldaccvm.v_Cltbs_Account_Master.Account_Number;
         Dbg('l_Acc_Num = ' || l_Acc_Num || ', Action Code = ' || p_Action_Code);
         BEGIN
            SELECT *
            INTO   l_Account_Rec
            FROM   Cltb_Account_Master
            WHERE  Account_Number = l_Acc_Num;

         EXCEPTION
            WHEN OTHERS THEN
               Dbg('No Data Found in Cstbs_Contract For Reference :' || l_Acc_Num);
               l_Cont_Exists := FALSE;
         END;

         IF l_Cont_Exists THEN
            BEGIN
               SELECT *
               INTO   l_Event_Rec
               FROM   Cltb_Account_Events_Diary
               WHERE  Account_Number = l_Acc_Num
               AND    Event_Seq_No = (SELECT MAX(Event_Seq_No)
                                      FROM   Cltb_Account_Events_Diary
                                      WHERE  Account_Number = l_Acc_Num);
            EXCEPTION
               WHEN OTHERS THEN
                  Dbg('No Data Found in Cstbs_Contract_Event_Log For Reference :' || l_Acc_Num);
            END;

            SELECT COUNT(*)
            INTO   l_Auth_Count
            FROM   Cltb_Account_Events_Diary
            WHERE  Account_Number = l_Acc_Num
            AND    Auth_Status = 'A';
         END IF;

         IF l_Cont_Exists THEN
            Dbg('p_Action_Code' || p_Action_Code);
            IF p_Action_Code IN (Cspks_Req_Global.p_Modify, Cspks_Req_Global.p_Hold, Cspks_Req_Global.p_New) THEN
               IF l_Auth_Count = 0 THEN
                  Dbg('Not Authorized so far...');
                  IF p_Action_Code <> 'HOLD' THEN
                     p_Action_Code := 'NEW';
                  END IF;
                  IF l_Account_Rec.Maker_Id <> Global.User_Id THEN
                     p_Err_Code   := 'LC-VALS-047';
                     p_Err_Params := NULL;
                     RETURN FALSE;
                  ELSE
                     Dbg('This For The Firsttime Unauth...');
                     Dbg('Calling clpks_Cldaccvm_main.fn_main.....');
                     IF NOT Clpks_Cldaccvm_Main.Fn_Main(p_Source
                                                       ,p_Source_Operation
                                                       ,p_Function_Id
                                                       ,Cspks_Req_Global.p_Delete
                                                       ,l_Multi_Trip_Id
                                                       ,l_Request_No
                                                       ,l_Cldaccvm
                                                       ,l_Status
                                                       ,p_Err_Code
                                                       ,p_Err_Params) THEN
                        Dbg('Failed in Clpks_Cldaant_Main.Fn_Main...');
                        Pr_Log_Error(p_Function_Id, p_Source, p_Err_Code, p_Err_Params);
                        RETURN FALSE;
                     END IF;
                  END IF;
               ELSE
                  Dbg('Authorized atleast once ...');

                  IF l_Event_Rec.Auth_Status = 'U' THEN
                     IF p_Function_Id IN ('CLDVAMI','CLDACCVM') THEN  --Kernel 11.3_RET_SFR_12401757 CLDACCVM ADDED
                        IF l_Event_Rec.Maker_Id != Global.User_Id THEN
                           p_Err_Code   := 'LCCON-037';
                           p_Err_Params := NULL;
                           RETURN FALSE;
                        ELSE
                           Dbg('Maker and the user are the same');

                           /*IF NOT Clpks_Cldaccvm_Main.Fn_Main(p_Source
                                                             ,p_Source_Operation
                                                             ,p_Function_Id
                                                             ,Cspks_Req_Global.p_Delete
                                                             ,l_Multi_Trip_Id
                                                             ,l_Request_No
                                                             ,l_Cldaccvm
                                                             ,l_Status
                                                             ,p_Err_Code
                                                             ,p_Err_Params) THEN
                              Dbg('Failed in Clpks_Cldaant_Main.Fn_Main...');
                              Pr_Log_Error(p_Function_Id, p_Source, p_Err_Code, p_Err_Params);
                              RETURN FALSE;
                           END IF;*/
                     --Kernel 11.3_RET_SFR_12401757 STARTS COMMENTEd BELOW CALL
                    /* Dbg('Calling Clpks_Cldaccvm_Utils.Fn_Modify_Account....');
                           IF NOT Clpks_Cldaccvm_Utils.Fn_Modify_Account(p_Source
                                                                        ,p_Source_Operation
                                                                        ,p_Function_Id
                                                                        ,p_Action_Code
                                                                        ,l_Cldaccvm
                                                                        ,p_Err_Code
                                                                        ,p_Err_Params) THEN
                              Dbg('Failed in Clpks_Cldaccvm_Utils.Fn_Modify_account');
                              Pr_Log_Error(p_Function_Id, p_Source, p_Err_Code, p_Err_Params);
                              RETURN FALSE;
                           END IF; */
                       --Kernel 11.3_RET_SFR_12401757 ends
                        END IF;
                     END IF;
                  END IF;
               END IF;
            END IF;
         END IF;

      END IF;
      Dbg('Returning Success From Fn_Unlock..');
      RETURN TRUE;
   EXCEPTION
      WHEN OTHERS THEN
         Debug.Pr_Debug('**', 'In When Others of clpks_Cldaccvm_Kernel.Fn_Unlock ..');
         Debug.Pr_Debug('**', SQLERRM);
         p_Err_Code   := 'ST-OTHR-001';
         p_Err_Params := NULL;
         RETURN FALSE;
   END Fn_Unlock;
   FUNCTION Fn_Query_Master(p_Source           IN VARCHAR2
                           ,p_Source_Operation IN VARCHAR2
                           ,p_Function_Id      IN VARCHAR2
                           ,p_Action_Code      IN VARCHAR2
                           ,p_Cldaccvm         IN Clpks_Cldaccvm_Main.Ty_Cldaccvm
                           ,p_Wrk_Cldaccvm     IN OUT Clpks_Cldaccvm_Main.Ty_Cldaccvm
                           ,p_Err_Code         IN OUT VARCHAR2
                           ,p_Err_Params       IN OUT VARCHAR2) RETURN BOOLEAN IS
      CURSOR c_v_Cltbs_Account_Promotions IS
         SELECT *
         FROM   Cltb_Account_Promotions
         WHERE  Account_Number = p_Wrk_Cldaccvm.v_Cltbs_Account_Master.Account_Number
         AND    Branch_Code = p_Wrk_Cldaccvm.v_Cltbs_Account_Master.Branch_Code;
      CURSOR c_v_Cltbs_Account_Parties IS
         SELECT *
         FROM   Cltb_Account_Parties
         WHERE  Account_Number = p_Wrk_Cldaccvm.v_Cltbs_Account_Master.Account_Number
         AND    Branch_Code = p_Wrk_Cldaccvm.v_Cltbs_Account_Master.Branch_Code;
      CURSOR c_v_Cltbs_Account_Hol_Perds IS
         SELECT *
         FROM   Cltb_Account_Hol_Perds
         WHERE  Account_Number = p_Wrk_Cldaccvm.v_Cltbs_Account_Master.Account_Number
         AND    Branch_Code = p_Wrk_Cldaccvm.v_Cltbs_Account_Master.Branch_Code;
      CURSOR c_v_Account_Ude_Eff_Dates IS
         SELECT *
         FROM   Cltb_Account_Ude_Eff_Dates
         WHERE  Account_Number = p_Wrk_Cldaccvm.v_Cltbs_Account_Master.Account_Number
         AND    Branch_Code = p_Wrk_Cldaccvm.v_Cltbs_Account_Master.Branch_Code;
      --effective_date = p_eff_date AND nvl(maint_rslv_flag, 'M') = 'M' also used in old
      CURSOR c_v_Cltbs_Account_Ude_Values IS
         SELECT *
         FROM   Cltb_Account_Ude_Values
         WHERE  Account_Number = p_Wrk_Cldaccvm.v_Cltbs_Account_Master.Account_Number
         AND    Branch_Code = p_Wrk_Cldaccvm.v_Cltbs_Account_Master.Branch_Code
         AND    Nvl(Maint_Rslv_Flag, 'M') = 'M';
      CURSOR c_v_Cltbs_Account_Roll_Comp IS
         SELECT *
         FROM   Cltb_Account_Roll_Comp
         WHERE  Account_Number = p_Wrk_Cldaccvm.v_Cltbs_Account_Master.Account_Number
         AND    Branch_Code = p_Wrk_Cldaccvm.v_Cltbs_Account_Master.Branch_Code;
      CURSOR c_v_Cltbs_Rate_Plan_Eff_Dates IS
         SELECT *
         FROM   Cltb_Rate_Plan_Eff_Dates
         WHERE  Account_Number = p_Wrk_Cldaccvm.v_Cltbs_Account_Master.Account_Number
         AND    Branch_Code = p_Wrk_Cldaccvm.v_Cltbs_Account_Master.Branch_Code;
      CURSOR c_v_Cltbs_Event_Check_List IS
         SELECT *
         FROM   Cltb_Event_Check_List
         WHERE  Account_Number = p_Wrk_Cldaccvm.v_Cltbs_Account_Master.Account_Number
         AND    Branch_Code = p_Wrk_Cldaccvm.v_Cltbs_Account_Master.Branch_Code;
      -- comp name?  a.component_type NOT IN ('H', 'O')
      CURSOR c_v_Account_Components__Cmp IS
         SELECT *
         FROM   Cltb_Account_Components
         WHERE  Account_Number = p_Wrk_Cldaccvm.v_Cltbs_Account_Master.Account_Number
         AND    Branch_Code = p_Wrk_Cldaccvm.v_Cltbs_Account_Master.Branch_Code
         AND    Component_Type NOT IN ('H', 'O');
      --comp name?
      CURSOR c_v_Cltbs_Account_Comp_Sch IS
         SELECT *
         FROM   Cltb_Account_Comp_Sch
         WHERE  Account_Number = p_Wrk_Cldaccvm.v_Cltbs_Account_Master.Account_Number
         AND    Branch_Code = p_Wrk_Cldaccvm.v_Cltbs_Account_Master.Branch_Code;

      --schedule_due_date > global.application_date AND nvl(schedule_flag, 'X') <> 'M' in old
      CURSOR c_v_Account_Schedules__Cmp IS
         SELECT *
         FROM   Cltb_Account_Schedules a
         WHERE  a.Account_Number = p_Wrk_Cldaccvm.v_Cltbs_Account_Master.Account_Number
         AND    a.Branch_Code = p_Wrk_Cldaccvm.v_Cltbs_Account_Master.Branch_Code
               --AND    a.Schedule_Due_Date > Global.Application_Date
         AND    (Nvl(a.Amount_Due, 0) <> 0 OR Nvl(a.Emi_Amount, 0) <> 0 OR Nvl(Decode(Component_Name
                                                                                     ,Pkg_Main_Int
                                                                                     ,Decode(Emi_Amount, NULL, NULL, Emi_Amount - Amount_Due)
                                                                                     ,Pkg_Principal
                                                                                     ,(SELECT Balance
                                                                                      FROM   Cltbs_Account_Comp_Balances b
                                                                                      WHERE  b.Account_Number = a.Account_Number
                                                                                      AND    b.Branch_Code = a.Branch_Code
                                                                                      AND    b.Component_Name = Pkg_Principal || '_EXPECTED'
                                                                                      AND    b.Val_Date = a.Schedule_Due_Date)
                                                                                     ,NULL)
                                                                              ,0) <> 0)

         AND    Nvl(Schedule_Flag, 'X') <> 'M'
         AND    Rownum <= Pkg_Totalrec;

      /*CURSOR c_v_Account_Schedules__Cmp IS
      SELECT *
      FROM   Cltb_Account_Schedules
      WHERE  Account_Number = p_Wrk_Cldaccvm.v_Cltbs_Account_Master.Account_Number
      AND    Branch_Code = p_Wrk_Cldaccvm.v_Cltbs_Account_Master.Branch_Code
      AND    Schedule_Due_Date > Global.Application_Date
      AND    Nvl(Schedule_Flag, 'X') <> 'M'
      AND    Rownum <= Pkg_Totalrec;*/

      CURSOR c_v_Cltbs_Account_Linkages IS
         SELECT *
         FROM   Cltb_Account_Linkages
         WHERE  Account_Number = p_Wrk_Cldaccvm.v_Cltbs_Account_Master.Account_Number
         AND    Branch_Code = p_Wrk_Cldaccvm.v_Cltbs_Account_Master.Branch_Code;
      CURSOR c_v_Account_Events_Advices IS
         SELECT *
         FROM   Cltb_Account_Events_Advices
         WHERE  Account_Number = p_Wrk_Cldaccvm.v_Cltbs_Account_Master.Account_Number
         AND    Branch_Code = p_Wrk_Cldaccvm.v_Cltbs_Account_Master.Branch_Code;
      CURSOR c_v_Account_Advice_Suppress IS
         SELECT *
         FROM   Cltb_Account_Advice_Suppress
         WHERE  Account_Number = p_Wrk_Cldaccvm.v_Cltbs_Account_Master.Account_Number
         AND    Branch_Code = p_Wrk_Cldaccvm.v_Cltbs_Account_Master.Branch_Code;
      CURSOR c_v_Account_Asset_Valuations IS
         SELECT *
         FROM   Cltb_Account_Asset_Valuations
         WHERE  Account_Number = p_Wrk_Cldaccvm.v_Cltbs_Account_Master.Account_Number
         AND    Branch_Code = p_Wrk_Cldaccvm.v_Cltbs_Account_Master.Branch_Code;
      CURSOR c_v_Cltbs_Account_Financials IS
         SELECT *
         FROM   Cltb_Account_Financials
         WHERE  Account_Number = p_Wrk_Cldaccvm.v_Cltbs_Account_Master.Account_Number
         AND    Branch_Code = p_Wrk_Cldaccvm.v_Cltbs_Account_Master.Branch_Code;
      CURSOR c_v_Cltbs_Account_Liabilities IS
         SELECT *
         FROM   Cltb_Account_Liabilities
         WHERE  Account_Number = p_Wrk_Cldaccvm.v_Cltbs_Account_Master.Account_Number
         AND    Branch_Code = p_Wrk_Cldaccvm.v_Cltbs_Account_Master.Branch_Code;
      CURSOR c_v_Account_Other_Income IS
         SELECT *
         FROM   Cltb_Account_Other_Income
         WHERE  Account_Number = p_Wrk_Cldaccvm.v_Cltbs_Account_Master.Account_Number
         AND    Branch_Code = p_Wrk_Cldaccvm.v_Cltbs_Account_Master.Branch_Code;
      -- comp name?
      CURSOR c_v_Cltbs_Disbr_Schedules IS
         SELECT *
         FROM   Cltb_Disbr_Schedules
         WHERE  Account_Number = p_Wrk_Cldaccvm.v_Cltbs_Account_Master.Account_Number
         AND    Branch_Code = p_Wrk_Cldaccvm.v_Cltbs_Account_Master.Branch_Code;
      -- comp name?
      CURSOR c_v_Cltbs_Revn_Schedules IS
         SELECT *
         FROM   Cltb_Revn_Schedules
         WHERE  Account_Number = p_Wrk_Cldaccvm.v_Cltbs_Account_Master.Account_Number
         AND    Branch_Code = p_Wrk_Cldaccvm.v_Cltbs_Account_Master.Branch_Code;
      -- comp name?  a.component_type IN ('H', 'O')
      CURSOR c_v_Account_Components__Chg IS
         SELECT *
         FROM   Cltb_Account_Components
         WHERE  Account_Number = p_Wrk_Cldaccvm.v_Cltbs_Account_Master.Account_Number
         AND    Branch_Code = p_Wrk_Cldaccvm.v_Cltbs_Account_Master.Branch_Code
         AND    Component_Type IN ('H', 'O');
      --schedule_due_date > global.application_date AND nvl(schedule_flag, 'X') <> 'M' in old
      CURSOR c_v_Account_Schedules__Chg IS
         SELECT *
         FROM   Cltb_Account_Schedules
         WHERE  Account_Number = p_Wrk_Cldaccvm.v_Cltbs_Account_Master.Account_Number
         AND    Branch_Code = p_Wrk_Cldaccvm.v_Cltbs_Account_Master.Branch_Code;
      CURSOR c_v_Clvss_Account_Charge IS
         SELECT DISTINCT * --tmp fix
         FROM   Clvs_Account_Charge
         WHERE  Account_Number = p_Wrk_Cldaccvm.v_Cltbs_Account_Master.Account_Number
         AND    Branch_Code = p_Wrk_Cldaccvm.v_Cltbs_Account_Master.Branch_Code;

      CURSOR c_v_Account_Comp_Balances IS
         SELECT *
         FROM   Clvs_Account_Comp_Balances
         WHERE  Account_Number = p_Wrk_Cldaccvm.v_Cltbs_Account_Master.Account_Number
         AND    Branch_Code = p_Wrk_Cldaccvm.v_Cltbs_Account_Master.Branch_Code;
      CURSOR c_v_Cltbs_Account_Irr IS
         SELECT *
         FROM   Cltb_Account_Irr
         WHERE  Account_Number = p_Wrk_Cldaccvm.v_Cltbs_Account_Master.Account_Number
         AND    Branch_Code = p_Wrk_Cldaccvm.v_Cltbs_Account_Master.Branch_Code;
      --Log#1 Changes start
      CURSOR c_v_Cltbs_Account_Emi_Chg IS
         SELECT *
         FROM   Cltb_Account_Emi_Chg
         WHERE  Account_Number = p_Wrk_Cldaccvm.v_Cltbs_Account_Master.Account_Number
         AND    Branch_Code = p_Wrk_Cldaccvm.v_Cltbs_Account_Master.Branch_Code;
      --Log#1 Changes ends
      CURSOR c_v_Cltbs_Account_Vamd IS
         SELECT *
         FROM   Cltb_Account_Vamd
         WHERE  Account_Number = p_Wrk_Cldaccvm.v_Cltbs_Account_Master.Account_Number
         AND    Branch_Code = p_Wrk_Cldaccvm.v_Cltbs_Account_Master.Branch_Code
         AND    Amend_Applied = 'N';
      --Log#3 7-Apr-10 FCUBS11.1 Mb0403 start
      CURSOR c_v_Acc_Guarantor_Customer IS
         SELECT *
         FROM   Cltb_Acc_Guarantor_Customer
         WHERE  Account_Number = p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd.Account_Number
         AND    Branch_Code = p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd.Branch_Code;
      CURSOR c_v_Acc_Guarantor_Accounts IS
         SELECT *
         FROM   Cltb_Acc_Guarantor_Accounts
         WHERE  Branch_Code = p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd.Branch_Code
         AND    Account_Number = p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd.Account_Number;
      l_Bnd_Cntr_44 NUMBER := 0;
      --Log#3 7-Apr-10 FCUBS11.1 Mb0403 end
      --Log#12 starts
       CURSOR c_v_Acc_Stmt_Pref IS
         SELECT *
         FROM   Cltb_Account_Statement
         WHERE  Branch_Code = p_Wrk_Cldaccvm.v_Cltbs_Account_Master.Branch_Code AND Account_Number = p_Wrk_Cldaccvm.v_Cltbs_Account_Master.Account_Number;
     --Log#12 ends


      j NUMBER := 0;
      k NUMBER := 0;
   BEGIN
      Dbg('In Fn_Query_master');

      p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd.Branch_Code    := Global.Current_Branch;
      p_Wrk_Cldaccvm.v_Cltbs_Account_Master.Branch_Code  := Global.Current_Branch;
      p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd.Account_Number := p_Wrk_Cldaccvm.v_Cltbs_Account_Master.Account_Number;
      p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd.Subsystemstat  := 'CREATEAMND:D;CVS_PROMOTIONS:D;HOLPERIODS:D;UDEVALS:D;COMPSCH:D;EXPLODE:D;MICTRMIS:D;';

      Dbg('Get Record for :CLTBS_ACCOUNT_VAMD_UNAPP');
      OPEN c_v_Cltbs_Account_Vamd;
      LOOP
         FETCH c_v_Cltbs_Account_Vamd BULK COLLECT
            INTO p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd__Unapp;
         EXIT WHEN c_v_Cltbs_Account_Vamd%NOTFOUND;
      END LOOP;
      CLOSE c_v_Cltbs_Account_Vamd;
      Dbg('UNAPPLIED AMND COUNT >>' || p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd__Unapp.COUNT);
      Dbg('Get the Record For :CLTBS_ACCOUNT_PARTIES');
      OPEN c_v_Cltbs_Account_Parties;
      LOOP
         FETCH c_v_Cltbs_Account_Parties BULK COLLECT
            INTO p_Wrk_Cldaccvm.v_Cltbs_Account_Parties;
         EXIT WHEN c_v_Cltbs_Account_Parties%NOTFOUND;
      END LOOP;
      CLOSE c_v_Cltbs_Account_Parties;
      Dbg('Get the Record For :CLTBS_ACCOUNT_HOL_PERDS');
      OPEN c_v_Cltbs_Account_Hol_Perds;
      LOOP
         FETCH c_v_Cltbs_Account_Hol_Perds BULK COLLECT
            INTO p_Wrk_Cldaccvm.v_Cltbs_Account_Hol_Perds;
         EXIT WHEN c_v_Cltbs_Account_Hol_Perds%NOTFOUND;
      END LOOP;
      CLOSE c_v_Cltbs_Account_Hol_Perds;
      Dbg('Get the Record For :CLTBS_ACCOUNT_UDE_EFF_DATES');
      OPEN c_v_Account_Ude_Eff_Dates;
      LOOP
         FETCH c_v_Account_Ude_Eff_Dates BULK COLLECT
            INTO p_Wrk_Cldaccvm.v_Account_Ude_Eff_Dates;
         EXIT WHEN c_v_Account_Ude_Eff_Dates%NOTFOUND;
      END LOOP;
      CLOSE c_v_Account_Ude_Eff_Dates;
      Dbg('Get the Record For :CLTBS_ACCOUNT_UDE_VALUES');
      OPEN c_v_Cltbs_Account_Ude_Values;
      LOOP
         FETCH c_v_Cltbs_Account_Ude_Values BULK COLLECT
            INTO p_Wrk_Cldaccvm.v_Cltbs_Account_Ude_Values;
         EXIT WHEN c_v_Cltbs_Account_Ude_Values%NOTFOUND;
      END LOOP;
      CLOSE c_v_Cltbs_Account_Ude_Values;
      Dbg('GETTING COUNT ??' || p_Wrk_Cldaccvm.v_Cltbs_Account_Ude_Values.COUNT);
      Dbg('Get the Record For :CLTBS_ACCOUNT_ROLL_COMP');
      OPEN c_v_Cltbs_Account_Roll_Comp;
      LOOP
         FETCH c_v_Cltbs_Account_Roll_Comp BULK COLLECT
            INTO p_Wrk_Cldaccvm.v_Cltbs_Account_Roll_Comp;
         EXIT WHEN c_v_Cltbs_Account_Roll_Comp%NOTFOUND;
      END LOOP;
      CLOSE c_v_Cltbs_Account_Roll_Comp;
      Dbg('Get the Record For :CLTBS_RATE_PLAN_EFF_DATES');
      OPEN c_v_Cltbs_Rate_Plan_Eff_Dates;
      LOOP
         FETCH c_v_Cltbs_Rate_Plan_Eff_Dates BULK COLLECT
            INTO p_Wrk_Cldaccvm.v_Cltbs_Rate_Plan_Eff_Dates;
         EXIT WHEN c_v_Cltbs_Rate_Plan_Eff_Dates%NOTFOUND;
      END LOOP;
      CLOSE c_v_Cltbs_Rate_Plan_Eff_Dates;
      Dbg('Get the Record For :CLTBS_EVENT_CHECK_LIST');
      OPEN c_v_Cltbs_Event_Check_List;
      LOOP
         FETCH c_v_Cltbs_Event_Check_List BULK COLLECT
            INTO p_Wrk_Cldaccvm.v_Cltbs_Event_Check_List;
         EXIT WHEN c_v_Cltbs_Event_Check_List%NOTFOUND;
      END LOOP;
      CLOSE c_v_Cltbs_Event_Check_List;
      Dbg('Get the Record For :CLTBS_EVENT_REMARKS');
      BEGIN
         SELECT *
         INTO   p_Wrk_Cldaccvm.v_Cltbs_Event_Remarks
         FROM   Cltb_Event_Remarks
         WHERE  Account_Number = p_Wrk_Cldaccvm.v_Cltbs_Account_Master.Account_Number
         AND    Branch_Code = p_Wrk_Cldaccvm.v_Cltbs_Account_Master.Branch_Code;
      EXCEPTION
         WHEN OTHERS THEN
            Dbg(SQLERRM);
            Dbg('Failed in Selecting The Record For :CLTBS_EVENT_REMARKS');
      END;
      Dbg('Get the Record For :CLTBS_ACCOUNT_COMPONENTS__CMP');
      OPEN c_v_Account_Components__Cmp;
      LOOP
         FETCH c_v_Account_Components__Cmp BULK COLLECT
            INTO p_Wrk_Cldaccvm.v_Account_Components__Cmp;
         EXIT WHEN c_v_Account_Components__Cmp%NOTFOUND;
      END LOOP;
      CLOSE c_v_Account_Components__Cmp;
      Dbg('Get the Record For :CLTBS_ACCOUNT_COMP_SCH');
      OPEN c_v_Cltbs_Account_Comp_Sch;
      LOOP
         FETCH c_v_Cltbs_Account_Comp_Sch BULK COLLECT
            INTO p_Wrk_Cldaccvm.v_Cltbs_Account_Comp_Sch;
         EXIT WHEN c_v_Cltbs_Account_Comp_Sch%NOTFOUND;
      END LOOP;
      CLOSE c_v_Cltbs_Account_Comp_Sch;
      Dbg('Get the Record For :CLTBS_ACCOUNT_SCHEDULES__CMP');
      OPEN c_v_Account_Schedules__Cmp;
      LOOP
         FETCH c_v_Account_Schedules__Cmp BULK COLLECT
            INTO p_Wrk_Cldaccvm.v_Account_Schedules__Cmp;
         EXIT WHEN c_v_Account_Schedules__Cmp%NOTFOUND;
      END LOOP;
      CLOSE c_v_Account_Schedules__Cmp;
      --Log#12 starts
       OPEN c_v_Acc_Stmt_Pref;
         LOOP
            FETCH c_v_Acc_Stmt_Pref
               INTO p_Wrk_Cldaccvm.v_Cltbs_Account_Statement;
            EXIT WHEN c_v_Acc_Stmt_Pref%NOTFOUND;
         END LOOP;
      close c_v_Acc_Stmt_Pref;
      --Log#12 ends
         Dbg(' FREQUENCY heree  '||p_Wrk_Cldaccvm.v_Cltbs_Account_Statement.FREQUENCY);

      Dbg('Assigning for Amort Principal');
      IF p_Wrk_Cldaccvm.v_Account_Schedules__Cmp.COUNT > 0 THEN
         FOR i IN p_Wrk_Cldaccvm.v_Account_Schedules__Cmp.FIRST .. p_Wrk_Cldaccvm.v_Account_Schedules__Cmp.LAST LOOP
            j := j + 1;
            p_Wrk_Cldaccvm.v_Cstbs_Ui_Columns__Sch(j).Char_Field1 := p_Wrk_Cldaccvm.v_Account_Schedules__Cmp(i).Account_Number;
            p_Wrk_Cldaccvm.v_Cstbs_Ui_Columns__Sch(j).Char_Field2 := p_Wrk_Cldaccvm.v_Account_Schedules__Cmp(i).Branch_Code;
            p_Wrk_Cldaccvm.v_Cstbs_Ui_Columns__Sch(j).Char_Field3 := p_Wrk_Cldaccvm.v_Account_Schedules__Cmp(i).Component_Name;
            p_Wrk_Cldaccvm.v_Cstbs_Ui_Columns__Sch(j).Date_Field1 := p_Wrk_Cldaccvm.v_Account_Schedules__Cmp(i).Schedule_Due_Date;
            p_Wrk_Cldaccvm.v_Cstbs_Ui_Columns__Sch(j).Date_Field2 := p_Wrk_Cldaccvm.v_Account_Schedules__Cmp(i).Schedule_St_Date;
            p_Wrk_Cldaccvm.v_Cstbs_Ui_Columns__Sch(j).Num_Field1 := p_Wrk_Cldaccvm.v_Account_Schedules__Cmp(i).Event_Seq_No;
            IF p_Wrk_Cldaccvm.v_Account_Schedules__Cmp(i).Component_Name = Pkg_Main_Int THEN
               IF p_Wrk_Cldaccvm.v_Account_Schedules__Cmp(i).Emi_Amount IS NOT NULL THEN
                  p_Wrk_Cldaccvm.v_Cstbs_Ui_Columns__Sch(j).Char_Field4 := p_Wrk_Cldaccvm.v_Account_Schedules__Cmp(i)
                                                                          .Emi_Amount - p_Wrk_Cldaccvm.v_Account_Schedules__Cmp(i).Amount_Due;
               END IF;
            ELSIF p_Wrk_Cldaccvm.v_Account_Schedules__Cmp(i).Component_Name = Pkg_Principal THEN
               BEGIN
                  SELECT Balance
                  INTO   p_Wrk_Cldaccvm.v_Cstbs_Ui_Columns__Sch(j) .Char_Field4
                  FROM   Cltbs_Account_Comp_Balances b
                  WHERE  b.Account_Number = p_Wrk_Cldaccvm.v_Account_Schedules__Cmp(i).Account_Number
                  AND    b.Branch_Code = p_Wrk_Cldaccvm.v_Account_Schedules__Cmp(i).Branch_Code
                  AND    b.Component_Name = Pkg_Principal || '_EXPECTED'
                  AND    b.Val_Date = p_Wrk_Cldaccvm.v_Account_Schedules__Cmp(i).Schedule_Due_Date;
               EXCEPTION
                  WHEN OTHERS THEN
                     Dbg('gone' || SQLERRM);
                     NULL;
               END;
            END IF;
            Dbg('value' || p_Wrk_Cldaccvm.v_Cstbs_Ui_Columns__Sch(j).Char_Field4);
         END LOOP;
      END IF;

      Dbg('Get the Record For :CLTBS_ACCOUNT_LINKAGES');
      OPEN c_v_Cltbs_Account_Linkages;
      LOOP
         FETCH c_v_Cltbs_Account_Linkages BULK COLLECT
            INTO p_Wrk_Cldaccvm.v_Cltbs_Account_Linkages;
         EXIT WHEN c_v_Cltbs_Account_Linkages%NOTFOUND;
      END LOOP;
      CLOSE c_v_Cltbs_Account_Linkages;
      Dbg('Get the Record For :CLTBS_ACCOUNT_EVENTS_ADVICES');
      OPEN c_v_Account_Events_Advices;
      LOOP
         FETCH c_v_Account_Events_Advices BULK COLLECT
            INTO p_Wrk_Cldaccvm.v_Account_Events_Advices;
         EXIT WHEN c_v_Account_Events_Advices%NOTFOUND;
      END LOOP;
      CLOSE c_v_Account_Events_Advices;
      Dbg('Get the Record For :CLTBS_ACCOUNT_ADVICE_SUPPRESS');
      OPEN c_v_Account_Advice_Suppress;
      LOOP
         FETCH c_v_Account_Advice_Suppress BULK COLLECT
            INTO p_Wrk_Cldaccvm.v_Account_Advice_Suppress;
         EXIT WHEN c_v_Account_Advice_Suppress%NOTFOUND;
      END LOOP;
      CLOSE c_v_Account_Advice_Suppress;
      Dbg('Get the Record For :CLTBS_ACCOUNT_CREDIT_SCORE');
      BEGIN
         SELECT *
         INTO   p_Wrk_Cldaccvm.v_Account_Credit_Score
         FROM   Cltb_Account_Credit_Score
         WHERE  Account_Number = p_Wrk_Cldaccvm.v_Cltbs_Account_Master.Account_Number
         AND    Branch_Code = p_Wrk_Cldaccvm.v_Cltbs_Account_Master.Branch_Code;
      EXCEPTION
         WHEN OTHERS THEN
            Dbg(SQLERRM);
            Dbg('Failed in Selecting The Record For :CLTBS_ACCOUNT_CREDIT_SCORE');
      END;
      Dbg('Get the Record For :CLTBS_ACCOUNT_ASSET_VEHICLE');
      BEGIN
         SELECT *
         INTO   p_Wrk_Cldaccvm.v_Account_Asset_Vehicle
         FROM   Cltb_Account_Asset_Vehicle
         WHERE  Account_Number = p_Wrk_Cldaccvm.v_Cltbs_Account_Master.Account_Number
         AND    Branch_Code = p_Wrk_Cldaccvm.v_Cltbs_Account_Master.Branch_Code;
      EXCEPTION
         WHEN OTHERS THEN
            Dbg(SQLERRM);
            Dbg('Failed in Selecting The Record For :CLTBS_ACCOUNT_ASSET_VEHICLE');
      END;
      Dbg('Get the Record For :CLTBS_ACCOUNT_ASSET_HOME');
      BEGIN
         SELECT *
         INTO   p_Wrk_Cldaccvm.v_Cltbs_Account_Asset_Home
         FROM   Cltb_Account_Asset_Home
         WHERE  Account_Number = p_Wrk_Cldaccvm.v_Cltbs_Account_Master.Account_Number
         AND    Branch_Code = p_Wrk_Cldaccvm.v_Cltbs_Account_Master.Branch_Code;
      EXCEPTION
         WHEN OTHERS THEN
            Dbg(SQLERRM);
            Dbg('Failed in Selecting The Record For :CLTBS_ACCOUNT_ASSET_HOME');
      END;
      Dbg('Get the Record For :CLTBS_ACCOUNT_ASSET_OTHERS');
      BEGIN
         SELECT *
         INTO   p_Wrk_Cldaccvm.v_Account_Asset_Others
         FROM   Cltb_Account_Asset_Others
         WHERE  Account_Number = p_Wrk_Cldaccvm.v_Cltbs_Account_Master.Account_Number
         AND    Branch_Code = p_Wrk_Cldaccvm.v_Cltbs_Account_Master.Branch_Code;
      EXCEPTION
         WHEN OTHERS THEN
            Dbg(SQLERRM);
            Dbg('Failed in Selecting The Record For :CLTBS_ACCOUNT_ASSET_OTHERS');
      END;
      Dbg('Get the Record For :CLTBS_ACCOUNT_PROPERTY');
      BEGIN
         SELECT *
         INTO   p_Wrk_Cldaccvm.v_Cltbs_Account_Property
         FROM   Cltb_Account_Property
         WHERE  Account_Number = p_Wrk_Cldaccvm.v_Cltbs_Account_Master.Account_Number
         AND    Branch_Code = p_Wrk_Cldaccvm.v_Cltbs_Account_Master.Branch_Code;
      EXCEPTION
         WHEN OTHERS THEN
            Dbg(SQLERRM);
            Dbg('Failed in Selecting The Record For :CLTBS_ACCOUNT_PROPERTY');
      END;
      Dbg('Get the Record For :CLTBS_ACCOUNT_ASSET_VALUATIONS');
      OPEN c_v_Account_Asset_Valuations;
      LOOP
         FETCH c_v_Account_Asset_Valuations BULK COLLECT
            INTO p_Wrk_Cldaccvm.v_Account_Asset_Valuations;
         EXIT WHEN c_v_Account_Asset_Valuations%NOTFOUND;
      END LOOP;
      CLOSE c_v_Account_Asset_Valuations;
      Dbg('Get the Record For :CLTBS_ACCOUNT_FINANCIALS');
      OPEN c_v_Cltbs_Account_Financials;
      LOOP
         FETCH c_v_Cltbs_Account_Financials BULK COLLECT
            INTO p_Wrk_Cldaccvm.v_Cltbs_Account_Financials;
         EXIT WHEN c_v_Cltbs_Account_Financials%NOTFOUND;
      END LOOP;
      CLOSE c_v_Cltbs_Account_Financials;
      Dbg('Get the Record For :CLTBS_ACCOUNT_LIABILITIES');
      OPEN c_v_Cltbs_Account_Liabilities;
      LOOP
         FETCH c_v_Cltbs_Account_Liabilities BULK COLLECT
            INTO p_Wrk_Cldaccvm.v_Cltbs_Account_Liabilities;
         EXIT WHEN c_v_Cltbs_Account_Liabilities%NOTFOUND;
      END LOOP;
      CLOSE c_v_Cltbs_Account_Liabilities;
      Dbg('Get the Record For :CLTBS_ACCOUNT_OTHER_INCOME');
      OPEN c_v_Account_Other_Income;
      LOOP
         FETCH c_v_Account_Other_Income BULK COLLECT
            INTO p_Wrk_Cldaccvm.v_Account_Other_Income;
         EXIT WHEN c_v_Account_Other_Income%NOTFOUND;
      END LOOP;
      CLOSE c_v_Account_Other_Income;
      Dbg('Get the Record For :CLTBS_DISBR_SCHEDULES');
      OPEN c_v_Cltbs_Disbr_Schedules;
      LOOP
         FETCH c_v_Cltbs_Disbr_Schedules BULK COLLECT
            INTO p_Wrk_Cldaccvm.v_Cltbs_Disbr_Schedules;
         EXIT WHEN c_v_Cltbs_Disbr_Schedules%NOTFOUND;
      END LOOP;
      CLOSE c_v_Cltbs_Disbr_Schedules;
      Dbg('Get the Record For :CLTBS_REVN_SCHEDULES');
      OPEN c_v_Cltbs_Revn_Schedules;
      LOOP
         FETCH c_v_Cltbs_Revn_Schedules BULK COLLECT
            INTO p_Wrk_Cldaccvm.v_Cltbs_Revn_Schedules;
         EXIT WHEN c_v_Cltbs_Revn_Schedules%NOTFOUND;
      END LOOP;
      CLOSE c_v_Cltbs_Revn_Schedules;
      Dbg('Get the Record For :CLTBS_ACCOUNT_COMPONENTS__CHG');
      OPEN c_v_Account_Components__Chg;
      LOOP
         FETCH c_v_Account_Components__Chg BULK COLLECT
            INTO p_Wrk_Cldaccvm.v_Account_Components__Chg;
         EXIT WHEN c_v_Account_Components__Chg%NOTFOUND;
      END LOOP;
      IF p_Wrk_Cldaccvm.v_Account_Components__Chg.COUNT > 0 THEN
         FOR i IN p_Wrk_Cldaccvm.v_Account_Components__Chg.FIRST .. p_Wrk_Cldaccvm.v_Account_Components__Chg.LAST LOOP
            k := k + 1;
            p_Wrk_Cldaccvm.v_Cstbs_Ui_Columns__Chg(k).Char_Field1 := p_Wrk_Cldaccvm.v_Cltbs_Account_Master.Account_Number;
            p_Wrk_Cldaccvm.v_Cstbs_Ui_Columns__Chg(k).Char_Field2 := p_Wrk_Cldaccvm.v_Cltbs_Account_Master.Branch_Code;
            p_Wrk_Cldaccvm.v_Cstbs_Ui_Columns__Chg(k).Char_Field3 := p_Wrk_Cldaccvm.v_Account_Components__Chg(i).Component_Name;
            p_Wrk_Cldaccvm.v_Cstbs_Ui_Columns__Chg(k).Date_Field1 := p_Wrk_Cldaccvm.v_Cltbs_Account_Master.Value_Date;
         END LOOP;
      END IF;

      CLOSE c_v_Account_Components__Chg;
      Dbg('Get the Record For :CLTBS_ACCOUNT_SCHEDULES__CHG');
      OPEN c_v_Account_Schedules__Chg;
      LOOP
         FETCH c_v_Account_Schedules__Chg BULK COLLECT
            INTO p_Wrk_Cldaccvm.v_Account_Schedules__Chg;
         EXIT WHEN c_v_Account_Schedules__Chg%NOTFOUND;
      END LOOP;
      CLOSE c_v_Account_Schedules__Chg;
      Dbg('Get the Record For :CLVSS_ACCOUNT_CHARGE');
      OPEN c_v_Clvss_Account_Charge;
      LOOP
         FETCH c_v_Clvss_Account_Charge BULK COLLECT
            INTO p_Wrk_Cldaccvm.v_Clvss_Account_Charge;
         EXIT WHEN c_v_Clvss_Account_Charge%NOTFOUND;
      END LOOP;
      CLOSE c_v_Clvss_Account_Charge;
      Dbg('Get the Record For :CLVSS_ACCOUNT_COMP_BALANCES');
      OPEN c_v_Account_Comp_Balances;
      LOOP
         FETCH c_v_Account_Comp_Balances BULK COLLECT
            INTO p_Wrk_Cldaccvm.v_Account_Comp_Balances;
         EXIT WHEN c_v_Account_Comp_Balances%NOTFOUND;
      END LOOP;
      CLOSE c_v_Account_Comp_Balances;
      Dbg('Get the Record For :CLTBS_ACCOUNT_IRR');
      OPEN c_v_Cltbs_Account_Irr;
      LOOP
         FETCH c_v_Cltbs_Account_Irr BULK COLLECT
            INTO p_Wrk_Cldaccvm.v_Cltbs_Account_Irr;
         EXIT WHEN c_v_Cltbs_Account_Irr%NOTFOUND;
      END LOOP;
      CLOSE c_v_Cltbs_Account_Irr;

      Dbg('Get the Record For :CLTBS_ACCOUNT_SETTL_DETAILS');
      BEGIN
         SELECT *
         INTO   p_Wrk_Cldaccvm.v_Account_Settl_Details
         FROM   Cltb_Account_Settl_Details
         WHERE  Account_Number = p_Wrk_Cldaccvm.v_Cltbs_Account_Master.Account_Number
         AND    Branch_Code = p_Wrk_Cldaccvm.v_Cltbs_Account_Master.Branch_Code;
      EXCEPTION
         WHEN OTHERS THEN
            Dbg(SQLERRM);
            Dbg('Failed in Selecting The Record For :CLTBS_ACCOUNT_SETTL_DETAILS');
      END;

      --Log#1 Changes start
      Dbg('Get the Record For :CLTBS_ACCOUNT_EMI_CHG');
      OPEN c_v_Cltbs_Account_Emi_Chg;
      LOOP
         FETCH c_v_Cltbs_Account_Emi_Chg BULK COLLECT
            INTO p_Wrk_Cldaccvm.v_Cltbs_Account_Emi_Chg;
         EXIT WHEN c_v_Cltbs_Account_Emi_Chg%NOTFOUND;
      END LOOP;
      CLOSE c_v_Cltbs_Account_Emi_Chg;
      --Log#1 Changes ends
      --Log#3 7-Apr-10 FCUBS11.1 MB0403 start
      Dbg('Get the Record For :CLTBS_ACC_GUARANTOR_CUSTOMER');
      OPEN c_v_Acc_Guarantor_Customer;
      LOOP
         FETCH c_v_Acc_Guarantor_Customer BULK COLLECT
            INTO p_Wrk_Cldaccvm.v_Acc_Guarantor_Customer;
         EXIT WHEN c_v_Acc_Guarantor_Customer%NOTFOUND;
      END LOOP;
      CLOSE c_v_Acc_Guarantor_Customer;
      Dbg('Get the Record For :CLTBS_ACC_GUARANTOR_ACCOUNTS');
      OPEN c_v_Acc_Guarantor_Accounts;
      LOOP
         FETCH c_v_Acc_Guarantor_Accounts BULK COLLECT
            INTO p_Wrk_Cldaccvm.v_Acc_Guarantor_Accounts;
         EXIT WHEN c_v_Acc_Guarantor_Accounts%NOTFOUND;
      END LOOP;
      CLOSE c_v_Acc_Guarantor_Accounts;

      IF p_Wrk_Cldaccvm.v_Acc_Guarantor_Customer.COUNT > 0 THEN
         FOR i_44 IN 1 .. p_Wrk_Cldaccvm.v_Acc_Guarantor_Customer.COUNT LOOP
            BEGIN
               SELECT Customer_Name1
               INTO   p_Wrk_Cldaccvm.Desc_Fields('CLTBS_ACC_GUARANTOR_CUSTOMER')(i_44)('TXT_CUSTNAME')
               FROM   (SELECT Customer_No, Customer_Name1
                        FROM   Sttm_Customer
                        ORDER  BY Customer_No)
               WHERE  Customer_No = p_Wrk_Cldaccvm.v_Acc_Guarantor_Customer(i_44).Guarantor_Cif
               AND    Rownum < 2;
            EXCEPTION
               WHEN OTHERS THEN
                  p_Wrk_Cldaccvm.Desc_Fields('CLTBS_ACC_GUARANTOR_CUSTOMER')(i_44)('TXT_CUSTNAME') := NULL;
                  Dbg(SQLERRM);
                  Dbg('Failed in selecting the Desc Fields For  :CUSTNO ' || p_Wrk_Cldaccvm.v_Acc_Guarantor_Customer(i_44).Guarantor_Cif);
            END;
         END LOOP;
      END IF;
      IF p_Wrk_Cldaccvm.v_Acc_Guarantor_Accounts.COUNT > 0 THEN
         FOR i_45 IN 1 .. p_Wrk_Cldaccvm.v_Acc_Guarantor_Accounts.COUNT LOOP
            l_Bnd_Cntr_44 := 0;
            IF p_Wrk_Cldaccvm.v_Acc_Guarantor_Customer.COUNT > 0 THEN
               FOR i_44 IN 1 .. p_Wrk_Cldaccvm.v_Acc_Guarantor_Customer.COUNT LOOP
                  IF Nvl(p_Wrk_Cldaccvm.v_Acc_Guarantor_Accounts(i_45).Branch_Code, '@') = Nvl(p_Wrk_Cldaccvm.v_Acc_Guarantor_Customer(i_44).Branch_Code, '@') AND
                     Nvl(p_Wrk_Cldaccvm.v_Acc_Guarantor_Accounts(i_45).Account_Number, '@') =
                     Nvl(p_Wrk_Cldaccvm.v_Acc_Guarantor_Customer(i_44).Account_Number, '@') AND
                     Nvl(p_Wrk_Cldaccvm.v_Acc_Guarantor_Accounts(i_45).Component_Name, '@') =
                     Nvl(p_Wrk_Cldaccvm.v_Acc_Guarantor_Customer(i_44).Component_Name, '@') AND
                     Nvl(p_Wrk_Cldaccvm.v_Acc_Guarantor_Accounts(i_45).Guarantor_Cif, '@') =
                     Nvl(p_Wrk_Cldaccvm.v_Acc_Guarantor_Customer(i_44).Guarantor_Cif, '@') THEN
                     l_Bnd_Cntr_44 := i_44;
                     EXIT;
                  END IF;
               END LOOP;
            END IF;
            IF l_Bnd_Cntr_44 > 0 THEN
               BEGIN
                  SELECT Currency
                  INTO   p_Wrk_Cldaccvm.Desc_Fields('CLTBS_ACC_GUARANTOR_ACCOUNTS')(i_45)('GUAACCCY')
                  FROM   (SELECT Account_No, Branch_Code, Currency
                           FROM   Stvws_Account
                           WHERE  Ac_Or_Gl = 'A'
                           AND    Record_Stat = 'O'
                           AND    Customer_No = p_Wrk_Cldaccvm.v_Acc_Guarantor_Customer(l_Bnd_Cntr_44).Guarantor_Cif)
                  WHERE  Account_No = p_Wrk_Cldaccvm.v_Acc_Guarantor_Accounts(i_45).Guarantor_Acc
                  AND    Rownum < 2;
               EXCEPTION
                  WHEN OTHERS THEN
                     p_Wrk_Cldaccvm.Desc_Fields('CLTBS_ACC_GUARANTOR_ACCOUNTS')(i_45)('GUAACCCY') := NULL;
                     Dbg(SQLERRM);
                     Dbg('Failed in selecting the Desc Fields For  :GUAACC');
               END;
            END IF;
         END LOOP;
      END IF;
      --Log#3 7-Apr-10 FCUBS11.1 MB0403 end
      IF NOT Clpks_Cldaccvm_Utils_1.Fn_Query_Udf_Values(p_Wrk_Cldaccvm, p_Err_Code, p_Err_Params) THEN
         Dbg('Failed in call to clpkss_utils_2.fn_query_udf_values');
         Pr_Log_Error(p_Function_Id, p_Source, p_Err_Code, p_Err_Params);
         RETURN FALSE;
      END IF;

      /*
      IF NOT Pkgs_Cldaccdt.Fn_Populate_Amendment( p_Wrk_Cldaccvm.v_Cltbs_Account_Master.Account_Number,  p_Wrk_Cldaccvm.v_Cltbs_Account_Master.Branch_Code, Nvl(p_Effdt, p_Effdtd), p_Account_Obj, p_Errs, p_Prms) THEN
         Dbg('Error in populating the object for VAMI. Returning False');
         RETURN FALSE;
      END IF;
      */

      RETURN TRUE;
      Dbg('Returning true from Fn_Query_master');
   EXCEPTION
      WHEN OTHERS THEN
         Dbg('In when others in Fn_Query_master ' || SQLERRM);
         Dbg(Dbms_Utility.Format_Error_Backtrace);
         p_Err_Code   := 'ST-OTHR-001';
         p_Err_Params := NULL;
         RETURN FALSE;
   END Fn_Query_Master;

   FUNCTION Fn_Query_Amend(p_Source           IN VARCHAR2
                          ,p_Source_Operation IN VARCHAR2
                          ,p_Function_Id      IN VARCHAR2
                          ,p_Action_Code      IN VARCHAR2
                          ,p_Cldaccvm         IN Clpks_Cldaccvm_Main.Ty_Cldaccvm
                          ,p_Wrk_Cldaccvm     IN OUT Clpks_Cldaccvm_Main.Ty_Cldaccvm
                          ,p_Err_Code         IN OUT VARCHAR2
                          ,p_Err_Params       IN OUT VARCHAR2) RETURN BOOLEAN IS
      CURSOR c_v_Cltbs_Account_Vamd IS
         SELECT *
         FROM   Cltb_Account_Vamd
         WHERE  Account_Number = p_Wrk_Cldaccvm.v_Cltbs_Account_Master.Account_Number
         AND    Branch_Code = p_Wrk_Cldaccvm.v_Cltbs_Account_Master.Branch_Code
         AND    Amend_Applied = 'N';

      CURSOR c_v_Cltbs_Parties_Amnd IS
         SELECT *
         FROM   Cltb_Account_Parties_Amnd
         WHERE  Account_Number = p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd.Account_Number
         AND    Branch_Code = p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd.Branch_Code
         AND    Effective_Date = p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd.Effective_Date
         AND    Auth_Status = p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd.Auth_Stat
         AND    Active_Status = p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd.Active_Status;

      CURSOR c_v_Cltbs_Hol_Perds_Amnd IS

         SELECT *
         FROM   Cltb_Account_Hol_Perds_Amnd
         WHERE  Account_Number = p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd.Account_Number
         AND    Branch_Code = p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd.Branch_Code
         AND    Effective_Date = p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd.Effective_Date
         AND    Auth_Status = p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd.Auth_Stat
         AND    Active_Status = p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd.Active_Status;

      CURSOR c_v_Ude_Eff_Dates_Amnd IS

         SELECT *
         FROM   Cltbs_Acc_Ude_Eff_Dates_Amnd
         WHERE  Account_Number = p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd.Account_Number
         AND    Branch_Code = p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd.Branch_Code
         AND    Amnd_Eff_Date = p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd.Effective_Date
         AND    Auth_Status = p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd.Auth_Stat
         AND    Active_Status = p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd.Active_Status;

      CURSOR c_v_Cltbs_Ude_Values_Amnd IS

         SELECT *
         FROM   Cltb_Account_Ude_Values_Amnd
         WHERE  Account_Number = p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd.Account_Number
         AND    Branch_Code = p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd.Branch_Code
         AND    Amnd_Eff_Date = p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd.Effective_Date
         AND    Auth_Status = p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd.Auth_Stat
         AND    Active_Status = p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd.Active_Status
         AND    Nvl(Maint_Rslv_Flag, 'M') = 'M';
      CURSOR c_v_Cltbs_Roll_Comp_Amnd IS

         SELECT *
         FROM   Cltb_Account_Roll_Comp_Amnd
         WHERE  Account_Number = p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd.Account_Number
         AND    Branch_Code = p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd.Branch_Code
         AND    Effective_Date = p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd.Effective_Date
         AND    Auth_Status = p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd.Auth_Stat
         AND    Active_Status = p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd.Active_Status;

      CURSOR c_v_Cltbs_Rtplan_Effdt_Amnd IS

         SELECT *
         FROM   Cltb_Rtplan_Effdt_Amnd
         WHERE  Account_Number = p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd.Account_Number
         AND    Branch_Code = p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd.Branch_Code
         AND    Effective_Date = p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd.Effective_Date
         AND    Auth_Status = p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd.Auth_Stat
         AND    Active_Status = p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd.Active_Status;

      CURSOR c_v_Cltbs_Check_List_Amnd IS
         SELECT a.*
         FROM   Cltb_Event_Check_List a
         WHERE  a.Account_Number = p_Wrk_Cldaccvm.v_Cltbs_Account_Master.Account_Number
         AND    a.Branch_Code = p_Wrk_Cldaccvm.v_Cltbs_Account_Master.Branch_Code;
      CURSOR c_v_Account_Comp__Cmp_Amnd IS

         SELECT *
         FROM   Cltb_Account_Components_Amnd
         WHERE  Account_Number = p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd.Account_Number
         AND    Branch_Code = p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd.Branch_Code
         AND    Effective_Date = p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd.Effective_Date
         AND    Auth_Status = p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd.Auth_Stat
         AND    Active_Status = p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd.Active_Status
         AND    Component_Type NOT IN ('H', 'O');

      CURSOR c_v_Cltbs_Comp_Sch_Amnd IS

         SELECT *
         FROM   Cltb_Account_Comp_Sch_Amnd
         WHERE  Account_Number = p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd.Account_Number
         AND    Branch_Code = p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd.Branch_Code
         AND    Effective_Date = p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd.Effective_Date
         AND    Auth_Status = p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd.Auth_Stat
         AND    Active_Status = p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd.Active_Status;

      CURSOR c_v_Account_Sch__Cmp_Amnd IS

         SELECT *
         FROM   Cltb_Account_Schedules_Amnd
         WHERE  Account_Number = p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd.Account_Number
         AND    Branch_Code = p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd.Branch_Code
         AND    Effective_Date = p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd.Effective_Date
         AND    Auth_Status = p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd.Auth_Stat
         AND    Active_Status = p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd.Active_Status;

      CURSOR c_v_Cltbs_Linkages_Amnd IS

         SELECT *
         FROM   Cltb_Account_Linkages_Amnd
         WHERE  Account_Number = p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd.Account_Number
         AND    Branch_Code = p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd.Branch_Code
         AND    Effective_Date = p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd.Effective_Date
         AND    Auth_Status = p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd.Auth_Stat
         AND    Active_Status = p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd.Active_Status;

      CURSOR c_v_Account_Advices_Amnd IS
         SELECT a.*
         FROM   Cltb_Account_Events_Advices a
         WHERE  a.Account_Number = p_Wrk_Cldaccvm.v_Cltbs_Account_Master.Account_Number
         AND    a.Branch_Code = p_Wrk_Cldaccvm.v_Cltbs_Account_Master.Branch_Code;
      CURSOR c_v_Advice_Suppress_Amnd IS
         SELECT a.*
         FROM   Cltb_Account_Advice_Suppress a
         WHERE  a.Account_Number = p_Wrk_Cldaccvm.v_Cltbs_Account_Master.Account_Number
         AND    a.Branch_Code = p_Wrk_Cldaccvm.v_Cltbs_Account_Master.Branch_Code;

      CURSOR c_v_Asset_Valuations_Amnd IS

         SELECT *
         FROM   Cltb_Asset_Valuations_Amnd
         WHERE  Account_Number = p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd.Account_Number
         AND    Branch_Code = p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd.Branch_Code
         AND    Effective_Date = p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd.Effective_Date
         AND    Auth_Status = p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd.Auth_Stat
         AND    Active_Status = p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd.Active_Status;

      CURSOR c_v_Cltbs_Financials_Amnd IS

         SELECT *
         FROM   Cltb_Financials_Amnd
         WHERE  Account_Number = p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd.Account_Number
         AND    Branch_Code = p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd.Branch_Code
         AND    Effective_Date = p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd.Effective_Date
         AND    Auth_Status = p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd.Auth_Stat
         AND    Active_Status = p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd.Active_Status;

      CURSOR c_v_Cltbs_Liabilities_Amnd IS
         SELECT *
         FROM   Cltb_Liabilities_Amnd
         WHERE  Account_Number = p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd.Account_Number
         AND    Branch_Code = p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd.Branch_Code
         AND    Effective_Date = p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd.Effective_Date
         AND    Auth_Status = p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd.Auth_Stat
         AND    Active_Status = p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd.Active_Status;

      CURSOR c_v_Other_Income_Amnd IS
         SELECT *
         FROM   Cltb_Other_Income_Amnd
         WHERE  Account_Number = p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd.Account_Number
         AND    Branch_Code = p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd.Branch_Code
         AND    Effective_Date = p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd.Effective_Date
         AND    Auth_Status = p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd.Auth_Stat
         AND    Active_Status = p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd.Active_Status;

      CURSOR c_v_Cltbs_Disbr_Sch_Amnd IS
         SELECT *
         FROM   Cltb_Disbr_Schedules_Amnd
         WHERE  Account_Number = p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd.Account_Number
         AND    Branch_Code = p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd.Branch_Code
         AND    Effective_Date = p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd.Effective_Date
         AND    Auth_Status = p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd.Auth_Stat
         AND    Active_Status = p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd.Active_Status;

      CURSOR c_v_Cltbs_Revn_Sch_Amnd IS
         SELECT *
         FROM   Cltb_Revn_Schedules_Amnd
         WHERE  Account_Number = p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd.Account_Number
         AND    Branch_Code = p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd.Branch_Code
         AND    Effective_Date = p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd.Effective_Date
         AND    Auth_Status = p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd.Auth_Stat
         AND    Active_Status = p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd.Active_Status;

      CURSOR c_v_Account_Comp__Chg_Amnd IS
         SELECT *
         FROM   Cltb_Account_Components_Amnd
         WHERE  Account_Number = p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd.Account_Number
         AND    Branch_Code = p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd.Branch_Code
         AND    Effective_Date = p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd.Effective_Date
         AND    Auth_Status = p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd.Auth_Stat
         AND    Active_Status = p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd.Active_Status
         AND    Component_Type IN ('H', 'O');
      CURSOR c_v_Account_Sch__Chg_Amnd IS
         SELECT *
         FROM   Cltb_Account_Schedules_Amnd
         WHERE  Account_Number = p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd.Account_Number
         AND    Branch_Code = p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd.Branch_Code
         AND    Effective_Date = p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd.Effective_Date
         AND    Auth_Status = p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd.Auth_Stat
         AND    Active_Status = p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd.Active_Status;

      --Log#1 Changes start
      CURSOR c_v_Cltbs_Emi_Chg_Amnd IS
         SELECT *
         FROM   Cltb_Account_Emi_Chg_Amnd
         WHERE  Account_Number = p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd.Account_Number
         AND    Branch_Code = p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd.Branch_Code
         AND    Amnd_Eff_Date = p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd.Effective_Date
         AND    Auth_Status = p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd.Auth_Stat
         AND    Active_Status = p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd.Active_Status;
      --Log#1 Changes ends

      CURSOR c_v_Clvss_Charge_Amnd IS
         SELECT DISTINCT a.* --temp fix
         FROM   Clvs_Account_Charge a
         WHERE  a.Account_Number = p_Wrk_Cldaccvm.v_Cltbs_Account_Master.Account_Number
         AND    a.Branch_Code = p_Wrk_Cldaccvm.v_Cltbs_Account_Master.Branch_Code;
      CURSOR c_v_Acc_Comp_Bal_Amnd IS
         SELECT a.*
         FROM   Clvs_Account_Comp_Balances a
         WHERE  a.Account_Number = p_Wrk_Cldaccvm.v_Cltbs_Account_Master.Account_Number
         AND    a.Branch_Code = p_Wrk_Cldaccvm.v_Cltbs_Account_Master.Branch_Code;
      CURSOR c_v_Cltbs_Irr_Amnd IS
         SELECT a.*
         FROM   Cltb_Account_Irr a
         WHERE  a.Account_Number = p_Wrk_Cldaccvm.v_Cltbs_Account_Master.Account_Number
         AND    a.Branch_Code = p_Wrk_Cldaccvm.v_Cltbs_Account_Master.Branch_Code;
      --Log#3 7-Apr-10 FCUBS11.1 Mb0403 start
      CURSOR c_v_Acc_Guarantor_Customer IS
         SELECT *
         FROM   Cltb_Acc_Gua_Customer_Amnd
         WHERE  Account_Number = p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd.Account_Number
         AND    Branch_Code = p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd.Branch_Code;
      CURSOR c_v_Acc_Guarantor_Accounts IS
         SELECT *
         FROM   Cltb_Acc_Gua_Accounts_Amnd
         WHERE  Branch_Code = p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd.Branch_Code
         AND    Account_Number = p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd.Account_Number;
      l_Bnd_Cntr_44 NUMBER := 0;
      --Log#3 7-Apr-10 FCUBS11.1 Mb0403 end

      j                NUMBER := 0;
      k                NUMBER := 0;
      l_Cldaccvm_Amend Ty_Cldaccvm_Amend;
      l_Key            VARCHAR2(4000);
      l_Ui_Name        VARCHAR2(4000) := 'CLDACCVM';
   BEGIN
      Dbg('In Fn_Query_amend');

      l_Key := Cspks_Req_Utils.Fn_Get_Item_Desc(p_Source, l_Ui_Name, 'CLTBS_ACCOUNT_MASTER.ACCOUNT_NUMBER') || '-' ||
               p_Cldaccvm.v_Cltbs_Account_Master.Account_Number || ':' ||
               Cspks_Req_Utils.Fn_Get_Item_Desc(p_Source, l_Ui_Name, 'CLTBS_ACCOUNT_MASTER.BRANCH_CODE') || '-' ||
               p_Cldaccvm.v_Cltbs_Account_Master.Branch_Code;
      Dbg('Came here with ESN >>>' || p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd.Vamb_Esn);
      BEGIN
         SELECT *
         INTO   p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd
         FROM   Cltbs_Account_Vamd
         WHERE  Account_Number = p_Wrk_Cldaccvm.v_Cltbs_Account_Master.Account_Number
         AND    Branch_Code = p_Wrk_Cldaccvm.v_Cltbs_Account_Master.Branch_Code
         AND    Vamb_Esn = p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd.Vamb_Esn;
      EXCEPTION
         WHEN No_Data_Found THEN
            p_Err_Code   := 'ST-VALS-002';
            p_Err_Params := l_Key;
            RETURN FALSE;
            Dbg('Record Not Found..');
            RETURN FALSE;
      END;

      BEGIN
         SELECT *
         INTO   l_Cldaccvm_Amend.v_Cltbs_Account_Master_Amnd
         FROM   Cltb_Account_Master_Amnd
         WHERE  Account_Number = p_Wrk_Cldaccvm.v_Cltbs_Account_Master.Account_Number
         AND    Branch_Code = p_Wrk_Cldaccvm.v_Cltbs_Account_Master.Branch_Code
         AND    Effective_Date = p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd.Effective_Date
         AND    Auth_Status = p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd.Auth_Stat
         AND    Active_Status = p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd.Active_Status;
      EXCEPTION
         WHEN No_Data_Found THEN
            Dbg('Failed in Selecting The Master Recotrd..');
            Dbg('Record Does not Exist..');

            IF p_Action_Code IN (Cspks_Req_Global.p_Delete) THEN
               Dbg('Record has been deleted in the process ');
               RETURN TRUE;
            END IF;
            p_Err_Code   := 'ST-VALS-002';
            p_Err_Params := l_Key;
            RETURN FALSE;
      END;

      Dbg('EFFDT >>' || p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd.Effective_Date);
      Dbg('auth_stat >>' || p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd.Auth_Stat);
      Dbg('active_status >>' || p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd.Active_Status);

      /*
         Dbg('Selecting for cltb_account_vamd');
         IF p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd.Vamb_Esn IS NOT NULL THEN
            Dbg('VAMB_ESN IS THERE ::' || p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd.Vamb_Esn);
            SELECT *
            INTO   p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd
            FROM   Cltbs_Account_Vamd
            WHERE  Account_Number = p_Wrk_Cldaccvm.v_Cltbs_Account_Master.Account_Number
            AND    Branch_Code = p_Wrk_Cldaccvm.v_Cltbs_Account_Master.Branch_Code
            AND    Vamb_Esn = p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd.Vamb_Esn;
         ELSE
            Dbg('Selecting Max ESN');
            SELECT a.*
            INTO   p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd
            FROM   Cltbs_Account_Vamd a
            WHERE  Account_Number = p_Wrk_Cldaccvm.v_Cltbs_Account_Master.Account_Number
            AND    Branch_Code = p_Wrk_Cldaccvm.v_Cltbs_Account_Master.Branch_Code
            AND    Amend_Applied = 'N'
            AND    Vamb_Esn = (SELECT MAX(Vamb_Esn)
                               FROM   Cltb_Account_Vamd
                               WHERE  Account_Number = a.Account_Number
                               AND    Branch_Code = a.Branch_Code
                               AND    Effective_Date = a.Effective_Date
                               AND    Amend_Applied = 'N')
            ORDER  BY a.Effective_Date;
         END IF;

      */
      Dbg('Get Record for :CLTBS_ACCOUNT_VAMD_UNAPP');
      OPEN c_v_Cltbs_Account_Vamd;
      LOOP
         FETCH c_v_Cltbs_Account_Vamd BULK COLLECT
            INTO p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd__Unapp;
         EXIT WHEN c_v_Cltbs_Account_Vamd%NOTFOUND;
      END LOOP;
      CLOSE c_v_Cltbs_Account_Vamd;
      Dbg('UNAPPLIED AMND COUNT >>' || p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd__Unapp.COUNT);
      Dbg('Get the Record For :CLTBS_ACCOUNT_PARTIES');
      OPEN c_v_Cltbs_Parties_Amnd;
      LOOP
         FETCH c_v_Cltbs_Parties_Amnd BULK COLLECT
            INTO l_Cldaccvm_Amend.v_Cltbs_Ac_Parties_Amnd;
         EXIT WHEN c_v_Cltbs_Parties_Amnd%NOTFOUND;
      END LOOP;
      CLOSE c_v_Cltbs_Parties_Amnd;
      Dbg('Get the Record For :CLTBS_ACCOUNT_HOL_PERDS');
      OPEN c_v_Cltbs_Hol_Perds_Amnd;
      LOOP
         FETCH c_v_Cltbs_Hol_Perds_Amnd BULK COLLECT
            INTO l_Cldaccvm_Amend.v_Cltbs_Ac_Hol_Perds_Amnd;
         EXIT WHEN c_v_Cltbs_Hol_Perds_Amnd%NOTFOUND;
      END LOOP;
      CLOSE c_v_Cltbs_Hol_Perds_Amnd;
      Dbg('Get the Record For :CLTBS_ACCOUNT_UDE_EFF_DATES');
      OPEN c_v_Ude_Eff_Dates_Amnd;
      LOOP
         FETCH c_v_Ude_Eff_Dates_Amnd BULK COLLECT
            INTO l_Cldaccvm_Amend.v_Ac_Ude_Eff_Dates_Amnd;
         EXIT WHEN c_v_Ude_Eff_Dates_Amnd%NOTFOUND;
      END LOOP;
      CLOSE c_v_Ude_Eff_Dates_Amnd;
      Dbg('Get the Record For :CLTBS_ACCOUNT_UDE_VALUES');
      OPEN c_v_Cltbs_Ude_Values_Amnd;
      LOOP
         FETCH c_v_Cltbs_Ude_Values_Amnd BULK COLLECT
            INTO l_Cldaccvm_Amend.v_Cltbs_Ac_Ude_Values_Amnd;
         EXIT WHEN c_v_Cltbs_Ude_Values_Amnd%NOTFOUND;
      END LOOP;
      CLOSE c_v_Cltbs_Ude_Values_Amnd;
      Dbg('Get the Record For :CLTBS_ACCOUNT_ROLL_COMP');
      OPEN c_v_Cltbs_Roll_Comp_Amnd;
      LOOP
         FETCH c_v_Cltbs_Roll_Comp_Amnd BULK COLLECT
            INTO l_Cldaccvm_Amend.v_Cltbs_Ac_Roll_Comp_Amnd;
         EXIT WHEN c_v_Cltbs_Roll_Comp_Amnd%NOTFOUND;
      END LOOP;
      CLOSE c_v_Cltbs_Roll_Comp_Amnd;
      Dbg('Get the Record For :CLTBS_RATE_PLAN_EFF_DATES');
      OPEN c_v_Cltbs_Rtplan_Effdt_Amnd;
      LOOP
         FETCH c_v_Cltbs_Rtplan_Effdt_Amnd BULK COLLECT
            INTO l_Cldaccvm_Amend.v_Cltbs_Rt_Plan_Effdt_Amnd;
         EXIT WHEN c_v_Cltbs_Rtplan_Effdt_Amnd%NOTFOUND;
      END LOOP;
      CLOSE c_v_Cltbs_Rtplan_Effdt_Amnd;
      Dbg('Get the Record For :CLTBS_EVENT_CHECK_LIST');
      OPEN c_v_Cltbs_Check_List_Amnd;
      LOOP
         FETCH c_v_Cltbs_Check_List_Amnd BULK COLLECT
            INTO l_Cldaccvm_Amend.v_Cltbs_Checklist_Amnd;
         EXIT WHEN c_v_Cltbs_Check_List_Amnd%NOTFOUND;
      END LOOP;
      CLOSE c_v_Cltbs_Check_List_Amnd;
      Dbg('Get the Record For :CLTBS_EVENT_REMARKS');
      BEGIN
         SELECT *
         INTO   l_Cldaccvm_Amend.v_Cltbs_Remarks_Amnd
         FROM   Cltb_Event_Remarks
         WHERE  Account_Number = p_Wrk_Cldaccvm.v_Cltbs_Account_Master.Account_Number
         AND    Branch_Code = p_Wrk_Cldaccvm.v_Cltbs_Account_Master.Branch_Code;
      EXCEPTION
         WHEN OTHERS THEN
            Dbg(SQLERRM);
            Dbg('Failed in Selecting The Record For :CLTBS_EVENT_REMARKS');
      END;
      Dbg('Get the Record For :CLTBS_ACCOUNT_COMPONENTS__CMP');
      OPEN c_v_Account_Comp__Cmp_Amnd;
      LOOP
         FETCH c_v_Account_Comp__Cmp_Amnd BULK COLLECT
            INTO l_Cldaccvm_Amend.v_Ac_Components__Cmp_Amnd;
         EXIT WHEN c_v_Account_Comp__Cmp_Amnd%NOTFOUND;
      END LOOP;
      CLOSE c_v_Account_Comp__Cmp_Amnd;
      Dbg('Get the Record For :CLTBS_ACCOUNT_COMP_SCH');
      OPEN c_v_Cltbs_Comp_Sch_Amnd;
      LOOP
         FETCH c_v_Cltbs_Comp_Sch_Amnd BULK COLLECT
            INTO l_Cldaccvm_Amend.v_Cltbs_Ac_Comp_Sch_Amnd;
         EXIT WHEN c_v_Cltbs_Comp_Sch_Amnd%NOTFOUND;
      END LOOP;
      CLOSE c_v_Cltbs_Comp_Sch_Amnd;
      Dbg('Get the Record For :CLTBS_ACCOUNT_SCHEDULES__CMP');
      OPEN c_v_Account_Sch__Cmp_Amnd;
      LOOP
         FETCH c_v_Account_Sch__Cmp_Amnd BULK COLLECT
            INTO l_Cldaccvm_Amend.v_Ac_Schedules__Cmp_Amnd;
         EXIT WHEN c_v_Account_Sch__Cmp_Amnd%NOTFOUND;
      END LOOP;
      CLOSE c_v_Account_Sch__Cmp_Amnd;

      Dbg('Assigning for Amort Principal');
      Dbg('Count here ' || l_Cldaccvm_Amend.v_Ac_Schedules__Cmp_Amnd.COUNT);
      IF l_Cldaccvm_Amend.v_Ac_Schedules__Cmp_Amnd.COUNT > 0 THEN
         FOR i IN l_Cldaccvm_Amend.v_Ac_Schedules__Cmp_Amnd.FIRST .. l_Cldaccvm_Amend.v_Ac_Schedules__Cmp_Amnd.LAST LOOP
            j := j + 1;
            p_Wrk_Cldaccvm.v_Cstbs_Ui_Columns__Sch(j).Char_Field1 := l_Cldaccvm_Amend.v_Ac_Schedules__Cmp_Amnd(i).Account_Number;
            p_Wrk_Cldaccvm.v_Cstbs_Ui_Columns__Sch(j).Char_Field2 := l_Cldaccvm_Amend.v_Ac_Schedules__Cmp_Amnd(i).Branch_Code;
            p_Wrk_Cldaccvm.v_Cstbs_Ui_Columns__Sch(j).Char_Field3 := l_Cldaccvm_Amend.v_Ac_Schedules__Cmp_Amnd(i).Component_Name;
            p_Wrk_Cldaccvm.v_Cstbs_Ui_Columns__Sch(j).Date_Field1 := l_Cldaccvm_Amend.v_Ac_Schedules__Cmp_Amnd(i).Schedule_Due_Date;
            p_Wrk_Cldaccvm.v_Cstbs_Ui_Columns__Sch(j).Date_Field2 := l_Cldaccvm_Amend.v_Ac_Schedules__Cmp_Amnd(i).Schedule_St_Date;
            p_Wrk_Cldaccvm.v_Cstbs_Ui_Columns__Sch(j).Num_Field1 := l_Cldaccvm_Amend.v_Ac_Schedules__Cmp_Amnd(i).Event_Seq_No;
            IF l_Cldaccvm_Amend.v_Ac_Schedules__Cmp_Amnd(i).Component_Name = Pkg_Main_Int THEN
               IF l_Cldaccvm_Amend.v_Ac_Schedules__Cmp_Amnd(i).Emi_Amount IS NOT NULL THEN
                  l_Cldaccvm_Amend.v_Cstbs_Ui_Columns__Sch(j).Char_Field4 := l_Cldaccvm_Amend.v_Ac_Schedules__Cmp_Amnd(i)
                                                                            .Emi_Amount - l_Cldaccvm_Amend.v_Ac_Schedules__Cmp_Amnd(i).Amount_Due;
               END IF;
            ELSIF l_Cldaccvm_Amend.v_Ac_Schedules__Cmp_Amnd(i).Component_Name = Pkg_Principal THEN
               BEGIN
                  SELECT Balance
                  INTO   p_Wrk_Cldaccvm.v_Cstbs_Ui_Columns__Sch(j) .Char_Field4
                  FROM   Cltbs_Account_Comp_Balances b
                  WHERE  b.Account_Number = l_Cldaccvm_Amend.v_Ac_Schedules__Cmp_Amnd(i).Account_Number
                  AND    b.Branch_Code = l_Cldaccvm_Amend.v_Ac_Schedules__Cmp_Amnd(i).Branch_Code
                  AND    b.Component_Name = Pkg_Principal || '_EXPECTED'
                  AND    b.Val_Date = l_Cldaccvm_Amend.v_Ac_Schedules__Cmp_Amnd(i).Schedule_Due_Date;
               EXCEPTION
                  WHEN OTHERS THEN
                     Dbg('gone' || SQLERRM);
                     NULL;
               END;
            END IF;
            Dbg('value' || p_Wrk_Cldaccvm.v_Cstbs_Ui_Columns__Sch(j).Char_Field4);
         END LOOP;
      END IF;

      Dbg('Get the Record For :CLTBS_ACCOUNT_LINKAGES');
      OPEN c_v_Cltbs_Linkages_Amnd;
      LOOP
         FETCH c_v_Cltbs_Linkages_Amnd BULK COLLECT
            INTO l_Cldaccvm_Amend.v_Cltbs_Ac_Linkages_Amnd;
         EXIT WHEN c_v_Cltbs_Linkages_Amnd%NOTFOUND;
      END LOOP;
      CLOSE c_v_Cltbs_Linkages_Amnd;
      Dbg('Get the Record For :CLTBS_ACCOUNT_EVENTS_ADVICES');
      OPEN c_v_Account_Advices_Amnd;
      LOOP
         FETCH c_v_Account_Advices_Amnd BULK COLLECT
            INTO l_Cldaccvm_Amend.v_Ac_Events_Advices_Amnd;
         EXIT WHEN c_v_Account_Advices_Amnd%NOTFOUND;
      END LOOP;
      CLOSE c_v_Account_Advices_Amnd;
      Dbg('Get the Record For :CLTBS_ACCOUNT_ADVICE_SUPPRESS');
      OPEN c_v_Advice_Suppress_Amnd;
      LOOP
         FETCH c_v_Advice_Suppress_Amnd BULK COLLECT
            INTO l_Cldaccvm_Amend.v_Ac_Advice_Suppress_Amnd;
         EXIT WHEN c_v_Advice_Suppress_Amnd%NOTFOUND;
      END LOOP;
      CLOSE c_v_Advice_Suppress_Amnd;
      Dbg('Get the Record For :CLTBS_ACCOUNT_CREDIT_SCORE');
      BEGIN
         SELECT *
         INTO   l_Cldaccvm_Amend.v_Ac_Credit_Score_Amnd
         FROM   Cltb_Credit_Score_Amnd
         WHERE  Account_Number = p_Wrk_Cldaccvm.v_Cltbs_Account_Master.Account_Number
         AND    Branch_Code = p_Wrk_Cldaccvm.v_Cltbs_Account_Master.Branch_Code;
      EXCEPTION
         WHEN OTHERS THEN
            Dbg(SQLERRM);
            Dbg('Failed in Selecting The Record For :CLTBS_ACCOUNT_CREDIT_SCORE');
      END;
      Dbg('Get the Record For :CLTBS_ACCOUNT_ASSET_VEHICLE');
      BEGIN
         SELECT *
         INTO   l_Cldaccvm_Amend.v_Ac_Asset_Vehicle_Amnd
         FROM   Cltb_Asset_Vehicle_Amnd
         WHERE  Account_Number = p_Wrk_Cldaccvm.v_Cltbs_Account_Master.Account_Number
         AND    Branch_Code = p_Wrk_Cldaccvm.v_Cltbs_Account_Master.Branch_Code;
      EXCEPTION
         WHEN OTHERS THEN
            Dbg(SQLERRM);
            Dbg('Failed in Selecting The Record For :CLTBS_ACCOUNT_ASSET_VEHICLE');
      END;
      Dbg('Get the Record For :CLTBS_ACCOUNT_ASSET_HOME');
      BEGIN
         SELECT *
         INTO   l_Cldaccvm_Amend.v_Cltbs_Ac_Asset_Home_Amnd
         FROM   Cltb_Asset_Home_Amnd
         WHERE  Account_Number = p_Wrk_Cldaccvm.v_Cltbs_Account_Master.Account_Number
         AND    Branch_Code = p_Wrk_Cldaccvm.v_Cltbs_Account_Master.Branch_Code;
      EXCEPTION
         WHEN OTHERS THEN
            Dbg(SQLERRM);
            Dbg('Failed in Selecting The Record For :CLTBS_ACCOUNT_ASSET_HOME');
      END;
      Dbg('Get the Record For :CLTBS_ACCOUNT_ASSET_OTHERS');
      BEGIN
         SELECT *
         INTO   l_Cldaccvm_Amend.v_Ac_Asset_Others_Amnd
         FROM   Cltb_Asset_Others_Amnd
         WHERE  Account_Number = p_Wrk_Cldaccvm.v_Cltbs_Account_Master.Account_Number
         AND    Branch_Code = p_Wrk_Cldaccvm.v_Cltbs_Account_Master.Branch_Code;
      EXCEPTION
         WHEN OTHERS THEN
            Dbg(SQLERRM);
            Dbg('Failed in Selecting The Record For :CLTBS_ACCOUNT_ASSET_OTHERS');
      END;
      Dbg('Get the Record For :CLTBS_ACCOUNT_PROPERTY');
      BEGIN
         SELECT *
         INTO   l_Cldaccvm_Amend.v_Cltbs_Ac_Property_Amnd
         FROM   Cltb_Account_Property_Amnd
         WHERE  Account_Number = p_Wrk_Cldaccvm.v_Cltbs_Account_Master.Account_Number
         AND    Branch_Code = p_Wrk_Cldaccvm.v_Cltbs_Account_Master.Branch_Code;
      EXCEPTION
         WHEN OTHERS THEN
            Dbg(SQLERRM);
            Dbg('Failed in Selecting The Record For :CLTBS_ACCOUNT_PROPERTY');
      END;
      Dbg('Get the Record For :CLTBS_ACCOUNT_ASSET_VALUATIONS');
      OPEN c_v_Asset_Valuations_Amnd;
      LOOP
         FETCH c_v_Asset_Valuations_Amnd BULK COLLECT
            INTO l_Cldaccvm_Amend.v_Ac_Asset_Valuations_Amnd;
         EXIT WHEN c_v_Asset_Valuations_Amnd%NOTFOUND;
      END LOOP;
      CLOSE c_v_Asset_Valuations_Amnd;
      Dbg('Get the Record For :CLTBS_ACCOUNT_FINANCIALS');
      OPEN c_v_Cltbs_Financials_Amnd;
      LOOP
         FETCH c_v_Cltbs_Financials_Amnd BULK COLLECT
            INTO l_Cldaccvm_Amend.v_Cltbs_Ac_Financials_Amnd;
         EXIT WHEN c_v_Cltbs_Financials_Amnd%NOTFOUND;
      END LOOP;
      CLOSE c_v_Cltbs_Financials_Amnd;
      Dbg('Get the Record For :CLTBS_ACCOUNT_LIABILITIES');
      OPEN c_v_Cltbs_Liabilities_Amnd;
      LOOP
         FETCH c_v_Cltbs_Liabilities_Amnd BULK COLLECT
            INTO l_Cldaccvm_Amend.v_Cltbs_Ac_Liabilities_Amnd;
         EXIT WHEN c_v_Cltbs_Liabilities_Amnd%NOTFOUND;
      END LOOP;
      CLOSE c_v_Cltbs_Liabilities_Amnd;
      Dbg('Get the Record For :CLTBS_ACCOUNT_OTHER_INCOME');
      OPEN c_v_Other_Income_Amnd;
      LOOP
         FETCH c_v_Other_Income_Amnd BULK COLLECT
            INTO l_Cldaccvm_Amend.v_Ac_Other_Income_Amnd;
         EXIT WHEN c_v_Other_Income_Amnd%NOTFOUND;
      END LOOP;
      CLOSE c_v_Other_Income_Amnd;
      Dbg('Get the Record For :CLTBS_DISBR_SCHEDULES');
      OPEN c_v_Cltbs_Disbr_Sch_Amnd;
      LOOP
         FETCH c_v_Cltbs_Disbr_Sch_Amnd BULK COLLECT
            INTO l_Cldaccvm_Amend.v_Cltbs_Disbr_Sch_Amnd;
         EXIT WHEN c_v_Cltbs_Disbr_Sch_Amnd%NOTFOUND;
      END LOOP;
      CLOSE c_v_Cltbs_Disbr_Sch_Amnd;
      Dbg('Get the Record For :CLTBS_REVN_SCHEDULES');
      OPEN c_v_Cltbs_Revn_Sch_Amnd;
      LOOP
         FETCH c_v_Cltbs_Revn_Sch_Amnd BULK COLLECT
            INTO l_Cldaccvm_Amend.v_Cltbs_Revn_Sch_Amnd;
         EXIT WHEN c_v_Cltbs_Revn_Sch_Amnd%NOTFOUND;
      END LOOP;
      CLOSE c_v_Cltbs_Revn_Sch_Amnd;
      Dbg('Get the Record For :CLTBS_ACCOUNT_COMPONENTS__CHG');
      OPEN c_v_Account_Comp__Chg_Amnd;
      LOOP
         FETCH c_v_Account_Comp__Chg_Amnd BULK COLLECT
            INTO l_Cldaccvm_Amend.v_Ac_Components__Chg_Amnd;
         EXIT WHEN c_v_Account_Comp__Chg_Amnd%NOTFOUND;
      END LOOP;
      IF p_Wrk_Cldaccvm.v_Account_Components__Chg.COUNT > 0 THEN
         FOR i IN p_Wrk_Cldaccvm.v_Account_Components__Chg.FIRST .. p_Wrk_Cldaccvm.v_Account_Components__Chg.LAST LOOP
            k := k + 1;
            p_Wrk_Cldaccvm.v_Cstbs_Ui_Columns__Chg(k).Char_Field1 := p_Wrk_Cldaccvm.v_Cltbs_Account_Master.Account_Number;
            p_Wrk_Cldaccvm.v_Cstbs_Ui_Columns__Chg(k).Char_Field2 := p_Wrk_Cldaccvm.v_Cltbs_Account_Master.Branch_Code;
            p_Wrk_Cldaccvm.v_Cstbs_Ui_Columns__Chg(k).Char_Field3 := l_Cldaccvm_Amend.v_Ac_Components__Chg_Amnd(i).Component_Name;
            p_Wrk_Cldaccvm.v_Cstbs_Ui_Columns__Chg(k).Date_Field1 := p_Wrk_Cldaccvm.v_Cltbs_Account_Master.Value_Date;
         END LOOP;
      END IF;

      CLOSE c_v_Account_Comp__Chg_Amnd;
      Dbg('Get the Record For :CLTBS_ACCOUNT_SCHEDULES__CHG');
      OPEN c_v_Account_Sch__Chg_Amnd;
      LOOP
         FETCH c_v_Account_Sch__Chg_Amnd BULK COLLECT
            INTO l_Cldaccvm_Amend.v_Ac_Schedules__Chg_Amnd;
         EXIT WHEN c_v_Account_Sch__Chg_Amnd%NOTFOUND;
      END LOOP;
      CLOSE c_v_Account_Sch__Chg_Amnd;
      Dbg('Get the Record For :CLVSS_ACCOUNT_CHARGE');
      OPEN c_v_Clvss_Charge_Amnd;
      LOOP
         FETCH c_v_Clvss_Charge_Amnd BULK COLLECT
            INTO p_Wrk_Cldaccvm.v_Clvss_Account_Charge;
         EXIT WHEN c_v_Clvss_Charge_Amnd%NOTFOUND;
      END LOOP;
      CLOSE c_v_Clvss_Charge_Amnd;
      Dbg('Get the Record For :CLVSS_ACCOUNT_COMP_BALANCES');
      OPEN c_v_Acc_Comp_Bal_Amnd;
      LOOP
         FETCH c_v_Acc_Comp_Bal_Amnd BULK COLLECT
            INTO p_Wrk_Cldaccvm.v_Account_Comp_Balances;
         EXIT WHEN c_v_Acc_Comp_Bal_Amnd%NOTFOUND;
      END LOOP;
      CLOSE c_v_Acc_Comp_Bal_Amnd;
      Dbg('Get the Record For :CLTBS_ACCOUNT_IRR');
      OPEN c_v_Cltbs_Irr_Amnd;
      LOOP
         FETCH c_v_Cltbs_Irr_Amnd BULK COLLECT
            INTO l_Cldaccvm_Amend.v_Cltbs_Ac_Irr_Amnd;
         EXIT WHEN c_v_Cltbs_Irr_Amnd%NOTFOUND;
      END LOOP;
      CLOSE c_v_Cltbs_Irr_Amnd;

      --Log#1 Changes starts
      Dbg('Get the Record For :CLTBS_ACCOUNT_EMI_CHG');
      OPEN c_v_Cltbs_Emi_Chg_Amnd;
      LOOP
         FETCH c_v_Cltbs_Emi_Chg_Amnd BULK COLLECT
            INTO l_Cldaccvm_Amend.v_Cltbs_Ac_Emi_Chg_Amnd;
         EXIT WHEN c_v_Cltbs_Emi_Chg_Amnd%NOTFOUND;
      END LOOP;
      CLOSE c_v_Cltbs_Emi_Chg_Amnd;
      --Log#1 Changes ends

      --Log#3 7-Apr-10 FCUBS11.1 MB0403 start
      Dbg('Get the Record For :CLTBS_ACC_GUARANTOR_CUSTOMER');
	  --11.1 itr1 sfr 5078 -starts
	  FOR each_rec in (
       SELECT *
         FROM   Cltb_Acc_Gua_Customer_Amnd
         WHERE  Account_Number = p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd.Account_Number
         AND    Branch_Code = p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd.Branch_Code) LOOP
      DBG('Cltb_Acc_Gua_Customer_Amnd inside loop'||each_rec.account_number);
	  dbg('vami logic to be added');
      END LOOP;
      Dbg('Get the Record For :CLTBS_ACC_GUARANTOR_ACCOUNTS');
      FOR each_rec1 in (
       SELECT *
         FROM   Cltb_Acc_Gua_Accounts_Amnd
         WHERE  Branch_Code = p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd.Branch_Code
         AND    Account_Number = p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd.Account_Number) LOOP
       DBG('Cltb_Acc_Gua_Accounts_Amnd loop'||each_rec1.account_number);
       dbg('vami logic to be added');
       END LOOP;
     /* OPEN c_v_Acc_Guarantor_Customer;
      LOOP
         FETCH c_v_Acc_Guarantor_Customer BULK COLLECT
            INTO l_Cldaccvm_Amend.v_Acc_Guarantor_Cust_Amnd;
         EXIT WHEN c_v_Acc_Guarantor_Customer%NOTFOUND;
      END LOOP;
      CLOSE c_v_Acc_Guarantor_Customer;
      Dbg('Get the Record For :CLTBS_ACC_GUARANTOR_ACCOUNTS');
      OPEN c_v_Acc_Guarantor_Accounts;
      LOOP
         FETCH c_v_Acc_Guarantor_Accounts BULK COLLECT
            INTO l_Cldaccvm_Amend.v_Acc_Guarantor_Acc_Amnd;
         EXIT WHEN c_v_Acc_Guarantor_Accounts%NOTFOUND;
      END LOOP;
      CLOSE c_v_Acc_Guarantor_Accounts; */
	  --11.1 itr1 sfr 5078 -ends


      IF l_Cldaccvm_Amend.v_Acc_Guarantor_Cust_Amnd.COUNT > 0 THEN
         FOR i_44 IN 1 .. l_Cldaccvm_Amend.v_Acc_Guarantor_Cust_Amnd.COUNT LOOP
            BEGIN
               SELECT Customer_Name1
               INTO   p_Wrk_Cldaccvm.Desc_Fields('CLTBS_ACC_GUARANTOR_CUSTOMER')(i_44)('TXT_CUSTNAME')
               FROM   (SELECT Customer_No, Customer_Name1
                        FROM   Sttm_Customer
                        ORDER  BY Customer_No)
               WHERE  Customer_No = p_Wrk_Cldaccvm.v_Acc_Guarantor_Customer(i_44).Guarantor_Cif
               AND    Rownum < 2;
            EXCEPTION
               WHEN OTHERS THEN
                  p_Wrk_Cldaccvm.Desc_Fields('CLTBS_ACC_GUARANTOR_CUSTOMER')(i_44)('TXT_CUSTNAME') := NULL;
                  Dbg(SQLERRM);
                  Dbg('Failed in selecting the Desc Fields For  :CUSTNO ' || p_Wrk_Cldaccvm.v_Acc_Guarantor_Customer(i_44).Guarantor_Cif);
            END;
         END LOOP;
      END IF;
      IF l_Cldaccvm_Amend.v_Acc_Guarantor_Acc_Amnd.COUNT > 0 THEN
         FOR i_45 IN 1 .. l_Cldaccvm_Amend.v_Acc_Guarantor_Acc_Amnd.COUNT LOOP
            l_Bnd_Cntr_44 := 0;
            IF l_Cldaccvm_Amend.v_Acc_Guarantor_Cust_Amnd.COUNT > 0 THEN
               FOR i_44 IN 1 .. p_Wrk_Cldaccvm.v_Acc_Guarantor_Customer.COUNT LOOP
                  IF Nvl(l_Cldaccvm_Amend.v_Acc_Guarantor_Acc_Amnd(i_45).Branch_Code, '@') =
                     Nvl(l_Cldaccvm_Amend.v_Acc_Guarantor_Cust_Amnd(i_44).Branch_Code, '@') AND
                     Nvl(l_Cldaccvm_Amend.v_Acc_Guarantor_Acc_Amnd(i_45).Account_Number, '@') =
                     Nvl(l_Cldaccvm_Amend.v_Acc_Guarantor_Cust_Amnd(i_44).Account_Number, '@') AND
                     Nvl(l_Cldaccvm_Amend.v_Acc_Guarantor_Acc_Amnd(i_45).Component_Name, '@') =
                     Nvl(l_Cldaccvm_Amend.v_Acc_Guarantor_Cust_Amnd(i_44).Component_Name, '@') AND
                     Nvl(l_Cldaccvm_Amend.v_Acc_Guarantor_Acc_Amnd(i_45).Guarantor_Cif, '@') =
                     Nvl(l_Cldaccvm_Amend.v_Acc_Guarantor_Cust_Amnd(i_44).Guarantor_Cif, '@') THEN
                     l_Bnd_Cntr_44 := i_44;
                     EXIT;
                  END IF;
               END LOOP;
            END IF;
            IF l_Bnd_Cntr_44 > 0 THEN
               BEGIN
                  SELECT Currency
                  INTO   p_Wrk_Cldaccvm.Desc_Fields('CLTBS_ACC_GUARANTOR_ACCOUNTS')(i_45)('GUAACCCY')
                  FROM   (SELECT Account_No, Branch_Code, Currency
                           FROM   Stvws_Account
                           WHERE  Ac_Or_Gl = 'A'
                           AND    Record_Stat = 'O'
                           AND    Customer_No = p_Wrk_Cldaccvm.v_Acc_Guarantor_Customer(l_Bnd_Cntr_44).Guarantor_Cif)
                  WHERE  Account_No = p_Wrk_Cldaccvm.v_Acc_Guarantor_Accounts(i_45).Guarantor_Acc
                  AND    Rownum < 2;
               EXCEPTION
                  WHEN OTHERS THEN
                     p_Wrk_Cldaccvm.Desc_Fields('CLTBS_ACC_GUARANTOR_ACCOUNTS')(i_45)('GUAACCCY') := NULL;
                     Dbg(SQLERRM);
                     Dbg('Failed in selecting the Desc Fields For  :GUAACC');
               END;
            END IF;
         END LOOP;
      END IF;
      --Log#3 7-Apr-10 FCUBS11.1 MB0403 end
      --Log#12
       Dbg('Get the Record For :c_cltbs_account_statement'||p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd.Branch_Code);
      BEGIN
         SELECT *  INTO l_Cldaccvm_Amend.v_cltbs_account_statement
         FROM   CLTB_ACC_STMT_AMND
         WHERE  Branch_Code = p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd.Branch_Code
         AND    Account_Number = p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd.Account_Number;
         dbg('frequency '||l_Cldaccvm_Amend.v_cltbs_account_statement .frequency);
      EXCEPTION
         WHEN OTHERS THEN
            Dbg(SQLERRM);
            Dbg('Failed in Selecting The Record For :CLTBS_ACCOUNT_PROPERTY');
      END;
      --Log#12 ends
      Dbg('Calling Clpks_Cldaccvm_Typ_amnd.Fn_Build_Type');
      IF NOT Clpks_Cldaccvm_Typ_Amnd.Fn_Build_Type(p_Wrk_Cldaccvm, l_Cldaccvm_Amend, p_Err_Code, p_Err_Params) THEN
         Dbg('Failed in Clpks_Cldaccvm_Typ_amnd.Fn_Build_Type');
         RETURN FALSE;
      END IF;
      IF NOT Clpks_Cldaccvm_Utils_1.Fn_Query_Udf_Values(p_Wrk_Cldaccvm, p_Err_Code, p_Err_Params) THEN
         Dbg('Failed in call to clpkss_utils_2.fn_query_udf_values');
         Pr_Log_Error(p_Function_Id, p_Source, p_Err_Code, p_Err_Params);
         RETURN FALSE;
      END IF;

      RETURN TRUE;
      Dbg('Returning true from Fn_Query_amend');
   EXCEPTION
      WHEN OTHERS THEN
         Dbg('In when others in Fn_Query_amend ' || SQLERRM);
         Dbg(Dbms_Utility.Format_Error_Backtrace);
         p_Err_Code   := 'ST-OTHR-001';
         p_Err_Params := NULL;
         RETURN FALSE;
   END Fn_Query_Amend;

   FUNCTION Fn_Query(p_Source           IN VARCHAR2
                    ,p_Source_Operation IN VARCHAR2
                    ,p_Function_Id      IN VARCHAR2
                    ,p_Action_Code      IN VARCHAR2
                    ,p_With_Lock        IN VARCHAR2 DEFAULT 'N'
                    ,p_Qrydata_Reqd     IN VARCHAR2 DEFAULT 'Y'
                    ,p_Cldaccvm         IN Clpks_Cldaccvm_Main.Ty_Cldaccvm
                    ,p_Wrk_Cldaccvm     IN OUT Clpks_Cldaccvm_Main.Ty_Cldaccvm
                    ,p_Err_Code         IN OUT VARCHAR2
                    ,p_Err_Params       IN OUT VARCHAR2) RETURN BOOLEAN IS

      /*    CURSOR c_v_cstbs_ui_columns__sch IS
        SELECT *
        FROM   cstb_ui_columns
        WHERE  char_field1 = p_wrk_Cldaccvm.v_cltbs_account_master.account_number AND char_field2 = p_wrk_Cldaccvm.v_cltbs_account_master.branch_code;
      CURSOR c_v_cstbs_ui_columns__chg IS
        SELECT *
        FROM   cstb_ui_columns
        WHERE  char_field1 = p_wrk_Cldaccvm.v_cltbs_account_master.account_number AND char_field2 = p_wrk_Cldaccvm.v_cltbs_account_master.branch_code;*/

      Record_Locked EXCEPTION;
      PRAGMA EXCEPTION_INIT(Record_Locked, -54);
      l_Key              VARCHAR2(5000) := NULL;
      l_Key_Vals         VARCHAR2(5000) := NULL;
      l_Main_Function    VARCHAR2(5000) := p_Function_Id;
      l_Rec_Exists       BOOLEAN := TRUE;
      l_Account_Obj_Temp Cltbs_Account_Apps_Master%ROWTYPE;
      l_Special_Count    PLS_INTEGER;
      j                  NUMBER := 0;
      k                  NUMBER := 0;
      l_Auth_Count       NUMBER := 0;
      l_Fld              VARCHAR2(100);
      l_Ui_Name          VARCHAR2(100) := 'CLDACCVM';
      l_Auth_Stat        VARCHAR2(1);
      l_Count            NUMBER := 0;

      --Log#12 Starts
      /*
      CURSOR c_v_Acc_Stmt_Pref IS
         SELECT *
         FROM   Cltb_Account_Statement
         WHERE  Branch_Code = p_Wrk_Cldaccvm.v_Cltbs_Account_Master.Branch_Code AND Account_Number = p_Wrk_Cldaccvm.v_Cltbs_Account_Master.Account_Number;
      */--Log#12 Ends
   BEGIN
      Dbg('Inside Fn_Query ==' || p_Action_Code || ':' || p_Cldaccvm.v_Cltbs_Account_Master.Account_Number);

      l_Key := Cspks_Req_Utils.Fn_Get_Item_Desc(p_Source, l_Ui_Name, 'CLTBS_ACCOUNT_MASTER.ACCOUNT_NUMBER') || '-' ||
               p_Cldaccvm.v_Cltbs_Account_Master.Account_Number || ':' ||
               Cspks_Req_Utils.Fn_Get_Item_Desc(p_Source, l_Ui_Name, 'CLTBS_ACCOUNT_MASTER.BRANCH_CODE') || '-' ||
               p_Cldaccvm.v_Cltbs_Account_Master.Branch_Code;

      IF Nvl(p_With_Lock, 'N') = 'Y' THEN
         BEGIN
            SELECT *
            INTO   p_Wrk_Cldaccvm.v_Cltbs_Account_Master
            FROM   Cltb_Account_Master
            WHERE  Account_Number = p_Cldaccvm.v_Cltbs_Account_Master.Account_Number
            AND    Branch_Code = p_Cldaccvm.v_Cltbs_Account_Master.Branch_Code
            FOR    UPDATE NOWAIT;
         EXCEPTION
            WHEN Record_Locked THEN
               Dbg('Failed to Obtain the Lock..');
               Pr_Log_Error(p_Function_Id, p_Source, 'ST-LOCK-001', NULL);
               RETURN FALSE;
            WHEN No_Data_Found THEN
               Dbg('Failed in Selecting The Master Recotrd..');
               Dbg('Record Does not Exist..');
               l_Rec_Exists := FALSE;
         END;
      ELSE
         Dbg('For query it will come here');
         IF p_Action_Code IN (Cspks_Req_Global.p_Query, Cspks_Req_Global.p_Delete) THEN
            p_Wrk_Cldaccvm.v_Cltbs_Account_Master.Account_Number := p_Cldaccvm.v_Cltbs_Account_Master.Account_Number;
            p_Wrk_Cldaccvm.v_Cltbs_Account_Master.Branch_Code    := p_Cldaccvm.v_Cltbs_Account_Master.Branch_Code;
         END IF;

         BEGIN
            SELECT *
            INTO   p_Wrk_Cldaccvm.v_Cltbs_Account_Master
            FROM   Cltb_Account_Master
            WHERE  Account_Number = p_Wrk_Cldaccvm.v_Cltbs_Account_Master.Account_Number
            AND    Branch_Code = p_Wrk_Cldaccvm.v_Cltbs_Account_Master.Branch_Code -- 11.1 centralization changes --SFR#4522
            AND    Loan_type      = 'L'; --SFR#4522
         EXCEPTION
            WHEN No_Data_Found THEN
               Dbg('Failed in Selecting The Master Recotrd..');
               Dbg('Record Does not Exist..');

               IF p_Action_Code IN (Cspks_Req_Global.p_Delete) THEN
                  Dbg('Record has been deleted in the process ');
                  l_Rec_Exists := FALSE;
                  RETURN TRUE;
               END IF;
               p_Err_Code   := 'ST-VALS-002';
               p_Err_Params := l_Key;
               RETURN FALSE;
         END;
      END IF;

      /*IF Global.Current_Branch <> p_Wrk_Cldaccvm.v_Cltbs_Account_Master.Branch_Code THEN --11.1 centralization changes
         p_Err_Code   := 'IS-VLD018;';
         p_Err_Params := 'Invalid account number';
         Pr_Log_Error(p_Function_Id, p_Source, p_Err_Code, p_Err_Params);
         RETURN FALSE;
      END IF;*/

      IF p_Wrk_Cldaccvm.v_Cltbs_Account_Master.Account_Number IS NULL THEN
         Dbg('Function ID :- ' || p_Function_Id);
         IF p_Function_Id IN ('CLDACCDT', 'CLDACC') THEN
            BEGIN
               SELECT Account_Number
               INTO   p_Wrk_Cldaccvm.v_Cltbs_Account_Master.Account_Number
               FROM   Cltbs_Account_Master
               WHERE  Branch_Code = p_Wrk_Cldaccvm.v_Cltbs_Account_Master.Branch_Code
               AND    Module_Code = 'CL'
               AND    Rownum = 1;
            EXCEPTION
               WHEN OTHERS THEN
                  p_Err_Code   := 'IS-VLD018;';
                  p_Err_Params := 'Invalid account number';
                  Pr_Log_Error(p_Function_Id, p_Source, p_Err_Code, p_Err_Params);
                  RETURN FALSE;
            END;
         END IF;
      END IF;
      l_Special_Count := Instr(p_Wrk_Cldaccvm.v_Cltbs_Account_Master.Account_Number, '%');
      Dbg('l_special_count >>' || l_Special_Count);
      IF l_Special_Count > 0 THEN
         IF p_Function_Id IN ('CLDACC', 'CLDACCDT') THEN
            BEGIN
               SELECT Account_Number
               INTO   p_Wrk_Cldaccvm.v_Cltbs_Account_Master.Account_Number
               FROM   Cltbs_Account_Master
               WHERE  Branch_Code = p_Wrk_Cldaccvm.v_Cltbs_Account_Master.Branch_Code
               AND    Account_Number LIKE p_Wrk_Cldaccvm.v_Cltbs_Account_Master.Account_Number
               AND    Rownum = 1;
            EXCEPTION
               WHEN OTHERS THEN
                  p_Err_Code   := 'IS-VLD018;';
                  p_Err_Params := 'Invalid account number';
                  Pr_Log_Error(p_Function_Id, p_Source, p_Err_Code, p_Err_Params);
                  RETURN FALSE;
            END;
         END IF;
      END IF;
      SELECT Auth_Stat
      INTO   l_Auth_Stat
      FROM   Cltbs_Account_Master
      WHERE  Account_Number = p_Wrk_Cldaccvm.v_Cltbs_Account_Master.Account_Number
      AND    Branch_Code = p_Wrk_Cldaccvm.v_Cltbs_Account_Master.Branch_Code;

      IF l_Rec_Exists THEN
         Dbg('VAMB ESN IS PROVIDED 1>>' || p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd.Vamb_Esn);
         Dbg('VAMB ESN IS PROVIDED 2>>' || p_Cldaccvm.v_Cltbs_Account_Vamd.Vamb_Esn);
         IF p_Cldaccvm.v_Cltbs_Account_Vamd.Vamb_Esn IS NOT NULL THEN
            p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd.Vamb_Esn       := p_Cldaccvm.v_Cltbs_Account_Vamd.Vamb_Esn;
            p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd.Active_Status  := p_Cldaccvm.v_Cltbs_Account_Vamd.Active_Status;
            p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd.Auth_Stat      := p_Cldaccvm.v_Cltbs_Account_Vamd.Auth_Stat;
            p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd.Effective_Date := p_Cldaccvm.v_Cltbs_Account_Vamd.Effective_Date;
         END IF;
         IF p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd.Vamb_Esn IS NULL THEN
            Dbg('l_Auth_Stat >>' || l_Auth_Stat);
            IF l_Auth_Stat = 'A' THEN
               IF NOT Fn_Query_Master(p_Source, p_Source_Operation, p_Function_Id, p_Action_Code, p_Cldaccvm, p_Wrk_Cldaccvm, p_Err_Code, p_Err_Params) THEN
                  Dbg('Failed in Fn_Query_master');
                  Pr_Log_Error(p_Function_Id, p_Source, p_Err_Code, p_Err_Params);
                  RETURN FALSE;
               END IF;
            ELSIF l_Auth_Stat = 'U' THEN
               Dbg('p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd.Vamb_Esn >>' || p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd.Vamb_Esn);
               /*IF p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd.Vamb_Esn IS NULL
               THEN*/
               SELECT MAX(Vamb_Esn)
               INTO   p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd.Vamb_Esn
               FROM   Cltb_Account_Vamd
               WHERE  Account_Number = p_Wrk_Cldaccvm.v_Cltbs_Account_Master.Account_Number
               AND    Branch_Code = p_Wrk_Cldaccvm.v_Cltbs_Account_Master.Branch_Code;
               --END IF;
               Dbg('Selected max vamb_esn >>' || p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd.Vamb_Esn);
               IF NOT Fn_Query_Amend(p_Source, p_Source_Operation, p_Function_Id, p_Action_Code, p_Cldaccvm, p_Wrk_Cldaccvm, p_Err_Code, p_Err_Params) THEN
                  Dbg('Failed in Fn_Query_amend');
                  Pr_Log_Error(p_Function_Id, p_Source, p_Err_Code, p_Err_Params);
                  RETURN FALSE;
               END IF;
            END IF;
         ELSE

            IF NOT Fn_Query_Amend(p_Source, p_Source_Operation, p_Function_Id, p_Action_Code, p_Cldaccvm, p_Wrk_Cldaccvm, p_Err_Code, p_Err_Params) THEN
               Dbg('Failed in Fn_Query_master');
               Pr_Log_Error(p_Function_Id, p_Source, p_Err_Code, p_Err_Params);
               RETURN FALSE;
            END IF;
         END IF;
         --Log#12 Starts
          /*  Dbg('Get the Record For: CLTB_ACCOUNT_STATEMENT');
         OPEN c_v_Acc_Stmt_Pref;
         LOOP
            FETCH c_v_Acc_Stmt_Pref
               INTO p_Wrk_Cldaccvm.v_Cltbs_Account_Statement;
            EXIT WHEN c_v_Acc_Stmt_Pref%NOTFOUND;
         END LOOP;*/
         Dbg(' FREQUENCY heree last  '||p_Wrk_Cldaccvm.v_Cltbs_Account_Statement.FREQUENCY);
         --Log#12 Ends
      END IF;

      RETURN TRUE;
      Dbg('Returning true from Fn_Query');
   EXCEPTION
      WHEN OTHERS THEN
         Dbg('In when others in Fn_Query ' || SQLERRM);
         p_Err_Code   := 'ST-OTHR-001';
         p_Err_Params := NULL;
         RETURN FALSE;
   END Fn_Query;

   FUNCTION Fn_Queryevents(p_Source           IN VARCHAR2
                          ,p_Source_Operation IN VARCHAR2
                          ,p_Function_Id      IN VARCHAR2
                          ,p_Action_Code      IN VARCHAR2
                          ,p_With_Lock        IN VARCHAR2 DEFAULT 'N'
                          ,p_Qrydata_Reqd     IN VARCHAR2
                          ,p_Cldevtqr         IN Clpks_Cldevtqr_Main.Ty_Cldevtqr
                          ,p_Wrk_Cldevtqr     IN OUT Clpks_Cldevtqr_Main.Ty_Cldevtqr
                          ,p_Err_Code         IN OUT VARCHAR2
                          ,p_Err_Params       IN OUT VARCHAR2) RETURN BOOLEAN IS
      l_Key           VARCHAR2(5000) := NULL;
      l_Main_Function VARCHAR2(5000) := p_Function_Id;
      l_Count         NUMBER := 0;
      l_Wrk_Count     NUMBER := 0;
      l_Key_Tags      VARCHAR2(32767);
      l_Key_Vals      VARCHAR2(32767);
      l_Rec_Exists    BOOLEAN := TRUE;
      Record_Locked EXCEPTION;
      PRAGMA EXCEPTION_INIT(Record_Locked, -54);
      l_Dsn_Rec_Cnt_2  NUMBER := 0;
      l_Bnd_Cntr_2     NUMBER := 0;
      l_Dsn_Rec_Cnt_3  NUMBER := 0;
      l_Bnd_Cntr_3     NUMBER := 0;
      l_Dsn_Rec_Cnt_4  NUMBER := 0;
      l_Bnd_Cntr_4     NUMBER := 0;
      l_Dsn_Rec_Cnt_5  NUMBER := 0;
      l_Bnd_Cntr_5     NUMBER := 0;
      l_Dsn_Rec_Cnt_6  NUMBER := 0;
      l_Bnd_Cntr_6     NUMBER := 0;
      l_Dsn_Rec_Cnt_7  NUMBER := 0;
      l_Bnd_Cntr_7     NUMBER := 0;
      l_Dsn_Rec_Cnt_8  NUMBER := 0;
      l_Bnd_Cntr_8     NUMBER := 0;
      l_Dsn_Rec_Cnt_9  NUMBER := 0;
      l_Bnd_Cntr_9     NUMBER := 0;
      l_Dsn_Rec_Cnt_10 NUMBER := 0;
      l_Bnd_Cntr_10    NUMBER := 0;
      l_Dsn_Rec_Cnt_11 NUMBER := 0;
      l_Bnd_Cntr_11    NUMBER := 0;
      l_Dsn_Rec_Cnt_12 NUMBER := 0;
      l_Bnd_Cntr_12    NUMBER := 0;
      l_Dsn_Rec_Cnt_13 NUMBER := 0;
      l_Bnd_Cntr_13    NUMBER := 0;
      l_Dsn_Rec_Cnt_14 NUMBER := 0;
      l_Bnd_Cntr_14    NUMBER := 0;
      CURSOR c_v_Account_Events_Diary IS
         SELECT *
         FROM   Cltb_Account_Events_Diary
         WHERE  Execution_Status = 'P'
         AND    Account_Number = p_Wrk_Cldevtqr.v_Cltbs_Account_Master.Account_Number
         AND    Branch_Code = p_Wrk_Cldevtqr.v_Cltbs_Account_Master.Branch_Code;
      CURSOR c_v_Account_Events_Advices IS
         SELECT *
         FROM   Cltb_Account_Events_Advices
         WHERE  Account_Number = p_Wrk_Cldevtqr.v_Cltbs_Account_Master.Account_Number
         AND    Branch_Code = p_Wrk_Cldevtqr.v_Cltbs_Account_Master.Branch_Code;
      CURSOR c_v_Clvws_Account_Event IS
         SELECT *
         FROM   Clvw_Account_Event
         WHERE  Account_Number = p_Wrk_Cldevtqr.v_Cltbs_Account_Master.Account_Number
         AND    Ac_Branch = p_Wrk_Cldevtqr.v_Cltbs_Account_Master.Branch_Code;
      CURSOR c_v_Account_Events_Diary__Ode IS
         SELECT *
         FROM   Cltb_Account_Events_Diary
         WHERE  Execution_Status = 'U'
         AND    Account_Number = p_Wrk_Cldevtqr.v_Cltbs_Account_Master.Account_Number
         AND    Branch_Code = p_Wrk_Cldevtqr.v_Cltbs_Account_Master.Branch_Code;
      CURSOR c_v_Account_Events_Diary__Odc IS
         SELECT *
         FROM   Cltb_Account_Events_Diary
         WHERE  Execution_Status = 'U'
         AND    Account_Number = p_Wrk_Cldevtqr.v_Cltbs_Account_Master.Account_Number
         AND    Branch_Code = p_Wrk_Cldevtqr.v_Cltbs_Account_Master.Branch_Code;
      CURSOR c_v_Ccount_Events_Diary__Duee IS
         SELECT *
         FROM   Cltb_Account_Events_Diary
         WHERE  Execution_Status = 'U'
         AND    Account_Number = p_Wrk_Cldevtqr.v_Cltbs_Account_Master.Account_Number
         AND    Branch_Code = p_Wrk_Cldevtqr.v_Cltbs_Account_Master.Branch_Code;
      CURSOR c_v_Ccount_Events_Diary__Duec IS
         SELECT *
         FROM   Cltb_Account_Events_Diary
         WHERE  Execution_Status = 'U'
         AND    Account_Number = p_Wrk_Cldevtqr.v_Cltbs_Account_Master.Account_Number
         AND    Branch_Code = p_Wrk_Cldevtqr.v_Cltbs_Account_Master.Branch_Code;
      CURSOR c_v_Event_Userdef__Char IS
         SELECT *
         FROM   Cltb_Account_Event_Userdef
         WHERE  Account_Number = p_Wrk_Cldevtqr.v_Cltbs_Account_Master.Account_Number;
      CURSOR c_v_Ccount_Event_Userdef__Num IS
         SELECT *
         FROM   Cltb_Account_Event_Userdef
         WHERE  Account_Number = p_Wrk_Cldevtqr.v_Cltbs_Account_Master.Account_Number;
      CURSOR c_v_Account_Event_Userdef__Dt IS
         SELECT *
         FROM   Cltb_Account_Event_Userdef
         WHERE  Account_Number = p_Wrk_Cldevtqr.v_Cltbs_Account_Master.Account_Number;
      -- FCUBS 11.1 : 9NT1368 - ITR1 - SFR#1692 - 10-May-2010 - Praveen Kumar D - Start
      CURSOR c_v_Cltb_Event_Check_List IS
		SELECT *
          FROM  Cltb_Event_Check_List
         WHERE  Account_Number = p_Wrk_Cldevtqr.v_Cltbs_Account_Master.Account_Number
           AND  Branch_Code = p_Wrk_Cldevtqr.v_Cltbs_Account_Master.Branch_Code;
      -- FCUBS 11.1 : 9NT1368 - ITR1 - SFR#1692 - 10-May-2010 - Praveen Kumar D - End
	--FCUBS11.1INFRA Events Screens Security Changes
      CURSOR c_v_Account_Events_Remarks IS
         SELECT *
         FROM   Cltbs_Event_Remarks
         WHERE  Account_Number = p_Wrk_Cldevtqr.v_Cltbs_Account_Master.Account_Number
                AND Branch_Code = p_Wrk_Cldevtqr.v_Cltbs_Account_Master.Branch_Code;
      --FCUBS11.1INFRA Events Screens Security Changes
   BEGIN
      Dbg('In Fn_Sys_Query..');
      IF Nvl(p_With_Lock, 'N') = 'Y' THEN
         BEGIN
            SELECT *
            INTO   p_Wrk_Cldevtqr.v_Cltbs_Account_Master
            FROM   Cltb_Account_Master
            WHERE  Account_Number = p_Cldevtqr.v_Cltbs_Account_Master.Account_Number
            AND    Branch_Code = p_Cldevtqr.v_Cltbs_Account_Master.Branch_Code
            FOR    UPDATE NOWAIT;
         EXCEPTION
            WHEN Record_Locked THEN
               Dbg('Failed to Obtain the Lock..');
               Pr_Log_Error(p_Function_Id, p_Source, 'ST-LOCK-001', NULL);
               RETURN FALSE;
            WHEN No_Data_Found THEN
               Dbg('Failed in Selecting The Master Recotrd..');
               Dbg('Record Does not Exist..');
               l_Rec_Exists := FALSE;
         END;
      ELSE
         BEGIN
            SELECT *
            INTO   p_Wrk_Cldevtqr.v_Cltbs_Account_Master
            FROM   Cltb_Account_Master
            WHERE  Account_Number = p_Cldevtqr.v_Cltbs_Account_Master.Account_Number
            AND    Branch_Code = p_Cldevtqr.v_Cltbs_Account_Master.Branch_Code;
         EXCEPTION
            WHEN No_Data_Found THEN
               Dbg('Failed in Selecting The Master Recotrd..');
               Dbg('Record Does not Exist..');
               p_Err_Code   := 'ST-VALS-002';
               p_Err_Params := l_Key;
               RETURN FALSE;
         END;
      END IF;
      Dbg('Get the Record For :CLTBS_ACCOUNT_EVENTS_DIARY');
      OPEN c_v_Account_Events_Diary;
      LOOP
         FETCH c_v_Account_Events_Diary BULK COLLECT
            INTO p_Wrk_Cldevtqr.v_Account_Events_Diary;
         EXIT WHEN c_v_Account_Events_Diary%NOTFOUND;
      END LOOP;
      CLOSE c_v_Account_Events_Diary;
      Dbg('Get the Record For :CLTBS_ACCOUNT_EVENTS_ADVICES');
      OPEN c_v_Account_Events_Advices;
      LOOP
         FETCH c_v_Account_Events_Advices BULK COLLECT
            INTO p_Wrk_Cldevtqr.v_Account_Events_Advices;
         EXIT WHEN c_v_Account_Events_Advices%NOTFOUND;
      END LOOP;
      CLOSE c_v_Account_Events_Advices;
      Dbg('Get the Record For :CLVWS_ACCOUNT_EVENT');
      OPEN c_v_Clvws_Account_Event;
      LOOP
         FETCH c_v_Clvws_Account_Event BULK COLLECT
            INTO p_Wrk_Cldevtqr.v_Clvws_Account_Event;
         EXIT WHEN c_v_Clvws_Account_Event%NOTFOUND;
      END LOOP;
      CLOSE c_v_Clvws_Account_Event;
      Dbg('Get the Record For :CLTBS_ACCOUNT_EVENTS_DIARY__ODE');
      OPEN c_v_Account_Events_Diary__Ode;
      LOOP
         FETCH c_v_Account_Events_Diary__Ode BULK COLLECT
            INTO p_Wrk_Cldevtqr.v_Account_Events_Diary__Ode;
         EXIT WHEN c_v_Account_Events_Diary__Ode%NOTFOUND;
      END LOOP;
      CLOSE c_v_Account_Events_Diary__Ode;
      Dbg('Get the Record For :CLTBS_ACCOUNT_EVENTS_DIARY__ODC');
      OPEN c_v_Account_Events_Diary__Odc;
      LOOP
         FETCH c_v_Account_Events_Diary__Odc BULK COLLECT
            INTO p_Wrk_Cldevtqr.v_Account_Events_Diary__Odc;
         EXIT WHEN c_v_Account_Events_Diary__Odc%NOTFOUND;
      END LOOP;
      CLOSE c_v_Account_Events_Diary__Odc;
      Dbg('Get the Record For :CLTBS_ACCOUNT_EVENTS_DIARY__DUEE');
      OPEN c_v_Ccount_Events_Diary__Duee;
      LOOP
         FETCH c_v_Ccount_Events_Diary__Duee BULK COLLECT
            INTO p_Wrk_Cldevtqr.v_Ccount_Events_Diary__Duee;
         EXIT WHEN c_v_Ccount_Events_Diary__Duee%NOTFOUND;
      END LOOP;
      CLOSE c_v_Ccount_Events_Diary__Duee;
      Dbg('Get the Record For :CLTBS_ACCOUNT_EVENTS_DIARY__DUEC');
      OPEN c_v_Ccount_Events_Diary__Duec;
      LOOP
         FETCH c_v_Ccount_Events_Diary__Duec BULK COLLECT
            INTO p_Wrk_Cldevtqr.v_Ccount_Events_Diary__Duec;
         EXIT WHEN c_v_Ccount_Events_Diary__Duec%NOTFOUND;
      END LOOP;
      CLOSE c_v_Ccount_Events_Diary__Duec;
      Dbg('Get the Record For :CLTBS_EVENT_CHECK_LIST');
      -- FCUBS 11.1 : 9NT1368 - ITR1 - SFR#1692 - 10-May-2010 - Praveen Kumar D - Start
      /*
      BEGIN
         SELECT *
         INTO   p_Wrk_Cldevtqr.v_Cltbs_Event_Check_List
         FROM   Cltb_Event_Check_List
         WHERE  Account_Number = p_Wrk_Cldevtqr.v_Cltbs_Account_Master.Account_Number
         AND    Branch_Code = p_Wrk_Cldevtqr.v_Cltbs_Account_Master.Branch_Code;
      EXCEPTION
         WHEN OTHERS THEN
            Dbg(SQLERRM);
            Dbg('Failed in Selecting The Record For :CLTBS_EVENT_CHECK_LIST');
      END;
      */
      OPEN c_v_Cltb_Event_Check_List;
      LOOP
         FETCH c_v_Cltb_Event_Check_List BULK COLLECT
            INTO p_Wrk_Cldevtqr.v_Cltbs_Event_Check_List;
         EXIT WHEN c_v_Cltb_Event_Check_List%NOTFOUND;
      END LOOP;
      -- FCUBS 11.1 : 9NT1368 - ITR1 - SFR#1692 - 10-May-2010 - Praveen Kumar D - End
      Dbg('Get the Record For :CLTBS_EVENT_REMARKS');
      --FCUBS11.1INFRA Events Screens Security Changes
      /*BEGIN
         SELECT *
         INTO   p_Wrk_Cldevtqr.v_Cltbs_Event_Remarks
         FROM   Cltb_Event_Remarks
         WHERE  Account_Number = p_Wrk_Cldevtqr.v_Cltbs_Account_Master.Account_Number
         AND    Branch_Code = p_Wrk_Cldevtqr.v_Cltbs_Account_Master.Branch_Code;
      EXCEPTION
         WHEN OTHERS THEN
            Dbg(SQLERRM);
            Dbg('Failed in Selecting The Record For :CLTBS_EVENT_REMARKS');
      END;*/
      OPEN c_v_Account_Events_Remarks;
      LOOP
         FETCH c_v_Account_Events_Remarks BULK COLLECT
            INTO p_Wrk_Cldevtqr.v_Cltbs_Event_Remarks;
         EXIT WHEN c_v_Account_Events_Remarks%NOTFOUND;
      END LOOP;
      CLOSE c_v_Account_Events_Remarks;
      --FCUBS11.1INFRA Events Screens Security Changes
      Dbg('Get the Record For :CLTBS_ACCOUNT_EVENT_USERDEF');
      BEGIN
         SELECT *
         INTO   p_Wrk_Cldevtqr.v_Account_Event_Userdef
         FROM   Cltb_Account_Event_Userdef
         WHERE  Account_Number = p_Wrk_Cldevtqr.v_Cltbs_Account_Master.Account_Number
         AND    Branch_Code = p_Wrk_Cldevtqr.v_Cltbs_Account_Master.Branch_Code;
      EXCEPTION
         WHEN OTHERS THEN
            Dbg(SQLERRM);
            Dbg('Failed in Selecting The Record For :CLTBS_ACCOUNT_EVENT_USERDEF');
      END;
      Dbg('Get the Record For :CLTBS_ACCOUNT_EVENT_USERDEF__CHAR');
      OPEN c_v_Event_Userdef__Char;
      LOOP
         FETCH c_v_Event_Userdef__Char BULK COLLECT
            INTO p_Wrk_Cldevtqr.v_Event_Userdef__Char;
         EXIT WHEN c_v_Event_Userdef__Char%NOTFOUND;
      END LOOP;
      CLOSE c_v_Event_Userdef__Char;
      Dbg('Get the Record For :CLTBS_ACCOUNT_EVENT_USERDEF__NUM');
      OPEN c_v_Ccount_Event_Userdef__Num;
      LOOP
         FETCH c_v_Ccount_Event_Userdef__Num BULK COLLECT
            INTO p_Wrk_Cldevtqr.v_Ccount_Event_Userdef__Num;
         EXIT WHEN c_v_Ccount_Event_Userdef__Num%NOTFOUND;
      END LOOP;
      CLOSE c_v_Ccount_Event_Userdef__Num;
      Dbg('Get the Record For :CLTBS_ACCOUNT_EVENT_USERDEF__DT');
      OPEN c_v_Account_Event_Userdef__Dt;
      LOOP
         FETCH c_v_Account_Event_Userdef__Dt BULK COLLECT
            INTO p_Wrk_Cldevtqr.v_Account_Event_Userdef__Dt;
         EXIT WHEN c_v_Account_Event_Userdef__Dt%NOTFOUND;
      END LOOP;
      CLOSE c_v_Account_Event_Userdef__Dt;
      IF Nvl(p_Qrydata_Reqd, 'Y') = 'Y' THEN
         Dbg('Querying Description Fields ');
      END IF;

      Dbg('Returning Success From Fn_Sys_Query..');
      RETURN TRUE;
   EXCEPTION
      WHEN OTHERS THEN
         Debug.Pr_Debug('**', 'In When Others of Fn_Sys_Query ..');
         Debug.Pr_Debug('**', SQLERRM);
         IF c_v_Account_Events_Diary%ISOPEN THEN
            CLOSE c_v_Account_Events_Diary;
         END IF;
         IF c_v_Account_Events_Advices%ISOPEN THEN
            CLOSE c_v_Account_Events_Advices;
         END IF;
         IF c_v_Clvws_Account_Event%ISOPEN THEN
            CLOSE c_v_Clvws_Account_Event;
         END IF;
         IF c_v_Account_Events_Diary__Ode%ISOPEN THEN
            CLOSE c_v_Account_Events_Diary__Ode;
         END IF;
         IF c_v_Account_Events_Diary__Odc%ISOPEN THEN
            CLOSE c_v_Account_Events_Diary__Odc;
         END IF;
         IF c_v_Ccount_Events_Diary__Duee%ISOPEN THEN
            CLOSE c_v_Ccount_Events_Diary__Duee;
         END IF;
         IF c_v_Ccount_Events_Diary__Duec%ISOPEN THEN
            CLOSE c_v_Ccount_Events_Diary__Duec;
         END IF;
         IF c_v_Event_Userdef__Char%ISOPEN THEN
            CLOSE c_v_Event_Userdef__Char;
         END IF;
         IF c_v_Ccount_Event_Userdef__Num%ISOPEN THEN
            CLOSE c_v_Ccount_Event_Userdef__Num;
         END IF;
         IF c_v_Account_Event_Userdef__Dt%ISOPEN THEN
            CLOSE c_v_Account_Event_Userdef__Dt;
         END IF;
         p_Err_Code   := 'ST-OTHR-001';
         p_Err_Params := NULL;
         RETURN FALSE;
   END Fn_Queryevents;
   FUNCTION Fn_Glquery(p_Source           IN VARCHAR2
                      ,p_Source_Operation IN VARCHAR2
                      ,p_Function_Id      IN VARCHAR2
                      ,p_Action_Code      IN VARCHAR2
                      ,p_With_Lock        IN VARCHAR2 DEFAULT 'N'
                      ,p_Qrydata_Reqd     IN VARCHAR2
                      ,p_Cldglbqr         IN Clpks_Cldglbqr_Main.Ty_Cldglbqr
                      ,p_Wrk_Cldglbqr     IN OUT Clpks_Cldglbqr_Main.Ty_Cldglbqr
                      ,p_Err_Code         IN OUT VARCHAR2
                      ,p_Err_Params       IN OUT VARCHAR2) RETURN BOOLEAN IS
      l_Key        VARCHAR2(5000) := NULL;
      l_Count      NUMBER := 0;
      l_Wrk_Count  NUMBER := 0;
      l_Key_Tags   VARCHAR2(32767);
      l_Key_Vals   VARCHAR2(32767);
      l_Rec_Exists BOOLEAN := TRUE;
      Record_Locked EXCEPTION;
      PRAGMA EXCEPTION_INIT(Record_Locked, -54);
      l_Dsn_Rec_Cnt_2 NUMBER := 0;
      l_Bnd_Cntr_2    NUMBER := 0;
      l_Dsn_Rec_Cnt_3 NUMBER := 0;
      l_Bnd_Cntr_3    NUMBER := 0;
      CURSOR c_v_Cltbs_Account_Components IS
         SELECT *
         FROM   Cltb_Account_Components
         WHERE  Account_Number = p_Wrk_Cldglbqr.v_Cltbs_Account_Master.Account_Number
         AND    Branch_Code = p_Wrk_Cldglbqr.v_Cltbs_Account_Master.Branch_Code;
      CURSOR c_v_Account_Comp_Bal_Breakup IS
         SELECT *
         FROM   Cltb_Account_Comp_Bal_Breakup
         WHERE  Account_Number = p_Wrk_Cldglbqr.v_Cltbs_Account_Master.Account_Number
         AND    Branch_Code = p_Wrk_Cldglbqr.v_Cltbs_Account_Master.Branch_Code;
   BEGIN
      Dbg('In Fn_Sys_Query..');

      IF Nvl(p_With_Lock, 'N') = 'Y' THEN
         BEGIN
            SELECT *
            INTO   p_Wrk_Cldglbqr.v_Cltbs_Account_Master
            FROM   Cltb_Account_Master
            WHERE  Account_Number = p_Cldglbqr.v_Cltbs_Account_Master.Account_Number
            AND    Branch_Code = p_Cldglbqr.v_Cltbs_Account_Master.Branch_Code
            FOR    UPDATE NOWAIT;
         EXCEPTION
            WHEN Record_Locked THEN
               Dbg('Failed to Obtain the Lock..');
               Pr_Log_Error(p_Function_Id, p_Source, 'ST-LOCK-001', NULL);
               RETURN FALSE;
            WHEN No_Data_Found THEN
               Dbg('Failed in Selecting The Master Recotrd..');
               Dbg('Record Does not Exist..');
               l_Rec_Exists := FALSE;
         END;

      ELSE
         BEGIN
            SELECT *
            INTO   p_Wrk_Cldglbqr.v_Cltbs_Account_Master
            FROM   Cltb_Account_Master
            WHERE  Account_Number = p_Cldglbqr.v_Cltbs_Account_Master.Account_Number
            AND    Branch_Code = p_Cldglbqr.v_Cltbs_Account_Master.Branch_Code;
         EXCEPTION
            WHEN No_Data_Found THEN
               Dbg('Failed in Selecting The Master Recotrd..');
               Dbg('Record Does not Exist..');
               p_Err_Code   := 'ST-VALS-002';
               p_Err_Params := l_Key;
               RETURN FALSE;
         END;

      END IF;

      Dbg('Get the Record For :CLTBS_ACCOUNT_COMPONENTS');
      OPEN c_v_Cltbs_Account_Components;
      LOOP
         FETCH c_v_Cltbs_Account_Components BULK COLLECT
            INTO p_Wrk_Cldglbqr.v_Cltbs_Account_Components;
         EXIT WHEN c_v_Cltbs_Account_Components%NOTFOUND;
      END LOOP;
      CLOSE c_v_Cltbs_Account_Components;
      Dbg('Get the Record For :CLTBS_ACCOUNT_COMP_BAL_BREAKUP');
      OPEN c_v_Account_Comp_Bal_Breakup;
      LOOP
         FETCH c_v_Account_Comp_Bal_Breakup BULK COLLECT
            INTO p_Wrk_Cldglbqr.v_Account_Comp_Bal_Breakup;
         EXIT WHEN c_v_Account_Comp_Bal_Breakup%NOTFOUND;
      END LOOP;
      CLOSE c_v_Account_Comp_Bal_Breakup;
      IF Nvl(p_Qrydata_Reqd, 'Y') = 'Y' THEN
         Dbg('Querying Description Fields ');
      END IF;
      Dbg('Returning Success From Fn_Sys_Query..');
      RETURN TRUE;
   EXCEPTION
      WHEN OTHERS THEN
         Debug.Pr_Debug('**', 'In When Others of Fn_Sys_Query ..');
         Debug.Pr_Debug('**', SQLERRM);
         IF c_v_Cltbs_Account_Components%ISOPEN THEN
            CLOSE c_v_Cltbs_Account_Components;
         END IF;
         IF c_v_Account_Comp_Bal_Breakup%ISOPEN THEN
            CLOSE c_v_Account_Comp_Bal_Breakup;
         END IF;
         p_Err_Code   := 'ST-OTHR-001';
         p_Err_Params := NULL;
         RETURN FALSE;
   END Fn_Glquery;
   FUNCTION Fn_Insquery(p_Source           IN VARCHAR2
                       ,p_Source_Operation IN VARCHAR2
                       ,p_Function_Id      IN VARCHAR2
                       ,p_Action_Code      IN VARCHAR2
                       ,p_With_Lock        IN VARCHAR2 DEFAULT 'N'
                       ,p_Qrydata_Reqd     IN VARCHAR2
                       ,p_Cldinsqr         IN Clpks_Cldinsqr_Main.Ty_Cldinsqr
                       ,p_Wrk_Cldinsqr     IN OUT Clpks_Cldinsqr_Main.Ty_Cldinsqr
                       ,p_Err_Code         IN OUT VARCHAR2
                       ,p_Err_Params       IN OUT VARCHAR2) RETURN BOOLEAN IS
      l_Key        VARCHAR2(5000) := NULL;
      l_Count      NUMBER := 0;
      l_Wrk_Count  NUMBER := 0;
      l_Key_Tags   VARCHAR2(32767);
      l_Key_Vals   VARCHAR2(32767);
      l_Rec_Exists BOOLEAN := TRUE;
      Record_Locked EXCEPTION;
      PRAGMA EXCEPTION_INIT(Record_Locked, -54);
      l_Dsn_Rec_Cnt_2 NUMBER := 0;
      l_Bnd_Cntr_2    NUMBER := 0;
      l_Dsn_Rec_Cnt_3 NUMBER := 0;
      l_Bnd_Cntr_3    NUMBER := 0;
      l_Dsn_Rec_Cnt_4 NUMBER := 0;
      l_Bnd_Cntr_4    NUMBER := 0;
      CURSOR c_v_Clvws_Inst_Summary IS
         SELECT *
         FROM   Clvw_Inst_Summary
         WHERE  Account_Number = p_Wrk_Cldinsqr.v_Cltbs_Account_Master.Account_Number
         AND    Branch_Code = p_Wrk_Cldinsqr.v_Cltbs_Account_Master.Branch_Code;
      CURSOR c_v_Clvws_Inst_Detail IS
         SELECT *
         FROM   Clvw_Inst_Detail
         WHERE  Account_Number = p_Wrk_Cldinsqr.v_Cltbs_Account_Master.Account_Number
         AND    Branch_Code = p_Wrk_Cldinsqr.v_Cltbs_Account_Master.Branch_Code;
      CURSOR c_v_Cltbs_Amount_Paid IS
         SELECT *
         FROM   Cltb_Amount_Paid
         WHERE  Account_Number = p_Wrk_Cldinsqr.v_Cltbs_Account_Master.Account_Number
         AND    Branch_Code = p_Wrk_Cldinsqr.v_Cltbs_Account_Master.Branch_Code;
   BEGIN
      Dbg('In Fn_Sys_Query..');
      IF Nvl(p_With_Lock, 'N') = 'Y' THEN
         BEGIN
            SELECT *
            INTO   p_Wrk_Cldinsqr.v_Cltbs_Account_Master
            FROM   Cltb_Account_Master
            WHERE  Account_Number = p_Cldinsqr.v_Cltbs_Account_Master.Account_Number
            AND    Branch_Code = p_Cldinsqr.v_Cltbs_Account_Master.Branch_Code
            FOR    UPDATE NOWAIT;
         EXCEPTION
            WHEN Record_Locked THEN
               Dbg('Failed to Obtain the Lock..');
               Pr_Log_Error(p_Function_Id, p_Source, 'ST-LOCK-001', NULL);
               RETURN FALSE;
            WHEN No_Data_Found THEN
               Dbg('Failed in Selecting The Master Recotrd..');
               Dbg('Record Does not Exist..');
               l_Rec_Exists := FALSE;
         END;

      ELSE
         BEGIN
            SELECT *
            INTO   p_Wrk_Cldinsqr.v_Cltbs_Account_Master
            FROM   Cltb_Account_Master
            WHERE  Account_Number = p_Cldinsqr.v_Cltbs_Account_Master.Account_Number
            AND    Branch_Code = p_Cldinsqr.v_Cltbs_Account_Master.Branch_Code;
         EXCEPTION
            WHEN No_Data_Found THEN
               Dbg('Failed in Selecting The Master Recotrd..');
               Dbg('Record Does not Exist..');
               p_Err_Code   := 'ST-VALS-002';
               p_Err_Params := l_Key;
               RETURN FALSE;
         END;

      END IF;

      Dbg('Get the Record For :CLVWS_INST_SUMMARY');
      OPEN c_v_Clvws_Inst_Summary;
      LOOP
         FETCH c_v_Clvws_Inst_Summary BULK COLLECT
            INTO p_Wrk_Cldinsqr.v_Clvws_Inst_Summary;
         EXIT WHEN c_v_Clvws_Inst_Summary%NOTFOUND;
      END LOOP;
      CLOSE c_v_Clvws_Inst_Summary;
      Dbg('Get the Record For :CLVWS_INST_DETAIL');
      OPEN c_v_Clvws_Inst_Detail;
      LOOP
         FETCH c_v_Clvws_Inst_Detail BULK COLLECT
            INTO p_Wrk_Cldinsqr.v_Clvws_Inst_Detail;
         EXIT WHEN c_v_Clvws_Inst_Detail%NOTFOUND;
      END LOOP;
      CLOSE c_v_Clvws_Inst_Detail;
      Dbg('Get the Record For :CLTBS_AMOUNT_PAID');
      OPEN c_v_Cltbs_Amount_Paid;
      LOOP
         FETCH c_v_Cltbs_Amount_Paid BULK COLLECT
            INTO p_Wrk_Cldinsqr.v_Cltbs_Amount_Paid;
         EXIT WHEN c_v_Cltbs_Amount_Paid%NOTFOUND;
      END LOOP;
      CLOSE c_v_Cltbs_Amount_Paid;
      IF Nvl(p_Qrydata_Reqd, 'Y') = 'Y' THEN
         Dbg('Querying Description Fields ');
      END IF;

      Dbg('Returning Success From Fn_Sys_Query..');
      RETURN TRUE;
   EXCEPTION
      WHEN OTHERS THEN
         Debug.Pr_Debug('**', 'In When Others of Fn_Sys_Query ..');
         Debug.Pr_Debug('**', SQLERRM);
         IF c_v_Clvws_Inst_Summary%ISOPEN THEN
            CLOSE c_v_Clvws_Inst_Summary;
         END IF;
         IF c_v_Clvws_Inst_Detail%ISOPEN THEN
            CLOSE c_v_Clvws_Inst_Detail;
         END IF;
         IF c_v_Cltbs_Amount_Paid%ISOPEN THEN
            CLOSE c_v_Cltbs_Amount_Paid;
         END IF;
         p_Err_Code   := 'ST-OTHR-001';
         p_Err_Params := NULL;
         RETURN FALSE;
   END Fn_Insquery;
   FUNCTION Fn_Log_Overrides(p_Source           IN VARCHAR2
                            ,p_Source_Operation IN VARCHAR2
                            ,p_Function_Id      IN VARCHAR2
                            ,p_Action_Code      IN VARCHAR2
                            ,p_Wrk_Cldaccvm     IN OUT Clpks_Cldaccvm_Main.Ty_Cldaccvm
                            ,p_Err_Code         IN OUT VARCHAR2
                            ,p_Err_Params       IN OUT VARCHAR2) RETURN BOOLEAN IS
      Lmsg              VARCHAR2(200);
      Ltype             VARCHAR2(10);
      l_Tb_Event_Ovd    Clpks_Util.Ty_Tb_Event_Ovd;
      l_Tb_Cl_Event_Ovd Clpks_Dml.Ty_Tb_Event_Ovd;

   BEGIN
      Dbg('In Fn_Log_Overrides');

      IF Ovpks.Gl_Tblerror.COUNT > 0 THEN
         l_Tb_Event_Ovd.DELETE;
         Clpks_Util.Pr_Format_Messages(l_Tb_Event_Ovd);
         IF l_Tb_Event_Ovd.COUNT > 0 THEN
            FOR i IN 1 .. l_Tb_Event_Ovd.COUNT LOOP
               --9NT1368 Legacy fix Starts - System should log both 'O' and 'D' type overrides
               --IF l_Tb_Event_Ovd(i).Ovd_Type = 'O' THEN
               IF l_Tb_Event_Ovd(i).Ovd_Type IN ('O', 'D') THEN
                  --9NT1368 Legacy fix End
                  l_Tb_Cl_Event_Ovd(i).Account_Number := p_Wrk_Cldaccvm.v_Cltbs_Account_Master.Account_Number;
                  l_Tb_Cl_Event_Ovd(i).Branch_Code := p_Wrk_Cldaccvm.v_Cltbs_Account_Master.Branch_Code;
                  l_Tb_Cl_Event_Ovd(i).Event_Seq_No := p_Wrk_Cldaccvm.v_Cltbs_Account_Master.Latest_Esn;
                  l_Tb_Cl_Event_Ovd(i).Ovd_Seq_No := l_Tb_Event_Ovd(i).Ovd_Seq_No;
                  l_Tb_Cl_Event_Ovd(i).Err_Code := l_Tb_Event_Ovd(i).Err_Code;
                  l_Tb_Cl_Event_Ovd(i).Message := l_Tb_Event_Ovd(i).Message;
                  l_Tb_Cl_Event_Ovd(i).Online_Auth_Id := l_Tb_Event_Ovd(i).Online_Auth_Id;
                  l_Tb_Cl_Event_Ovd(i).Auth_By := l_Tb_Event_Ovd(i).Auth_By;
                  l_Tb_Cl_Event_Ovd(i).Auth_Dt_Stamp := l_Tb_Event_Ovd(i).Auth_Dt_Stamp;
                  l_Tb_Cl_Event_Ovd(i).Ovd_Status := l_Tb_Event_Ovd(i).Ovd_Status;
                  l_Tb_Cl_Event_Ovd(i).Confirmed := l_Tb_Event_Ovd(i).Confirmed;
                  l_Tb_Cl_Event_Ovd(i).Ovd_Type := l_Tb_Event_Ovd(i).Ovd_Type;
                  l_Tb_Cl_Event_Ovd(i).Remarks := l_Tb_Event_Ovd(i).Remarks;
                  l_Tb_Cl_Event_Ovd(i).Amount := l_Tb_Event_Ovd(i).Amount;
               END IF;
            END LOOP;
            IF NOT Clpks_Dml.Fn_Store_Overrides(l_Tb_Cl_Event_Ovd, Lmsg, Ltype) THEN
               Dbg('Failed in store overrides::' || Lmsg);
               RETURN FALSE;
            END IF;
         END IF;
      END IF;

      Dbg('Returning Success From Fn_Log_Ove..');
      RETURN TRUE;
   EXCEPTION
      WHEN OTHERS THEN
         Debug.Pr_Debug('**', 'In When Others of Fn_Log_Overrides ..');
         Debug.Pr_Debug('**', SQLERRM);
         p_Err_Code   := 'ST-OTHR-001';
         p_Err_Params := NULL;
         RETURN FALSE;
   END Fn_Log_Overrides;

   FUNCTION Fn_Process(p_Source           IN VARCHAR2
                      ,p_Source_Operation IN VARCHAR2
                      ,p_Function_Id      IN VARCHAR2
                      ,p_Action_Code      IN VARCHAR2
                      ,p_Child_Function   IN VARCHAR2
                      ,p_Multi_Trip_Id    IN VARCHAR2
                      ,p_Cldaccvm         IN Clpks_Cldaccvm_Main.Ty_Cldaccvm
                      ,p_Prev_Cldaccvm    IN Clpks_Cldaccvm_Main.Ty_Cldaccvm
                      ,p_Wrk_Cldaccvm     IN OUT Clpks_Cldaccvm_Main.Ty_Cldaccvm
                      ,p_Err_Code         IN OUT VARCHAR2
                      ,p_Err_Params       IN OUT VARCHAR2) RETURN BOOLEAN IS

      l_Function_Id   Smtb_Menu.Function_Id%TYPE;
      l_Prev_Cldaccvm Clpks_Cldaccvm_Main.Ty_Cldaccvm;
	   l_effective_date cltb_account_vamd.effective_date%type;  -- ASKARI-UP_14397581 added
      l_auth_stat cltb_account_vamd.auth_stat%type; -- ASKARI-UP_14397581 added
   BEGIN
      Dbg('In Fn_Process..' || p_Action_Code);
      l_Function_Id := Clpks_Cldaccvm_Type_Conv.Fn_Get_Context_Fid(p_Function_Id);

      IF p_Action_Code = Cspks_Req_Global.p_Modify THEN
         IF NOT Clpks_Cldaccvm_Utils.Fn_Modify_Account(p_Source, p_Source_Operation, p_Function_Id, p_Action_Code, p_Wrk_Cldaccvm, p_Err_Code, p_Err_Params) THEN
            Dbg('Failed in Clpks_Cldaccvm_Utils.Fn_Save_account');
            Pr_Log_Error(p_Function_Id, p_Source, p_Err_Code, p_Err_Params);
            RETURN FALSE;
         END IF;
      ELSIF p_Action_Code = Cspks_Req_Global.p_Delete THEN
         IF NOT Clpks_Cldaccvm_Utils.Fn_Delete_Account(p_Source, p_Source_Operation, p_Function_Id, p_Action_Code, p_Wrk_Cldaccvm, p_Err_Code, p_Err_Params) THEN
            Dbg('Failed in Clpks_Cldaccvm_Utils.Fn_Delete_Account');
            Pr_Log_Error(p_Function_Id, p_Source, p_Err_Code, p_Err_Params);
            RETURN FALSE;
         END IF;
      ELSIF p_Action_Code = 'GETSCORE' THEN
         IF NOT Clpks_Cldaccvm_Utils.Fn_Credit_Score(p_Source, p_Source_Operation, p_Function_Id, p_Action_Code, p_Wrk_Cldaccvm, p_Err_Code, p_Err_Params) THEN
            Dbg('Failed in Clpks_Cldaccvm_Utils.fn_credit_score');
            Pr_Log_Error(p_Function_Id, p_Source, p_Err_Code, p_Err_Params);
            RETURN FALSE;
         END IF;
      ELSIF p_Action_Code = Cspks_Req_Global.p_Auth THEN
         IF NOT Clpks_Cldaccvm_Utils.Fn_Auth_Account(p_Source, p_Source_Operation, p_Function_Id, p_Action_Code, p_Wrk_Cldaccvm, p_Err_Code, p_Err_Params) THEN
            Dbg('Failed in Clpks_Cldaccvm_Utils.Fn_Auth_Account');
            Pr_Log_Error(p_Function_Id, p_Source, p_Err_Code, p_Err_Params);
            RETURN FALSE;
         END IF;
      ELSIF p_Action_Code = Cspks_Req_Global.p_Reverse THEN
         --Call Reverse??
		 -- ASKARI-UP_14397581 starts
		  Dbg('reverse 1111'||'auth_stats'|| p_Cldaccvm.v_cltbs_account_vamd.auth_stat||'---branch'||p_Cldaccvm.v_cltbs_account_master.branch_code);



           BEGIN
              SELECT effective_date,auth_stat
              into l_effective_date,l_auth_stat
              from CLTB_ACCOUNT_VAMD
              where account_number = p_Cldaccvm.v_cltbs_account_master.account_number
              and branch_code =p_Cldaccvm.v_cltbs_account_master.branch_code and
              amend_applied ='N' and auth_stat ='A';


           EXCEPTION
            WHEN OTHERS THEN
            Debug.Pr_Debug('**', 'In When Others of Clpks_Cldaccvm_Utils.Fn_Process ..');
            Debug.Pr_Debug('**', SQLERRM);
             p_Err_Code   := 'ST-OTHR-001';
             p_Err_Params := NULL;
             RETURN FALSE;
             end;
             Dbg('reverse 1111'||'auth_stats'|| l_auth_stat||'---branch'||p_Cldaccvm.v_cltbs_account_master.branch_code);
             IF NOT CLPKS_VD_AMENDMENT.Fn_Delete_Vami_Account(p_Cldaccvm.v_cltbs_account_master.branch_code,
                                                          p_Cldaccvm.v_cltbs_account_vamd.account_number,
                                                          l_effective_date,
                                                          l_auth_stat,
                                                          p_Err_Code,
                                                           p_Err_Params) THEN
                    Dbg('Failed in Clpks_Cldaccvm_Utils.Fn_Delete_Vami_Account');
                    Pr_Log_Error(p_Function_Id, p_Source, p_Err_Code, p_Err_Params);
                     return false;
         end if;
         -- ASKARI-UP_14397581 ends

         --NULL; -- ASKARI-UP_14397581 commented
      END IF;

      --FCUBS11.1 ITR2 SFR#1085 Starts..
      IF p_Source <> 'FLEXCUBE' AND p_Action_Code = Cspks_Req_Global.p_New THEN
         IF NOT Clpks_Cldaccvm_Utils.Fn_Modify_Account(p_Source, p_Source_Operation, p_Function_Id, p_Action_Code, p_Wrk_Cldaccvm, p_Err_Code, p_Err_Params) THEN
            Dbg('Failed in Clpks_Cldaccvm_Utils.Fn_Save_account');
            Pr_Log_Error(p_Function_Id, p_Source, p_Err_Code, p_Err_Params);
            RETURN FALSE;
         END IF;
      END IF;
      --FCUBS11.1 ITR2 SFR#1085 Ends..

      IF p_Action_Code NOT IN (Cspks_Req_Global.p_Auth) THEN
         BEGIN
            UPDATE Cltb_Account_Apps_Master
            SET    Subsystemstat = p_Wrk_Cldaccvm.v_Cltbs_Account_Vamd.Subsystemstat
            WHERE  Account_Number = p_Wrk_Cldaccvm.v_Cltbs_Account_Master.Account_Number;

         EXCEPTION
            WHEN OTHERS THEN
               Dbg('Failed to update in cltb_account_master for Subsystemstat');
         END;
      END IF;

      Dbg('Logging Overrides...');
      IF p_Action_Code IN (Cspks_Req_Global.p_New, Cspks_Req_Global.p_Modify, Cspks_Req_Global.p_Close, Cspks_Req_Global.p_Delete, Cspks_Req_Global.p_Hold) THEN
         IF NOT Fn_Log_Overrides(p_Source, p_Source_Operation, p_Function_Id, p_Action_Code, p_Wrk_Cldaccvm, p_Err_Code, p_Err_Params) THEN
            Dbg('Failed to log Overrides');
            Pr_Log_Error(p_Function_Id, p_Source, p_Err_Code, p_Err_Params);
            RETURN FALSE;
         END IF;
      END IF;
      Dbg('Returning Success From Fn_Process..');
      RETURN TRUE;
   EXCEPTION
      WHEN OTHERS THEN
         Debug.Pr_Debug('**', 'In When Others of Clpks_Cldaccvm_Utils.Fn_Process ..');
         Debug.Pr_Debug('**', SQLERRM);
         p_Err_Code   := 'ST-OTHR-001';
         p_Err_Params := NULL;
         RETURN FALSE;
   END Fn_Process;

BEGIN
   Pkg_Principal := Clpkss_Nls.Principal;
   Pkg_Main_Int  := Clpks_Nls.Main_Int;
END Clpks_Cldaccvm_Utils;
