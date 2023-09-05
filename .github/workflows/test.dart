name: Test

on:
  - push
  - pull_request

jobs:
  test:
    runs-on: ubuntu-latest

    container:
      image: dart:stable

    steps:
      - uses: actions/checkout@v3

      - name: Install dependencies
        run: dart pub get

      - name: Analyze
        run: dart analyze

      - name: Run tests
        run: dart test
