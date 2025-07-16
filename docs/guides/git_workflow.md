# Git Workflow

We follow a simplified GitFlow process to enable parallel development.

1. **main** – stable release-ready branch.
2. **develop** – integration branch for ongoing development.
3. **feature/*** – feature branches created from `develop`.
4. **hotfix/*** – urgent fixes created from `main`.

Developers should open pull requests from their feature branches into `develop`.
After review, features are merged and later released to `main`.


