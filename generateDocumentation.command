# update Xcode project

# swift package generate-xcodeproj

#if which swiftlint >/dev/null; then
#  swiftlint
#else
#  echo "warning: SwiftLint not installed, download from https://github.com/realm/SwiftLint"
#fi

# Disable run scripts

# Run Jazzy
jazzy

# Restore run scrips



# Github swiftlint checks for // without space:
# use this regex " //[a-Z].*" Or "^:{0}//[a-Z]"
