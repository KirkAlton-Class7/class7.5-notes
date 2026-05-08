#!/bin/bash

files=(
  "https://raw.githubusercontent.com/aaron-dm-mcdonald/class7-5-notes/refs/heads/main/week-7/bam/assets/404.html"
  "https://raw.githubusercontent.com/aaron-dm-mcdonald/class7-5-notes/refs/heads/main/week-7/bam/assets/index.html"
  "https://raw.githubusercontent.com/aaron-dm-mcdonald/class7-5-notes/refs/heads/main/week-7/bam/assets/style.css"
  "https://raw.githubusercontent.com/aaron-dm-mcdonald/class7-5-notes/refs/heads/main/.gitignore"
)

for i in "${!files[@]}"; do
  echo "Downloading file $((i+1))..."
  curl -Os "${files[$i]}"
done

echo "all done downloading, get to writing terraform!" 
