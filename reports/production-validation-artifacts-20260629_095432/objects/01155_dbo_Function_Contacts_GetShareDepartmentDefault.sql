-- ─── FUNCTION: contacts_getsharedepartmentdefault ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_getsharedepartmentdefault(integer, character varying);
CREATE OR REPLACE FUNCTION public.contacts_getsharedepartmentdefault(
    userno integer DEFAULT 222,
    langcode character varying DEFAULT 'KO'
) RETURNS TABLE(
    departno text,
    name text
)
-- TODO: TOP was preserved as comment; add LIMIT manually
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
