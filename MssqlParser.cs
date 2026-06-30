using System.Text;
using System.Text.RegularExpressions;

namespace pg_converter_ui;

public static class MssqlParser
{
    public static List<DbObject> ParseFile(string path)
    {
        var text = File.ReadAllText(path, Encoding.UTF8).TrimStart('﻿');
        var blocks = Regex.Split(text, @"(?m)^\s*GO\s*$")
            .Select(b => b.Trim())
            .Where(b => b.Length > 10)
            .ToList();

        var result = new List<DbObject>();
        foreach (var block in blocks)
        {
            var obj = TryParse(block);
            if (obj != null) result.Add(obj);
        }
        return result;
    }

    static DbObject? TryParse(string block)
    {
        // Stored Procedure
        var m = Regex.Match(block,
            @"(?:CREATE\s+OR\s+ALTER|ALTER|CREATE)\s+(?:PROCEDURE|PROC)\s+(?:\[?dbo\]?\.)?\[?(\w+)\]?",
            RegexOptions.IgnoreCase);
        if (m.Success)
        {
            var name = m.Groups[1].Value;
            var complex = IsComplex(block);
            return new DbObject(name, ObjectType.Procedure, block, complex, complex ? "STUB" : "OK");
        }

        // Function
        m = Regex.Match(block,
            @"(?:CREATE\s+OR\s+ALTER|ALTER|CREATE)\s+FUNCTION\s+(?:\[?dbo\]?\.)?\[?(\w+)\]?",
            RegexOptions.IgnoreCase);
        if (m.Success)
        {
            var name = m.Groups[1].Value;
            var complex = IsComplex(block);
            return new DbObject(name, ObjectType.Function, block, complex, complex ? "STUB" : "OK");
        }

        // View
        m = Regex.Match(block,
            @"(?:CREATE\s+OR\s+ALTER|ALTER|CREATE)\s+VIEW\s+(?:\[?dbo\]?\.)?\[?(\w+)\]?",
            RegexOptions.IgnoreCase);
        if (m.Success)
        {
            return new DbObject(m.Groups[1].Value, ObjectType.View, block, false, "OK");
        }

        // Table
        m = Regex.Match(block, @"CREATE\s+TABLE\s+(?:\[?dbo\]?\.)?\[?(\w+)\]?", RegexOptions.IgnoreCase);
        if (m.Success)
            return new DbObject(m.Groups[1].Value, ObjectType.Table, block, false, "OK");

        // Standalone constraint
        m = Regex.Match(block,
            @"ALTER\s+TABLE\s+(?:\[?dbo\]?\.)?\[?(\w+)\]?\s+(?:WITH\s+CHECK\s+)?ADD\s+CONSTRAINT\s+\[?(\w+)\]?",
            RegexOptions.IgnoreCase);
        if (m.Success)
            return new DbObject(m.Groups[2].Value, ObjectType.Constraint, block, false, "OK");

        // Index
        m = Regex.Match(block,
            @"CREATE\s+(?:UNIQUE\s+)?(?:CLUSTERED\s+|NONCLUSTERED\s+)?INDEX\s+\[?(\w+)\]?",
            RegexOptions.IgnoreCase);
        if (m.Success)
            return new DbObject(m.Groups[1].Value, ObjectType.Index, block, false, "OK");

        return null;
    }

    static bool IsComplex(string block) => BodyConverter.IsTrueStub(block);

    public static List<DbObject> Search(
        List<DbObject> all, string pattern,
        bool inclFunc, bool inclTable, bool inclIndex)
    {
        var rx = BuildRegex(pattern.Trim());
        return all.Where(o =>
        {
            if (!inclFunc  && (o.Type == ObjectType.Function || o.Type == ObjectType.Procedure || o.Type == ObjectType.View)) return false;
            if (!inclTable && o.Type == ObjectType.Table)    return false;
            if (!inclIndex && (o.Type == ObjectType.Index || o.Type == ObjectType.Constraint)) return false;
            return rx.IsMatch(o.Name);
        }).ToList();
    }

    static Regex BuildRegex(string pattern)
    {
        if (string.IsNullOrWhiteSpace(pattern)) return new Regex(".*");
        var p = Regex.Escape(pattern).Replace(@"\*", ".*").Replace(@"\?", ".");
        return new Regex(p, RegexOptions.IgnoreCase);
    }
}
