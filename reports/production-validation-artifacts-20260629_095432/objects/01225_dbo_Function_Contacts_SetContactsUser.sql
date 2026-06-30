-- ─── FUNCTION: contacts_setcontactsuser ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_setcontactsuser(character varying, character varying, character varying, integer, character varying, character varying, character varying, character varying, integer);
CREATE OR REPLACE FUNCTION public.contacts_setcontactsuser(
    lastname character varying,
    firstname character varying,
    nicname character varying,
    reguserno integer,
    memo character varying,
    userpic character varying,
    groupno character varying,
    share character varying,
    seq integer
) RETURNS TABLE(
    groupno text,
    userseq text,
    reguserno text,
    col4 text,
    col5 text
)
-- TODO: LEN was not fully converted; use length()
AS $function$
DECLARE
    rtn integer;
    tab table(groupno int, userseq int,reguserno int);
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	IF Seq = 0
	BEGIN;
		INSERT INTO ContactsUser(LastName, FirstName, CallName, RegUserNo, Memo, Photo, RegDate, ModDate, CheckDate, Share, UseYn, Important)
		VALUES(LastName,FirstName,NicName,RegUserNo,Memo,UserPic, NOW(), NOW(), NOW(), Share, 'Y', 0)
		SET RTN = lastval()			
	END
	
	ELSE
	BEGIN;
		UPDATE ContactsUser SET FirstName=contacts_setcontactsuser.firstname, LastName=contacts_setcontactsuser.lastname,CallName=contacts_setcontactsuser.nicname,Memo=contacts_setcontactsuser.memo, RegDate = NOW(), Share=contacts_setcontactsuser.share WHERE Seq=contacts_setcontactsuser.seq;
		DELETE FROM ContactsGroupUser WHERE RegUserNo=contacts_setcontactsuser.reguserno AND UserSeq=contacts_setcontactsuser.seq		
		SET RTN = contacts_setcontactsuser.seq
	END
	

	WHILE STRPOS(',GroupNo, ') > 0
	BEGIN;
		INSERT INTO tab(GroupNo,UserSeq,RegUserNo)
		VALUES (SUBSTRING(GroupNo,0,STRPOS(',GroupNo, ')),RTN,RegUserNo)
		SET GroupNo = SUBSTRING(GroupNo,STRPOS(',GroupNo, ')+1,LEN(GroupNo))
	END
			
	INSERT INTO tab VALUES (GroupNo,RTN,RegUserNo)	;
	INSERT INTO ContactsGroupUser
	(GroupNo,UserSeq,RegUserNo,RegDate,ModDate)
	RETURN QUERY
	SELECT GroupNo, UserSeq, RegUserNo, NOW(), NOW() FROM tab
	
	RETURN QUERY
	SELECT RTN;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
