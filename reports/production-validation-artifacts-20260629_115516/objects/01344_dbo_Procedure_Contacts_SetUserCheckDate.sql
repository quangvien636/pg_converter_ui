-- ─── PROCEDURE→FUNCTION: contacts_setusercheckdate ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.contacts_setusercheckdate(integer, integer);
CREATE OR REPLACE FUNCTION public.contacts_setusercheckdate(
    IN reguserno integer,
    IN userseq integer
) RETURNS void
AS $function$
BEGIN

	update ContactsUser set CheckDate= NOW() where RegUserNo = contacts_setusercheckdate.reguserno AND Seq = contacts_setusercheckdate.userseq;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
