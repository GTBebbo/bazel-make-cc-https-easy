# Do not change the filename; it is part of the user interface.

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")
load("@com_github_nelhage_rules_boost//:boost/boost.bzl", "boost_deps")

def hedron_make_cc_https_easy():
    """Setup a WORKSPACE so you can easily make https requests from C++.

    Ensures you have CPR, whose interface you want to use...
    ... and its dependencies: curl and boringssl.
    """

    # Unified setup for users' WORKSPACES and this workspace when used standalone.
    # See invocations in:
    #     README.md (for users)
    #     WORKSPACE (for working on this repo standalone)

    maybe(
        http_archive,
        name = "cpr",
        patches = ["@hedron_make_cc_https_easy//:cpr.patch"], # Minor. Just removes version-define header from unbrella header <cpr/cpr.h>, since it's generated by cmake and we don't need it. If needed, could hack it in like https://github.com/curoky/tame/blob/c8926a2cd569848137ebb971a95057cb117055c3/recipes/c/cpr/default/BUILD
        build_file = "@hedron_make_cc_https_easy//:cpr.BUILD",
        url = "https://github.com/cpsauer/cpr/archive/a932bde8aec2242dd900fd6192a306584456aa48.tar.gz",
        sha256 = "5e330fe4fd0b79677bb6246017e15e80958485005a16df7d69bb82d558fa678f",
        strip_prefix = "cpr-a932bde8aec2242dd900fd6192a306584456aa48",
    )

    # CPR (temporarily) needs boost::filesystem to backfill std::filesystem on Apple platforms.
    # This is not public API; we anticipate eliminating it at some point in the future.
    maybe(
        http_archive,
        name = "com_github_nelhage_rules_boost",
        url = "https://github.com/nelhage/rules_boost/archive/c22ca92429bb038a16a533d137ee3dc859988810.tar.gz",
        sha256 = "48e0428a972dd0bd157911722d16d9f12b8818a70828b448782b797c89408571",
        strip_prefix = "rules_boost-c22ca92429bb038a16a533d137ee3dc859988810",
    )
    boost_deps()

    # CPR wraps libcurl
    # Note: libcurl updates are auto-PRd but not auto-merged, because the defines required to build it change frequently enough that you need to manually keep curl.BUILD in sync with https://github.com/curl/curl/commits/master/CMakeLists.txt. @cpsauer is responsible.
    maybe(
        http_archive,
        name = "curl",
        build_file = "@hedron_make_cc_https_easy//:curl.BUILD",
        url = "https://github.com/curl/curl/archive/curl-7_87_0.tar.gz",
        sha256 = "41cf1305f8f802616a27474ecf68135faeac38beccbe4e5f15a8c7e6f05a15a9",
        strip_prefix = "curl-curl-7_87_0",
    )

    # libcurl needs to bundle an SSL library on Android. We're using boringssl because it has easy Bazel support. Despite it's Google-only orientation, it's also used in, e.g., Envoy. But if LibreSSL had Bazel wrappings, we'd probably consider it.
    # We're pointing our own mirror of google/boringssl:master-with-bazel to get Renovate auto-update. Otherwise, Renovate will keep moving us back to master, which doesn't support Bazel. See https://github.com/renovatebot/renovate/issues/18492
    # OPTIMNOTE: Their BUILD files should really be using assembly on Android https://bugs.chromium.org/p/boringssl/issues/detail?id=531
    maybe(
        http_archive,
        name = "boringssl",
        url = "https://github.com/hedronvision/boringssl/archive/5a17a399b32eedd18ae83c48f028f20085f08287.tar.gz",
        sha256 = "eefab71b41131c9d12eeab301ccde79a4eac95893c96ff8cf5f857c2bccd70de",
        strip_prefix = "boringssl-5a17a399b32eedd18ae83c48f028f20085f08287",
    )
