-- ─── PROCEDURE→FUNCTION: workingtime_getlocationoutsidessearch ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.workingtime_getlocationoutsidessearch(timestamp without time zone, timestamp without time zone, integer, character varying, integer, integer);
CREATE OR REPLACE FUNCTION public.workingtime_getlocationoutsidessearch(
    IN p_start timestamp without time zone,
    IN p_end timestamp without time zone,
    IN p_type integer,
    IN p_search character varying DEFAULT '',
    IN p_index integer DEFAULT 1,
    IN p_size integer DEFAULT 20
) RETURNS void
AS $function$
BEGIN


	
	CREATE TEMP TABLE TAM AS SELECT W.LocationNo, W.RegUserNo, W.RegDate, W.ModUserNo, W.ModDate, W.Name, W.Latitude, W.Longitude, W.ErrorRange,W.Representation,W.PhoneNumber, Description, w.Enabled,
			U.NAME AS UseName,
			u.Name_EN,
			ROW_NUMBER() OVER ( ORDER BY W.LocationNo desc) AS RowNum FROM WorkingTime_LocationsOutside w
	LEFT JOIN Organization_Users U ON W.RegUserNo = U .UserNo
	WHERE w.RegDate between p_Start and p_End AND
	 ( p_type = 0
		AND ( W.NAME ILIKE '%' || p_search || '%'
				OR W.DESCRIPTION ILIKE '%' || p_search || '%'  OR U.NAME ILIKE '%' || p_search || '%' OR  u.Name_EN ILIKE '%' || p_search || '%'
			)       
	) 
	or (    p_type = 1
		AND W.NAME ILIKE '%' || p_search || '%'
	)
	or ( p_type = 2
		AND W.DESCRIPTION ILIKE '%' || p_search || '%'
	)
	or ( p_type = 3
		AND (U.NAME ILIKE '%' || p_search || '%' OR  u.Name_EN ILIKE '%' || p_search || '%')
	)
	--Order by w.LocationNo desc

	_TOTAL := (SELECT COUNT(1)  FROM TAM);
	SELECT *, _TOTAL AS Total 
	FROM TAM RS
	WHERE RS.RowNum BETWEEN ((p_index - 1)*p_size+1) AND (p_index*p_size)
	ORDER BY RS.LocationNo desc;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
