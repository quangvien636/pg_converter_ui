-- ─── FUNCTION: uf_positionno ───────────────────────────────
DROP FUNCTION IF EXISTS public.uf_positionno();
CREATE OR REPLACE FUNCTION public.uf_positionno(
) RETURNS character varying
AS $function$
DECLARE
    positionno integer;
BEGIN

	-- Declare the return variable here

	SET PositionNo = 0


	-- Add the T-SQL statements to compute the return value here
	SELECT PositionNo = MIN(P.SortNo)
	FROM Organization_BelongToDepartment B
	INNER JOIN Organization_Positions P ON P.PositionNo = B.PositionNo AND B.UserNo = UserNo
	


	-- Return the result of the function
	RETURN PositionNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
