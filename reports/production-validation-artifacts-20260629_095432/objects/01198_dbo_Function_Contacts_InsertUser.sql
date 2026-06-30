-- ─── FUNCTION: contacts_insertuser ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_insertuser(integer, integer, character varying, character varying, character varying, character varying, character varying, character varying);
CREATE OR REPLACE FUNCTION public.contacts_insertuser(
    reguserno integer,
    groupno integer,
    firstname character varying,
    lastname character varying,
    email character varying,
    phonenum character varying,
    company character varying,
    depart character varying
) RETURNS void
AS $function$
DECLARE
    userno integer;
BEGIN

-- 새로운 유저등록.;
INSERT INTO ContactsUser (FirstName, LastName, RegUserNo, RegDate, UseYn)
VALUES (FirstName, LastName, RegUserNo, NOW(), 'Y')

SET UserNo = lastval()

-- 그룹 지정.;
INSERT INTO ContactsGroupUser (GroupNo, UserSeq, RegUserNo, RegDate)
VALUES (GroupNo, UserNo, RegUserNo ,NOW())

-- 회사 정보.;
INSERT INTO ContactsCompany (RegUserNo, UserSeq, Company, Depart, Position, IsDefault, RegDate)
VALUES (RegUserNo, UserNo, Company, Depart, Position, '1' ,NOW())

-- 전화번호 정보.;
INSERT INTO ContactsNumber (RegUserNo, UserSeq, Type, TypeName, Value, IsDefault, RegDate)
VALUES (RegUserNo, UserNo, 0, '휴대폰', PhoneNum, '1' ,NOW())

-- 메일 정보.;
INSERT INTO ContactsEmail (RegUserNo, UserSeq, Value, IsDefault, RegDate)
VALUES (RegUserNo, UserNo, Email, '1' ,NOW());
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
