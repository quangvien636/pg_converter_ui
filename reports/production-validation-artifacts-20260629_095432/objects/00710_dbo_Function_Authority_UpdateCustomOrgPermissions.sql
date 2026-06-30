-- ─── FUNCTION: authority_updatecustomorgpermissions ───────────────────────────────
DROP FUNCTION IF EXISTS public.authority_updatecustomorgpermissions(integer, integer, timestamp without time zone, integer);
CREATE OR REPLACE FUNCTION public.authority_updatecustomorgpermissions(
    userno integer,
    moduserno integer,
    moddate timestamp without time zone,
    permissiontype integer
) RETURNS void
AS $function$
BEGIN


	IF ((SELECT COUNT(*) FROM Authority_CustomOrgPermissions WHERE UserNo = authority_updatecustomorgpermissions.userno) = 0) BEGIN
	
		INSERT INTO Authority_CustomOrgPermissions (UserNo, ModUserNo, ModDate, PermissionType)
		VALUES (UserNo, ModUserNo, ModDate, PermissionType)
	
	END

	ELSE BEGIN
	
		UPDATE Authority_CustomOrgPermissions SET ModUserNo = authority_updatecustomorgpermissions.moduserno, ModDate = authority_updatecustomorgpermissions.moddate, PermissionType = authority_updatecustomorgpermissions.permissiontype
		WHERE UserNo = authority_updatecustomorgpermissions.userno

	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
