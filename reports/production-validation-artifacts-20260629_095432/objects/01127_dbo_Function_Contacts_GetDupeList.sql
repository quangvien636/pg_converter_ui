-- ─── FUNCTION: contacts_getdupelist ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_getdupelist();
CREATE OR REPLACE FUNCTION public.contacts_getdupelist(
) RETURNS TABLE(
    value text
)
AS $function$
BEGIN

	RETURN QUERY
	SELECT U.Seq, FirstName, LastName, E.Seq AS E_Seq, E.Value AS EMail, N.Seq AS N_Seq, N.Value AS Number,
		RANK() OVER(ORDER BY E.Value) AS Group1,
		RANK() OVER(ORDER BY N.Value) AS Group2
	FROM ContactsUser U
	LEFT JOIN ContactsEmail E ON U.Seq = E.UserSeq
	LEFT JOIN ContactsNumber N ON U.Seq = N.UserSeq
	WHERE U.RegUserNo = UserNo
	AND UseYn = 'Y'
	AND (
		 E.Value IN (
			SELECT 
				Value
			FROM ContactsEmail
			WHERE RegUserNo = UserNo
			AND Value <> ''
			GROUP BY Value
			HAVING COUNT(VALUE) > 1
		 ) OR
		 N.Value IN (
			SELECT
				Value
			FROM ContactsNumber
			WHERE RegUserNo = UserNo
			AND Value <> ''
			GROUP BY Value
			HAVING COUNT(VALUE) > 1
		 )
	);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
