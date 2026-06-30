-- ─── FUNCTION: noticesyn_mobile_getlistofreference ───────────────────────────────
DROP FUNCTION IF EXISTS public.noticesyn_mobile_getlistofreference(integer);
CREATE OR REPLACE FUNCTION public.noticesyn_mobile_getlistofreference(
    noticeno integer
) RETURNS TABLE(
    referenceno text,
    userid text,
    readdate text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT ReferenceNo, UserID, ReadDate
	FROM NoticeSyn_Reference
	WHERE NoticeNo = noticesyn_mobile_getlistofreference.noticeno

END;
---------------------------////////////////////////----------------
-- USE CrewCloud_Core
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
