-- â”€â”€â”€ PROCEDUREâ†’FUNCTION: board_insertusersetting â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output â€” stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record â€” procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.board_insertusersetting(integer, integer, integer);
CREATE OR REPLACE FUNCTION public.board_insertusersetting(
    IN userno integer,
    IN modeview integer,
    IN pagesize integer
) RETURNS SETOF bigint
AS $function$
-- !! WARNING: output needs manual review â€” see TODO comments
BEGIN

		
--	IF ((SELECT COUNT(*) FROM Board_UserSetting WHERE UserNo = UserNo) >0 )
	IF (SELECT COUNT(*) FROM Board_UserSetting) >0 THEN
		UPDATE Board_UserSetting 
		SET ModeView=board_insertusersetting.modeview , PageSize=board_insertusersetting.pagesize,UserNo = board_insertusersetting.userno;
		RETURN QUERY
		SELECT 1
	ELSE
	BEGIN;
		INSERT INTO Board_UserSetting (UserNo, ModeView, PageSize)
		VALUES (UserNo, ModeView, PageSize);
		RETURN QUERY
		SELECT 0
	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.