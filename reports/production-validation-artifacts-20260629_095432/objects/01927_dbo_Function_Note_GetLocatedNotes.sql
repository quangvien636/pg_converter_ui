-- ─── FUNCTION: note_getlocatednotes ───────────────────────────────
DROP FUNCTION IF EXISTS public.note_getlocatednotes(integer, uuid, character varying, character varying, integer, integer, integer, double precision, double precision, integer);
CREATE OR REPLACE FUNCTION public.note_getlocatednotes(
    userno integer,
    listno uuid,
    groupno character varying,
    textsearch character varying,
    pagesize integer,
    type integer,
    sorttype integer,
    lat1 double precision,
    lng1 double precision,
    favoritetype integer DEFAULT -1
) RETURNS TABLE(
    listno text
)
-- TODO: TOP was preserved as comment; add LIMIT manually
-- TODO: LEN was not fully converted; use length()
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	IF CAST(ListNo as varchar(64)) = '00000000-0000-0000-0000-000000000000'
	BEGIN
		RETURN QUERY
		SELECT * FROM (
			SELECT	ROW_NUMBER() OVER (ORDER BY  CASE Sorttype WHEN 0 THEN N.DayEdit END DESC
										,CASE Sorttype WHEN 1 THEN public."DictanceKM"(lat1,lng1, N.Latitude, N.Longitude) END) AS RowNumber
			,N.ListNo ,N.Name
			,CASE WHEN UserNo =  N.UserNo  THEN  N.GroupNo 
					ELSE COALESCE((  SELECT /* TOP 1 */ GroupNo
									FROM Note_Share
									WHERE UserShare = note_getlocatednotes.userno 
									AND ListNo = N.ListNo
									),Null)
			  END AS GroupNo
			,N.UserNo,N.Description,N.Latitude,N.Longitude,N.DayCreate,N.DayEdit,N.NoteTimeZoneCreate,N.NoteTimeZoneEdit
			,public."DictanceKM"(lat1,lng1,N.Latitude, N.Longitude) AS Calcutordistance
			,CASE WHEN UserNo =  N.UserNo  THEN  TRUE 
					ELSE COALESCE((  SELECT /* TOP 1 */ IsReads
									FROM Note_Share
									WHERE UserShare = note_getlocatednotes.userno 
									AND ListNo = N.ListNo
									),0)
			  END AS IsRead
			 ,CASE WHEN   UserNo =  N.UserNo THEN  COALESCE(N.ReadDate, N.DayCreate)
					ELSE COALESCE((  SELECT /* TOP 1 */ ReadDate
									FROM Note_Share
									WHERE UserShare = note_getlocatednotes.userno 
									AND ListNo = N.ListNo
									),0)
			  END AS ReadDate
			 ,CASE WHEN UserNo =  N.UserNo  THEN  N.FavoriteType 
					ELSE COALESCE((  SELECT /* TOP 1 */ FavoriteType
									FROM Note_Share
									WHERE UserShare = note_getlocatednotes.userno 
									AND ListNo = N.ListNo
									),0)
			  END AS FavoriteType
			  ,CASE WHEN UserNo =  N.UserNo  THEN  COALESCE((SELECT count(AttachmentNo) FROM Note_Attachment where ListNo = N.ListNo and UserNo <> note_getlocatednotes.userno),0)
					ELSE COALESCE((SELECT count(AttachmentNo) FROM Note_Attachment where ListNo = N.ListNo and UserNo = note_getlocatednotes.userno),0)
			  END AS isAttach
			  
		  FROM  Note_List N  INNER JOIN
                 public."Organization_Users" O ON N.UserNo = O.UserNo
		  WHERE (CASE Type WHEN 0 THEN N.UserNo 
				   WHEN 1 THEN N.UserNo 
				END = note_getlocatednotes.userno 
			  OR CASE Type WHEN 0 THEN N.ListNo 
							WHEN 2 THEN N.ListNo 
					END in (select S.ListNo from Note_Share S where S.UserShare = note_getlocatednotes.userno AND S.UserNo <> note_getlocatednotes.userno))
					AND N.Show = 1 
					AND (N.Description ILIKE '%' || TextSearch || '%' OR O.Name ILIKE '%' || TextSearch || '%' OR O.Name_EN ILIKE '%' || TextSearch || '%' OR N.Name ILIKE '%' || TextSearch || '%'
						 OR public."fVietnameseAccentFilters"(N.Description) ILIKE '%' || TextSearch || '%' 
						 OR public."fVietnameseAccentFilters"(O.Name) ILIKE '%' || TextSearch || '%' 
						 OR public."fVietnameseAccentFilters"(O.Name_EN) ILIKE '%' || TextSearch || '%' 
						 OR public."fVietnameseAccentFilters"(N.Name) ILIKE '%' || TextSearch || '%'
						OR CONVERT(varchar(25), N.DayEdit , 101)  ILIKE '%' || TextSearch || '%'
						OR CONVERT(varchar(25), N.DayEdit , 102)  ILIKE '%' || TextSearch || '%'
						OR CONVERT(varchar(25), N.DayEdit , 103)  ILIKE '%' || TextSearch || '%'
						OR CONVERT(varchar(25), N.DayEdit , 104)  ILIKE '%' || TextSearch || '%'
						OR CONVERT(varchar(25), N.DayEdit , 105)  ILIKE '%' || TextSearch || '%'
						OR CONVERT(varchar(25), N.DayEdit , 106)  ILIKE '%' || TextSearch || '%'
						OR CONVERT(varchar(25), N.DayEdit , 107)  ILIKE '%' || TextSearch || '%'
						OR CONVERT(varchar(25), N.DayEdit , 1)  ILIKE '%' || TextSearch || '%'
						OR CONVERT(varchar(25), N.DayEdit , 2)  ILIKE '%' || TextSearch || '%'
						OR CONVERT(varchar(25), N.DayEdit , 3)  ILIKE '%' || TextSearch || '%'
						OR CONVERT(varchar(25), N.DayEdit , 4)  ILIKE '%' || TextSearch || '%'
						OR CONVERT(varchar(25), N.DayEdit , 5)  ILIKE '%' || TextSearch || '%'
						OR CONVERT(varchar(25), N.DayEdit , 6)  ILIKE '%' || TextSearch || '%'
						OR CONVERT(varchar(25), N.DayEdit , 7)  ILIKE '%' || TextSearch || '%'
						OR CONVERT(varchar(25), N.DayEdit , 110)  ILIKE '%' || TextSearch || '%'
						OR CONVERT(varchar(25), N.DayEdit , 111)  ILIKE '%' || TextSearch || '%'
						OR CONVERT(varchar(25), N.DayEdit , 10)  ILIKE '%' || TextSearch || '%'
						OR CONVERT(varchar(25), N.DayEdit , 11)  ILIKE '%' || TextSearch || '%'
						OR public."DictanceKM"(lat1,lng1,N.Latitude, N.Longitude) ILIKE TextSearch || '%'
						OR ROUND(public."DictanceKM"(lat1,lng1,N.Latitude, N.Longitude),0) BETWEEN (
							CASE ISNUMERIC(REPLACE(TextSearch,',','.')) WHEN 1 THEN  CAST(REPLACE(TextSearch,',','.') AS float)
							ELSE (CASE WHEN RIGHT(LOWER(TextSearch),2) = 'km' THEN (CAST(SUBSTRING(REPLACE(TextSearch,',','.'),0,LEN(TextSearch)-1) AS float) * 1000) 
									   WHEN RIGHT(LOWER(TextSearch),1) = 'm' THEN (CAST(SUBSTRING(REPLACE(TextSearch,',','.'),0,LEN(TextSearch)) AS float)) 
								END)
							END) AND (
							CASE ISNUMERIC(REPLACE(TextSearch,',','.')) WHEN 1 THEN  CAST(REPLACE(TextSearch,',','.') AS float)
							ELSE (CASE WHEN RIGHT(LOWER(TextSearch),2) = 'km' THEN ((CAST(SUBSTRING(REPLACE(TextSearch,',','.'),0,LEN(TextSearch)-1) AS float) * 1000)+999)
									   WHEN RIGHT(LOWER(TextSearch),1) = 'm' THEN (CAST(SUBSTRING(REPLACE(TextSearch,',','.'),0,LEN(TextSearch)) AS float))
								END)
							END)
						)
					AND (N.GroupNo ILIKE '%' || GroupNo || '%' OR N.ListNo IN (SELECT ListNo FROM Note_Share WHERE GroupNo ILIKE '%' || GroupNo || '%'))
					AND (FavoriteType=-1 OR (N.FavoriteType = note_getlocatednotes.favoritetype AND UserNo =  N.UserNo)  OR (UserNo <>  N.UserNo AND N.ListNo IN (SELECT ListNo FROM Note_Share WHERE FavoriteType = note_getlocatednotes.favoritetype AND UserShare = note_getlocatednotes.userno 
									AND ListNo = N.ListNo)))
					--AND ((N.Latitude != 0 AND N.Longitude != 0) AND (N.Description NOT ILIKE '' OR N.ListNo  IN (SELECT N.ListNo from Note_Attachment A where N.ListNo = A.ListNo)))
			) AS t
		WHERE  t.RowNumber BETWEEN RowStart and PageSize
		ORDER BY CASE Sorttype WHEN 0 THEN DayEdit END DESC
				,CASE Sorttype WHEN 1 THEN Calcutordistance END
	END
	ELSE
	BEGIN
		SELECT RowStart = RowNumber from	(SELECT	ROW_NUMBER() OVER (ORDER BY  CASE Sorttype WHEN 0 THEN N.DayEdit END DESC
													,CASE Sorttype WHEN 1 THEN public."DictanceKM"(lat1,lng1, N.Latitude, N.Longitude)  END) AS RowNumber,  N.ListNo
						FROM  Note_List N  INNER JOIN
							public."Organization_Users" O ON N.UserNo = O.UserNo
						WHERE (CASE Type WHEN 0 THEN N.UserNo 
								   WHEN 1 THEN N.UserNo 
								END = note_getlocatednotes.userno 
							  OR CASE Type WHEN 0 THEN N.ListNo 
											WHEN 2 THEN N.ListNo 
									END in (select S.ListNo from Note_Share S where S.UserShare = note_getlocatednotes.userno AND S.UserNo <> note_getlocatednotes.userno))
								AND N.Show = 1 
								AND (N.Description ILIKE '%' || TextSearch || '%' OR O.Name ILIKE '%' || TextSearch || '%' OR O.Name_EN ILIKE '%' || TextSearch || '%' OR N.Name ILIKE '%' || TextSearch || '%'
										OR public."fVietnameseAccentFilters"(N.Description) ILIKE '%' || TextSearch || '%' 
										OR public."fVietnameseAccentFilters"(O.Name) ILIKE '%' || TextSearch || '%' 
										OR public."fVietnameseAccentFilters"(O.Name_EN) ILIKE '%' || TextSearch || '%' 
										OR public."fVietnameseAccentFilters"(N.Name) ILIKE '%' || TextSearch || '%'
										OR CONVERT(varchar(25), N.DayEdit , 101)  ILIKE '%' || TextSearch || '%'
										OR CONVERT(varchar(25), N.DayEdit , 102)  ILIKE '%' || TextSearch || '%'
										OR CONVERT(varchar(25), N.DayEdit , 103)  ILIKE '%' || TextSearch || '%'
										OR CONVERT(varchar(25), N.DayEdit , 104)  ILIKE '%' || TextSearch || '%'
										OR CONVERT(varchar(25), N.DayEdit , 105)  ILIKE '%' || TextSearch || '%'
										OR CONVERT(varchar(25), N.DayEdit , 106)  ILIKE '%' || TextSearch || '%'
										OR CONVERT(varchar(25), N.DayEdit , 107)  ILIKE '%' || TextSearch || '%'
										OR CONVERT(varchar(25), N.DayEdit , 1)  ILIKE '%' || TextSearch || '%'
										OR CONVERT(varchar(25), N.DayEdit , 2)  ILIKE '%' || TextSearch || '%'
										OR CONVERT(varchar(25), N.DayEdit , 3)  ILIKE '%' || TextSearch || '%'
										OR CONVERT(varchar(25), N.DayEdit , 4)  ILIKE '%' || TextSearch || '%'
										OR CONVERT(varchar(25), N.DayEdit , 5)  ILIKE '%' || TextSearch || '%'
										OR CONVERT(varchar(25), N.DayEdit , 6)  ILIKE '%' || TextSearch || '%'
										OR CONVERT(varchar(25), N.DayEdit , 7)  ILIKE '%' || TextSearch || '%'
										OR CONVERT(varchar(25), N.DayEdit , 110)  ILIKE '%' || TextSearch || '%'
										OR CONVERT(varchar(25), N.DayEdit , 111)  ILIKE '%' || TextSearch || '%'
										OR CONVERT(varchar(25), N.DayEdit , 10)  ILIKE '%' || TextSearch || '%'
										OR CONVERT(varchar(25), N.DayEdit , 11)  ILIKE '%' || TextSearch || '%'
										OR public."DictanceKM"(lat1,lng1,N.Latitude, N.Longitude) ILIKE TextSearch || '%'
										OR ROUND(public."DictanceKM"(lat1,lng1,N.Latitude, N.Longitude),0) BETWEEN (
											CASE ISNUMERIC(REPLACE(TextSearch,',','.')) WHEN 1 THEN  CAST(REPLACE(TextSearch,',','.') AS float)
											ELSE (CASE WHEN RIGHT(LOWER(TextSearch),2) = 'km' THEN (CAST(SUBSTRING(REPLACE(TextSearch,',','.'),0,LEN(TextSearch)-1) AS float) * 1000) 
													   WHEN RIGHT(LOWER(TextSearch),1) = 'm' THEN (CAST(SUBSTRING(REPLACE(TextSearch,',','.'),0,LEN(TextSearch)) AS float)) 
												END)
											END) AND (
											CASE ISNUMERIC(REPLACE(TextSearch,',','.')) WHEN 1 THEN  CAST(REPLACE(TextSearch,',','.') AS float)
											ELSE (CASE WHEN RIGHT(LOWER(TextSearch),2) = 'km' THEN ((CAST(SUBSTRING(REPLACE(TextSearch,',','.'),0,LEN(TextSearch)-1) AS float) * 1000)+999)
													   WHEN RIGHT(LOWER(TextSearch),1) = 'm' THEN (CAST(SUBSTRING(REPLACE(TextSearch,',','.'),0,LEN(TextSearch)) AS float))
												END)
											END)
										)
								AND (N.GroupNo ILIKE '%' || GroupNo || '%' OR N.ListNo IN (SELECT ListNo FROM Note_Share WHERE GroupNo ILIKE '%' || GroupNo || '%'))
								AND (FavoriteType=-1 OR (N.FavoriteType = note_getlocatednotes.favoritetype AND UserNo =  N.UserNo)  OR (UserNo <>  N.UserNo AND N.ListNo IN (SELECT ListNo FROM Note_Share WHERE FavoriteType = note_getlocatednotes.favoritetype AND UserShare = note_getlocatednotes.userno 
									AND ListNo = N.ListNo)))
								--AND ((N.Latitude != 0 AND N.Longitude != 0) AND (N.Description NOT ILIKE '' OR N.ListNo  IN (SELECT N.ListNo from Note_Attachment A where N.ListNo = A.ListNo)))
						) as t
		WHERE t.ListNo = note_getlocatednotes.listno

		RETURN QUERY
		SELECT * FROM (
			SELECT	ROW_NUMBER() OVER (ORDER BY  CASE Sorttype WHEN 0 THEN N.DayEdit END DESC
										,CASE Sorttype WHEN 1 THEN public."DictanceKM"(lat1,lng1, N.Latitude, N.Longitude)  END) AS RowNumber
			,N.ListNo ,N.Name
			,CASE WHEN UserNo =  N.UserNo  THEN  N.GroupNo 
					ELSE COALESCE((  SELECT /* TOP 1 */ GroupNo
									FROM Note_Share
									WHERE UserShare = note_getlocatednotes.userno 
									AND ListNo = N.ListNo
									),Null)
			  END AS GroupNo
			,N.UserNo,N.Description,N.Latitude,N.Longitude,N.DayCreate,N.DayEdit,N.NoteTimeZoneCreate,N.NoteTimeZoneEdit
			, public."DictanceKM"(lat1,lng1,N.Latitude, N.Longitude) AS Calcutordistance
			,CASE WHEN  N.UserNo = note_getlocatednotes.userno THEN  TRUE 
					ELSE COALESCE((  SELECT /* TOP 1 */ IsReads
									FROM Note_Share
									WHERE UserShare = note_getlocatednotes.userno 
									AND ListNo = N.ListNo
									),0)
			  END AS IsRead
			  ,CASE WHEN  N.UserNo = note_getlocatednotes.userno THEN  COALESCE(N.ReadDate, N.DayCreate) 
					ELSE COALESCE((  SELECT /* TOP 1 */ ReadDate
									FROM Note_Share
									WHERE UserShare = note_getlocatednotes.userno 
									AND ListNo = N.ListNo
									),0)
			  END AS ReadDate
			  ,CASE WHEN UserNo =  N.UserNo  THEN  N.FavoriteType 
					ELSE COALESCE((  SELECT /* TOP 1 */ FavoriteType
									FROM Note_Share
									WHERE UserShare = note_getlocatednotes.userno 
									AND ListNo = N.ListNo
									),0)
			  END AS FavoriteType
			   ,CASE WHEN UserNo =  N.UserNo  THEN  COALESCE((SELECT count(AttachmentNo) FROM Note_Attachment where ListNo = N.ListNo and UserNo <> note_getlocatednotes.userno),0)
					ELSE COALESCE((SELECT count(AttachmentNo) FROM Note_Attachment where ListNo = N.ListNo and UserNo = note_getlocatednotes.userno),0)
			  END AS isAttach
		  FROM  Note_List N  INNER JOIN
                 public."Organization_Users" O ON N.UserNo = O.UserNo
		  WHERE CASE Type WHEN 0 THEN N.UserNo 
				   WHEN 1 THEN N.UserNo 
				END = note_getlocatednotes.userno 
			  OR CASE Type WHEN 0 THEN N.ListNo 
							WHEN 2 THEN N.ListNo 
					END in (select S.ListNo from Note_Share S where S.UserShare = note_getlocatednotes.userno AND S.UserNo <> note_getlocatednotes.userno)
					AND N.Show = 1 
					AND (N.Description ILIKE '%' || TextSearch || '%' OR O.Name ILIKE '%' || TextSearch || '%' OR O.Name_EN ILIKE '%' || TextSearch || '%' OR N.Name ILIKE '%' || TextSearch || '%'
						 OR public."fVietnameseAccentFilters"(N.Description) ILIKE '%' || TextSearch || '%' 
						 OR public."fVietnameseAccentFilters"(O.Name) ILIKE '%' || TextSearch || '%' 
						 OR public."fVietnameseAccentFilters"(O.Name_EN) ILIKE '%' || TextSearch || '%' 
						 OR public."fVietnameseAccentFilters"(N.Name) ILIKE '%' || TextSearch || '%'
						OR CONVERT(varchar(25), N.DayEdit , 101)  ILIKE '%' || TextSearch || '%'
						OR CONVERT(varchar(25), N.DayEdit , 102)  ILIKE '%' || TextSearch || '%'
						OR CONVERT(varchar(25), N.DayEdit , 103)  ILIKE '%' || TextSearch || '%'
						OR CONVERT(varchar(25), N.DayEdit , 104)  ILIKE '%' || TextSearch || '%'
						OR CONVERT(varchar(25), N.DayEdit , 105)  ILIKE '%' || TextSearch || '%'
						OR CONVERT(varchar(25), N.DayEdit , 106)  ILIKE '%' || TextSearch || '%'
						OR CONVERT(varchar(25), N.DayEdit , 107)  ILIKE '%' || TextSearch || '%'
						OR CONVERT(varchar(25), N.DayEdit , 1)  ILIKE '%' || TextSearch || '%'
						OR CONVERT(varchar(25), N.DayEdit , 2)  ILIKE '%' || TextSearch || '%'
						OR CONVERT(varchar(25), N.DayEdit , 3)  ILIKE '%' || TextSearch || '%'
						OR CONVERT(varchar(25), N.DayEdit , 4)  ILIKE '%' || TextSearch || '%'
						OR CONVERT(varchar(25), N.DayEdit , 5)  ILIKE '%' || TextSearch || '%'
						OR CONVERT(varchar(25), N.DayEdit , 6)  ILIKE '%' || TextSearch || '%'
						OR CONVERT(varchar(25), N.DayEdit , 7)  ILIKE '%' || TextSearch || '%'
						OR CONVERT(varchar(25), N.DayEdit , 110)  ILIKE '%' || TextSearch || '%'
						OR CONVERT(varchar(25), N.DayEdit , 111)  ILIKE '%' || TextSearch || '%'
						OR CONVERT(varchar(25), N.DayEdit , 10)  ILIKE '%' || TextSearch || '%'
						OR CONVERT(varchar(25), N.DayEdit , 11)  ILIKE '%' || TextSearch || '%'
						OR public."DictanceKM"(lat1,lng1,N.Latitude, N.Longitude) ILIKE TextSearch || '%'
						OR ROUND(public."DictanceKM"(lat1,lng1,N.Latitude, N.Longitude),0) BETWEEN (
							CASE ISNUMERIC(REPLACE(TextSearch,',','.')) WHEN 1 THEN  CAST(REPLACE(TextSearch,',','.') AS float)
							ELSE (CASE WHEN RIGHT(LOWER(TextSearch),2) = 'km' THEN (CAST(SUBSTRING(REPLACE(TextSearch,',','.'),0,LEN(TextSearch)-1) AS float) * 1000) 
									   WHEN RIGHT(LOWER(TextSearch),1) = 'm' THEN (CAST(SUBSTRING(REPLACE(TextSearch,',','.'),0,LEN(TextSearch)) AS float)) 
								END)
							END) AND (
							CASE ISNUMERIC(REPLACE(TextSearch,',','.')) WHEN 1 THEN  CAST(REPLACE(TextSearch,',','.') AS float)
							ELSE (CASE WHEN RIGHT(LOWER(TextSearch),2) = 'km' THEN ((CAST(SUBSTRING(REPLACE(TextSearch,',','.'),0,LEN(TextSearch)-1) AS float) * 1000)+999)
									   WHEN RIGHT(LOWER(TextSearch),1) = 'm' THEN (CAST(SUBSTRING(REPLACE(TextSearch,',','.'),0,LEN(TextSearch)) AS float))
								END)
							END)
						)
					AND (N.GroupNo ILIKE '%' || GroupNo || '%' OR N.ListNo IN (SELECT ListNo FROM Note_Share WHERE GroupNo ILIKE '%' || GroupNo || '%'))
					AND (FavoriteType=-1 OR (N.FavoriteType = note_getlocatednotes.favoritetype AND UserNo =  N.UserNo)  OR (UserNo <>  N.UserNo AND N.ListNo IN (SELECT ListNo FROM Note_Share WHERE  FavoriteType = note_getlocatednotes.favoritetype AND UserShare = note_getlocatednotes.userno 
									AND ListNo = N.ListNo)))
					--AND ((N.Latitude != 0 AND N.Longitude != 0) AND (N.Description NOT ILIKE '' OR N.ListNo  IN (SELECT N.ListNo from Note_Attachment A where N.ListNo = A.ListNo)))
			) as t
		WHERE  t.RowNumber BETWEEN RowStart+1 and RowStart+PageSize
		ORDER BY CASE Sorttype WHEN 0 THEN DayEdit END DESC
				,CASE Sorttype WHEN 1 THEN Calcutordistance END
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
