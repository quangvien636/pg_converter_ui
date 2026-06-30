-- ─── PROCEDURE→FUNCTION: contacts_getuserdatahistory ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.contacts_getuserdatahistory(integer, integer, integer);
CREATE OR REPLACE FUNCTION public.contacts_getuserdatahistory(
    IN historyno integer,
    IN reguserno integer,
    IN userseq integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	IF Key = 'number' THEN
		RETURN QUERY
		SELECT Value, Type FROM ContactsNumberHistory WHERE HistoryNo=contacts_getuserdatahistory.historyno AND RegUserNo=contacts_getuserdatahistory.reguserno AND UserSeq=contacts_getuserdatahistory.userseq ORDER BY IsDefault DESC, Seq DESC

	ELSIF Key = 'email' THEN
		RETURN QUERY
		SELECT Value FROM ContactsEmailHistory WHERE HistoryNo=contacts_getuserdatahistory.historyno AND RegUserNo=contacts_getuserdatahistory.reguserno AND UserSeq=contacts_getuserdatahistory.userseq ORDER BY IsDefault DESC, Seq DESC

	ELSIF Key = 'days' THEN
		RETURN QUERY
		SELECT Value FROM ContactsDaysHistory WHERE HistoryNo=contacts_getuserdatahistory.historyno AND RegUserNo=contacts_getuserdatahistory.reguserno AND UserSeq=contacts_getuserdatahistory.userseq ORDER BY IsDefault DESC, Seq DESC

	ELSIF Key = 'comp' THEN
		RETURN QUERY
		SELECT Company FROM ContactsCompanyHistory WHERE HistoryNo=contacts_getuserdatahistory.historyno AND RegUserNo=contacts_getuserdatahistory.reguserno AND UserSeq=contacts_getuserdatahistory.userseq ORDER BY IsDefault DESC, Seq DESC

	ELSIF Key = 'dept' THEN
		RETURN QUERY
		SELECT Depart FROM ContactsCompanyHistory WHERE HistoryNo=contacts_getuserdatahistory.historyno AND RegUserNo=contacts_getuserdatahistory.reguserno AND UserSeq=contacts_getuserdatahistory.userseq ORDER BY IsDefault DESC, Seq DESC

	ELSIF Key = 'position' THEN
		RETURN QUERY
		SELECT Position FROM ContactsCompanyHistory WHERE HistoryNo=contacts_getuserdatahistory.historyno AND RegUserNo=contacts_getuserdatahistory.reguserno AND UserSeq=contacts_getuserdatahistory.userseq ORDER BY IsDefault DESC, Seq DESC

	ELSIF Key = 'addr' THEN
		RETURN QUERY
		SELECT '(' || ZipCode1 || '-' || ZipCode2 || ')' || Address Address FROM ContactsAddressHistory
        WHERE HistoryNo=contacts_getuserdatahistory.historyno AND RegUserNo=contacts_getuserdatahistory.reguserno AND UserSeq=contacts_getuserdatahistory.userseq AND IsDefault='1'

	ELSIF Key = 'sns' THEN
		RETURN QUERY
		SELECT Value FROM ContactsSnsHistory WHERE HistoryNo=contacts_getuserdatahistory.historyno AND RegUserNo=contacts_getuserdatahistory.reguserno AND UserSeq=contacts_getuserdatahistory.userseq ORDER BY IsDefault DESC, Seq DESC

	ELSIF Key = 'memo' THEN
		RETURN QUERY
		SELECT Memo FROM ContactsUserHistory WHERE HistoryNo=contacts_getuserdatahistory.historyno AND RegUserNo=contacts_getuserdatahistory.reguserno AND Seq=contacts_getuserdatahistory.userseq

	ELSIF Key = 'firstname' THEN
		RETURN QUERY
		SELECT FirstName FROM ContactsUserHistory WHERE HistoryNo=contacts_getuserdatahistory.historyno AND RegUserNo=contacts_getuserdatahistory.reguserno AND Seq=contacts_getuserdatahistory.userseq

	ELSIF Key = 'lastname' THEN
		RETURN QUERY
		SELECT LastName FROM ContactsUserHistory WHERE HistoryNo=contacts_getuserdatahistory.historyno AND RegUserNo=contacts_getuserdatahistory.reguserno AND Seq=contacts_getuserdatahistory.userseq

	ELSIF Key = 'callname' THEN
		RETURN QUERY
		SELECT CallName FROM ContactsUserHistory WHERE HistoryNo=contacts_getuserdatahistory.historyno AND RegUserNo=contacts_getuserdatahistory.reguserno AND Seq=contacts_getuserdatahistory.userseq

	ELSIF Key = 'deldate' THEN
		RETURN QUERY
		SELECT DelDate FROM ContactsUserHistory WHERE HistoryNo=contacts_getuserdatahistory.historyno AND RegUserNo=contacts_getuserdatahistory.reguserno AND Seq=contacts_getuserdatahistory.userseq
	ELSIF Key = 'group' THEN
		RETURN QUERY
		SELECT G.GroupName
		From ContactsGroupUserHistory GU
		LEFT JOIN ContactsGroup G ON G.GroupNo = GU.GroupNo
		WHERE HistoryNo=contacts_getuserdatahistory.historyno
		AND GU.RegUserNo = contacts_getuserdatahistory.reguserno
		AND GU.UserSeq = contacts_getuserdatahistory.userseq
		ORDER BY G.Sort;
	ELSE
		RETURN QUERY
		SELECT FirstName, LastName, CallName, Memo, Share FROM ContactsUserHistory
		WHERE HistoryNo=contacts_getuserdatahistory.historyno AND RegUserNo=contacts_getuserdatahistory.reguserno and Seq=contacts_getuserdatahistory.userseq;

		RETURN QUERY
		SELECT Type,TypeName,Value,IsDefault FROM ContactsNumberHistory
		WHERE HistoryNo=contacts_getuserdatahistory.historyno AND RegUserNo=contacts_getuserdatahistory.reguserno AND UserSeq=contacts_getuserdatahistory.userseq AND Value != '';

		RETURN QUERY
		SELECT Value,IsDefault FROM ContactsEmailHistory
		WHERE HistoryNo=contacts_getuserdatahistory.historyno AND RegUserNo=contacts_getuserdatahistory.reguserno AND UserSeq=contacts_getuserdatahistory.userseq;

		RETURN QUERY
		SELECT Type,TypeName,Value,IsDefault,SolarLunar FROM ContactsDaysHistory
		WHERE HistoryNo=contacts_getuserdatahistory.historyno AND RegUserNo=contacts_getuserdatahistory.reguserno AND UserSeq=contacts_getuserdatahistory.userseq;

		RETURN QUERY
		SELECT Company,Depart,Position,IsDefault FROM ContactsCompanyHistory
		WHERE HistoryNo=contacts_getuserdatahistory.historyno AND RegUserNo=contacts_getuserdatahistory.reguserno AND UserSeq=contacts_getuserdatahistory.userseq;

		RETURN QUERY
		SELECT Type,TypeName,ZipCode1,ZipCode2,Address,IsDefault FROM ContactsAddressHistory
        WHERE HistoryNo=contacts_getuserdatahistory.historyno AND RegUserNo=contacts_getuserdatahistory.reguserno AND UserSeq=contacts_getuserdatahistory.userseq;

        RETURN QUERY
        SELECT Value,IsDefault FROM ContactsSnsHistory
        WHERE HistoryNo=contacts_getuserdatahistory.historyno AND RegUserNo=contacts_getuserdatahistory.reguserno AND UserSeq=contacts_getuserdatahistory.userseq;

        RETURN QUERY
        SELECT G.GroupNo,GroupName FROM ContactsGroup G
        INNER JOIN ContactsGroupUserHistory GU ON G.GroupNo=GU.GroupNo
        WHERE HistoryNo=contacts_getuserdatahistory.historyno AND GU.RegUserNo=contacts_getuserdatahistory.reguserno and UserSeq=contacts_getuserdatahistory.userseq;
	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.