-- ─── PROCEDURE→FUNCTION: noticesyn_setfiles ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.noticesyn_setfiles(integer, character varying, integer, character varying);
CREATE OR REPLACE FUNCTION public.noticesyn_setfiles(
    IN noticeno integer,
    IN filename character varying,
    IN filelength integer,
    IN filepath character varying
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	IF Mode = '0' THEN;
		INSERT INTO NoticeSyn_Attachments(NoticeNo,FileName,FileLength,FilePath)
		VALUES(NoticeNo,FileName,FileLength,FilePath)
	END IF;
	ELSE;
		DELETE FROM NoticeSyn_Attachments WHERE NoticeNo = noticesyn_setfiles.noticeno
	END IF;
	
	RETURN QUERY
	SELECT @ERROR
END;
--------------------------- ///////////////////--------------------------
-- USE CrewCloud_Core
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
