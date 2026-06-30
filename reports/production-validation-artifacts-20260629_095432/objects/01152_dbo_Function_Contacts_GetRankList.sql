-- ─── FUNCTION: contacts_getranklist ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_getranklist();
CREATE OR REPLACE FUNCTION public.contacts_getranklist(
) RETURNS TABLE(
    rownum text,
    seq text,
    firstname text,
    lastname text,
    memo text,
    viewcount text
)
-- TODO: TOP was preserved as comment; add LIMIT manually
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	RETURN QUERY
	SELECT /* TOP 10 */
		RowNum,
		Seq,
		FirstName,
		LastName,
		Memo,
		ViewCount
	FROM
	(
		SELECT
			ROW_NUMBER() OVER(ORDER BY ViewCount DESC) AS RowNum,
			U.Seq,
			U.FirstName,
			U.LastName,
			U.Memo,
			U.ViewCount	
		  FROM ContactsUser U
		  JOIN ContactsGroupUser G ON G.UserSeq = U.Seq
		WHERE U.RegUserNo = UserNo
		AND UseYn = 'Y'
	) A;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
