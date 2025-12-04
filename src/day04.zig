const std = @import("std");

pub fn run() !void {
    std.debug.print("run\n", .{});

    const arr_file: []const u8 = @embedFile("input04.txt");

    const num_cols = (std.mem.indexOfScalar(u8, arr_file, '\n') orelse 0) + 1;
    const num_rows = arr_file.len / num_cols;

    std.debug.print("num_rows={} num_cols={}\n", .{ num_rows, num_cols });

    const part1 = false;
    var count: u32 = 0;

    if (part1) {
        const arr = arr_file;
        for (0..num_rows) |i| {
            for (0..num_cols) |j| {
                const idx = i * num_cols + j;
                const c = arr[idx];
                if (c == '@') {
                    var num_ats: u8 = 0;
                    if (arr[idx - num_cols - 1] == '@')
                        num_ats += 1;
                    if (arr[idx - num_cols] == '@')
                        num_ats += 1;
                    if (arr[idx - num_cols + 1] == '@')
                        num_ats += 1;
                    if (arr[idx - 1] == '@')
                        num_ats += 1;
                    if (arr[idx + 1] == '@')
                        num_ats += 1;
                    if (arr[idx + num_cols - 1] == '@')
                        num_ats += 1;
                    if (arr[idx + num_cols] == '@')
                        num_ats += 1;
                    if (arr[idx + num_cols + 1] == '@')
                        num_ats += 1;
                    if (num_ats <= 3)
                        count += 1;
                }
            }
        }
    } else {
        var buf: [256 * 256]u8 = undefined;
        std.mem.copyForwards(u8, buf[0..buf.len], arr_file);
        const arr = buf[0..arr_file.len];
        while (true) {
            var removed = false;

            for (0..num_rows) |i| {
                for (0..num_cols) |j| {
                    const idx = i * num_cols + j;
                    const c = arr[idx];
                    if (c == '@') {
                        var num_ats: u8 = 0;
                        if (arr[idx - num_cols - 1] == '@')
                            num_ats += 1;
                        if (arr[idx - num_cols] == '@')
                            num_ats += 1;
                        if (arr[idx - num_cols + 1] == '@')
                            num_ats += 1;
                        if (arr[idx - 1] == '@')
                            num_ats += 1;
                        if (arr[idx + 1] == '@')
                            num_ats += 1;
                        if (arr[idx + num_cols - 1] == '@')
                            num_ats += 1;
                        if (arr[idx + num_cols] == '@')
                            num_ats += 1;
                        if (arr[idx + num_cols + 1] == '@')
                            num_ats += 1;
                        if (num_ats <= 3) {
                            count += 1;
                            arr[idx] = 'x';
                            removed = true;
                        }
                    }
                }
            }
            if (!removed) {
                break;
            }
            for (0..num_rows) |i| {
                for (0..num_cols) |j| {
                    const idx = i * num_cols + j;
                    const c = arr[idx];
                    if (c == 'x') {
                        arr[idx] = '.';
                    }
                }
            }
        }
    }
    std.debug.print("count: {}\n", .{count});
}
