-- ─── PROCEDURE→FUNCTION: contacts_moveuser ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.contacts_moveuser(integer, integer, integer, integer);
CREATE OR REPLACE FUNCTION public.contacts_moveuser(
    IN reguserno integer,
    IN userseq integer,
    IN curboxkey integer,
    IN newboxkey integer
) RETURNS void
AS $function$
BEGIN




    UPDATE ContactsGroupUser SET GroupNo=contacts_moveuser.newboxkey
    WHERE RegUserNo=contacts_moveuser.reguserno AND GroupNo=contacts_moveuser.curboxkey AND UserSeq=contacts_moveuser.userseq

    IF @ERROR <> 0 THEN

		END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.