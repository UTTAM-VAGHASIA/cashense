# Agent Workflow & Rules

## Core Principles

- **No commits by agent** — Agent gives commands, human executes git
- **One phase at a time** — Do not start next phase until human says "done"
- **Human tasks explicitly marked** — Clear separation of agent vs human work
- **Test before proceeding** — Each phase has a checklist; wait for human confirmation

---

## Workflow

### Phase Execution Cycle

```
1. Agent: Announce "Starting Phase N.X: [Feature Name]"
2. Agent: List all files to create/modify
3. Human: Review file list, approve or adjust
4. Agent: Implement changes
5. Agent: Provide test checklist
6. Human: Run flutter analyze, test features manually
7. Human: Say "all done" or describe issues
8. Agent: If issues → fix. If done → give git commands
9. Human: Execute git commands
10. Agent: Update MASTER_PLAN.md status → Proceed to next phase
```

---

## Phase Structure

### Each Phase Contains

**Agent does:**
- Create new feature directories and files
- Write model, controller, view, widget code
- Update routes with new screens
- Update DI bindings
- Add required packages to pubspec.yaml

**Human does:**
- Review file list before agent starts
- Run `flutter pub get` after pubspec changes
- Run `flutter analyze` after implementation
- Test navigation to new screens manually
- Confirm each item in test checklist
- Execute git commands

---

## Test Commands

After every phase:

```bash
# Analyze for errors
flutter analyze

# Quick run on device
flutter run --flavor dev -t lib/flavors/main_dev.dart

# Build check
flutter build apk --flavor dev -t lib/flavors/main_dev.dart --debug
```

---

## Git Protocol

After human says "all done":

Agent provides:
```bash
git add lib/features/[feature]/ lib/routes/ pubspec.yaml pubspec.lock
git commit -m "feat: Phase N.X — [Feature Name]"
git push origin main
```

Human executes the commands.

---

## Communication Format

### Agent Says
- "Starting Phase 1.2: Expense Tracking"
- "Files to create: [list]"
- "Files to modify: [list]"
- "Packages to add to pubspec.yaml: [list]"
- "Test checklist: [list]"
- "Git commands: [commands]"

### Human Says
- **"all done"** — Proceed to next sub-phase
- **"[issue description]"** — Agent fixes the issue
- **"skip this"** — Skip current sub-phase, note it as deferred
- **"done with phase N"** — Mark phase complete in MASTER_PLAN.md

---

## Rules

1. Never commit without explicit "all done" from human
2. Never start a new phase without completing the previous one's checklist
3. After every pubspec.yaml change, remind human to run `flutter pub get`
4. Always run `flutter analyze` guidance before closing a phase
5. Keep old working code intact — never delete until new code is confirmed working
6. iOS `flavor_constants.dart` TODOs block all iOS testing — flag this every session until fixed
7. All Firestore operations must go through a Repository class, never direct in controllers
8. All API keys must go through Firebase Cloud Functions — never in Flutter client code
