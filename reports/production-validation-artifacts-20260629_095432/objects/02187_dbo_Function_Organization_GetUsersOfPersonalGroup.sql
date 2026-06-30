-- ─── FUNCTION: organization_getusersofpersonalgroup ───────────────────────────────
DROP FUNCTION IF EXISTS public.organization_getusersofpersonalgroup(bigint);
CREATE OR REPLACE FUNCTION public.organization_getusersofpersonalgroup(
    groupno bigint
) RETURNS TABLE(
    seq text
)
-- TODO: LEN was not fully converted; use length()
AS $function$
DECLARE
    listofusers character varying;
    result_users table (userno int);
    result_contacts table (seq int);
    index integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN



	SET ListOfUsers = (SELECT ListOfUsers FROM Organization_PersonalGroups WHERE GroupNo = organization_getusersofpersonalgroup.groupno)


	SET Delimiter = ','
	SET Item = NULL
 



	WHILE LEN(ListOfUsers) > 0 BEGIN

		SET Index = PATINDEX('%' || Delimiter || '%', ListOfUsers)

		IF Index > 0 BEGIN

			SET Item = SUBSTRING(ListOfUsers, 0, Index)
			SET ListOfUsers = SUBSTRING(ListOfUsers, LEN(Item + Delimiter) + 1, LEN(ListOfUsers))

			IF (STRPOS(Item, 'C') = 0) BEGIN

				INSERT INTO Result_Users VALUES (CONVERT(INT, Item))

			END

			ELSE BEGIN

				INSERT INTO Result_Contacts VALUES (CONVERT(INT, SUBSTRING(Item, 2, LEN(Item) - 1)))

			END

		END
	
		ELSE BEGIN

			SET Item = ListOfUsers
			SET ListOfUsers = NULL

			IF (STRPOS(Item, 'C') = 0) BEGIN

				INSERT INTO Result_Users VALUES (CONVERT(INT, Item))

			END

			ELSE BEGIN

				INSERT INTO Result_Contacts VALUES (CONVERT(INT, SUBSTRING(Item, 2, LEN(Item) - 1)))

			END

		END

	END

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
	WHERE B.IsDefault = TRUE AND B.UserNo IN (SELECT UserNo FROM Result_Users)
	ORDER BY P.SortNo ASC, U.Name ASC

	IF ((SELECT COUNT(*) FROM Center_Applications WHERE ProjectCode = 'Contacts') = 1) BEGIN

		RETURN QUERY
		SELECT U.Seq, (U.LastName + U.FirstName) AS Name, E.Value AS MailAddress, C.Company AS Company, C.Position AS Position, COALESCE(N.Value,'') AS CellPhone
		FROM ContactsUser U
		INNER JOIN ContactsEmail E ON E.UserSeq = U.Seq
		LEFT JOIN ContactsCompany C ON C.UserSeq = U.Seq
		LEFT JOIN ContactsNumber N ON N.UserSeq = U.Seq AND N.IsDefault = TRUE AND N.Type = 0
		WHERE U.Seq IN (SELECT Seq FROM Result_Contacts)

	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
