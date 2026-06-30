-- ─── PROCEDURE→FUNCTION: workingtime_getlocationlist ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.workingtime_getlocationlist(integer, integer, integer, integer);
CREATE OR REPLACE FUNCTION public.workingtime_getlocationlist(
    IN reguser integer,
    IN currpage integer DEFAULT 1,
    IN recodperpage integer DEFAULT 20,
    IN type integer DEFAULT 0
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	IF type=0 THEN
			WITH s AS
				(
					SELECT ROW_NUMBER() 
						OVER(ORDER BY id DESC) AS RowNum,id,name,dayadd,timeadd,distance,lat,lng,
						(SELECT COUNT(*) FROM WorkingTime_LocationList	WHERE userno=workingtime_getlocationlist.reguser) as counts
					FROM WorkingTime_LocationList
			
					WHERE userno=workingtime_getlocationlist.reguser 				  
				)
				RETURN QUERY
				Select * From s 
				
		END IF;
	IF type=2 THEN
				WITH s AS
					(
						SELECT ROW_NUMBER() 
							OVER(ORDER BY id DESC) AS RowNum,id,name,dayadd,timeadd,distance,lat,lng,
							(SELECT COUNT(*) FROM WorkingTime_LocationList	WHERE userno=workingtime_getlocationlist.reguser) as counts
						FROM WorkingTime_LocationList
			
						WHERE userno=workingtime_getlocationlist.reguser AND  	name ILIKE '%' || textsearch || '%'
					)
					RETURN QUERY
					Select * From s 
				
			END IF;
			IF type=3 THEN
						WITH s AS
							(
								SELECT ROW_NUMBER() 
									OVER(ORDER BY id DESC) AS RowNum,id,name,dayadd,timeadd,distance,lat,lng,
									(SELECT COUNT(*) FROM WorkingTime_LocationList	WHERE userno=workingtime_getlocationlist.reguser) as counts
								FROM WorkingTime_LocationList
			
								WHERE userno=workingtime_getlocationlist.reguser AND  	name ILIKE '%' || textsearch || '%'	  
							)
							RETURN QUERY
							Select * From s 
						
					END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
