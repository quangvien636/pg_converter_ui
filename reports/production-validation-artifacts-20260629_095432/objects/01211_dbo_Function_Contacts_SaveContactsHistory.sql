-- ─── FUNCTION: contacts_savecontactshistory ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_savecontactshistory(integer, character varying);
CREATE OR REPLACE FUNCTION public.contacts_savecontactshistory(
    seq integer,
    status character varying DEFAULT 'DEL'
) RETURNS TABLE(
    historyno text,
    seq text,
    groupno text,
    userseq text,
    reguserno text,
    regdate text,
    col7 text
)
AS $function$
DECLARE
    historyno integer;
BEGIN


	-- 주소록 메인 ;
	INSERT INTO ContactsUserHistory
	(
		Seq, FirstName, LastName, RegUserNo, Memo,
		RegDate, Photo, ModDate, CheckDate, Share,
		UseYn, DelDate, Important, CallName, ViewCount,
		Status
	)
	RETURN QUERY
	SELECT 
		Seq, FirstName,LastName,RegUserNo, Memo,
		RegDate, Photo, NOW(), CheckDate, Share,
		UseYn, DelDate, Important, CallName, ViewCount,
		Status
	FROM ContactsUser 
	WHERE RegUserNo=UserNo AND Seq=contacts_savecontactshistory.seq
	
	SET HistoryNo = lastval();
	-- 전화번호 기록;
	INSERT INTO ContactsNumberHistory
	(
		HistoryNo, Seq, RegUserNo, UserSeq, Type,
		TypeName, Value, IsDefault, RegDate, ModDate
	)
	RETURN QUERY
	SELECT
		HistoryNo, Seq, RegUserNo, UserSeq, Type,
		TypeName, Value, IsDefault, RegDate, NOW()
	FROM ContactsNumber
	WHERE RegUserNo=UserNo AND UserSeq = contacts_savecontactshistory.seq
	-- 이메일 이력;
	INSERT INTO ContactsEmailHistory
	(
		HistoryNo, Seq, RegUserNo, UserSeq, Value,
		IsDefault, RegDate, ModDate
	)
	RETURN QUERY
	SELECT
		HistoryNo, Seq, RegUserNo, UserSeq, Value,
		IsDefault, RegDate, NOW()
	FROM ContactsEmail
	WHERE RegUserNo = UserNo AND UserSeq = contacts_savecontactshistory.seq
	-- 기념일 이력;
	INSERT INTO ContactsDaysHistory
	(
		HistoryNo, Seq, RegUserNo, UserSeq, Type, 
		TypeName, Value, IsDefault, SolarLunar, RegDate,
		ModDate
	)
	RETURN QUERY
	SELECT
		HistoryNo, Seq, RegUserNo, UserSeq, Type,
		TypeName, Value, IsDefault, SolarLunar, RegDate,
		NOW()
	FROM ContactsDays
	WHERE RegUserNo = UserNo AND UserSeq = contacts_savecontactshistory.seq
	-- 회사;
	INSERT INTO ContactsCompanyHistory
	(
		HistoryNo, Seq, RegUserNo, UserSeq, Company,
		Depart, Position, IsDefault, RegDate, ModDate	
	)
	RETURN QUERY
	SELECT
		HistoryNo, Seq, RegUserNo, UserSeq, Company,
		Depart, Position, IsDefault, RegDate, NOW()
	FROM ContactsCompany
	WHERE RegUserNo = UserNo AND UserSeq = contacts_savecontactshistory.seq
	-- 주소;
	INSERT INTO ContactsAddressHistory
	(
		HistoryNo, Seq, RegUserNo, UserSeq, Type,
		TypeName, ZipCode1, ZipCode2, Address, IsDefault,
		RegDate, ModDate
	)
	RETURN QUERY
	SELECT
		HistoryNo, Seq, RegUserNo, UserSeq, Type,
		TypeName, ZipCode1, ZipCode2, Address, IsDefault,
		RegDate, NOW()
	FROM ContactsAddress
	WHERE RegUserNo = UserNo ANd UserSeq = contacts_savecontactshistory.seq
	-- 홈페이지;
	INSERT INTO ContactsHomepageHistory
	(
		HistoryNo, Seq, RegUserNo, UserSeq, Type,
		TypeName, Value, IsDefault, RegDate, ModDate
	)
	RETURN QUERY
	SELECT
		HistoryNo, Seq, RegUserNo, UserSeq, Type,
		TypeName, Value, IsDefault, RegDate, ModDate
	FROM ContactsHomepage
	WHERE RegUserNo = UserNo AND UserSeq = contacts_savecontactshistory.seq
	-- SNS;
	INSERT INTO ContactsSnsHistory
	(
		HistoryNo, Seq, RegUserNo, UserSeq, Type,
		TypeName, Value, IsDefault, RegDate, ModDate
	)	
	RETURN QUERY
	SELECT	
		HistoryNo, Seq, RegUserNo, UserSeq, Type,
		TypeName, Value, IsDefault, RegDate, NOW()
	FROM ContactsSns
	WHERE RegUserNo = UserNo ANd UserSeq = contacts_savecontactshistory.seq
	
	-- 그룹	;
	INSERT INTO ContactsGroupUserHistory
	(
		HistoryNo, Seq, GroupNo, UserSeq, RegUserNo, RegDate, ModDate
	)
	RETURN QUERY
	SELECT
		HistoryNo, Seq, GroupNo, UserSeq, RegUserNo, RegDate, NOW()
	FROM ContactsGroupUser
	WHERE RegUserNo = UserNo ANd UserSeq = contacts_savecontactshistory.seq;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
