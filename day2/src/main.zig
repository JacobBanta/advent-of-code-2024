const std = @import("std");

var counter = std.atomic.Value(usize).init(0);
var correct = std.atomic.Value(usize).init(0);

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
    std.debug.print("part 1: {d}\n", .{correct.fetchAdd(0, .monotonic)});
}
fn func(line: []const u8) void {
    defer _ = counter.fetchSub(1, .acq_rel);
    var list = std.ArrayList(u32).init(std.heap.page_allocator);
    var it = std.mem.split(u8, line, " ");
    while (it.next()) |x| {
        if (x.len == 0) continue;
        list.append(std.fmt.parseUnsigned(u32, x, 0) catch return) catch {
            _ = correct.fetchAdd(1, .monotonic);
            return;
        };
    }
    const order = std.math.order(list.items[0], list.items[1]);
    for (0..list.items.len - 1) |index| {
        const newOrder = std.math.order(list.items[index], list.items[index + 1]);
        if (order != newOrder) return;
        if (order == .eq) return;
        if (order == .gt) {
            if (list.items[index] - list.items[index + 1] > 3) return;
        }
        if (order == .lt) {
            if (list.items[index + 1] - list.items[index] > 3) return;
        }
    }
    _ = correct.fetchAdd(1, .monotonic);
}
