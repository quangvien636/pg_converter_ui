-- ─── FUNCTION: contacts_setcontactstrash ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_setcontactstrash(integer, integer);
CREATE OR REPLACE FUNCTION public.contacts_setcontactstrash(
    reguserno integer,
    seq integer
) RETURNS void
AS $function$
BEGIN

	UPDATE ContactsUser SET UseYn = '', DelDate = NOW() WHERE Seq= contacts_setcontactstrash.seq;
	--DELETE FROM ContactsGroupUser  WHERE UserSeq= Seq AND RegUserNo=RegUserNo
	--UPDATE Contact_PublicGroupUser SET IsDelete = TRUE, ModDate = NOW(),ModUserNo=RegUserNo WHERE UserSeq= Seq AND RegUserNo=RegUserNo
	--UPDATE Contact_ShareGroupUser SET IsDelete = TRUE, ModDate = NOW(),ModUserNo=RegUserNo WHERE UserSeq= Seq AND RegUserNo=RegUserNo
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
