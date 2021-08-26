if which swiftlint >/dev/null; then
  swiftlint --strict
else
  echo "warning: SwiftLint not installed, download from https://github.com/realm/SwiftLint"
fi

# Run Jazzy
jazzy

# Github swiftlint checks for // without space:
# use this regex " //[a-Z].*" Or "^:{0}//[a-Z]"
