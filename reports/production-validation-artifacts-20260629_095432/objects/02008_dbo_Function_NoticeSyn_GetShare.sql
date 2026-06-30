-- ─── FUNCTION: noticesyn_getshare ───────────────────────────────
DROP FUNCTION IF EXISTS public.noticesyn_getshare(integer);
CREATE OR REPLACE FUNCTION public.noticesyn_getshare(
    noticeno integer
) RETURNS TABLE(
    departno text,
    departname text,
    ischild text
)
AS $function$
BEGIN

	RETURN QUERY
	SELECT DepartNo,DepartName,IsChild FROM NoticeSyn_Sharers WHERE NoticeNo = noticesyn_getshare.noticeno
END;
--------------------------------
-- USE CrewCloud_Core
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
