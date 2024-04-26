const std = @import("std");
const testing = std.testing;

pub fn TabWriter(comptime WriterType: type) type {
    return struct {
        wrapped: WriterType,

        pub const Error = WriterType.Error;
        pub const Writer = std.io.Writer(*Self, Error, write);

        const Self = @This();

        /// create a tab writer from some underlying WriterType
        fn init(underlying: anytype) TabWriter(@TypeOf(underlying)) {
            return .{ .wrapped = underlying };
        }

        /// return reference to self as an io.Writer
        pub fn writer(self: *Self) Writer {
            return .{ .context = self };
        }

        pub fn flush(_: *Self) !void {
            std.debug.print("flush...\n", .{});
        }

        pub fn write(_: *Self, _: []const u8) Error!usize {
            std.debug.print("write...\n", .{});
            return 0;
        }
    };
}

test "writer" {
    const allocator = std.testing.allocator;
    const Bytes = std.ArrayList(u8);
    var bytes = Bytes.init(allocator);
    defer bytes.deinit();
    var tabwriter = TabWriter(Bytes.Writer).init(bytes.writer());

    var writer = tabwriter.writer();
    _ = try writer.write("hello");
    try tabwriter.flush();
}
