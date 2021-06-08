add_custom_target(
    tidy
    COMMAND run-clang-tidy -p build/
    WORKING_DIRECTORY ..
)

add_custom_target(
    tidy-fix
    # The double run-clang-tidy is because when -fix is applied the fixed error are still shown
    COMMAND run-clang-tidy -p build/ -fix -quiet && run-clang-tidy -p build/
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