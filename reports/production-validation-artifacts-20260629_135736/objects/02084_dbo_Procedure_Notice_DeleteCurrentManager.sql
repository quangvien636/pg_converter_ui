-- ─── PROCEDURE→FUNCTION: notice_deletecurrentmanager ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.notice_deletecurrentmanager(character varying, character varying);
CREATE OR REPLACE FUNCTION public.notice_deletecurrentmanager(
    IN usernos character varying,
    IN delimiter character varying
) RETURNS void
AS $function$
BEGIN
	

	DELETE FROM Notice_UserByGroup WHERE USERGROUP_ID IN (SELECT Items FROM public."fn_split_array"(UserNos,Delimiter));
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
