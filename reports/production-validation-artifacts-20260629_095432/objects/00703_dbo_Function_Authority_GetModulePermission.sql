-- ─── FUNCTION: authority_getmodulepermission ───────────────────────────────
DROP FUNCTION IF EXISTS public.authority_getmodulepermission(integer, integer);
CREATE OR REPLACE FUNCTION public.authority_getmodulepermission(
    applicationno integer,
    userno integer
) RETURNS TABLE(
    departno text
)
AS $function$
BEGIN

	RETURN QUERY
	SELECt COUNT(ApplicationNo) FROM Authority_ModulePermission
	WHERE ApplicationNo = authority_getmodulepermission.applicationno and (UserNo = authority_getmodulepermission.userno or DepartNo in(select DepartNo from Organization_BelongToDepartment where UserNo = authority_getmodulepermission.userno))
END

/****** Object:  StoredProcedure public."Organization_GetUser"    Script Date: 2024-06-27 오전 11:58:45 ******/
/* BirthDateType 추가의 건 없으면 로그인 안됨 */
SET ANSI_NULLS ON;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
