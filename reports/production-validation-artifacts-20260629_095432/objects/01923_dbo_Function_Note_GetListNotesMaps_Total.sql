-- ─── FUNCTION: note_getlistnotesmaps_total ───────────────────────────────
DROP FUNCTION IF EXISTS public.note_getlistnotesmaps_total(integer, uuid, double precision, double precision);
CREATE OR REPLACE FUNCTION public.note_getlistnotesmaps_total(
    userno integer,
    groupno uuid,
    lat1 double precision DEFAULT 0,
    lng1 double precision DEFAULT 0
) RETURNS TABLE(
    listno text
)
AS $function$
BEGIN


	IF GroupNo = '00000000-0000-0000-0000-000000000000'
	BEGIN
		SELECT	Total = COUNT(ListNo), MaxDictance = MAX(public."DictanceKM"(lat1,lng1,Latitude, Longitude)), MinDictance = MIN(public."DictanceKM"(lat1,lng1,Latitude, Longitude))
		  FROM  Note_List N  INNER JOIN
                 public."Organization_Users" O ON N.UserNo = O.UserNo
		  WHERE (N.UserNo = note_getlistnotesmaps_total.userno OR N.ListNo IN (select S.ListNo from Note_Share S where S.UserShare = note_getlistnotesmaps_total.userno AND S.UserNo <> note_getlistnotesmaps_total.userno))
					AND N.Show = 1 
	END
	ELSE
	BEGIN
		SELECT	Total = COUNT(ListNo), MaxDictance = MAX(public."DictanceKM"(lat1,lng1,Latitude, Longitude)), MinDictance = MIN(public."DictanceKM"(lat1,lng1,Latitude, Longitude))
		  FROM  Note_List N  INNER JOIN
                 public."Organization_Users" O ON N.UserNo = O.UserNo
		  WHERE  (N.UserNo = note_getlistnotesmaps_total.userno OR  N.ListNo IN (select S.ListNo from Note_Share S where S.UserShare = note_getlistnotesmaps_total.userno AND S.UserNo <> note_getlistnotesmaps_total.userno))
					AND N.Show = 1 
					AND (N.GroupNo = note_getlistnotesmaps_total.groupno OR N.ListNo IN (SELECT ListNo FROM Note_Share WHERE GroupNo = note_getlistnotesmaps_total.groupno))
	END

	RETURN QUERY
	SELECT Total AS Total, (MaxDictance*1000) AS MaxDictance, (MinDictance*1000) AS MinDictance;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
