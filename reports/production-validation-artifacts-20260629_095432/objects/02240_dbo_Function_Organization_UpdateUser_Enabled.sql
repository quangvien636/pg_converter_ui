-- ─── FUNCTION: organization_updateuser_enabled ───────────────────────────────
DROP FUNCTION IF EXISTS public.organization_updateuser_enabled(integer, integer, timestamp without time zone, boolean);
CREATE OR REPLACE FUNCTION public.organization_updateuser_enabled(
    userno integer,
    moduserno integer,
    moddate timestamp without time zone,
    enabled boolean
) RETURNS void
AS $function$
BEGIN


	IF (Enabled = FALSE) BEGIN
	
		DELETE FROM Center_Sessions WHERE UserNo = organization_updateuser_enabled.userno;
		DELETE FROM Center_MobileSessions WHERE UserNo = organization_updateuser_enabled.userno;
		DELETE FROM Organization_SortingEachDepartment WHERE UserNo = organization_updateuser_enabled.userno
			if((select count(*) from information_schema.tables where TABLE_NAME = 'CrewChat_PCSessions') >= 1)
		BEGIN;
			DELETE FROM CrewChat_PCSessions WHERE UserNo = organization_updateuser_enabled.userno
		END
	END

	IF (SELECT COUNT(*) FROM Center_Applications WHERE ProjectCode = 'Mail') > 0 BEGIN

	   UPDATE Mail_Accounts SET
			ModUserNo = organization_updateuser_enabled.moduserno,
			ModDate = organization_updateuser_enabled.moddate,
			Enabled = organization_updateuser_enabled.enabled
		WHERE UserNo = organization_updateuser_enabled.userno

	END


	UPDATE Organization_Users SET
		ModUserNo = organization_updateuser_enabled.moduserno,
		ModDate = organization_updateuser_enabled.moddate,
		Enabled = organization_updateuser_enabled.enabled
	WHERE UserNo = organization_updateuser_enabled.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
