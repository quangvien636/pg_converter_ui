-- ─── PROCEDURE→FUNCTION: noticesyn_updatecurrentmanager ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.noticesyn_updatecurrentmanager(integer, integer, integer, integer, integer, timestamp without time zone, integer, integer);
CREATE OR REPLACE FUNCTION public.noticesyn_updatecurrentmanager(
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
