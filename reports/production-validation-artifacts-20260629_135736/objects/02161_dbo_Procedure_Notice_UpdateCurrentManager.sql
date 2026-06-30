-- ─── PROCEDURE→FUNCTION: notice_updatecurrentmanager ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.notice_updatecurrentmanager(integer, integer, integer, integer, integer, timestamp without time zone, integer, integer);
CREATE OR REPLACE FUNCTION public.notice_updatecurrentmanager(
    IN usergroup_id integer,
    IN user_no integer,
    IN menu_id integer,
    IN auth_grp_id integer,
    IN id_insert integer,
    IN dts_insert timestamp without time zone,
    IN id_update integer,
    IN department_id integer DEFAULT 0
) RETURNS void
AS $function$
BEGIN


	UPDATE Notice_UserByGroup SET
		USER_NO = notice_updatecurrentmanager.user_no, 
		MENU_ID = notice_updatecurrentmanager.menu_id, 
		AUTH_GRP_ID = notice_updatecurrentmanager.auth_grp_id, 
		ID_INSERT = notice_updatecurrentmanager.id_insert, 
		DTS_INSERT = notice_updatecurrentmanager.dts_insert, 
		ID_UPDATE = notice_updatecurrentmanager.id_update, 
		DTS_UPDATE = NOW(),
		DEPARTMENT_ID= notice_updatecurrentmanager.department_id

	WHERE USERGROUP_ID = notice_updatecurrentmanager.usergroup_id;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
