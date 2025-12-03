const std = @import("std");

pub fn run() !void {
    std.debug.print("run\n", .{});

    const arr: []const u8 = @embedFile("input03.txt");
    var sum: u32 = 0;

    var it = std.mem.splitScalar(u8, arr, '\n');
    while (it.next()) |line| {
        if (line.len == 0) break;
        std.debug.print("{s}\n", .{line});
        const idx_left = std.mem.indexOfMax(u8, line[0 .. line.len - 1]);
        const left = line[idx_left] - '0';
        const idx_right = std.mem.indexOfMax(u8, line[idx_left + 1 .. line.len]);
        const right = line[idx_right + idx_left + 1] - '0';
        std.debug.print("idx_left={}, idx_right={}, left={}, right={}\n", .{ idx_left, idx_right, left, right });
        const v = 10 * left + right;
        sum += v;
    }
    std.debug.print("sum={}", .{sum});
}
