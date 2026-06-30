-- ─── PROCEDURE→FUNCTION: note_getlistshare_ownernote ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.note_getlistshare_ownernote(uuid);
CREATE OR REPLACE FUNCTION public.note_getlistshare_ownernote(
    IN listno uuid
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

RETURN QUERY
SELECT        public."Organization_Users".Name AS UsersName, public."Organization_Users".Name_EN AS UsersNameEN, public."Organization_Users".CellPhone, public."Organization_Users".CompanyPhone, 
                         public."Organization_Users".Photo, public."Organization_Positions".Name AS Positions, public."Organization_Positions".Name_EN AS PositionsEN, public."Organization_BelongToDepartment".DepartNo, public."Note_List".UserNo, 
                         public."Note_List".ListNo, public."Note_List".GroupNo, public."Note_List".DayCreate, public."Note_List".DayEdit, public."Note_List".ReadDate, public."Note_List".NoteTimeZoneRead
FROM            public."Organization_Users" INNER JOIN
                         public."Organization_BelongToDepartment" ON public."Organization_Users".UserNo = public."Organization_BelongToDepartment".UserNo INNER JOIN
                         public."Organization_Positions" ON public."Organization_BelongToDepartment".PositionNo = public."Organization_Positions".PositionNo INNER JOIN
                         public."Note_List" ON public."Organization_Users".UserNo = public."Note_List".UserNo
	WHERE ListNo=note_getlistshare_ownernote.listno
	ORDER BY DayCreate DESC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
