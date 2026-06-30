-- ─── FUNCTION: workingtimev3_getuser ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtimev3_getuser(integer);
CREATE OR REPLACE FUNCTION public.workingtimev3_getuser(
    p_uno integer
) RETURNS TABLE(
    col1 text,
    col2 text,
    col3 text,
    userno text
)
AS $function$
BEGIN

		   RETURN QUERY
		   SELECT
		   		1 AS RowNum
				, pTotal = 1
				,U.UserNo, U.UserID, U.Name, U.Name_EN
				,D.DepartNo, D.Name AS DepartName, D.Name_EN AS DepartName_EN
				,P.PositionNo, P.Name AS PositionName, P.Name_EN AS PositionName_EN
				,U.BirthDate
				, public."WorkingTime_GetCompanyName"(U.UserNo,'') as Company
			FROM (select max(BelongNo) BelongNo,max(PositionNo) PositionNo, max(DepartNo) DepartNo,  UserNo from  Organization_BelongToDepartment group by UserNo) B 
			INNER JOIN Organization_Users U  ON U.UserNo = B.UserNo  AND U.IsVirtual = FALSE
			INNER JOIN Organization_Positions P  ON P.PositionNo = B.PositionNo
			INNER JOIN Organization_Departments D  ON D.DepartNo = B.DepartNo
			WHERE B.UserNo = workingtimev3_getuser.p_uno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
