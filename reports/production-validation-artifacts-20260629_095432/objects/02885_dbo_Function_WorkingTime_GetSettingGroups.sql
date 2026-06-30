-- ─── FUNCTION: workingtime_getsettinggroups ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_getsettinggroups();
CREATE OR REPLACE FUNCTION public.workingtime_getsettinggroups(
) RETURNS TABLE(
    id text,
    name text,
    timein text,
    timeout text,
    lunchstart text,
    lunchend text,
    isaddlunch text,
    bin1 text,
    bout1 text,
    bin2 text,
    bout2 text,
    isb1 text,
    isb2 text,
    registeredid text,
    registereddate text,
    col16 text,
    col17 text,
    col18 text,
    col19 text,
    col20 text,
    col21 text,
    col22 text,
    userid text,
    nameu text,
    name_en text
)
AS $function$
BEGIN

	RETURN QUERY
	select G.Id, G.Name, g.TimeIn, g.TimeOut, G.LunchStart, G.LunchEnd, G.IsAddLunch, G.BIn1, G.BOut1
		,G.BIn2,G.BOut2, G.IsB1, G.IsB2,G.RegisteredId, G.RegisteredDate
		,COALESCE(G.Sun, 0) Sun
		,COALESCE(G.Mon, 0) Mon
		,COALESCE(G.Tue, 0) Tue
		,COALESCE(G.Wen, 0) Wen
		,COALESCE(G.Thur, 0) Thur
		,COALESCE(G.Fri, 0) Fri
		,COALESCE(G.Sat, 0) Sat
		, U.UserId, U.Name as NameU, U.Name_EN
	from WorkingTime_SettingGroup G
	LEFT JOIN Organization_Users U
	ON G.RegisteredId = U.USERNO
	WHERE COALESCE(G.STATUST,1) = 1
	ORDER BY G.RegisteredDate DESC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
