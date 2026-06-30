-- ─── PROCEDURE→FUNCTION: noticesyn_getfiles ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.noticesyn_getfiles(integer);
CREATE OR REPLACE FUNCTION public.noticesyn_getfiles(
    IN noticeno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	RETURN QUERY
	SELECT AttachNo,FileName,FileLength,FilePath FROM NoticeSyn_Attachments
	WHERE NoticeNo=noticesyn_getfiles.noticeno
	ORDER BY AttachNo
END;
---------------------------//////////////////////////----------
-- USE CrewCloud_Core
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
