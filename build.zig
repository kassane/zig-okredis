const std = @import("std");
const builtin = @import("builtin");
const Builder = std.build.Builder;

pub fn build(b: *Builder) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    _ = b.addModule("okredis", .{
        .source_file = .{ .path = "src/okredis.zig" },
    });

    const tests = b.addTest(.{
        .name = "debug test",
        .root_source_file = .{ .path = "src/okredis.zig" },
        .target = target,
        .optimize = optimize,
    });

    const test_step = b.step("test", "Run all tests in debug mode.");
    test_step.dependOn(&tests.step);

    const build_docs = b.addSystemCommand(&.{
        b.zig_exe,
        "test",
        "src/okredis.zig",
        // "-target",
        // "x86_64-linux",
        "-femit-docs",
        "-fno-emit-bin",
        // "--output-dir",
        ".",
    });

    const all_step = b.step("all", "Builds docs and runs all tests");
    const docs = b.step("docs", "Builds docs");
    docs.dependOn(&build_docs.step);
    all_step.dependOn(test_step);
    all_step.dependOn(docs);
    b.default_step.dependOn(docs);
}
