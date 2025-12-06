const std = @import("std");

pub fn run() !void {
    std.debug.print("run\n", .{});

    const f = @embedFile("input06.txt");

    var it = std.mem.tokenizeScalar(u8, f[0..], '\n');

    var ops: [1024]u8 = undefined;
    var nums = [_]u64{0} ** 1024;
    var num_ops: usize = 0;
    {
        const line = it.next() orelse unreachable;
        var toks = std.mem.tokenizeScalar(u8, line, ' ');

        var i: usize = 0;
        while (toks.next()) |tok| : (i += 1) {
            std.debug.print("op={s}\n", .{tok});
            ops[i] = tok[0];
            if (ops[i] == '*')
                nums[i] = 1;
        }
        num_ops = i;
    }

    while (it.next()) |line| {
        var toks = std.mem.tokenizeScalar(u8, line, ' ');

        var i: usize = 0;
        while (toks.next()) |tok| : (i += 1) {
            const x = try std.fmt.parseInt(u32, tok, 10);
            std.debug.print("x={s}\n", .{tok});

            if (ops[i] == '*') {
                nums[i] *= x;
            } else {
                nums[i] += x;
            }
        }
        num_ops = i;
    }
    var total: u64 = 0;
    for (nums) |num| {
        total += num;
    }
    std.debug.print("total={}\n", .{total});
}
