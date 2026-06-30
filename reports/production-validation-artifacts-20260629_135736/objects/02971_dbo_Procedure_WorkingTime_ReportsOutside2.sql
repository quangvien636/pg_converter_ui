-- ─── PROCEDURE→FUNCTION: workingtime_reportsoutside2 ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.workingtime_reportsoutside2(integer, integer, integer, integer, character varying, character varying, character varying);
CREATE OR REPLACE FUNCTION public.workingtime_reportsoutside2(
    IN p_from integer,
    IN p_to integer,
    IN p_viewcount integer DEFAULT 50,
    IN p_index integer DEFAULT 1,
    IN p_sort character varying DEFAULT '0',
    IN p_name character varying DEFAULT '',
    IN p_address character varying DEFAULT ''
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
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
		AND COALESCE(W.TotalVisited,0) <= 0
	),
	tbtotal as (
		select count(1) as Total from tb
	)
   RETURN QUERY
   SELECT (select Total from tbtotal) as Total ,rs.* 
   FROM tb RS WHERE RS.RowNum BETWEEN ((p_Index - 1)*p_ViewCount+1) AND (p_Index*p_ViewCount)
	ORDER BY (case when p_Sort = '0' then  RS.LocationNo else rs.TotalVisited end) desc;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
