const std = @import("std");

pub fn run() !void {
    std.debug.print("run\n", .{});

    const f: []const u8 = @embedFile("input06.txt");

    // Made the file into a 2d array.
    // I wanted to put a spaces at the end of the line (before newline), but as my editor was removing them, so I put spaces and a pipe.
    var it = std.mem.tokenizeAny(u8, f[0..], "\n|");

    var ops: [1024]u8 = undefined;
    var op_idxs: [1024]usize = undefined;
    var sums_or_prods = [_]u64{0} ** 1024;
    var num_ops: usize = 0;
    {
        const line = it.next() orelse unreachable;
        var toks = std.mem.tokenizeScalar(u8, line, ' ');

        var i: usize = 0;
        while (toks.next()) |tok| : (i += 1) {
            std.debug.print("op={s} toks.index={d}\n", .{ tok, toks.index });
            ops[i] = tok[0];
            op_idxs[i] = toks.index - 1;
            if (ops[i] == '*')
                sums_or_prods[i] = 1;
        }
        num_ops = i;
    }

    var total: u64 = 0;

    const part1 = false;
    if (part1) {
        while (it.next()) |line| {
            var toks = std.mem.tokenizeAny(u8, line, " |");

            var i: usize = 0;
            while (toks.next()) |tok| : (i += 1) {
                const x = try std.fmt.parseInt(u32, tok, 10);
                std.debug.print("x={s}\n", .{tok});

                if (ops[i] == '*') {
                    sums_or_prods[i] *= x;
                } else {
                    sums_or_prods[i] += x;
                }
            }
            num_ops = i;
        }
        for (sums_or_prods[0..num_ops]) |num| {
            total += num;
        }
    } else {
        const index_nl = std.mem.indexOfScalar(u8, f, '\n') orelse 0;
        const num_cols = index_nl + 1;
        const num_rows = f.len / num_cols;
        const num_cols_data = num_cols - 2; // -2 for \n and |.

        for (op_idxs[0..num_ops], 0..) |ops_idx, i| {
            const start_c = ops_idx;
            var end_c = num_cols_data;
            if (i + 1 < num_ops)
                end_c = op_idxs[i + 1] - 1; // -1 for space before op.

            var sum_or_prod: u64 = 0;
            if (ops[i] == '*')
                sum_or_prod = 1;
            for (start_c..end_c) |curr_c| {
                var v: u32 = 0;
                for (1..num_rows) |r| {
                    const f_idx = r * num_cols + curr_c;
                    const char = f[f_idx];
                    if (std.ascii.isDigit(char)) {
                        v *= 10;
                        v += char - '0';
                    }
                }
                std.debug.print("v={}\n", .{v});

                if (ops[i] == '*') {
                    sum_or_prod *= v;
                } else {
                    sum_or_prod += v;
                }
            }
            total += sum_or_prod;
        }
    }
    std.debug.print("total={}\n", .{total});
}
