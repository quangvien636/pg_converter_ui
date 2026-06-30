-- ─── PROCEDURE→FUNCTION: approval_insertform ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.approval_insertform(integer, timestamp without time zone, character varying, integer, integer);
CREATE OR REPLACE FUNCTION public.approval_insertform(
    IN reguserno integer,
    IN regdate timestamp without time zone,
    IN name character varying,
    IN categoryno integer,
    IN filetype integer
) RETURNS SETOF record
AS $function$
DECLARE
    formno integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	INSERT INTO Approval_Forms (RegUserNo, RegDate, ModUserNo, ModDate, Name, CategoryNo, FileType, Description)
	VALUES (RegUserNo, RegDate, RegUserNo, RegDate, Name, CategoryNo, FileType, Description)


	FormNo := lastval();
	RETURN QUERY
	SELECT FormNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
