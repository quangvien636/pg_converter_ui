-- ─── FUNCTION: workingtime_get_requestcorrectiontime ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_get_requestcorrectiontime(character varying, character varying, integer, integer, integer, character varying, integer);
CREATE OR REPLACE FUNCTION public.workingtime_get_requestcorrectiontime(
    fromdate character varying,
    todate character varying,
    usernoinput integer,
    usertype integer,
    pagenumber integer DEFAULT 0,
    sort character varying DEFAULT 'Status',
    pagesize integer DEFAULT 30
) RETURNS TABLE(
    col1 text
)
AS $function$
DECLARE
    temp_department table(  
   departno int
  );
BEGIN
   

  INSERT INTO TEMP_DEPARTMENT  
  EXEC WorkingTime_GetAllChildDepartByUID usernoinput;

  WITH CTE AS(  
  SELECT    
		 ROW_NUMBER()OVER(ORDER BY convert(varchar(20), t.RegDate , 120) DESC, t.TimeType)   
		  
		AS NO  
		,t.WorkingNo  
		,t2.WorkingDayOfCompany  
		,t.UserNo  
		,U.Name  
		,U.Name_EN  
		,d.Name DepartName
		,d.Name_EN DepartName_EN
		,U.UserID  
		,OP.Name  AS Position  
		,OP.Name_EN AS Position_EN  
		,t.Provider  
		,t.Remark  
		,r.RegDate AS DateRequest  
		,r.AccDate AS DateAccepted  
		,t.TimeType  
		,t2.CheckDateTimeOffset  
		,r.Status  
		,r.AccUserNo  
		,U.Enabled  
		,RN = ROW_NUMBER()OVER(PARTITION BY WorkingDayOfCompany, U.UserNo  ORDER BY t2.CheckDateTimeOffset DESC)  
		,t.timeoffset
		,COALESCE(r.Reject,0) Reject
		,COALESCE(r.RejectDate,'2000-01-01') RejectDate
   FROM WorkingTime_Times t INNER JOIN WorkingTime_Times_v2 t2 ON t.WorkingNo = t2.WorkingNo  
   INNER JOIN WorkingTime_RequestCorrectionTime r ON t.WorkingNo = r.WorkingNo  
   LEFT JOIN Organization_Users U ON U.UserNo = T.UserNo
   LEFT JOIN (select max(BelongNo) BelongNo,max(PositionNo) PositionNo, max(DepartNo) DepartNo, bl.UserNo from  Organization_BelongToDepartment bl group by bl.UserNo) OB ON OB.UserNo = t.UserNo
   JOIN Organization_Departments D  ON D.DepartNo = OB.DepartNo
   LEFT JOIN Organization_Positions OP ON OB.PositionNo = OP.PositionNo

   WHERE t2.WorkingDayOfCompany BETWEEN  FromDate AND ToDate  
     AND (t.Provider = 999)  AND U.Enabled = TRUE  
	 AND (userType = 1 
		OR OB.DepartNo IN (SELECT DepartNo FROM  TEMP_DEPARTMENT)
		OR OB.DepartNo IN (SELECT DepartNo FROM Organization_GetDepartments_Reflexive(D_NO,1))
	 )
   )  

  RETURN QUERY
  SELECT T.* FROM CTE T  
  WHERE NO BETWEEN ((pageNumber-1)*pageSize)+1 AND (pageNumber*pageSize)+pageSize    ORDER BY NO  ASC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
