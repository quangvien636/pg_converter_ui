-- ─── FUNCTION: contacts_updatecontactsuser ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_updatecontactsuser(integer, integer, character varying, character varying, character varying, character varying, character varying, character varying);
CREATE OR REPLACE FUNCTION public.contacts_updatecontactsuser(
    reguserno integer,
    userseq integer,
    memo character varying,
    share character varying,
    groupno character varying,
    company character varying,
    zipcode1 character varying,
    zipcode2 character varying
) RETURNS void
-- TODO: LEN was not fully converted; use length()
AS $function$
DECLARE
    tab table(groupno int,contactsuser int,reguserno int);
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	DELETE FROM ContactsGroupUser WHERE UserSeq = contacts_updatecontactsuser.userseq 

	UPDATE ContactsUser SET Memo = contacts_updatecontactsuser.memo, RegDate = NOW(), Share = contacts_updatecontactsuser.share
		WHERE RegUserNo = contacts_updatecontactsuser.reguserno AND Seq = contacts_updatecontactsuser.userseq
	

	WHILE STRPOS(',GroupNo, ') > 0
	BEGIN;
		INSERT INTO tab(GroupNo,ContactsUser,RegUserNo)
		VALUES (SUBSTRING(GroupNo,0,STRPOS(',GroupNo, ')),UserSeq,RegUserNo)
		SET GroupNo = SUBSTRING(GroupNo,STRPOS(',GroupNo, ')+1,LEN(GroupNo))
	END
			
	INSERT INTO tab VALUES (GroupNo,UserSeq,RegUserNo)	;
	INSERT INTO ContactsGroupUser (GroupNo, UserSeq, RegUserNo, RegDate) SELECT *,NOW() FROM tab
	
	UPDATE ContactsCompany SET Company = contacts_updatecontactsuser.company WHERE RegUserNo = contacts_updatecontactsuser.reguserno AND UserSeq = contacts_updatecontactsuser.userseq
	
	UPDATE ContactsAddress SET ZipCode1 = contacts_updatecontactsuser.zipcode1, ZipCode2 = contacts_updatecontactsuser.zipcode2, Address = Address WHERE RegUserNo = contacts_updatecontactsuser.reguserno AND UserSeq = contacts_updatecontactsuser.userseq;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
