if [[ ! -f pubspec.lock ]]; then
  echo "pubspec.lock not found!"
  exit 1
fi

if grep -q 'flutter: "' pubspec.lock; then
  echo "::set-output name=project_type::flutter"
elif grep -q 'dart: "' pubspec.lock; then
  echo "::set-output name=project_type::dart"
else
  echo "::set-output name=project_type::none"
fi
