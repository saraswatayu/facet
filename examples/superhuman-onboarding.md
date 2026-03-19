---
exercise_name: onboarding-flows
study_type: onboarding
options:
  - name: "Flow A"
    description: "Concierge onboarding — 1-on-1 video call with a Superhuman specialist"
  - name: "Flow B"
    description: "Self-serve onboarding — interactive tutorial with progressive disclosure"
  - name: "Flow C"
    description: "Hybrid — self-serve setup with optional concierge call after day 3"
---

## Flows to Test

### Flow A: Concierge Onboarding (current)

Superhuman's signature: every new user gets a 30-minute 1-on-1 video call with a specialist who configures their account, teaches keyboard shortcuts, sets up Split Inbox, and ensures the user reaches "Inbox Zero" during the call.

The call is scheduled within 48 hours of signup. The user cannot access the product until the call happens.

Key dynamics:
- Extremely high-touch — creates personal investment and commitment
- The specialist customizes everything during the call (IKEA effect through guided labor)
- Users leave the call with a configured, working product (immediate value)
- Bottleneck: scales poorly. Scheduling delays lose momentum. Some users don't want a call.
- The "gate" before the call means impatient users churn before ever trying the product
- Cost: ~$25-40 per onboarding session (specialist time + scheduling overhead)

### Flow B: Self-Serve Interactive Tutorial

No human interaction. After signup, a 10-minute interactive tutorial walks users through:
1. Connect email account (Gmail or Outlook)
2. Learn 5 core shortcuts (archive, reply, snooze, remind, split inbox)
3. Process 10 real emails using shortcuts (guided practice)
4. Set up Split Inbox categories
5. Reach Inbox Zero (or close to it)

Progressive disclosure: advanced features (Snippets, Read Statuses, AI) are introduced via tooltips over the first week, not during initial setup.

Key dynamics:
- Instant access — no scheduling delay, no waiting
- Scales infinitely at near-zero marginal cost
- Users who prefer learning by doing will thrive
- Users who need hand-holding may abandon mid-tutorial
- No personalization — everyone gets the same flow
- Risk: users skip the tutorial and get overwhelmed by an unfamiliar interface

### Flow C: Hybrid

Self-serve setup (same as Flow B) gets users into the product immediately. On day 3, users who have logged in at least twice receive an offer: "Want a 15-minute call to unlock the rest of Superhuman?" The call covers advanced features, personalized workflow tips, and answers questions that arose from real usage.

Key dynamics:
- Immediate access (no gate) + personalized guidance (for those who want it)
- The day-3 call is informed by 3 days of actual usage data — the specialist can tailor advice
- Users who don't want a call still get a working product
- Lower cost per user (not everyone takes the call; calls are shorter at 15 min)
- Risk: by day 3, some users have already formed opinions ("this isn't for me") that a call can't reverse
- The opt-in call may attract only already-enthusiastic users (selection bias)
