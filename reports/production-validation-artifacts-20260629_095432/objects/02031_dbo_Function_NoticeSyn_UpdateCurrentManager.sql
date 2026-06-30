-- ─── FUNCTION: noticesyn_updatecurrentmanager ───────────────────────────────
DROP FUNCTION IF EXISTS public.noticesyn_updatecurrentmanager(integer, integer, integer, integer, integer, timestamp without time zone, integer, integer);
CREATE OR REPLACE FUNCTION public.noticesyn_updatecurrentmanager(
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


	UPDATE NoticeSyn_UserByGroup SET
		USER_NO = noticesyn_updatecurrentmanager.user_no, 
		MENU_ID = noticesyn_updatecurrentmanager.menu_id, 
		AUTH_GRP_ID = noticesyn_updatecurrentmanager.auth_grp_id, 
		ID_INSERT = noticesyn_updatecurrentmanager.id_insert, 
		DTS_INSERT = noticesyn_updatecurrentmanager.dts_insert, 
		ID_UPDATE = noticesyn_updatecurrentmanager.id_update, 
		DTS_UPDATE = NOW(),
		DEPARTMENT_ID= noticesyn_updatecurrentmanager.department_id

	WHERE USERGROUP_ID = noticesyn_updatecurrentmanager.usergroup_id 
END;
--------------------//---------------------
-- USE CrewCloud_Core
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
