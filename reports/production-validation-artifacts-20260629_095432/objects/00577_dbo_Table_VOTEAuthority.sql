-- ─── TABLE: VOTEAuthority ───────────────────────────────────
CREATE TABLE IF NOT EXISTS public."VOTEAuthority" (
    ID serial NOT NULL,
    UserNo integer NOT NULL,
    IsFullAuth integer,
    IsRegMod integer,
    RegDate timestamp without time zone NOT NULL,
    ModDate timestamp without time zone,
    DepartNo integer NOT NULL
);
-- TODO: Owner mapping skipped. Target role postgres not verified.
