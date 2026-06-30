-- ─── PROCEDURE→FUNCTION: vacation_getrequestsearchs ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.vacation_getrequestsearchs(integer, character varying, integer, integer, character varying, character varying, character varying);
CREATE OR REPLACE FUNCTION public.vacation_getrequestsearchs(
    IN p_y integer,
    IN p_uname character varying DEFAULT '',
    IN p_dno integer DEFAULT 0,
    IN p_type integer DEFAULT 0,
    IN p_lang character varying DEFAULT 'KO',
    IN p_from character varying DEFAULT '2021-01-01',
    IN p_to character varying DEFAULT '2040-06-23'
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	SELECT 
			R.RequestId
		, U.UserID
		, U.Name
		, T.Typei
		, COALESCE(T.Name,'') as TypeName
		, T.TypeId
		, R.UserNo
		, R.Fromd
		, R.Tod
		, COALESCE(R.VacationsCount,0) VacationsCount
		, R.Note
		, R.DateCreate
		, COALESCE(R.StatusUser,0) StatusUser
		, COALESCE(R.StatusAdmin,0) StatusAdmin
		------------------------
		--total used
		, X3.Used + COALESCE(v.Used,0) as Used
		--total unused
		, COALESCE(V.Vacations,0) + COALESCE(X2.TimeDis,0)  AS Vacations
		,T.TimeDis
		, COALESCE(T.OffType,-1) OffType
	FROM  Vacation_Requests R
	LEFT JOIN Vacation_Vacations v ON R.UserNo = V.UserNo and v.years = vacation_getrequestsearchs.p_y 
	left join Vacation_Types T on R.TypeId = T.TypeId
	INNER JOIN Organization_Users U  ON U.UserNo = R.UserNo AND U.IsVirtual = FALSE
	LEFT JOIN Vacation_Sum X2 ON u.UserNo =  x2.UsernoI AND X2.YEARS =  vacation_getrequestsearchs.p_y
	LEFT JOIN Vacation_SumRequest X3 ON V.UserNo =  X3.UserNo and x3.years = vacation_getrequestsearchs.p_y
	WHERE  R.StatusAdmin != 1
	AND (p_UName = '' OR LOWER(U.Name) ILIKE '%' || p_UName || '%' OR LOWER(U.UserID) = '%' || p_UName || '%')
	AND ( R.Fromd >= vacation_getrequestsearchs.p_from AND R.Tod <= vacation_getrequestsearchs.p_to)
	AND (p_Type=0 OR T.TypeId = vacation_getrequestsearchs.p_type);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
