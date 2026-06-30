-- ─── PROCEDURE→FUNCTION: organization_insertbelongtodepartment ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.organization_insertbelongtodepartment(integer, integer, integer, integer, boolean);
CREATE OR REPLACE FUNCTION public.organization_insertbelongtodepartment(
    IN userno integer,
    IN departno integer,
    IN positionno integer,
    IN dutyno integer,
    IN isdefault boolean
) RETURNS SETOF record
AS $function$
DECLARE
    belongno bigint;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	INSERT INTO Organization_BelongToDepartment (UserNo, DepartNo, PositionNo, DutyNo, IsDefault)
	VALUES (UserNo, DepartNo, PositionNo, DutyNo, IsDefault)


	BelongNo := lastval();
	RETURN QUERY
	SELECT BelongNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
