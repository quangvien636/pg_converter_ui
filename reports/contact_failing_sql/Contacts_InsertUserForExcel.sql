-- ─── PROCEDURE→FUNCTION: contacts_insertuserforexcel ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.contacts_insertuserforexcel(integer, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, "position" character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, timestamp without time zone, timestamp without time zone, character varying);
CREATE OR REPLACE FUNCTION public.contacts_insertuserforexcel(
    IN reguserno integer,
    IN lastname character varying,
    IN firstname character varying,
    IN callname character varying,
    IN phonenum character varying,
    IN companynum character varying,
    IN homenum character varying,
    IN faxnum character varying,
    IN company character varying,
    IN "position" character varying,
    IN depart character varying,
    IN email character varying,
    IN companyzip1 character varying,
    IN companyzip2 character varying,
    IN companyaddr character varying,
    IN homezip1 character varying,
    IN homezip2 character varying,
    IN homeaddr character varying,
    IN homepage character varying,
    IN memo character varying,
    IN grouplist character varying,
    IN regday timestamp without time zone,
    IN modday timestamp without time zone,
    IN share character varying DEFAULT '100'
) RETURNS SETOF record
AS $function$
DECLARE
    userno integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

IsPhoneDef CHAR(1)='0',
IsAddrDef CHAR(1)='0',
DefValue CHAR(1)='0'


-- ??? ????.;
INSERT INTO ContactsUser (FirstName, LastName, CallName,Memo, RegUserNo, RegDate,ModDate, UseYn,Share)
VALUES (FirstName, LastName, CallName,Memo, RegUserNo, RegDay,ModDay, 'Y',Share);
UserNo := lastval();
PERFORM contacts_insertlistgroupcontact(UserNo,Grouplist);
-- ?? ??.
--INSERT INTO ContactsGroupUser (GroupNo, UserSeq, RegUserNo, RegDate)
--VALUES (GroupNo, UserNo, RegUserNo ,NOW())

-- ???? ??(0:???1:?2:??3:FAX)
-- ?? ???? ??.
IF PhoneNum != '' THEN
	IF IsPhoneDef = '0' THEN
		IsPhoneDef := '1';
		DefValue := '1';
	END IF;

	INSERT INTO ContactsNumber (RegUserNo, UserSeq, Type, TypeName, Value, IsDefault, RegDate)
	VALUES (RegUserNo, UserNo, 0, '???', PhoneNum, DefValue ,NOW());
END IF;

-- ? ???? ??.
IF HomeNum != '' THEN
	DefValue := '0';
	IF IsPhoneDef = '0' THEN
		IsPhoneDef := '1';
		DefValue := '1';
	END IF;

	INSERT INTO ContactsNumber (RegUserNo, UserSeq, Type, TypeName, Value, IsDefault, RegDate)
	VALUES (RegUserNo, UserNo, 1, '?', HomeNum, DefValue ,NOW());
END IF;

-- ?? ???? ??.
IF CompanyNum != '' THEN
	DefValue := '0';
	IF IsPhoneDef = '0' THEN
		IsPhoneDef := '1';
		DefValue := '1';
	END IF;
	INSERT INTO ContactsNumber (RegUserNo, UserSeq, Type, TypeName, Value, IsDefault, RegDate)
	VALUES (RegUserNo, UserNo, 2, '??', CompanyNum, DefValue ,NOW());
END IF;

-- ???? ??.
IF FaxNum != '' THEN
	DefValue := '0';
	IF IsPhoneDef = '0' THEN
		IsPhoneDef := '1';
		DefValue := '1';
	END IF;
	INSERT INTO ContactsNumber (RegUserNo, UserSeq, Type, TypeName, Value, IsDefault, RegDate)
	VALUES (RegUserNo, UserNo, 3, 'FAX', FaxNum, DefValue ,NOW());
END IF;

-- ??/??/?? ??.
IF Company != '' OR Depart != '' OR Position != '' THEN
	INSERT INTO ContactsCompany (RegUserNo, UserSeq, Company, Depart, Position, IsDefault, RegDate)
	VALUES (RegUserNo, UserNo, Company, Depart, Position, '1' ,NOW());
END IF;

-- ?? ??.
IF Email != '' THEN
	INSERT INTO ContactsEmail (RegUserNo, UserSeq, Value, IsDefault, RegDate)
	VALUES (RegUserNo, UserNo, Email, '1' ,NOW());
END IF;
-- ????(0:??1:?)
-- ????
IF CompanyZip1 != '' OR CompanyZip2 != '' OR CompanyAddr != '' THEN
	DefValue := '0';
	IF IsAddrDef = '0' THEN
		IsAddrDef := '1';
		DefValue := '1';
	END IF;
	INSERT INTO ContactsAddress
	(RegUserNo, UserSeq, Type, TypeName, ZipCode1, ZipCode2, Address, IsDefault, RegDate)
	VALUES
	(RegUserNo, UserNo, 0, '??', CompanyZip1, CompanyZip2, CompanyAddr, DefValue ,NOW());
END IF;

-- ???
IF HomeZip1 != '' OR HomeZip2 != '' OR HomeAddr != '' THEN
	DefValue := '0';
	IF IsAddrDef = '0' THEN
		IsAddrDef := '1';
		DefValue := '1';
	END IF;
	INSERT INTO ContactsAddress
	(RegUserNo, UserSeq, Type, TypeName, ZipCode1, ZipCode2, Address, IsDefault, RegDate)
	VALUES
	(RegUserNo, UserNo, 1, '?', HomeZip1, HomeZip2, HomeAddr, DefValue ,NOW());
END IF;

-- ???? ??(0:????1:???2:??)
IF HomePage != '' THEN
	DefValue := '0';
	IF IsAddrDef = '0' THEN
		IsAddrDef := '1';
		DefValue := '1';
	END IF;
	INSERT INTO ContactsHomepage
	(RegUserNo, UserSeq, Type, TypeName, Value, IsDefault, RegDate)
	VALUES
	(RegUserNo, UserNo, 0, '????', HomePage, DefValue ,NOW());
END IF;

RETURN QUERY
SELECT UserNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.