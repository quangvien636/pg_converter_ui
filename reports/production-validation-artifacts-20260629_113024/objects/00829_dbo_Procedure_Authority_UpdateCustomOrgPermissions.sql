-- ─── PROCEDURE→FUNCTION: authority_updatecustomorgpermissions ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.authority_updatecustomorgpermissions(integer, integer, timestamp without time zone, integer);
CREATE OR REPLACE FUNCTION public.authority_updatecustomorgpermissions(
    IN userno integer,
    IN moduserno integer,
    IN moddate timestamp without time zone,
    IN permissiontype integer
) RETURNS void
AS $function$
BEGIN


	IF (SELECT COUNT(*) FROM Authority_CustomOrgPermissions WHERE UserNo = authority_updatecustomorgpermissions.userno) = 0 THEN
	
		INSERT INTO Authority_CustomOrgPermissions (UserNo, ModUserNo, ModDate, PermissionType)
		VALUES (UserNo, ModUserNo, ModDate, PermissionType)
	
	END IF;

	ELSE BEGIN
	
		UPDATE Authority_CustomOrgPermissions SET ModUserNo = authority_updatecustomorgpermissions.moduserno, ModDate = authority_updatecustomorgpermissions.moddate, PermissionType = authority_updatecustomorgpermissions.permissiontype
		WHERE UserNo = authority_updatecustomorgpermissions.userno

	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
