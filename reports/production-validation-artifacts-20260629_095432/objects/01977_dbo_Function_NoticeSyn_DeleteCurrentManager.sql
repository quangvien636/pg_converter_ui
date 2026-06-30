-- ─── FUNCTION: noticesyn_deletecurrentmanager ───────────────────────────────
DROP FUNCTION IF EXISTS public.noticesyn_deletecurrentmanager(character varying, character varying);
CREATE OR REPLACE FUNCTION public.noticesyn_deletecurrentmanager(
    usernos character varying,
    delimiter character varying
) RETURNS void
AS $function$
BEGIN
	

	DELETE FROM NoticeSyn_UserByGroup WHERE USERGROUP_ID IN (SELECT Items FROM public."fn_split_array"(UserNos,Delimiter))	

END;
-----------------------------------//////////////////////////////////----------
-- USE CrewCloud_Core
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
