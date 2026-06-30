-- ─── FUNCTION: bslg_getschmlog ───────────────────────────────
DROP FUNCTION IF EXISTS public.bslg_getschmlog(character varying, character varying);
CREATE OR REPLACE FUNCTION public.bslg_getschmlog(
    userid character varying,
    date character varying
) RETURNS TABLE(
    seq text,
    title text,
    content text,
    writer text,
    opentype text,
    divide text,
    kind text,
    smsyn text,
    smssdate text,
    startdate text,
    starttime text,
    lmonth text,
    enddate text,
    lweekseq text,
    endtime text,
    lweek text,
    ldaily text
)
AS $function$
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	RETURN QUERY
	SELECT SM.Seq, Title, Content, Writer, OpenType, Divide, Kind, smsYN,  smsSDate, StartDate, StartTime, LMonth, EndDate, LWeekSeq, EndTime,  LWeek, LDaily
	FROM schmmaster SM 
	WHERE EndDate >= bslg_getschmlog.date and StartDate <= bslg_getschmlog.date and  Divide ILIKE '%S%' AND Writer = bslg_getschmlog.userid
	Order by StartTime;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
