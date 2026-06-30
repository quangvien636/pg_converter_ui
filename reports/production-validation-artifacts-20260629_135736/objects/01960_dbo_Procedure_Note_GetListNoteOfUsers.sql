-- ─── PROCEDURE→FUNCTION: note_getlistnoteofusers ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.note_getlistnoteofusers(integer, integer, uuid);
CREATE OR REPLACE FUNCTION public.note_getlistnoteofusers(
    IN userno integer,
    IN type integer,
    IN groupno uuid
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN
 
 ----- IF NO GROUP ---------
 IF GroupNo='00000000-0000-0000-0000-000000000000' THEN
		IF Type=1  ------ Get My Note ------ THEN
			WITH s AS
				(
					SELECT ROW_NUMBER() 
						OVER(ORDER BY DayEdit DESC) AS RowNum,  TRUE As IsRead,  DayCreate As ReadDate,
						ListNo,GroupNo,UserNo,Name,DayCreate,DayEdit,Description,Latitude,Longitude,(SELECT COUNT(*) FROM Note_List WHERE Show=1 AND UserNo=note_getlistnoteofusers.userno) as TotalCnt
					FROM Note_List			
					WHERE Show=1 AND UserNo=note_getlistnoteofusers.userno		
				)	
			RETURN QUERY
			Select * From s 			
		END IF;
		ELSIF Type=2  -------------- Get Note Share ------------------ THEN

			WITH s AS
				(
					SELECT ROW_NUMBER() 
						OVER(ORDER BY L.DayEdit DESC) AS RowNum, S.IsRead, S.ReadDate,
						L.DayCreate,L.DayEdit,L.Description, COALESCE((SELECT L.GroupNo WHERE S.GroupNo IS NULL), S.GroupNo) As GroupNo ,L.Latitude,L.Longitude,L.Name,L.UserNo,L.ListNo,(SELECT COUNT(*)  FROM Note_Share S
																											INNER JOIN Note_List L
																											ON L.ListNo=S.ListNo
																											WHERE S.UserShare=note_getlistnoteofusers.userno AND L.Show=1) as TotalCnt
					FROM Note_Share S		
					INNER JOIN Note_List L
					ON L.ListNo=S.ListNo
					WHERE S.UserShare=note_getlistnoteofusers.userno AND L.Show=1
				)	
			RETURN QUERY
			Select * From s 		
		END IF;
	END IF;
	------ END NO GROUP NO -----------------------
	ELSE
		IF Type=1  ------ Get My Note ------ THEN
			WITH s AS
				(
					SELECT ROW_NUMBER() 
						OVER(ORDER BY DayCreate DESC) AS RowNum,  TRUE As IsRead,  DayCreate As ReadDate,
						ListNo,GroupNo,UserNo,Name,DayCreate,DayEdit,Description,Latitude,Longitude,(SELECT COUNT(*) FROM Note_List WHERE Show=1 AND UserNo=note_getlistnoteofusers.userno AND GroupNo=note_getlistnoteofusers.groupno) as TotalCnt
					FROM Note_List			
					WHERE Show=1 AND UserNo=note_getlistnoteofusers.userno	AND GroupNo=note_getlistnoteofusers.groupno	
				)	
			RETURN QUERY
			Select * From s 			
		END IF;
		ELSIF Type=2  -------------- Get Note Share ------------------ THEN
			WITH s AS
				(
					SELECT ROW_NUMBER() 
						OVER(ORDER BY L.DayEdit DESC) AS RowNum, S.IsRead, S.ReadDate,
						L.DayCreate,L.DayEdit,L.Description, COALESCE((SELECT L.GroupNo WHERE S.GroupNo IS NULL), S.GroupNo)As GroupNo ,L.Latitude,L.Longitude,L.Name,L.UserNo,L.ListNo,(SELECT COUNT(*)  FROM Note_Share S
																											INNER JOIN Note_List L
																											ON L.ListNo=S.ListNo
																											WHERE S.UserShare=note_getlistnoteofusers.userno AND L.Show=1 AND L.GroupNo=note_getlistnoteofusers.groupno) as TotalCnt
					FROM Note_Share S		
					INNER JOIN Note_List L
					ON L.ListNo=S.ListNo
					WHERE S.UserShare=note_getlistnoteofusers.userno AND L.Show=1 AND  COALESCE((SELECT L.GroupNo WHERE S.GroupNo IS NULL), S.GroupNo)=note_getlistnoteofusers.groupno
				)	
			RETURN QUERY
			Select * From s 		
		END IF;
	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
