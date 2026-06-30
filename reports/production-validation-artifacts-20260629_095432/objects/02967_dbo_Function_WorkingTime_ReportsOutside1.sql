-- ─── FUNCTION: workingtime_reportsoutside1 ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_reportsoutside1(integer, integer, integer, integer, character varying, character varying, character varying);
CREATE OR REPLACE FUNCTION public.workingtime_reportsoutside1(
    p_from integer,
    p_to integer,
    p_viewcount integer DEFAULT 50,
    p_index integer DEFAULT 1,
    p_sort character varying DEFAULT '0',
    p_name character varying DEFAULT '',
    p_address character varying DEFAULT ''
) RETURNS TABLE(
    col1 text
)
AS $function$
BEGIN

	with tb as(
		SELECT S.LocationNo
		   ,S.Name
		   ,S.Description
		   ,COALESCE(S.Latitude,'0') Latitude
		   ,COALESCE(S.Longitude,'0') Longitude
		   ,COALESCE(W.TotalVisited,0) TotalVisited
		   ,ROW_NUMBER() OVER ( ORDER BY (case when p_Sort = '0' then  S.LocationNo else W.TotalVisited end) desc) AS RowNum 
		FROM WorkingTime_LocationsOutside S
		LEFT JOIN 
		(
			SELECT LocationNo,COUNT(1) TotalVisited 
			FROM WorkingTime_Times T
			WHERE t.TimeType = 2  AND WorkingDay BETWEEN p_From AND p_To
			GROUP BY LocationNo
		) W ON S.LocationNo = W.LocationNo	
		WHERE (p_Name ='' OR LOWER(S.Name) ILIKE '%' || p_Name || '%') AND (p_Address ='' OR LOWER(S.Description) ILIKE '%' || p_Address || '%')
		AND COALESCE(W.TotalVisited,0) > 0
	),
	tbtotal as (
		select count(1) as Total from tb
	)
   RETURN QUERY
   SELECT (select Total from tbtotal) as Total ,rs.* 
   FROM tb RS WHERE RS.RowNum BETWEEN ((p_Index - 1)*p_ViewCount) AND (p_Index*p_ViewCount)
	ORDER BY (case when p_Sort = '0' then  RS.LocationNo else rs.TotalVisited end) desc;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
