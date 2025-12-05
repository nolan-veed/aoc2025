const std = @import("std");

const Pair = struct {
    start: u64 = 0,
    end: u64 = 0,
};

pub fn run() !void {
    std.debug.print("run\n", .{});

    const f = @embedFile("input05.txt");

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer std.debug.print("{}", .{gpa.deinit()});
    const allocator = gpa.allocator();

    var ranges = try std.ArrayList(Pair).initCapacity(allocator, 1024);
    defer ranges.deinit(allocator);

    const idx_nlnl = std.mem.indexOf(u8, f, "\n\n") orelse 0;
    {
        var it = std.mem.tokenizeScalar(u8, f[0..idx_nlnl], '\n');
        while (it.next()) |tok| {
            if (tok.len == 0)
                break;
            std.debug.print("tok={s}\n", .{tok});
            const idx_dash = std.mem.indexOfScalar(u8, tok, '-') orelse 0;
            const start = try std.fmt.parseInt(u64, tok[0..idx_dash], 10);
            const end = try std.fmt.parseInt(u64, tok[idx_dash + 1 ..], 10);
            try ranges.append(allocator, Pair{ .start = start, .end = end });
        }
        std.debug.print("ranges parsed.\n", .{});
    }

    var count: u64 = 0;
    const part1 = false;
    if (part1) {
        var it = std.mem.tokenizeScalar(u8, f[idx_nlnl..], '\n');
        while (it.next()) |tok| {
            std.debug.print("tok={s}\n", .{tok});
            const id = try std.fmt.parseInt(u64, tok, 10);
            for (ranges.items) |range| {
                if (id >= range.start and id <= range.end) {
                    count += 1;
                    break;
                }
            }
        }
    } else {
        std.mem.sort(Pair, ranges.items, {}, PairLessThan);
        var current = ranges.items[0];
        for (ranges.items[1..]) |range| {
            if (range.start > current.end) {
                const x = current.end - current.start + 1;
                count += x;
                current = range;
            } else if (range.end > current.end) {
                current.end = range.end;
            }
        }
        const x = current.end - current.start + 1;
        count += x;
    }
    std.debug.print("count={}\n", .{count});
}

fn PairLessThan(_: void, a: Pair, b: Pair) bool {
    if (a.start == b.start)
        return a.end < b.end;
    return a.start < b.start;
}
