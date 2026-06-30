-- ─── PROCEDURE→FUNCTION: note_getlistnotesmaps ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
-- TODO: TOP was preserved as comment; add LIMIT manually
DROP FUNCTION IF EXISTS public.note_getlistnotesmaps(integer, uuid, integer, double precision, double precision, double precision, double precision);
CREATE OR REPLACE FUNCTION public.note_getlistnotesmaps(
    IN userno integer,
    IN groupno uuid,
    IN pagesize integer,
    IN lat1 double precision,
    IN lng1 double precision,
    IN from double precision DEFAULT 0,
    IN to double precision DEFAULT 2000
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	IF GroupNo = '00000000-0000-0000-0000-000000000000' THEN
		RETURN QUERY
		SELECT * FROM (
			SELECT	ROW_NUMBER() OVER (ORDER BY N.DayEdit DESC) AS RowNumber
			,N.ListNo ,N.Name
			,CASE WHEN UserNo =  N.UserNo  THEN  N.GroupNo 
					ELSE COALESCE((  SELECT /* TOP 1 */ GroupNo
									FROM Note_Share
									WHERE UserShare = note_getlistnotesmaps.userno 
									AND ListNo = N.ListNo
									),Null)
			  END AS GroupNo
			,N.UserNo,N.Description,N.Latitude,N.Longitude,N.DayCreate,N.DayEdit,N.NoteTimeZoneCreate,N.NoteTimeZoneEdit
			,(public."DictanceKM"(lat1,lng1,N.Latitude, N.Longitude)*1000) AS Calcutordistance
			,CASE WHEN UserNo =  N.UserNo  THEN  TRUE 
					ELSE COALESCE((  SELECT /* TOP 1 */ IsReads
									FROM Note_Share
									WHERE UserShare = note_getlistnotesmaps.userno 
									AND ListNo = N.ListNo
									),0)
			  END AS IsRead
			 ,CASE WHEN   UserNo =  N.UserNo THEN COALESCE(N.ReadDate, N.DayCreate)
					ELSE COALESCE((  SELECT /* TOP 1 */ ReadDate
									FROM Note_Share
									WHERE UserShare = note_getlistnotesmaps.userno 
									AND ListNo = N.ListNo
									),0)
			  END AS ReadDate
			 ,CASE WHEN UserNo =  N.UserNo  THEN  N.FavoriteType 
					ELSE COALESCE((  SELECT /* TOP 1 */ FavoriteType
									FROM Note_Share
									WHERE UserShare = note_getlistnotesmaps.userno 
									AND ListNo = N.ListNo
									),0)
			  END AS FavoriteType
			  ,CASE WHEN UserNo =  N.UserNo  THEN  0
					ELSE 1
			  END AS isAttach

		  FROM  Note_List N  INNER JOIN
                 public."Organization_Users" O ON N.UserNo = O.UserNo
		  WHERE (N.UserNo = note_getlistnotesmaps.userno OR N.ListNo IN (select S.ListNo from Note_Share S where S.UserShare = note_getlistnotesmaps.userno AND S.UserNo <> note_getlistnotesmaps.userno))
					AND N.Show = 1 
					AND ((ROUND(public."DictanceKM"(lat1,lng1,N.Latitude, N.Longitude),0)*1000) BETWEEN from AND to)
			) AS t
		WHERE  t.RowNumber BETWEEN RowStart and PageSize
		ORDER BY  DayEdit DESC
	END IF;
	ELSE
		RETURN QUERY
		SELECT * FROM (
			SELECT	ROW_NUMBER() OVER (ORDER BY N.DayEdit DESC) AS RowNumber
			,N.ListNo ,N.Name
			,CASE WHEN UserNo =  N.UserNo  THEN  N.GroupNo 
					ELSE COALESCE((  SELECT /* TOP 1 */ GroupNo
									FROM Note_Share
									WHERE UserShare = note_getlistnotesmaps.userno 
									AND ListNo = N.ListNo
									),Null)
			  END AS GroupNo
			,N.UserNo,N.Description,N.Latitude,N.Longitude,N.DayCreate,N.DayEdit,N.NoteTimeZoneCreate,N.NoteTimeZoneEdit
			,(public."DictanceKM"(lat1,lng1,N.Latitude, N.Longitude)*1000) AS Calcutordistance
			,CASE WHEN UserNo =  N.UserNo  THEN  TRUE 
					ELSE COALESCE((  SELECT /* TOP 1 */ IsReads
									FROM Note_Share
									WHERE UserShare = note_getlistnotesmaps.userno 
									AND ListNo = N.ListNo
									),0)
			  END AS IsRead
			 ,CASE WHEN   UserNo =  N.UserNo THEN COALESCE(N.ReadDate, N.DayCreate)
					ELSE COALESCE((  SELECT /* TOP 1 */ ReadDate
									FROM Note_Share
									WHERE UserShare = note_getlistnotesmaps.userno 
									AND ListNo = N.ListNo
									),0)
			  END AS ReadDate
			 ,CASE WHEN UserNo =  N.UserNo  THEN  N.FavoriteType 
					ELSE COALESCE((  SELECT /* TOP 1 */ FavoriteType
									FROM Note_Share
									WHERE UserShare = note_getlistnotesmaps.userno 
									AND ListNo = N.ListNo
									),0)
			  END AS FavoriteType
			  ,CASE WHEN UserNo =  N.UserNo  THEN  0
					ELSE 1
			  END AS isAttach

		  FROM  Note_List N  INNER JOIN
                 public."Organization_Users" O ON N.UserNo = O.UserNo
		  WHERE  (N.UserNo = note_getlistnotesmaps.userno OR  N.ListNo IN (select S.ListNo from Note_Share S where S.UserShare = note_getlistnotesmaps.userno AND S.UserNo <> note_getlistnotesmaps.userno))
					AND N.Show = 1 
					AND ((ROUND(public."DictanceKM"(lat1,lng1,N.Latitude, N.Longitude),0)*1000) BETWEEN from AND to)
					AND (N.GroupNo = note_getlistnotesmaps.groupno OR N.ListNo IN (SELECT ListNo FROM Note_Share WHERE GroupNo = note_getlistnotesmaps.groupno AND UserShare = note_getlistnotesmaps.userno))
			) as t
		WHERE  t.RowNumber BETWEEN RowStart and PageSize
		ORDER BY DayEdit  DESC
	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
