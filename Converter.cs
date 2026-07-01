using System.Text;
using System.Text.RegularExpressions;

namespace pg_converter_ui;

public static class Converter
{
    // ── PostgreSQL reserved words that commonly appear as column names ────────
    static readonly HashSet<string> PgReservedWords = new(StringComparer.OrdinalIgnoreCase)
    {
        "all","analyse","analyze","and","any","array","as","asc",
        "asymmetric","both","case","cast","check","collate","column",
        "constraint","create","cross","current_catalog","current_date",
        "current_role","current_schema","current_time","current_timestamp",
        "current_user","default","deferrable","desc","distinct","do",
        "else","end","except","false","fetch","for","foreign","from",
        "grant","group","having","in","initially","inner","intersect",
        "into","lateral","leading","left","like","limit","localtime",
        "localtimestamp","natural","not","null","offset","on","only",
        "or","order","outer","over","overlaps","placing","position","primary",
        "references","returning","right","select","session_user","similar",
        "some","symmetric","table","then","to","trailing","true",
        "union","unique","user","using","variadic","verbose","when",
        "where","window","with"
    };

    static string QuoteIfReserved(string name) =>
        PgReservedWords.Contains(name) ? $"\"{name}\"" : name;

    public static string Convert(DbObject obj, string owner,
        Dictionary<string, List<ColumnInfo>>? tableCatalog = null)
    {
        Logger.Info($"Convert [{obj.Type}] {obj.Name}");
        try
        {
            return obj.Type switch
            {
                ObjectType.Procedure  => ConvertProcedure(obj, owner),
                ObjectType.Function   => ConvertFunction(obj, owner, tableCatalog),
                ObjectType.Table      => ConvertTable(obj, owner),
                ObjectType.Index      => ConvertIndex(obj),
                ObjectType.Constraint => ConvertConstraint(obj),
                ObjectType.View       => ConvertView(obj, owner),
                _                     => $"-- Unknown type: {obj.Name}"
            };
        }
        catch (Exception ex)
        {
            Logger.Error($"Convert [{obj.Type}] {obj.Name} FAILED", ex);
            return $"-- !! ERROR converting {obj.Type} [{obj.Name}]: {ex.Message}\n-- Review raw block above and convert manually.\n";
        }
    }

    // ── PROCEDURE → PostgreSQL function ──────────────────────────────────────

    static string ConvertProcedure(DbObject obj, string owner)
    {
        var block  = obj.RawBlock;
        var pgName = obj.Name.ToLower();

        var hdr = Regex.Match(block,
            @"(?:CREATE\s+OR\s+ALTER|ALTER|CREATE)\s+(?:PROCEDURE|PROC)\s+(?:\[?dbo\]?\.)?\[?(\w+)\]?",
            RegexOptions.IgnoreCase);
        string rawParams = "";
        if (hdr.Success)
        {
            string afterName = block[(hdr.Index + hdr.Length)..];
            var asMarker = Regex.Match(afterName,
                @"(?im)^[ \t]*AS(?:[ \t]+BEGIN)?[ \t]*\r?$");
            if (!asMarker.Success)
                asMarker = Regex.Match(afterName, @"(?i)\s+AS(?:\s+BEGIN)?\b");
            if (asMarker.Success)
                rawParams = afterName[..asMarker.Index].Trim();
        }
        var pgParams = ConvertParams(rawParams, forProcedure: true);
        // Non-default params first
        pgParams = pgParams.Where(p => !p.Contains(" DEFAULT ")).ToList()
                  .Concat(pgParams.Where(p => p.Contains(" DEFAULT "))).ToList();

        var rawBody = ExtractRoutineBody(block);

        // Extract DECLARE vars — handles multi-var lines, skips TABLE vars, handles \r\n endings
        var declares = new List<string>();
        rawBody = Regex.Replace(rawBody,
            @"(?m)^[ \t]*DECLARE[ \t]*\r?\n(?<vars>(?:[ \t]*@\w+[^\r\n]*(?:\r?\n|$))+)",
            m =>
            {
                foreach (Match vm in Regex.Matches(m.Groups["vars"].Value,
                    @"@(\w+)\s+(?!TABLE\b)([A-Za-z_][A-Za-z0-9_]*)(\s*\(\s*[^)]+\))?(?:\s*=\s*[^,\r\n]+)?",
                    RegexOptions.IgnoreCase))
                    declares.Add($"    {vm.Groups[1].Value.ToLower()} {MapType(vm.Groups[2].Value + vm.Groups[3].Value)};");
                return "";
            }, RegexOptions.IgnoreCase);
        var bodyNoDecl = Regex.Replace(rawBody,
            @"(?m)^[ \t]*DECLARE\s+([^\r\n]+)\r?$",
            m =>
            {
                var line = m.Groups[1].Value.TrimEnd();
                // Leave DECLARE @var TABLE(...) for ConvertTempTables
                if (Regex.IsMatch(line, @"^@?\w+\s+TABLE\b", RegexOptions.IgnoreCase))
                    return m.Value;
                // Leave DECLARE name CURSOR ... for BodyConverter.ConvertCursors
                if (Regex.IsMatch(line, @"^@?\w+\s+CURSOR\b", RegexOptions.IgnoreCase))
                    return m.Value;
                // Parse all variables: @name TYPE[(size)] [= default] [, ...]
                foreach (Match vm in Regex.Matches(line,
                    @"@(\w+)\s+(?!TABLE\b)([A-Za-z_][A-Za-z0-9_]*)(\s*\(\s*[^)]+\))?(?:\s*=\s*[^,]+)?",
                    RegexOptions.IgnoreCase))
                    declares.Add($"    {vm.Groups[1].Value.ToLower()} {MapType(vm.Groups[2].Value + vm.Groups[3].Value)};");
                return "";
            }, RegexOptions.IgnoreCase);
        bodyNoDecl = Regex.Replace(bodyNoDecl,
            @"(?:\[dbo\]|dbo)\.(?:\[(\w+)\]|(\w+))",
            m => $"public.\"{(m.Groups[1].Success ? m.Groups[1].Value : m.Groups[2].Value)}\"",
            RegexOptions.IgnoreCase);

        string convertedBody;
        try
        {
            convertedBody = ConvertBody(BodyConverter.Convert(bodyNoDecl, pgName), pgName);
        }
        catch (Exception ex)
        {
            Logger.Warn($"[{pgName}] procedure body conversion failed. {ex.Message}");
            convertedBody = $"-- !! body conversion error: {ex.Message}\n{bodyNoDecl}";
        }
        convertedBody = EnsureLastSemicolon(convertedBody);

        bool hasResultSelect = HasResultReturningSelect(rawBody);
        string returnType = hasResultSelect ? "SETOF record" : "void";
        string? returnTodo = hasResultSelect
            ? "-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually"
            : null;
        // PostgreSQL cannot combine INOUT parameters with an unrelated SETOF
        // return type. Keep the input channel and warn about OUTPUT semantics.
        bool outputModeDemoted = hasResultSelect &&
            pgParams.Any(p => p.TrimStart().StartsWith("INOUT ", StringComparison.OrdinalIgnoreCase));
        if (outputModeDemoted)
            pgParams = pgParams.Select(p => Regex.Replace(
                p, @"^INOUT\s+", "IN ", RegexOptions.IgnoreCase)).ToList();
        bool contactReturnQueryPreInjected = hasResultSelect &&
            (pgName.StartsWith("contact_", StringComparison.OrdinalIgnoreCase) ||
             pgName.StartsWith("contacts_", StringComparison.OrdinalIgnoreCase));
        if (contactReturnQueryPreInjected)
        {
            convertedBody = InjectReturnQuery(convertedBody);
            convertedBody = NormalizeBoardStatementBoundaries(convertedBody);
            convertedBody = RepairBoardCteBoundaries(convertedBody);
        }

        // For void: strip RETURN <literal number>;
        if (returnType == "void")
        {
            convertedBody = Regex.Replace(convertedBody,
                @"(?m)^([ \t]*)RETURN\s+[-+]?\d+\s*;",
                "$1RETURN;", RegexOptions.IgnoreCase);
            if (pgName.StartsWith("contact_", StringComparison.OrdinalIgnoreCase) ||
                pgName.StartsWith("contacts_", StringComparison.OrdinalIgnoreCase))
                convertedBody = Regex.Replace(convertedBody,
                    @"(?m)^([ \t]*)SELECT\s+([-+]?\d+|NULL|'(?:[^']|'')*')\s*;",
                    "$1PERFORM $2;", RegexOptions.IgnoreCase);
        }

        // Add _rowcount declare if needed
        if (Regex.IsMatch(convertedBody, @"\b_rowcount\b", RegexOptions.IgnoreCase))
            declares.Insert(0, "    _rowcount integer := 0;");

        // Qualify param names (strip IN/OUT/INOUT mode prefix for extraction)
        var validParams = pgParams.Where(p => !p.StartsWith("-- UNPARSED")).ToList();
        var paramNames  = validParams
            .Select(p => Regex.Match(p, @"^(?:(?:IN|OUT|INOUT)\s+)?(\w+)").Groups[1].Value.ToLower())
            .Where(n => n.Length >= 2)
            .ToList();
        convertedBody = QualifyParams(convertedBody, pgName, paramNames);

        // Rank 3: Drop DECLARE vars whose names duplicate procedure parameter names.
        // PL/pgSQL raises "duplicate variable declaration" when a DECLARE entry matches a param.
        var paramNameSet = new HashSet<string>(paramNames, StringComparer.OrdinalIgnoreCase);
        declares = declares
            .Where(d => { var m = Regex.Match(d.TrimStart(), @"^(\w+)\s"); return !m.Success || !paramNameSet.Contains(m.Groups[1].Value); })
            .ToList();

        var warnings = new List<string>();
        if (Regex.IsMatch(rawBody, @"\bEXEC(?:UTE)?\s+sp_executesql\b|\bEXEC(?:UTE)?\s*\(", RegexOptions.IgnoreCase))
            warnings.Add("Dynamic SQL detected. Manual rewrite required for PostgreSQL.");
        if (hasResultSelect)
            warnings.Add("procedure contains result-returning SELECT; replace SETOF record with correct column types");
        if (outputModeDemoted)
            warnings.Add("OUTPUT parameter treated as input because PostgreSQL SETOF functions cannot also use INOUT parameters");
        warnings.AddRange(FindUnsupportedWarnings(convertedBody));
        bool hasWarning = BodyConverter.HasUnhandledPatterns(convertedBody) || returnTodo != null || warnings.Any();

        var dropTypes    = GetDropTypes(validParams);
        var createParams = validParams.Any() ? "    " + string.Join(",\n    ", validParams) : "";

        var sb = new StringBuilder();
        sb.AppendLine($"-- ─── PROCEDURE→FUNCTION: {pgName} ───────────────────────────────");
        sb.AppendLine("-- NOTE: SQL Server stored procedure converted to PostgreSQL function.");
        sb.AppendLine("-- TODO: Review converted output — stored procedure semantics differ; test before use in production.");
        if (returnTodo != null) sb.AppendLine(returnTodo);
        foreach (var warn in warnings.Distinct())
            sb.AppendLine($"-- TODO: {warn}");
        sb.AppendLine($"DROP FUNCTION IF EXISTS public.{pgName}({dropTypes});");
        sb.AppendLine($"CREATE OR REPLACE FUNCTION public.{pgName}(");
        if (createParams.Length > 0) sb.AppendLine(createParams);
        sb.AppendLine($") RETURNS {returnType}");
        sb.AppendLine("AS $function$");
        if (declares.Any())
        {
            sb.AppendLine("DECLARE");
            foreach (var d in declares) sb.AppendLine(d);
        }
        if (hasWarning)
            sb.AppendLine("-- !! WARNING: output needs manual review — see TODO comments");
        sb.AppendLine("BEGIN");
        if (hasResultSelect && !contactReturnQueryPreInjected)
            sb.AppendLine(InjectReturnQuery(convertedBody).TrimEnd());
        else
            sb.AppendLine(convertedBody.TrimEnd());
        sb.AppendLine("END;");
        sb.AppendLine("$function$");
        sb.AppendLine("LANGUAGE plpgsql;");
        sb.Append($"-- TODO: Owner mapping skipped. Target role {owner} not verified.");
        return sb.ToString();
    }

    // ── FUNCTION ─────────────────────────────────────────────────────────────

    static string ConvertFunction(DbObject obj, string owner,
        Dictionary<string, List<ColumnInfo>>? tableCatalog = null)
    {
        var block  = obj.RawBlock;
        var pgName = obj.Name.ToLower();

        var hdr = Regex.Match(block,
            @"(?:CREATE\s+OR\s+ALTER|ALTER|CREATE)\s+(?:PROCEDURE|PROC|FUNCTION)\s+(?:\[?dbo\]?\.)?\[?(\w+)\]?\s*([\s\S]*?)(?:AS\s*$|AS\s*BEGIN)",
            RegexOptions.IgnoreCase | RegexOptions.Multiline);

        var rawParams    = hdr.Success ? hdr.Groups[2].Value.Trim() : "";
        bool isTableValued = Regex.IsMatch(block, @"RETURNS\s+@\w+\s+TABLE", RegexOptions.IgnoreCase);
        var scalarReturn = TryGetScalarReturnType(block);
        var functionParams = Regex.Match(block,
            @"FUNCTION\s+(?:\[?dbo\]?\.)?\[?\w+\]?\s*\(([\s\S]*?)\)\s*RETURNS",
            RegexOptions.IgnoreCase);
        if (functionParams.Success) rawParams = functionParams.Groups[1].Value.Trim();

        string? tableResultVariable = null;
        string? declaredTableReturn = null;
        if (isTableValued)
        {
            var tvfReturn = Regex.Match(block,
                @"RETURNS\s+@(\w+)\s+TABLE\s*\(([\s\S]*?)\)\s*AS\b",
                RegexOptions.IgnoreCase);
            if (tvfReturn.Success)
            {
                tableResultVariable = tvfReturn.Groups[1].Value;
                var returnColumns = new List<string>();
                foreach (var part in SplitParams(tvfReturn.Groups[2].Value))
                {
                    var col = Regex.Match(part.Trim(),
                        @"^\[?(\w+)\]?\s+([A-Za-z_][A-Za-z0-9_]*)(\s*\([^)]*\))?");
                    if (!col.Success) continue;
                    returnColumns.Add($"{col.Groups[1].Value.ToLower()} {MapType(col.Groups[2].Value + col.Groups[3].Value)}");
                }
                if (returnColumns.Count > 0)
                    declaredTableReturn = string.Join(",\n    ", returnColumns);
            }
        }

        var pgParams = ConvertParams(rawParams);
        pgParams = pgParams.Where(p => !p.Contains(" DEFAULT ")).ToList()
                  .Concat(pgParams.Where(p => p.Contains(" DEFAULT "))).ToList();

        var rawBody = ExtractRoutineBody(block);
        bool isDml = !isTableValued && !HasResultReturningSelect(rawBody);

        // Extract DECLARE vars — handles multi-var lines, skips TABLE vars, handles \r\n endings
        var declares = new List<string>();
        var bodyNoDecl = Regex.Replace(rawBody,
            @"(?m)^[ \t]*DECLARE\s+([^\r\n]+)\r?$",
            m =>
            {
                var line = m.Groups[1].Value.TrimEnd();
                // Leave DECLARE @var TABLE(...) for ConvertTempTables
                if (Regex.IsMatch(line, @"^@?\w+\s+TABLE\b", RegexOptions.IgnoreCase))
                    return m.Value;
                // Leave DECLARE name CURSOR ... for BodyConverter.ConvertCursors
                if (Regex.IsMatch(line, @"^@?\w+\s+CURSOR\b", RegexOptions.IgnoreCase))
                    return m.Value;
                // Parse all variables: @name TYPE[(size)] [= default] [, ...]
                foreach (Match vm in Regex.Matches(line,
                    @"@(\w+)\s+(?!TABLE\b)([A-Za-z_][A-Za-z0-9_]*)(\s*\(\s*[^)]+\))?(?:\s*=\s*[^,]+)?",
                    RegexOptions.IgnoreCase))
                    declares.Add($"    {vm.Groups[1].Value.ToLower()} {MapType(vm.Groups[2].Value + vm.Groups[3].Value)};");
                return "";
            }, RegexOptions.IgnoreCase);
        bodyNoDecl = Regex.Replace(bodyNoDecl,
            @"(?:\[dbo\]|dbo)\.(?:\[(\w+)\]|(\w+))",
            m => $"public.\"{(m.Groups[1].Success ? m.Groups[1].Value : m.Groups[2].Value)}\"",
            RegexOptions.IgnoreCase);

        string convertedBody;
        try
        {
            convertedBody = obj.IsComplex
                ? ConvertBody(BodyConverter.Convert(bodyNoDecl, pgName), pgName)
                : ConvertBody(bodyNoDecl, pgName);
        }
        catch (Exception ex)
        {
            Logger.Warn($"[{pgName}] body conversion failed — using raw body. {ex.Message}");
            convertedBody = $"-- !! body conversion error: {ex.Message}\n{bodyNoDecl}";
        }
        convertedBody = EnsureLastSemicolon(convertedBody);
        if (scalarReturn is "character varying" or "character" or "text")
            convertedBody = Regex.Replace(convertedBody, @"(?<=\S)\s*\+\s*(?=\S)", " || ");
        if (isTableValued && tableResultVariable != null)
            convertedBody = Regex.Replace(convertedBody,
                $@"\bINSERT\s+INTO\s+{Regex.Escape(tableResultVariable)}\s+(SELECT[\s\S]+?);\s*RETURN\s*;",
                "RETURN QUERY $1;", RegexOptions.IgnoreCase);

        // For void functions: strip RETURN <number>;
        if (isDml)
            convertedBody = Regex.Replace(convertedBody,
                @"(?m)^([ \t]*)RETURN\s+[-+]?\d+\s*;",
                "$1RETURN;", RegexOptions.IgnoreCase);

        if (Regex.IsMatch(convertedBody, @"\b_rowcount\b", RegexOptions.IgnoreCase))
            declares.Insert(0, "    _rowcount integer := 0;");

        string returnType;
        string? returnTodo = null;
        if (scalarReturn != null)
        {
            returnType = scalarReturn;
        }
        else if (declaredTableReturn != null)
        {
            returnType = $"TABLE(\n    {declaredTableReturn}\n)";
        }
        else if (isDml)
        {
            returnType = "void";
        }
        else
        {
            var cols = TryExtractReturnColumns(convertedBody, rawBody, tableCatalog);
            if (!string.IsNullOrEmpty(cols))
            {
                returnType = $"TABLE(\n    {cols}\n)";
                Logger.Info($"[{pgName}] auto-detected RETURNS TABLE columns");
            }
            else
            {
                returnType = "SETOF record";
                returnTodo = "-- TODO: replace SETOF record — add RETURNS TABLE(col1 type, col2 type, ...)";
                Logger.Warn($"[{pgName}] cannot auto-detect return columns → SETOF record");
            }
        }

        var validParams  = pgParams.Where(p => !p.StartsWith("-- UNPARSED")).ToList();
        var paramNames   = validParams
            .Select(p => Regex.Match(p, @"^(\w+)").Groups[1].Value.ToLower())
            .Where(n => n.Length >= 2)
            .ToList();
        convertedBody = QualifyParams(convertedBody, pgName, paramNames);

        // Rank 3: Drop DECLARE vars whose names duplicate function parameter names.
        var paramNameSetF = new HashSet<string>(paramNames, StringComparer.OrdinalIgnoreCase);
        declares = declares
            .Where(d => { var m = Regex.Match(d.TrimStart(), @"^(\w+)\s"); return !m.Success || !paramNameSetF.Contains(m.Groups[1].Value); })
            .ToList();

        var warnings = FindUnsupportedWarnings(convertedBody).ToList();
        bool hasWarning = BodyConverter.HasUnhandledPatterns(convertedBody) || returnTodo != null || warnings.Any();

        var dropTypes    = GetDropTypes(validParams);
        var createParams = validParams.Any() ? "    " + string.Join(",\n    ", validParams) : "";

        var sb = new StringBuilder();
        sb.AppendLine($"-- ─── FUNCTION: {pgName} ───────────────────────────────");
        sb.AppendLine($"DROP FUNCTION IF EXISTS public.{pgName}({dropTypes});");
        sb.AppendLine($"CREATE OR REPLACE FUNCTION public.{pgName}(");
        if (createParams.Length > 0) sb.AppendLine(createParams);
        sb.AppendLine($") RETURNS {returnType}");
        if (returnTodo != null) sb.AppendLine(returnTodo);
        foreach (var warn in warnings.Distinct())
            sb.AppendLine($"-- TODO: {warn}");
        sb.AppendLine("AS $function$");
        if (isTableValued)
            sb.AppendLine("#variable_conflict use_column");

        if (declares.Any())
        {
            sb.AppendLine("DECLARE");
            foreach (var d in declares) sb.AppendLine(d);
        }
        if (hasWarning)
            sb.AppendLine("-- !! WARNING: output needs manual review — see TODO comments");
        sb.AppendLine("BEGIN");

        if (scalarReturn != null)
            sb.AppendLine(convertedBody.TrimEnd());
        else if (!isDml)
            sb.AppendLine(InjectReturnQuery(convertedBody).TrimEnd());
        else
            sb.AppendLine(convertedBody.TrimEnd());
        sb.AppendLine("END;");
        sb.AppendLine("$function$");
        sb.AppendLine("LANGUAGE plpgsql;");
        sb.Append($"-- TODO: Owner mapping skipped. Target role {owner} not verified.");
        return sb.ToString();
    }

    static string ExtractRoutineBody(string block)
    {
        var bodyMatch = Regex.Match(block,
            @"(?:AS\s*BEGIN|AS\s*\r?\n)([\s\S]+?)(?:\r?\n\s*END\s*;?\s*\z|\z)",
            RegexOptions.IgnoreCase);
        if (bodyMatch.Success) return bodyMatch.Groups[1].Value;

        var asMatch = Regex.Match(block, @"\bAS\b\s*\r?\n([\s\S]+)", RegexOptions.IgnoreCase);
        return asMatch.Success ? asMatch.Groups[1].Value : "";
    }

    static string? TryGetScalarReturnType(string block)
    {
        if (Regex.IsMatch(block, @"RETURNS\s+@\w+\s+TABLE", RegexOptions.IgnoreCase))
            return null;

        var m = Regex.Match(block,
            @"\bRETURNS\s+([A-Za-z_][A-Za-z0-9_]*)(\s*\(\s*[^)]+\))?",
            RegexOptions.IgnoreCase);
        if (!m.Success) return null;
        return MapType(m.Groups[1].Value + m.Groups[2].Value);
    }

    static IEnumerable<string> FindUnsupportedWarnings(string body)
    {
        var checks = new (string Pattern, string Message)[]
        {
            (@"\bEXECUTE\s+format\b|\bEXECUTE\s+\w+", "dynamic SQL converted best-effort; review EXECUTE statement"),
            (@"DECLARE\s+@\w+\s+TABLE|\b@\w+\s+TABLE\b", "table variable is not fully supported; use temp table or manual rewrite"),
            (@"\bTRY\b|\bCATCH\b", "TRY/CATCH requires manual EXCEPTION block review"),
            (@"\/\*\s*TOP\s+\d+\s*\*\/", "TOP was preserved as comment; add LIMIT manually"),
            (@"\bOPENROWSET\b|TODO_CONN_", "linked-server query requires postgres_fdw or dblink configuration"),
            (@"\bMERGE\b", "MERGE requires manual review for PostgreSQL version and semantics"),
            (@"\bIIF\s*\(", "IIF was not fully converted; use CASE WHEN"),
            (@"\bLEN\s*\(", "LEN was not fully converted; use length()"),
            (@"\bDATEADD\s*\(", "DATEADD was not fully converted; use interval arithmetic")
        };

        foreach (var (pattern, message) in checks)
            if (Regex.IsMatch(body, pattern, RegexOptions.IgnoreCase))
                yield return message;
    }

    // ── Auto-detect SELECT column list for RETURNS TABLE ─────────────────────

    static string TryExtractReturnColumns(string pgBody, string rawBody,
        Dictionary<string, List<ColumnInfo>>? catalog)
    {
        string searchIn = pgBody;

        var allSelects = Regex.Matches(searchIn,
            @"\bSELECT\s+([\s\S]+?)\s+FROM\b",
            RegexOptions.IgnoreCase);

        string colPart;
        if (allSelects.Count > 0)
        {
            colPart = allSelects[allSelects.Count - 1].Groups[1].Value.Trim();

            if (Regex.IsMatch(colPart, @"^\s*\*\s*$"))
            {
                var lastIdx = allSelects[allSelects.Count - 1].Index;
                var fromM   = Regex.Match(searchIn[lastIdx..], @"\bFROM\s+(\w+)", RegexOptions.IgnoreCase);
                if (fromM.Success && catalog != null
                    && catalog.TryGetValue(fromM.Groups[1].Value.ToLower(), out var catCols))
                {
                    Logger.Info($"TryExtractReturnColumns: resolved SELECT * from catalog ({fromM.Groups[1].Value})");
                    return string.Join(",\n    ", catCols.Select(c => $"{c.Name.ToLower()} {MapCatalogType(c)}"));
                }

                var rawFromM = Regex.Match(rawBody, @"\bFROM\s+\[?(\w+)\]?", RegexOptions.IgnoreCase);
                if (rawFromM.Success && catalog != null
                    && catalog.TryGetValue(rawFromM.Groups[1].Value.ToLower(), out var rawCatCols))
                {
                    return string.Join(",\n    ", rawCatCols.Select(c => $"{c.Name.ToLower()} {MapCatalogType(c)}"));
                }

                if (fromM.Success)
                    colPart = TryResolveCteColumns(searchIn, fromM.Groups[1].Value);

                if (string.IsNullOrEmpty(colPart) || Regex.IsMatch(colPart, @"^\s*\*\s*$"))
                {
                    colPart = "";
                    for (int i = allSelects.Count - 2; i >= 0; i--)
                    {
                        var c = allSelects[i].Groups[1].Value.Trim();
                        if (!Regex.IsMatch(c, @"^\s*\*\s*$")) { colPart = c; break; }
                    }
                }
            }
        }
        else
        {
            var scalarM = Regex.Match(searchIn,
                @"\bSELECT\s+((?!INTO\b)[\s\S]+?)(?:\s*;|$)",
                RegexOptions.IgnoreCase);
            if (!scalarM.Success) return "";
            colPart = scalarM.Groups[1].Value.Trim();
        }

        if (string.IsNullOrEmpty(colPart) || Regex.IsMatch(colPart, @"^\s*\*\s*$")) return "";
        return BuildColDefs(colPart);
    }

    static string TryResolveCteColumns(string searchIn, string cteName)
    {
        var cteM = Regex.Match(searchIn,
            $@"\b{Regex.Escape(cteName)}\s+AS\s*\(\s*SELECT\s+([\s\S]+?)\s+FROM\b",
            RegexOptions.IgnoreCase);
        return cteM.Success ? cteM.Groups[1].Value.Trim() : "";
    }

    static bool HasResultReturningSelect(string body)
    {
        var b = body;
        b = Regex.Replace(b, @"(?m)^[ \t]*SELECT\s+@\w+\s*=[^\r\n]*$",
            "", RegexOptions.IgnoreCase | RegexOptions.Multiline);
        b = Regex.Replace(b, @"\bSELECT\s+(?:@\w+\s*=[^,\r\n;]+,\s*)+@\w+\s*=[^\r\n;]+",
            "", RegexOptions.IgnoreCase);
        b = Regex.Replace(b, @"\bSELECT\b[^;]*\bINTO\s+#\w+[^;]*",
            "", RegexOptions.IgnoreCase);
        b = Regex.Replace(b, @"\bINSERT\b[^\r\n]*\bSELECT\b",
            "", RegexOptions.IgnoreCase);
        b = Regex.Replace(b, @"\bINSERT\b[^\r\n]*\r?\n\s*SELECT\b",
            "", RegexOptions.IgnoreCase);
        b = Regex.Replace(b, @"\bFOR\s+SELECT\b",
            "", RegexOptions.IgnoreCase);
        b = Regex.Replace(b, @"\bIF\s+(?:NOT\s+)?EXISTS\s*\([^)]*\)",
            "", RegexOptions.IgnoreCase);
        b = Regex.Replace(b, @"\(\s*SELECT\b[^)]*\)",
            "", RegexOptions.IgnoreCase);
        return Regex.IsMatch(b, @"\bSELECT\b", RegexOptions.IgnoreCase);
    }

    static string InjectReturnQuery(string body)
    {
        var lines  = body.Split('\n');
        var result = new List<string>(lines.Length * 2);
        int depth  = 0;
        bool inStr = false;
        bool inDmlStatement = false;
        bool dmlIsInsert = false;
        bool dmlHasValues = false;
        bool dmlHasSelect = false;
        // Set when RETURN QUERY is injected before a WITH CTE — the following SELECT is the CTE's
        // main query and should NOT get its own RETURN QUERY injection.
        bool skipNextTopSelect = false;

        foreach (var rawLine in lines)
        {
            var trimmed = rawLine.TrimStart();
            var indent  = rawLine.Length > trimmed.Length ? rawLine[..^trimmed.Length] : "";

            // CTE at top level: any WITH keyword at depth 0 starts a CTE block.
            // RETURN QUERY belongs before WITH (not before the final SELECT inside the CTE).
            // Handles both "WITH name AS (" on same line and bare "WITH" alone on a line.
            bool isTopCte = depth == 0
                && !trimmed.StartsWith("--", StringComparison.Ordinal)
                && Regex.IsMatch(trimmed, @"^WITH\b", RegexOptions.IgnoreCase);

            // UNION/INTERSECT/EXCEPT at top level: next SELECT is part of the same result set,
            // so no additional RETURN QUERY should be injected before it.
            bool isUnionAtTop = depth == 0
                && !trimmed.StartsWith("--", StringComparison.Ordinal)
                && Regex.IsMatch(trimmed, @"^(?:UNION|INTERSECT|EXCEPT)\b", RegexOptions.IgnoreCase);

            bool selectFollowsCompletedDml = inDmlStatement &&
                (!dmlIsInsert || dmlHasValues || dmlHasSelect);
            bool isSelectAtTop = depth == 0
                && !trimmed.StartsWith("--", StringComparison.Ordinal)
                && Regex.IsMatch(trimmed, @"^SELECT\b", RegexOptions.IgnoreCase)
                && (!inDmlStatement || selectFollowsCompletedDml)
                && !Regex.IsMatch(trimmed, @"^SELECT\s+@?\w+\s*=", RegexOptions.IgnoreCase)
                && !Regex.IsMatch(trimmed, @"^SELECT\b[^\r\n]*\bINTO\s+\w", RegexOptions.IgnoreCase);

            if (depth == 0
                && !trimmed.StartsWith("--", StringComparison.Ordinal)
                && Regex.IsMatch(trimmed,
                    @"^(?:INSERT\b|UPDATE\b|DELETE\b|CREATE\s+TEMP(?:ORARY)?\s+TABLE\b.*\bAS\b)",
                    RegexOptions.IgnoreCase))
            {
                inDmlStatement = true;
                dmlIsInsert = Regex.IsMatch(trimmed,
                    @"^(?:INSERT\b|CREATE\s+TEMP(?:ORARY)?\s+TABLE\b.*\bAS\b)",
                    RegexOptions.IgnoreCase);
                dmlHasValues = Regex.IsMatch(trimmed, @"\bVALUES\b", RegexOptions.IgnoreCase);
                dmlHasSelect = false;
            }

            if (inDmlStatement && Regex.IsMatch(trimmed, @"^VALUES\b", RegexOptions.IgnoreCase))
                dmlHasValues = true;

            if (isTopCte)
            {
                result.Add(indent + "RETURN QUERY");
                skipNextTopSelect = true;
            }
            else if (isUnionAtTop)
            {
                // Next SELECT is a UNION member — RETURN QUERY already covers the whole set
                skipNextTopSelect = true;
            }
            else if (isSelectAtTop)
            {
                if (selectFollowsCompletedDml)
                {
                    for (int i = result.Count - 1; i >= 0; i--)
                    {
                        if (string.IsNullOrWhiteSpace(result[i])) continue;
                        if (!result[i].TrimEnd().EndsWith(";"))
                            result[i] = result[i].TrimEnd() + ";";
                        break;
                    }
                    inDmlStatement = false;
                    dmlIsInsert = false;
                    dmlHasValues = false;
                    dmlHasSelect = false;
                }
                if (skipNextTopSelect)
                    skipNextTopSelect = false;  // CTE main SELECT or UNION member — already covered
                else
                {
                    // Terminate any preceding RETURN QUERY SELECT before injecting another.
                    // Guard with BoardLineNeedsTerminator to avoid adding ; to THEN/ELSE/BEGIN/etc.
                    for (int i = result.Count - 1; i >= 0; i--)
                    {
                        if (string.IsNullOrWhiteSpace(result[i])) continue;
                        string prevCode = StripLineComment(result[i]).TrimEnd();
                        if (BoardLineNeedsTerminator(prevCode))
                            result[i] = result[i].TrimEnd() + ";";
                        break;
                    }
                    result.Add(indent + "RETURN QUERY");
                }
            }

            result.Add(rawLine);

            if (inDmlStatement
                && Regex.IsMatch(trimmed, @"^SELECT\b", RegexOptions.IgnoreCase)
                && !selectFollowsCompletedDml)
                dmlHasSelect = true;

            for (int i = 0; i < rawLine.Length; i++)
            {
                char c = rawLine[i];
                if (!inStr && i + 1 < rawLine.Length && c == '-' && rawLine[i + 1] == '-') break;
                if (c == '\'' && !inStr) { inStr = true; continue; }
                if (c == '\'' && inStr)
                {
                    if (i + 1 < rawLine.Length && rawLine[i + 1] == '\'') { i++; continue; }
                    inStr = false; continue;
                }
                if (!inStr)
                {
                    if (c == '(') depth++;
                    else if (c == ')' && depth > 0) depth--;
                    else if (c == ';' && depth == 0)
                    {
                        skipNextTopSelect = false;
                        inDmlStatement = false;
                        dmlIsInsert = false;
                        dmlHasValues = false;
                        dmlHasSelect = false;
                    }
                }
            }
        }

        return RepairBoardCteBoundaries(string.Join('\n', result));
    }

    static string BuildColDefs(string colPart)
    {
        var cols = SplitParams(colPart);
        if (cols.Count == 0) return "";

        var defs = cols.Select((col, i) =>
        {
            col = col.Trim();
            var am = Regex.Match(col, @"\bAS\s+(?:""(\w+)""|(\w+))\s*$", RegexOptions.IgnoreCase);
            string name;
            if (am.Success)
                name = (am.Groups[1].Value.Length > 0 ? am.Groups[1].Value : am.Groups[2].Value).ToLower();
            else
            {
                var dm = Regex.Match(col, @"\.(\w+)\s*$");
                if (dm.Success)
                    name = dm.Groups[1].Value.ToLower();
                else if (Regex.Match(col, @"^(\w+)\s*$") is { Success: true } bm)
                    name = bm.Groups[1].Value.ToLower();
                else
                    name = $"col{i + 1}";
            }
            return $"{name} text";
        }).ToList();

        if (defs.Count == 0) return "";
        return string.Join(",\n    ", defs);
    }

    // ── TABLE ─────────────────────────────────────────────────────────────────

    static string ConvertTable(DbObject obj, string owner)
    {
        if (obj.RawBlock.StartsWith("__TABLE_FROM_CATALOG__"))
        {
            var cols = MssqlDbReader.ParseTableRaw(obj.RawBlock);
            return ConvertTableFromCatalog(obj.Name, cols, owner);
        }

        var block  = obj.RawBlock;
        var pgName = obj.Name;

        var bodyMatch = Regex.Match(block, @"CREATE\s+TABLE\s+[^\(]+\(([\s\S]+)\)\s*$",
            RegexOptions.IgnoreCase | RegexOptions.Multiline);
        if (!bodyMatch.Success)
            return $"-- Could not parse table: {pgName}\n-- RAW:\n{block}";

        var colDefs = bodyMatch.Groups[1].Value;

        // Remove brackets, quoting reserved words
        colDefs = Regex.Replace(colDefs, @"\[(\w+)\]", m => {
            var n = m.Groups[1].Value;
            return QuoteIfReserved(n);
        });
        colDefs = Regex.Replace(colDefs, @"\bdbo\.(\w+)\b", m => $"public.\"{m.Groups[1].Value}\"", RegexOptions.IgnoreCase);

        // IDENTITY
        colDefs = Regex.Replace(colDefs,
            @"\b(BIGINT|INT|INTEGER)\s+IDENTITY\s*\(\s*\d+\s*,\s*\d+\s*\)",
            m => m.Groups[1].Value.Equals("BIGINT", StringComparison.OrdinalIgnoreCase) ? "bigserial" : "serial",
            RegexOptions.IgnoreCase);
        colDefs = Regex.Replace(colDefs, @"\bIDENTITY\s*\(\s*\d+\s*,\s*\d+\s*\)", "", RegexOptions.IgnoreCase);

        // DEFAULT mappings
        colDefs = Regex.Replace(colDefs, @"\bDEFAULT\s*\(\s*GETDATE\s*\(\s*\)\s*\)", "DEFAULT now()", RegexOptions.IgnoreCase);
        colDefs = Regex.Replace(colDefs, @"\bDEFAULT\s+GETDATE\s*\(\s*\)", "DEFAULT now()", RegexOptions.IgnoreCase);
        var hasNewIdDefault = Regex.IsMatch(colDefs, @"\bDEFAULT\s*\(*\s*NEWID\s*\(\s*\)\s*\)*", RegexOptions.IgnoreCase);
        colDefs = Regex.Replace(colDefs, @"(?:\bCONSTRAINT\s+\w+\s+)?\bDEFAULT\s*\(*\s*NEWID\s*\(\s*\)\s*\)*", "", RegexOptions.IgnoreCase);
        colDefs = Regex.Replace(colDefs, @"\bDEFAULT\s*\(\s*N'([^']*)'\s*\)", "DEFAULT '$1'", RegexOptions.IgnoreCase);
        colDefs = Regex.Replace(colDefs, @"\bDEFAULT\s*\(\s*([^)]+?)\s*\)", "DEFAULT $1", RegexOptions.IgnoreCase);

        // Type conversions
        colDefs = Regex.Replace(colDefs, @"\bDATETIMEOFFSET\b(?:\s*\(\s*\d+\s*\))?", "timestamp with time zone", RegexOptions.IgnoreCase);
        colDefs = Regex.Replace(colDefs, @"\bSYSNAME\b", "character varying(128)", RegexOptions.IgnoreCase);
        colDefs = Regex.Replace(colDefs, @"\bBIGINT\b", "bigint", RegexOptions.IgnoreCase);
        colDefs = Regex.Replace(colDefs, @"\bSMALLINT\b", "smallint", RegexOptions.IgnoreCase);
        colDefs = Regex.Replace(colDefs, @"\bTINYINT\b", "smallint", RegexOptions.IgnoreCase);
        colDefs = Regex.Replace(colDefs, @"\bINT\b(?!\w)", "integer", RegexOptions.IgnoreCase);
        colDefs = Regex.Replace(colDefs, @"\bBIT\b(?!\w)", "boolean", RegexOptions.IgnoreCase);
        colDefs = Regex.Replace(colDefs, @"\bDATETIME2?\s*(?:\(\s*\d+\s*\))?", "timestamp without time zone", RegexOptions.IgnoreCase);
        colDefs = Regex.Replace(colDefs, @"\bSMALLDATETIME\b", "timestamp without time zone", RegexOptions.IgnoreCase);
        colDefs = Regex.Replace(colDefs, @"\bDATE\b(?!\w)", "date", RegexOptions.IgnoreCase);
        colDefs = Regex.Replace(colDefs, @"\bN?VARCHAR\s*\(\s*MAX\s*\)", "text", RegexOptions.IgnoreCase);
        colDefs = Regex.Replace(colDefs, @"\bN?VARCHAR\b", "character varying", RegexOptions.IgnoreCase);
        colDefs = Regex.Replace(colDefs, @"\bN?CHAR\b", "character", RegexOptions.IgnoreCase);
        colDefs = Regex.Replace(colDefs, @"\bN?TEXT\b", "text", RegexOptions.IgnoreCase);
        colDefs = Regex.Replace(colDefs, @"\bMONEY\b|\bSMALLMONEY\b", "numeric(19,4)", RegexOptions.IgnoreCase);
        colDefs = Regex.Replace(colDefs, @"\bDECIMAL\b|\bNUMERIC\b", "numeric", RegexOptions.IgnoreCase);
        colDefs = Regex.Replace(colDefs, @"\bFLOAT\b|\bREAL\b", "double precision", RegexOptions.IgnoreCase);
        colDefs = Regex.Replace(colDefs, @"\bUNIQUEIDENTIFIER\b", "uuid", RegexOptions.IgnoreCase);
        colDefs = Regex.Replace(colDefs, @"\bIMAGE\b|\bVARBINARY\b(\([^)]*\))?", "bytea", RegexOptions.IgnoreCase);
        colDefs = Regex.Replace(colDefs, @"\bXML\b", "xml", RegexOptions.IgnoreCase);

        // Remove MSSQL-specific clauses
        colDefs = Regex.Replace(colDefs, @"\bCONSTRAINT\s+\w+\s+DEFAULT\s+([^,\n]+)", "DEFAULT $1", RegexOptions.IgnoreCase);
        colDefs = Regex.Replace(colDefs,
            @"(\bboolean\b[^\r\n,]*\bDEFAULT)\s*\(*\s*([01])\b\s*\)*",
            m => $"{m.Groups[1].Value} {(m.Groups[2].Value == "1" ? "true" : "false")}",
            RegexOptions.IgnoreCase);
        colDefs = Regex.Replace(colDefs, @"\bCONSTRAINT\s+\w+\s+(?=PRIMARY\s+KEY\b)", "", RegexOptions.IgnoreCase);
        colDefs = Regex.Replace(colDefs, @"\bCONSTRAINT\s+\w+\s+(UNIQUE)[^\n,]*", "$1", RegexOptions.IgnoreCase);
        colDefs = Regex.Replace(colDefs, @"\bCLUSTERED\b|\bNONCLUSTERED\b", "", RegexOptions.IgnoreCase);
        colDefs = Regex.Replace(colDefs, @"\bPRIMARY\s+KEY\s*\(([^)]*)\)",
            m => $"PRIMARY KEY ({Regex.Replace(m.Groups[1].Value, @"\s+\b(?:ASC|DESC)\b", "", RegexOptions.IgnoreCase)})",
            RegexOptions.IgnoreCase);
        colDefs = Regex.Replace(colDefs, @"\bWITH\s*\([^)]+\)", "", RegexOptions.IgnoreCase);
        colDefs = Regex.Replace(colDefs, @"\bON\s+\[?PRIMARY\]?", "", RegexOptions.IgnoreCase);

        var sb = new StringBuilder();
        sb.AppendLine($"-- ─── TABLE: {pgName} ───────────────────────────────────");
        if (hasNewIdDefault)
            sb.AppendLine("-- TODO: NEWID() requires manual rewrite or uuid-ossp extension on PostgreSQL 9.3.");
        sb.AppendLine($"CREATE TABLE IF NOT EXISTS public.\"{pgName}\" (");
        sb.AppendLine(colDefs.Trim().TrimEnd(','));
        sb.AppendLine(");");
        sb.Append($"-- TODO: Owner mapping skipped. Target role {owner} not verified.");
        return sb.ToString();
    }

    // ── INDEX ─────────────────────────────────────────────────────────────────

    static string ConvertIndex(DbObject obj)
    {
        var block = obj.RawBlock;

        // Strip INCLUDE (...) before matching — index key columns only
        var blockNoInclude = Regex.Replace(block, @"\s+INCLUDE\s*\([^)]+\)", "", RegexOptions.IgnoreCase);
        // Strip WHERE ... filter
        var blockNoWhere = Regex.Replace(blockNoInclude, @"\s+WHERE\s+.+$", "", RegexOptions.IgnoreCase);

        var m = Regex.Match(blockNoWhere,
            @"CREATE\s+(UNIQUE\s+)?(?:CLUSTERED\s+|NONCLUSTERED\s+)?INDEX\s+\[?(\w+)\]?\s+ON\s+(?:\[?dbo\]?\.)?\[?(\w+)\]?\s*\(([^)]+)\)",
            RegexOptions.IgnoreCase);
        if (!m.Success) return $"-- Could not parse index: {obj.Name}\n-- RAW: {block}";

        var unique  = m.Groups[1].Success ? "UNIQUE " : "";
        var idxName = m.Groups[2].Value.ToLower();
        var tblName = m.Groups[3].Value;
        var cols    = Regex.Replace(m.Groups[4].Value, @"\[(\w+)\]", "$1");
        cols = Regex.Replace(cols, @"\b(ASC|DESC)\b", "", RegexOptions.IgnoreCase).Trim().TrimEnd(',');
        var isClustered = Regex.IsMatch(block, @"\bCREATE\s+(?:UNIQUE\s+)?CLUSTERED\s+INDEX\b", RegexOptions.IgnoreCase);

        // Extract optional WHERE filter from original block for partial index
        var filterM  = Regex.Match(block, @"\bWHERE\s+(.+?)(?:\s*$)", RegexOptions.IgnoreCase | RegexOptions.Multiline);
        var filterStr = filterM.Success
            ? " WHERE " + Regex.Replace(filterM.Groups[1].Value.Trim(), @"\[(\w+)\]", "$1")
            : "";

        var sb = new StringBuilder();
        sb.AppendLine($"-- ─── INDEX: {idxName} ON {tblName} ─────────────────────");
        if (isClustered)
            sb.AppendLine("-- TODO: SQL Server CLUSTERED index detected. PostgreSQL does not maintain clustered indexes the same way. Manual review required.");
        sb.AppendLine("DO $$");
        sb.AppendLine("BEGIN");
        sb.AppendLine($"    IF NOT EXISTS (SELECT 1 FROM pg_indexes WHERE schemaname = 'public' AND indexname = '{idxName}') THEN");
        sb.AppendLine($"        CREATE {unique}INDEX {idxName} ON public.\"{tblName}\" ({cols}){filterStr};");
        sb.AppendLine("    END IF;");
        sb.AppendLine("END;");
        sb.Append("$$;");
        return sb.ToString();
    }

    // ── HELPERS ───────────────────────────────────────────────────────────────

    static string ConvertConstraint(DbObject obj)
    {
        var raw = obj.RawBlock;

        // FK constraint loaded from MssqlDbReader.LoadForeignKeys
        if (raw.StartsWith("__FK_CONSTRAINT__"))
        {
            var data  = raw["__FK_CONSTRAINT__".Length..].Trim();
            var parts = data.Split('|');
            if (parts.Length >= 5)
            {
                var fkName     = parts[0].ToLower();
                var childTable = parts[1];
                var childCols  = string.Join(", ", parts[2].Split(',').Select(c => c.Trim()));
                var parentTable= parts[3];
                var parentCols = string.Join(", ", parts[4].Split(',').Select(c => c.Trim()));
                var onDelete   = parts.Length >= 6 ? PgReferentialAction(parts[5]) : "";
                var onUpdate   = parts.Length >= 7 ? PgReferentialAction(parts[6]) : "";
                var onClause   = new List<string>();
                if (!string.IsNullOrEmpty(onDelete)) onClause.Add($"ON DELETE {onDelete}");
                if (!string.IsNullOrEmpty(onUpdate)) onClause.Add($"ON UPDATE {onUpdate}");
                var onStr = onClause.Count > 0 ? " " + string.Join(" ", onClause) : "";

                return $@"-- ─── FK: {fkName} ───────────────────────────────
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = '{fkName}' AND contype = 'f') THEN
        ALTER TABLE public.""{childTable}"" ADD CONSTRAINT {fkName}
            FOREIGN KEY ({childCols}) REFERENCES public.""{parentTable}"" ({parentCols}){onStr};
    END IF;
END;
$$;";
            }
        }

        // Fallback: comment out all lines of raw block safely
        var commentedRaw = string.Join("\n", raw.Split('\n').Select(l => $"-- {l}"));
        return $"-- TODO: constraint conversion not implemented for: {obj.Name}\n{commentedRaw}";
    }

    static string PgReferentialAction(string msAction) => msAction.Trim().ToUpperInvariant() switch
    {
        "CASCADE"      => "CASCADE",
        "SET_NULL"     => "SET NULL",
        "SET_DEFAULT"  => "SET DEFAULT",
        "NO_ACTION"    => "",
        "RESTRICT"     => "",
        _              => ""
    };

    static string ConvertView(DbObject obj, string owner)
    {
        var block  = obj.RawBlock;
        var pgName = obj.Name;

        // Cannot convert encrypted views
        if (Regex.IsMatch(block, @"\bWITH\s+ENCRYPTION\b", RegexOptions.IgnoreCase))
            return $"-- TODO: view [{pgName}] uses WITH ENCRYPTION — cannot convert automatically.\n" +
                   $"-- Recreate manually: CREATE OR REPLACE VIEW public.\"{pgName}\" AS SELECT ...";

        // Extract body after AS keyword
        var asMatch = Regex.Match(block,
            @"\bAS\b\s*\r?\n([\s\S]+)",
            RegexOptions.IgnoreCase);
        var body = asMatch.Success ? asMatch.Groups[1].Value.Trim() : "";

        if (string.IsNullOrWhiteSpace(body))
        {
            var commentedRaw = string.Join("\n", block.Split('\n').Select(l => $"-- {l}"));
            return $"-- TODO: could not extract view body for [{pgName}]\n{commentedRaw}";
        }

        // Convert body from T-SQL to PostgreSQL SQL
        body = Regex.Replace(body, @"\[(\w+)\]", "$1");
        body = Regex.Replace(body, @"(?:\bdbo\b\.)", "public.", RegexOptions.IgnoreCase);
        body = Regex.Replace(body, @"\bWITH\s+(?:SCHEMABINDING|NOEXPAND)\b", "", RegexOptions.IgnoreCase);
        body = Regex.Replace(body, @"\s*(?:WITH\s*)?\(\s*NOLOCK\s*\)", "", RegexOptions.IgnoreCase);
        body = Regex.Replace(body, @"\bN'", "'");
        body = Regex.Replace(body, @"\bISNULL\s*\(", "COALESCE(", RegexOptions.IgnoreCase);
        body = Regex.Replace(body, @"\bGETDATE\s*\(\s*\)", "NOW()", RegexOptions.IgnoreCase);
        body = Regex.Replace(body, @"\bTOP\s*\(\s*(\d+)\s*\)", "/* TOP $1 */", RegexOptions.IgnoreCase);
        body = Regex.Replace(body, @"\bTOP\s+(\d+)\b", "/* TOP $1 */", RegexOptions.IgnoreCase);
        body = Regex.Replace(body, @"\bLIKE\b", "ILIKE", RegexOptions.IgnoreCase);
        body = body.Trim().TrimEnd(';');

        var sb = new StringBuilder();
        sb.AppendLine($"-- ─── VIEW: {pgName} ───────────────────────────────");
        sb.AppendLine($"DROP VIEW IF EXISTS public.\"{pgName}\";");
        sb.AppendLine($"CREATE OR REPLACE VIEW public.\"{pgName}\" AS");
        sb.AppendLine(body);
        sb.AppendLine(";");
        sb.Append($"-- TODO: Owner mapping skipped. Target role {owner} not verified.");
        return sb.ToString();
    }

    static List<string> ConvertParams(string rawParams, bool forProcedure = false)
    {
        var result = new List<string>();
        if (string.IsNullOrWhiteSpace(rawParams)) return result;
        rawParams = rawParams.Trim();
        if (rawParams.StartsWith('(') && rawParams.EndsWith(')'))
            rawParams = rawParams[1..^1].Trim();
        // P1b: remove single-line comments before parsing so they don't corrupt parameter names
        rawParams = Regex.Replace(rawParams, @"--[^\n]*", "");
        foreach (var part in SplitParams(rawParams))
        {
            var p = part.Trim().TrimStart('﻿');
            if (string.IsNullOrWhiteSpace(p)) continue;
            var isOutput = Regex.IsMatch(p, @"\bOUTPUT\b|\bOUT\b", RegexOptions.IgnoreCase);
            p = Regex.Replace(p, @"\bOUTPUT\b|\bOUT\b|\bREADONLY\b", "", RegexOptions.IgnoreCase).Trim();
            p = Regex.Replace(p, @"^\s*@", "");
            var m = Regex.Match(p, @"^(\w+)\s+([A-Za-z_][^\s=(]*)(\s*\(\s*[^\)]+\))?\s*(?:=\s*(.+))?$");
            if (!m.Success) { result.Add("-- UNPARSED: " + p); continue; }
            var name   = m.Groups[1].Value.ToLower();
            var msBase = m.Groups[2].Value.Trim();
            var msSz   = m.Groups[3].Value.Trim();
            var def    = m.Groups[4].Success ? m.Groups[4].Value.Trim() : null;
            var pgType = MapType(msBase + msSz);
            var defStr = def != null ? $" DEFAULT {MapDefault(def, pgType)}" : "";
            var mode   = forProcedure ? (isOutput ? "INOUT " : "IN ") : "";
            result.Add($"{mode}{QuoteIfReserved(name)} {pgType}{defStr}");
        }
        return result;
    }

    static string GetDropTypes(List<string> pgParams) =>
        string.Join(", ", pgParams
            .Where(p => !p.StartsWith("--"))
            .Select(p => Regex.Replace(
                Regex.Replace(p.Trim(), @"^(?:IN|OUT|INOUT)\s+\w+\s+|^\w+\s+", "", RegexOptions.IgnoreCase),
                @"\s+DEFAULT\b.*$", "", RegexOptions.IgnoreCase).Trim()));

    public static string MapType(string ms)
    {
        var uBase = Regex.Replace(ms.Trim().ToUpper(), @"\s*\([^)]*\)", "").Trim();
        return uBase switch {
            "INT" or "INTEGER"                                  => "integer",
            "BIGINT"                                            => "bigint",
            "SMALLINT" or "TINYINT"                             => "smallint",
            "BIT"                                               => "boolean",
            "FLOAT" or "REAL"                                   => "double precision",
            "DECIMAL" or "NUMERIC"                              => "numeric",
            "MONEY" or "SMALLMONEY"                             => "numeric(19,4)",
            "DATETIME" or "DATETIME2" or "SMALLDATETIME"        => "timestamp without time zone",
            "DATETIMEOFFSET"                                    => "timestamp with time zone",
            "DATE"                                              => "date",
            "TIME"                                              => "time without time zone",
            "UNIQUEIDENTIFIER"                                  => "uuid",
            "XML"                                               => "xml",
            "IMAGE" or "VARBINARY"                              => "bytea",
            "SYSNAME"                                           => "character varying(128)",
            _ when uBase.StartsWith("NVARCHAR") || uBase.StartsWith("VARCHAR")
                   || uBase.StartsWith("NCHAR") || uBase.StartsWith("CHAR") => "character varying",
            _ when uBase.StartsWith("NTEXT") || uBase.StartsWith("TEXT")    => "text",
            _                                                   => ms.ToLower().Trim()
        };
    }

    static string MapDefault(string def, string pgType)
    {
        def = def.Trim().TrimEnd(',', ')');
        if (def.StartsWith("N'") && def.EndsWith("'")) def = "'" + def[2..^1] + "'";
        if (def.Equals("NULL", StringComparison.OrdinalIgnoreCase)) return "NULL";
        if (def == "''" && pgType is not "text" and not "character varying" and not "character")
            return "NULL";
        if (def == "0") return pgType == "boolean" ? "FALSE" : "0";
        if (def == "1") return pgType == "boolean" ? "TRUE" : "1";
        if (def.StartsWith("'") && def.EndsWith("'")) return def;
        // P2: translate GETDATE()/GETUTCDATE() → PostgreSQL current_date/current_timestamp
        if (Regex.IsMatch(def, @"^GETDATE\s*(?:\(\s*\))?$", RegexOptions.IgnoreCase)) return "CURRENT_DATE";
        if (Regex.IsMatch(def, @"^GETUTCDATE\s*(?:\(\s*\))?$", RegexOptions.IgnoreCase)) return "CURRENT_TIMESTAMP";
        if (Regex.IsMatch(def, @"^[A-Za-z_]\w*$")) return $"'{def}'";
        return def;
    }

    // Convert MSSQL DEFAULT expression (from sys.default_constraints.definition) to PostgreSQL
    static string? ConvertDefaultExpression(string? rawDef, string pgType)
    {
        if (string.IsNullOrWhiteSpace(rawDef)) return null;
        // Strip outer parens: ((0)) → 0, (N'') → N''
        var def = rawDef.Trim();
        while (def.StartsWith("(") && def.EndsWith(")"))
            def = def[1..^1].Trim();
        if (string.IsNullOrWhiteSpace(def) || def.Equals("NULL", StringComparison.OrdinalIgnoreCase))
            return null;
        if (Regex.IsMatch(def, @"^\bGETDATE\s*\(\s*\)$", RegexOptions.IgnoreCase)) return "now()";
        if (Regex.IsMatch(def, @"^\bSYSDATETIME\s*\(\s*\)$|\bGETUTCDATE\s*\(\s*\)$", RegexOptions.IgnoreCase)) return "now()";
        if (Regex.IsMatch(def, @"^\bNEWID\s*\(\s*\)$", RegexOptions.IgnoreCase)) return null; // needs uuid-ossp, skip
        if (def.StartsWith("N'") && def.EndsWith("'")) return "'" + def[2..^1] + "'";
        if (def.StartsWith("'") && def.EndsWith("'")) return def;
        if (def == "0") return pgType == "boolean" ? "false" : "0";
        if (def == "1") return pgType == "boolean" ? "true" : "1";
        // Numeric literal
        if (Regex.IsMatch(def, @"^-?\d+(\.\d+)?$")) return def;
        // Fallback: return as-is (may still fail; better than nothing)
        return def.ToLower();
    }

    static string ConvertBody(string body, string fnName)
    {
        // P1a: normalize Windows line endings so all regex patterns see only \n
        body = body.Replace("\r\n", "\n").Replace("\r", "\n");
        // Trim trailing whitespaces at the end of lines to prevent shielding semicolon lookbehinds
        body = Regex.Replace(body, @"[ \t]+(?=\n)", "");
        // P3: remove ORDER BY that appears before UNION (ORDER BY inside a UNION sub-select is
        //     invalid in PostgreSQL; the ORDER BY must come after the last UNION member)
        // Multi-line case: ORDER BY on its own line(s) before UNION
        body = Regex.Replace(body,
            @"(?im)^[ \t]*ORDER\s+BY\s+[^\n]+(\n[ \t]*)*(?=[ \t]*UNION\b)",
            "");
        // Single-line case: ORDER BY embedded inline before UNION on the same line
        body = Regex.Replace(body,
            @"\bORDER\s+BY\s+(?:[^;()\n])+?(?=\s+UNION\b)",
            "", RegexOptions.IgnoreCase);
        // Strip SQL Server transaction control — PostgreSQL wraps the whole function in an implicit transaction
        body = Regex.Replace(body, @"(?m)^[ \t]*BEGIN\s+TRAN(?:SACTION)?(?:\s+\w+)?[ \t]*;?[ \t]*(?:--.*)?$", "", RegexOptions.IgnoreCase);
        body = Regex.Replace(body, @"(?m)^[ \t]*COMMIT\s+TRAN(?:SACTION)?(?:\s+\w+)?[ \t]*;?[ \t]*(?:--.*)?$", "", RegexOptions.IgnoreCase);
        body = Regex.Replace(body, @"(?m)^[ \t]*ROLLBACK\s+TRAN(?:SACTION)?(?:\s+\w+)?[ \t]*;?[ \t]*(?:--.*)?$", "", RegexOptions.IgnoreCase);
        body = Regex.Replace(body, @"(?m)^[ \t]*SAVE\s+TRAN(?:SACTION)?(?:\s+\w+)?[ \t]*;?[ \t]*(?:--.*)?$", "", RegexOptions.IgnoreCase);
        // Remove MSSQL session settings
        body = Regex.Replace(body, @"(?m)^[ \t]*SET\s+NOCOUNT\s+ON\s*;?[ \t]*$", "", RegexOptions.IgnoreCase);
        // Inject semicolon to DROP TABLE if missing (supporting IF EXISTS)
        body = Regex.Replace(body,
            @"(?i)\bDROP\s+TABLE\s+(?:IF\s+EXISTS\s+(\w+)|\b(?!IF\s+EXISTS\b)(\w+))\b(?!\s*;)",
            m => {
                var tbl = m.Groups[1].Success ? m.Groups[1].Value : m.Groups[2].Value;
                var ifExists = m.Groups[1].Success ? "IF EXISTS " : "";
                return $"DROP TABLE {ifExists}{tbl};";
            }, RegexOptions.IgnoreCase);
        // Fix ;WITH CTE
        body = Regex.Replace(body, @"(?m)^(\s*);(WITH\b)", "$1$2", RegexOptions.IgnoreCase);
        // Remove remaining DECLARE lines
        body = Regex.Replace(body, @"(?m)^[ \t]*DECLARE\s+@?\w+[^\r\n]*\r?$", "", RegexOptions.IgnoreCase);
        // Remove @ from variable references
        body = Regex.Replace(body, @"@(\w+)", "$1");
        // Remove [dbo]. and brackets
        body = Regex.Replace(body, @"\[dbo\]\.", "");
        body = Regex.Replace(body, @"\[(\w+)\]", "$1");

        // Function mappings
        body = Regex.Replace(body, @"\bISNULL\s*\(", "COALESCE(", RegexOptions.IgnoreCase);
        body = Regex.Replace(body, @"\bGETDATE\s*\(\s*\)", "NOW()", RegexOptions.IgnoreCase);
        body = Regex.Replace(body, @"\bSCOPE_IDENTITY\s*\(\s*\)", "lastval()", RegexOptions.IgnoreCase);
        // @@ROWCOUNT → _rowcount
        body = Regex.Replace(body, @"@@ROWCOUNT\b", "_rowcount", RegexOptions.IgnoreCase);
        body = Regex.Replace(body,
            @"(?m)^([ \t]*)((?!GET DIAGNOSTICS).*\b_rowcount\b.*)$",
            "$1GET DIAGNOSTICS _rowcount = ROW_COUNT;\n$1$2",
            RegexOptions.IgnoreCase);
        // @@ERROR
        body = Regex.Replace(body,
            @"(?m)^[ \t]*IF\s+@@ERROR\s*(?:<>|!=)\s*0\b[^\r\n]*\r?\n?",
            "", RegexOptions.IgnoreCase);
        body = Regex.Replace(body, @"@@ERROR\b",    "0", RegexOptions.IgnoreCase);
        body = Regex.Replace(body, @"@ERROR\b",     "0", RegexOptions.IgnoreCase);
        body = Regex.Replace(body, @"@@IDENTITY\b", "lastval()", RegexOptions.IgnoreCase);

        // TOP N → LIMIT N: single-line SELECT TOP → move TOP value to LIMIT at end
        // \s* (not \s+) so TOP(1)* (no space before *) also matches
        body = Regex.Replace(body,
            @"(?im)^([ \t]*(?:RETURN\s+QUERY\s+)?SELECT\s+)TOP\s*\(?\s*(\d+)\s*\)?\s*([^\n]+?)(\s*;?)[ \t]*$",
            "$1$3 LIMIT $2$4");
        // Any remaining TOP (multi-line context) → comment placeholder
        body = Regex.Replace(body, @"\bTOP\s*\(?\s*(\d+)\s*\)?\s*", "/* TOP $1 */ ", RegexOptions.IgnoreCase);

        // Quote reserved word identifiers when used as table names in DML
        body = Regex.Replace(body,
            @"\b(UPDATE|DELETE\s+FROM|INSERT\s+INTO)\s+(\w+)(?=\s)",
            m => {
                var kw  = m.Groups[1].Value;
                var tbl = m.Groups[2].Value;
                return PgReservedWords.Contains(tbl)
                    ? $"{kw} public.\"{tbl}\""
                    : $"{kw} {tbl}";
            }, RegexOptions.IgnoreCase);

        // Strip table alias prefix from UPDATE SET left-hand sides.
        // T-SQL allows UPDATE t SET t.col = val; PostgreSQL only accepts SET col = val.
        // First assignment (after SET keyword):
        body = Regex.Replace(body, @"\bSET\s+(\w+)\.(\w+)(\s*=)(?![=>])", "SET $2$3", RegexOptions.IgnoreCase);
        // Subsequent assignments (after top-level commas — right-side subqueries use parens so are depth>0):
        body = Regex.Replace(body, @"(,\s*)(\w+)\.(\w+)(\s*=)(?![=>])", "$1$3$4", RegexOptions.IgnoreCase);
        body = Regex.Replace(body, @"\bTOP\s+(\d+)\b", "/* TOP $1 */", RegexOptions.IgnoreCase);

        // String literals
        body = Regex.Replace(body, @"\bN'", "'");

        // Remove NOLOCK hints
        body = Regex.Replace(body, @"\s*(?:WITH\s*)?\(\s*NOLOCK\s*\)", "", RegexOptions.IgnoreCase);

        // VARCHAR(MAX) → text
        body = Regex.Replace(body, @"\bAS\s+N?(?:VARCHAR|CHAR|NCHAR)\s*\(\s*MAX\s*\)", "AS text", RegexOptions.IgnoreCase);
        body = Regex.Replace(body, @"\bN?(?:VARCHAR|CHAR|NCHAR)\s*\(\s*MAX\s*\)", "text", RegexOptions.IgnoreCase);

        // Boolean column = 1/0
        body = Regex.Replace(body,
            @"\b(Is\w+|Enabled|IsActive|IsUse|IsDel|IsLock)\s*=\s*1\b",
            "$1 = TRUE", RegexOptions.IgnoreCase);
        body = Regex.Replace(body,
            @"\b(Is\w+|Enabled|IsActive|IsUse|IsDel|IsLock)\s*=\s*0\b",
            "$1 = FALSE", RegexOptions.IgnoreCase);
        body = Regex.Replace(body, @"=\s*'TRUE'",  "= TRUE",  RegexOptions.IgnoreCase);
        body = Regex.Replace(body, @"=\s*'FALSE'", "= FALSE", RegexOptions.IgnoreCase);
        body = Regex.Replace(body, @"CAST\s*\(\s*1\s+AS\s+BIT\s*\)", "TRUE",  RegexOptions.IgnoreCase);
        body = Regex.Replace(body, @"CAST\s*\(\s*0\s+AS\s+BIT\s*\)", "FALSE", RegexOptions.IgnoreCase);
        body = Regex.Replace(body, @"CONVERT\s*\(\s*BIT\s*,\s*1\s*\)", "TRUE",  RegexOptions.IgnoreCase);
        body = Regex.Replace(body, @"CONVERT\s*\(\s*BIT\s*,\s*0\s*\)", "FALSE", RegexOptions.IgnoreCase);

        // CAST/CONVERT
        body = Regex.Replace(body, @"CAST\s*\(\s*'([^']+)'\s+AS\s+DATETIME\s*\)", "'$1'::timestamp", RegexOptions.IgnoreCase);
        if (fnName.StartsWith("contact_", StringComparison.OrdinalIgnoreCase) ||
            fnName.StartsWith("contacts_", StringComparison.OrdinalIgnoreCase))
            body = Regex.Replace(body,
                @"CONVERT\s*\(\s*N?(?:VAR)?CHAR\s*(?:\(\s*\d+\s*\))?\s*,\s*([^)]+)\)",
                "CAST($1 AS text)", RegexOptions.IgnoreCase);
        body = Regex.Replace(body,
            @"(\bCAST\s*\([^)]*?\s+AS\s+)N?(?:VAR)?CHAR\s*\(\s*(?:MAX|\d+)\s*\)(\s*\))",
            "$1text$2", RegexOptions.IgnoreCase);
        body = Regex.Replace(body, @"CONVERT\s*\(\s*[N]?VARCHAR\s*,\s*([^,]+),\s*120\s*\)",
            "TO_CHAR($1, 'YYYY-MM-DD HH24:MI:SS')", RegexOptions.IgnoreCase);

        // INSERT ... OUTPUT inserted.col VALUES ... → INSERT ... VALUES ... RETURNING col
        body = Regex.Replace(body,
            @"\bINSERT\s+INTO\s+(\w+)\s*(\([^)]+\))\s+OUTPUT\s+inserted\.(\w+)\s+(VALUES\s*\([^)]+\))",
            "INSERT INTO $1 $2 $4 RETURNING $3",
            RegexOptions.IgnoreCase);
        // Generic OUTPUT inserted.* → RETURNING (catches other forms)
        body = Regex.Replace(body,
            @"\bOUTPUT\s+inserted\.(\w+)\b",
            "RETURNING $1",
            RegexOptions.IgnoreCase);

        // WITH cte AS (... UNION ALL ... FROM cte ...) → WITH RECURSIVE
        body = Regex.Replace(body,
            @"\bWITH\s+(\w+)\s+AS\s*\(",
            m => {
                var cteName = m.Groups[1].Value;
                // Find the CTE body to check for self-reference (scan ahead in body)
                var afterParen = body.Substring(body.IndexOf(m.Value, StringComparison.OrdinalIgnoreCase)
                    + m.Value.Length);
                if (Regex.IsMatch(afterParen, $@"\bFROM\s+{Regex.Escape(cteName)}\b", RegexOptions.IgnoreCase))
                    return $"WITH RECURSIVE {cteName} AS (";
                return m.Value;
            }, RegexOptions.IgnoreCase);

        // DML fixes
        body = Regex.Replace(body, @"\bDELETE\s+(?!FROM\b)(@?\w+)", "DELETE FROM $1", RegexOptions.IgnoreCase);
        body = Regex.Replace(body, @"\bINSERT\s+(?!INTO\b)(@?\w+)", "INSERT INTO $1", RegexOptions.IgnoreCase);
        // Add ; at statement boundaries when the preceding SQL line has none.
        // Spans blank lines so VALUES (...)\n\n\nvar := ... gets semicolon added.
        // Negative lookbehind (?<!;) prevents double semicolons.
        // Negative lookbehind (?<!\*/) prevents adding ; after block-comment closing */ lines.
        body = Regex.Replace(body,
            @"([^\n]*?[^\s;,\(\r\n])(?<!\*/)(?<!;)((?:\n[ \t]*)+)([ \t]*(?:INSERT\s+INTO|DELETE\s+FROM|UPDATE\s+\w|\w+\s*:=\s|RETURN\s+QUERY\b|END\s+IF\b|END\s+LOOP\b|RAISE\b))",
            m => m.Groups[1].Value + ";" + m.Groups[2].Value + m.Groups[3].Value,
            RegexOptions.IgnoreCase);
        // Inject semicolon before SELECT ... INTO statements
        body = Regex.Replace(body,
            @"([^\n]*?[^\s;,\(\r\n])(?<!\*/)(?<!;)((?:\n[ \t]*)+)([ \t]*SELECT\s+(?:(?!\bUNION\b|\bCREATE\b|\bINSERT\b|\bUPDATE\b|\bDELETE\b|\bWHILE\b|\bLOOP\b|\bIF\b)[^;])*?\bINTO\b)",
            m => m.Groups[1].Value + ";" + m.Groups[2].Value + m.Groups[3].Value,
            RegexOptions.IgnoreCase);
        // Close common multi-line DML tails before a PL/pgSQL/result boundary.
        body = Regex.Replace(body,
            @"(?m)^([ \t]*(?:VALUES\b|WHERE\b|DELETE\s+FROM\b|UPDATE\b|INSERT\s+INTO\b|SELECT\b).+?)(?<![;,])((?:\r?\n[ \t]*)+)(?=[ \t]*(?:\w+\s*:=|RETURN\s+QUERY\b|END\s+IF\b|END\s+LOOP\b|RAISE\b))",
            "$1;$2",
            RegexOptions.IgnoreCase);
        // Strip spurious ; that the DML rule may have appended to control-flow keywords
        body = Regex.Replace(body, @"(?m)\bTHEN\s*;[ \t]*$",  "THEN",  RegexOptions.IgnoreCase);
        body = Regex.Replace(body, @"(?m)\bELSE\s*;[ \t]*$",  "ELSE",  RegexOptions.IgnoreCase);
        body = Regex.Replace(body, @"(?m)\bBEGIN\s*;[ \t]*$", "BEGIN", RegexOptions.IgnoreCase);
        body = Regex.Replace(body, @"(?m)\bLOOP\s*;[ \t]*$",  "LOOP",  RegexOptions.IgnoreCase);

        // Misc
        body = Regex.Replace(body,
            @"(?m)^([ \t]*)PRINT\s*\((.+)\)\s*;?\s*$",
            "$1RAISE NOTICE '%', $2;", RegexOptions.IgnoreCase);
        body = Regex.Replace(body, @"(?m)^([ \t]*)PRINT\s+", "$1RAISE NOTICE '%', ", RegexOptions.IgnoreCase);
        body = Regex.Replace(body,
            @"\bCHARINDEX\s*\(\s*','\s*,\s*([^)]+)\)",
            "STRPOS($1, ',')", RegexOptions.IgnoreCase);
        body = Regex.Replace(body, @"\bCHARINDEX\s*\(\s*([^,]+),\s*([^)]+)\)", "STRPOS($2, $1)", RegexOptions.IgnoreCase);
        body = Regex.Replace(body, @"\bAS\s+'([^']+)'", @"AS ""$1""", RegexOptions.IgnoreCase);
        body = Regex.Replace(body, @"\s*OPTION\s*\([^)]+\)\s*;?", ";", RegexOptions.IgnoreCase);
        body = Regex.Replace(body, @"\bDATEDIFF\s*\(\s*day\s*,\s*([^,]+),\s*([^)]+)\)",
            "($2::date - $1::date)", RegexOptions.IgnoreCase);

        // String concat
        body = Regex.Replace(body, @"'([^']*)'\s*\+\s*(\w+)", "'$1' || $2");
        body = Regex.Replace(body, @"(\w+)\s*\+\s*'([^']*)'", "$1 || '$2'");
        if (fnName.StartsWith("contact_", StringComparison.OrdinalIgnoreCase) ||
            fnName.StartsWith("contacts_", StringComparison.OrdinalIgnoreCase))
        {
            body = Regex.Replace(body, @"\+\s*(?='(?:[^']|'')*')", "|| ");
            body = Regex.Replace(body, @"('(?:[^']|'')*')\s*\+", "$1 ||");
        }

        // ParseJson
        body = Regex.Replace(body,
            @"\(SELECT\s+StringValue\s+FROM\s+ParseJson\s*\((\w+)\)\s+WHERE\s+NAME\s*=\s*'(\w+)'[^)]*\)",
            "$1::json->>'$2'", RegexOptions.IgnoreCase);

        // LIKE → ILIKE
        body = Regex.Replace(body, @"\bLIKE\b", "ILIKE", RegexOptions.IgnoreCase);

        // fn_split_array
        body = Regex.Replace(body,
            @"(?:dbo\.)?fn_split_array\s*\(\s*(\w+)\s*,\s*','\s*\)",
            "string_to_array($1, ',')::integer[]", RegexOptions.IgnoreCase);

        if (fnName.StartsWith("board_", StringComparison.OrdinalIgnoreCase) ||
            fnName.StartsWith("contact_", StringComparison.OrdinalIgnoreCase) ||
            fnName.StartsWith("contacts_", StringComparison.OrdinalIgnoreCase))
        {
            body = NormalizeBoardBlockTerminators(body);
            body = NormalizeBoardStatementBoundaries(body);
            body = RepairBoardCteBoundaries(body);
        }

        return body;
    }

    enum BoardBlockKind { If, Loop, Plain }

    static string NormalizeBoardBlockTerminators(string body)
    {
        var lines = body.Split('\n').ToList();
        var stack = new Stack<BoardBlockKind>();
        int sqlCaseDepth = 0;

        for (int i = 0; i < lines.Count; i++)
        {
            string trimmed = lines[i].Trim();
            string sqlCode = StripLineComment(lines[i]);
            bool insideSqlCase = sqlCaseDepth > 0;
            int caseStarts = Regex.Matches(sqlCode, @"\bCASE\b",
                RegexOptions.IgnoreCase).Count;
            int caseEnds = Regex.Matches(sqlCode, @"\bEND\b(?!\s+IF\b|\s+LOOP\b)",
                RegexOptions.IgnoreCase).Count;
            sqlCaseDepth = Math.Max(0, sqlCaseDepth + caseStarts - caseEnds);
            if (insideSqlCase ||
                (caseStarts > caseEnds &&
                 !Regex.IsMatch(trimmed, @"^IF\b", RegexOptions.IgnoreCase)))
                continue;

            if (Regex.IsMatch(trimmed, @"^IF\b.*\bTHEN\s*$", RegexOptions.IgnoreCase))
            {
                stack.Push(BoardBlockKind.If);
                continue;
            }
            if (Regex.IsMatch(trimmed, @"^(?:WHILE\b.*\bLOOP|FOR\b.*\bLOOP|LOOP)\s*;?$",
                RegexOptions.IgnoreCase))
            {
                stack.Push(BoardBlockKind.Loop);
                continue;
            }
            if (Regex.IsMatch(trimmed, @"^BEGIN\s*;?$", RegexOptions.IgnoreCase))
            {
                stack.Push(BoardBlockKind.Plain);
                continue;
            }
            if (Regex.IsMatch(trimmed, @"^END\s+IF\s*;?$", RegexOptions.IgnoreCase))
            {
                PopThrough(stack, BoardBlockKind.If);
                lines[i] = PreserveIndent(lines[i], "END IF;");
                continue;
            }
            if (Regex.IsMatch(trimmed, @"^END\s+LOOP\s*;?$", RegexOptions.IgnoreCase))
            {
                PopThrough(stack, BoardBlockKind.Loop);
                lines[i] = PreserveIndent(lines[i], "END LOOP;");
                continue;
            }
            if (Regex.IsMatch(trimmed, @"^END\s*;?$", RegexOptions.IgnoreCase))
            {
                if (stack.Count == 0)
                {
                    lines[i] = "";
                    continue;
                }

                BoardBlockKind block = stack.Pop();
                lines[i] = PreserveIndent(lines[i], block switch
                {
                    BoardBlockKind.If => "END IF;",
                    BoardBlockKind.Loop => "END LOOP;",
                    _ => "END;"
                });
            }
        }

        while (stack.Count > 0)
        {
            BoardBlockKind block = stack.Pop();
            if (block == BoardBlockKind.If) lines.Add("END IF;");
            else if (block == BoardBlockKind.Loop) lines.Add("END LOOP;");
            else if (block == BoardBlockKind.Plain) lines.Add("END;");
        }
        return string.Join('\n', lines);
    }

    static void PopThrough(Stack<BoardBlockKind> stack, BoardBlockKind target)
    {
        while (stack.Count > 0)
        {
            if (stack.Pop() == target) return;
        }
    }

    static string PreserveIndent(string original, string replacement)
    {
        int length = original.Length - original.TrimStart().Length;
        return original[..length] + replacement;
    }

    static string NormalizeBoardStatementBoundaries(string body)
    {
        var source = body.Split('\n');
        var result = new List<string>(source.Length);
        int sqlCaseDepth = 0;

        foreach (var rawLine in source)
        {
            string line = rawLine.TrimEnd('\r');
            string trimmed = line.Trim();
            string codeForCase = StripLineComment(line);
            bool insideSqlCase = sqlCaseDepth > 0;
            int caseStarts = Regex.Matches(codeForCase, @"\bCASE\b",
                RegexOptions.IgnoreCase).Count;
            int caseEnds = Regex.Matches(codeForCase, @"\bEND\b(?!\s+IF\b|\s+LOOP\b)",
                RegexOptions.IgnoreCase).Count;
            sqlCaseDepth = Math.Max(0, sqlCaseDepth + caseStarts - caseEnds);

            // A semicolon is a terminator, not a standalone PL/pgSQL statement.
            if (trimmed == ";") continue;

            if (Regex.IsMatch(trimmed, @"^BEGIN\s*;$", RegexOptions.IgnoreCase))
                line = Regex.Replace(line, @";[ \t]*$", "");
            else if (Regex.IsMatch(trimmed, @"^END\s+LOOP\s*$", RegexOptions.IgnoreCase))
                line = line.TrimEnd() + ";";

            trimmed = line.Trim();
            bool startsBoundary = Regex.IsMatch(trimmed,
                @"^(?:IF\b|ELSIF\b|ELSE\b|END\s+IF\b|END\s+LOOP\b|WHILE\b|" +
                @"RETURN\s+QUERY\b|RETURN\b|INSERT\s+INTO\b|UPDATE\b|DELETE\s+FROM\b|" +
                @"CREATE\s+TEMP(?:ORARY)?\s+TABLE\b|DROP\s+TABLE\b|EXECUTE\b|PERFORM\b|" +
                @"RAISE\b|\w+\s*:=)",
                RegexOptions.IgnoreCase);
            if (insideSqlCase && Regex.IsMatch(trimmed, @"^ELSE\b", RegexOptions.IgnoreCase))
                startsBoundary = false;

            bool startsResultSelect = Regex.IsMatch(trimmed, @"^SELECT\b",
                RegexOptions.IgnoreCase);

            if ((startsBoundary || startsResultSelect) &&
                TryFindPreviousCodeLine(result, out int previousIndex, out string previousCode))
            {
                bool selectNeedsBoundary = startsResultSelect &&
                    Regex.IsMatch(previousCode,
                        @"^(?:VALUES\b|UPDATE\b|DELETE\s+FROM\b|SELECT\b.*\bINTO\b)",
                        RegexOptions.IgnoreCase);

                if ((!startsResultSelect || selectNeedsBoundary) &&
                    BoardLineNeedsTerminator(previousCode))
                    result[previousIndex] = AddTerminatorBeforeComment(result[previousIndex]);
            }

            // A standalone SELECT may end with an inline comment. Put the
            // terminator before -- so END/RETURN QUERY is not swallowed.
            if (Regex.IsMatch(trimmed, @"^(?:END\b|RETURN\s+QUERY\b)", RegexOptions.IgnoreCase) &&
                TryFindPreviousCodeLine(result, out int commentIndex, out string commentCode) &&
                result[commentIndex].Contains("--", StringComparison.Ordinal) &&
                BoardLineNeedsTerminator(commentCode))
                result[commentIndex] = AddTerminatorBeforeComment(result[commentIndex]);

            // Split boundary tokens that were merged after a valid terminator.
            line = Regex.Replace(line,
                @";[ \t]*(?=(?:END\s+IF|END\s+LOOP|IF|WHILE|RETURN\s+QUERY|EXECUTE|PERFORM)\b)",
                ";\n", RegexOptions.IgnoreCase);
            result.Add(line);
        }

        return string.Join('\n', result);
    }

    static string RepairBoardCteBoundaries(string body)
    {
        var lines = body.Split('\n').ToList();
        for (int boundary = 0; boundary < lines.Count; boundary++)
        {
            string boundaryCode = StripLineComment(lines[boundary]).Trim();
            bool isReturnQuery = Regex.IsMatch(boundaryCode, @"^RETURN\s+QUERY\s*;?$",
                RegexOptions.IgnoreCase);
            bool isDml = Regex.IsMatch(boundaryCode,
                @"^(?:INSERT\s+INTO|UPDATE\b|DELETE\s+FROM\b)", RegexOptions.IgnoreCase);
            if (!isReturnQuery && !isDml) continue;

            int close = boundary - 1;
            while (close >= 0)
            {
                string candidate = lines[close].TrimStart();
                if (!string.IsNullOrWhiteSpace(lines[close]) &&
                    !candidate.StartsWith("--", StringComparison.Ordinal))
                    break;
                close--;
            }
            if (close < 0 ||
                !Regex.IsMatch(StripLineComment(lines[close]).Trim(), @"\)\s*;?$"))
                continue;

            int cteStart = FindBoardCteStart(lines, close);
            if (cteStart < 0) continue;

            lines[close] = Regex.Replace(lines[close], @";[ \t]*$", "");
            if (!isReturnQuery) continue;

            bool materializesTempTable = Regex.IsMatch(
                StripLineComment(lines[cteStart]).Trim(),
                @"^CREATE\s+TEMP(?:ORARY)?\s+TABLE\b.*\bAS\s+WITH(?:\s+RECURSIVE)?\b",
                RegexOptions.IgnoreCase);
            if (materializesTempTable)
            {
                // The SELECT after the CTE belongs to CREATE TEMP TABLE ... AS,
                // not to the function result stream.
                lines.RemoveAt(boundary);
                boundary--;
            }
            else
            {
                // PL/pgSQL requires RETURN QUERY before the complete WITH query.
                string returnLine = lines[boundary];
                lines.RemoveAt(boundary);
                lines.Insert(cteStart, returnLine);
            }
        }
        return string.Join('\n', lines);
    }

    static int FindBoardCteStart(List<string> lines, int closeLine)
    {
        for (int i = closeLine; i >= 0; i--)
        {
            string code = StripLineComment(lines[i]).Trim();
            if (code.Length == 0) continue;
            if (Regex.IsMatch(code,
                @"^(?:CREATE\s+TEMP(?:ORARY)?\s+TABLE\b.*\bAS\s+)?WITH(?:\s+RECURSIVE)?\b",
                RegexOptions.IgnoreCase))
                return i;
            if (i != closeLine && code.EndsWith(";") &&
                !Regex.IsMatch(code, @"^\)\s*;$"))
                return -1;
        }
        return -1;
    }

    static bool TryFindPreviousCodeLine(List<string> lines, out int index, out string code)
    {
        for (int i = lines.Count - 1; i >= 0; i--)
        {
            string candidate = StripLineComment(lines[i]).Trim();
            if (candidate.Length == 0 || candidate.StartsWith("/*") || candidate.StartsWith("*"))
                continue;
            index = i;
            code = candidate;
            return true;
        }
        index = -1;
        code = "";
        return false;
    }

    static bool BoardLineNeedsTerminator(string code)
    {
        if (code.EndsWith(";") || code.EndsWith(",") || code.EndsWith("(") ||
            code.EndsWith("+") || code.EndsWith("||") || code.EndsWith("*/"))
            return false;
        if (Regex.IsMatch(code,
            @"(?:\bTHEN|\bELSE|\bBEGIN|\bLOOP|\bRETURN\s+QUERY)$",
            RegexOptions.IgnoreCase))
            return false;
        if (Regex.IsMatch(code,
            @"^(?:IF\b|ELSIF\b|ELSE\b|BEGIN\b|WHILE\b|FOR\b|WITH\b)",
            RegexOptions.IgnoreCase))
            return false;
        return true;
    }

    static string AddTerminatorBeforeComment(string line)
    {
        int comment = FindLineCommentStart(line);
        if (comment < 0) return line.TrimEnd() + ";";
        string code = line[..comment].TrimEnd();
        string suffix = line[comment..];
        return code + "; " + suffix;
    }

    static string StripLineComment(string line)
    {
        int comment = FindLineCommentStart(line);
        return comment < 0 ? line : line[..comment];
    }

    static int FindLineCommentStart(string line)
    {
        bool inString = false;
        for (int i = 0; i + 1 < line.Length; i++)
        {
            if (line[i] == '\'')
            {
                if (inString && i + 1 < line.Length && line[i + 1] == '\'') { i++; continue; }
                inString = !inString;
                continue;
            }
            if (!inString && line[i] == '-' && line[i + 1] == '-') return i;
        }
        return -1;
    }

    static string EnsureLastSemicolon(string pgBody)
    {
        var lines = pgBody.Split('\n').ToList();
        for (int i = lines.Count - 1; i >= 0; i--)
        {
            var t = lines[i].TrimEnd();
            if (t.Length == 0 || t.TrimStart().StartsWith("--")) continue;
            int comment = FindLineCommentStart(t);
            var sqlPart = (comment < 0 ? t : t[..comment]).TrimEnd();
            if (sqlPart.Length > 0 && !sqlPart.EndsWith(";") && !sqlPart.EndsWith("*/"))
                lines[i] = comment < 0
                    ? sqlPart + ";"
                    : sqlPart + "; " + t[comment..];
            break;
        }
        return string.Join('\n', lines);
    }

    // ── TABLE FROM CATALOG ────────────────────────────────────────────────────

    static string ConvertTableFromCatalog(string tableName, List<ColumnInfo> columns, string owner)
    {
        var sb = new StringBuilder();
        sb.AppendLine($"-- ─── TABLE: {tableName} ───────────────────────────────────");
        sb.AppendLine($"CREATE TABLE IF NOT EXISTS public.\"{tableName}\" (");

        var pkCols  = columns.Where(c => c.IsPrimaryKey).ToList();
        var colDefs = new List<string>();
        bool hasNewIdDefault = false;

        foreach (var col in columns)
        {
            var pgType   = MapCatalogType(col);
            var nullable = col.IsNullable ? "" : " NOT NULL";

            // DEFAULT value
            string defaultClause = "";
            if (!col.IsIdentity && col.DefaultValue != null)
            {
                if (Regex.IsMatch(col.DefaultValue, @"\bNEWID\s*\(\s*\)", RegexOptions.IgnoreCase))
                {
                    hasNewIdDefault = true;
                    // skip — NEWID not auto-generated; leave TODO
                }
                else
                {
                    var pgDefault = ConvertDefaultExpression(col.DefaultValue, pgType);
                    if (pgDefault != null)
                        defaultClause = $" DEFAULT {pgDefault}";
                }
            }

            var quotedName = QuoteIfReserved(col.Name);
            colDefs.Add($"    {quotedName} {pgType}{nullable}{defaultClause}");
        }

        // Single-column PK: append PRIMARY KEY inline (if not already a serial)
        if (pkCols.Count == 1 && !pkCols[0].IsIdentity)
        {
            var pkQuoted = QuoteIfReserved(pkCols[0].Name);
            var idx = colDefs.FindIndex(c => {
                var t = c.TrimStart();
                return t.StartsWith(pkQuoted + " ") || t.StartsWith(pkQuoted + "\t");
            });
            if (idx >= 0) colDefs[idx] += " PRIMARY KEY";
        }
        else if (pkCols.Count > 1)
        {
            colDefs.Add($"    PRIMARY KEY ({string.Join(", ", pkCols.Select(c => QuoteIfReserved(c.Name)))})");
        }

        if (hasNewIdDefault)
            sb.AppendLine("-- TODO: NEWID() requires manual rewrite or uuid-ossp extension on PostgreSQL 9.3.");
        sb.AppendLine(string.Join(",\n", colDefs));
        sb.AppendLine(");");
        sb.Append($"-- TODO: Owner mapping skipped. Target role {owner} not verified.");
        return sb.ToString();
    }

    static string MapCatalogType(ColumnInfo col)
    {
        var t = col.TypeName.ToLower();

        if (col.IsIdentity)
            return t == "bigint" ? "bigserial" : "serial";

        return t switch {
            "int"                               => "integer",
            "bigint"                            => "bigint",
            "smallint" or "tinyint"             => "smallint",
            "bit"                               => "boolean",
            "datetime" or "datetime2"
                       or "smalldatetime"       => "timestamp without time zone",
            "datetimeoffset"                    => "timestamp with time zone",
            "date"                              => "date",
            "time"                              => "time without time zone",
            "float" or "real"                   => "double precision",
            "money" or "smallmoney"             => "numeric(19,4)",
            "decimal" or "numeric" when col.Precision > 0
                                                => $"numeric({col.Precision},{col.Scale})",
            "decimal" or "numeric"              => "numeric",
            "uniqueidentifier"                  => "uuid",
            "xml"                               => "xml",
            "image" or "varbinary"              => "bytea",
            "text" or "ntext"                   => "text",
            "sysname"                           => "character varying(128)",
            "varchar" or "nvarchar" when col.Size == "MAX"
                                                => "text",
            "varchar" or "nvarchar" when col.Size != null
                                                => $"character varying({col.Size})",
            "varchar" or "nvarchar"             => "character varying",
            "char"    or "nchar"    when col.Size != null
                                                => $"character({col.Size})",
            "char"    or "nchar"                => "character",
            _                                   => t
        };
    }

    static List<string> SplitParams(string s)
    {
        var result = new List<string>();
        var cur = new StringBuilder();
        int depth = 0;
        bool inStr = false;
        for (int i = 0; i < s.Length; i++)
        {
            var c = s[i];
            if (c == '\'' && !inStr) { inStr = true; cur.Append(c); }
            else if (c == '\'' && inStr)
            {
                cur.Append(c);
                if (i + 1 < s.Length && s[i + 1] == '\'') cur.Append(s[++i]);
                else inStr = false;
            }
            else if (!inStr)
            {
                if (c == '(') depth++;
                else if (c == ')') depth--;
                if (c == ',' && depth == 0) { result.Add(cur.ToString()); cur.Clear(); }
                else cur.Append(c);
            }
            else cur.Append(c);
        }
        if (cur.Length > 0) result.Add(cur.ToString());
        return result;
    }

    static string QualifyParams(string body, string fnName, List<string> paramNames)
    {
        if (paramNames.Count == 0) return body;

        var tokenRx = new Regex(@"'(?:[^']|'')*'|--[^\n]*", RegexOptions.Singleline);

        foreach (var name in paramNames)
        {
            var paramRx = new Regex(
                $@"((?:[=!]=?|[<>]=?|<>)\s*)(?<![.\w])({Regex.Escape(name)})(?!\w|\.)",
                RegexOptions.IgnoreCase);

            var sb = new StringBuilder();
            int pos = 0;
            foreach (Match tok in tokenRx.Matches(body))
            {
                sb.Append(paramRx.Replace(body[pos..tok.Index], $"$1{fnName}.{name}"));
                sb.Append(tok.Value);
                pos = tok.Index + tok.Length;
            }
            sb.Append(paramRx.Replace(body[pos..], $"$1{fnName}.{name}"));
            body = sb.ToString();
        }
        return body;
    }
}
