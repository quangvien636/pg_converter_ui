-- ─── PROCEDURE→FUNCTION: organization_updateinfoaddfield ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.organization_updateinfoaddfield(integer, integer, integer, character varying, character varying, integer, integer, boolean, boolean, boolean);
CREATE OR REPLACE FUNCTION public.organization_updateinfoaddfield(
    IN no integer,
    IN userno integer,
    IN moduserno integer,
    IN code character varying,
    IN name character varying,
    IN type integer,
    IN sortno integer,
    IN modauth boolean,
    IN enabled boolean,
    IN display boolean
) RETURNS void
AS $function$
BEGIN


	UPDATE Organization_Users_InfoAddfield 
	UserNo := organization_updateinfoaddfield.userno;
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
