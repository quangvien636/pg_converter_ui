-- ─── FUNCTION: noticesyn_updateimportant ───────────────────────────────
DROP FUNCTION IF EXISTS public.noticesyn_updateimportant(integer, boolean);
CREATE OR REPLACE FUNCTION public.noticesyn_updateimportant(
    noticeno integer,
    important boolean
) RETURNS void
AS $function$
BEGIN


	UPDATE NoticesSyn
	SET Important = noticesyn_updateimportant.important,
	IsImportant= FALSE
	WHERE  NoticeNo = noticesyn_updateimportant.noticeno 
	
END;
--------------------------///////////////////////////////////-----------------------

-- USE CrewCloud_Core
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
