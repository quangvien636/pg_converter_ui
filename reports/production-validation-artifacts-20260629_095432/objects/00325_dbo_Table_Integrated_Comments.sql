-- ─── TABLE: Integrated_Comments ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."Integrated_Comments" (
    CommentNo serial NOT NULL,
    IntegratedNo integer NOT NULL,
    RegUserNo integer NOT NULL,
    RegDate timestamp without time zone NOT NULL,
    ModUserNo integer NOT NULL,
    ModDate timestamp without time zone NOT NULL,
    Content character varying(200) NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
