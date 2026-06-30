-- ─── FUNCTION: organization_update_addfields ───────────────────────────────
DROP FUNCTION IF EXISTS public.organization_update_addfields(integer, character varying, character varying);
CREATE OR REPLACE FUNCTION public.organization_update_addfields(
    userno integer,
    userid character varying,
    value character varying
) RETURNS TABLE(
    col1 text
)
AS $function$
DECLARE
    puserid character varying;
BEGIN


		RETURN QUERY
		SELECT
		pUserId = organization_update_addfields.userid
	FROM Organization_Users_Addfields WHERE UserNo = organization_update_addfields.userno and key = Key

	IF pUserId is null
	BEGIN;
		INSERT INTO Organization_Users_Addfields VALUES(UserNo,UserId,Key,Value)
	END
	ELSE
	BEGIN;
		UPDATe Organization_Users_Addfields
		SET Value = organization_update_addfields.value
		WHERE UserNo = organization_update_addfields.userno
		and key = Key
	END


	IF (select count(*) from Center_CompanyInformation where value = 'ngw.pncport.com' and Key = 'Company_Domain') = 1 AND Key = 'EmpNo'
	BEGIN

			if (select count(*) from erprbrdgmapping where userid = organization_update_addfields.userid) = 1
			begin;
				update erprbrdgmapping set empno = organization_update_addfields.value where userid = organization_update_addfields.userid
			end
			else
			begin;
				INSERT INTO erprbrdgmapping(empno,userid) values(Value,UserId)
			end
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
