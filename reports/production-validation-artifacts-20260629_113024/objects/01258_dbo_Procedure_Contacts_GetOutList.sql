-- ─── PROCEDURE→FUNCTION: contacts_getoutlist ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
-- TODO: LEN was not fully converted; use length()
DROP FUNCTION IF EXISTS public.contacts_getoutlist(character varying);
CREATE OR REPLACE FUNCTION public.contacts_getoutlist(
    IN grouplist character varying DEFAULT 'ALL'
) RETURNS SETOF record
AS $function$
DECLARE
    tabgroup table(groupno int);
    groupno integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	IF GroupList = 'ALL' THEN
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
	END IF;
	ELSIF GroupList = 'LIST' THEN
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
	END IF;
	ELSE

		GroupList := contacts_getoutlist.grouplist || ',';
		WHILE STRPOS(',GroupList, ') > 0 LOOP

			GroupNo := SUBSTRING(GroupList,0,STRPOS(',GroupList, '));;
			INSERT INTO tabGroup
			(
				GroupNo
			)
			VALUES
			(
				GroupNo
			)
			
			GroupList := SUBSTRING(GroupList,STRPOS(',GroupList, ')+1,LEN(GroupList));
		END LOOP;
		 
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
	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
