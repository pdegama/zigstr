/// String library for zig
const std = @import("std");

pub const String = struct {
    buffer: ?[]u8,
    size: usize,

    const Self = @This();

    var allocater: std.heap.ArenaAllocator = undefined;
    var a: std.mem.Allocator = undefined;

    pub fn init() Self {
        allocater = std.heap.ArenaAllocator.init(std.heap.page_allocator);
        a = allocater.allocator();

        return Self{
            .buffer = null,
            .size = 0,
        };
    }

    pub fn initString(str: [:0]const u8) Self {
        allocater = std.heap.ArenaAllocator.init(std.heap.page_allocator);
        a = allocater.allocator();

        var buffer = a.alloc(u8, str.len) catch unreachable;
        var i: usize = 0;
        while (str.len > i) : (i += 1) {
            buffer[i] = str[i];
        }
        var size = str.len;

        return Self{
            .buffer = buffer,
            .size = size,
        };
    }

    pub fn push(self: *Self, str: [:0]const u8) !void {
        if (self.buffer) |_| {
            self.buffer = try a.realloc(self.buffer.?, self.size + str.len);
        } else {
            self.buffer = try a.alloc(u8, str.len);
        }

        var i: usize = 0;
        while (str.len > i) : (i += 1) {
            self.buffer.?[self.size + i] = str[i];
        }

        self.size += str.len;
    }

    pub fn pushChar(self: *String, char: u8) !void {
        if (self.buffer) |_| {
            self.buffer = try a.realloc(self.buffer.?, self.size + 1);
        } else {
            self.buffer = try a.alloc(u8, 1);
        }

        self.buffer.?[self.size] = char;

        self.size += 1;
    }

    pub fn add(self: *Self, str: [:0]const u8) void {
        self.push(str) catch unreachable;
    }

    pub fn get(self: Self) []u8 {
        return self.buffer orelse "";
    }

    pub fn clear(self: *Self) void {
        if (self.buffer) |_| {
            self.buffer = a.realloc(self.buffer.?, 0) catch unreachable;
        }
        a.free(self.buffer.?);
        self.size = 0;
    }

    pub fn equ(self: Self, str: Self) bool {
        return std.mem.eql(u8, self.get(), str.get());
    }

    pub fn equString(self: Self, str: [:0]const u8) bool {
        return std.mem.eql(u8, self.get(), str);
    }

    pub fn len(self: Self) usize {
        return self.size;
    }

    pub fn deinit(_: *Self) void {
        allocater.deinit();
    }
};

pub fn main() void {}

test "make string" {
    var str1 = String.init();
    str1.add("zigggg");
    str1.deinit();
}

test "make string direct" {
    var str1 = String.initString("Hello, Computers!");
    str1.deinit();
}

test "equ String" {
    var str1 = String.init();

    str1.add("Hello, ");
    str1.add("Computers");
    str1.add("!");

    var str2 = String.initString("Hello, Computers!");

    try std.testing.expect(str1.equ(str2));
    try std.testing.expect(str2.equ(str1));
}

test "not eql String" {
    var str1 = String.init();
    str1.add("Computers");
    str1.add("!");

    var str2 = String.initString("Hello, Computers!");

    try std.testing.expect(!str1.equ(str2));
    try std.testing.expect(!str2.equ(str1));
}

test "eql str String" {
    var str1 = String.init();

    str1.add("Hello, ");
    str1.add("Computers");
    str1.add("!");

    try std.testing.expect(str1.equString("Hello, Computers!"));
}

test "not eql str String" {
    var str1 = String.init();

    str1.add("Hello, ");
    str1.add("Computers");
    str1.add("!");

    try std.testing.expect(!str1.equString("Hello"));
}

test "size String" {
    var str1 = String.initString("Hello, Computers!");
    try std.testing.expect(str1.len() == 17);
}

test "size 2 String" {
    var str1 = String.init();

    str1.add("Hello, ");
    try std.testing.expect(str1.len() != 0);
    str1.add("Computers");
    try std.testing.expect(str1.len() == 16);
    str1.add("!");
    try std.testing.expect(str1.len() == 17);
}

test "clear String" {
    var str1 = String.init();
    str1.add("Hello, ");
    str1.clear();
    str1.add("Computers!");

    try std.testing.expect(str1.equString("Computers!"));
    try std.testing.expect(str1.len() == 10);

    str1.clear();
    try std.testing.expect(str1.len() == 0);
    try std.testing.expect(str1.equString(""));
}
