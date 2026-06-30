-- ─── FUNCTION: edmssetadminlist ───────────────────────────────
DROP FUNCTION IF EXISTS public.edmssetadminlist();
CREATE OR REPLACE FUNCTION public.edmssetadminlist(
) RETURNS TABLE(
    col1 text
)
AS $function$
BEGIN

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.


    -- INSERT INTO statements for procedure here

	IF (SELECT COUNT(*) FROM EDMSUserEnv WHERE UserID = UserId) > 0
	BEGIN;
		UPDATE EDMSUSERENV
		SET
			AdminFlag = AdminFlag
		WHERE UserID = UserId
	END
	ELSE
	BEGIN;
		INSERT INTO EDMSUSERENV
		(UserID, AdminFlag)
		VALUES
		(UserId, AdminFlag)
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
