-- ─── PROCEDURE→FUNCTION: contacts_getuserdata ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.contacts_getuserdata(integer, integer);
CREATE OR REPLACE FUNCTION public.contacts_getuserdata(
    IN reguserno integer,
    IN userseq integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	IF Key = 'number' THEN
		RETURN QUERY
		SELECT Value, Type FROM ContactsNumber  WHERE RegUserNo=contacts_getuserdata.reguserno AND UserSeq=contacts_getuserdata.userseq AND IsDefault='1'

	ELSIF Key = 'email' THEN
		RETURN QUERY
		SELECT Value,0 AS Type FROM ContactsEmail  WHERE RegUserNo=contacts_getuserdata.reguserno AND UserSeq=contacts_getuserdata.userseq AND IsDefault='1'

	ELSIF Key = 'days' THEN
		RETURN QUERY
		SELECT Value,0 AS Type FROM ContactsDays  WHERE RegUserNo=contacts_getuserdata.reguserno AND UserSeq=contacts_getuserdata.userseq AND IsDefault='1'

	ELSIF Key = 'comp' THEN
		RETURN QUERY
		SELECT Company As Value ,0 AS Type FROM ContactsCompany  WHERE RegUserNo=contacts_getuserdata.reguserno AND UserSeq=contacts_getuserdata.userseq AND IsDefault='1'

	ELSIF Key = 'dept' THEN
		RETURN QUERY
		SELECT Depart As Value ,0 AS Type FROM ContactsCompany  WHERE RegUserNo=contacts_getuserdata.reguserno AND UserSeq=contacts_getuserdata.userseq AND IsDefault='1'

	ELSIF Key = 'position' THEN
		RETURN QUERY
		SELECT Position As Value ,0 AS Type FROM ContactsCompany  WHERE RegUserNo=contacts_getuserdata.reguserno AND UserSeq=contacts_getuserdata.userseq AND IsDefault='1'

	ELSIF Key = 'addr' THEN
		RETURN QUERY
		SELECT '(' || ZipCode1 || '-' || ZipCode2 || ')' || Address  As Value ,0 AS Type FROM ContactsAddress
        WHERE RegUserNo=contacts_getuserdata.reguserno AND UserSeq=contacts_getuserdata.userseq AND IsDefault='1'

	ELSIF Key = 'sns' THEN
		RETURN QUERY
		SELECT Value ,0 AS Type FROM ContactsSns  WHERE RegUserNo=contacts_getuserdata.reguserno AND UserSeq=contacts_getuserdata.userseq AND IsDefault='1'

	ELSIF Key = 'memo' THEN
		RETURN QUERY
		SELECT Memo  As Value ,0 AS Type FROM ContactsUser  WHERE RegUserNo=contacts_getuserdata.reguserno AND Seq=contacts_getuserdata.userseq

	ELSIF Key = 'firstname' THEN
		RETURN QUERY
		SELECT FirstName As Value ,0 AS Type FROM ContactsUser  WHERE RegUserNo=contacts_getuserdata.reguserno AND Seq=contacts_getuserdata.userseq

	ELSIF Key = 'lastname' THEN
		RETURN QUERY
		SELECT LastName As Value ,0 AS Type FROM ContactsUser  WHERE RegUserNo=contacts_getuserdata.reguserno AND Seq=contacts_getuserdata.userseq

	ELSIF Key = 'callname' THEN
		RETURN QUERY
		SELECT CallName As Value ,0 AS Type FROM ContactsUser  WHERE RegUserNo=contacts_getuserdata.reguserno AND Seq=contacts_getuserdata.userseq

	ELSIF Key = 'deldate' THEN
		RETURN QUERY
		SELECT DelDate As Value ,0 AS Type FROM ContactsUser  WHERE RegUserNo=contacts_getuserdata.reguserno AND Seq=contacts_getuserdata.userseq
	ELSIF Key = 'group' THEN
		RETURN QUERY
		SELECT G.GroupName As Value ,0 AS Type
		From ContactsGroupUser GU
		LEFT JOIN ContactsGroup G ON G.GroupNo = GU.GroupNo
		WHERE GU.RegUserNo = contacts_getuserdata.reguserno
		AND GU.UserSeq = contacts_getuserdata.userseq
		ORDER BY G.Sort;
	ELSE
		RETURN QUERY
		SELECT FirstName, LastName, CallName, Memo, Share FROM ContactsUser
		WHERE RegUserNo=contacts_getuserdata.reguserno and Seq=contacts_getuserdata.userseq;
		RETURN QUERY
		SELECT Type,TypeName,Value,IsDefault FROM ContactsNumber
		WHERE RegUserNo=contacts_getuserdata.reguserno AND UserSeq=contacts_getuserdata.userseq AND Value != '';
		RETURN QUERY
		SELECT Value,IsDefault FROM ContactsEmail
		WHERE RegUserNo=contacts_getuserdata.reguserno AND UserSeq=contacts_getuserdata.userseq;
		RETURN QUERY
		SELECT Type,TypeName,Value,IsDefault,SolarLunar FROM ContactsDays
		WHERE RegUserNo=contacts_getuserdata.reguserno AND UserSeq=contacts_getuserdata.userseq;
		RETURN QUERY
		SELECT Company,Depart,Position,IsDefault FROM ContactsCompany
		WHERE RegUserNo=contacts_getuserdata.reguserno AND UserSeq=contacts_getuserdata.userseq;
		RETURN QUERY
		SELECT Type,TypeName,ZipCode1,ZipCode2,Address,IsDefault FROM ContactsAddress
        WHERE RegUserNo=contacts_getuserdata.reguserno AND UserSeq=contacts_getuserdata.userseq;
        RETURN QUERY
        SELECT Value,IsDefault FROM ContactsSns
        WHERE RegUserNo=contacts_getuserdata.reguserno AND UserSeq=contacts_getuserdata.userseq;
        RETURN QUERY
        SELECT G.GroupNo,GroupName FROM ContactsGroup G
        INNER JOIN ContactsGroupUser GU  ON G.GroupNo=GU.GroupNo
        WHERE GU.RegUserNo=contacts_getuserdata.reguserno and UserSeq=contacts_getuserdata.userseq;
	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.