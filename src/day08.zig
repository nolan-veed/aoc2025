const std = @import("std");

const Point = struct {
    x: u32 = 0,
    y: u32 = 0,
    z: u32 = 0,
};

const Dist = struct {
    d: i32 = 0,
    f: usize = 0,
    t: usize = 0,
};

pub fn run() !void {
    std.debug.print("run\n", .{});
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer std.debug.print("{}", .{gpa.deinit()});
    const allocator = gpa.allocator();

    const f: []const u8 = @embedFile("test08.txt");
    // const max_connects = 10;

    // const f: []const u8 = @embedFile("input08.txt");
    // const max_connects = 1000;

    var points = try std.ArrayList(Point).initCapacity(allocator, 1024);
    defer points.deinit(allocator);

    var lines = std.mem.splitScalar(u8, f, '\n');
    while (lines.next()) |line| {
        if (line.len == 0)
            break;
        var splits = std.mem.splitScalar(u8, line, ',');
        const x = try std.fmt.parseInt(u32, splits.next().?, 10);
        const y = try std.fmt.parseInt(u32, splits.next().?, 10);
        const z = try std.fmt.parseInt(u32, splits.next().?, 10);
        const p = Point{ .x = x, .y = y, .z = z };
        try points.append(allocator, p);
    }
    std.debug.print("points.items.len={d}\n", .{points.items.len});

    var dists = try std.ArrayList(Dist).initCapacity(allocator, 1024 * 1024);
    defer dists.deinit(allocator);

    for (0..points.items.len - 1) |i| {
        for (i + 1..points.items.len) |j| {
            const p1 = points.items[i];
            const p2 = points.items[j];
            const diff_x = @as(i32, @intCast(p1.x)) - @as(i32, @intCast(p2.x));
            const diff_y = @as(i32, @intCast(p1.y)) - @as(i32, @intCast(p2.y));
            const diff_z = @as(i32, @intCast(p1.z)) - @as(i32, @intCast(p2.z));
            const dist = (diff_x * diff_x) + (diff_y * diff_y) + (diff_z * diff_z);
            try dists.append(allocator, Dist{ .d = dist, .f = i, .t = j });
        }
    }

    std.mem.sort(Dist, dists.items, {}, DistLessThan);

    std.debug.print("dist={d}\n", .{dists.items[0].d});
}

fn DistLessThan(_: void, a: Dist, b: Dist) bool {
    return a.d < b.d;
}
