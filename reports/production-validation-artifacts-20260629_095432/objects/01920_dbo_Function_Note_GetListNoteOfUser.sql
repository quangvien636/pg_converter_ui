-- ─── FUNCTION: note_getlistnoteofuser ───────────────────────────────
DROP FUNCTION IF EXISTS public.note_getlistnoteofuser(integer, integer, integer, integer);
CREATE OR REPLACE FUNCTION public.note_getlistnoteofuser(
    userno integer,
    type integer,
    currpage integer,
    limit integer
) RETURNS TABLE(
    listno uuid,
    name character varying(250),
    groupno uuid,
    userno integer,
    description text,
    latitude double precision,
    longitude double precision,
    daycreate timestamp without time zone,
    dayedit timestamp without time zone,
    show integer,
    notetimezonecreate double precision,
    notetimezoneedit double precision,
    favoritetype integer,
    readdate timestamp without time zone,
    notetimezoneread double precision
)
AS $function$
BEGIN

	IF Type= 0  ----- Get All ----
	BEGIN
	WITH s AS
		(
			SELECT ROW_NUMBER() 
				OVER(ORDER BY DayEdit DESC) AS RowNum, TRUE As IsRead,  DayCreate As ReadDate,
				ListNo,GroupNo,UserNo,Name,DayCreate,DayEdit,Description,Latitude,Longitude,(SELECT COUNT(*) FROM Note_List WHERE Show=1 AND UserNo=note_getlistnoteofuser.userno ) as TotalCnt
			FROM Note_List			
			WHERE Show=1 AND UserNo=note_getlistnoteofuser.userno		
		)
		RETURN QUERY
		Select * From s 
		Where RowNum Between (currPage - 1)*Limit+1 AND currPage*Limit	
	END
	ELSE IF Type=1  ------ Get My Note ------
	BEGIN
		WITH s AS
			(
				SELECT ROW_NUMBER() 
					OVER(ORDER BY DayEdit DESC) AS RowNum, TRUE As IsRead,  DayCreate As ReadDate,
					ListNo,GroupNo,UserNo,Name,DayCreate,DayEdit,Description,Latitude,Longitude,(SELECT COUNT(*) FROM Note_List WHERE Show=1 AND UserNo=note_getlistnoteofuser.userno) as TotalCnt
				FROM Note_List			
				WHERE Show=1 AND UserNo=note_getlistnoteofuser.userno		
			)
			RETURN QUERY
			Select * From s 
			Where RowNum Between (currPage - 1)*Limit+1 AND currPage*Limit		
	END
	ELSE IF Type=2  ---- Get Note Share ----------
	BEGIN

		WITH s AS
			(
				SELECT ROW_NUMBER() 
					OVER(ORDER BY L.DayEdit DESC) AS RowNum, S.IsRead, S.ReadDate,
					L.DayCreate,L.DayEdit,L.Description, COALESCE((SELECT L.GroupNo WHERE S.GroupNo IS NULL), S.GroupNo) As GroupNo,L.Latitude,L.Longitude,L.Name,L.UserNo,L.ListNo,(SELECT COUNT(*)  FROM Note_Share S
																										INNER JOIN Note_List L
																										ON L.ListNo=S.ListNo
																										WHERE S.UserShare=note_getlistnoteofuser.userno AND L.Show=1) as TotalCnt
				FROM Note_Share S		
				INNER JOIN Note_List L
				ON L.ListNo=S.ListNo
				WHERE S.UserShare=note_getlistnoteofuser.userno AND L.Show=1	
			)
			RETURN QUERY
			Select * From s 
			Where RowNum Between (currPage - 1)*Limit+1 AND currPage*Limit	
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
