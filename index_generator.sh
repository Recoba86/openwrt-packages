#!/bin/sh

set -e

echo "Generating package index..."

rm -f Packages Packages.gz Packages.manifest sha256sum.txt Packages.sig
touch Packages Packages.manifest sha256sum.txt

# Find all IPK files recursively
ipk_files=$(find . -name "*.ipk" | sort)

for ipk in $ipk_files; do
    clean_ipk=$(echo "$ipk" | sed 's|^\./||')
    echo "Processing $clean_ipk..."
    
    # Extract control and write to Packages
    tar -xzOf "$ipk" control.tar.gz | tar -xzOf - ./control >> Packages
    
    # Calculate size and sha256sum
    size=$(wc -c < "$ipk" | tr -d ' ')
    sha256=$(sha256sum "$ipk" 2>/dev/null | awk '{print $1}' || shasum -a 256 "$ipk" 2>/dev/null | awk '{print $1}')
    
    # Append filename, size, and sha
    echo "Filename: $clean_ipk" >> Packages
    echo "Size: $size" >> Packages
    echo "SHA256sum: $sha256" >> Packages
    echo "" >> Packages
    
    # Also write manifest and sha256sum.txt
    echo "$clean_ipk" >> Packages.manifest
    echo "$sha256  $clean_ipk" >> sha256sum.txt
done

# Sign Packages if usign is available
if which usign >/dev/null 2>&1; then
    echo "Signing Packages using usign..."
    usign -S -m Packages -s keys/custom_feed.key -x Packages.sig
else
    echo "Warning: usign not found. Skipping signature generation."
fi

# Compress Packages
gzip -c Packages > Packages.gz

echo "Feed index files generated successfully!"
