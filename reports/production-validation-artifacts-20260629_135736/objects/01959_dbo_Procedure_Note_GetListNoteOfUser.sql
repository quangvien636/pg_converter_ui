-- ─── PROCEDURE→FUNCTION: note_getlistnoteofuser ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.note_getlistnoteofuser(integer, integer, integer, integer);
CREATE OR REPLACE FUNCTION public.note_getlistnoteofuser(
    IN userno integer,
    IN type integer,
    IN currpage integer,
    IN limit integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	IF Type= 0  ----- Get All ---- THEN
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
	END IF;
	ELSIF Type=1  ------ Get My Note ------ THEN
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
	END IF;
	ELSIF Type=2  ---- Get Note Share ---------- THEN

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
	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
