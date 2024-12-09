//!save yourself now, before its too late
const std = @import("std");

pub fn main() !void {
    var it = std.mem.split(u8, @embedFile("input"), "\n");
    var board = std.ArrayList([]const u8).init(std.heap.page_allocator);
    var antinodes = std.ArrayList([]bool).init(std.heap.page_allocator);
    var harmonics = std.ArrayList([]bool).init(std.heap.page_allocator);
    while (it.next()) |x| {
        if (x.len == 0) continue;
        try board.append(x);
        try antinodes.append(try std.heap.page_allocator.alloc(bool, x.len));
        try harmonics.append(try std.heap.page_allocator.alloc(bool, x.len));
    }
    for ('a'..'z' + 1) |letter| {
        for (board.items, 0..) |line, lindex1| {
            for (line, 0..) |char, cindex1| {
                if (char == letter) {
                    for (board.items, 0..) |line2, lindex2| {
                        for (line2, 0..) |char2, cindex2| {
                            if (char2 == letter) {
                                if (lindex1 != lindex2 and cindex1 != cindex2) {
                                    const ldiff: isize = @as(isize, @intCast(lindex1)) - @as(isize, @intCast(lindex2));
                                    const cdiff: isize = @as(isize, @intCast(cindex1)) - @as(isize, @intCast(cindex2));
                                    for (0..std.math.maxInt(usize)) |multiplier| {
                                        const lindex3 = @as(isize, @intCast(lindex1)) + ldiff * @as(isize, @intCast(multiplier));
                                        const cindex3 = @as(isize, @intCast(cindex1)) + cdiff * @as(isize, @intCast(multiplier));
                                        if (lindex3 >= 0 and lindex3 < board.items.len and cindex3 >= 0 and cindex3 < line.len) {
                                            harmonics.items[@intCast(lindex3)][@intCast(cindex3)] = true;
                                        } else {
                                            break;
                                        }
                                    }
                                    const lindex3 = @as(isize, @intCast(lindex1)) + ldiff;
                                    const cindex3 = @as(isize, @intCast(cindex1)) + cdiff;
                                    if (lindex3 >= 0 and lindex3 < board.items.len and cindex3 >= 0 and cindex3 < line.len) {
                                        antinodes.items[@intCast(lindex3)][@intCast(cindex3)] = true;
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    for ('A'..'Z' + 1) |letter| {
        for (board.items, 0..) |line, lindex1| {
            for (line, 0..) |char, cindex1| {
                if (char == letter) {
                    for (board.items, 0..) |line2, lindex2| {
                        for (line2, 0..) |char2, cindex2| {
                            if (char2 == letter) {
                                if (lindex1 != lindex2 and cindex1 != cindex2) {
                                    const ldiff: isize = @as(isize, @intCast(lindex1)) - @as(isize, @intCast(lindex2));
                                    const cdiff: isize = @as(isize, @intCast(cindex1)) - @as(isize, @intCast(cindex2));
                                    for (0..std.math.maxInt(usize)) |multiplier| {
                                        const lindex3 = @as(isize, @intCast(lindex1)) + ldiff * @as(isize, @intCast(multiplier));
                                        const cindex3 = @as(isize, @intCast(cindex1)) + cdiff * @as(isize, @intCast(multiplier));
                                        if (lindex3 >= 0 and lindex3 < board.items.len and cindex3 >= 0 and cindex3 < line.len) {
                                            harmonics.items[@intCast(lindex3)][@intCast(cindex3)] = true;
                                        } else {
                                            break;
                                        }
                                    }
                                    const lindex3 = @as(isize, @intCast(lindex1)) + ldiff;
                                    const cindex3 = @as(isize, @intCast(cindex1)) + cdiff;
                                    if (lindex3 >= 0 and lindex3 < board.items.len and cindex3 >= 0 and cindex3 < line.len) {
                                        antinodes.items[@intCast(lindex3)][@intCast(cindex3)] = true;
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    for ('0'..'9' + 1) |letter| {
        for (board.items, 0..) |line, lindex1| {
            for (line, 0..) |char, cindex1| {
                if (char == letter) {
                    for (board.items, 0..) |line2, lindex2| {
                        for (line2, 0..) |char2, cindex2| {
                            if (char2 == letter) {
                                if (lindex1 != lindex2 and cindex1 != cindex2) {
                                    const ldiff: isize = @as(isize, @intCast(lindex1)) - @as(isize, @intCast(lindex2));
                                    const cdiff: isize = @as(isize, @intCast(cindex1)) - @as(isize, @intCast(cindex2));
                                    for (0..std.math.maxInt(usize)) |multiplier| {
                                        const lindex3 = @as(isize, @intCast(lindex1)) + ldiff * @as(isize, @intCast(multiplier));
                                        const cindex3 = @as(isize, @intCast(cindex1)) + cdiff * @as(isize, @intCast(multiplier));
                                        if (lindex3 >= 0 and lindex3 < board.items.len and cindex3 >= 0 and cindex3 < line.len) {
                                            harmonics.items[@intCast(lindex3)][@intCast(cindex3)] = true;
                                        } else {
                                            break;
                                        }
                                    }
                                    const lindex3 = @as(isize, @intCast(lindex1)) + ldiff;
                                    const cindex3 = @as(isize, @intCast(cindex1)) + cdiff;
                                    if (lindex3 >= 0 and lindex3 < board.items.len and cindex3 >= 0 and cindex3 < line.len) {
                                        antinodes.items[@intCast(lindex3)][@intCast(cindex3)] = true;
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    var counter: usize = 0;
    for (antinodes.items) |line| {
        for (line) |node| {
            if (node) counter += 1;
        }
    }
    std.debug.print("part1: {d}\n", .{counter});
    var counter2: usize = 0;
    for (harmonics.items) |line| {
        for (line) |node| {
            if (node) counter2 += 1;
        }
    }
    std.debug.print("part2: {d}\n", .{counter2});
}
