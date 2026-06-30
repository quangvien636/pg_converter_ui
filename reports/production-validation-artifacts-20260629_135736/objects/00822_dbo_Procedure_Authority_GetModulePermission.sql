-- ─── PROCEDURE→FUNCTION: authority_getmodulepermission ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.authority_getmodulepermission(integer, integer);
CREATE OR REPLACE FUNCTION public.authority_getmodulepermission(
    IN applicationno integer,
    IN userno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	RETURN QUERY
	SELECt COUNT(ApplicationNo) FROM Authority_ModulePermission
	WHERE ApplicationNo = authority_getmodulepermission.applicationno and (UserNo = authority_getmodulepermission.userno or DepartNo in(select DepartNo from Organization_BelongToDepartment where UserNo = authority_getmodulepermission.userno))
END;

/****** Object:  StoredProcedure public."Organization_GetUser"    Script Date: 2024-06-27 오전 11:58:45 ******/
/* BirthDateType 추가의 건 없으면 로그인 안됨 */
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
