#include "share/atspre_define.hats"
#include "share/atspre_staload.hats"

absvt@ype sqlite3_ptr(l:addr) = $extype "sqlite3*"
vtypedef sqlite3_ptr0 = [l:addr] sqlite3_ptr(l)
vtypedef sqlite3_ptr1 = [l:addr | l > null] sqlite3_ptr(l)
absvt@ype sqlite3_stmt(l:addr) = $extype "sqlite3_stmt*"
vtypedef sqlite3_stmt0 = [l:addr] sqlite3_stmt(l)
vtypedef sqlite3_stmt1 = [l:addr | l > null] sqlite3_stmt(l)
typedef callback = [n:int;l,l2:addr] (!ptr,int(n),!arrayptr(string,l,n),!arrayptr(string,l2,n)) -> int
macdef SQLITE_ROW = $extval(int, "SQLITE_ROW")
macdef SQLITE_OK = $extval(int, "SQLITE_OK")
macdef SQLITE_ERROR = $extval(int, "SQLITE_ERROR")

castfn sqlite3_ptr2ptr{l:addr}(!sqlite3_ptr(l)): ptr
overload ptrcast with sqlite3_ptr2ptr
// stadef SQLITE_ROW = 100
// stadef SQLITE_OK = 0

// datavtype // covariance
// or_vt0ype_bool_vt0ype (a:vt@ype+, b:vt@ype+, opt: bool) = 
// | right(a, b, true) of a | left(a, b, false) of b
// stadef or_vt = or_vt0ype_bool_vt0ype
// praxi
// orvt_right{a,b:vt0p}
//   (x: !or_vt(a, b, true) >> a):<prf> void
// praxi
// orvt_left{a,b:vt0p}
//   (x: !or_vt(a, b, false) >> b):<prf> void
typedef constchar = $extype "const char*"
castfn constchar2string(!constchar): string

fn open(filename: string, db: &sqlite3_ptr0? >> sqlite3_ptr1): int = "mac#sqlite3_open"
fn close{l:addr}(db: !sqlite3_ptr1 >> sqlite3_ptr0?): int = "mac#sqlite3_close"
fn sqlite3_free(p: strptr): void = "mac#"
fn prepare{l:addr}(db: !sqlite3_ptr1, sql: string, len: int, &sqlite3_stmt0? >> sqlite3_stmt1, pzTail: ptr): int = "mac#sqlite3_prepare"
fn step(stmt: !sqlite3_stmt1): int = "mac#sqlite3_step"
fn finalize(stmt: !sqlite3_stmt1 >> sqlite3_stmt0?): int = "mac#sqlite3_finalize"
fn column_text{n:nat}(!sqlite3_stmt1, i: int(n)): constchar = "mac#sqlite3_column_text"
fn bind_text(stmt: !sqlite3_stmt1, idx: int, string, int, ptr): int = "mac#sqlite3_bind_text"
fn bind_int(stmt: !sqlite3_stmt1, idx: int, int): int = "mac#sqlite3_bind_int"

fn{a:vt@ype} to_type(name: string, value: string): a 