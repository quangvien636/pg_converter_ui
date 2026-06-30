-- ─── FUNCTION: note_searchnote ───────────────────────────────
DROP FUNCTION IF EXISTS public.note_searchnote(integer, integer, uuid);
CREATE OR REPLACE FUNCTION public.note_searchnote(
    userno integer,
    type integer,
    groupno uuid
) RETURNS TABLE(
    col1 text
)
AS $function$
BEGIN
 
 ----- IF NO GROUP ---------
 IF GroupNo='00000000-0000-0000-0000-000000000000'
	 BEGIN
		IF Type=1  ------ Get My Note ------
		BEGIN
			WITH s AS
				(
					SELECT ROW_NUMBER() 
						OVER(ORDER BY DayEdit DESC) AS RowNum,  TRUE As IsRead,  DayCreate As ReadDate,
						ListNo,GroupNo,UserNo,Name,DayCreate,DayEdit,Description,Latitude,Longitude,(SELECT COUNT(*) FROM Note_List WHERE Show=1 AND UserNo=note_searchnote.userno AND Description ILIKE '%' || TextSearch || '%') as TotalCnt
					FROM Note_List			
					WHERE Show=1 AND UserNo=note_searchnote.userno	AND Description ILIKE '%' || TextSearch || '%'	
				)	
			RETURN QUERY
			Select * From s 			
		END
		ELSE IF Type=2  -------------- Get Note Share ------------------
		BEGIN

			WITH s AS
				(
					SELECT ROW_NUMBER() 
						OVER(ORDER BY L.DayEdit DESC) AS RowNum, S.IsRead, S.ReadDate,
						L.DayCreate,L.DayEdit,L.Description, COALESCE((SELECT L.GroupNo WHERE S.GroupNo IS NULL), S.GroupNo) As GroupNo ,L.Latitude,L.Longitude,L.Name,L.UserNo,L.ListNo,(SELECT COUNT(*)  FROM Note_Share S
																											INNER JOIN Note_List L
																											ON L.ListNo=S.ListNo
																											WHERE S.UserShare=note_searchnote.userno AND L.Show=1 AND L.Description ILIKE '%' || TextSearch || '%') as TotalCnt
					FROM Note_Share S		
					INNER JOIN Note_List L
					ON L.ListNo=S.ListNo
					WHERE S.UserShare=note_searchnote.userno AND L.Show=1 AND L.Description ILIKE '%' || TextSearch || '%'	
				)	
			RETURN QUERY
			Select * From s 		
		END
	END
	------ END NO GROUP NO -----------------------
	ELSE
	BEGIN
		IF Type=1  ------ Get My Note ------
		BEGIN
			WITH s AS
				(
					SELECT ROW_NUMBER() 
						OVER(ORDER BY DayEdit DESC) AS RowNum,  TRUE As IsRead,  DayCreate As ReadDate,
						ListNo,GroupNo,UserNo,Name,DayCreate,DayEdit,Description,Latitude,Longitude,(SELECT COUNT(*) FROM Note_List WHERE Show=1 AND UserNo=note_searchnote.userno AND GroupNo=note_searchnote.groupno AND Description ILIKE '%' || TextSearch || '%') as TotalCnt
					FROM Note_List			
					WHERE Show=1 AND UserNo=note_searchnote.userno	AND GroupNo=note_searchnote.groupno AND Description ILIKE '%' || TextSearch || '%'	
				)	
			RETURN QUERY
			Select * From s 			
		END
		ELSE IF Type=2  -------------- Get Note Share ------------------
		BEGIN
			WITH s AS
				(
					SELECT ROW_NUMBER() 
						OVER(ORDER BY L.DayEdit DESC) AS RowNum, S.IsRead, S.ReadDate,
						L.DayCreate,L.DayEdit,L.Description, COALESCE((SELECT L.GroupNo WHERE S.GroupNo IS NULL), S.GroupNo) As GroupNo ,L.Latitude,L.Longitude,L.Name,L.UserNo,L.ListNo,(SELECT COUNT(*)  FROM Note_Share S
																											INNER JOIN Note_List L
																											ON L.ListNo=S.ListNo
																											WHERE S.UserShare=note_searchnote.userno AND L.Show=1 AND L.GroupNo=note_searchnote.groupno AND L.Description ILIKE '%' || TextSearch || '%') as TotalCnt
					FROM Note_Share S		
					INNER JOIN Note_List L
					ON L.ListNo=S.ListNo
					WHERE S.UserShare=note_searchnote.userno AND L.Show=1 AND  COALESCE((SELECT L.GroupNo WHERE S.GroupNo IS NULL), S.GroupNo)=note_searchnote.groupno AND L.Description ILIKE '%' || TextSearch || '%'	
				)	
			RETURN QUERY
			Select * From s 		
		END
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
