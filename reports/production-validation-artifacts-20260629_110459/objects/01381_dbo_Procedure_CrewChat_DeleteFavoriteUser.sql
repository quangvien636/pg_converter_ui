-- ─── PROCEDURE→FUNCTION: crewchat_deletefavoriteuser ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.crewchat_deletefavoriteuser(integer, integer);
CREATE OR REPLACE FUNCTION public.crewchat_deletefavoriteuser(
    IN groupno integer,
    IN userno integer
) RETURNS void
AS $function$
BEGIN

	DELETE FROM CrewChat_FavoriteUsers
	WHERE GroupNo=crewchat_deletefavoriteuser.groupno AND UserNo=crewchat_deletefavoriteuser.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
