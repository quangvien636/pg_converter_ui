-- ─── PROCEDURE→FUNCTION: dday_getusersharebydayno ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.dday_getusersharebydayno(bigint);
CREATE OR REPLACE FUNCTION public.dday_getusersharebydayno(
    IN dayno bigint DEFAULT 11193
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


WITH  DepartNos AS (
  SELECT ODP.DepartNo,ODP.ParentNo
  FROM Organization_Departments ODP
  WHERE  ODP.DepartNo IN (SELECT DS.DepartNo FROM dday_sharers DS WHERE DS.DayNo=dday_getusersharebydayno.dayno AND DS.DepartNo>0 )
  UNION ALL
  SELECT ODC.DepartNo, ODC.ParentNo
  FROM Organization_Departments ODC 
  INNER JOIN DepartNos P ON P.DepartNo = ODC.ParentNo
 )
  RETURN QUERY
  SELECT OU.UserNo
  FROM Organization_Users OU
  INNER JOIN Organization_BelongToDepartment OP ON OU.UserNo=OP.UserNo
  WHERE OP.DepartNo IN (SELECT  DN.DepartNo FROM DepartNos DN)
  UNION 
  RETURN QUERY
  SELECT DS.UserNo FROM Dday_Sharers DS Where DS.DayNo=dday_getusersharebydayno.dayno AND  DS.UserNo>0
  UNION 
  RETURN QUERY
  SELECT DM.UserNo FROM Dday_Managers DM Where DM.DayNo=dday_getusersharebydayno.dayno
  UNION 
  RETURN QUERY
  SELECT DD.UserNo FROM Dday_Directors DD Where DD.DayNo=dday_getusersharebydayno.dayno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
