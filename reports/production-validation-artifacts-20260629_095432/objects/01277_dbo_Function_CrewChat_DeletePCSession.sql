-- ─── FUNCTION: crewchat_deletepcsession ───────────────────────────────
DROP FUNCTION IF EXISTS public.crewchat_deletepcsession();
CREATE OR REPLACE FUNCTION public.crewchat_deletepcsession(
) RETURNS void
AS $function$
DECLARE
    deviceno bigint;
BEGIN



	SET DeviceNo = (SELECT DeviceNo FROM CrewChat_PCSessions WHERE SessionID = SessionID)
	IF (DeviceNo IS NOT NULL)
	BEGIN;
		DELETE FROM CrewChat_PCSessions WHERE SessionID = SessionID;
		DELETE FROM CrewChat_PCDevices WHERE DeviceNo = DeviceNo
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
