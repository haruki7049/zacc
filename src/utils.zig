const std = @import("std");
const testing = std.testing;
const ascii = std.ascii;

pub fn is_ident(c: u8) bool {
    if (ascii.isAlphanumeric(c)) {
        return true;
    }
    return switch (c) {
        '_', '.', '$' => true,
        else => false,
    };
}

test "is_ident" {
    const five = '5';
    const underbar = '_';
    const dot = '.';
    const dollar = '$';

    try testing.expectEqual(true, is_ident(five));
    try testing.expectEqual(true, is_ident(underbar));
    try testing.expectEqual(true, is_ident(dot));
    try testing.expectEqual(true, is_ident(dollar));
}
