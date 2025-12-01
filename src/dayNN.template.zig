const std = @import("std");
const helpers = @import("helpers.zig");

var gpa = std.heap.GeneralPurposeAllocator(.{}){};
const allocator = gpa.allocator();

pub fn run() !void {
    std.debug.print("run\n", .{});

    // const some_number = try allocator.create(u32);
    // defer allocator.destroy(some_number);
    // some_number.* = @as(u32, 45);
    // std.debug.print("some_number: {}", .{some_number.*});

    const f = try std.fs.cwd().openFile("testNN.txt", .{ .mode = .read_only });
    defer f.close();
    var read_buffer: [1024]u8 = undefined;
    var fr = f.reader(&read_buffer);
    var reader = &fr.interface;

    var buffer: [300]u8 = undefined;
    @memset(buffer[0..], 0);
    // _ = reader.readSliceAll(buffer[0..]) catch 0;
    // std.debug.print("{s}\n", .{buffer});
    const line = try reader.takeDelimiter('\n') orelse "";
    std.debug.print("{s}\n", .{line});

    var toks = std.mem.tokenizeAny(u8, line, " ");
    while (toks.next()) |tok| {
        std.debug.print("{s}\n", .{tok});
        const v = try std.fmt.parseInt(u32, tok, 10);
        std.debug.print("v={d}\n", .{v});
    }
}
