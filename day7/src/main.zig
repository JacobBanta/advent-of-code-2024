const std = @import("std");

var threadCounter = std.atomic.Value(usize).init(0);
var counter = std.atomic.Value(usize).init(0);
var counter2 = std.atomic.Value(usize).init(0);

pub fn main() !void {
    var lines = std.mem.split(u8, @embedFile("input"), "\n");
    var pool: std.Thread.Pool = undefined;
    try pool.init(.{ .n_jobs = 16, .allocator = std.heap.page_allocator });
    defer pool.deinit();
    while (lines.next()) |line| {
        if (line.len == 0) continue;
        _ = threadCounter.fetchAdd(1, .acq_rel);
        try pool.spawn(func, .{line});
    }
    while (threadCounter.fetchXor(0, .acq_rel) != 0) {
        std.time.sleep(100 * std.time.ns_per_ms);
    }
    std.debug.print("part1: {d}\n", .{counter.fetchAdd(0, .monotonic)});
    std.debug.print("part2: {d}\n", .{counter2.fetchAdd(0, .monotonic)});
}
fn func(line: []const u8) void {
    defer _ = threadCounter.fetchSub(1, .acq_rel);
    var sections = std.mem.split(u8, line, ":");
    var testValue: usize = 0;
    if (sections.next()) |left| {
        testValue = std.fmt.parseUnsigned(usize, left, 0) catch unreachable;
    }
    var operands = std.mem.split(u8, sections.next().?, " ");
    var numbers = std.ArrayList(usize).init(std.heap.page_allocator);
    defer numbers.deinit();
    while (operands.next()) |n| {
        if (n.len == 0) continue;
        numbers.append(std.fmt.parseUnsigned(usize, n, 0) catch unreachable) catch unreachable;
    }
    for (0..std.math.pow(usize, 2, numbers.items.len - 1)) |attempt| {
        var total = numbers.items[0];
        for (0..numbers.items.len - 1) |index| {
            if ((attempt >> @intCast(index)) & 1 == 1) {
                total *= numbers.items[index + 1];
            } else {
                total += numbers.items[index + 1];
            }
        }
        if (total == testValue) {
            _ = counter.fetchAdd(total, .monotonic);
            break;
        }
    }
    for (0..std.math.pow(usize, 3, numbers.items.len - 1)) |attempt| {
        var total = numbers.items[0];
        for (0..numbers.items.len - 1) |index| {
            if (@divFloor(attempt, std.math.pow(usize, 3, index)) % 3 == 1) {
                total *= numbers.items[index + 1];
            } else if (@divFloor(attempt, std.math.pow(usize, 3, index)) % 3 == 2) {
                total += numbers.items[index + 1];
            } else {
                var digits: usize = 0;
                var n = numbers.items[index + 1];
                if (n == 0) digits = 1;
                while (n != 0) {
                    n = @divFloor(n, 10);
                    digits += 1;
                }
                total = total * std.math.pow(usize, 10, digits) + numbers.items[index + 1];
            }
        }
        if (total == testValue) {
            _ = counter2.fetchAdd(total, .monotonic);
            return;
        }
    }
}
