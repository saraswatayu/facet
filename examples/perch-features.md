---
exercise_name: feature-prioritization
study_type: features
options:
  - name: "Multi-Airline Rebooking"
    description: "Automatically rebook across airlines, not just the original carrier"
  - name: "Group Trip Tracking"
    description: "Track and rebook flights for an entire travel group with one setup"
  - name: "Hotel Price Monitoring"
    description: "Extend price tracking beyond flights to hotel reservations"
  - name: "Price Prediction Alerts"
    description: "Proactive alerts when fares are historically low for a route"
  - name: "Travel Insurance Integration"
    description: "Automatically bundle travel insurance optimized for the rebooked itinerary"
---

## Features to Evaluate

### Multi-Airline Rebooking

Currently Perch can only rebook on the same airline. This feature would search across all airlines for cheaper alternatives on the same route, automatically rebooking even if it means switching carriers. Handles seat preferences, loyalty programs, and baggage policies across carriers.

### Group Trip Tracking

For travel groups (families, wedding parties, corporate teams), one person forwards all confirmation emails and Perch tracks every flight in the group. If a price drop is found, it rebooks everyone. Group dashboard shows total savings and individual status.

### Hotel Price Monitoring

Same concept as flight tracking, but for hotel reservations. Forward your hotel confirmation, and Perch monitors the rate. If the price drops, it rebooks at the lower rate (for hotels with free cancellation policies).

### Price Prediction Alerts

Before you book, Perch analyzes historical pricing data for your route and dates. It alerts you when fares are significantly below historical averages ("Book now — this fare is 32% below the 90-day average for LAX→JFK"). Helps users time their initial booking, not just the rebooking.

### Travel Insurance Integration

When Perch rebooks a flight, it automatically evaluates whether your existing travel insurance covers the change or if a new policy would be beneficial. Partners with insurance providers to offer optimized coverage for the specific rebooked itinerary, including trip interruption and cancellation coverage.
