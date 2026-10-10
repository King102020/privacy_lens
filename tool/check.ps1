$ErrorActionPreference = "Stop"
Set-Location (Split-Path -Parent $PSScriptRoot)

Write-Host "Formatting check"
dart format --output=none --set-exit-if-changed .

Write-Host "Analyzer"
flutter analyze

Write-Host "Dart tests"
flutter test

Write-Host "Kotlin tests"
Set-Location android
.\gradlew.bat test --console=plain
Set-Location ..
