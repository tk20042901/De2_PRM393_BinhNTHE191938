param([switch]$Create)

$source = @'
using System;
using System.Runtime.InteropServices;

public static class NativeSqlite {
    [DllImport("winsqlite3.dll", CallingConvention = CallingConvention.Cdecl, CharSet = CharSet.Unicode, EntryPoint = "sqlite3_open16")]
    public static extern int Open(string filename, out IntPtr db);

    [DllImport("winsqlite3.dll", CallingConvention = CallingConvention.Cdecl, CharSet = CharSet.Unicode, EntryPoint = "sqlite3_prepare16_v2")]
    public static extern int Prepare(IntPtr db, string sql, int nBytes, out IntPtr statement, IntPtr tail);

    [DllImport("winsqlite3.dll", CallingConvention = CallingConvention.Cdecl, EntryPoint = "sqlite3_step")]
    public static extern int Step(IntPtr statement);

    [DllImport("winsqlite3.dll", CallingConvention = CallingConvention.Cdecl, EntryPoint = "sqlite3_column_text16")]
    public static extern IntPtr ColumnText(IntPtr statement, int column);

    [DllImport("winsqlite3.dll", CallingConvention = CallingConvention.Cdecl, EntryPoint = "sqlite3_finalize")]
    public static extern int FinalizeStatement(IntPtr statement);

    [DllImport("winsqlite3.dll", CallingConvention = CallingConvention.Cdecl, EntryPoint = "sqlite3_close")]
    public static extern int Close(IntPtr db);

    [DllImport("winsqlite3.dll", CallingConvention = CallingConvention.Cdecl, EntryPoint = "sqlite3_errmsg16")]
    public static extern IntPtr ErrorMessage(IntPtr db);
}
'@

Add-Type -TypeDefinition $source
$path = Join-Path $PSScriptRoot 'assets\database\exam.db'
$database = [IntPtr]::Zero
$code = [NativeSqlite]::Open($path, [ref]$database)
if ($code -ne 0) { throw "Could not open database: $code" }

function Invoke-Sql([string]$sql, [int]$columns) {
    $statement = [IntPtr]::Zero
    $result = [NativeSqlite]::Prepare($database, $sql, -1, [ref]$statement, [IntPtr]::Zero)
    if ($result -ne 0) { throw [Runtime.InteropServices.Marshal]::PtrToStringUni([NativeSqlite]::ErrorMessage($database)) }
    try {
        while (($result = [NativeSqlite]::Step($statement)) -eq 100) {
            $values = for ($i = 0; $i -lt $columns; $i++) {
                [Runtime.InteropServices.Marshal]::PtrToStringUni([NativeSqlite]::ColumnText($statement, $i))
            }
            Write-Output ($values -join ' | ')
        }
        if ($result -ne 101) { throw [Runtime.InteropServices.Marshal]::PtrToStringUni([NativeSqlite]::ErrorMessage($database)) }
    } finally {
        [void][NativeSqlite]::FinalizeStatement($statement)
    }
}

try {
    if ($Create) {
        Invoke-Sql 'CREATE TABLE IF NOT EXISTS expense (id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT NOT NULL, category TEXT NOT NULL, amount INTEGER NOT NULL, date TEXT NOT NULL)' 0
    }
    Invoke-Sql "SELECT name, sql FROM sqlite_master WHERE type = 'table' ORDER BY name" 2
    Invoke-Sql 'PRAGMA integrity_check' 1
} finally {
    [void][NativeSqlite]::Close($database)
}
