const std = @import("std");

var counter = std.atomic.Value(usize).init(0);
var correct1 = std.atomic.Value(usize).init(0);
var correct2 = std.atomic.Value(usize).init(0);

pub fn main() !void {
    var it = std.mem.split(u8, @embedFile("input"), "\n");
    var pool: std.Thread.Pool = undefined;
    try pool.init(.{ .n_jobs = 16, .allocator = std.heap.page_allocator });
    defer pool.deinit();
    while (it.next()) |x| {
        if (x.len == 0) continue;
        try pool.spawn(func, .{x});
        _ = counter.fetchAdd(1, .acq_rel);
    }
    while (counter.fetchAdd(0, .monotonic) != 0) {
        std.time.sleep(100 * std.time.ns_per_ms);
    }
    std.debug.print("part 1: {d}\n", .{correct1.fetchAdd(0, .monotonic)});
    std.debug.print("part 2: {d}\n", .{correct2.fetchAdd(0, .monotonic)});
}
fn func(line: []const u8) void {
    defer _ = counter.fetchSub(1, .acq_rel);
    var list = std.ArrayList(u32).init(std.heap.page_allocator);
    var it = std.mem.split(u8, line, " ");
    while (it.next()) |x| {
        if (x.len == 0) continue;
        list.append(std.fmt.parseUnsigned(u32, x, 0) catch return) catch {
            return;
        };
    }
    if (isCorrect(list.items)) {
        _ = correct1.fetchAdd(1, .monotonic);
        _ = correct2.fetchAdd(1, .monotonic);
    } else {
        for (0..list.items.len) |index| {
            var newList = list.clone() catch return;
            _ = newList.orderedRemove(index);
            if (isCorrect(newList.items)) {
                _ = correct2.fetchAdd(1, .monotonic);
                return;
            }
        }
    }
}

fn isCorrect(items: []const u32) bool {
    const order = std.math.order(items[0], items[1]);
    for (0..items.len - 1) |index| {
        const newOrder = std.math.order(items[index], items[index + 1]);
        if (order != newOrder) return false;
        if (order == .eq) return false;
        if (order == .gt) {
            if (items[index] - items[index + 1] > 3) return false;
        }
        if (order == .lt) {
            if (items[index + 1] - items[index] > 3) return false;
        }
    }
    return true;
}
