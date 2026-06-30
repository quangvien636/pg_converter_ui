-- ─── FUNCTION: mail_getmailboxs_forallbox ───────────────────────────────
DROP FUNCTION IF EXISTS public.mail_getmailboxs_forallbox(integer);
CREATE OR REPLACE FUNCTION public.mail_getmailboxs_forallbox(
    userno integer
) RETURNS TABLE(
    boxno bigint
)
AS $function$
#variable_conflict use_column
DECLARE
    totalboxs table (
		rownum		int,
		boxno		bigint,
		parentno	bigint,
		sortno		int,
		totalcount	int,
		unreadcount	int
	);
    missboxs table (
		boxno		bigint,
		parentno	bigint,
		sortno		int,
		totalcount	int,
		unreadcount	int
	);
    _parentno bigint;
BEGIN




	INSERT INTO TotalBoxs
	RETURN QUERY
	SELECT ROW_NUMBER() OVER (ORDER BY BoxNo ASC) AS RowNum,
		BoxNo, ParentNo, SortNo, TotalCount, UnReadCount
	FROM Mail_MailBoxs WHERE UserNo = mail_getmailboxs_forallbox.userno


	SET CurrentRow = 1
	SET TotalRow = (SELECT MAX(RowNum) FROM TotalBoxs)



	WHILE (CurrentRow <= TotalRow) BEGIN

		RETURN QUERY
		SELECT
			BoxNo = BoxNo,
			ParentNo = ParentNo,
			SortNo = SortNo,
			TotalCount = TotalCount,
			UnReadCount = UnReadCount
		FROM TotalBoxs WHERE RowNum = CurrentRow

		IF (ParentNo = -1) BEGIN
		
			IF (SortNo IN (1, 3, 4, 5, 6, 8)) BEGIN
			
				INSERT INTO MissBoxs VALUES(BoxNo, ParentNo, SortNo, TotalCount, UnReadCount)
			
			END
				
		END
		
		ELSE IF (ParentNo = 1) BEGIN
		
			INSERT INTO MissBoxs VALUES(BoxNo, ParentNo, SortNo, TotalCount, UnReadCount)
		
		END
		
		ELSE IF (ParentNo != 0) BEGIN
		

			SET _ParentNo = ParentNo
			
			WHILE (_ParentNo NOT IN (0, 1)) BEGIN
			
				SET _ParentNo = (SELECT ParentNo FROM TotalBoxs WHERE BoxNo = _ParentNo)
			
			END
			
			IF (_ParentNo = 1) BEGIN
			
				INSERT INTO MissBoxs VALUES(BoxNo, ParentNo, SortNo, TotalCount, UnReadCount)
			
			END
		
		END

		SET CurrentRow = CurrentRow + 1

	END

	INSERT INTO Boxs
	RETURN QUERY
	SELECT BoxNo FROM TotalBoxs WHERE BoxNo NOT IN (SELECT BoxNo FROM MissBoxs)
	
	RETURN;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
