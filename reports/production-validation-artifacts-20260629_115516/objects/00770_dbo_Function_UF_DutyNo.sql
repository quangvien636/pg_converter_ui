-- ─── FUNCTION: uf_dutyno ───────────────────────────────
DROP FUNCTION IF EXISTS public.uf_dutyno();
CREATE OR REPLACE FUNCTION public.uf_dutyno(
) RETURNS character varying
AS $function$
DECLARE
    dutyno integer;
BEGIN

	-- Declare the return variable here

	SET DutyNo = 0


	-- Add the T-SQL statements to compute the return value here
	SELECT DutyNo = DutyNo
	FROM Organization_BelongToDepartment
	WHERE UserNo = UserNo


	-- Return the result of the function
	RETURN DutyNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
