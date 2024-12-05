const std = @import("std");

pub fn main() !void {
    var it = std.mem.split(u8, @embedFile("input"), "\n");
    var list = std.ArrayList([]const u8).init(std.heap.page_allocator);
    while (it.next()) |x| {
        if (x.len == 0) continue;
        const i = try std.heap.page_allocator.dupe(u8, x);
        try list.append(i);
    }
    var counter: usize = 0;
    var counter2: usize = 0;
    for (0..list.items.len) |index1| {
        for (0..list.items[index1].len) |index2| {
            for (0..3) |offset1| {
                for (0..3) |offset2| {
                    if (index1 < 3 and offset1 == 0) break;
                    if (index2 < 3 and offset2 == 0) continue;
                    if (index1 > list.items.len - 4 and offset1 == 2) break;
                    if (index2 > list.items[index1].len - 4 and offset2 == 2) continue;
                    if (list.items[index1][index2] == 'X') {
                        if (list.items[index1 + offset1 - 1][index2 + offset2 - 1] == 'M') {
                            if (list.items[index1 + offset1 * 2 - 2][index2 + offset2 * 2 - 2] == 'A') {
                                if (list.items[index1 + offset1 * 3 - 3][index2 + offset2 * 3 - 3] == 'S') {
                                    counter += 1;
                                }
                            }
                        }
                    }
                }
            }
            if (index1 > list.items.len - 3) continue;
            if (index2 > list.items[index1].len - 3) continue;
            if (list.items[index1][index2] == 'M') {
                if (list.items[index1 + 1][index2 + 1] == 'A') {
                    if (list.items[index1 + 2][index2 + 2] == 'S') {
                        if (list.items[index1][index2 + 2] == 'S') {
                            if (list.items[index1 + 2][index2] == 'M') {
                                counter2 += 1;
                            }
                        }
                        if (list.items[index1][index2 + 2] == 'M') {
                            if (list.items[index1 + 2][index2] == 'S') {
                                counter2 += 1;
                            }
                        }
                    }
                }
            }
            if (list.items[index1][index2] == 'S') {
                if (list.items[index1 + 1][index2 + 1] == 'A') {
                    if (list.items[index1 + 2][index2 + 2] == 'M') {
                        if (list.items[index1][index2 + 2] == 'S') {
                            if (list.items[index1 + 2][index2] == 'M') {
                                counter2 += 1;
                            }
                        }
                        if (list.items[index1][index2 + 2] == 'M') {
                            if (list.items[index1 + 2][index2] == 'S') {
                                counter2 += 1;
                            }
                        }
                    }
                }
            }
        }
    }
    std.debug.print("part1: {d}\n", .{counter});
    std.debug.print("part2: {d}\n", .{counter2});
}
