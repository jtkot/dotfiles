#!/usr/bin/env bash

for file in "$CHEZMOI_SOURCE_DIR/macos_defaults"/*.plist; do
    IFS='_' read -ra attrs <<< "$(basename "$file")"

    unset is_host domain
    for attr in "${attrs[@]}"; do
        case "$attr" in
            host) is_host=1 ;;
            *.plist) domain="${attr%.plist}" ;;
            *) ;;
        esac
    done

    echo "Applying defaults for $domain..."
    plutil -convert xml1 -o - "$file" | defaults ${is_host:+-currentHost} import "$domain" -
done
