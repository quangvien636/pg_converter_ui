-- ─── FUNCTION: board_deletecurrentmanager ───────────────────────────────
DROP FUNCTION IF EXISTS public.board_deletecurrentmanager(character varying, character varying);
CREATE OR REPLACE FUNCTION public.board_deletecurrentmanager(
    usernos character varying,
    delimiter character varying
) RETURNS void
AS $function$
BEGIN
	
	DELETE FROM Board_UserByGroup WHERE USERGROUP_ID IN (SELECT Items FROM public."fn_split_array"(UserNos,Delimiter));
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
