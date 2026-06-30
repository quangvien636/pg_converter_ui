-- ─── FUNCTION: notice_updatecurrentmanager ───────────────────────────────
DROP FUNCTION IF EXISTS public.notice_updatecurrentmanager(integer, integer, integer, integer, integer, timestamp without time zone, integer, integer);
CREATE OR REPLACE FUNCTION public.notice_updatecurrentmanager(
    usergroup_id integer,
    user_no integer,
    menu_id integer,
    auth_grp_id integer,
    id_insert integer,
    dts_insert timestamp without time zone,
    id_update integer,
    department_id integer DEFAULT 0
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
