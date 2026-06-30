-- ─── TABLE: Board_Menu ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Board_Menu" (
    MENU_IDX serial NOT NULL,
    MENU_ID character varying(20) NOT NULL,
    MENU_TITLE character varying(100) NOT NULL,
    MENU_PARENT_ID integer,
    MENU_URL character varying(50),
    MENU_DESCRIPTION character varying(50),
    USE_YN character(1) DEFAULT 'Y',
    ID_INSERT integer NOT NULL,
    DTS_INSERT timestamp without time zone NOT NULL DEFAULT now(),
    ID_UPDATE integer,
    DTS_UPDATE timestamp without time zone NOT NULL DEFAULT now()
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
