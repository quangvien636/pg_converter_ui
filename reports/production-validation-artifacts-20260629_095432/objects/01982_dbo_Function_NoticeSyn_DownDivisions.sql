-- ─── FUNCTION: noticesyn_downdivisions ───────────────────────────────
DROP FUNCTION IF EXISTS public.noticesyn_downdivisions(integer);
CREATE OR REPLACE FUNCTION public.noticesyn_downdivisions(
    divisionno integer
) RETURNS void
AS $function$
DECLARE
    sortno integer;
    tempno integer;
    ranktempno integer;
BEGIN



SET RANKTEMPNO=1

SELECT  DivisionNo from NoticeSyn_Divisions WHERE  Status=1 ORDER BY Sort ASC,DivisionNo ASC
OPEN Division_Cursor
FETCH NEXT FROM Division_Cursor 
INTO TEMPNO
WHILE @FETCH_STATUS = 0
   BEGIN	;
		UPDATE NoticeSyn_Divisions SET Sort = RANKTEMPNO WHERE TEMPNO=noticesyn_downdivisions.divisionno
		
		IF (TEMPNO=noticesyn_downdivisions.divisionno)
		BEGIN
			SET SORTNO=RANKTEMPNO
		END
		SET RANKTEMPNO=RANKTEMPNO+1
		FETCH NEXT FROM Division_Cursor
		INTO  TEMPNO
   END;
CLOSE Division_Cursor;
DEALLOCATE Division_Cursor;

UPDATE NoticeSyn_Divisions SET Sort = SORTNO WHERE Status=1 And SORTNO = Sort - 1;
UPDATE NoticeSyn_Divisions SET Sort = SORTNO + 1 WHERE DivisionNo = noticesyn_downdivisions.divisionno;

--------------------------------------///////////////////////////////////////--------------
--USE CrewCloud_Core
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
