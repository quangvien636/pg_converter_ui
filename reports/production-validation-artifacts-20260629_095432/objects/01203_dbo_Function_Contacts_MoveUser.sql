-- ─── FUNCTION: contacts_moveuser ───────────────────────────────
DROP FUNCTION IF EXISTS public.contacts_moveuser(integer);
CREATE OR REPLACE FUNCTION public.contacts_moveuser(
    reguserno integer
) RETURNS void
AS $function$
BEGIN

	
	BEGIN TRAN
    
    UPDATE ContactsGroupUser SET GroupNo=NewBoxKey 
    WHERE RegUserNo=contacts_moveuser.reguserno AND GroupNo=CurBoxKey AND UserSeq=UserSeq

    IF @ERROR <> 0
		BEGIN
			ROLLBACK TRAN
		END
		COMMIT TRAN;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
