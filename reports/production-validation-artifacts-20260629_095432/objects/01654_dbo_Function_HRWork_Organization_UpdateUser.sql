-- ─── FUNCTION: hrwork_organization_updateuser ───────────────────────────────
DROP FUNCTION IF EXISTS public.hrwork_organization_updateuser(integer, integer, character varying);
CREATE OR REPLACE FUNCTION public.hrwork_organization_updateuser(
    userno integer,
    positionno integer,
    cellphone character varying
) RETURNS void
AS $function$
BEGIN

	
	update Organization_Users 
	set CellPhone = hrwork_organization_updateuser.cellphone
	,CompanyPhone = CompanyPhone
	where UserNo = hrwork_organization_updateuser.userno

	update Organization_BelongToDepartment 
	set PositionNo = hrwork_organization_updateuser.positionno
	where UserNo = hrwork_organization_updateuser.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
