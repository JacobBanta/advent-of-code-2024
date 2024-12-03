const std = @import("std");
const Regex = @import("regex").Regex;

const input = @embedFile("input");

pub fn main() !void {
    var re = try Regex.compile(std.heap.page_allocator, "mul\\([0-9]{0,3},[0-9]{0,3}\\)");
    var counter: usize = 0;
    for (0..input.len) |n| {
        if (try re.match(input[n..]))
            counter += try func(input[n..]);
    }
    std.debug.print("part 1: {d}\n", .{counter});
}

fn func(line: []const u8) !usize {
    var it = std.mem.split(u8, line, ",");
    var v1: usize = 0;
    var v2: usize = 0;
    if (it.next()) |x| {
        v1 = try std.fmt.parseUnsigned(usize, x[4..], 0);
    }
    if (it.next()) |x| {
        var it2 = std.mem.split(u8, x, ")");
        if (it2.next()) |x2| {
            v2 = try std.fmt.parseUnsigned(usize, x2[0..], 0);
        }
    }
    return v1 * v2;
}
