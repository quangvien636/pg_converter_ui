-- ─── PROCEDURE→FUNCTION: menu_updatebadgecount_module ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.menu_updatebadgecount_module(integer, integer, integer);
CREATE OR REPLACE FUNCTION public.menu_updatebadgecount_module(
    IN userno integer,
    IN moduleno integer,
    IN badgecount integer
) RETURNS void
AS $function$
BEGIN


	UPDATE Badge SET BadgeCount=menu_updatebadgecount_module.badgecount
	WHERE UserNo=menu_updatebadgecount_module.userno AND ModuleNo=menu_updatebadgecount_module.moduleno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
