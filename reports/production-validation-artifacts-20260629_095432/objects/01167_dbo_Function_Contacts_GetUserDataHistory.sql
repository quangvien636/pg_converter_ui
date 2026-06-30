-- ─── FUNCTION: contacts_getuserdatahistory ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_getuserdatahistory(integer, integer, integer);
CREATE OR REPLACE FUNCTION public.contacts_getuserdatahistory(
    historyno integer,
    reguserno integer,
    userseq integer
) RETURNS TABLE(
    groupno text,
    groupname text
)
AS $function$
BEGIN


	IF Key = 'number'
	BEGIN
		RETURN QUERY
		SELECT Value, Type FROM ContactsNumberHistory WHERE HistoryNo=contacts_getuserdatahistory.historyno AND RegUserNo=contacts_getuserdatahistory.reguserno AND UserSeq=contacts_getuserdatahistory.userseq ORDER BY IsDefault DESC, Seq DESC
	END
	
	ELSE IF Key = 'email'
	BEGIN
		RETURN QUERY
		SELECT Value FROM ContactsEmailHistory WHERE HistoryNo=contacts_getuserdatahistory.historyno AND RegUserNo=contacts_getuserdatahistory.reguserno AND UserSeq=contacts_getuserdatahistory.userseq ORDER BY IsDefault DESC, Seq DESC
	END
	
	ELSE IF Key = 'days'
	BEGIN
		RETURN QUERY
		SELECT Value FROM ContactsDaysHistory WHERE HistoryNo=contacts_getuserdatahistory.historyno AND RegUserNo=contacts_getuserdatahistory.reguserno AND UserSeq=contacts_getuserdatahistory.userseq ORDER BY IsDefault DESC, Seq DESC
	END
	
	ELSE IF Key = 'comp'
	BEGIN
		RETURN QUERY
		SELECT Company FROM ContactsCompanyHistory WHERE HistoryNo=contacts_getuserdatahistory.historyno AND RegUserNo=contacts_getuserdatahistory.reguserno AND UserSeq=contacts_getuserdatahistory.userseq ORDER BY IsDefault DESC, Seq DESC
	END
	
	ELSE IF Key = 'dept'
	BEGIN
		RETURN QUERY
		SELECT Depart FROM ContactsCompanyHistory WHERE HistoryNo=contacts_getuserdatahistory.historyno AND RegUserNo=contacts_getuserdatahistory.reguserno AND UserSeq=contacts_getuserdatahistory.userseq ORDER BY IsDefault DESC, Seq DESC
	END
	
	ELSE IF Key = 'position'
	BEGIN
		RETURN QUERY
		SELECT Position FROM ContactsCompanyHistory WHERE HistoryNo=contacts_getuserdatahistory.historyno AND RegUserNo=contacts_getuserdatahistory.reguserno AND UserSeq=contacts_getuserdatahistory.userseq ORDER BY IsDefault DESC, Seq DESC
	END
	
	ELSE IF Key = 'addr'
	BEGIN
		RETURN QUERY
		SELECT '(' || ZipCode1 || '-' || ZipCode2 || ')' || Address Address FROM ContactsAddressHistory
        WHERE HistoryNo=contacts_getuserdatahistory.historyno AND RegUserNo=contacts_getuserdatahistory.reguserno AND UserSeq=contacts_getuserdatahistory.userseq AND IsDefault='1'
	END
	
	ELSE IF Key = 'sns'
	BEGIN
		RETURN QUERY
		SELECT Value FROM ContactsSnsHistory WHERE HistoryNo=contacts_getuserdatahistory.historyno AND RegUserNo=contacts_getuserdatahistory.reguserno AND UserSeq=contacts_getuserdatahistory.userseq ORDER BY IsDefault DESC, Seq DESC
	END
	
	ELSE IF Key = 'memo'
	BEGIN
		RETURN QUERY
		SELECT Memo FROM ContactsUserHistory WHERE HistoryNo=contacts_getuserdatahistory.historyno AND RegUserNo=contacts_getuserdatahistory.reguserno AND Seq=contacts_getuserdatahistory.userseq
	END
	
	ELSE IF Key = 'firstname'
	BEGIN
		RETURN QUERY
		SELECT FirstName FROM ContactsUserHistory WHERE HistoryNo=contacts_getuserdatahistory.historyno AND RegUserNo=contacts_getuserdatahistory.reguserno AND Seq=contacts_getuserdatahistory.userseq
	END
	
	ELSE IF Key = 'lastname'
	BEGIN
		RETURN QUERY
		SELECT LastName FROM ContactsUserHistory WHERE HistoryNo=contacts_getuserdatahistory.historyno AND RegUserNo=contacts_getuserdatahistory.reguserno AND Seq=contacts_getuserdatahistory.userseq
	END
	
	ELSE IF Key = 'callname'
	BEGIN
		RETURN QUERY
		SELECT CallName FROM ContactsUserHistory WHERE HistoryNo=contacts_getuserdatahistory.historyno AND RegUserNo=contacts_getuserdatahistory.reguserno AND Seq=contacts_getuserdatahistory.userseq
	END
	
	ELSE IF Key = 'deldate'
	BEGIN
		RETURN QUERY
		SELECT DelDate FROM ContactsUserHistory WHERE HistoryNo=contacts_getuserdatahistory.historyno AND RegUserNo=contacts_getuserdatahistory.reguserno AND Seq=contacts_getuserdatahistory.userseq
	END
	ElSE IF Key = 'group'
	BEGIN
		RETURN QUERY
		SELECT G.GroupName
		From ContactsGroupUserHistory GU
		LEFT JOIN ContactsGroup G ON G.GroupNo = GU.GroupNo
		WHERE HistoryNo=contacts_getuserdatahistory.historyno 
		AND GU.RegUserNo = contacts_getuserdatahistory.reguserno
		AND GU.UserSeq = contacts_getuserdatahistory.userseq
		ORDER BY G.Sort
	END
	ELSE
	BEGIN
		RETURN QUERY
		SELECT FirstName, LastName, CallName, Memo, Share FROM ContactsUserHistory
		WHERE HistoryNo=contacts_getuserdatahistory.historyno AND RegUserNo=contacts_getuserdatahistory.reguserno and Seq=contacts_getuserdatahistory.userseq
		
		RETURN QUERY
		SELECT Type,TypeName,Value,IsDefault FROM ContactsNumberHistory
		WHERE HistoryNo=contacts_getuserdatahistory.historyno AND RegUserNo=contacts_getuserdatahistory.reguserno AND UserSeq=contacts_getuserdatahistory.userseq AND Value != ''
		
		RETURN QUERY
		SELECT Value,IsDefault FROM ContactsEmailHistory
		WHERE HistoryNo=contacts_getuserdatahistory.historyno AND RegUserNo=contacts_getuserdatahistory.reguserno AND UserSeq=contacts_getuserdatahistory.userseq
		
		RETURN QUERY
		SELECT Type,TypeName,Value,IsDefault,SolarLunar FROM ContactsDaysHistory
		WHERE HistoryNo=contacts_getuserdatahistory.historyno AND RegUserNo=contacts_getuserdatahistory.reguserno AND UserSeq=contacts_getuserdatahistory.userseq
		
		RETURN QUERY
		SELECT Company,Depart,Position,IsDefault FROM ContactsCompanyHistory
		WHERE HistoryNo=contacts_getuserdatahistory.historyno AND RegUserNo=contacts_getuserdatahistory.reguserno AND UserSeq=contacts_getuserdatahistory.userseq
		
		RETURN QUERY
		SELECT Type,TypeName,ZipCode1,ZipCode2,Address,IsDefault FROM ContactsAddressHistory
        WHERE HistoryNo=contacts_getuserdatahistory.historyno AND RegUserNo=contacts_getuserdatahistory.reguserno AND UserSeq=contacts_getuserdatahistory.userseq
        
        RETURN QUERY
        SELECT Value,IsDefault FROM ContactsSnsHistory
        WHERE HistoryNo=contacts_getuserdatahistory.historyno AND RegUserNo=contacts_getuserdatahistory.reguserno AND UserSeq=contacts_getuserdatahistory.userseq
        
        RETURN QUERY
        SELECT G.GroupNo,GroupName FROM ContactsGroup G
        INNER JOIN ContactsGroupUserHistory GU ON G.GroupNo=GU.GroupNo
        WHERE HistoryNo=contacts_getuserdatahistory.historyno AND GU.RegUserNo=contacts_getuserdatahistory.reguserno and UserSeq=contacts_getuserdatahistory.userseq
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
