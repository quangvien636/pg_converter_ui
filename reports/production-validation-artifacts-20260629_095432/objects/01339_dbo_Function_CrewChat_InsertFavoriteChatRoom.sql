-- ─── FUNCTION: crewchat_insertfavoritechatroom ───────────────────────────────
DROP FUNCTION IF EXISTS public.crewchat_insertfavoritechatroom(integer, integer);
CREATE OR REPLACE FUNCTION public.crewchat_insertfavoritechatroom(
    reguserno integer,
    roomno integer
) RETURNS void
AS $function$
DECLARE
    usercount integer;
BEGIN



	SET UserCount = (SELECT COUNT(*) FROM CrewChat_FavoriteChatRoom
	WHERE RegUserNo=crewchat_insertfavoritechatroom.reguserno AND RoomNo = crewchat_insertfavoritechatroom.roomno)

	IF UserCount = 0
	BEGIN;
		INSERT INTO CrewChat_FavoriteChatRoom (RegUserNo, RoomNo, ModDate)
		VALUES (RegUserNo, RoomNo, NOW())
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
