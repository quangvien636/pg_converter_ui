-- ─── FUNCTION: organization_insertinfoaddfield ───────────────────────────────
DROP FUNCTION IF EXISTS public.organization_insertinfoaddfield(integer, integer, character varying, character varying, integer, boolean, boolean, boolean);
CREATE OR REPLACE FUNCTION public.organization_insertinfoaddfield(
    userno integer,
    moduserno integer,
    code character varying,
    name character varying,
    type integer,
    modauth boolean,
    enabled boolean,
    display boolean
) RETURNS TABLE(
    col1 text
)
AS $function$
DECLARE
    no integer;
BEGIN


	INSERT INTO Organization_Users_InfoAddfield (UserNo,RegDate,ModUserNo,ModDate,Code,Name,Type,SortNo,ModAuth,Enabled,DisPlay)
	VALUES (UserNo,NOW(),ModUserNo,NOW(),Code,Name,Type,
	(SELECT COALESCE(MAX(SortNo),0) + 1 FROM Organization_Users_InfoAddfield)
	,ModAuth,Enabled,DisPlay)


	SET No = lastval()

	RETURN QUERY
	SELECT No;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
