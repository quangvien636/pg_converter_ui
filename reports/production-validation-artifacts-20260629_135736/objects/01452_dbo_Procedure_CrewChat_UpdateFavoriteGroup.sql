-- ─── PROCEDURE→FUNCTION: crewchat_updatefavoritegroup ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.crewchat_updatefavoritegroup(integer, integer, character varying, integer);
CREATE OR REPLACE FUNCTION public.crewchat_updatefavoritegroup(
    IN groupno integer,
    IN userno integer,
    IN name character varying,
    IN sortno integer
) RETURNS void
AS $function$
BEGIN

	UPDATE CrewChat_FavoriteGroups SET Name=crewchat_updatefavoritegroup.name, SortNo=crewchat_updatefavoritegroup.sortno, ModDate=NOW()
	WHERE GroupNo=crewchat_updatefavoritegroup.groupno AND UserNo=crewchat_updatefavoritegroup.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
