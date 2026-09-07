#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"

fail() { echo "FAIL: $1" >&2; exit 1; }

test -f hugo.yaml || fail "missing hugo.yaml"
test -f layouts/_default/baseof.html || fail "missing base template"
test -f layouts/index.html || fail "missing home template"
test -f layouts/_default/single.html || fail "missing single template"
test -f layouts/partials/header.html || fail "missing header partial"
test -f static/editorial.css || fail "missing editorial stylesheet"
test -f static/stylesheets/screen.css || fail "missing base stylesheet"
grep -q '\.Content' layouts/_default/list.html || fail "list template does not render page content"
test -f layouts/_default/archives.html || fail "missing archive template"
test -f .github/workflows/hugo-pages.yml || fail "missing GitHub Pages workflow"

hugo_posts=$(find content/posts -type f -name '*.md' | wc -l | tr -d ' ')
[ "$hugo_posts" = "56" ] || fail "expected 56 migrated posts, found $hugo_posts"

grep -q 'blog/:year/:month/:day/:slug' hugo.yaml || fail "blog permalink is not preserved"
grep -q 'categories: "/blog/categories/' hugo.yaml || fail "category permalink is not preserved"
grep -q 'actions/deploy-pages' .github/workflows/hugo-pages.yml || fail "Pages deployment step missing"
grep -q 'contents: read' .github/workflows/hugo-pages.yml || fail "workflow permissions missing"
grep -q 'pages: write' .github/workflows/hugo-pages.yml || fail "workflow Pages permission missing"

echo "PASS: Hugo migration structure and content counts are valid ($hugo_posts posts)."
