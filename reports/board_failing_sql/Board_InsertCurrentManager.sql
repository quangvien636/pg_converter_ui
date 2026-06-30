-- ─── PROCEDURE→FUNCTION: board_insertcurrentmanager ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.board_insertcurrentmanager(integer, integer, integer, integer, timestamp without time zone, integer, integer);
CREATE OR REPLACE FUNCTION public.board_insertcurrentmanager(
    IN user_no integer,
    IN menu_id integer,
    IN auth_grp_id integer,
    IN id_insert integer,
    IN dts_insert timestamp without time zone,
    IN id_update integer,
    IN department_id integer DEFAULT 0
) RETURNS SETOF record
AS $function$
DECLARE
    usergroup_id integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	IF (SELECT COUNT(*) FROM Board_UserByGroup WHERE USER_NO=board_insertcurrentmanager.user_no AND DEPARTMENT_ID=board_insertcurrentmanager.department_id) <=0 THEN
	INSERT INTO Board_UserByGroup (
		USER_NO, 
		MENU_ID, 	
		AUTH_GRP_ID, 	
		ID_INSERT, 	
		DTS_INSERT, 	
		ID_UPDATE, 	
		DTS_UPDATE,
		DEPARTMENT_ID
	)
	VALUES (
		USER_NO, MENU_ID, 	AUTH_GRP_ID, 	ID_INSERT, 	DTS_INSERT, 	ID_UPDATE, 	NOW(),DEPARTMENT_ID
	);
		

	USERGROUP_ID := lastval();
	RETURN QUERY
	SELECT USERGROUP_ID

	ELSE
	BEGIN
	 RETURN QUERY
	 SELECT 0
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.