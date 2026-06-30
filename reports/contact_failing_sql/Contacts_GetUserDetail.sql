-- ─── PROCEDURE→FUNCTION: contacts_getuserdetail ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.contacts_getuserdetail(integer);
CREATE OR REPLACE FUNCTION public.contacts_getuserdetail(
    IN userseq integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	-- 주소;
	RETURN QUERY
	SELECT
	Seq,
	RegUserNo,
	UserSeq,
	Type,
	TypeName,
	ZipCode1,
	ZipCode2,
	Address,
	IsDefault,
	RegDate,
	ModDate
	FROM ContactsAddress WHERE UserSeq = contacts_getuserdetail.userseq

	-- 회사;
	RETURN QUERY
	SELECT
	Seq,
	RegUserNo,
	UserSeq,
	Company,
	Depart,
	Position,
	IsDefault,
	RegDate,
	ModDate
	FROM ContactsCompany WHERE UserSeq = contacts_getuserdetail.userseq

	-- 기념일;
	RETURN QUERY
	SELECT
	Seq,
	RegUserNo,
	UserSeq,
	Type,
	TypeName,
	Value,
	IsDefault,
	SolarLunar,
	RegDate,
	ModDate
	FROM ContactsDays WHERE UserSeq = contacts_getuserdetail.userseq

	-- 이메일;
	RETURN QUERY
	SELECT
	Seq,
	RegUserNo,
	UserSeq,
	Value,
	IsDefault,
	RegDate,
	ModDate
	FROM ContactsEmail WHERE UserSeq = contacts_getuserdetail.userseq

	-- 그룹;
	RETURN QUERY
	SELECT G.* FROM ContactsGroupUser U
	INNER JOIN ContactsGroup G ON G.GroupNo = U.GroupNo
	WHERE U.UserSeq=contacts_getuserdetail.userseq

	-- 홈페이지;
	RETURN QUERY
	SELECT
	Seq,
	RegUserNo,
	UserSeq,
	Type,
	TypeName,
	Value,
	IsDefault,
	RegDate,
	ModDate
	FROM ContactsHomepage WHERE UserSeq = contacts_getuserdetail.userseq

	-- 전화번호;
	RETURN QUERY
	SELECT
	Seq,
	RegUserNo,
	UserSeq,
	Type,
	TypeName,
	Value,
	IsDefault,
	RegDate,
	ModDate
	FROM ContactsNumber WHERE UserSeq = contacts_getuserdetail.userseq

	-- SNS;
	RETURN QUERY
	SELECT
	Seq,
	RegUserNo,
	UserSeq,
	Type,
	TypeName,
	Value,
	IsDefault,
	RegDate,
	ModDate
	FROM ContactsSns WHERE UserSeq = contacts_getuserdetail.userseq;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.