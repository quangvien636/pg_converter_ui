-- ─── FUNCTION: contacts_insertuserforexcel ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_insertuserforexcel(integer, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, timestamp without time zone, timestamp without time zone, character varying);
CREATE OR REPLACE FUNCTION public.contacts_insertuserforexcel(
    reguserno integer,
    lastname character varying,
    firstname character varying,
    callname character varying,
    phonenum character varying,
    companynum character varying,
    homenum character varying,
    faxnum character varying,
    company character varying,
    position character varying,
    depart character varying,
    email character varying,
    companyzip1 character varying,
    companyzip2 character varying,
    companyaddr character varying,
    homezip1 character varying,
    homezip2 character varying,
    homeaddr character varying,
    homepage character varying,
    memo character varying,
    grouplist character varying,
    regday timestamp without time zone,
    modday timestamp without time zone,
    share character varying DEFAULT '100'
) RETURNS TABLE(
    userno text
)
AS $function$
BEGIN

IsPhoneDef CHAR(1)='0', 
IsAddrDef CHAR(1)='0', 
DefValue CHAR(1)='0'


-- ??? ????.;
INSERT INTO ContactsUser (FirstName, LastName, CallName,Memo, RegUserNo, RegDate,ModDate, UseYn,Share)
VALUES (FirstName, LastName, CallName,Memo, RegUserNo, RegDay,ModDay, 'Y',Share)
SET UserNo = lastval()

EXEC Contacts_InsertListGroupContact UserNo,Grouplist
-- ?? ??.
--INSERT INTO ContactsGroupUser (GroupNo, UserSeq, RegUserNo, RegDate)
--VALUES (GroupNo, UserNo, RegUserNo ,NOW())

-- ???? ??(0:???1:?2:??3:FAX)
-- ?? ???? ??.
IF PhoneNum != ''
BEGIN
	IF IsPhoneDef = '0'
	BEGIN
		SET IsPhoneDef = '1'
		SET DefValue = '1'
	END
	
	INSERT INTO ContactsNumber (RegUserNo, UserSeq, Type, TypeName, Value, IsDefault, RegDate)
	VALUES (RegUserNo, UserNo, 0, '???', PhoneNum, DefValue ,NOW())
END

-- ? ???? ??.
IF HomeNum != ''
BEGIN
	SET DefValue = '0'
	IF IsPhoneDef = '0'
	BEGIN
		SET IsPhoneDef = '1'
		SET DefValue = '1'
	END
	
	INSERT INTO ContactsNumber (RegUserNo, UserSeq, Type, TypeName, Value, IsDefault, RegDate)
	VALUES (RegUserNo, UserNo, 1, '?', HomeNum, DefValue ,NOW())
END

-- ?? ???? ??.
IF CompanyNum != ''
BEGIN
	SET DefValue = '0'
	IF IsPhoneDef = '0'
	BEGIN
		SET IsPhoneDef = '1'
		SET DefValue = '1'
	END;
	INSERT INTO ContactsNumber (RegUserNo, UserSeq, Type, TypeName, Value, IsDefault, RegDate)
	VALUES (RegUserNo, UserNo, 2, '??', CompanyNum, DefValue ,NOW())
END

-- ???? ??.
IF FaxNum != ''
BEGIN
	SET DefValue = '0'
	IF IsPhoneDef = '0'
	BEGIN
		SET IsPhoneDef = '1'
		SET DefValue = '1'
	END;
	INSERT INTO ContactsNumber (RegUserNo, UserSeq, Type, TypeName, Value, IsDefault, RegDate)
	VALUES (RegUserNo, UserNo, 3, 'FAX', FaxNum, DefValue ,NOW())
END

-- ??/??/?? ??.
IF Company != '' OR Depart != '' OR Position != ''
BEGIN;
	INSERT INTO ContactsCompany (RegUserNo, UserSeq, Company, Depart, Position, IsDefault, RegDate)
	VALUES (RegUserNo, UserNo, Company, Depart, Position, '1' ,NOW())
END

-- ?? ??.
IF Email != ''
BEGIN;
	INSERT INTO ContactsEmail (RegUserNo, UserSeq, Value, IsDefault, RegDate)
	VALUES (RegUserNo, UserNo, Email, '1' ,NOW())
END
-- ????(0:??1:?)
-- ????
IF CompanyZip1 != '' OR CompanyZip2 != '' OR CompanyAddr != ''
BEGIN
	SET DefValue = '0'
	IF IsAddrDef = '0'
	BEGIN
		SET IsAddrDef = '1'
		SET DefValue = '1'
	END;
	INSERT INTO ContactsAddress 
	(RegUserNo, UserSeq, Type, TypeName, ZipCode1, ZipCode2, Address, IsDefault, RegDate)
	VALUES 
	(RegUserNo, UserNo, 0, '??', CompanyZip1, CompanyZip2, CompanyAddr, DefValue ,NOW())
END

-- ???
IF HomeZip1 != '' OR HomeZip2 != '' OR HomeAddr != ''
BEGIN
	SET DefValue = '0'
	IF IsAddrDef = '0'
	BEGIN
		SET IsAddrDef = '1'
		SET DefValue = '1'
	END;
	INSERT INTO ContactsAddress 
	(RegUserNo, UserSeq, Type, TypeName, ZipCode1, ZipCode2, Address, IsDefault, RegDate)
	VALUES 
	(RegUserNo, UserNo, 1, '?', HomeZip1, HomeZip2, HomeAddr, DefValue ,NOW())
END

-- ???? ??(0:????1:???2:??)
IF HomePage != ''
BEGIN
	SET DefValue = '0'
	IF IsAddrDef = '0'
	BEGIN
		SET IsAddrDef = '1'
		SET DefValue = '1'
	END;
	INSERT INTO ContactsHomepage
	(RegUserNo, UserSeq, Type, TypeName, Value, IsDefault, RegDate)
	VALUES 
	(RegUserNo, UserNo, 0, '????', HomePage, DefValue ,NOW())
END

RETURN QUERY
SELECT UserNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
