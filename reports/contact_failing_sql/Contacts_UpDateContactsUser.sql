-- ─── PROCEDURE→FUNCTION: contacts_updatecontactsuser ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: LEN was not fully converted; use length()
DROP FUNCTION IF EXISTS public.contacts_updatecontactsuser(integer, integer, character varying, character varying, character varying, character varying, character varying, character varying);
CREATE OR REPLACE FUNCTION public.contacts_updatecontactsuser(
    IN reguserno integer,
    IN userseq integer,
    IN memo character varying,
    IN share character varying,
    IN groupno character varying,
    IN company character varying,
    IN zipcode1 character varying,
    IN zipcode2 character varying
) RETURNS void
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	DELETE FROM ContactsGroupUser WHERE UserSeq = contacts_updatecontactsuser.userseq;

	UPDATE ContactsUser SET Memo = contacts_updatecontactsuser.memo, RegDate = NOW(), Share = contacts_updatecontactsuser.share
		WHERE RegUserNo = contacts_updatecontactsuser.reguserno AND Seq = contacts_updatecontactsuser.userseq

	CREATE TEMP TABLE tab (GroupNo integer,ContactsUser integer,RegUserNo integer) ON COMMIT DROP;
	WHILE STRPOS(',GroupNo, ') > 0 LOOP
		INSERT INTO tab(GroupNo,ContactsUser,RegUserNo)
		VALUES (SUBSTRING(GroupNo,0,STRPOS(',GroupNo, ')),UserSeq,RegUserNo);
		GroupNo := SUBSTRING(GroupNo,STRPOS(',GroupNo, ')+1,LEN(GroupNo));
	END LOOP

	INSERT INTO tab VALUES (GroupNo,UserSeq,RegUserNo);
	INSERT INTO ContactsGroupUser (GroupNo, UserSeq, RegUserNo, RegDate) SELECT *,NOW() FROM tab;

	UPDATE ContactsCompany SET Company = contacts_updatecontactsuser.company WHERE RegUserNo = contacts_updatecontactsuser.reguserno AND UserSeq = contacts_updatecontactsuser.userseq;

	UPDATE ContactsAddress SET ZipCode1 = contacts_updatecontactsuser.zipcode1, ZipCode2 = contacts_updatecontactsuser.zipcode2, Address = Address WHERE RegUserNo = contacts_updatecontactsuser.reguserno AND UserSeq = contacts_updatecontactsuser.userseq;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.