-- ─── FUNCTION: board_insertboard ───────────────────────────────
DROP FUNCTION IF EXISTS public.board_insertboard(integer, timestamp without time zone, character varying, character varying, integer, integer, integer, boolean, boolean, boolean, boolean, integer, boolean, integer);
CREATE OR REPLACE FUNCTION public.board_insertboard(
    moduserno integer,
    moddate timestamp without time zone,
    name character varying,
    description character varying,
    folderno integer,
    displaytypeno integer,
    sortno integer,
    isreply boolean,
    ishead boolean,
    isnotice boolean,
    isrecommend boolean,
    recommendeddisplaycount integer,
    enabled boolean,
    viewmode integer DEFAULT 2
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
