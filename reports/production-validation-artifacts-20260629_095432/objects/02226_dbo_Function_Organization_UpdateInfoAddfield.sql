-- ─── FUNCTION: organization_updateinfoaddfield ───────────────────────────────
DROP FUNCTION IF EXISTS public.organization_updateinfoaddfield(integer, integer, integer, character varying, character varying, integer, integer, boolean, boolean, boolean);
CREATE OR REPLACE FUNCTION public.organization_updateinfoaddfield(
    no integer,
    userno integer,
    moduserno integer,
    code character varying,
    name character varying,
    type integer,
    sortno integer,
    modauth boolean,
    enabled boolean,
    display boolean
) RETURNS void
AS $function$
BEGIN


	UPDATE Organization_Users_InfoAddfield 
	SET
	UserNo = organization_updateinfoaddfield.userno
	,RegDate = NOW()
	,ModUserNo = organization_updateinfoaddfield.moduserno
	,ModDate = NOW()
	,Code = organization_updateinfoaddfield.code
	,Name = organization_updateinfoaddfield.name
	,Type = organization_updateinfoaddfield.type
	,SortNo = organization_updateinfoaddfield.sortno
	,ModAuth = organization_updateinfoaddfield.modauth
	,Enabled = organization_updateinfoaddfield.enabled
	,DisPlay = organization_updateinfoaddfield.display
	WHERE No = organization_updateinfoaddfield.no;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
