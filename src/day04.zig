const std = @import("std");

var gpa = std.heap.GeneralPurposeAllocator(.{}){};
const allocator = gpa.allocator();

pub fn run() !void {
    std.debug.print("run\n", .{});

    const arr: []const u8 = @embedFile("input04.txt");

    const num_cols = (std.mem.indexOfScalar(u8, arr, '\n') orelse 0) + 1;
    const num_rows = arr.len / (num_cols);

    std.debug.print("num_rows={} num_cols={}\n", .{ num_rows, num_cols });

    var count: u32 = 0;
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
                if(num_ats <= 3)
                    count+=1;
            }
        }
    }
    std.debug.print("count: {}\n", .{count});
}
