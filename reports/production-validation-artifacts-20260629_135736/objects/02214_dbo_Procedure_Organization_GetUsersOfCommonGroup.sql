-- ─── PROCEDURE→FUNCTION: organization_getusersofcommongroup ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
-- TODO: LEN was not fully converted; use length()
DROP FUNCTION IF EXISTS public.organization_getusersofcommongroup(bigint);
CREATE OR REPLACE FUNCTION public.organization_getusersofcommongroup(
    IN groupno bigint
) RETURNS SETOF record
AS $function$
DECLARE
    listofusers character varying;
    result table (userno int);
    index integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN



	ListOfUsers := (SELECT ListOfUsers FROM Organization_CommonGroups WHERE GroupNo = organization_getusersofcommongroup.groupno);

	Delimiter := ',';
	Item := NULL;
	WHILE LEN(ListOfUsers) > 0 LOOP

		Index := PATINDEX('%' || Delimiter || '%', ListOfUsers);
		IF Index > 0 THEN

			Item := SUBSTRING(ListOfUsers, 0, Index);
			ListOfUsers := SUBSTRING(ListOfUsers, LEN(Item + Delimiter) + 1, LEN(ListOfUsers));;
			INSERT INTO Result VALUES (CONVERT(INT, Item))

		END IF;
	
		ELSE BEGIN

			Item := ListOfUsers;
			ListOfUsers := NULL;;
			INSERT INTO Result VALUES (CONVERT(INT, Item))

		END LOOP;

	END;

	RETURN QUERY
	SELECT B.UserNo, U.ModUserNo, U.ModDate, U.UserID, U.Name, U.Name_EN, U.MailAddress, U.CellPhone, U.CompanyPhone,U.ExtensionNumber, U.UserPhoto, U.Photo, U.Enabled,
		D.DepartNo, D.Name AS DepartName, D.Name_EN AS DepartName_EN, D.SortNo AS DepartSortNo,
		P.PositionNo, P.Name AS PositionName, P.Name_EN AS PositionName_EN, P.SortNo AS PositionSortNo,
		COALESCE(DT.DutyNo, 0) AS DutyNo, COALESCE(DT.Name, '') AS DutyName, COALESCE(DT.Name_EN, '') AS DutyName_EN, COALESCE(DT.SortNo, 9999) AS DutySortNo
	FROM Organization_BelongToDepartment B
	INNER JOIN Organization_Users U ON U.UserNo = B.UserNo AND U.Enabled = TRUE AND U.IsVirtual = FALSE
	INNER JOIN Organization_Departments D ON D.DepartNo = B.DepartNo
	INNER JOIN Organization_Positions P ON P.PositionNo = B.PositionNo
	LEFT JOIN Organization_Duties DT ON DT.DutyNo = B.DutyNo
	WHERE B.IsDefault = TRUE AND B.UserNo IN (SELECT UserNo FROM Result)
	ORDER BY P.SortNo ASC, U.Name ASC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
