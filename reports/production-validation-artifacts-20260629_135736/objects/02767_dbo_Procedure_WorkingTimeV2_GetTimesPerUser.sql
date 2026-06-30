-- ─── PROCEDURE→FUNCTION: workingtimev2_gettimesperuser ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.workingtimev2_gettimesperuser(integer);
CREATE OR REPLACE FUNCTION public.workingtimev2_gettimesperuser(
    IN p_uno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	RETURN QUERY
	SELECT T.V2No
	    , WORKDAY as WorkingDay
		, T.UserNo
		, T.RegDate
		, T.CheckIn
		,T.CheckOut
		,T.CheckIne
		,T.CheckOute
		,COALESCE(T.TypeNo,0) TypeNo
		,COALESCE(TY.TypeName,'') TypeName
	FROM WorkingTimeV2_Times  T
	LEFT JOIN WorkingTimeV2_Types TY ON T.TypeNo = TY.TypeNo
	WHERE T.UserNo = workingtimev2_gettimesperuser.p_uno AND LEFT(T.WORKDAY,6) = p_month;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
