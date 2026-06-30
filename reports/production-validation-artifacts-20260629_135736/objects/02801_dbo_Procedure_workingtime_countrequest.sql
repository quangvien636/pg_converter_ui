-- ─── PROCEDURE→FUNCTION: workingtime_countrequest ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.workingtime_countrequest(integer, integer, integer, integer);
CREATE OR REPLACE FUNCTION public.workingtime_countrequest(
    IN p_from integer,
    IN p_to integer,
    IN p_uno integer,
    IN p_type integer
) RETURNS SETOF record
AS $function$
DECLARE
    temp_department table(  
   departno int
  );
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


  INSERT INTO TEMP_DEPARTMENT  
  PERFORM workingtime_getallchilddepartbyuid(p_uno);


		RETURN QUERY
		SELECT  
			COUNT(1) AS uncomfirm
		FROM WorkingTime_Times t  
		INNER JOIN WorkingTime_Times_v2 t2  ON t.WorkingNo = t2.WorkingNo
		INNER JOIN WorkingTime_RequestCorrectionTime r  ON t.WorkingNo = r.WorkingNo
		LEFT JOIN Organization_BelongToDepartment OB ON OB.UserNo = t.UserNo
		WHERE t.WorkingDayC BETWEEN  p_from AND p_to
		AND (t.Provider = 999) 
		AND R.STATUS = 0 AND R.REJECT = 0
		AND (p_type = 1 OR OB.DepartNo IN(select DepartNo from TEMP_DEPARTMENT) OR OB.DepartNo IN (SELECT * FROM Organization_GetDepartments_Reflexive(D_NO, 0)));
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
