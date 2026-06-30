-- ─── PROCEDURE→FUNCTION: organization_deletecommongroup ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.organization_deletecommongroup(bigint);
CREATE OR REPLACE FUNCTION public.organization_deletecommongroup(
    IN groupno bigint
) RETURNS void
AS $function$
DECLARE
    sortno integer;
BEGIN



	SortNo := (SELECT SortNo FROM Organization_CommonGroups WHERE GroupNo = organization_deletecommongroup.groupno);;
	DELETE FROM Organization_CommonGroups WHERE GroupNo = organization_deletecommongroup.groupno

	UPDATE Organization_CommonGroups SET SortNo = SortNo - 1
	WHERE SortNo > SortNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
