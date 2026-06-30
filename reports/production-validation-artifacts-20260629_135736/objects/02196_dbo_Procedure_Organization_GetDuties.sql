-- ─── PROCEDURE→FUNCTION: organization_getduties ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.organization_getduties(boolean);
CREATE OR REPLACE FUNCTION public.organization_getduties(
    IN alsodisabled boolean
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	IF AlsoDisabled = 1 THEN

		RETURN QUERY
		SELECT D.DutyNo, D.ModUserNo, U.Name AS ModUserName, U.Name_EN AS ModUserName_EN, U.Name_CH AS ModUserName_CH, U.Name_JP AS ModUserName_JP, U.Name_VN AS ModUserName_VN,
			D.ModDate, D.Name, D.Name_EN, D.SortNo, D.Enabled,D.Name_CH,D.Name_JP,D.Name_VN
		FROM Organization_Duties D
		LEFT JOIN Organization_Users U ON U.UserNo = D.ModUserNo
		ORDER BY SortNo ASC

	END IF;

	ELSE BEGIN

		RETURN QUERY
		SELECT D.DutyNo, D.ModUserNo, U.Name AS ModUserName, U.Name_EN AS ModUserName_EN, U.Name_CH AS ModUserName_CH, U.Name_JP AS ModUserName_JP, U.Name_VN AS ModUserName_VN,
			D.ModDate, D.Name, D.Name_EN, D.SortNo, D.Enabled,D.Name_CH,D.Name_JP,D.Name_VN
		FROM Organization_Duties D
		LEFT JOIN Organization_Users U ON U.UserNo = D.ModUserNo
		WHERE D.Enabled = TRUE
		ORDER BY SortNo ASC

	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
