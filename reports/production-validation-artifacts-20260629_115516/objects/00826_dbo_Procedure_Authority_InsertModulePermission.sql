-- ─── PROCEDURE→FUNCTION: authority_insertmodulepermission ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.authority_insertmodulepermission(integer, character varying, integer, integer, integer);
CREATE OR REPLACE FUNCTION public.authority_insertmodulepermission(
    IN applicationno integer,
    IN userofdepart character varying,
    IN reguserno integer,
    IN userno integer DEFAULT 0,
    IN departno integer DEFAULT 0
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
