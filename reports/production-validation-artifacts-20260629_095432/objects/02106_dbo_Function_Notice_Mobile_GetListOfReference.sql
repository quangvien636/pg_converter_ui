-- ─── FUNCTION: notice_mobile_getlistofreference ───────────────────────────────
DROP FUNCTION IF EXISTS public.notice_mobile_getlistofreference(integer);
CREATE OR REPLACE FUNCTION public.notice_mobile_getlistofreference(
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
	FROM NoticeReference
	WHERE NoticeNo = notice_mobile_getlistofreference.noticeno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
