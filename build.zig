const Builder = @import("std").build.Builder;

pub fn build(b: *Builder) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const lib = b.addStaticLibrary(.{
        .name = "zigstr",
        .root_source_file = .{ .path = "lib/str.zig" },
        .optimize = optimize,
        .target = target,
    });
    lib.emit_docs = .emit;
    b.installArtifact(lib);

    const main_tests = b.addTest(.{
        .name = "test1",
        .root_source_file = .{ .path = "lib/str.zig" },
        .optimize = optimize,
    });

    const test_step = b.step("test", "Run library tests");
    test_step.dependOn(&main_tests.step);
}
