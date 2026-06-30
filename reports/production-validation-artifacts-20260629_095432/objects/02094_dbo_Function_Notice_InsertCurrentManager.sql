-- ─── FUNCTION: notice_insertcurrentmanager ───────────────────────────────
DROP FUNCTION IF EXISTS public.notice_insertcurrentmanager(integer, integer, integer, integer, timestamp without time zone, integer, integer);
CREATE OR REPLACE FUNCTION public.notice_insertcurrentmanager(
    user_no integer,
    menu_id integer,
    auth_grp_id integer,
    id_insert integer,
    dts_insert timestamp without time zone,
    id_update integer,
    department_id integer DEFAULT 0
) RETURNS TABLE(
    col1 text
)
AS $function$
DECLARE
    usergroup_id integer;
BEGIN

IF ((SELECT COUNT(*) FROM Notice_UserByGroup WHERE USER_NO=notice_insertcurrentmanager.user_no AND DEPARTMENT_ID=notice_insertcurrentmanager.department_id) <=0)
	BEGIN;
	INSERT INTO Notice_UserByGroup (
		USER_NO, 
		MENU_ID, 	
		AUTH_GRP_ID, 	
		ID_INSERT, 	
		DTS_INSERT, 	
		ID_UPDATE, 	
		DTS_UPDATE,DEPARTMENT_ID
	)
	VALUES (
		USER_NO, MENU_ID, 	AUTH_GRP_ID, 	ID_INSERT, 	DTS_INSERT, 	ID_UPDATE, 	NOW() ,DEPARTMENT_ID
	)
		

	SET USERGROUP_ID = lastval()
	
	RETURN QUERY
	SELECT USERGROUP_ID
	END
	ELSE
	BEGIN
	 RETURN QUERY
	 SELECT 0
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
