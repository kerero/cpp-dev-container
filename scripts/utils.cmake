add_custom_target(
    tidy
    COMMAND run-clang-tidy -p build/
    WORKING_DIRECTORY ..
)

add_custom_target(
    tidy-fix
    COMMAND run-clang-tidy -p build/ -fix -quiet
    WORKING_DIRECTORY ..
)

add_custom_target(
    format
    COMMAND find . -path ./build -prune -false -o -iname *.h -o -iname *.cpp -o -iname *.hpp -o -iname *.cc | xargs clang-format --dry-run --Werror
    WORKING_DIRECTORY ..
)

add_custom_target(
    format-fix
    COMMAND find . -path ./build -prune -false -o -iname *.h -o -iname *.cpp -o -iname *.hpp -o -iname *.cc | xargs clang-format -i
    WORKING_DIRECTORY ..
)

add_custom_target(
    static-analysis
    COMMAND rm -rf codechecker && mkdir -p codechecker/reports && cmake .. -B codechecker
    COMMAND CodeChecker check --build "cmake --build codechecker" --output codechecker/reports --ignore /opt/cmake-utils/.CodeCheckerIgnore
)