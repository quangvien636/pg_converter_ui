-- ─── FUNCTION: organization_insertinfoaddfield_sub ───────────────────────────────
DROP FUNCTION IF EXISTS public.organization_insertinfoaddfield_sub(integer, integer, integer, character varying, character varying, boolean);
CREATE OR REPLACE FUNCTION public.organization_insertinfoaddfield_sub(
    no integer,
    userno integer,
    moduserno integer,
    code character varying,
    name character varying,
    enabled boolean
) RETURNS TABLE(
    col1 text
)
AS $function$
DECLARE
    nosub integer;
BEGIN


	INSERT INTO Organization_Users_InfoAddfield_Sub (UserNo,No,RegDate,ModUserNo,ModDate,Code,Name,SortNo,Enabled)
	VALUES (UserNo,No,NOW(),ModUserNo,NOW(),Code,Name,
	(SELECT COALESCE(MAX(SortNo),0) + 1 FROM Organization_Users_InfoAddfield_Sub)
	,Enabled)


	SET NoSub = lastval()

	RETURN QUERY
	SELECT NoSub;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
