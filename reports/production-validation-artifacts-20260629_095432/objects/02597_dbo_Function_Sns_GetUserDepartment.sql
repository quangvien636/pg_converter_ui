-- ─── FUNCTION: sns_getuserdepartment ───────────────────────────────
DROP FUNCTION IF EXISTS public.sns_getuserdepartment();
CREATE OR REPLACE FUNCTION public.sns_getuserdepartment(
) RETURNS TABLE(
    userno text,
    posname text,
    depname text
)
AS $function$
BEGIN

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	
    -- INSERT INTO statements for procedure here
	RETURN QUERY
	SELECT B.UserNo, P.Name AS PosName, D.Name AS DepName FROM Organization_BelongToDepartment B
	INNER JOIN Organization_Departments D ON B.DepartNo=D.DepartNo
	INNER JOIN Organization_Positions P ON B.PositionNo=P.PositionNo
	WHERE UserNo = UserNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
