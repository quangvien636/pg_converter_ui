-- ─── PROCEDURE→FUNCTION: permission_insertpermissionlevel ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.permission_insertpermissionlevel(integer, integer, timestamp without time zone, integer, timestamp without time zone, integer);
CREATE OR REPLACE FUNCTION public.permission_insertpermissionlevel(
    IN userno integer,
    IN reguserno integer,
    IN regdate timestamp without time zone,
    IN moduserno integer,
    IN moddate timestamp without time zone,
    IN level integer
) RETURNS void
AS $function$
BEGIN


	INSERT INTO PermissionLevels
	VALUES(UserNo, RegUserNo, RegDate, ModUserNo, ModDate, Level);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
