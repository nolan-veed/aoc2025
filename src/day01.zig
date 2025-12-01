const std = @import("std");

pub fn run() !void {
    std.debug.print("run\n", .{});

    const f = try std.fs.cwd().openFile("input01.txt", .{ .mode = .read_only });
    defer f.close();
    var read_buffer: [1024]u8 = undefined;
    var fr = f.reader(&read_buffer);
    var reader = &fr.interface;

    var v: i32 = 50;
    var count: i32 = 0;
    var count_crossings: i32 = 0;

    while (true) {
        const line = try reader.takeDelimiter('\n') orelse "";
        if (line.len == 0)
            break;
        std.debug.print("{s}\n", .{line});

        const x = std.fmt.parseInt(i32, line[1..], 10) catch unreachable;
        const lr = line[0];
        const start = v;
        if (lr == 'L') {
            v -= x;
        } else {
            v += x;
        }
        const end = v;
        v = @mod(v, 100);
        if (end > 100) {
            count_crossings += 1;
            const extra = end - 100;
            const times = @divTrunc(extra - 1, 100);
            count_crossings += times;
        } else if (end < 0) {
            if (start > 0)
                count_crossings += 1;
            const extra = -end;
            const times = @divTrunc(extra - 1, 100);
            count_crossings += times;
        }
        if (v == 0)
            count += 1;
        std.debug.print("v: {} count: {} count_crossings: {}\n", .{ v, count, count_crossings });
    }
    std.debug.print("part1: {}\n", .{count});
    std.debug.print("part2: {}\n", .{count + count_crossings});
}
