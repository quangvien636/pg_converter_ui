-- ─── TABLE: WorkingTime_GroupPlace ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."WorkingTime_GroupPlace" (
    GNo serial NOT NULL,
    RegUserNo integer NOT NULL,
    RegDate timestamp without time zone NOT NULL,
    GName character varying(100) NOT NULL,
    GNameEn character varying(100),
    GType integer
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
