-- ─── PROCEDURE→FUNCTION: noticesyn_deletecontentimg ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.noticesyn_deletecontentimg(integer);
CREATE OR REPLACE FUNCTION public.noticesyn_deletecontentimg(
    IN noticeno integer
) RETURNS void
AS $function$
BEGIN

	DELETE FROM NoticeSyn_ContentImgs
	WHERE NoticeNo = noticesyn_deletecontentimg.noticeno
END;
-----------------------------///////////////////////////--------------
--USE CrewCloud_Core
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
