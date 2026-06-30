-- ─── FUNCTION: note_getlocatednotes_total ───────────────────────────────
DROP FUNCTION IF EXISTS public.note_getlocatednotes_total(integer, character varying, character varying, integer, double precision, double precision, integer);
CREATE OR REPLACE FUNCTION public.note_getlocatednotes_total(
    userno integer,
    groupno character varying,
    textsearch character varying,
    type integer,
    lng1 double precision,
    lat1 double precision DEFAULT 0,
    favoritetype integer DEFAULT -1
) RETURNS TABLE(
    listno text
)
-- TODO: LEN was not fully converted; use length()
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

		RETURN QUERY
		SELECT	COUNT(N.ListNo) as TotalCnt
		FROM  Note_List N  INNER JOIN
				public."Organization_Users" O ON N.UserNo = O.UserNo
		WHERE (CASE Type WHEN 0 THEN N.UserNo 
					WHEN 1 THEN N.UserNo 
				END = note_getlocatednotes_total.userno 
				OR CASE Type WHEN 0 THEN N.ListNo 
							WHEN 2 THEN N.ListNo 
					END in (select S.ListNo from Note_Share S where S.UserShare = note_getlocatednotes_total.userno AND S.UserNo <> note_getlocatednotes_total.userno))
				AND N.Show = 1 
				AND (N.Description ILIKE '%' || TextSearch || '%' OR O.Name ILIKE '%' || TextSearch || '%' OR O.Name_EN ILIKE '%' || TextSearch || '%' OR N.Name ILIKE '%' || TextSearch || '%'
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
			AND (FavoriteType=-1 OR (N.FavoriteType = note_getlocatednotes_total.favoritetype AND UserNo =  N.UserNo)  OR (UserNo <>  N.UserNo AND N.ListNo IN (SELECT ListNo FROM Note_Share WHERE  FavoriteType = note_getlocatednotes_total.favoritetype AND UserShare = note_getlocatednotes_total.userno 
									AND ListNo = N.ListNo)));
		 --AND ((N.Latitude != 0 AND N.Longitude != 0) AND (N.Description NOT ILIKE '' OR N.ListNo  IN (SELECT N.ListNo from Note_Attachment A where N.ListNo = A.ListNo)))
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
