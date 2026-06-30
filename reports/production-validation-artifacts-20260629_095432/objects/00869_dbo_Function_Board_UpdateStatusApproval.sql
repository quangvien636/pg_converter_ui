-- ─── FUNCTION: board_updatestatusapproval ───────────────────────────────
DROP FUNCTION IF EXISTS public.board_updatestatusapproval(bigint, character varying, character varying, character varying, character varying, character varying);
CREATE OR REPLACE FUNCTION public.board_updatestatusapproval(
    contentno bigint,
    type character varying,
    errortype character varying,
    persontype character varying,
    applyto character varying,
    designno character varying
) RETURNS TABLE(
    isalarm text
)
AS $function$
BEGIN


	UPDATE Board_Contents SET
		Type = board_updatestatusapproval.type,
		ErrorType = board_updatestatusapproval.errortype,
		PersonType = board_updatestatusapproval.persontype,
		ApplyTo=board_updatestatusapproval.applyto,
		DesignNo = board_updatestatusapproval.designno,
		Purpose=Purpose
	WHERE ContentNo = board_updatestatusapproval.contentno;

	--SELECT IsAlarm
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
