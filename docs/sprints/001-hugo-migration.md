# Sprint 001 — Hugo migration

## Acceptance criteria

1. Hugo builds the site without Ruby, Bundler, Jekyll, or Octopress.
2. All existing Markdown posts are migrated.
3. Existing blog URLs use `/blog/YYYY/MM/DD/slug/`.
4. About and consulting pages remain available.
5. Existing images, favicon, robots.txt, RSS, categories, and pagination remain available.
6. The editorial layout remains responsive and keeps the current visual direction.
7. GitHub Actions builds Hugo and deploys GitHub Pages on pushes to `source`.

## Test cases

- Count source posts and migrated Hugo posts; the counts must match.
- Run the migration test script.
- Run `hugo --minify` successfully.
- Check generated `index.html`, one post, `/about/`, `/consulting/`, `/categories/`, and `/index.xml`.
- Check the GitHub Pages workflow contains the required Pages permissions and deployment steps.
