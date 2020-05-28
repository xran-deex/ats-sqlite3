#include "./../HATS/includes.hats"
#define ATS_DYNLOADFLAG 0
staload "./../SATS/sqlite.sats"

implement {a} query_to_list(db, sql) = result where {
    val tmp = list_vt_nil()
    var stmt: sqlite3_stmt0?
    val res = prepare(db, sql, sz2i(length(sql)), stmt, the_null_ptr)
    val result = (if res = SQLITE_OK then result where {
        fun loop{l:agz}{n:nat}(stmt: !sqlite3_stmt(l), ls: list_vt(a, n)): List_vt(a) = res where {
            val ret = step(stmt)
            val res = (if ret = SQLITE_ROW then res where {
                val x = stmt_to_type<a>(stmt)
                val newls = list_vt_cons(x, ls)
                val res = loop(stmt, newls)
            } else ls): List_vt(a)
        }
        val result = loop(stmt, tmp)
        val _ = finalize(stmt)
    } else result where {
        val _ = finalize(stmt)
        val result = tmp
    }): List_vt(a)
}