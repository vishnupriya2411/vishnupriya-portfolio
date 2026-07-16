# docs/

Somewhere to keep supporting documents that aren't part of the site itself,
things like publication lists or conference posters. Nothing in this folder is
deployed, since `.vercelignore` skips it.

The resume isn't here. It used to be linked from an external site, but it's now
served by the portfolio directly and lives with the other site assets:

```
assets/resume/Priya_Resume_2.pdf
```

That's what the three Resume links in `index.html` point to, so the site doesn't
depend on anything outside this repo. If I swap in a new PDF, keeping the same
filename means those links keep working.
