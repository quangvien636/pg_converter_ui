-- ─── FUNCTION: contacts_deleteallgroupbyuserseq ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_deleteallgroupbyuserseq(integer, integer);
CREATE OR REPLACE FUNCTION public.contacts_deleteallgroupbyuserseq(
    userseq integer,
    userno integer
) RETURNS TABLE(
    userseq text
)
AS $function$
BEGIN

	UPDATE  Contact_PublicGroupUser SET IsDelete = TRUE,  ModUserNo=contacts_deleteallgroupbyuserseq.userno,ModDate=NOW()
	WHERE UserSeq=contacts_deleteallgroupbyuserseq.userseq;
	UPDATE  Contact_ShareGroupUser SET IsDelete = TRUE,  ModUserNo=contacts_deleteallgroupbyuserseq.userno,ModDate=NOW()
	WHERE UserSeq=contacts_deleteallgroupbyuserseq.userseq;
	Delete FROM  ContactsGroupUser WHERE UserSeq=contacts_deleteallgroupbyuserseq.userseq
	RETURN QUERY
	SELECT UserSeq;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
