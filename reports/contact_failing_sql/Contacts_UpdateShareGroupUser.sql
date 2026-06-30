-- ─── PROCEDURE→FUNCTION: contacts_updatesharegroupuser ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.contacts_updatesharegroupuser(integer, integer, integer);
CREATE OR REPLACE FUNCTION public.contacts_updatesharegroupuser(
    IN userno integer DEFAULT 70,
    IN groupno integer DEFAULT 0,
    IN userseq integer DEFAULT 0
) RETURNS void
AS $function$
BEGIN

	UPDATE Contact_PublicGroupUser SET IsDelete= TRUE ,ModUserNo=contacts_updatesharegroupuser.userno,ModDate=NOW() WHERE UserSeq=contacts_updatesharegroupuser.userseq;
	DELETE FROM ContactsGroupUser  WHERE   UserSeq=contacts_updatesharegroupuser.userseq
	--UPDATE Contact_ShareGroupUser SET IsDelete= TRUE ,ModUserNo=UserNo,ModDate=NOW() WHERE UserSeq=UserSeq
	IF EXISTS(SELECT No FROM Contact_ShareGroupUser PG WHERE PG.ShareGroupNo=contacts_updatesharegroupuser.groupno AND  PG.UserSeq=contacts_updatesharegroupuser.userseq AND IsDelete= FALSE ) THEN
		UPDATE Contact_ShareGroupUser SET ShareGroupNo=contacts_updatesharegroupuser.groupno,UserSeq=contacts_updatesharegroupuser.userseq,ModUserNo=contacts_updatesharegroupuser.userno,ModDate=NOW() WHERE ShareGroupNo=contacts_updatesharegroupuser.groupno AND  UserSeq=contacts_updatesharegroupuser.userseq AND IsDelete= FALSE;
	ELSE
		INSERT INTO Contact_ShareGroupUser(ShareGroupNo,UserSeq,RegUserNo,ModUserNo) VALUES(GroupNo,UserSeq,UserNo,UserNo);

	SELECT No FROM Contact_ShareGroupUser PG WHERE PG.ShareGroupNo=contacts_updatesharegroupuser.groupno AND  PG.UserSeq=contacts_updatesharegroupuser.userseq AND IsDelete= FALSE;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.