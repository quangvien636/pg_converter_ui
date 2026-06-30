-- ─── FUNCTION: work_userno ───────────────────────────────
DROP FUNCTION IF EXISTS public.work_userno(integer);
CREATE OR REPLACE FUNCTION public.work_userno(
    userno integer
) RETURNS character varying
-- TODO: TOP was preserved as comment; add LIMIT manually
AS $function$
DECLARE
    reuserno integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	

	SET reUserNo = 1


	SELECT reUserNo = work_userno.userno FROM Organization_Users WHERE UserID = (
	SELECT /* TOP 1 */ UserID from CrewCloud_Company_1107.public."Organization_Users" where userno = work_userno.userno)
	
	
	RETURN reUserNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
