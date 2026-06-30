-- ─── PROCEDURE→FUNCTION: board_insertboard ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.board_insertboard(integer, timestamp without time zone, character varying, character varying, integer, integer, integer, boolean, boolean, boolean, boolean, integer, boolean, integer);
CREATE OR REPLACE FUNCTION public.board_insertboard(
    IN moduserno integer,
    IN moddate timestamp without time zone,
    IN name character varying,
    IN description character varying,
    IN folderno integer,
    IN displaytypeno integer,
    IN sortno integer,
    IN isreply boolean,
    IN ishead boolean,
    IN isnotice boolean,
    IN isrecommend boolean,
    IN recommendeddisplaycount integer,
    IN enabled boolean,
    IN viewmode integer DEFAULT 2
) RETURNS void
AS $function$
BEGIN

INSERT INTO public."Board_Boards"
           (ModUserNo
           ,ModDate
           ,Name
           ,Description
           ,FolderNo
           ,DisplayTypeNo
           ,SortNo
           ,IsReply
           ,IsHead
           ,IsNotice
           ,IsRecommend
           ,RecommendedDisplayCount
           ,Enabled,
		   ViewMode)
     VALUES
           (ModUserNo ,
			ModDate ,
			Name ,
			Description ,
			FolderNo ,
			DisplayTypeNo ,
			SortNo ,
			IsReply ,
			IsHead ,
			IsNotice ,
			IsRecommend ,
			RecommendedDisplayCount ,
			Enabled,
			ViewMode );
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
