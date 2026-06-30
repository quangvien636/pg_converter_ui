-- ─── PROCEDURE→FUNCTION: edmssetadminlist ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.edmssetadminlist();
CREATE OR REPLACE FUNCTION public.edmssetadminlist(
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

    -- INSERT INTO statements for procedure here

	IF (SELECT COUNT(*) FROM EDMSUserEnv WHERE UserID = UserId) > 0 THEN;
		UPDATE EDMSUSERENV
		AdminFlag := AdminFlag;
		WHERE UserID = UserId
	END IF;
	ELSE;
		INSERT INTO EDMSUSERENV
		(UserID, AdminFlag)
		VALUES
		(UserId, AdminFlag)
	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
