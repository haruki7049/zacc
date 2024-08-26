/// keyword codes
pub const keywords = enum(u4) {
    TOKEN = 0,
    LEFT = 1,
    RIGHT = 2,
    NONASSOC = 3,
    MARK = 4,
    TEXT = 5,
    TYPE = 6,
    START = 7,
    UNION = 8,
    IDENT = 9,
    EXPECT = 10,
};

/// symbol classes
pub const symbol = enum(u2) {
    UNKNOWN = 0,
    TERM = 1,
    NONTERM = 2,
};

/// the structure of the LR(0) state machine
pub const core = struct {
    next: *core,
    link: *core,
    number: u16,
    accessing_symbol: u16,
    nitems: u16,
    items: []u16,
};

/// the structure used to record shifts
pub const shifts = struct {
    next: *shifts,
    number: u16,
    nshifts: u16,
    shift: []u16,
};

/// the structure used to store reductions
pub const reductions = struct {
    next: *reductions,
    number: u16,
    nreds: u16,
    rules: []u16,
};

/// the structure used to represent parser actions
pub const action = struct {
    next: *action,
    symbol: u16,
    number: u16,
    prec: u16,
    action_code: u8,
    assoc: u8,
    suppressed: u8,
};
