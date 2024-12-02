const std = @import("std");

pub fn main() !void {
    var it = std.mem.split(u8, @embedFile("input"), "\n");
    var list1 = std.ArrayList(u32).init(std.heap.page_allocator);
    var list2 = std.ArrayList(u32).init(std.heap.page_allocator);
    while (it.next()) |x| {
        if (x.len == 0) continue;
        try list1.append(try std.fmt.parseUnsigned(u32, x[0..5], 0));
        try list2.append(try std.fmt.parseUnsigned(u32, x[8..13], 0));
    }
    std.sort.heap(u32, list1.items, {}, std.sort.asc(u32));
    std.sort.heap(u32, list2.items, {}, std.sort.asc(u32));
    var counter: u64 = 0;
    for (0..list1.items.len) |index| {
        if (list1.items[index] < list2.items[index]) {
            counter += @intCast(list2.items[index] - list1.items[index]);
        }
        if (list1.items[index] > list2.items[index]) {
            counter += @intCast(list1.items[index] - list2.items[index]);
        }
    }
    std.debug.print("{d}\n", .{counter});
}
