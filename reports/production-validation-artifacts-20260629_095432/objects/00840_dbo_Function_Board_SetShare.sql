-- ─── FUNCTION: board_setshare ───────────────────────────────
DROP FUNCTION IF EXISTS public.board_setshare(integer, integer, integer, character varying);
CREATE OR REPLACE FUNCTION public.board_setshare(
    contentno integer,
    departno integer,
    userno integer,
    ischild character varying
) RETURNS TABLE(
    col1 text
)
AS $function$
DECLARE
    departname character varying;
BEGIN

	IF Mode = 0
	BEGIN
	

		SET DepartName = public."COMNGetDepartName"(DepartNo)
		if((select count(*) from Board_Sharers b where b.ContentNo = board_setshare.contentno and b.DepartNo=board_setshare.departno and b.Userno=board_setshare.userno)=0) begin;
		INSERT INTO Board_Sharers(ContentNo,DepartNo,DepartName,IsChild,UserNo)
		VALUES(ContentNo,DepartNo,DepartName,IsChild,UserNo)
		end
	END
	ELSE
	BEGIN;
		DELETE FROM Board_Sharers WHERE ContentNo = board_setshare.contentno
	END
	
	RETURN QUERY
	SELECT @ERROR;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
