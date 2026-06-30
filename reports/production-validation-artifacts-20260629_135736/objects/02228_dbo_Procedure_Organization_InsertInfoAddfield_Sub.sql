-- ─── PROCEDURE→FUNCTION: organization_insertinfoaddfield_sub ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.organization_insertinfoaddfield_sub(integer, integer, integer, character varying, character varying, boolean);
CREATE OR REPLACE FUNCTION public.organization_insertinfoaddfield_sub(
    IN no integer,
    IN userno integer,
    IN moduserno integer,
    IN code character varying,
    IN name character varying,
    IN enabled boolean
) RETURNS SETOF record
AS $function$
DECLARE
    nosub integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	INSERT INTO Organization_Users_InfoAddfield_Sub (UserNo,No,RegDate,ModUserNo,ModDate,Code,Name,SortNo,Enabled)
	VALUES (UserNo,No,NOW(),ModUserNo,NOW(),Code,Name,
	(SELECT COALESCE(MAX(SortNo),0) + 1 FROM Organization_Users_InfoAddfield_Sub)
	,Enabled)


	NoSub := lastval();
	RETURN QUERY
	SELECT NoSub;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
