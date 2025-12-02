const std = @import("std");

var gpa = std.heap.GeneralPurposeAllocator(.{}){};
const allocator = gpa.allocator();

pub fn run() !void {
    std.debug.print("run\n", .{});

    const f = try std.fs.cwd().openFile("input02.txt", .{ .mode = .read_only });
    defer f.close();
    var read_buffer: [1024]u8 = undefined;
    var fr = f.reader(&read_buffer);
    var reader = &fr.interface;

    var buffer: [1024]u8 = undefined;
    @memset(buffer[0..], 0);

    var sum: u64 = 0;
    const part1 = false;

    while (try reader.takeDelimiter(',')) |line| {
        std.debug.print("{s}\n", .{line});
        var v1: u32 = undefined;
        var v2: u32 = undefined;

        var toks = std.mem.tokenizeAny(u8, line, "-\n");
        if (toks.next()) |tok| {
            std.debug.print("{s}\n", .{tok});
            v1 = try std.fmt.parseInt(u32, tok, 10);
            std.debug.print("v1={d}\n", .{v1});
        }
        if (toks.next()) |tok| {
            std.debug.print("{s}\n", .{tok});
            v2 = try std.fmt.parseInt(u32, tok, 10);
            std.debug.print("v2={d}\n", .{v2});
        }

        var i = v1;
        while (i <= v2) : (i += 1) {
            const s = try std.fmt.bufPrint(&buffer, "{}", .{i});
            if (part1) {
                if (s.len % 2 != 0)
                    continue;
                const s2_start = s.len / 2;
                const s1 = s[0..s2_start];
                const s2 = s[s2_start..s.len];
                const eql = std.mem.eql(u8, s1, s2);
                if (eql) {
                    std.debug.print("eql: s1={s} s2={s} i={d}\n", .{ s1, s2, i });
                    sum += i;
                }
            } else {
                var sz: u32 = 1;
                while (sz <= s.len / 2) : (sz += 1) {
                    const rem = s.len % sz;
                    if (rem > 0) continue;
                    const s1 = s[0..sz];
                    var isInvalid = true;
                    var j = sz;
                    while (j < s.len) : (j += sz) {
                        const s2 = s[j .. j + sz];
                        const eql = std.mem.eql(u8, s1, s2);
                        if (!eql) {
                            isInvalid = false;
                            break;
                        }
                    }
                    if (isInvalid) {
                        std.debug.print("isInvalid: i={d}\n", .{i});
                        sum += i;
                        break;
                    }
                }
            }
        }
    }
    std.debug.print("part1={} sum={}\n", .{ part1, sum });
}
