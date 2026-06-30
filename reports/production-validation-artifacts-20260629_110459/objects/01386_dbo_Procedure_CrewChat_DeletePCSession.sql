-- ─── PROCEDURE→FUNCTION: crewchat_deletepcsession ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.crewchat_deletepcsession();
CREATE OR REPLACE FUNCTION public.crewchat_deletepcsession(
) RETURNS void
AS $function$
DECLARE
    deviceno bigint;
BEGIN



	DeviceNo := (SELECT DeviceNo FROM CrewChat_PCSessions WHERE SessionID = SessionID);
	IF DeviceNo IS NOT NULL THEN;
		DELETE FROM CrewChat_PCSessions WHERE SessionID = SessionID;
		DELETE FROM CrewChat_PCDevices WHERE DeviceNo = DeviceNo
	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
