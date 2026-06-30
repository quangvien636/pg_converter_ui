-- ─── FUNCTION: workingtime_getsinglenotice ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_getsinglenotice(integer);
CREATE OR REPLACE FUNCTION public.workingtime_getsinglenotice(
    noticeno integer
) RETURNS TABLE(
    noticeno serial,
    reguserno integer,
    regdate timestamp without time zone,
    timetype integer,
    startdate date,
    enddate date,
    content character varying(500),
    content_ko character varying(500),
    content_vn character varying(500),
    locationno integer
)
AS $function$
BEGIN

	RETURN QUERY
	SELECT * FROM WorkingTime_Notices
	WHERE NoticeNo=workingtime_getsinglenotice.noticeno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
