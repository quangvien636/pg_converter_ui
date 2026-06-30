-- ─── FUNCTION: schedule_getchilddeparts ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_getchilddeparts();
CREATE OR REPLACE FUNCTION public.schedule_getchilddeparts(
) RETURNS TABLE(
    departno text
)
AS $function$
BEGIN

	WITH DEPT_CTE (DepartNo) AS 
	(
		SELECT DepartNo
		FROM Organization_Departments
		WHERE DepartNo = DepartNo
		AND Enabled = TRUE
		UNION ALL
		SELECT PD.DepartNo
		FROM Organization_Departments PD JOIN DEPT_CTE DC ON PD.ParentNo = DC.DepartNo
		AND PD.Enabled = TRUE
	)
	RETURN QUERY
	SELECT DepartNo
	FROM DEPT_CTE;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
