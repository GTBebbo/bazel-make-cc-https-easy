# This file existed originally to enable quick local development via local_repository.
    # See ./ImplementationReadme.md for details on local development.
    # Why? local_repository didn't work without a WORKSPACE, and new_local_repository required overwriting the BUILD file (as of Bazel 5.0).

workspace(name = "hedron_make_cc_https_easy")

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")
http_archive(
    name = "com_github_nelhage_rules_boost",
    url = "https://github.com/nelhage/rules_boost/archive/5729d34dcf595874f32b9f1aa1134db65fe78fda.tar.gz",
    sha256 = "bf488e4c472832a303d31ed20ea0ffdd8fa974654969b0c129b7c0ce4273f103",
    strip_prefix = "rules_boost-5729d34dcf595874f32b9f1aa1134db65fe78fda",
)

# load("@hedron_make_cc_https_easy//:workspace_setup.bzl", "hedron_compile_commands_setup")
# hedron_compile_commands_setup()
load("@hedron_make_cc_https_easy//:workspace_setup.bzl", "hedron_make_cc_https_easy")
hedron_make_cc_https_easy()
