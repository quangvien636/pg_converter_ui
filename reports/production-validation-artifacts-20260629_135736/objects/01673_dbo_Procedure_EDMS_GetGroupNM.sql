-- ─── PROCEDURE→FUNCTION: edms_getgroupnm ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
-- TODO: TOP was preserved as comment; add LIMIT manually
DROP FUNCTION IF EXISTS public.edms_getgroupnm(character varying, integer, integer, character varying);
CREATE OR REPLACE FUNCTION public.edms_getgroupnm(
    IN langcode character varying,
    IN userno integer,
    IN parentno integer,
    INOUT groupnm character varying
) RETURNS SETOF record
AS $function$
DECLARE
    departno integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN



	RETURN QUERY
	select /* TOP 1 */ DepartNo=DepartNo from public."Organization_GetDepartmentsByUser"(UserNo) order by DepartNo ASC
	SELECT ( case when LangCode='EN' THEN Name_EN ELSE Name END) INTO groupnm from Organization_Departments
where ParentNo=edms_getgroupnm.parentno and Enabled = TRUE and DepartNo=DepartNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
