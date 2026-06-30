-- ─── PROCEDURE→FUNCTION: workingtime_getsettinggroups ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.workingtime_getsettinggroups();
CREATE OR REPLACE FUNCTION public.workingtime_getsettinggroups(
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
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
