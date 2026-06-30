-- ─── PROCEDURE→FUNCTION: crewchat_getgroupware_badgecount_forv8 ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: TOP was preserved as comment; add LIMIT manually
DROP FUNCTION IF EXISTS public.crewchat_getgroupware_badgecount_forv8(integer);
CREATE OR REPLACE FUNCTION public.crewchat_getgroupware_badgecount_forv8(
    IN userno integer
) RETURNS void
AS $function$
DECLARE
    userid character varying;
    hnewcnt integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN
 


	UserID := (SELECT /* TOP 1 */ UserID FROM Organization_Users WHERE UserNo=crewchat_getgroupware_badgecount_forv8.userno AND Enabled = TRUE);
	-- 미확인 공지 카운트
	EXEC CrewworksDB.public."MESG_GetHNewReference" UserID,HNEWCnt
	-- 전체공지 카운트
	EXEC CrewworksDB.public."MESG_GetHNewReceive" UserID,HNEWCnt

	-- 받은메일함 카운트
	EXEC CrewworksDB.public."MESG_GetMailReceive" UserID

	-- 전자결재 카운트(결재|경유|합의|협조|수신|후결|없음|진행|없음)
	EXEC CrewworksDB.public."MESG_GetEappSign" UserID;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
