-- ─── PROCEDURE→FUNCTION: authority_updatesitepermission ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.authority_updatesitepermission(integer, integer, timestamp without time zone, integer);
CREATE OR REPLACE FUNCTION public.authority_updatesitepermission(
    IN userno integer,
    IN moduserno integer,
    IN moddate timestamp without time zone,
    IN permissiontype integer
) RETURNS void
AS $function$
BEGIN


	IF (SELECT COUNT(*) FROM Authority_SitePermissions WHERE UserNo = authority_updatesitepermission.userno) = 0 THEN
	
		INSERT INTO Authority_SitePermissions (UserNo, ModUserNo, ModDate, PermissionType)
		VALUES (UserNo, ModUserNo, ModDate, PermissionType)
	
	END IF;

	ELSE BEGIN
	
		UPDATE Authority_SitePermissions SET ModUserNo = authority_updatesitepermission.moduserno, ModDate = authority_updatesitepermission.moddate, PermissionType = authority_updatesitepermission.permissiontype
		WHERE UserNo = authority_updatesitepermission.userno

	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
