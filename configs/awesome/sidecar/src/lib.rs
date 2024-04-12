use std::fmt::Display;

use mlua::lua_module as module;
use mlua::{Error, IntoLua, Lua, Table, Value};

type LuaResult<T> = Result<T, Error>;

fn cwd(_lua: &Lua, args: (i32,)) -> LuaResult<String> {
    let cwd = procinfo::pid::cwd(args.0)?;
    let str = cwd
        .to_str()
        .ok_or_else(|| Error::DeserializeError("Path was not valid UTF-8".to_owned()))?;
    Ok(str.to_owned())
}

#[derive(Debug, Clone, serde::Serialize, serde::Deserialize)]
struct Stat {
    pid: i32,
    ppid: i32,
    pgrp: i32,
    session: i32,
    tty_nr: i32,
    tty_pgrp: i32,
    flags: u32,
    command: String,
    state: String,
}

impl<'a> IntoLua<'a> for Stat {
    fn into_lua(self, lua: &'a Lua) -> LuaResult<Value<'a>> {
        let res = lua.create_table_with_capacity(0, 9)?;

        res.set("pid", self.pid)?;
        res.set("ppid", self.ppid)?;
        res.set("pgrp", self.pgrp)?;
        res.set("session", self.session)?;
        res.set("tty_nr", self.tty_nr)?;
        res.set("tty_pgrp", self.tty_pgrp)?;
        res.set("flags", self.flags)?;
        res.set("command", self.command)?;
        res.set("state", self.state)?;

        Ok(Value::Table(res))
    }
}

struct State(procinfo::pid::State);

impl Display for State {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        use procinfo::pid::State;
        write!(
            f,
            "{}",
            match self.0 {
                State::Running => "running",
                State::Sleeping => "sleeping",
                State::Waiting => "waiting",
                State::Zombie => "zombie",
                State::Stopped => "stopped",
                State::TraceStopped => "trace_stopped",
                State::Paging => "paging",
                State::Dead => "dead",
                State::Wakekill => "wake_kill",
                State::Waking => "waking",
                State::Parked => "parked",
            }
        )
    }
}

fn stat(_lua: &Lua, (pid,): (i32,)) -> LuaResult<Stat> {
    let stat = procinfo::pid::stat(pid)?;
    Ok(Stat {
        pid: stat.pid,
        ppid: stat.ppid,
        pgrp: stat.pgrp,
        session: stat.session,
        tty_nr: stat.tty_nr,
        tty_pgrp: stat.tty_pgrp,
        flags: stat.flags,
        command: stat.command,
        state: State(stat.state).to_string(),
    })
}

#[module]
fn sidecar<'a>(lua: &'a Lua) -> LuaResult<Table<'a>> {
    let exports = lua.create_table()?;

    exports.set("cwd", lua.create_function(cwd)?)?;
    exports.set("stat", lua.create_function(stat)?)?;

    Ok(exports)
}
