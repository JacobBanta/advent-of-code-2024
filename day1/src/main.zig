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
    std.debug.print("part1: {d}\n", .{counter});

    var counter2: u64 = 0;
    for (list1.items) |item| {
        if (std.sort.binarySearch(u32, item, list2.items, {}, order_u32)) |initialIndex| {
            var index = initialIndex;
            while (list2.items[index] == item) index -= 1;
            index += 1;
            while (list2.items[index] == item) {
                index += 1;
                counter2 += @intCast(item);
            }
        }
    }
    std.debug.print("part2: {d}\n", .{counter2});
}

const math = std.math;

fn order_u32(context: void, lhs: u32, rhs: u32) math.Order {
    _ = context;
    return math.order(lhs, rhs);
}
