-- ─── FUNCTION: authority_insertmodulepermission ───────────────────────────────
DROP FUNCTION IF EXISTS public.authority_insertmodulepermission(integer, character varying, integer, integer, integer);
CREATE OR REPLACE FUNCTION public.authority_insertmodulepermission(
    applicationno integer,
    userofdepart character varying,
    reguserno integer,
    userno integer DEFAULT 0,
    departno integer DEFAULT 0
) RETURNS void
AS $function$
BEGIN

	INSERT INTO Authority_ModulePermission
	(ApplicationNo,UserNo,DepartNo,UserofDepart,RegUserNo,RegDate)
	VALUES(ApplicationNo,UserNo,DepartNo,UserofDepart,RegUserNo,NOW());
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
