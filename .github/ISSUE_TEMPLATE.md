---
title: ":rotating_light: Performance regression in #{{ env.PR_NUMBER }}"
labels: P-Performance, automated issue
---
Testing regression in: #{{ env.PR_NUMBER }}
Commit: {{ env.GIT_SHA }}
Triggered by: {{ env.WORKFLOW_URL }}