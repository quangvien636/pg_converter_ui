namespace pg_converter_ui;

public enum ObjectType { Procedure, Function, Table, Index, Constraint, View }

public record DbObject(
    string Name,
    ObjectType Type,
    string RawBlock,
    bool IsComplex,
    string Status   // "OK" | "STUB"
);

public record ColumnInfo(
    string Name,
    string TypeName,
    string? Size,           // "50", "MAX", null
    int Precision,
    int Scale,
    bool IsNullable,
    bool IsIdentity,
    bool IsPrimaryKey,
    string? DefaultValue = null  // raw MSSQL DEFAULT expression, e.g. "((0))", "(getdate())", "(N'')"
);
