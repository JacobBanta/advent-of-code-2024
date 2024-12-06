const std = @import("std");

pub fn main() !void {
    var lines = std.mem.split(u8, @embedFile("input"), "\n");
    var board = std.ArrayList([]u8).init(std.heap.page_allocator);
    while (lines.next()) |line| {
        if (line.len == 0) continue;

        try board.append(try std.heap.page_allocator.dupe(u8, line));
    }
    var pos: struct { x: usize, y: usize } = undefined;
    var dir: enum { north, east, south, west } = .north;
    for (board.items, 0..) |row, index1| {
        for (row, 0..) |char, index2| {
            if (char == '^') {
                pos = .{ .x = index2, .y = index1 };
            }
        }
    }
    var travelField = std.ArrayList([]bool).init(std.heap.page_allocator);
    for (board.items) |row| {
        try travelField.append(try std.heap.page_allocator.alloc(bool, row.len));
    }
    var hasBeen = travelField.items;
    for (0..hasBeen.len) |index| {
        for (0..hasBeen[index].len) |index2| {
            hasBeen[index][index2] = false;
        }
    }
    const startingPos = pos;
    var counter: usize = 0;
    var totalCounter: usize = 0;
    while (true) {
        if (!hasBeen[pos.y][pos.x]) {
            hasBeen[pos.y][pos.x] = true;
            counter += 1;
        }
        totalCounter += 1;
        var newPos = pos;
        if (pos.y == 0 and dir == .north) break;
        if (pos.x == 0 and dir == .west) break;
        switch (dir) {
            .north => newPos.y -= 1,
            .east => newPos.x += 1,
            .south => newPos.y += 1,
            .west => newPos.x -= 1,
        }
        if (newPos.y == board.items.len) break;
        if (newPos.x == board.items[0].len) break;

        if (board.items[newPos.y][newPos.x] == '#') {
            switch (dir) {
                .north => dir = .east,
                .east => dir = .south,
                .south => dir = .west,
                .west => dir = .north,
            }
        } else {
            pos = newPos;
        }
    }
    std.debug.print("part 1: {d}\n", .{counter});
    var counter2: usize = 0;
    for (0..board.items.len) |index| {
        for (0..board.items[index].len) |index2| {
            if (board.items[index][index2] == '.') {
                board.items[index][index2] = '#';
                if (try part2(startingPos, board)) {
                    counter2 += 1;
                }
                board.items[index][index2] = '.';
            }
        }
    }
    std.debug.print("part 2: {d}\n", .{counter2});
}

fn part2(startingPos: anytype, board: anytype) !bool {
    var pos = startingPos;
    var dir: enum { north, east, south, west } = .north;
    const Encounter = struct { pos: @TypeOf(pos), dir: @TypeOf(dir) };
    var encounters = std.ArrayList(Encounter).init(std.heap.page_allocator);
    defer encounters.deinit();

    while (true) {
        for (0..encounters.items.len) |index| {
            const e = encounters.items[index];

            if (e.pos.x == pos.x and e.pos.y == pos.y and e.dir == dir) {
                return true;
            }
        }
        try encounters.append(.{ .dir = dir, .pos = pos });
        var newPos = pos;
        if (pos.y == 0 and dir == .north) break;
        if (pos.x == 0 and dir == .west) break;
        switch (dir) {
            .north => newPos.y -= 1,
            .east => newPos.x += 1,
            .south => newPos.y += 1,
            .west => newPos.x -= 1,
        }
        if (newPos.y == board.items.len) break;
        if (newPos.x == board.items[0].len) break;

        if (board.items[newPos.y][newPos.x] == '#') {
            switch (dir) {
                .north => dir = .east,
                .east => dir = .south,
                .south => dir = .west,
                .west => dir = .north,
            }
        } else {
            pos = newPos;
        }
    }
    return false;
}
