-- ─── PROCEDURE→FUNCTION: organization_deletepersonalgroup ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.organization_deletepersonalgroup(bigint);
CREATE OR REPLACE FUNCTION public.organization_deletepersonalgroup(
    IN groupno bigint
) RETURNS void
AS $function$
BEGIN



	SELECT UserNo INTO userno FROM Organization_PersonalGroups WHERE GroupNo = organization_deletepersonalgroup.groupno

	DELETE FROM Organization_PersonalGroups WHERE GroupNo = organization_deletepersonalgroup.groupno

	UPDATE Organization_PersonalGroups SET SortNo = SortNo - 1
	WHERE UserNo = UserNo AND SortNo > SortNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
