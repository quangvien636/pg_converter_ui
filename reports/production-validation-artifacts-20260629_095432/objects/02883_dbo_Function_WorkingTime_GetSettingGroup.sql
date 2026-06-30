-- ─── FUNCTION: workingtime_getsettinggroup ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_getsettinggroup(integer);
CREATE OR REPLACE FUNCTION public.workingtime_getsettinggroup(
    p_id integer
) RETURNS TABLE(
    id text,
    name text,
    timein text,
    timeout text,
    lunchstart text,
    lunchend text,
    isaddlunch text,
    bin1 text,
    bin2 text,
    bout1 text,
    bout2 text,
    isb1 text,
    isb2 text,
    registeredid text,
    registereddate text,
    userid text,
    col17 text,
    col18 text,
    col19 text,
    col20 text,
    col21 text,
    col22 text,
    col23 text
)
AS $function$
BEGIN

	RETURN QUERY
	select G.Id, G.Name, g.TimeIn, g.TimeOut, G.LunchStart, G.LunchEnd, G.IsAddLunch, G.BIn1, G.BIn2, G.BOut1
		,G.BOut2, G.IsB1, G.IsB2,G.RegisteredId, G.RegisteredDate
		, U.UserId
		,COALESCE(G.Sun, 0) Sun
		,COALESCE(G.Mon, 0) Mon
		,COALESCE(G.Tue, 0) Tue
		,COALESCE(G.Wen, 0) Wen
		,COALESCE(G.Thur, 0) Thur
		,COALESCE(G.Fri, 0) Fri
		,COALESCE(G.Sat, 0) Sat
	from WorkingTime_SettingGroup G
	LEFT JOIN Organization_Users U
	ON G.RegisteredId = U.USERNO
	WHERE id = workingtime_getsettinggroup.p_id;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
