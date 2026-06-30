-- ─── FUNCTION: contacts_getuserdata ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_getuserdata(integer, integer);
CREATE OR REPLACE FUNCTION public.contacts_getuserdata(
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
		SELECT Value, Type FROM ContactsNumber  WHERE RegUserNo=contacts_getuserdata.reguserno AND UserSeq=contacts_getuserdata.userseq AND IsDefault='1'
	END
	
	ELSE IF Key = 'email'
	BEGIN
		RETURN QUERY
		SELECT Value,0 AS Type FROM ContactsEmail  WHERE RegUserNo=contacts_getuserdata.reguserno AND UserSeq=contacts_getuserdata.userseq AND IsDefault='1'
	END
	
	ELSE IF Key = 'days'
	BEGIN
		RETURN QUERY
		SELECT Value,0 AS Type FROM ContactsDays  WHERE RegUserNo=contacts_getuserdata.reguserno AND UserSeq=contacts_getuserdata.userseq AND IsDefault='1'
	END
	
	ELSE IF Key = 'comp'
	BEGIN
		RETURN QUERY
		SELECT Company As Value ,0 AS Type FROM ContactsCompany  WHERE RegUserNo=contacts_getuserdata.reguserno AND UserSeq=contacts_getuserdata.userseq AND IsDefault='1'
	END
	
	ELSE IF Key = 'dept'
	BEGIN
		RETURN QUERY
		SELECT Depart As Value ,0 AS Type FROM ContactsCompany  WHERE RegUserNo=contacts_getuserdata.reguserno AND UserSeq=contacts_getuserdata.userseq AND IsDefault='1'
	END
	
	ELSE IF Key = 'position'
	BEGIN
		RETURN QUERY
		SELECT Position As Value ,0 AS Type FROM ContactsCompany  WHERE RegUserNo=contacts_getuserdata.reguserno AND UserSeq=contacts_getuserdata.userseq AND IsDefault='1'
	END
	
	ELSE IF Key = 'addr'
	BEGIN
		RETURN QUERY
		SELECT '(' || ZipCode1 || '-' || ZipCode2 || ')' || Address  As Value ,0 AS Type FROM ContactsAddress 
        WHERE RegUserNo=contacts_getuserdata.reguserno AND UserSeq=contacts_getuserdata.userseq AND IsDefault='1'
	END
	
	ELSE IF Key = 'sns'
	BEGIN
		RETURN QUERY
		SELECT Value ,0 AS Type FROM ContactsSns  WHERE RegUserNo=contacts_getuserdata.reguserno AND UserSeq=contacts_getuserdata.userseq AND IsDefault='1'
	END
	
	ELSE IF Key = 'memo'
	BEGIN
		RETURN QUERY
		SELECT Memo  As Value ,0 AS Type FROM ContactsUser  WHERE RegUserNo=contacts_getuserdata.reguserno AND Seq=contacts_getuserdata.userseq
	END
	
	ELSE IF Key = 'firstname'
	BEGIN
		RETURN QUERY
		SELECT FirstName As Value ,0 AS Type FROM ContactsUser  WHERE RegUserNo=contacts_getuserdata.reguserno AND Seq=contacts_getuserdata.userseq
	END
	
	ELSE IF Key = 'lastname'
	BEGIN
		RETURN QUERY
		SELECT LastName As Value ,0 AS Type FROM ContactsUser  WHERE RegUserNo=contacts_getuserdata.reguserno AND Seq=contacts_getuserdata.userseq
	END
	
	ELSE IF Key = 'callname'
	BEGIN
		RETURN QUERY
		SELECT CallName As Value ,0 AS Type FROM ContactsUser  WHERE RegUserNo=contacts_getuserdata.reguserno AND Seq=contacts_getuserdata.userseq
	END
	
	ELSE IF Key = 'deldate'
	BEGIN
		RETURN QUERY
		SELECT DelDate As Value ,0 AS Type FROM ContactsUser  WHERE RegUserNo=contacts_getuserdata.reguserno AND Seq=contacts_getuserdata.userseq
	END
	ElSE IF Key = 'group'
	BEGIN
		RETURN QUERY
		SELECT G.GroupName As Value ,0 AS Type
		From ContactsGroupUser GU 
		LEFT JOIN ContactsGroup G ON G.GroupNo = GU.GroupNo
		WHERE GU.RegUserNo = contacts_getuserdata.reguserno
		AND GU.UserSeq = contacts_getuserdata.userseq
		ORDER BY G.Sort
	END
	ELSE
	BEGIN
		RETURN QUERY
		SELECT FirstName, LastName, CallName, Memo, Share FROM ContactsUser 
		WHERE RegUserNo=contacts_getuserdata.reguserno and Seq=contacts_getuserdata.userseq
		RETURN QUERY
		SELECT Type,TypeName,Value,IsDefault FROM ContactsNumber 
		WHERE RegUserNo=contacts_getuserdata.reguserno AND UserSeq=contacts_getuserdata.userseq AND Value != ''
		RETURN QUERY
		SELECT Value,IsDefault FROM ContactsEmail 
		WHERE RegUserNo=contacts_getuserdata.reguserno AND UserSeq=contacts_getuserdata.userseq
		RETURN QUERY
		SELECT Type,TypeName,Value,IsDefault,SolarLunar FROM ContactsDays 
		WHERE RegUserNo=contacts_getuserdata.reguserno AND UserSeq=contacts_getuserdata.userseq
		RETURN QUERY
		SELECT Company,Depart,Position,IsDefault FROM ContactsCompany 
		WHERE RegUserNo=contacts_getuserdata.reguserno AND UserSeq=contacts_getuserdata.userseq
		RETURN QUERY
		SELECT Type,TypeName,ZipCode1,ZipCode2,Address,IsDefault FROM ContactsAddress 
        WHERE RegUserNo=contacts_getuserdata.reguserno AND UserSeq=contacts_getuserdata.userseq
        RETURN QUERY
        SELECT Value,IsDefault FROM ContactsSns 
        WHERE RegUserNo=contacts_getuserdata.reguserno AND UserSeq=contacts_getuserdata.userseq
        RETURN QUERY
        SELECT G.GroupNo,GroupName FROM ContactsGroup G 
        INNER JOIN ContactsGroupUser GU  ON G.GroupNo=GU.GroupNo
        WHERE GU.RegUserNo=contacts_getuserdata.reguserno and UserSeq=contacts_getuserdata.userseq
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
