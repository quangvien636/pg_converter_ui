-- ─── FUNCTION: contacts_delcontactsuser ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_delcontactsuser(integer, integer);
CREATE OR REPLACE FUNCTION public.contacts_delcontactsuser(
    reguserno integer,
    userseq integer
) RETURNS void
AS $function$
BEGIN

	--DELETE FROM ContactsNumber WHERE RegUserNo=RegUserNo AND UserSeq=UserSeq
	--DELETE FROM ContactsEmail WHERE RegUserNo=RegUserNo AND UserSeq=UserSeq
	--DELETE FROM ContactsDays WHERE RegUserNo=RegUserNo AND UserSeq=UserSeq
	--DELETE FROM ContactsCompany WHERE RegUserNo=RegUserNo AND UserSeq=UserSeq
	--DELETE FROM ContactsAddress WHERE RegUserNo=RegUserNo AND UserSeq=UserSeq
	--DELETE FROM ContactsSns WHERE RegUserNo=RegUserNo AND UserSeq=UserSeq
	
	IF Mode = '0'
	BEGIN
		--DELETE FROM ContactsGroupUser WHERE RegUserNo=RegUserNo AND UserSeq=UserSeq
		--DELETE FROM ContactsUser WHERE RegUserNo=RegUserNo AND Seq=UserSeq;
		UPDATE ContactsUser SET UseYn='F' WHERE RegUserNo=contacts_delcontactsuser.reguserno AND Seq=contacts_delcontactsuser.userseq
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
