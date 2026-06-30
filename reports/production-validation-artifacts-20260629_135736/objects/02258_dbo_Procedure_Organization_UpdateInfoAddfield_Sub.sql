-- ─── PROCEDURE→FUNCTION: organization_updateinfoaddfield_sub ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.organization_updateinfoaddfield_sub(integer, integer, integer, character varying, character varying, boolean);
CREATE OR REPLACE FUNCTION public.organization_updateinfoaddfield_sub(
    IN nosub integer,
    IN userno integer,
    IN moduserno integer,
    IN code character varying,
    IN name character varying,
    IN enabled boolean
) RETURNS void
AS $function$
BEGIN


	UPDATE Organization_Users_InfoAddfield_Sub 
	UserNo := organization_updateinfoaddfield_sub.userno;
	,RegDate = NOW()
	,ModUserNo = organization_updateinfoaddfield_sub.moduserno
	,ModDate = NOW()
	,Code = organization_updateinfoaddfield_sub.code
	,Name = organization_updateinfoaddfield_sub.name
	,Enabled = organization_updateinfoaddfield_sub.enabled
	WHERE NoSub = organization_updateinfoaddfield_sub.nosub;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
