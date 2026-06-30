-- ─── FUNCTION: notice_countreadbyuser ───────────────────────────────
DROP FUNCTION IF EXISTS public.notice_countreadbyuser(integer, boolean);
CREATE OR REPLACE FUNCTION public.notice_countreadbyuser(
    noticeno integer,
    isshare boolean
) RETURNS integer
AS $function$
BEGIN



		SELECT count = COUNT(N.NoticeNo) FROM NoticeReference N WHERE N.NoticeNo = notice_countreadbyuser.noticeno

	return count;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
