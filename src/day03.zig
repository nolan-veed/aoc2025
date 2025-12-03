const std = @import("std");

pub fn run() !void {
    std.debug.print("run\n", .{});

    const arr: []const u8 = @embedFile("input03.txt");
    var sum: u64 = 0;
    const part1 = false;

    var it = std.mem.splitScalar(u8, arr, '\n');
    while (it.next()) |line| {
        if (line.len == 0) break;
        std.debug.print("{s}\n", .{line});
        if (part1) {
            const idx_left = std.mem.indexOfMax(u8, line[0 .. line.len - 1]);
            const left = line[idx_left] - '0';
            const start_idx = idx_left + 1;
            const idx_right = std.mem.indexOfMax(u8, line[start_idx..line.len]);
            const right = line[start_idx + idx_right] - '0';
            std.debug.print("idx_left={}, idx_right={}, left={}, right={}\n", .{ idx_left, idx_right, left, right });
            const v = 10 * left + right;
            sum += v;
        } else {
            var num_digs: u8 = 0;
            var start_idx: usize = 0;
            var v: u64 = 0;
            while (num_digs < 12) : (num_digs += 1) {
                const num_left = 12 - num_digs - 1;
                const end = line.len - num_left;
                const idx = std.mem.indexOfMax(u8, line[start_idx..end]);
                const d = line[start_idx + idx] - '0';
                start_idx += idx + 1;
                // std.debug.print("d={}\n", .{d});
                const p = std.math.pow(u64, 10, 11 - num_digs);
                v += d * p;
            }
            sum += v;
        }
    }
    std.debug.print("sum={}", .{sum});
}
