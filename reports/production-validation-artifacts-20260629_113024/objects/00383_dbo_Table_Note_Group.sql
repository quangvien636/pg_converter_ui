-- ─── TABLE: Note_Group ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Note_Group" (
    GroupNo uuid NOT NULL PRIMARY KEY,
    Name character varying(250),
    OrderPostion integer,
    DayCreate timestamp without time zone,
    DayEdit timestamp without time zone,
    UserNo integer,
    Show integer DEFAULT 1,
    Icon character varying(250),
    CheckDelete integer NOT NULL DEFAULT 0
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
