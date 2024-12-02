const std = @import("std");

var counter = std.atomic.Value(usize).init(0);

pub fn main() !void {
    var it = std.mem.split(u8, @embedFile("input"), "\n");
    var pool: std.Thread.Pool = undefined;
    try pool.init(.{ .n_jobs = 16, .allocator = std.heap.page_allocator });
    defer pool.deinit();
    while (it.next()) |x| {
        try pool.spawn(func, .{x});
        _ = counter.fetchAdd(1, .monotonic);
    }
    while (counter.fetchXor(0, .monotonic) != 0) {
        std.time.sleep(100 * std.time.ns_per_ms);
    }
}
fn func(line: []const u8) void {
    _ = line;
    std.time.sleep(std.time.ns_per_s);
    _ = counter.fetchSub(1, .monotonic);
}
