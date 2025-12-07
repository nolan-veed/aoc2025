const std = @import("std");

const Pos = struct {
    r: u32 = 0,
    c: u32 = 0,
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

    var poses = try std.ArrayList(Pos).initCapacity(allocator, 1024);
    defer poses.deinit(allocator);

    const idx_S = std.mem.indexOfScalar(u8, f, 'S') orelse 0;
    try poses.append(allocator, Pos{ .r = 0, .c = @intCast(idx_S) });
    arr[idx_S] = '.'; // S -> .

    const part1 = false;

    if (part1) {
        var count: u32 = 0;
        while (poses.items.len > 0) {
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
    } else {
        var memo = std.AutoHashMap(Pos, u64).init(allocator);
        defer memo.deinit();
        while (poses.items.len > 0) {
            const pos = poses.items[poses.items.len - 1];
            if (memo.contains(pos)) {
                std.debug.print("found pos=({d}, {d}) count={d}\n", .{ pos.r, pos.c, memo.get(pos).? });
                _ = poses.pop();
                continue;
            }
            const idx = pos.r * num_cols + pos.c;
            if (arr[idx] == '.') {
                const next_pos = Pos{ .r = pos.r + 2, .c = pos.c };
                if (memo.contains(next_pos)) {
                    try memo.put(pos, memo.get(next_pos).?);
                    continue;
                }
                if (next_pos.r >= num_rows) {
                    try memo.put(pos, 1);
                    continue;
                }
                try poses.append(allocator, next_pos);
                continue;
            } else if (arr[idx] == '^') {
                const next_pos_l = Pos{ .r = pos.r + 2, .c = pos.c - 1 };
                const next_pos_r = Pos{ .r = pos.r + 2, .c = pos.c + 1 };
                if (memo.contains(next_pos_l) and memo.contains(next_pos_r)) {
                    try memo.put(pos, memo.get(next_pos_l).? + memo.get(next_pos_r).?);
                    continue;
                }
                if (next_pos_l.r >= num_rows) {
                    try memo.put(pos, 2);
                    continue;
                }
                if (!memo.contains(next_pos_l)) {
                    try poses.append(allocator, next_pos_l);
                }
                if (!memo.contains(next_pos_r)) {
                    try poses.append(allocator, next_pos_r);
                }
                continue;
            }
        }
    }
}
