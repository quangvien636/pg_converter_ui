-- ─── PROCEDURE→FUNCTION: contacts_moveuser ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.contacts_moveuser(integer);
CREATE OR REPLACE FUNCTION public.contacts_moveuser(
    IN reguserno integer
) RETURNS void
AS $function$
BEGIN

	
	BEGIN TRAN
    
    UPDATE ContactsGroupUser SET GroupNo=NewBoxKey 
    WHERE RegUserNo=contacts_moveuser.reguserno AND GroupNo=CurBoxKey AND UserSeq=UserSeq

    IF @ERROR <> 0 THEN
			ROLLBACK TRAN
		END IF;
		COMMIT TRAN;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
