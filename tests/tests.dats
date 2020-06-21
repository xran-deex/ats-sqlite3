#include "../ats-sqlite3.hats"
staload "libats/SATS/stringbuf.sats"
staload _ = "libats/DATS/stringbuf.dats"

staload $SQLITE

fun print_query_result{l:agz}(stmt: !sqlite3_stmt(l)): void = {
    val ret = step(stmt)
    val () = if ret = SQLITE_ROW then {
        val () = println!(constchar2string(column_text(stmt, 0)), ", ", constchar2string(column_text(stmt, 1)))
        val () = print_query_result(stmt)
    }
}

vtypedef Thing = @{
    name = strptr,
    age = int
}

implement stmt_to_type<Thing>(stmt) = res where {
    val name = copy(constchar2string(column_text(stmt, 0)))
    val age = constchar2string(column_text(stmt, 1))
    val res = @{
        name = name,
        age = g0string2int(age)
    }
}

fn insert_thing(db: !sqlite3_ptr1, t: !Thing): void = {
    var stmt: sqlite3_stmt0?
    val sql = "insert into Thing (name, age) values (?1, ?2)"
    val res = prepare(db, sql, sz2i (length(sql)), stmt, the_null_ptr)
    val _ = bind_text(stmt, 1, $UNSAFE.castvwtp1{string}t.name, ~1, the_null_ptr)
    val _ = bind_int(stmt, 2, t.age)
    val _ = step(stmt)
    val _ = finalize(stmt)
}

val CREATE_TABLE = "
CREATE TABLE IF NOT EXISTS Thing (name text, age int);
"

implement main(argc, argv) = 0 where {
    var db: sqlite3_ptr0?
    val res = open("test.db", db)
    val () = if res = SQLITE_OK then {
        var stmt: sqlite3_stmt0?
        val res = prepare(db, CREATE_TABLE, sz2i(length(CREATE_TABLE)), stmt, the_null_ptr)
        val _ = finalize(stmt)
        val sql = "select * from Thing where age > ?1 and name = ?2"
        val res = prepare(db, sql, sz2i(length(sql)), stmt, the_null_ptr)
        val () = if res = SQLITE_OK then {
            val _ = bind_int(stmt, 1, 20)
            val _ = bind_text(stmt, 2, "Joe", sz2i(length("Joe")), the_null_ptr)
            val () = print_query_result(stmt)
            val _ = finalize(stmt)
        } else {
            val _ = finalize(stmt)
        }

        val th: Thing = @{
            name = copy("Lauren"),
            age = 35
        }

        val () = insert_thing(db, th)

        val () = free(th.name)

        val ls = query_to_list<Thing>(db, "select * from Thing")
        val () = list_vt_foreach(ls) where {
            implement list_vt_foreach$fwork<Thing><void>(t, e) = {
                val () = println!("Thing: name=", t.name, ", age=", t.age)
            }
        }
        val () = list_vt_freelin(ls) where {
            implement list_vt_freelin$clear<Thing>(t) = {
                val () = strptr_free(t.name)
            }
        }
        val _ = close(db)
    } else {
        val _ = close(db)
    }
}

