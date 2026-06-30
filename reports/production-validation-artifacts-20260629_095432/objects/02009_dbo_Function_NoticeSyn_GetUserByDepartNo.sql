-- ─── FUNCTION: noticesyn_getuserbydepartno ───────────────────────────────
DROP FUNCTION IF EXISTS public.noticesyn_getuserbydepartno(integer);
CREATE OR REPLACE FUNCTION public.noticesyn_getuserbydepartno(
    departno integer
) RETURNS TABLE(
    departno text,
    userno text,
    userid text
)
AS $function$
BEGIN

RETURN QUERY
select b.DepartNo,u.userNo,u.UserID from Organization_BelongToDepartment b inner join Organization_Users u on b.UserNo=u.Userno 
where b.departno=noticesyn_getuserbydepartno.departno and u.Enabled = TRUE;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
