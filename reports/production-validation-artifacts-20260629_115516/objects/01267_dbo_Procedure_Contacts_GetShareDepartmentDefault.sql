-- ─── PROCEDURE→FUNCTION: contacts_getsharedepartmentdefault ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
-- TODO: TOP was preserved as comment; add LIMIT manually
DROP FUNCTION IF EXISTS public.contacts_getsharedepartmentdefault(integer, character varying);
CREATE OR REPLACE FUNCTION public.contacts_getsharedepartmentdefault(
    IN userno integer DEFAULT 222,
    IN langcode character varying DEFAULT 'KO'
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

 RETURN QUERY
 SELECT /* /* TOP 1 */ */ OD.DepartNo,CASE LangCode WHEN 'EN' THEN  COALESCE(OD.Name_EN,OD.Name) WHEN 'VN' THEN  COALESCE(OD.Name_VN,OD.Name) WHEN 'CH' THEN COALESCE(OD.Name_CH,OD.Name)  WHEN 'JP' THEN COALESCE(OD.Name_JP,OD.Name) ELSE OD.Name END AS Name 
 FROM Contact_DepartAllowAccess DA
 INNER JOIN Organization_BelongToDepartment  OB ON OB.DepartNo=DA.DepartNo  
 INNER JOIN Organization_Departments OD ON OD.DepartNo=OB.DepartNo
 
 WHERE OB.UserNo=contacts_getsharedepartmentdefault.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
