-- ─── PROCEDURE→FUNCTION: contacts_deleteallgroupbyuserseq ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.contacts_deleteallgroupbyuserseq(integer, integer);
CREATE OR REPLACE FUNCTION public.contacts_deleteallgroupbyuserseq(
    IN userseq integer,
    IN userno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
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
