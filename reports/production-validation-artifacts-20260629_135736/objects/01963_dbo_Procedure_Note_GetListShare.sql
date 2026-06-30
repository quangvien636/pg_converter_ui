-- ─── PROCEDURE→FUNCTION: note_getlistshare ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.note_getlistshare(uuid);
CREATE OR REPLACE FUNCTION public.note_getlistshare(
    IN listno uuid
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

RETURN QUERY
SELECT        public."Note_Share".ShareNo, public."Note_Share".UserNo, public."Note_Share".ListNo, public."Note_Share".DayCreate, public."Note_Share".DayEdit, public."Note_Share".UserShare, public."Note_Share".GroupNo, public."Note_Share".IsRead, 
                         public."Note_Share".ReadDate, public."Note_Share".IsReads, public."Note_Share".FavoriteType, public."Note_Share".ShareType, public."Organization_Users".Name AS UsersName, public."Organization_Users".Name_EN AS UsersNameEN, 
                         public."Organization_Users".CellPhone, public."Organization_Users".CompanyPhone, public."Organization_Users".Photo, public."Organization_Positions".Name AS Positions, 
                         public."Organization_Positions".Name_EN AS PositionsEN, public."Organization_BelongToDepartment".DepartNo, public."Note_Share".timeOffset
FROM            public."Organization_Users" INNER JOIN
                         public."Organization_BelongToDepartment" ON public."Organization_Users".UserNo = public."Organization_BelongToDepartment".UserNo INNER JOIN
                         public."Organization_Positions" ON public."Organization_BelongToDepartment".PositionNo = public."Organization_Positions".PositionNo RIGHT OUTER JOIN
                         public."Note_Share" ON public."Organization_Users".UserNo = public."Note_Share".UserShare AND public."Note_Share".ShareType = 2
	WHERE ListNo=note_getlistshare.listno
	ORDER BY DayCreate DESC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
