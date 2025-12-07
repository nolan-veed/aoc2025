const std = @import("std");

const Pos = struct {
    r: u64 = 0,
    c: u64 = 0,
};

pub fn run() !void {
    std.debug.print("run\n", .{});
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer std.debug.print("{}", .{gpa.deinit()});
    const allocator = gpa.allocator();

    const f: []const u8 = @embedFile("input07.txt");
    const idx_nl = std.mem.indexOfScalar(u8, f, '\n') orelse 0;
    const num_cols = idx_nl + 1;
    const num_rows = f.len / num_cols;

    var arr = try allocator.alloc(u8, f.len);
    defer allocator.free(arr);

    std.mem.copyForwards(u8, arr, f);

    const idx_S = std.mem.indexOfScalar(u8, f, 'S') orelse 0;

    var poses = try std.ArrayList(Pos).initCapacity(allocator, 1024);
    defer poses.deinit(allocator);

    try poses.append(allocator, Pos{ .r = 0, .c = idx_S });
    arr[idx_S] = '.'; // S -> .

    var count: u32 = 0;
    while (poses.items.len > 0)  {
        const pos = poses.orderedRemove(0);
        const idx = pos.r * num_cols + pos.c;
        if (arr[idx] == '.') {
            arr[idx] = '|';
            if (pos.r + 1 < num_rows) {
                try poses.append(allocator, Pos{ .r = pos.r + 1, .c = pos.c });
            }
            continue;
        } else if (arr[idx] == '^') {
            count += 1;
            if (arr[idx + 1] == '.') {
                try poses.append(allocator, Pos{ .r = pos.r, .c = pos.c + 1 });
            }
            if (arr[idx - 1] == '.') {
                try poses.append(allocator, Pos{ .r = pos.r, .c = pos.c - 1 });
            }
            continue;
        }
    }
    std.debug.print("count={}\n", .{count});
}
