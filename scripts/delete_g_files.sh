#!/bin/bash

find . -type f -name "*.g.dart" ! -name "locale_keys.g.dart" ! -name "localization.g.dart" -exec rm -v {} +

echo "All .g.dart files have been deleted."
