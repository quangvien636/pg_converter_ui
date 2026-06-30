-- ─── PROCEDURE→FUNCTION: crewchat_insertfavoritechatroom ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.crewchat_insertfavoritechatroom(integer, integer);
CREATE OR REPLACE FUNCTION public.crewchat_insertfavoritechatroom(
    IN reguserno integer,
    IN roomno integer
) RETURNS void
AS $function$
DECLARE
    usercount integer;
BEGIN



	UserCount := (SELECT COUNT(*) FROM CrewChat_FavoriteChatRoom;
	WHERE RegUserNo=crewchat_insertfavoritechatroom.reguserno AND RoomNo = crewchat_insertfavoritechatroom.roomno)

	IF UserCount = 0 THEN;
		INSERT INTO CrewChat_FavoriteChatRoom (RegUserNo, RoomNo, ModDate)
		VALUES (RegUserNo, RoomNo, NOW())
	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
