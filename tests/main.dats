#include "../ats-sqlite.hats"

staload $SQLITE

fun print_query_result{l:agz}(stmt: !sqlite3_stmt(l)): void = {
    val ret = step(stmt)
    val () = if ret = SQLITE_ROW then {
        val () = println!(constchar2string(column_text(stmt, 0)), ", ", constchar2string(column_text(stmt, 1)))
        val () = print_query_result(stmt)
    }
}

implement main(argc, argv) = 0 where {
    var db: sqlite3_ptr0?
    val res = open("test.db", db)
    val () = if res = SQLITE_OK then {
        var stmt: sqlite3_stmt0?
        // val res = prepare(db, "select * from Thing", ~1, stmt, the_null_ptr)
        // val res = prepare(db, "select * from Thing where age > ?1", ~1, stmt, the_null_ptr)
        val sql = "select * from Thing where age > ?1 and name = ?2"
        val res = prepare(db, sql, sz2i(length(sql)), stmt, the_null_ptr)
        val () = if res = SQLITE_OK then {
            val _ = bind_int(stmt, 1, 20)
            val _ = bind_text(stmt, 2, "Joe", ~1, the_null_ptr)
            val () = print_query_result(stmt)
            val _ = finalize(stmt)
        } else {
            val _ = finalize(stmt)
        }
        val _ = close(db)
    } else {
        val _ = close(db)
    }
}

