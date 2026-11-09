use jiff::civil::DateTime;
use std::{
    cmp::Ordering,
    num::NonZeroU8,
    path::{Path, PathBuf},
    string::{self, ParseError},
    sync::MutexGuard,
    time::Duration,
};

pub type TaskId = String;

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct TodoState {
    pub keyword: String, // TODO, PLANNING, STARTED, DONE, OBSOLETE, WONT-DO
    pub kind: String,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum TodoKind {
    // Used only for Fangdoro for better task tracking
    Active,
    Done,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord)]
pub enum Priority {
    A,
    B,
    C,
}

#[derive(Debug, Clone, PartialEq, Eq)]
// path for org file???
pub struct SourceRef {
    pub file: PathBuf,
    pub line: u32,
    pub outline_path: Vec<String>, // ["Projects", "Fangdoro", "Parser"]
}

// Where to put this?
// pub fn load_tasks(path: Path) -> Result<Vec<OrgTask>, FangdoroError> {
//     todo!()
// }

// pub fn load_config(path: Path) -> Result<AppConfig, ConfigError> {
//     todo!()
// }

#[derive(Debug, Clone, PartialEq, Eq)]
// Sets up when a task should start, when I should finish it
// and when a task has been closed/finished
pub struct Planning {
    pub scheduled: Option<DateTime>,
    pub deadline: Option<DateTime>,
    pub closed: Option<DateTime>,
}

#[derive(Debug, Clone, PartialEq, Eq)]
// Sets up focus and break duration, how many slices
// and if it autostarts the next slice
pub struct PomodoroPlan {
    pub focus: Duration,
    pub break_time: Duration,
    pub slices: NonZeroU8,
    pub autostart_next: bool,
}

pub fn user_input_parse(input: &str) -> Duration {
    // let mut time = input.lines();
    let i = input.trim();
    let Some((x, y)) = i.split_once(":") else {
        panic!("Some error!")
    };
    let m: u64 = x.parse::<u64>().unwrap() * 60 + y.parse::<u64>().unwrap();
    let s: u64 = m * 60;
    let dur = Duration::from_secs(s);
    println!("{s}");
    dur
}

pub fn display_duration(time: Duration) -> (u64, u64) {
    let minutes: u64 = time.as_secs() / 60;
    let hours: u64 = minutes / 60;
    // format!("{0}:{1}", hours, minutes)
    (hours, minutes)
}

impl PomodoroPlan {
    pub fn new(focus_d: Duration, break_d: Duration, slices: u8) -> Option<Self> {
        let Some(s) = NonZeroU8::new(slices) else {
            return None;
        };
        Some(Self {
            focus: focus_d,
            break_time: break_d,
            slices: s,
            autostart_next: false,
        })
    }

    pub fn plan(&self) {
        let (f_h, f_m) = display_duration(self.focus);
        let (b_h, b_m) = display_duration(self.break_time);
        println!(
            "Focus time: {0}:{1}\n Break time: {2}:{3}\n Work slices: {4}\n Autostart: {5}",
            f_h, f_m, b_h, b_m, self.slices, self.autostart_next
        );
    }
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct OrgTask {
    pub id: Option<TaskId>,
    pub title: String,
    pub state: TodoState,
    pub priority: Option<Priority>,
    pub tags: Vec<String>,
    pub created: Option<DateTime>,
    pub planning: Planning,
    pub source: SourceRef,
    pub plan: Option<PomodoroPlan>, // overrides user's default plan
}

impl OrgTask {
    pub fn parse_tasks(input: &str) -> Result<Vec<OrgTask>, ParseError> {
        todo!()
    }
    pub fn effective_plan(task: &OrgTask, defaults: &PomodoroPlan) -> PomodoroPlan {
        todo!()
    }
    pub fn actionable_tasks(tasks: &[OrgTask]) -> Vec<&OrgTask> {
        todo!()
    }
    pub fn compare_tasks(a: &OrgTask, b: &OrgTask) -> Ordering {
        todo!()
    }
}
