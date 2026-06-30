-- ─── FUNCTION: workingtimev2_gettimesperuser ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtimev2_gettimesperuser(integer);
CREATE OR REPLACE FUNCTION public.workingtimev2_gettimesperuser(
    p_uno integer
) RETURNS TABLE(
    v2no text,
    workingday text,
    userno text,
    regdate text,
    checkin text,
    checkout text,
    checkine text,
    checkoute text,
    col9 text,
    col10 text
)
AS $function$
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
