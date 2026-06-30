-- ─── PROCEDURE→FUNCTION: contacts_getoutfile ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
-- TODO: LEN was not fully converted; use length()
DROP FUNCTION IF EXISTS public.contacts_getoutfile(character varying);
CREATE OR REPLACE FUNCTION public.contacts_getoutfile(
    IN userseqlist character varying DEFAULT 'ALL'
) RETURNS SETOF record
AS $function$
DECLARE
    tabuser table(userseq int);
    userseq integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	IF UserSeqList = 'ALL' THEN
		RETURN QUERY
		SELECT
			U.Seq,
			U.LastName,
			U.FirstName,
			public."UF_ContactsDetail"(U.Seq,'Position') AS Position,
			public."UF_ContactsDetail"(U.Seq,'number') AS Number,
			public."UF_ContactsDetail"(U.Seq,'company') AS Company,
			public."UF_ContactsDetail"(U.Seq,'Depart') As Depart,
			public."UF_ContactsDetail"(U.Seq,'group') AS GroupName,
			public."UF_ContactsDetail"(U.Seq,'email') AS Email,
			U.CheckDate,
			U.ModDate,
			U.RegDate
		FROM ContactsUser U
		WHERE RegUserNo = UserNo
		AND UseYn = 'Y'
	END IF;
	ELSE
	

		UserSeqList := contacts_getoutfile.userseqlist || ',';
		WHILE STRPOS(',UserSeqList, ') > 0 LOOP

			UserSeq := SUBSTRING(UserSeqList,0,STRPOS(',UserSeqList, '));;
			INSERT INTO tabUser
			(
				UserSeq
			)
			VALUES
			(
				UserSeq
			)
			
			UserSeqList := SUBSTRING(UserSeqList,STRPOS(',UserSeqList, ')+1,LEN(UserSeqList));
		END LOOP;
		
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
		AND Seq IN (SELECT UserSeq FROM tabUser)
	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
