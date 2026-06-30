-- ─── PROCEDURE→FUNCTION: board_setshare ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.board_setshare(integer, integer, integer, character varying);
CREATE OR REPLACE FUNCTION public.board_setshare(
    IN contentno integer,
    IN departno integer,
    IN userno integer,
    IN ischild character varying
) RETURNS SETOF record
AS $function$
DECLARE
    departname character varying;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	IF Mode = 0 THEN
	

		DepartName := public."COMNGetDepartName"(DepartNo);
		IF (select count(*) from Board_Sharers b where b.ContentNo = board_setshare.contentno and b.DepartNo=board_setshare.departno and b.Userno=board_setshare.userno)=0 THEN
		INSERT INTO Board_Sharers(ContentNo,DepartNo,DepartName,IsChild,UserNo)
		VALUES(ContentNo,DepartNo,DepartName,IsChild,UserNo);
		END IF;
	ELSE
		DELETE FROM Board_Sharers WHERE ContentNo = board_setshare.contentno
	END;
	
	RETURN QUERY
	SELECT @ERROR;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.