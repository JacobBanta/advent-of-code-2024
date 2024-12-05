const std = @import("std");

pub fn main() !void {
    var lines = std.mem.split(u8, @embedFile("input"), "\n");
    var ruleLeft = std.ArrayList(u8).init(std.heap.page_allocator);
    var ruleRight = std.ArrayList(u8).init(std.heap.page_allocator);
    while (lines.next()) |line| {
        if (line.len == 0) break;
        try ruleLeft.append(try std.fmt.parseUnsigned(u8, line[0..2], 0));
        try ruleRight.append(try std.fmt.parseUnsigned(u8, line[3..5], 0));
    }
    var counter: usize = 0;
    var counter2: usize = 0;
    while (lines.next()) |line| {
        if (line.len == 0) continue;
        var numbers = std.mem.split(u8, line, ",");
        var update = std.ArrayList(u8).init(std.heap.page_allocator);
        while (numbers.next()) |number| {
            if (number.len == 0) continue;
            try update.append(try std.fmt.parseUnsigned(u8, number, 0));
        }
        var correct = true;
        outer: while (true) {
            for (0..update.items.len) |index| {
                for (index..update.items.len) |index2| {
                    for (ruleLeft.items, ruleRight.items) |left, right| {
                        if (left == update.items[index2] and right == update.items[index]) {
                            correct = false;
                            const temp = update.items[index];
                            update.items[index] = update.items[index2];
                            update.items[index2] = temp;

                            continue :outer;
                        }
                    }
                }
            }
            break;
        }
        if (correct) {
            counter += @intCast(update.items[@divFloor(update.items.len, 2)]);
        } else {
            counter2 += @intCast(update.items[@divFloor(update.items.len, 2)]);
        }
    }
    std.debug.print("part1: {d}\n", .{counter});
    std.debug.print("part2: {d}\n", .{counter2});
}
