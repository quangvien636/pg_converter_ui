-- ─── FUNCTION: contacts_getoutlist ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_getoutlist(character varying);
CREATE OR REPLACE FUNCTION public.contacts_getoutlist(
    grouplist character varying DEFAULT 'ALL'
) RETURNS TABLE(
    groupno text
)
-- TODO: LEN was not fully converted; use length()
AS $function$
DECLARE
    tabgroup table(groupno int);
    groupno integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	IF GroupList = 'ALL'
	BEGIN
		RETURN QUERY
		SELECT
			Seq,
			LastName,
			FirstName,
			CheckDate,
			ModDate,
			RegDate,
			Company,
			Depart,
			Position,
			Email,
			Number,
			GroupName
		FROM 
		(
			SELECT
				ROW_NUMBER() OVER(ORDER BY U.ModDate DESC) AS RowNum,
				U.Seq,
				U.LastName,
				U.FirstName,
				U.CheckDate,
				U.ModDate,
				U.RegDate,
				public."UF_ContactsDetail"(U.Seq,'company') AS Company,
				public."UF_ContactsDetail"(U.Seq,'Depart') As Depart,
				public."UF_ContactsDetail"(U.Seq,'Position') AS Position,
				public."UF_ContactsDetail"(U.Seq,'email') AS Email,
				public."UF_ContactsDetail"(U.Seq,'number') AS Number,
				public."UF_ContactsDetail"(U.Seq,'group') AS GroupName
			FROM ContactsUser U
			WHERE RegUserNo = UserNo
			AND UseYn = 'Y'
		) A
		WHERE 1>0
	END
	ELSE IF GroupList = 'LIST'
	BEGIN
		RETURN QUERY
		SELECT
			U.Seq,
			U.LastName,
			U.FirstName,
			U.CheckDate,
			U.ModDate,
			U.RegDate,
			public."UF_ContactsDetail"(U.Seq,'company') AS Company,
			public."UF_ContactsDetail"(U.Seq,'Depart') As Depart,
			public."UF_ContactsDetail"(U.Seq,'Position') AS Position,
			public."UF_ContactsDetail"(U.Seq,'email') AS Email,
			public."UF_ContactsDetail"(U.Seq,'number') AS Number,
			public."UF_ContactsDetail"(U.Seq,'group') AS GroupName
		FROM ContactsUser U
		WHERE RegUserNo = UserNo
		AND UseYn = 'Y'
	END
	ELSE
	BEGIN

		SET GroupList = contacts_getoutlist.grouplist || ','
		
		WHILE STRPOS(',GroupList, ') > 0
		BEGIN

			SET GroupNo = SUBSTRING(GroupList,0,STRPOS(',GroupList, '))
			
			INSERT INTO tabGroup
			(
				GroupNo
			)
			VALUES
			(
				GroupNo
			)
			
			SET GroupList = SUBSTRING(GroupList,STRPOS(',GroupList, ')+1,LEN(GroupList))
		END
		 
		RETURN QUERY
		SELECT
			Seq,
			LastName,
			FirstName,
			CheckDate,
			ModDate,
			RegDate,
			Company,
			Depart,
			Position,
			Email,
			Number,
			GroupName
		FROM 
		(
			SELECT
				ROW_NUMBER() OVER(ORDER BY U.ModDate DESC) AS RowNum,
				U.Seq,
				U.LastName,
				U.FirstName,
				U.CheckDate,
				U.ModDate,
				U.RegDate,
				public."UF_ContactsDetail"(U.Seq,'company') AS Company,
				public."UF_ContactsDetail"(U.Seq,'Depart') As Depart,
				public."UF_ContactsDetail"(U.Seq,'Position') AS Position,
				public."UF_ContactsDetail"(U.Seq,'email') AS Email,
				public."UF_ContactsDetail"(U.Seq,'number') AS Number,
				public."UF_ContactsDetail"(U.Seq,'group') AS GroupName
			FROM ContactsUser U
			JOIN ContactsGroupUser G ON U.Seq = G.UserSeq
			JOIN ContactsGroup GR ON G.GroupNo=GR.GroupNo
			WHERE U.RegUserNo = UserNo
			AND U.UseYn = 'Y'
			AND G.GroupNo IN (SELECT GroupNo FROM tabGroup)
		) A
		WHERE 1>0
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
