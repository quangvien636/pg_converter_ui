-- ─── PROCEDURE→FUNCTION: contacts_getoutfileexcel ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
-- TODO: LEN was not fully converted; use length()
DROP FUNCTION IF EXISTS public.contacts_getoutfileexcel(character varying);
CREATE OR REPLACE FUNCTION public.contacts_getoutfileexcel(
    IN userseqlist character varying DEFAULT '2,3,4,5'
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
			U.LastName,			
			U.FirstName,
			U.CallName,
			public."UF_ContactsDetailExcel"(U.Seq,'cellphone') AS cellphone,
			public."UF_ContactsDetailExcel"(U.Seq,'companyphone') AS companyphone,
			public."UF_ContactsDetailExcel"(U.Seq,'homephone') AS homephone,
			public."UF_ContactsDetailExcel"(U.Seq,'faxphone') AS faxphone,
			public."UF_ContactsDetailExcel"(U.Seq,'company') AS Company,
			public."UF_ContactsDetailExcel"(U.Seq,'Position') AS Position,
			public."UF_ContactsDetailExcel"(U.Seq,'Depart') As Depart,
			public."UF_ContactsDetailExcel"(U.Seq,'email') AS Email,
			public."UF_ContactsDetailExcel"(U.Seq,'companyzipcode') AS companyzipcode,
			public."UF_ContactsDetailExcel"(U.Seq,'companyaddress') AS companyaddress,
			public."UF_ContactsDetailExcel"(U.Seq,'homezipcode') AS homezipcode,
			public."UF_ContactsDetailExcel"(U.Seq,'homeaddress') AS homeaddress,
			public."UF_ContactsDetailExcel"(U.Seq,'homepage') AS homepage,
			U.Memo,
			public."UF_ContactsDetailExcel"(U.Seq,'group') AS GroupName,			
			U.RegDate,
			U.ModDate
		FROM ContactsUser U
		WHERE RegUserNo = UserNo
		AND UseYn = 'Y'
	END IF;
	ELSE
	

		UserSeqList := contacts_getoutfileexcel.userseqlist || ',';
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
			U.LastName,			
			U.FirstName,
			U.CallName,
			public."UF_ContactsDetailExcel"(U.Seq,'cellphone') AS cellphone,
			public."UF_ContactsDetailExcel"(U.Seq,'companyphone') AS companyphone,
			public."UF_ContactsDetailExcel"(U.Seq,'homephone') AS homephone,
			public."UF_ContactsDetailExcel"(U.Seq,'faxphone') AS faxphone,
			public."UF_ContactsDetailExcel"(U.Seq,'company') AS Company,
			public."UF_ContactsDetailExcel"(U.Seq,'Position') AS Position,
			public."UF_ContactsDetailExcel"(U.Seq,'Depart') As Depart,
			public."UF_ContactsDetailExcel"(U.Seq,'email') AS Email,
			public."UF_ContactsDetailExcel"(U.Seq,'companyzipcode') AS companyzipcode,
			public."UF_ContactsDetailExcel"(U.Seq,'companyaddress') AS companyaddress,
			public."UF_ContactsDetailExcel"(U.Seq,'homezipcode') AS homezipcode,
			public."UF_ContactsDetailExcel"(U.Seq,'homeaddress') AS homeaddress,
			public."UF_ContactsDetailExcel"(U.Seq,'homepage') AS homepage,
			U.Memo,
			public."UF_ContactsDetailExcel"(U.Seq,'group') AS GroupName,
			U.RegDate,
			U.ModDate
		FROM ContactsUser U
		WHERE 
		--RegUserNo = UserNo	AND
		 UseYn = 'Y'
		AND Seq IN (SELECT UserSeq FROM tabUser)
	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
