-- ─── PROCEDURE→FUNCTION: organization_insertinfoaddfield ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.organization_insertinfoaddfield(integer, integer, character varying, character varying, integer, boolean, boolean, boolean);
CREATE OR REPLACE FUNCTION public.organization_insertinfoaddfield(
    IN userno integer,
    IN moduserno integer,
    IN code character varying,
    IN name character varying,
    IN type integer,
    IN modauth boolean,
    IN enabled boolean,
    IN display boolean
) RETURNS SETOF record
AS $function$
DECLARE
    no integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	INSERT INTO Organization_Users_InfoAddfield (UserNo,RegDate,ModUserNo,ModDate,Code,Name,Type,SortNo,ModAuth,Enabled,DisPlay)
	VALUES (UserNo,NOW(),ModUserNo,NOW(),Code,Name,Type,
	(SELECT COALESCE(MAX(SortNo),0) + 1 FROM Organization_Users_InfoAddfield)
	,ModAuth,Enabled,DisPlay)


	No := lastval();
	RETURN QUERY
	SELECT No;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
