-- ─── PROCEDURE→FUNCTION: noticesyn_getattachinfo ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.noticesyn_getattachinfo(integer);
CREATE OR REPLACE FUNCTION public.noticesyn_getattachinfo(
    IN attachno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	RETURN QUERY
	SELECT AttachNo,NoticeNo,FileName,FileLength,FilePath FROM NoticeSyn_Attachments
	WHERE AttachNo = noticesyn_getattachinfo.attachno
END;
-------------------------------////////////////////////////////////////////------------
--USE CrewCloud_Core
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
