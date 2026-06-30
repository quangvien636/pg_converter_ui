-- ─── PROCEDURE→FUNCTION: crewchat_deletefavoritegroup ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.crewchat_deletefavoritegroup(integer, integer);
CREATE OR REPLACE FUNCTION public.crewchat_deletefavoritegroup(
    IN groupno integer,
    IN userno integer
) RETURNS void
AS $function$
BEGIN

	DELETE FROM CrewChat_FavoriteGroups
	WHERE GroupNo=crewchat_deletefavoritegroup.groupno AND UserNo=crewchat_deletefavoritegroup.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
