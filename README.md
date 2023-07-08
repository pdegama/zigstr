# zigstr

**zigstr** is string library for Zig language.

## Usage Examples

```zig
const String = @import("zigstr").String;

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

```
