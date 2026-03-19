---
exercise_name: feature-prioritization
study_type: features
options:
  - name: "AI Auto-Reply"
    description: "AI drafts and sends routine replies automatically, with user-set rules"
  - name: "Calendar Integration"
    description: "Schedule meetings directly from email — availability detection, one-click booking"
  - name: "Team Analytics"
    description: "Dashboard showing team email response times, volume, and bottlenecks"
  - name: "Email Scheduling Intelligence"
    description: "AI learns optimal send times per recipient for maximum open/response rates"
  - name: "CRM Sync"
    description: "Two-way sync with Salesforce/HubSpot — log emails, surface deal context, update records"
---

## Features to Evaluate

### AI Auto-Reply

Superhuman's AI already drafts replies for user review. This feature goes further: for routine emails (meeting confirmations, simple questions, acknowledgments), AI drafts and sends automatically based on user-defined rules. Users review a daily digest of what was sent on their behalf. An "undo" window of 30 seconds allows intervention.

Key tension: massive time savings vs. trust/control anxiety. "What if it says something wrong to my CEO?"

### Calendar Integration

View availability and schedule meetings without leaving Superhuman. When someone asks "when are you free?", one click inserts available slots. Detects scheduling intent in incoming emails and suggests times. Two-way sync with Google Calendar and Outlook Calendar. No Calendly link needed.

Key tension: Calendly/Cal.com already solve this. Does building it into email add enough convenience to matter? Or is it table stakes that Superhuman is missing?

### Team Analytics

Dashboard for managers showing: average response time by team member, email volume trends, messages sitting unanswered for 24+ hours, busiest communication channels, and cross-team collaboration patterns. Privacy-conscious design — shows patterns, not content.

Key tension: managers want visibility, individual contributors fear surveillance. "Is my boss going to see that I take 6 hours to reply to the VP?"

### Email Scheduling Intelligence

AI analyzes each recipient's past behavior (when they typically open and reply to emails) and suggests optimal send times. Over time, it learns patterns: "Sarah opens email at 7:15am PT" or "The engineering team ignores Friday afternoon emails." Users can auto-schedule sends for optimal timing.

Key tension: genuinely useful for sales/outreach professionals, but feels invasive. Privacy questions about tracking recipient behavior.

### CRM Sync

Two-way sync with Salesforce and HubSpot. Emails to contacts are automatically logged to the right deal/account. When reading an email, a sidebar shows deal stage, recent notes, and account history. Update deal fields without leaving Superhuman.

Key tension: huge value for sales teams (Superhuman's fastest-growing segment), but adds complexity for non-sales users. Risk of scope creep away from "fast, focused email."
