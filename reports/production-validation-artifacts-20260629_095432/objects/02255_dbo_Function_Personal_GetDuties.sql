-- ─── FUNCTION: personal_getduties ───────────────────────────────
DROP FUNCTION IF EXISTS public.personal_getduties();
CREATE OR REPLACE FUNCTION public.personal_getduties(
) RETURNS TABLE(
    dutyno text,
    name text,
    sortno text
)
AS $function$
BEGIN

	RETURN QUERY
	SELECT DutyNo, Name, SortNo FROM Duties
	WHERE Enabled = TRUE
	ORDER BY SortNo
END



RETURN QUERY
select * from Duties;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
