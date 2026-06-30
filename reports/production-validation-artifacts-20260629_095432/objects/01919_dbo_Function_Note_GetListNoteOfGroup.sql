-- ─── FUNCTION: note_getlistnoteofgroup ───────────────────────────────
DROP FUNCTION IF EXISTS public.note_getlistnoteofgroup(integer, uuid, integer, integer, integer);
CREATE OR REPLACE FUNCTION public.note_getlistnoteofgroup(
    userno integer,
    groupno uuid,
    type integer,
    currpage integer,
    limit integer
) RETURNS TABLE(
    col1 text
)
AS $function$
BEGIN

	IF Type= 0  ----- Get All ----
	BEGIN
	WITH s AS
		(
			SELECT ROW_NUMBER() 
				OVER(ORDER BY DayEdit DESC) AS RowNum, TRUE As IsRead, DayCreate As ReadDate,
				ListNo,GroupNo,DayCreate,DayEdit,Name,Description,Latitude,UserNo,Longitude,(SELECT COUNT(*) FROM Note_List WHERE Show=1 AND GroupNo=note_getlistnoteofgroup.groupno) as TotalCnt
			FROM Note_List			
			WHERE Show=1 AND GroupNo=note_getlistnoteofgroup.groupno AND UserNo=note_getlistnoteofgroup.userno		
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
					OVER(ORDER BY DayEdit DESC) AS RowNum,TRUE As IsRead, DayCreate As ReadDate,
					ListNo,GroupNo,Name,DayCreate,DayEdit,Description,Latitude,UserNo,Longitude,(SELECT COUNT(*) FROM Note_List WHERE Show=1 AND UserNo=note_getlistnoteofgroup.userno AND GroupNo=note_getlistnoteofgroup.groupno) as TotalCnt
				FROM Note_List	
				WHERE Show=1 AND UserNo=note_getlistnoteofgroup.userno AND GroupNo=note_getlistnoteofgroup.groupno		
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
					L.DayCreate,L.DayEdit,L.Description, /*COALESCE((SELECT L.GroupNo WHERE S.GroupNo IS NULL), S.GroupNo)*/ COALESCE((SELECT L.GroupNo WHERE S.GroupNo IS NULL), S.GroupNo) As GroupNo,L.Latitude,L.Longitude,L.Name,L.UserNo,L.ListNo,(SELECT COUNT(*)  FROM Note_Share S
																										INNER JOIN Note_List L
																										ON L.ListNo=S.ListNo
																										WHERE S.UserShare=note_getlistnoteofgroup.userno AND L.Show=1 AND COALESCE((SELECT L.GroupNo WHERE S.GroupNo IS NULL), S.GroupNo) =  note_getlistnoteofgroup.groupno) as TotalCnt
				FROM Note_Share S		
				INNER JOIN Note_List L
				ON L.ListNo=S.ListNo
				WHERE S.UserShare=note_getlistnoteofgroup.userno AND L.Show=1 AND COALESCE((SELECT L.GroupNo WHERE S.GroupNo IS NULL), S.GroupNo) = note_getlistnoteofgroup.groupno
			)
			RETURN QUERY
			Select * From s 
			Where RowNum Between (currPage - 1)*Limit+1 AND currPage*Limit	
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
