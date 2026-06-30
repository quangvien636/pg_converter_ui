-- ─── TABLE: NoticeSyn_UserByGroup ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."NoticeSyn_UserByGroup" (
    USERGROUP_ID serial NOT NULL,
    USER_NO integer NOT NULL,
    MENU_ID integer NOT NULL,
    AUTH_GRP_ID integer NOT NULL,
    ID_INSERT integer NOT NULL,
    DTS_INSERT timestamp without time zone NOT NULL DEFAULT now(),
    ID_UPDATE integer,
    DTS_UPDATE timestamp without time zone NOT NULL DEFAULT now(),
    DEPARTMENT_ID integer
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
