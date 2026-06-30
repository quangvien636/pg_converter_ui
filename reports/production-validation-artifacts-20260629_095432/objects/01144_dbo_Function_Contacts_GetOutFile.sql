-- ─── FUNCTION: contacts_getoutfile ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_getoutfile(character varying);
CREATE OR REPLACE FUNCTION public.contacts_getoutfile(
    userseqlist character varying DEFAULT 'ALL'
) RETURNS TABLE(
    userseq text
)
-- TODO: LEN was not fully converted; use length()
AS $function$
DECLARE
    tabuser table(userseq int);
    userseq integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	IF UserSeqList = 'ALL'
	BEGIN
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
	END
	ELSE
	BEGIN
	

		SET UserSeqList = contacts_getoutfile.userseqlist || ','
		
		WHILE STRPOS(',UserSeqList, ') > 0
		BEGIN

			SET UserSeq = SUBSTRING(UserSeqList,0,STRPOS(',UserSeqList, '))
			
			INSERT INTO tabUser
			(
				UserSeq
			)
			VALUES
			(
				UserSeq
			)
			
			SET UserSeqList = SUBSTRING(UserSeqList,STRPOS(',UserSeqList, ')+1,LEN(UserSeqList))
		END
		
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
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
