-- ─── TABLE: Cooperation ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Cooperation" (
    CooperationNo serial NOT NULL,
    GroupNo integer NOT NULL,
    RegUserNo integer NOT NULL,
    RegDate timestamp without time zone NOT NULL,
    ModUserNo integer NOT NULL,
    ModDate timestamp without time zone NOT NULL,
    Title character varying(200) NOT NULL,
    Content character varying(200) NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
