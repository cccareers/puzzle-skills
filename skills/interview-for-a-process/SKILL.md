---
name: interview-for-a-process
description: Prepare the questions to ask before mapping a process in Puzzle, whether the user is interviewing a teammate, a client, a department, or themselves. Load when the user asks to "prep the mapping call", "what should I ask", "interview questions for the X process", "discovery questions", "help me document how we do X", or when a process build is missing its trigger, steps, handoffs, data, time, exceptions or owners and the answers have to come from a person. Produces a one-page guide per process in run order, a list of what is already known so it is confirmed not re-asked, and a listening checklist that maps straight onto what a Puzzle step needs.
---

# Interview for a process

A map is only as good as what the conversation surfaces. This skill turns whatever is known (a survey, a brief, a few Slack messages, an old SOP, the user's own head) into the questions for one conversation about one process, in the order the process runs, so nothing a Puzzle step needs is left for a follow-up.

It works for a consultant interviewing a client contact, an ops lead interviewing a department, a founder interviewing a teammate, or a solo operator interviewing themselves. The questions are the same; the formality changes.

Load `read-the-map` first and check whether the process already exists in the workspace, so the interview confirms and extends instead of starting over.

## Inputs

- Who is being interviewed: their role, their team, the processes they own or work in.
- What is already known: survey answers, a brief, existing documentation, an existing section in the workspace, what a kickoff said.
- The scope: which processes and which systems are in.
- Anything regulated or sensitive the user has named (approvals that must exist, data that cannot leave a system, steps that cannot be automated).

## Procedure

1. **Read what is known.** List every process mentioned, every tool, every time estimate, every pain point, every wish. Note the gaps: steps with no tool, processes with no trigger, pains with no step attached, owners named as people instead of roles.
2. **Draft the walk-through per process, in run order.** Lead with "walk me through what happens when..." and put the specific questions under each stage, to ask only where the walk-through skips them.
3. **Mark what is already known** so the conversation confirms it in a sentence instead of re-asking.
4. **Write the listening checklist.** What to catch on every answer, mapped to the fields a Puzzle step carries.
5. **Keep it to one page per process.** The guide is a prompt sheet for a human conversation, or a checklist the user works through alone. It is not a script.

## The questions, by stage

Each stage names the Puzzle field it fills.

**Trigger** (the first step). What starts this? A form, an email, a date, a signed document, a threshold, a message? How do you know it has started? What happens if it starts wrong or twice?

**Steps** (step name, type, executor). What happens first, then next? Is it a person doing it, software doing it, or an AI? In which tool? Is it an email, a form, a meeting, a call, a document, a payment?

**Owners** (role, RACI). Who does it, by role rather than name? Who signs off? Who has to be asked first? Who needs to be told after?

**Decisions** (conditional steps, branch labels). What decision gets made here? What are the possible outcomes, and where does each one go? When it comes back for rework, where does it come back to?

**Handoffs** (connections). When it leaves you, who gets it and how do they find out? How do you find out it came back? What falls through?

**Data** (entities, attributes, kind). Which record gets created or updated, in which system? Which fields? Where else does that same information get typed?

**Time** (duration, frequency). How long does this step take, start to finish? How many times a week or month? When it goes wrong, how long then?

**Waits** (delay steps). Where does it sit waiting, and on whom? For how long, typically?

**Exceptions** (branches, terminators). What are the versions that don't follow the path? How often? Who handles them, and does the map need them or are they rare enough to note?

**Cadence and hot spots** (step tags, when the workspace uses them). Does this run on a schedule: daily, weekly, monthly, quarterly? Where does work pile up? Where does it break or get redone? Which steps does the customer see? Where does it change teams?

**Pain** (pain_point comments, automation candidates). Where does this hurt? What gets redone, chased, or worked around? What would you stop doing tomorrow?

**Wish** (idea comments, future state). If one step disappeared, which one? What have you tried already?

**Definitions** (glossary). Any word used twice with two meanings: ask for the definition and write it down.

**Assets** (templates, reports, docs). Is there a template, a checklist, a board, a report for this? Where does it live?

## Regulated or sensitive parts

Where the user has named them, add the questions that surface them: who must approve, what must be retained and for how long, what cannot be automated, what data cannot leave which system, who may not see what.

## Output format

```
# Process interview: <person>, <role>, <team>
Process(es): <list> · When: <date or "self-interview">

## Already known (confirm, don't re-ask)
- ...

## Process 1: <name>
Trigger: <what is known, or "ask">
Walk-through prompt: "Walk me through what happens when..."
Ask if skipped:
  Steps · Owners · Decisions · Handoffs · Data · Time · Waits · Exceptions · Pain · Wish · Assets
  (one line per stage with the specific question for this process)
Known pain points to probe: ...

## Process 2: ...

## Listening checklist (what every answer should fill)
Trigger · step name and type · executor · role and RACI · tool · fields read/written · minutes and times per month · cadence · waits · outcomes of each decision · exceptions · pain (in their words) · wishes · what is still unconfirmed · definitions · assets

## Open questions from what is known
- ...

## Comment plan (filled in after the conversation)
| Step | Type | Their words | Source |
|---|---|---|---|
| <step, or "new: <name>"> | pain_point / question / idea / note | "<quote>" | <role>, <date> |
```

## After the conversation

The answers feed `build-puzzle-process` directly: the trigger becomes the first step, each stage fills the matching field, decisions become conditionals with labeled branches, waits become delay steps, a schedule or a hot spot becomes a step tag where the workspace uses them. Anything the conversation didn't settle becomes the build skill's one intake round, not a second interview.

What people said, as opposed to what the process is, goes on the map as comments, through the comment plan:

- **pain_point**: where it hurts, in the person's words, with their role, the date and any cost they named ("two hours every Monday"). On the step where it hurts. `find-automation-opportunities` reads these. The process owner (on a client engagement, the client) gives the proposed solution as a reply in the thread; the team that builds it resolves the thread once it is Live.
- **question**: anything still unconfirmed after the conversation, with who can answer it. Resolved once the answer is in the step's fields.
- **idea**: a wish or an improvement they suggested.
- **note**: context worth keeping that fits no field.

The plan is proposed with the build's push plan and posted after approval (`create_comments` with `step_id` or `section_id`, `type` and a Markdown `body`), one thread per point. Comments post as the connected user and notify no one.

## Rules

- Never put a fact the person hasn't said into the guide as if known. Survey entries and old docs are "they said", not confirmed.
- Roles, not names, for who does a step. The map is owned by roles.
- One conversation, one person, their processes only. Scope creep starts in the interview.
- The guide is the user's working document. It is not sent to the interviewee unless the user wants it as a pre-read.
