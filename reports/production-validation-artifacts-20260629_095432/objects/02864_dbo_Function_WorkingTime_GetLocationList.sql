-- ─── FUNCTION: workingtime_getlocationlist ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_getlocationlist(integer, integer, integer, integer);
CREATE OR REPLACE FUNCTION public.workingtime_getlocationlist(
    reguser integer,
    currpage integer DEFAULT 1,
    recodperpage integer DEFAULT 20,
    type integer DEFAULT 0
) RETURNS TABLE(
    id serial,
    name character varying(250),
    dayadd integer,
    timeadd character varying(250),
    distance double precision,
    lat double precision,
    lng double precision,
    userno integer
)
AS $function$
BEGIN

	IF type=0
		BEGIN
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
				
		END
	IF type=2
		    BEGIN
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
				
			END
			IF type=3
					BEGIN
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
						
					END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
