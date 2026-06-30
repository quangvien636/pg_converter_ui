using System.Diagnostics;
using System.Text;
using System.Text.RegularExpressions;

namespace pg_converter_ui;

/// <summary>
/// Converts complex MSSQL body constructs → PL/pgSQL.
/// Call this BEFORE Converter.ConvertBody() (which handles simple token swaps).
/// Handles: IF/ELSE/WHILE, CURSOR→FOR LOOP, #TempTable, SET/SELECT @var assignment.
/// </summary>
public static class BodyConverter
{
    enum BlockKind { If, ElseIf, Else, While, Plain }

    // Thread-static context for logging inside phase methods
    [ThreadStatic] static string? _fnName;
    [ThreadStatic] static string? _phase;

    static readonly TimeSpan RegexTimeout = TimeSpan.FromSeconds(5);

    public static string Convert(string body, string fnName)
    {
        _fnName = fnName;
        var totalSw = Stopwatch.StartNew();
        // Normalize line endings early so all phases work with \n only
        body = body.Replace("\r\n", "\n").Replace("\r", "\n");
        body = Regex.Replace(body, @"[ \t]+(?=\n)", "");
        Logger.Info($"[PHASE] [{fnName}] Enter Convert() inputLen={body.Length}");

        // Board procedures frequently combine TOP with SELECT variable assignment
        // (SELECT TOP 1 @x = col ...). Normalize TOP before the assignment pass;
        // keep every non-Board conversion path unchanged.
        if (fnName.StartsWith("board_", StringComparison.OrdinalIgnoreCase))
        {
            body = TrySafe(body, fnName, "NormalizeBoardTop", NormalizeBoardTop);
            body = TrySafe(body, fnName, "ConvertBoardOuterApply", ConvertBoardOuterApply);
        }

        body = TrySafe(body, fnName, "ConvertTryCatch",   ConvertTryCatch);
        body = TrySafe(body, fnName, "StripBoilerplate",  StripBoilerplate);
        body = TrySafe(body, fnName, "ConvertCursors",    ConvertCursors);
        body = fnName.StartsWith("board_", StringComparison.OrdinalIgnoreCase)
            ? TrySafe(body, fnName, "ConvertBoardTempTables", ConvertBoardTempTables)
            : TrySafe(body, fnName, "ConvertTempTables", ConvertTempTables);
        body = TrySafe(body, fnName, "ConvertExec",       ConvertExec);
        body = TrySafe(body, fnName, "ConvertMerge",      ConvertMerge);
        body = TrySafe(body, fnName, "ConvertOpenQuery",  ConvertOpenQuery);
        body = TrySafe(body, fnName, "ConvertRaiseError", ConvertRaiseError);
        body = TrySafe(body, fnName, "ConvertControlFlow",ConvertControlFlow);
        body = TrySafe(body, fnName, "ConvertAssignments",ConvertAssignments);

        Logger.Info($"[PHASE] [{fnName}] Exit Convert() outputLen={body.Length} totalMs={totalSw.ElapsedMilliseconds}");
        return body;
    }

    static string ConvertBoardOuterApply(string body)
    {
        var output = new StringBuilder(body.Length + 64);
        int position = 0;

        while (position < body.Length)
        {
            var match = Regex.Match(body[position..], @"\bOUTER\s+APPLY\s*\(",
                RegexOptions.IgnoreCase, RegexTimeout);
            if (!match.Success)
            {
                output.Append(body, position, body.Length - position);
                break;
            }

            int start = position + match.Index;
            int openParen = start + match.Value.LastIndexOf('(');
            int closeParen = FindMatchingParen(body, openParen);
            if (closeParen < 0)
            {
                output.Append(body, position, body.Length - position);
                break;
            }

            int aliasStart = closeParen + 1;
            while (aliasStart < body.Length && char.IsWhiteSpace(body[aliasStart])) aliasStart++;
            var aliasMatch = Regex.Match(body[aliasStart..], @"^(?:\[(\w+)\]|(\w+))",
                RegexOptions.IgnoreCase, RegexTimeout);
            if (!aliasMatch.Success)
            {
                output.Append(body, position, closeParen + 1 - position);
                position = closeParen + 1;
                continue;
            }

            int aliasEnd = aliasStart + aliasMatch.Length;
            string alias = aliasMatch.Groups[1].Success
                ? aliasMatch.Groups[1].Value
                : aliasMatch.Groups[2].Value;

            output.Append(body, position, start - position);
            output.Append("LEFT JOIN LATERAL (");
            output.Append(body, openParen + 1, closeParen - openParen - 1);
            output.Append(") ");
            output.Append(alias);
            output.Append(" ON TRUE");
            position = aliasEnd;
        }

        return output.ToString();
    }

    static int FindMatchingParen(string text, int openParen)
    {
        int depth = 0;
        bool inString = false;
        for (int i = openParen; i < text.Length; i++)
        {
            char c = text[i];
            if (inString)
            {
                if (c == '\'' && i + 1 < text.Length && text[i + 1] == '\'') { i++; continue; }
                if (c == '\'') inString = false;
                continue;
            }
            if (c == '\'') { inString = true; continue; }
            if (c == '-' && i + 1 < text.Length && text[i + 1] == '-')
            {
                int newline = text.IndexOf('\n', i + 2);
                if (newline < 0) return -1;
                i = newline;
                continue;
            }
            if (c == '/' && i + 1 < text.Length && text[i + 1] == '*')
            {
                int endComment = text.IndexOf("*/", i + 2, StringComparison.Ordinal);
                if (endComment < 0) return -1;
                i = endComment + 1;
                continue;
            }
            if (c == '(') depth++;
            else if (c == ')' && --depth == 0) return i;
        }
        return -1;
    }

    static string NormalizeBoardTop(string body)
    {
        // PostgreSQL cannot place TOP after SELECT. Removing it preserves a
        // compilable best-effort query; the procedure-level TOP warning remains
        // based on the original SQL and calls out the required LIMIT review.
        body = SafeReplace(body, "TopParenthesized",
            @"(\bSELECT\s+)(?:DISTINCT\s+)?TOP\s*\(\s*[^)]+\s*\)\s+",
            "$1",
            RegexOptions.IgnoreCase);
        body = SafeReplace(body, "TopNumeric",
            @"(\bSELECT\s+)(?:DISTINCT\s+)?TOP\s+\d+\s+",
            "$1",
            RegexOptions.IgnoreCase);
        return body;
    }

    static string TrySafe(string body, string fnName, string step, Func<string, string> transform)
    {
        _phase = step;
        var sw = Stopwatch.StartNew();
        Logger.Info($"[PHASE] [{fnName}] Enter {step} inputLen={body.Length}");
        try
        {
            var result = transform(body);
            Logger.Info($"[PHASE] [{fnName}] Exit {step} outputLen={result.Length} elapsedMs={sw.ElapsedMilliseconds}");
            return result;
        }
        catch (Exception ex)
        {
            Logger.Warn($"[PHASE] [{fnName}] {step} FAILED elapsedMs={sw.ElapsedMilliseconds} — skipping step. {ex.GetType().Name}: {ex.Message}");
            return body;
        }
    }

    // Safe regex replace — logs slow/timeout cases, skips on timeout
    static string SafeReplace(string input, string label, string pattern, string replacement,
        RegexOptions options, TimeSpan? timeout = null)
    {
        var t = timeout ?? RegexTimeout;
        var sw = Stopwatch.StartNew();
        try
        {
            var result = Regex.Replace(input, pattern, replacement, options, t);
            if (sw.ElapsedMilliseconds > 200)
                Logger.Info($"[PHASE] [{_fnName}] {_phase}/{label} elapsedMs={sw.ElapsedMilliseconds} inputLen={input.Length} outputLen={result.Length}");
            return result;
        }
        catch (RegexMatchTimeoutException)
        {
            Logger.Warn($"[TIMEOUT] [{_fnName}] {_phase}/{label} pattern timeout={t.TotalSeconds}s inputLen={input.Length} — skipping replacement");
            return input;
        }
    }

    static string SafeReplace(string input, string label, string pattern, MatchEvaluator evaluator,
        RegexOptions options, TimeSpan? timeout = null)
    {
        var t = timeout ?? RegexTimeout;
        var sw = Stopwatch.StartNew();
        try
        {
            var result = Regex.Replace(input, pattern, evaluator, options, t);
            if (sw.ElapsedMilliseconds > 200)
                Logger.Info($"[PHASE] [{_fnName}] {_phase}/{label} elapsedMs={sw.ElapsedMilliseconds} inputLen={input.Length} outputLen={result.Length}");
            return result;
        }
        catch (RegexMatchTimeoutException)
        {
            Logger.Warn($"[TIMEOUT] [{_fnName}] {_phase}/{label} pattern timeout={t.TotalSeconds}s inputLen={input.Length} — skipping replacement");
            return input;
        }
    }

    // ── Strip MSSQL-only boilerplate ─────────────────────────────────────────

    static string StripBoilerplate(string body)
    {
        body = Regex.Replace(body, @"(?m)^[ \t]*SET\s+NOCOUNT\s+(?:ON|OFF)\s*;?[ \t]*\r?$\n?",           "", RegexOptions.IgnoreCase);
        body = Regex.Replace(body, @"(?m)^[ \t]*SET\s+ANSI_NULLS\s+\w+\s*;?[ \t]*\r?$\n?",              "", RegexOptions.IgnoreCase);
        body = Regex.Replace(body, @"(?m)^[ \t]*SET\s+QUOTED_IDENTIFIER\s+\w+\s*;?[ \t]*\r?$\n?",        "", RegexOptions.IgnoreCase);
        body = Regex.Replace(body, @"(?m)^[ \t]*SET\s+XACT_ABORT\s+\w+\s*;?[ \t]*\r?$\n?",              "", RegexOptions.IgnoreCase);
        body = Regex.Replace(body, @"(?m)^[ \t]*SET\s+IDENTITY_INSERT\s+\S+\s+(?:ON|OFF)\s*;?[ \t]*\r?$\n?", "", RegexOptions.IgnoreCase);
        body = Regex.Replace(body, @"(?m)^[ \t]*SET\s+ROWCOUNT\s+\d+\s*;?[ \t]*\r?$\n?",                "", RegexOptions.IgnoreCase);
        body = Regex.Replace(body, @"(?m)^[ \t]*SET\s+TRANSACTION\s+ISOLATION\s+LEVEL\s+[^\r\n]+\r?$\n?","", RegexOptions.IgnoreCase);
        body = Regex.Replace(body, @"(?m)^[ \t]*SET\s+LOCK_TIMEOUT\s+\d+\s*;?[ \t]*\r?$\n?",            "", RegexOptions.IgnoreCase);
        body = Regex.Replace(body, @"(?m)^[ \t]*SET\s+DATEFORMAT\s+\w+\s*;?[ \t]*\r?$\n?",              "", RegexOptions.IgnoreCase);
        body = Regex.Replace(body, @"(?m)^[ \t]*SET\s+LANGUAGE\s+\w+\s*;?[ \t]*\r?$\n?",                "", RegexOptions.IgnoreCase);
        body = Regex.Replace(body, @"(?m)^[ \t]*SET\s+CONCAT_NULL_YIELDS_NULL\s+\w+\s*;?[ \t]*\r?$\n?",  "", RegexOptions.IgnoreCase);
        body = Regex.Replace(body, @"(?m)^[ \t]*SET\s+ARITHABORT\s+\w+\s*;?[ \t]*\r?$\n?",              "", RegexOptions.IgnoreCase);
        body = Regex.Replace(body, @"(?m)^[ \t]*SET\s+NUMERIC_ROUNDABORT\s+\w+\s*;?[ \t]*\r?$\n?",      "", RegexOptions.IgnoreCase);
        body = Regex.Replace(body, @"(?m)^[ \t]*SET\s+ANSI_PADDING\s+\w+\s*;?[ \t]*\r?$\n?",            "", RegexOptions.IgnoreCase);
        body = Regex.Replace(body, @"(?m)^[ \t]*SET\s+ANSI_WARNINGS\s+\w+\s*;?[ \t]*\r?$\n?",           "", RegexOptions.IgnoreCase);
        body = Regex.Replace(body, @"(?m)^(\s*);(WITH\b)", "$1$2", RegexOptions.IgnoreCase);
        return body;
    }

    // ── CURSOR → FOR _rec IN ... LOOP ────────────────────────────────────────

    static string ConvertCursors(string body)
    {
        // Collect cursor declarations
        var cursors = new List<(string name, string sql)>();
        body = SafeReplace(body, "CursorDecl",
            @"DECLARE\s+@?(\w+)\s+CURSOR\s+(?:(?:LOCAL|GLOBAL|FORWARD_ONLY|SCROLL|STATIC|KEYSET|DYNAMIC|FAST_FORWARD|READ_ONLY|SCROLL_LOCKS|OPTIMISTIC|TYPE_WARNING)\s+)*FOR\s+([\s\S]+?)(?=\s+OPEN\s+@?\1\b)",
            m => {
                cursors.Add((m.Groups[1].Value.ToLower(), m.Groups[2].Value.Trim().TrimEnd(';')));
                return "";
            }, RegexOptions.IgnoreCase, TimeSpan.FromSeconds(10));
        body = SafeReplace(body, "CursorVariableAssignment",
            @"SET\s+@?(\w+)\s*=\s*CURSOR\s+(?:(?:LOCAL|GLOBAL|FORWARD_ONLY|SCROLL|STATIC|KEYSET|DYNAMIC|FAST_FORWARD|READ_ONLY|SCROLL_LOCKS|OPTIMISTIC|TYPE_WARNING)\s+)*FOR\s+([\s\S]+?)(?=\s+OPEN\s+@?\1\b)",
            m => {
                cursors.Add((m.Groups[1].Value.ToLower(), m.Groups[2].Value.Trim().TrimEnd(';')));
                return "";
            }, RegexOptions.IgnoreCase, TimeSpan.FromSeconds(10));

        foreach (var (cur, selectSql) in cursors)
        {
            // Collect FETCH INTO variable names (first occurrence)
            var fetchM = Regex.Match(body,
                $@"FETCH\s+NEXT\s+FROM\s+@?{Regex.Escape(cur)}[ \t]*(?:\r?\n[ \t]*)?INTO[ \t]+([^\r\n;]+)",
                RegexOptions.IgnoreCase, RegexTimeout);
            var intoVars = fetchM.Success
                ? fetchM.Groups[1].Value.Split(',').Select(v => v.Trim().TrimStart('@').ToLower()).ToList()
                : new List<string>();

            // Remove OPEN
            body = Regex.Replace(body, $@"\bOPEN\s+@?{Regex.Escape(cur)}\s*;?\s*\r?\n?", "", RegexOptions.IgnoreCase);
            // Remove ALL FETCH NEXT FROM cursor lines
            body = Regex.Replace(body,
                $@"\bFETCH\s+NEXT\s+FROM\s+@?{Regex.Escape(cur)}[ \t]*(?:\r?\n[ \t]*)?INTO[^\r\n;]*(?:;?[ \t]*\r?\n)?",
                "", RegexOptions.IgnoreCase, RegexTimeout);
            // Replace WHILE @@FETCH_STATUS = 0 / @FETCH_STATUS = 0 with FOR loop
            var loopTarget = intoVars.Count > 0 ? string.Join(", ", intoVars) : "_rec";
            var loopHeader = $"FOR {loopTarget} IN {selectSql} LOOP";
            body = Regex.Replace(body, @"\bWHILE\s+@{1,2}FETCH_STATUS\s*=\s*0\b", loopHeader, RegexOptions.IgnoreCase);
            // Remove CLOSE / DEALLOCATE
            body = Regex.Replace(body, $@"\bCLOSE\s+@?{Regex.Escape(cur)}\s*;?\s*\r?\n?",      "", RegexOptions.IgnoreCase);
            body = Regex.Replace(body, $@"\bDEALLOCATE\s+@?{Regex.Escape(cur)}\s*;?\s*\r?\n?", "", RegexOptions.IgnoreCase);
        }

        return body;
    }

    static List<string> ParseSelectCols(string selectSql)
    {
        // Isolate SELECT list (before FROM)
        var fromM = Regex.Match(selectSql, @"\bFROM\b", RegexOptions.IgnoreCase);
        var list  = fromM.Success ? selectSql[..fromM.Index] : selectSql;
        list = Regex.Replace(list, @"^\s*SELECT\s+(?:TOP\s*\(\d+\)\s*|TOP\s+\d+\s*)?", "", RegexOptions.IgnoreCase).Trim();

        return SplitComma(list).Select(col => {
            col = col.Trim();
            // Use alias if present: expr AS alias
            var am = Regex.Match(col, @"\bAS\s+(\w+)\s*$", RegexOptions.IgnoreCase);
            if (am.Success) return am.Groups[1].Value.ToLower();
            // Otherwise last word (bare column or expression)
            var lm = Regex.Match(col, @"(\w+)\s*$");
            return lm.Success ? lm.Groups[1].Value.ToLower() : "col";
        }).ToList();
    }

    // ── #TempTable → TEMP TABLE ──────────────────────────────────────────────

    static string ConvertTempTables(string body)
    {
        // DECLARE @var TABLE (...) → CREATE TEMP TABLE var (...) ON COMMIT DROP
        // Use FindMatchingParen to handle nested parens (e.g. VARCHAR(50) inside column list)
        int pos = 0;
        while (pos < body.Length)
        {
            var m = Regex.Match(body[pos..], @"\bDECLARE\s+@(\w+)\s+TABLE\s*\(", RegexOptions.IgnoreCase, RegexTimeout);
            if (!m.Success) break;
            int start = pos + m.Index;
            int openP  = start + m.Value.LastIndexOf('(');
            int closeP = FindMatchingParen(body, openP);
            if (closeP < 0) break;
            string varName = m.Groups[1].Value.ToLower();
            string colDefs = body[(openP + 1)..closeP];
            // Map column types
            colDefs = Regex.Replace(colDefs, @"\b(?:TINY|SMALL)?INT(?:EGER)?\b", "integer", RegexOptions.IgnoreCase);
            colDefs = Regex.Replace(colDefs, @"\bBIGINT\b", "bigint", RegexOptions.IgnoreCase);
            colDefs = Regex.Replace(colDefs, @"\bN?VARCHAR\s*\(\s*MAX\s*\)", "text", RegexOptions.IgnoreCase);
            colDefs = Regex.Replace(colDefs, @"\bN?VARCHAR\b", "varchar", RegexOptions.IgnoreCase);
            colDefs = Regex.Replace(colDefs, @"\bDATETIME\b", "timestamp", RegexOptions.IgnoreCase);
            colDefs = Regex.Replace(colDefs, @"\bBIT\b", "boolean", RegexOptions.IgnoreCase);
            colDefs = Regex.Replace(colDefs, @"\bINT\s+IDENTITY(?:\s*\(\s*\d+\s*,\s*\d+\s*\))?", "serial", RegexOptions.IgnoreCase);
            int end = closeP + 1;
            if (end < body.Length && body[end] == ';') end++;
            string replacement = $"CREATE TEMP TABLE {varName} ({colDefs}) ON COMMIT DROP;";
            body = body[..start] + replacement + body[end..];
            pos = start + replacement.Length;
        }

        // CREATE TABLE #tmp (...) → CREATE TEMP TABLE tmp (...)
        body = Regex.Replace(body, @"\bCREATE\s+TABLE\s+#(\w+)", "CREATE TEMP TABLE $1", RegexOptions.IgnoreCase);

        // SELECT cols INTO #tmp FROM ... → CREATE TEMP TABLE tmp AS SELECT cols FROM ...
        body = SafeReplace(body, "SelectIntoTemp",
            @"\bSELECT\s+([\s\S]+?)\s+INTO\s+#(\w+)\s+FROM\b",
            "CREATE TEMP TABLE $2 AS SELECT $1 FROM",
            RegexOptions.IgnoreCase, TimeSpan.FromSeconds(10));

        // All remaining #name references → name
        body = Regex.Replace(body, @"#(\w+)", "$1");

        return body;
    }

    static string ConvertBoardTempTables(string body)
    {
        var tableVariables = new HashSet<string>(StringComparer.OrdinalIgnoreCase);

        // Board table variables need a real relation because later INSERT/UPDATE/JOIN
        // statements reference them. Keep them local to the transaction.
        body = ConvertBoardTableVariableDeclarations(body, tableVariables);

        // CREATE TABLE #tmp (...) keeps its column definition and gains local scope.
        body = Regex.Replace(body, @"\bCREATE\s+TABLE\s+#(\w+)",
            "CREATE TEMP TABLE $1", RegexOptions.IgnoreCase);
        body = Regex.Replace(body,
            @"(?is)(CREATE\s+TEMP\s+TABLE\s+\w+\s*\([^;]*?\))\s*;",
            "$1 ON COMMIT DROP;");

        // Do not let SELECT INTO matching cross a FROM belonging to an earlier
        // statement. This was the source of the Board WidgetTemp corruption.
        body = SafeReplace(body, "BoardSelectIntoTemp",
            @"\bSELECT\s+((?:(?!\bFROM\b)[\s\S])+?)\s+INTO\s+#(\w+)\s+FROM\b",
            "CREATE TEMP TABLE $2 ON COMMIT DROP AS SELECT $1 FROM",
            RegexOptions.IgnoreCase, TimeSpan.FromSeconds(10));

        body = ReorderBoardCteTempMaterialization(body);

        // SQL Server's OBJECT_ID guard is represented directly by IF EXISTS.
        body = Regex.Replace(body,
            @"(?im)^[ \t]*IF\s+OBJECT_ID\s*\(\s*'tempdb\.\.#?(\w+)'\s*\)\s+IS\s+NOT\s+NULL\s+DROP\s+TABLE\s+#?\1\s*;?[ \t]*$",
            "DROP TABLE IF EXISTS $1;",
            RegexOptions.IgnoreCase);
        body = Regex.Replace(body, @"\bDROP\s+TABLE\s+(?!IF\s+EXISTS\b)#?(\w+)[ \t]*;?",
            "DROP TABLE IF EXISTS $1;", RegexOptions.IgnoreCase);

        body = Regex.Replace(body, @"#(\w+)", "$1");
        foreach (string name in tableVariables)
            body = Regex.Replace(body, $@"@{Regex.Escape(name)}\b", name,
                RegexOptions.IgnoreCase);

        return body;
    }

    static string ConvertBoardTableVariableDeclarations(string body,
        HashSet<string> tableVariables)
    {
        int searchFrom = 0;
        while (searchFrom < body.Length)
        {
            var match = Regex.Match(body[searchFrom..],
                @"\bDECLARE\s+@(\w+)\s+TABLE\s*\(",
                RegexOptions.IgnoreCase, RegexTimeout);
            if (!match.Success) break;

            int start = searchFrom + match.Index;
            int openParen = start + match.Value.LastIndexOf('(');
            int closeParen = FindMatchingParen(body, openParen);
            if (closeParen < 0) break;

            string name = match.Groups[1].Value;
            tableVariables.Add(name);
            string columns = body[(openParen + 1)..closeParen];
            columns = Regex.Replace(columns,
                @"\b(?:TINYINT|SMALLINT|INT|BIGINT)\s+IDENTITY(?:\s*\(\s*\d+\s*,\s*\d+\s*\))?",
                "serial", RegexOptions.IgnoreCase);
            columns = Regex.Replace(columns, @"\bNVARCHAR\s*\(\s*MAX\s*\)", "text",
                RegexOptions.IgnoreCase);
            columns = Regex.Replace(columns, @"\bN?VARCHAR\b", "varchar",
                RegexOptions.IgnoreCase);
            columns = Regex.Replace(columns, @"\bDATETIME\b", "timestamp",
                RegexOptions.IgnoreCase);
            columns = Regex.Replace(columns, @"\bBIT\b", "boolean",
                RegexOptions.IgnoreCase);

            int end = closeParen + 1;
            if (end < body.Length && body[end] == ';') end++;
            string replacement =
                $"CREATE TEMP TABLE {name} ({columns}) ON COMMIT DROP;";
            body = body[..start] + replacement + body[end..];
            searchFrom = start + replacement.Length;
        }
        return body;
    }

    static string ReorderBoardCteTempMaterialization(string body)
    {
        var lines = body.Split('\n').ToList();
        for (int createLine = 0; createLine < lines.Count; createLine++)
        {
            var create = Regex.Match(lines[createLine],
                @"^([ \t]*)(\)?\s*)(CREATE\s+TEMP(?:ORARY)?\s+TABLE\s+\w+\s+ON\s+COMMIT\s+DROP\s+AS\s+)(SELECT\b.*)$",
                RegexOptions.IgnoreCase);
            if (!create.Success) continue;

            int withLine = -1;
            for (int i = createLine - 1; i >= 0; i--)
            {
                string trimmed = lines[i].Trim();
                if (string.IsNullOrWhiteSpace(trimmed) || trimmed.StartsWith("--"))
                    continue;

                if (Regex.IsMatch(trimmed, @"^;?WITH\b", RegexOptions.IgnoreCase))
                {
                    withLine = i;
                    break;
                }
                if (trimmed.EndsWith(";") && !Regex.IsMatch(trimmed, @"^\)\s*;?$"))
                    break;
            }
            if (withLine < 0) continue;

            int previous = withLine - 1;
            while (previous >= 0 && string.IsNullOrWhiteSpace(lines[previous])) previous--;
            if (previous >= 0 &&
                Regex.IsMatch(lines[previous].Trim(), @"^RETURN\s+QUERY\s*;?$",
                    RegexOptions.IgnoreCase))
                lines[previous] = "";

            lines[withLine] = create.Groups[1].Value + create.Groups[3].Value +
                              Regex.Replace(lines[withLine].TrimStart(), @"^;", "");
            lines[createLine] = create.Groups[1].Value + create.Groups[2].Value + create.Groups[4].Value;
        }
        return string.Join('\n', lines);
    }

    // ── EXEC → PERFORM / EXECUTE ──────────────────────────────────────────────

    static string ConvertExec(string body)
    {
        // P5: Remove sp_xml_preparedocument / sp_xml_removedocument (OPENXML XML shredding)
        body = Regex.Replace(body,
            @"(?m)^[ \t]*(?:EXEC(?:UTE)?\s+)?sp_xml_preparedocument\b[^\n]*\n",
            "-- TODO: XML shredding removed — rewrite as xmltable\n",
            RegexOptions.IgnoreCase);
        body = Regex.Replace(body,
            @"(?m)^[ \t]*(?:EXEC(?:UTE)?\s+)?sp_xml_removedocument\b[^\n;]*(?:;?[ \t]*\n|;?[ \t]*$)",
            "", RegexOptions.IgnoreCase);
        // P5: Replace OPENXML(...) WITH (...) with a syntactically complete XMLTABLE stub.
        // Keep the whole WITH list on the line: SQL types such as varchar(50) contain
        // parentheses, so stopping at the first ')' leaves invalid trailing columns.
        body = SafeReplace(body, "OpenXml",
            @"(?m)OPENXML\s*\([^\n]*?\)\s*WITH\s*\((?<columns>[^\n]*)\)",
            m => BuildOpenXmlStub(m.Groups["columns"].Value),
            RegexOptions.IgnoreCase);

        // SQL Server xml.nodes(...).value(...) has no direct PostgreSQL equivalent.
        // Emit an empty, typed relation so surrounding temp-table DDL remains
        // compilable while making the incomplete semantic mapping explicit.
        body = SafeReplace(body, "XmlNodesValue",
            @"(?ims)SELECT\s+.*?\.value\s*\(.*?\)\s+AS\s+ContentJson\s+FROM\s+@?\w+\.nodes\s*\([^\n;]*?\)\s*AS\s+\w+\s*\(\w+\)",
            "-- TODO: map SQL Server xml.nodes/value expressions to PostgreSQL XMLTABLE\n" +
            "SELECT NULL::integer AS Id, NULL::text AS Title, NULL::text AS ContentJson WHERE FALSE",
            RegexOptions.IgnoreCase);

        // EXEC sp_executesql N'literal'  →  EXECUTE 'literal';
        body = SafeReplace(body, "ExecSqlLiteral",
            @"\bEXEC(?:UTE)?\s+sp_executesql\s+(N?'[^']*')\s*;?",
            "EXECUTE $1;",
            RegexOptions.IgnoreCase);

        // EXEC sp_executesql @sql  →  EXECUTE sql;
        body = SafeReplace(body, "ExecSql",
            @"(?m)^([ \t]*)EXEC(?:UTE)?\s+sp_executesql\s+@?(\w+)\s*;?\s*$",
            "$1EXECUTE $2;",
            RegexOptions.IgnoreCase);

        // EXEC sp_executesql @sql, N'@p int', @p = @val  →  EXECUTE format(sql, val)
        body = SafeReplace(body, "ExecSqlParams",
            @"(?m)^([ \t]*)EXEC(?:UTE)?\s+sp_executesql\s+@?(\w+)\s*,\s*N?'([^']*)'\s*,\s*(.+?)\s*;?\s*$",
            m => {
                var indent  = m.Groups[1].Value;
                var sqlVar  = m.Groups[2].Value;
                var argStr  = m.Groups[4].Value;

                // Named: @param = value (variable, string literal, or number)
                var namedM = Regex.Matches(argStr,
                    @"@\w+\s*=\s*(@?\w+(?:\.\w+)?|'(?:[^']|'')*'|-?\d+(?:\.\d+)?)");
                if (namedM.Count > 0)
                {
                    var vals = namedM.Select(x => x.Groups[1].Value.TrimStart('@')).ToList();
                    return $"{indent}EXECUTE format({sqlVar}, {string.Join(", ", vals)});";
                }

                // Positional: @val1, @val2, ...
                var posVals = SplitComma(argStr)
                    .Select(v => v.Trim().TrimStart('@'))
                    .Where(v => v.Length > 0).ToList();
                if (posVals.Count > 0)
                    return $"{indent}EXECUTE format({sqlVar}, {string.Join(", ", posVals)});";

                return $"{indent}EXECUTE {sqlVar}; -- TODO: parameterized sp_executesql";
            },
            RegexOptions.IgnoreCase);

        // EXEC ('string' + @var)  →  EXECUTE 'string' || var;  (line-anchored)
        body = SafeReplace(body, "ExecParens",
            @"(?m)^([ \t]*)EXEC(?:UTE)?\s*\(\s*(.+?)\s*\)\s*;?\s*$",
            "$1EXECUTE ($2);",
            RegexOptions.IgnoreCase);

        // EXEC('string') inline (not at line start)  →  EXECUTE 'string';
        body = SafeReplace(body, "ExecParensInline",
            @"\bEXEC(?:UTE)?\s*\(\s*(.+?)\s*\)\s*;?",
            "EXECUTE ($1);",
            RegexOptions.IgnoreCase);

        // EXEC dbo.proc @p1, @p2  →  PERFORM proc(p1, p2);
        // Atomic group (?>...) prevents catastrophic backtracking on the nested param quantifier
        body = SafeReplace(body, "ExecProcArgs",
            @"(?m)^([ \t]*)EXEC(?:UTE)?\s+(?:\[?dbo\]?\.)?\[?(\w+)\]?\s+((?>(?:@?\w+\s*(?:=\s*@?\w+\s*)?,?\s*)+))\s*;?\s*$",
            m => {
                var indent   = m.Groups[1].Value;
                var procName = m.Groups[2].Value.ToLower();
                // Strip named-param syntax: @name = @val → val
                var args = Regex.Replace(m.Groups[3].Value, @"@?\w+\s*=\s*@?(\w+)", "$1");
                args = Regex.Replace(args, @"@(\w+)", "$1").Trim().TrimEnd(',');
                return $"{indent}PERFORM {procName}({args});";
            },
            RegexOptions.IgnoreCase);

        // EXEC dbo.proc  (no params)  →  PERFORM proc();
        body = SafeReplace(body, "ExecProcNoArgs",
            @"(?m)^([ \t]*)EXEC(?:UTE)?\s+(?:\[?dbo\]?\.)?\[?(\w+)\]?\s*;?\s*$",
            m => $"{m.Groups[1].Value}PERFORM {m.Groups[2].Value.ToLower()}();",
            RegexOptions.IgnoreCase);

        return body;
    }

    static string BuildOpenXmlStub(string columns)
    {
        var mappedColumns = Regex.Matches(columns,
                @"(?<name>[A-Za-z_]\w*)\s+(?<type>n?varchar\s*\(\s*\d+\s*\)|bigint|int|bit|datetime|date|text)",
                RegexOptions.IgnoreCase, RegexTimeout)
            .Select(m =>
            {
                var name = m.Groups["name"].Value;
                var type = m.Groups["type"].Value;
                var pgType = Regex.IsMatch(type, @"^n?varchar", RegexOptions.IgnoreCase, RegexTimeout)
                    ? "text"
                    : type.Equals("int", StringComparison.OrdinalIgnoreCase) ? "integer"
                    : type.Equals("bit", StringComparison.OrdinalIgnoreCase) ? "boolean"
                    : type.Equals("datetime", StringComparison.OrdinalIgnoreCase) ? "timestamp"
                    : type.ToLowerInvariant();
                return $"NULL::{pgType} AS {name}";
            })
            .ToList();

        if (mappedColumns.Count == 0)
            mappedColumns.Add("NULL::text AS col");

        // PostgreSQL 9.3 predates XMLTABLE. Keep a typed, empty relation so the
        // surrounding procedure compiles, and leave the semantic work explicit.
        return "(SELECT " +
               string.Join(", ", mappedColumns) +
               " WHERE FALSE) AS openxml_stub /* TODO: replace with xmltable and verify XML paths */";
    }

    // ── MERGE INTO → UPDATE + INSERT (UPSERT) ────────────────────────────────

    static string ConvertMerge(string body)
    {
        body = SafeReplace(body, "MergeMain",
            @"MERGE\s+(?:INTO\s+)?(?:\[?dbo\]?\.)?\[?(\w+)\]?\s+(?:AS\s+)?(\w+)\s*\r?\n\s*USING\s+([\s\S]+?)\s+(?:AS\s+)?(\w+)\s+ON\s*\(([^)]+)\)([\s\S]+?)(?=;|\r?\n\s*GO\b|\z)",
            m => {
                var tbl    = m.Groups[1].Value;
                var tAlias = m.Groups[2].Value;
                var src    = m.Groups[3].Value.Trim();
                var sAlias = m.Groups[4].Value;
                var onCond = m.Groups[5].Value.Trim();
                var when   = m.Groups[6].Value;

                var sb = new StringBuilder();
                sb.AppendLine($"-- Converted from MERGE INTO {tbl}");

                // WHEN MATCHED THEN UPDATE SET ...
                var updM = Regex.Match(when,
                    @"WHEN\s+MATCHED(?:\s+AND\s+[^\r\n]+)?\s+THEN\s+UPDATE\s+SET\s+([\s\S]+?)(?=WHEN\b|$)",
                    RegexOptions.IgnoreCase);
                if (updM.Success)
                {
                    var setCols = updM.Groups[1].Value.Trim().TrimEnd(',', ';');
                    sb.AppendLine($"UPDATE {tbl} {tAlias}");
                    sb.AppendLine($"SET {setCols}");
                    sb.AppendLine($"FROM ({src}) {sAlias}");
                    sb.AppendLine($"WHERE {onCond};");
                }

                // WHEN NOT MATCHED [BY TARGET] THEN INSERT
                var insM = Regex.Match(when,
                    @"WHEN\s+NOT\s+MATCHED(?:\s+BY\s+TARGET)?(?:\s+AND\s+[^\r\n]+)?\s+THEN\s+INSERT\s*\(([^)]+)\)\s*VALUES\s*\(([^)]+)\)",
                    RegexOptions.IgnoreCase);
                if (insM.Success)
                {
                    var cols = insM.Groups[1].Value.Trim();
                    var vals = insM.Groups[2].Value.Trim();
                    sb.AppendLine($"INSERT INTO {tbl} ({cols})");
                    sb.AppendLine($"SELECT {vals} FROM ({src}) {sAlias}");
                    sb.AppendLine($"WHERE NOT EXISTS (SELECT 1 FROM {tbl} {tAlias} WHERE {onCond});");
                }

                // WHEN NOT MATCHED BY SOURCE THEN DELETE
                if (Regex.IsMatch(when, @"WHEN\s+NOT\s+MATCHED\s+BY\s+SOURCE\s+THEN\s+DELETE", RegexOptions.IgnoreCase))
                {
                    sb.AppendLine($"DELETE FROM {tbl} {tAlias}");
                    sb.AppendLine($"WHERE NOT EXISTS (SELECT 1 FROM ({src}) {sAlias} WHERE {onCond});");
                }

                return sb.ToString().TrimEnd() + ";";
            },
            RegexOptions.IgnoreCase, TimeSpan.FromSeconds(10));

        // Fallback: unrecognized MERGE → preserve cleaned-up version with PG 15+ note
        body = SafeReplace(body, "MergeFallback",
            @"\bMERGE\s+(?:INTO\s+)?\w+[\s\S]+?(?=;|\r?\n\s*GO\b)",
            m => {
                var cleaned = Regex.Replace(m.Value, @"\[(\w+)\]", "$1");
                cleaned = Regex.Replace(cleaned, @"\[?dbo\]?\.", "", RegexOptions.IgnoreCase);
                return $"-- TODO: MERGE requires PostgreSQL 15+ — review syntax before running:\n{cleaned}";
            },
            RegexOptions.IgnoreCase, TimeSpan.FromSeconds(10));

        return body;
    }

    // ── OPENQUERY / OPENROWSET → dblink template ──────────────────────────────

    static string ConvertOpenQuery(string body)
    {
        // OPENQUERY(LinkedServer, 'SELECT col1, col2 FROM ...')  →  dblink('TODO_CONN', ...) AS t(col1 text, col2 text)
        body = SafeReplace(body, "OpenQuery",
            @"\bOPENQUERY\s*\(\s*(\w+)\s*,\s*N?'((?:[^']|'')*)'\s*\)",
            m => {
                var server   = m.Groups[1].Value.ToUpper();
                var innerSql = m.Groups[2].Value.Replace("''", "'");
                var colDefs  = ExtractOpenQueryCols(innerSql);
                var quoted   = "'" + innerSql.Replace("'", "''") + "'";
                return $"dblink('TODO_CONN_{server}', {quoted}) AS t({colDefs})";
            },
            RegexOptions.IgnoreCase);

        // OPENROWSET  →  TODO
        body = SafeReplace(body, "OpenRowset",
            @"\bOPENROWSET\s*\([^)]+\)",
            "NULL -- TODO: OPENROWSET → use postgres_fdw or dblink",
            RegexOptions.IgnoreCase);

        return body;
    }

    static string ExtractOpenQueryCols(string innerSql)
    {
        var selM = Regex.Match(innerSql, @"\bSELECT\s+([\s\S]+?)\s+FROM\b", RegexOptions.IgnoreCase);
        if (!selM.Success) return "-- TODO: list col defs (name type, ...)";

        var colPart = selM.Groups[1].Value.Trim();
        if (Regex.IsMatch(colPart, @"^\s*\*\s*$"))
            return "-- TODO: list col defs (name type, ...)";

        var cols = SplitComma(colPart);
        var defs = cols.Select((col, i) => {
            col = col.Trim();
            var am = Regex.Match(col, @"\bAS\s+(?:""(\w+)""|(\w+))\s*$", RegexOptions.IgnoreCase);
            string name;
            if (am.Success)
                name = (am.Groups[1].Value.Length > 0 ? am.Groups[1].Value : am.Groups[2].Value).ToLower();
            else
            {
                var dm = Regex.Match(col, @"\.(\w+)\s*$");
                name = dm.Success ? dm.Groups[1].Value.ToLower()
                     : Regex.Match(col, @"^(\w+)\s*$") is { Success: true } bm ? bm.Groups[1].Value.ToLower()
                     : $"col{i + 1}";
            }
            return $"{name} text";
        }).ToList();
        return string.Join(", ", defs);
    }

    // ── BEGIN TRY / END TRY / BEGIN CATCH / END CATCH → EXCEPTION WHEN OTHERS THEN ──

    static string ConvertTryCatch(string body)
    {
        body = SafeReplace(body, "TryCatch",
            @"BEGIN\s+TRY\s*([\s\S]+?)\s*END\s+TRY\s+BEGIN\s+CATCH\s*([\s\S]*?)\s*END\s+CATCH\b",
            m => {
                var tryBody   = m.Groups[1].Value.Trim();
                var catchBody = m.Groups[2].Value.Trim();
                if (string.IsNullOrWhiteSpace(catchBody))
                    return $"{tryBody}\nEXCEPTION WHEN OTHERS THEN\n    NULL;";
                return $"{tryBody}\nEXCEPTION WHEN OTHERS THEN\n    {catchBody}";
            },
            RegexOptions.IgnoreCase, TimeSpan.FromSeconds(10));
        return body;
    }

    // ── RAISERROR → RAISE EXCEPTION ──────────────────────────────────────────

    static string ConvertRaiseError(string body)
    {
        // RAISERROR('msg', severity, state) → RAISE EXCEPTION 'msg';
        body = SafeReplace(body, "RaiseErrorLiteral",
            @"\bRAISERROR\s*\(\s*(N?'[^']+')\s*,\s*\d+\s*,\s*\d+\s*(?:,\s*[^)]+)?\)",
            m => $"RAISE EXCEPTION {m.Groups[1].Value.TrimStart('N', 'n')}",
            RegexOptions.IgnoreCase);

        // RAISERROR with variable: RAISERROR(@msg, 16, 1) → RAISE EXCEPTION '%', msg;
        body = SafeReplace(body, "RaiseErrorVar",
            @"\bRAISERROR\s*\(\s*@?(\w+)\s*,\s*\d+\s*,\s*\d+\s*\)",
            "RAISE EXCEPTION '%', $1",
            RegexOptions.IgnoreCase);

        // THROW; or THROW errnum, msg, state → RAISE;
        body = SafeReplace(body, "Throw",
            @"\bTHROW\s*(?:\d+\s*,\s*N?'[^']+'\s*,\s*\d+)?\s*;",
            "RAISE;",
            RegexOptions.IgnoreCase);

        return body;
    }

    // ── Control flow: IF / ELSE / WHILE / BEGIN / END ─────────────────────────

    static string ConvertControlFlow(string body)
    {
        var lines  = body.Split('\n');
        var result = new List<string>();
        var stack  = new Stack<BlockKind>();
        BlockKind? pending = null;
        int sqlCaseDepth = 0;
        bool isBoardProcedure = _fnName?.StartsWith("board_", StringComparison.OrdinalIgnoreCase) == true;
        bool suppressNextElseBegin = false;

        for (int li = 0; li < lines.Length; li++)
        {
            var rawLine = lines[li];
            var trimmed = rawLine.TrimStart();
            var indent  = rawLine[..^trimmed.Length];

            if (string.IsNullOrWhiteSpace(trimmed))
            {
                result.Add(rawLine);
                continue;
            }

            int caseOpens = Regex.Matches(trimmed, @"\bCASE\b", RegexOptions.IgnoreCase).Count;
            int caseCloses = Regex.Matches(trimmed, @"\bEND\b(?!\s+IF\b|\s+LOOP\b)",
                RegexOptions.IgnoreCase).Count;
            bool isSqlCaseControl = sqlCaseDepth > 0 &&
                Regex.IsMatch(trimmed, @"^(?:ELSE\b|END\b)", RegexOptions.IgnoreCase);
            sqlCaseDepth = Math.Max(0, sqlCaseDepth + caseOpens - caseCloses);
            if (isSqlCaseControl)
            {
                result.Add(rawLine);
                continue;
            }

            // ── ELSE IF ──────────────────────────────────────────────────────
            var elseIfM = Regex.Match(trimmed, @"^ELSE\s+IF\s+(.+?)(?:\s+BEGIN\s*)?$", RegexOptions.IgnoreCase);
            if (elseIfM.Success)
            {
                var condPart = CollectMultiLineCond(lines, ref li, elseIfM.Groups[1].Value.Trim());
                if (TrySplitInlineCondition(condPart, out var inlineCond, out var inlineStatement))
                {
                    result.Add(indent + $"ELSIF {StripOuterParens(inlineCond)} THEN");
                    result.Add(indent + "    " + inlineStatement);
                    if (!NextLineStartsElse(lines, li))
                    {
                        if (stack.Count > 0) stack.Pop();
                        result.Add(indent + "END IF;");
                    }
                    continue;
                }
                var (condBody, trailingComment) = ExtractTrailingLineComment(condPart);
                bool inline  = Regex.IsMatch(condBody, @"\bBEGIN\s*$", RegexOptions.IgnoreCase);
                if (inline) condBody = Regex.Replace(condBody, @"\s*BEGIN\s*$", "", RegexOptions.IgnoreCase).TrimEnd();
                result.Add(indent + $"ELSIF {StripOuterParens(condBody)} THEN{trailingComment}");
                if (inline) stack.Push(BlockKind.ElseIf);
                else        pending = BlockKind.ElseIf;
                continue;
            }

            // ── IF ───────────────────────────────────────────────────────────
            // Exclude IF NOT EXISTS / IF EXISTS (used in DO blocks).
            // Use \b\s* instead of \s+ to also handle IF(condition) without space.
            var ifM = Regex.Match(trimmed,
                @"^IF\b\s*(?!(?:NOT\s+)?EXISTS\b)(.+?)(?:\s+BEGIN\s*)?$",
                RegexOptions.IgnoreCase);
            if (ifM.Success)
            {
                var condPart = CollectMultiLineCond(lines, ref li, ifM.Groups[1].Value.Trim());
                if (TrySplitInlineCondition(condPart, out var inlineCond, out var inlineStatement))
                {
                    result.Add(indent + $"IF {StripOuterParens(inlineCond)} THEN");
                    result.Add(indent + "    " + inlineStatement);
                    if (NextLineStartsElse(lines, li))
                        stack.Push(BlockKind.If);
                    else
                        result.Add(indent + "END IF;");
                    continue;
                }
                var (condBody, trailingComment) = ExtractTrailingLineComment(condPart);
                bool inline  = Regex.IsMatch(condBody, @"\bBEGIN\s*$", RegexOptions.IgnoreCase);
                if (inline) condBody = Regex.Replace(condBody, @"\s*BEGIN\s*$", "", RegexOptions.IgnoreCase).TrimEnd();
                result.Add(indent + $"IF {StripOuterParens(condBody)} THEN{trailingComment}");
                if (inline) stack.Push(BlockKind.If);
                else        pending = BlockKind.If;
                continue;
            }

            // ── ELSE ─────────────────────────────────────────────────────────
            var elseM = Regex.Match(trimmed, @"^ELSE(?:\s+BEGIN)?\s*$", RegexOptions.IgnoreCase);
            if (elseM.Success)
            {
                EnsurePreviousBranchTerminator(result);
                result.Add(indent + "ELSE");
                // ELSE continues the current IF block. SQL Server commonly writes
                // "END / ELSE / BEGIN"; the END immediately before ELSE is suppressed
                // below, so no second stack entry is needed here.
                pending = null;
                // Suppress the standalone BEGIN that follows ELSE (applies to all procedures)
                suppressNextElseBegin = !Regex.IsMatch(trimmed, @"\bBEGIN\b", RegexOptions.IgnoreCase);
                continue;
            }

            var inlineElseM = Regex.Match(trimmed, @"^ELSE\s+(?!IF\b|BEGIN\b)(.+)$",
                RegexOptions.IgnoreCase);
            if (inlineElseM.Success)
            {
                result.Add(indent + "ELSE");
                result.Add(indent + "    " + inlineElseM.Groups[1].Value.Trim());
                if (stack.Count > 0) stack.Pop();
                result.Add(indent + "END IF;");
                pending = null;
                continue;
            }

            // ── WHILE (not @@FETCH_STATUS — already handled) ─────────────────
            // Cursor conversion emits a complete PL/pgSQL FOR query header.
            if (Regex.IsMatch(trimmed, @"^FOR\s+.+\s+IN\s+.+\s+LOOP\s*$",
                RegexOptions.IgnoreCase))
            {
                result.Add(rawLine);
                pending = BlockKind.While;
                continue;
            }

            var whileM = Regex.Match(trimmed,
                @"^WHILE\s+(?!@@FETCH_STATUS\b)(.+?)(?:\s+BEGIN\s*)?$",
                RegexOptions.IgnoreCase);
            if (whileM.Success)
            {
                var condPart = CollectMultiLineCond(lines, ref li, whileM.Groups[1].Value.Trim());
                var (condBody, trailingComment) = ExtractTrailingLineComment(condPart);
                bool inline  = Regex.IsMatch(condBody, @"\bBEGIN\s*$", RegexOptions.IgnoreCase);
                if (inline) condBody = Regex.Replace(condBody, @"\s*BEGIN\s*$", "", RegexOptions.IgnoreCase).TrimEnd();
                result.Add(indent + $"WHILE {StripOuterParens(condBody)} LOOP{trailingComment}");
                if (inline) stack.Push(BlockKind.While);
                else        pending = BlockKind.While;
                continue;
            }

            // ── BEGIN ────────────────────────────────────────────────────────
            if (Regex.IsMatch(trimmed, @"^BEGIN\s*$", RegexOptions.IgnoreCase))
            {
                if (suppressNextElseBegin)
                {
                    suppressNextElseBegin = false;
                    continue;
                }
                if (pending.HasValue)
                {
                    stack.Push(pending.Value);
                    pending = null;
                    // Don't emit BEGIN — THEN / LOOP / ELSE already written
                }
                else
                {
                    stack.Push(BlockKind.Plain);
                    result.Add(rawLine);
                }
                continue;
            }

            // ── END (bare) ────────────────────────────────────────────────────
            if (Regex.IsMatch(trimmed, @"^END\s*;?\s*$", RegexOptions.IgnoreCase))
            {
                // In T-SQL, END closes the THEN's BEGIN block before ELSE. In
                // PL/pgSQL the IF itself must stay open until the final END IF.
                int next = li + 1;
                while (next < lines.Length && string.IsNullOrWhiteSpace(lines[next])) next++;
                if (next < lines.Length &&
                    Regex.IsMatch(lines[next].Trim(), @"^ELSE\b", RegexOptions.IgnoreCase))
                    continue;

                var top = stack.Count > 0 ? stack.Pop() : BlockKind.Plain;
                if (top is BlockKind.If or BlockKind.ElseIf or BlockKind.Else)
                    EnsurePreviousBranchTerminator(result);
                result.Add(indent + top switch {
                    BlockKind.If or BlockKind.ElseIf or BlockKind.Else => "END IF;",
                    BlockKind.While                                     => "END LOOP;",
                    _                                                   => "END;"
                });
                continue;
            }

            // ── BREAK → EXIT ─────────────────────────────────────────────────
            if (Regex.IsMatch(trimmed, @"^BREAK\s*;?\s*$", RegexOptions.IgnoreCase))
            {
                result.Add(indent + "EXIT;");
                continue;
            }

            // ── CONTINUE stays CONTINUE ───────────────────────────────────────
            if (Regex.IsMatch(trimmed, @"^CONTINUE\s*;?\s*$", RegexOptions.IgnoreCase))
            {
                result.Add(indent + "CONTINUE;");
                continue;
            }

            result.Add(rawLine);
        }

        return string.Join('\n', result);
    }

    static void EnsurePreviousBranchTerminator(List<string> lines)
    {
        for (int i = lines.Count - 1; i >= 0; i--)
        {
            var trimmed = lines[i].Trim();
            if (trimmed.Length == 0 || trimmed.StartsWith("--")) continue;
            if (trimmed.EndsWith(";") ||
                Regex.IsMatch(trimmed, @"(?:\bTHEN|\bELSE|\bBEGIN|\bLOOP)$",
                    RegexOptions.IgnoreCase))
                return;
            lines[i] = lines[i].TrimEnd() + ";";
            return;
        }
    }

    static bool NextLineStartsElse(string[] lines, int li)
    {
        for (int i = li + 1; i < lines.Length; i++)
        {
            if (string.IsNullOrWhiteSpace(lines[i])) continue;
            return Regex.IsMatch(lines[i].TrimStart(), @"^ELSE\b", RegexOptions.IgnoreCase);
        }
        return false;
    }

    static bool TrySplitInlineCondition(string text, out string condition, out string statement)
    {
        condition = "";
        statement = "";
        text = text.Trim();
        if (!text.StartsWith("(")) return false;

        int depth = 0;
        bool inString = false;
        for (int i = 0; i < text.Length; i++)
        {
            char c = text[i];
            if (c == '\'') inString = !inString;
            if (inString) continue;
            if (c == '(') depth++;
            else if (c == ')' && --depth == 0)
            {
                statement = text[(i + 1)..].Trim();
                if (!Regex.IsMatch(statement,
                    @"^(?:SET\b|SELECT\b|INSERT\b|UPDATE\b|DELETE\b|EXEC(?:UTE)?\b|RETURN\b|RAISE\b|PRINT\b)",
                    RegexOptions.IgnoreCase))
                    return false;
                condition = text[..(i + 1)];
                return true;
            }
        }
        return false;
    }

    // Collects continuation lines when an IF/WHILE condition has unbalanced open parentheses.
    // Stops when parens balance, when next line is BEGIN, or when lines run out.
    static string CollectMultiLineCond(string[] lines, ref int li, string condSoFar)
    {
        condSoFar = condSoFar.TrimEnd(';').Trim();
        while (CountOpenParens(condSoFar) > 0 && li + 1 < lines.Length)
        {
            var next = lines[li + 1].Trim();
            if (Regex.IsMatch(next, @"^BEGIN\s*$", RegexOptions.IgnoreCase)) break;
            li++;
            condSoFar = condSoFar + " " + next.TrimEnd(';');
        }
        return condSoFar.Trim();
    }

    static int CountOpenParens(string s)
    {
        int depth = 0;
        bool inStr = false;
        foreach (char c in s)
        {
            if (c == '\'' && !inStr) { inStr = true;  continue; }
            if (c == '\'' && inStr)  { inStr = false; continue; }
            if (!inStr) { if (c == '(') depth++; else if (c == ')') depth--; }
        }
        return depth;
    }

    // Extract trailing -- comment from a condition string so THEN/LOOP can be placed before it.
    // Returns (cleanedCondition, " -- comment") or (original, "").
    static (string clean, string comment) ExtractTrailingLineComment(string s)
    {
        bool inStr = false;
        for (int i = 0; i < s.Length; i++)
        {
            if (s[i] == '\'') { inStr = !inStr; continue; }
            if (!inStr && i + 1 < s.Length && s[i] == '-' && s[i + 1] == '-')
                return (s[..i].TrimEnd(), " " + s[i..].TrimEnd());
        }
        return (s, "");
    }

    // ── Variable assignments ─────────────────────────────────────────────────

    static string ConvertAssignments(string body)
    {
        if (_fnName?.StartsWith("board_", StringComparison.OrdinalIgnoreCase) == true)
        {
            body = ConvertBoardSelectAssignments(body);
            body = ConvertBoardStringAccumulation(body);
        }

        // SET @var = expr  →  var := expr;
        // @ is required to avoid matching UPDATE SET col=val (no @ before column names)
        body = SafeReplace(body, "SetVar",
            @"(?m)^([ \t]*)SET\s+@(\w+)\s*=\s*(.+?)\s*;?\s*$",
            "$1$2 := $3;",
            RegexOptions.IgnoreCase);

        // SELECT @v1 = e1, @v2 = e2 FROM tbl  →  SELECT e1, e2 INTO v1, v2 FROM tbl
        body = SafeReplace(body, "SelectAssign",
            @"\bSELECT\s+((?:@\w+\s*=\s*[^,\r\n]+,?\s*)+)(?=FROM\b)",
            m => {
                var parts = Regex.Matches(m.Groups[1].Value,
                    @"@(\w+)\s*=\s*([^,\r\n]+?)(?=,\s*@|$|\s+FROM)");
                var vars  = parts.Select(p => p.Groups[1].Value.ToLower());
                var exprs = parts.Select(p => p.Groups[2].Value.Trim());
                return $"SELECT {string.Join(", ", exprs)} INTO {string.Join(", ", vars)} ";
            },
            RegexOptions.IgnoreCase);

        // SELECT @var = scalar_expr (no FROM)  →  var := (scalar_expr);
        body = SafeReplace(body, "SelectScalar",
            @"(?m)^([ \t]*)SELECT\s+@(\w+)\s*=\s*(.+?)\s*;?\s*$",
            "$1$2 := ($3);",
            RegexOptions.IgnoreCase);

        return body;
    }

    static string ConvertBoardSelectAssignments(string body)
    {
        var lines = body.Split('\n');
        for (int i = 0; i < lines.Length; i++)
        {
            string raw = lines[i];
            var select = Regex.Match(raw,
                @"^([ \t]*)SELECT\s+(.+?)[ \t]*\r?$", RegexOptions.IgnoreCase);
            if (!select.Success || raw.TrimStart().StartsWith("--")) continue;

            string selectBody = select.Groups[2].Value.Trim().TrimEnd(';');
            int fromIndex = FindTopLevelKeyword(selectBody, "FROM");
            int consumedThrough = i;
            int currentDepth = GetParenthesisDepth(selectBody);
            while ((fromIndex < 0 || currentDepth > 0) &&
                   selectBody.StartsWith("@", StringComparison.Ordinal) &&
                   consumedThrough + 1 < lines.Length)
            {
                string continuation = lines[consumedThrough + 1].Trim().TrimEnd('\r');
                if (currentDepth == 0 && Regex.IsMatch(continuation,
                    @"^(?:IF|ELSE|BEGIN|END|WHILE|INSERT|UPDATE|DELETE|SET|DROP|CREATE|RETURN|SELECT)\b",
                    RegexOptions.IgnoreCase))
                    break;
                consumedThrough++;
                selectBody += "\n" + continuation;
                fromIndex = FindTopLevelKeyword(selectBody, "FROM");
                currentDepth = GetParenthesisDepth(selectBody);
            }

            if (fromIndex < 0)
            {
                var assignments = SplitTopLevelComma(selectBody);
                var assignLines = new List<string>();
                bool allScalar = assignments.Count > 0;
                foreach (string assignment in assignments)
                {
                    var match = Regex.Match(assignment.Trim(),
                        @"^@(\w+)\s*=\s*([\s\S]+)$", RegexOptions.IgnoreCase);
                    if (!match.Success) { allScalar = false; break; }
                    string varName = match.Groups[1].Value.ToLowerInvariant();
                    string expr = match.Groups[2].Value.Trim().TrimEnd(';');
                    assignLines.Add($"{select.Groups[1].Value}{varName} := ({expr});");
                }
                if (allScalar)
                {
                    lines[i] = string.Join("\n", assignLines);
                    for (int consumed = i + 1; consumed <= consumedThrough; consumed++)
                        lines[consumed] = "";
                }
                continue;
            }

            string assignmentList = selectBody[..fromIndex].Trim();
            string fromTail = selectBody[(fromIndex + 4)..].Trim();
            var assignmentsList = SplitTopLevelComma(assignmentList);
            var variables = new List<string>();
            var expressions = new List<string>();
            bool valid = assignmentsList.Count > 0;

            foreach (string assignment in assignmentsList)
            {
                var match = Regex.Match(assignment.Trim(),
                    @"^@(\w+)\s*=\s*([\s\S]+)$", RegexOptions.IgnoreCase);
                if (!match.Success) { valid = false; break; }
                variables.Add(match.Groups[1].Value.ToLowerInvariant());
                expressions.Add(match.Groups[2].Value.Trim());
            }

            if (valid)
            {
                lines[i] = $"{select.Groups[1].Value}SELECT {string.Join(", ", expressions)} " +
                           $"INTO {string.Join(", ", variables)} FROM {fromTail}";
                for (int consumed = i + 1; consumed <= consumedThrough; consumed++)
                    lines[consumed] = "";
            }
        }
        return string.Join('\n', lines);
    }

    static int GetParenthesisDepth(string text)
    {
        int depth = 0;
        bool inString = false;
        for (int i = 0; i < text.Length; i++)
        {
            char c = text[i];
            if (c == '\'')
            {
                if (inString && i + 1 < text.Length && text[i + 1] == '\'') { i++; continue; }
                inString = !inString;
                continue;
            }
            if (inString) continue;
            if (c == '(') depth++;
            if (c == ')') { if (depth > 0) depth--; }
        }
        return depth;
    }

    static List<string> SplitTopLevelComma(string text)
    {
        var parts = new List<string>();
        var current = new StringBuilder();
        int depth = 0;
        bool inString = false;
        for (int i = 0; i < text.Length; i++)
        {
            char c = text[i];
            if (c == '\'')
            {
                current.Append(c);
                if (inString && i + 1 < text.Length && text[i + 1] == '\'')
                {
                    current.Append(text[++i]);
                    continue;
                }
                inString = !inString;
                continue;
            }
            if (!inString)
            {
                if (c == '(') depth++;
                else if (c == ')' && depth > 0) depth--;
                else if (c == ',' && depth == 0)
                {
                    parts.Add(current.ToString());
                    current.Clear();
                    continue;
                }
            }
            current.Append(c);
        }
        if (current.Length > 0) parts.Add(current.ToString());
        return parts;
    }

    static int FindTopLevelKeyword(string text, string keyword)
    {
        int depth = 0;
        bool inString = false;
        for (int i = 0; i <= text.Length - keyword.Length; i++)
        {
            char c = text[i];
            if (c == '\'')
            {
                if (inString && i + 1 < text.Length && text[i + 1] == '\'') { i++; continue; }
                inString = !inString;
                continue;
            }
            if (inString) continue;
            if (c == '(') { depth++; continue; }
            if (c == ')') { if (depth > 0) depth--; continue; }
            if (depth != 0) continue;

            if (string.Compare(text, i, keyword, 0, keyword.Length,
                    StringComparison.OrdinalIgnoreCase) == 0 &&
                (i == 0 || !char.IsLetterOrDigit(text[i - 1])) &&
                (i + keyword.Length == text.Length ||
                 !char.IsLetterOrDigit(text[i + keyword.Length])))
                return i;
        }
        return -1;
    }

    static string ConvertBoardStringAccumulation(string body)
    {
        var lines = body.Split('\n');
        var result = new List<string>(lines.Length);

        for (int i = 0; i < lines.Length; i++)
        {
            var match = Regex.Match(lines[i],
                @"^([ \t]*)SET\s+@?(\w+)\s*\+=\s*(.*?)[ \t]*\r?$",
                RegexOptions.IgnoreCase);
            if (!match.Success || lines[i].TrimStart().StartsWith("--"))
            {
                result.Add(lines[i]);
                continue;
            }

            string indent = match.Groups[1].Value;
            string variable = match.Groups[2].Value.ToLowerInvariant();
            var expression = new StringBuilder(match.Groups[3].Value.Trim());

            while (i + 1 < lines.Length &&
                   NeedsStringAccumulationContinuation(expression.ToString()))
            {
                i++;
                if (expression.Length > 0) expression.AppendLine();
                expression.Append(lines[i].Trim().TrimEnd('\r'));
            }

            string convertedExpression = Regex.Replace(expression.ToString(),
                @"\s+\+\s+", " || ", RegexOptions.None, RegexTimeout).Trim().TrimEnd(';');
            if (convertedExpression.Length == 0) convertedExpression = "''";

            result.Add($"{indent}{variable} := COALESCE({variable}, '') || " +
                       $"COALESCE(({convertedExpression}), '');");
        }

        return string.Join('\n', result);
    }

    static bool NeedsStringAccumulationContinuation(string expression)
    {
        if (string.IsNullOrWhiteSpace(expression)) return true;

        bool inString = false;
        for (int i = 0; i < expression.Length; i++)
        {
            if (expression[i] != '\'') continue;
            if (inString && i + 1 < expression.Length && expression[i + 1] == '\'')
            {
                i++;
                continue;
            }
            inString = !inString;
        }
        if (inString) return true;

        string trimmed = expression.TrimEnd();
        return trimmed.EndsWith("+", StringComparison.Ordinal) ||
               trimmed.EndsWith("||", StringComparison.Ordinal);
    }

    // ── Utilities ────────────────────────────────────────────────────────────

    // Strip single layer of wrapping parens if the string starts & ends with () and no nested
    static string StripOuterParens(string s)
    {
        if (!s.StartsWith("(") || !s.EndsWith(")")) return s;
        int depth = 0;
        for (int i = 0; i < s.Length - 1; i++)
        {
            if (s[i] == '(') depth++;
            else if (s[i] == ')') depth--;
            if (depth == 0) return s; // parens close before end → don't strip
        }
        return s[1..^1].Trim();
    }

    static List<string> SplitComma(string s)
    {
        var result = new List<string>();
        var cur = new StringBuilder();
        int depth = 0;
        foreach (var c in s)
        {
            if (c == '(') depth++;
            else if (c == ')') depth--;
            if (c == ',' && depth == 0) { result.Add(cur.ToString()); cur.Clear(); }
            else cur.Append(c);
        }
        if (cur.Length > 0) result.Add(cur.ToString());
        return result;
    }

    // Detect remaining patterns that need manual review (check after Convert())
    // @@ROWCOUNT → _rowcount + GET DIAGNOSTICS, @@ERROR → 0: both handled in ConvertBody
    public static bool HasUnhandledPatterns(string body) =>
        body.Contains("-- TODO:", StringComparison.OrdinalIgnoreCase);

    // True unhandleable: multi-resultset SP or CLR assembly
    public static bool IsTrueStub(string definition) =>
        Regex.IsMatch(definition, @"\bEXTERNAL\s+NAME\b", RegexOptions.IgnoreCase); // CLR
}
