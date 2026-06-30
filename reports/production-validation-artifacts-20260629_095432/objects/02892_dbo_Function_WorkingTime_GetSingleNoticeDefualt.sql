-- ─── FUNCTION: workingtime_getsinglenoticedefualt ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_getsinglenoticedefualt(integer);
CREATE OR REPLACE FUNCTION public.workingtime_getsinglenoticedefualt(
    noticeno integer
) RETURNS TABLE(
    noticeno integer,
    reguserno integer,
    regdate timestamp without time zone,
    timetype integer,
    content character varying(500),
    content_ko character varying(500),
    content_vn character varying(500)
)
AS $function$
BEGIN

		RETURN QUERY
		SELECT * FROM WorkingTime_DefaultNotices
		WHERE NoticeNo=workingtime_getsinglenoticedefualt.noticeno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
