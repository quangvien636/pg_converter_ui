-- ─── PROCEDURE→FUNCTION: workingtime_getsettinggroup ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.workingtime_getsettinggroup(integer);
CREATE OR REPLACE FUNCTION public.workingtime_getsettinggroup(
    IN p_id integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
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
