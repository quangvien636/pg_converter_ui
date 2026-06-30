-- ─── FUNCTION: contacts_getuser_touserno ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_getuser_touserno(integer);
CREATE OR REPLACE FUNCTION public.contacts_getuser_touserno(
    userno integer
) RETURNS TABLE(
    seq text,
    firstname text,
    lastname text,
    reguserno text,
    memo text,
    regdate text,
    photo text,
    moddate text,
    checkdate text,
    share text,
    useyn text,
    deldate text,
    important text,
    callname text
)
AS $function$
BEGIN

	RETURN QUERY
	SELECT
	U.Seq
	,U.FirstName
	,U.LastName
	,U.RegUserNo
	,U.Memo
	,U.RegDate
	,U.Photo
	,U.ModDate
	,U.CheckDate
	,U.Share
	,U.UseYn
	,U.DelDate
	,U.Important
	,U.CallName
	FROM ContactsUser U
	WHERE U.Seq = contacts_getuser_touserno.userno
	AND U.UseYn = 'Y';
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
