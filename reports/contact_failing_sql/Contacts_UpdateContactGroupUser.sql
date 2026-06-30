-- ─── PROCEDURE→FUNCTION: contacts_updatecontactgroupuser ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.contacts_updatecontactgroupuser(integer, integer, integer);
CREATE OR REPLACE FUNCTION public.contacts_updatecontactgroupuser(
    IN userno integer DEFAULT 70,
    IN groupno integer DEFAULT 8,
    IN userseq integer DEFAULT 7999
) RETURNS void
AS $function$
BEGIN

	UPDATE Contact_PublicGroupUser SET IsDelete= TRUE ,ModUserNo=contacts_updatecontactgroupuser.userno,ModDate=NOW() WHERE UserSeq=contacts_updatecontactgroupuser.userseq;
	UPDATE Contact_ShareGroupUser SET IsDelete= TRUE ,ModUserNo=contacts_updatecontactgroupuser.userno,ModDate=NOW() WHERE UserSeq=contacts_updatecontactgroupuser.userseq
		IF EXISTS(SELECT Seq FROM ContactsGroupUser GU WHERE GU.GroupNo=contacts_updatecontactgroupuser.groupno AND  GU.UserSeq=contacts_updatecontactgroupuser.userseq  ) THEN
		UPDATE ContactsGroupUser SET GroupNo=contacts_updatecontactgroupuser.groupno,UserSeq=contacts_updatecontactgroupuser.userseq,ModDate=NOW()  WHERE GroupNo=contacts_updatecontactgroupuser.groupno AND  UserSeq=contacts_updatecontactgroupuser.userseq;
	ELSE
		INSERT INTO ContactsGroupUser(GroupNo,UserSeq,RegUserNo) VALUES(GroupNo,UserSeq,UserNo);
	SELECT Seq FROM ContactsGroupUser  WHERE GroupNo=contacts_updatecontactgroupuser.groupno AND  UserSeq=contacts_updatecontactgroupuser.userseq;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.