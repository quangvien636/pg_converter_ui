-- ─── FUNCTION: notice_downdivisions ───────────────────────────────
DROP FUNCTION IF EXISTS public.notice_downdivisions(integer);
CREATE OR REPLACE FUNCTION public.notice_downdivisions(
    divisionno integer
) RETURNS void
AS $function$
DECLARE
    sortno integer;
    tempno integer;
    ranktempno integer;
BEGIN



SET RANKTEMPNO=1

SELECT  DivisionNo from NoticeDivisions WHERE  Status=1 ORDER BY Sort ASC,DivisionNo ASC
OPEN Division_Cursor
FETCH NEXT FROM Division_Cursor 
INTO TEMPNO
WHILE @FETCH_STATUS = 0
   BEGIN	;
		UPDATE NoticeDivisions SET Sort = RANKTEMPNO WHERE TEMPNO=notice_downdivisions.divisionno
		
		IF (TEMPNO=notice_downdivisions.divisionno)
		BEGIN
			SET SORTNO=RANKTEMPNO
		END
		SET RANKTEMPNO=RANKTEMPNO+1
		FETCH NEXT FROM Division_Cursor
		INTO  TEMPNO
   END;
CLOSE Division_Cursor;
DEALLOCATE Division_Cursor;

UPDATE NoticeDivisions SET Sort = SORTNO WHERE Status=1 And SORTNO = Sort - 1;
UPDATE NoticeDivisions SET Sort = SORTNO + 1 WHERE DivisionNo = notice_downdivisions.divisionno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
