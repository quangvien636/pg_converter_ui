-- ─── PROCEDURE→FUNCTION: noticesyn_updateimportant ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.noticesyn_updateimportant(integer, boolean);
CREATE OR REPLACE FUNCTION public.noticesyn_updateimportant(
    IN noticeno integer,
    IN important boolean
) RETURNS void
AS $function$
BEGIN


	UPDATE NoticesSyn
	Important := noticesyn_updateimportant.important,;
	IsImportant= FALSE
	WHERE  NoticeNo = noticesyn_updateimportant.noticeno 
	
END;
--------------------------///////////////////////////////////-----------------------

-- USE CrewCloud_Core
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
