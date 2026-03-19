# Behavioral Economics, Decision Psychology, and AI Persona Simulation

## Research Report for Facet Simulation Engine

**Date:** 2026-03-19
**Purpose:** Inform the design of realistic AI-generated personas that exhibit authentic human decision-making patterns in product pricing, feature preference, and copy evaluation simulations.

---

## Table of Contents

1. [Core Behavioral Economics for Product Decisions](#1-core-behavioral-economics-for-product-decisions)
2. [Social Influence on Product Adoption](#2-social-influence-on-product-adoption)
3. [Demographic-Specific Decision Patterns](#3-demographic-specific-decision-patterns)
4. [Subscription and Pricing Psychology](#4-subscription-and-pricing-psychology)
5. [Emotional Decision-Making](#5-emotional-decision-making)
6. [LLMs and Behavioral Economics](#6-llms-and-behavioral-economics)
7. [Decision Frameworks for Simulation](#7-decision-frameworks-for-simulation)
8. [Synthesis: Implications for Facet](#8-synthesis-implications-for-facet)

---

## 1. Core Behavioral Economics for Product Decisions

### 1.1 Prospect Theory and Reference-Dependent Preferences

**Source:** Kahneman & Tversky (1979), "Prospect Theory: An Analysis of Decision under Risk," *Econometrica*. [PDF](https://web.mit.edu/curhan/www/docs/Articles/15341_Readings/Behavioral_Decision_Theory/Kahneman_Tversky_1979_Prospect_theory.pdf)

**Source:** Barberis (2012), "Thirty Years of Prospect Theory in Economics: A Review and Assessment," NBER Working Paper 18621. [Link](https://www.nber.org/system/files/working_papers/w18621/w18621.pdf)

**Source:** Tversky & Kahneman (1991), "Loss Aversion in Riskless Choice: A Reference-Dependent Model." [Wikipedia overview](https://en.wikipedia.org/wiki/Reference_dependence)

**Key findings and actionable insights:**

- People evaluate outcomes relative to a **reference point** (typically their current state), not on an absolute scale. Losses relative to that reference point are felt approximately **2x as intensely** as equivalent gains. The median measured loss-aversion coefficient is 1.93. (Kahneman & Tversky, 1979; confirmed by multiple replications)

- Reference points are formed from: (a) the status quo, (b) lagged consumption/past experience, (c) goals/aspirations, (d) recent expectations. For persona simulation, each persona's reference point should be explicitly modeled based on their current spending patterns and alternatives.

- The loss-aversion coefficient is **magnitude-dependent**: small-stakes decisions show different loss sensitivity than large-stakes ones. A persona spending $5/month experiences a $2 price increase differently than one spending $50/month.

- **Framing matters enormously**: identical information presented as a "gain" vs. a "loss" produces different decisions. "Save $50 by choosing annual billing" vs. "You'll pay $50 more by sticking with monthly" should yield different persona reactions.

**Simulation implication:** Every persona should have an explicit reference point (their current solution/spending), and their evaluation of new options should be asymmetric around it. The magnitude of the price relative to their income shapes the loss-aversion intensity.

---

### 1.2 Mental Accounting

**Source:** Thaler (1985), "Mental Accounting and Consumer Choice," *Marketing Science*. [Link](https://pubsonline.informs.org/doi/10.1287/mksc.4.3.199)

**Source:** Thaler (1999), "Mental Accounting Matters," *Journal of Behavioral Decision Making*. [PDF](https://people.bath.ac.uk/mnsrf/Teaching%202011/Thaler-99.pdf)

**Source:** Frontiers in Psychology (2019), "Individual Differences in Mental Accounting." [Link](https://www.frontiersin.org/journals/psychology/articles/10.3389/fpsyg.2019.02866/full)

**Key findings and actionable insights:**

- People maintain separate **mental accounts** for different spending categories (entertainment, productivity, health, etc.). Money in one account is not fungible with another. A persona with a "productivity tools" budget of $30/month evaluates your product against that specific budget, not their total income.

- **Subscription services reduce the pain of paying** because the cost is "mentally written off" after initial enrollment, hiding subsequent payments and undermining awareness of true cumulative cost.

- People evaluate transactions using **transaction utility** (the deal quality relative to a reference price) in addition to **acquisition utility** (the actual value received). A product priced at $9.99 that a persona "expected" to cost $15 provides positive transaction utility even if the actual value is marginal.

- Individual expenses are evaluated in the context of **two accounts**: the current budgetary period and the expense category, not lifetime wealth.

**Simulation implication:** Each persona should have explicitly modeled spending categories with approximate budgets. Their evaluation of a new product should be influenced by what "account" they mentally file it under and what else competes in that account.

---

### 1.3 Anchoring Effects

**Source:** Tversky & Kahneman (1974), "Judgment under Uncertainty: Heuristics and Biases," *Science*.

**Source:** Frontiers in Psychology (2022), "An Experimental Study on Anchoring Effect of Consumers' Price Judgment." [Link](https://www.frontiersin.org/journals/psychology/articles/10.3389/fpsyg.2022.794135/full)

**Source:** Ariely, Loewenstein & Prelec (2003), "Coherent Arbitrariness." [Stanford GSB working paper](https://www.gsb.stanford.edu/faculty-research/working-papers/anchoring-effects-consumers-willingness-pay-willingness-accept)

**Key findings and actionable insights:**

- Anchor values that are **completely arbitrary** (e.g., the last two digits of a social security number) significantly influence price expectations and willingness to pay. The first price a persona encounters for a product category sets an anchor that biases all subsequent evaluations.

- **Gender differences**: Women are more likely to be influenced by representation information and anchoring when making price judgments. Men tend toward more heuristic processing that may or may not respond to the same anchors.

- **Education and income**: Less educated consumers with lower exposure to price comparison tools are more susceptible to initial price anchors. Higher-income consumers may anchor to quality signals rather than price points.

- **Knowledge modulates anchoring**: Domain experts are less susceptible to anchoring than novices, but are not immune. A tech-savvy persona will be less price-anchored than a tech-unfamiliar one, but both will be influenced.

**Simulation implication:** Each persona's first exposure to a product's price should create an anchor. Personas with lower financial literacy or less category experience should show stronger anchoring effects. The competitor/alternative pricing landscape should be part of each persona's context.

---

### 1.4 Endowment Effect and Psychological Ownership

**Source:** Norton, Mochon & Ariely (2012), "The IKEA Effect: When Labor Leads to Love," *Journal of Consumer Psychology*. [HBS PDF](https://www.hbs.edu/ris/Publication%20Files/11-091.pdf)

**Source:** Springer (2025), "Turning Free Trials into Treasures: The Effect of Perceived Control on Psychological Ownership of Digital Products," *Current Psychology*. [Link](https://link.springer.com/article/10.1007/s12144-025-08231-x)

**Source:** Kahneman, Knetsch & Thaler (1990), "Experimental Tests of the Endowment Effect."

**Key findings and actionable insights:**

- People assign **higher value to items they own** compared to identical items they do not own. This is the core mechanism behind free trial conversion: once users integrate a product into their workflow, they feel they already "own" it.

- **Period-limited trials** (full access, time-restricted) are more effective at creating psychological ownership than **part-limited trials** (limited features, no time restriction), because full access allows deeper integration and customization.

- The **IKEA effect**: labor invested in customizing or configuring a product increases valuation. Users who spend time setting up preferences, importing data, or creating content within a product develop stronger ownership feelings. This works for both novices and experts.

- The loss aversion multiplier applies: **the prospect of losing access at trial end triggers pain roughly 2x the pleasure** of the original gain. The closer the trial end approaches, the stronger the aversion to losing access.

- Critically, **labor leads to love only when the task is completed successfully**. If a user fails to set up a product or has a frustrating experience, the effect dissipates or reverses.

**Simulation implication:** Personas who successfully complete onboarding and invest effort in configuration should show higher willingness to pay at conversion. Personas who struggle should show the opposite. Trial length and feature access model should be part of the simulation variables.

---

### 1.5 Status Quo Bias and Switching Costs

**Source:** Samuelson & Zeckhauser (1988), "Status Quo Bias in Decision Making," *Journal of Risk and Uncertainty*.

**Source:** Kim & Kankanhalli (2009), "Investigating User Resistance to Information Systems Implementation." [Springer review](https://link.springer.com/article/10.1007/s11301-022-00283-8)

**Source:** Polites & Karahanna (2012), "Shackled to the Status Quo." [Academia.edu](https://www.academia.edu/55480137)

**Key findings and actionable insights:**

- Status quo bias involves three interacting mechanisms: **(a) habitual use** of the current solution, **(b) perceived transition costs** (learning curve, migration effort, uncertainty), and **(c) psychological sunk costs** (investment already made in the current tool).

- These mechanisms create **inertia** that mediates the impact on new product adoption. Even when a new product is objectively superior, the switching costs can be overwhelming.

- **Real-world switching cost categories**: financial (cancellation fees, new subscription costs), procedural (learning new interfaces, migrating data), relational (losing relationships with support teams, community), and cognitive (mental effort of evaluating alternatives).

- The strength of status quo bias varies by personality and context: more conservative personas and those with high uncertainty avoidance show stronger bias.

**Simulation implication:** Each persona's current tool/solution should be explicitly defined, along with estimated switching costs (time, money, effort). The simulation should model whether the perceived benefit of the new product exceeds the perceived switching cost for each persona.

---

### 1.6 Hyperbolic Discounting and Present Bias

**Source:** Laibson (1997), "Golden Eggs and Hyperbolic Discounting," *Quarterly Journal of Economics*.

**Source:** Enke (2024), "Complexity and Hyperbolic Discounting," Harvard Business School Working Paper 24-048. [PDF](https://www.hbs.edu/ris/Publication%20Files/24-048_304d978e-f730-4523-a9e0-4370f82ebd03.pdf)

**Source:** PMC (2024), "Navigating Time-Inconsistent Behavior: The Influence of Financial Knowledge." [Link](https://pmc.ncbi.nlm.nih.gov/articles/PMC11591072/)

**Key findings and actionable insights:**

- People discount the value of future rewards **hyperbolically**, not exponentially: short-term delays are discounted extremely steeply, while longer delays are discounted much more gradually. A benefit available "next week" is valued far less than one available "today," but a benefit available "in 12 months" vs. "in 13 months" is discounted nearly equally.

- This creates **present bias**: consumers overly weight immediate benefits and costs. A $9.99/month subscription feels cheaper than a $99/year subscription despite costing more, because the immediate pain is lower.

- **Financial knowledge and behavior moderate hyperbolic discounting**: financially literate personas should show less steep discounting. Lower-income personas facing scarcity show steeper discounting because cognitive load increases reliance on heuristics.

- **Marketing exploitation**: limited-time offers, urgency messaging, and countdown timers all exploit hyperbolic discounting by making the immediate reward (the deal) more salient than the future cost.

**Simulation implication:** Personas should exhibit different discount rates based on financial sophistication, income level, and cognitive load. Monthly vs. annual pricing framing should produce systematically different responses. Personas under financial stress should show steeper discounting.

---

### 1.7 Choice Overload (Paradox of Choice)

**Source:** Iyengar & Lepper (2000), "When Choice Is Demotivating," *Journal of Personality and Social Psychology*. [PDF](https://faculty.washington.edu/jdb/345/345%20Articles/Iyengar%20&%20Lepper%20(2000).pdf)

**Source:** Chernev, Bockenholt & Goodman (2015), "Choice Overload: A Conceptual Review and Meta-Analysis," *Journal of Consumer Psychology*. [PDF](https://chernev.com/wp-content/uploads/2017/02/ChoiceOverload_JCP_2015.pdf)

**Source:** Iyengar, Huberman & Jiang (2004), "How Much Choice is Too Much? 401(k) Plans."

**Key findings and actionable insights:**

- The famous jam study: 24 options attracted 60% of passers-by but only 3% purchased; 6 options attracted 40% but **30% purchased** -- a 10x conversion difference.

- In 401(k) plan analysis of 800,000 employees: as fund options increased, participation rates decreased. Plans with fewer than 10 options had the highest enrollment rates.

- Working memory spans approximately 7 +/- 2 items. When options exceed cognitive capacity, decision-makers feel overwhelmed, less motivated, and less satisfied with their eventual choice.

- A 2015 meta-analysis of 99 observations identified four key moderators: **choice set complexity**, **decision task difficulty**, **preference uncertainty**, and **decision goal**. Choice overload is strongest when people are uncertain about their preferences and when options are complex.

**Simulation implication:** Pricing pages with more than 3-4 tiers should produce choice paralysis in some personas, especially those with low domain expertise. The simulation should model decision fatigue: personas encountering complex option matrices should sometimes defer the decision entirely.

---

### 1.8 The Framing Effect

**Source:** Tversky & Kahneman (1981), "The Framing of Decisions and the Psychology of Choice," *Science*.

**Source:** PMC (2023), "Why It Is Good to Communicate the Bad: Influence of Message Framing." [Link](https://pmc.ncbi.nlm.nih.gov/articles/PMC10508293/)

**Source:** PMC (2020), "Consumer Responses to Savings Message Framing." [Link](https://pmc.ncbi.nlm.nih.gov/articles/PMC7367006/)

**Key findings and actionable insights:**

- Identical information presented differently produces different decisions. "95% fat-free" vs. "5% fat" evokes different reactions despite being logically equivalent.

- **Gain frames** encourage certainty-seeking behavior; **loss frames** encourage risk-seeking behavior. "Save $50 with annual billing" (gain frame) vs. "You'll waste $50 without annual billing" (loss frame) -- the loss frame is typically more motivating due to loss aversion.

- McDonald's increased Quarter Pounder sales 30% by reframing "not frozen" to "fresh beef." Amazon frames Prime's $139/year as "less than $12/month," contributing to 90%+ retention rates.

- The framing effect interacts with product type: for utilitarian products, positive frames outperform; for hedonic products, loss frames can be more effective.

- **Percentage vs. absolute framing**: percentage-off framing is computationally difficult and can actually reduce engagement. Absolute dollar savings are processed more easily.

**Simulation implication:** Copy variant testing in Facet should model personas responding differently to gain vs. loss framing. The persona's risk orientation and the product type should determine which frame is more effective.

---

### 1.9 The Default Effect

**Source:** Thaler & Sunstein (2008), *Nudge: Improving Decisions About Health, Wealth, and Happiness*.

**Source:** PMC (2024), "Framing the Default: Influence of Choosing Versus Rejecting Frame." [Link](https://pmc.ncbi.nlm.nih.gov/articles/PMC11612645/)

**Key findings and actionable insights:**

- A meta-analysis of 58 studies found a robust medium-sized effect (d = 0.68): opt-out defaults lead to dramatically higher uptake than opt-in defaults.

- Real-world example: organ donation rates reach 90%+ in opt-out countries versus under 15% in opt-in countries.

- Defaults work through three mechanisms: (a) cognitive cost of changing the default, (b) loss aversion (changing feels like losing the default), (c) implied endorsement (the default seems "recommended").

**Simulation implication:** When simulating feature selection or pricing tier defaults, personas should show strong bias toward whatever is pre-selected. This is especially relevant for "recommended" plan badges on pricing pages.

---

### 1.10 Sunk Cost Fallacy

**Source:** Arkes & Blumer (1985), "The Psychology of Sunk Cost," *Organizational Behavior and Human Decision Processes*.

**Source:** IJRTI (2025), "The Psychology of Subscription Models." [PDF](https://www.ijrti.org/papers/IJRTI2505112.pdf)

**Key findings and actionable insights:**

- 68% of research participants continued investments due to previous financial commitments, regardless of future expected value.

- **Age sensitivity**: older individuals (46+) are more susceptible (80%) to sunk cost effects. Brand-loyal consumers are 85% more likely to persist despite dissatisfaction.

- In subscription contexts, sunk costs create a paradox: customers who have paid for months but rarely use a service may *continue* paying because cancellation would mean "wasting" past payments, yet simultaneously feel resentment building.

- Progress indicators ("80% completed") and onboarding investment reminders exploit sunk cost psychology to reduce churn.

**Simulation implication:** Personas who have invested time or money in setup/onboarding should show resistance to cancellation even when dissatisfied. Older personas and brand-loyal personas should exhibit this more strongly.

---

## 2. Social Influence on Product Adoption

### 2.1 Social Proof Mechanisms

**Source:** Cialdini (1984), *Influence: The Psychology of Persuasion*.

**Source:** WiserNotify (2026), "33 Impactful Social Proof Statistics." [Link](https://wisernotify.com/blog/social-proof-statistics/)

**Source:** Journal of Marketing & Social Research (2024). [PDF](https://www.jmsr-online.com/article/download/pdf/47/)

**Key findings and actionable insights:**

- Social proof operates through three mechanisms: **(a) informational influence** (using others as data sources), **(b) normative influence** (desire to fit in), and **(c) group wisdom assumption** (believing collective decisions are better).

- **Age-specific responses**: 18-24 year olds expect an average of 203 reviews per product page; all-age average is 112. Younger consumers are more influenced by social media influencers; working professionals (25-44) rely more on peer recommendations.

- **Demographic matching matters**: a 35-year-old professional is more influenced by reviews from other professionals in their age group than by celebrities or different demographic groups.

- 92% of people trust word-of-mouth referrals more than any form of advertising.

**Simulation implication:** Each persona's social proof sensitivity should vary by age, professional identity, and social orientation. The type of social proof that resonates (reviews, expert endorsements, peer usage counts, celebrity) should be persona-specific.

---

### 2.2 Referral Psychology and Word-of-Mouth

**Source:** Wojnicki & Godes (2008), "Word-of-Mouth as Self-Enhancement," *Journal of Marketing Research*.

**Source:** Tremendous (2026), "Psychology Behind Word-of-Mouth Marketing." [Link](https://www.tremendous.com/blog/word-of-mouth-marketing-psychology/)

**Source:** PMC (2023), "Information Distortion in Word-of-Mouth Retransmission." [Link](https://pmc.ncbi.nlm.nih.gov/articles/PMC10105362/)

**Key findings and actionable insights:**

- People recommend products for **self-enhancement**: when broadcasting (sharing with large audiences), the primary motivation is appearing smart or savvy. When **narrowcasting** (sharing with an individual), the motivation shifts to helping the other person.

- **Referral distortion is real**: approximately 60% of stories are distorted in retransmission. When the retransmitter has a persuasive (vs. informative) intent, distortion increases, especially exaggeration. Entertainment goals lead people to make stories more extreme.

- Referred customers have **37% higher retention rates** and **16-25% higher lifetime values**. Word-of-mouth generates 2x the sales of paid advertising.

- **Perceived behavioral control** (feeling capable of making the referral) is the strongest predictor of referral program participation, followed by subjective norms and attitude.

**Simulation implication:** Facet's referral chains should model distortion -- the product description should mutate as it passes through social connections. The referrer's motivation (self-enhancement vs. helpfulness) should shape what they emphasize. This is already partially in the weave template but could be made more systematic.

---

### 2.3 Diffusion of Innovation

**Source:** Rogers (2003), *Diffusion of Innovations*, 5th edition.

**Source:** High Tech Strategies, "Innovation Adoption Curve: Adopter-Segment Profiles." [Link](https://www.hightechstrategies.com/innovation-adoption-curve/)

**Key findings and actionable insights:**

- Five adopter categories with distinct personality profiles:
  - **Innovators** (2.5%): adventurous, risk-tolerant, technology-obsessed, high social status
  - **Early Adopters** (13.5%): opinion leaders, younger, higher education, financially literate, empathetic
  - **Early Majority** (34%): prudent, wait for trusted peer validation, not risk-taking
  - **Late Majority** (34%): conservative, technologically cautious, very cost-sensitive, skeptical
  - **Laggards** (16%): traditional, resist change until forced, lowest risk tolerance

- Key personality differentiators: empathy, dogmatism, capacity for abstraction, rationality, attitude toward change, risk tolerance, self-efficacy, aspiration level.

- Each category requires **different persuasion approaches**: innovators respond to novelty; early adopters to competitive advantage; early majority to proven reliability; late majority to social pressure; laggards to necessity.

**Simulation implication:** Facet's segment matrix should explicitly map each segment to a position on the adoption curve. Persona psychographic traits should include their adopter category, and their decision patterns should reflect the corresponding profile.

---

### 2.4 Network Effects and Critical Mass

**Source:** Metcalfe's Law; Shapiro & Varian (1998), *Information Rules*.

**Source:** Cornell Networks textbook, Chapter 17. [PDF](https://www.cs.cornell.edu/home/kleinber/networks-book/networks-book-ch17.pdf)

**Source:** NFX (2019), "The Network Effects Bible." [Link](https://www.nfx.com/post/network-effects-bible)

**Key findings and actionable insights:**

- **Critical mass** is the adoption threshold beyond which a product becomes self-sustaining. Controlled experiments suggest approximately **25% of a population** is sufficient to overturn established conventions, but the exact threshold is context-dependent.

- In early adoption phases, incentives to adopt are low. After critical mass, a **bandwagon effect** creates positive feedback: each new adopter increases value, attracting more adopters.

- For persona simulation, the *perceived* adoption level matters as much as the actual level. A persona who believes "everyone is using this" will behave differently than one who sees it as niche, even if objective adoption is the same.

**Simulation implication:** Personas should have different perceptions of how widely adopted a product is, based on their social circles and information exposure. Social proof sensitivity should interact with perceived adoption level.

---

### 2.5 Tribal Identity and Brand as Identity Signal

**Source:** Tajfel & Turner (1979), Social Identity Theory.

**Source:** Raimondo (2022), "Consumers' Identity Signaling Towards Social Groups," *Psychology & Marketing*. [Link](https://onlinelibrary.wiley.com/doi/full/10.1002/mar.21711)

**Source:** Consumer Culture Theory literature.

**Key findings and actionable insights:**

- Product choice often functions as **identity signaling**: people acquire products to communicate values, lifestyle, or social group membership. "I use [Product X]" becomes "I am the kind of person who uses [Product X]."

- In collectivist cultures, brand loyalty is stronger because switching brands distinguishes an individual from the group. In individualist cultures, product choice signals personal identity more than group belonging.

- **Dissociative desire**: people also avoid products associated with groups they want to distance themselves from. A persona may reject a product not because of its features but because of who else uses it.

- Product symbolism mediates the relationship between consumption and identity formation: the more symbolically loaded a product is, the more it shapes how a persona sees themselves.

**Simulation implication:** Some personas should evaluate products partly through the lens of "what does using this say about me?" This is especially true for visible, shareable, or socially-discussed products. Persona segments should include identity-signaling motivations where relevant.

---

## 3. Demographic-Specific Decision Patterns

### 3.1 Age and Generational Differences

**Source:** SAGE Journals (2025), "Generational Investment Behavior." [Link](https://journals.sagepub.com/doi/10.1177/21582440251352342)

**Source:** MDPI (2022), "Generational Differences, Risk Tolerance, and Ownership of Financial Securities." [Link](https://www.mdpi.com/2227-7072/10/2/35)

**Key findings and actionable insights:**

- **Gen Z** (born ~1997-2012): more risk-averse than previous generations due to entering adulthood during COVID-19. Heightened sensitivity to potential losses. Technology is integral to daily life. Minimal response to technology-adoption nudges -- they already use everything.

- **Millennials** (born ~1981-1996): technology adoption enhances engagement significantly. Moderate-to-high risk tolerance for investments. Higher sensitivity to social proof through digital channels.

- **Gen X** (born ~1965-1980): gradual technological adaptation through repeated exposure. Higher risk capacity due to career establishment. "Technological tolerance" rather than enthusiasm.

- **Baby Boomers** (born ~1946-1964): more likely to own financial investments overall. Lower technology adoption but when adopted, they are methodical users. Fixed-income considerations create different pricing sensitivity.

**Simulation implication:** Persona age should systematically influence risk tolerance, technology comfort, price sensitivity, and social proof channel preferences. This should be operationalized beyond simple stereotypes -- a tech-savvy 65-year-old is realistic and valuable for simulation diversity.

---

### 3.2 Income and Scarcity Mindset

**Source:** Shah, Mullainathan & Shafir (2012), "Some Consequences of Having Too Little," *Science*.

**Source:** PNAS (2019), "A Scarcity Mindset Alters Neural Processing Underlying Consumer Decision Making." [Link](https://www.pnas.org/doi/10.1073/pnas.1818572116)

**Source:** Journal of the Association for Consumer Research (2020), "Scarcity and Consumer Decision Making." [Link](https://www.journals.uchicago.edu/doi/full/10.1086/710531)

**Key findings and actionable insights:**

- **Scarcity mindset** increases activity in the orbitofrontal cortex (valuation) while decreasing activity in dorsolateral prefrontal cortex (goal-directed choice). This means people under financial stress are simultaneously *more* focused on prices and *less* able to make optimal decisions.

- People under scarcity spend **significantly more time on price-related information** and **less time on other useful information** (features, reviews, comparisons).

- Poverty-related decision patterns include: higher-interest loans, less savings, more present-biased choices, more lottery participation -- all stemming from cognitive load, not irrationality.

- The scarcity mindset is **contextual, not permanent**: the same person can shift between scarcity and abundance thinking based on recent financial events, pay cycles, and emotional state.

**Simulation implication:** Low-income personas should exhibit: stronger price focus, steeper hyperbolic discounting, more heuristic-based decisions, less attention to feature details, and higher sensitivity to "free" offers. This should be modeled as a cognitive pattern, not a character flaw.

---

### 3.3 Cultural Dimensions

**Source:** Hofstede (1980, 2001), *Cultures and Organizations: Software of the Mind*.

**Source:** Scielo (2018), "How Does National Culture Impact Consumer Decision-Making Styles?" [Link](https://www.scielo.br/j/bar/a/4xJ5VDbd48m53mJtMVCpzMB/?lang=en)

**Source:** SAGE Journals (2015), "Consumer Ethnocentrism, National Identity, and Consumer Cosmopolitanism." [Link](https://journals.sagepub.com/doi/10.1509/jim.14.0038)

**Key findings and actionable insights:**

- **Individualism vs. Collectivism**: Individualist cultures (US, UK, Australia) emphasize personal achievement and personal benefit in product evaluation. Collectivist cultures (Japan, China, Korea) prioritize group harmony, popular/proven brands, and social acceptance. Brand switching in collectivist cultures is more psychologically costly because it distinguishes from the group.

- **Uncertainty Avoidance**: High UA cultures (Japan, Greece, Portugal) prefer clear rules, detailed plans, known brands. They respond well to safety-focused messaging and established brands. Low UA cultures (US, UK, Sweden) are more comfortable with novelty and ambiguity.

- **Long-term Orientation**: Cultures high on this dimension (East Asia) are more willing to invest now for future benefits. Short-term oriented cultures prefer immediate rewards.

- For product marketing: "In high uncertainty avoidance cultures, emphasize safety. In low uncertainty avoidance cultures, emphasize adventure."

**Simulation implication:** Personas from different cultural backgrounds should show systematically different evaluation patterns. However, within-culture variation is large -- cultural background should be a probabilistic influence, not a deterministic one. Personas of the same ethnicity should still show meaningful individual variation.

---

### 3.4 Gender Differences in Information Processing

**Source:** Meyers-Levy & Maheswaran (1991), "Exploring Differences in Males' and Females' Processing Strategies," *Journal of Consumer Research*.

**Source:** Meyers-Levy (1989), "Gender Differences in Information Processing: A Selectivity Interpretation."

**Source:** Springer (2023), "Men on a Mission, Women on a Journey." [Link](https://www.sciencedirect.com/science/article/abs/pii/S0969698923002230)

**Key findings and actionable insights:**

- The **selectivity model**: women tend to be comprehensive information processors who evaluate both subjective and objective product attributes and respond to subtle cues. Men tend to be selective processors who use heuristics and may miss subtle details.

- In e-commerce: men are more affected by website interactivity; women are more affected by vividness, information diagnosticity, and perceived risk.

- Women process both the claims and the context; men process primarily the claims. This means copy variants may perform differently across genders not because of content preferences but because of *how much* of the content is actually processed.

**Simulation implication:** Female personas should generally evaluate copy variants more comprehensively, attending to subtle tone and trust cues. Male personas should respond more to clear, heuristic-friendly messaging (numbers, rankings, comparisons). But this is a tendency, not a rule -- individual variation should override gender stereotypes.

---

### 3.5 Urban vs. Rural Decision Patterns

**Source:** PNAS Nexus (2023), "Exposure to Urban and Rural Contexts Shapes Smartphone Usage Behavior." [Link](https://academic.oup.com/pnasnexus/article/2/11/pgad357/7442564)

**Source:** SAGE (2024), "Bridging the Digital Divide: FinTech Adoption in Rural Communities." [Link](https://journals.sagepub.com/doi/full/10.1177/21582440241227770)

**Key findings and actionable insights:**

- Urban consumers: higher brand awareness, more convenience-oriented, greater exposure to diverse products, more comfortable with digital-first experiences. Use smartphones for service access and navigation.

- Rural consumers: more price-sensitive, trust-driven, community-influenced. Research online but purchase cautiously. Word-of-mouth and peer reviews are disproportionately influential. In rural areas, families play a crucial role in transmitting financial values and technology attitudes across generations.

- Rural consumers exhibit more **rational and logical** buying behavior compared to urban counterparts, partly because each purchase decision carries more weight when resources are limited.

**Simulation implication:** Personas in rural settings should show: stronger community influence, more deliberate purchase processes, higher price sensitivity, and greater reliance on word-of-mouth. Urban personas should show more impulsive adoption but also more churn.

---

## 4. Subscription and Pricing Psychology

### 4.1 Subscription Fatigue

**Source:** Self Financial (2025) survey data.

**Source:** CivicScience (2024-2025), streaming subscription fatigue surveys. [Link](https://civicscience.com/feelings-of-video-subscription-fatigue-take-hold-driving-streamers-to-switch-churn-and-cancel/)

**Source:** Antenna (2024), Q4 churn rate data.

**Key findings and actionable insights:**

- The average household has trimmed paid subscriptions from **4.1 in 2024 to 2.8 in 2025** -- a 32% drop in a single year.

- **41% of consumers** in 2025 say they experience subscription fatigue, up from 35% in mid-2024.

- 2 out of 3 consumers cancelled at least one subscription in the past year (Bluelabel 2024 survey).

- Nearly half (49.7%) say **any further price increase** would be unacceptable.

- Churn rates for video-on-demand services reached an all-time high of **44% in Q4 2024**.

**Simulation implication:** Every persona should have a defined number of existing subscriptions. Personas with 4+ active subscriptions should show significantly higher resistance to new subscription commitments. The simulation should model subscription fatigue as a dynamic that intensifies with each additional subscription, not a binary threshold.

---

### 4.2 The Zero Price Effect (Psychology of Free)

**Source:** Shampanier, Mazar & Ariely (2007), "Zero as a Special Price: The True Value of Free Products," *Marketing Science*. [PDF](https://web.mit.edu/ariely/www/MIT/Papers/zero.pdf)

**Source:** St. Louis Fed (2025), "The Psychology of Free." [Link](https://www.stlouisfed.org/publications/page-one-economics/2025/apr/psychology-of-free-how-price-of-zero-influences-decisionmaking)

**Key findings and actionable insights:**

- Zero is not just another price point -- it is **qualitatively different**. People act as if zero pricing not only decreases cost but also adds to the product's perceived benefits.

- The famous candy experiment: at 1 cent, 58 students stopped and took an average of 3.5 candies. At zero cents, **207 students stopped** but took only 1.1 candies each. Free attracts far more people but paradoxically triggers more restrained consumption (social norms activate at zero price).

- The primary mechanism is **affect**: free generates positive emotional response disproportionate to the economic value.

- In freemium models, the free tier creates a massive top-of-funnel but conversion is the challenge. The emotional warmth of "free" must be carefully transitioned to a pricing conversation without destroying the positive affect.

**Simulation implication:** Personas evaluating freemium products should show: (a) disproportionate attraction to free tiers, (b) qualitative shift in evaluation when any price is introduced (even $1), (c) social-norm-influenced consumption of free tiers. The "free to $X" transition should be modeled as a psychologically distinct moment, not just a price comparison.

---

### 4.3 Flat-Rate Bias

**Source:** Lambrecht & Skiera (2006), "Paying Too Much and Being Happy About It," *Journal of Marketing Research*. [PDF](https://www.marketing.uni-frankfurt.de/fileadmin/Publikationen/Lambrecht_Skiera_Tariff-Choice-Biases-JMR.pdf)

**Source:** Springer (2022), "Consumer Preference for Pay-Per-Use Service Tariffs: The Roles of Mental Accounting." [Link](https://link.springer.com/article/10.1007/s11747-022-00853-y)

**Key findings and actionable insights:**

- Consumers systematically prefer flat-rate pricing over pay-per-use, **even when flat-rate is more expensive for their actual usage**. This bias is driven by four effects:

  1. **Insurance effect**: certainty that costs won't exceed a planned amount
  2. **Overestimation effect**: consumers overestimate their future usage
  3. **Convenience effect**: reduced need to monitor and compare
  4. **Taximeter effect**: per-use billing creates anxiety during consumption (the "meter running" feeling)

- Remarkably, **even professional purchasing agents** exhibit flat-rate bias, suggesting it is not merely a consumer naivete issue.

- The taximeter effect connects to Prelec & Loewenstein's pain-of-paying research: per-use pricing couples payment to consumption, maximizing payment pain.

**Simulation implication:** Most personas should show preference for flat-rate/subscription pricing over per-use pricing at equivalent expected cost. Exceptions: very low-usage personas and highly analytical personas who calculate actual cost. The taximeter effect should be explicitly modeled in personas evaluating per-use pricing.

---

### 4.4 Charm Pricing (Price Ending Effects)

**Source:** Troll et al. (2024), "A Meta-Analysis on the Effects of Just-Below Versus Round Prices," *Journal of Consumer Psychology*. [Link](https://myscp.onlinelibrary.wiley.com/doi/full/10.1002/jcpy.1353)

**Source:** Stiving & Winer (1997), "An Empirical Analysis of Price Endings with Scanner Data."

**Source:** Ortega & Tabares (2023), research on when charm pricing backfires.

**Key findings and actionable insights:**

- Meta-analysis of 69 studies: just-below prices ($X.99) increase purchase decisions, improve price image, have no effect on perceived quality, and are more likely to be underestimated (the left-digit effect).

- The left-digit effect: $9.99 is anchored on "9" not "10," making items appear significantly cheaper. Charm prices outperform rounded prices by approximately 24%.

- **When charm pricing backfires**: for premium/luxury brands and high-quality signaling products, round prices ($10.00) outperform charm prices ($9.99). The .99 association with "bargain" undermines quality perception.

- Walmart adopted charm pricing (.97, .98 endings) after consumer behavior analysis, improving competitive positioning against Amazon.

**Simulation implication:** For mass-market products, charm pricing should improve persona conversion. For premium-positioned products, round pricing should signal quality. Personas with higher income or luxury orientation should respond differently than price-sensitive personas.

---

### 4.5 The Decoy Effect and Compromise Effect

**Source:** Huber, Payne & Puto (1982), "Adding Asymmetrically Dominated Alternatives."

**Source:** Ariely (2008), *Predictably Irrational*, Chapter 1.

**Source:** Simon-Kucher, "Positioning Decoy Pricing to Shape Customer Value Perception." [Link](https://www.simon-kucher.com/en/insights/positioning-decoy-pricing-shape-how-customers-perceive-value)

**Key findings and actionable insights:**

- The **decoy effect**: adding an asymmetrically dominated third option shifts preference toward the "target" option. The Economist subscription experiment is the classic case: print-only at $125 made print+online at $125 seem like an obvious deal, dramatically shifting preference from online-only at $59.

- The **compromise effect**: when three options are presented, consumers tend to prefer the middle option as a "safe" choice. This is why most three-tier pricing structures see the middle tier outperform.

- The decoy effect is **stronger when people need to justify their choice to others**. The decoy provides an easy rationale.

- A $2,000 option makes a $500 option seem reasonable even if $500 is more than the buyer would otherwise pay (contrast effect / anchor shifting).

**Simulation implication:** When simulating pricing pages with 3+ tiers, the simulation should model both decoy and compromise effects. Personas who are more analytical should be somewhat less susceptible, but not immune. The effect should be visible in which tier personas select.

---

### 4.6 Payment Pain and Timing

**Source:** Prelec & Loewenstein (1998), "The Red and the Black: Mental Accounting of Savings and Debt," *Marketing Science*.

**Source:** Knutson et al. (2007), "Neural Predictors of Purchases," *Neuron* (Stanford/CMU/MIT fMRI study).

**Source:** Shah et al. (2016), "Effects of Payment Mechanism on Spending Behavior." [PDF](https://www-2.rotman.utoronto.ca/facbios/file/paymechjcr.pdf)

**Key findings and actionable insights:**

- Payment creates literal **pain** -- fMRI studies show activation of the anterior insula (pain region) when prices are perceived as excessive.

- **Credit cards double willingness to pay** compared to cash, because they decouple payment from consumption (temporal separation reduces pain).

- **Two key concepts**: Prospective accounting (enjoyment is greater when payment precedes consumption) and Coupling (the degree to which payment is linked to consumption in the consumer's mind). Decoupling reduces pain; coupling increases it.

- Consumers pay off expenditures on transient consumption (meals, experiences) more quickly than durables, because the pain of paying for something that no longer provides pleasure is greater.

**Simulation implication:** Per-use pricing creates maximum payment pain (tight coupling). Annual prepaid subscriptions create positive prospective accounting ("I already paid, might as well enjoy it"). Monthly subscriptions fall in between. Each persona's preferred payment method and timing should influence their experience.

---

## 5. Emotional Decision-Making

### 5.1 The Role of Emotions in Purchase Decisions

**Source:** Antonio Damasio (1994), *Descartes' Error* (somatic marker hypothesis).

**Source:** Research & Metric (2025), "Consumer Psychology Buying Decisions: 95% Are Emotional." [Link](https://www.researchandmetric.com/blog/consumer-psychology-buying-decisions-emotional-factors/)

**Source:** ResearchGate, "What We Feel and Why We Buy: The Influence of Emotions on Consumer Decision-Making." [Link](https://www.researchgate.net/publication/293801220)

**Key findings and actionable insights:**

- Estimates suggest that up to **95% of purchasing decisions** are driven by subconscious emotional processes, with rational analysis serving primarily as post-hoc justification.

- **Anticipatory dopamine**: the anticipation of a purchase triggers a stronger dopamine response than the actual purchase itself. Anticipation-building strategies increase purchase intent and willingness to pay premium prices by 20-40%.

- Excitement about potential outcomes drives **45% of purchase completions**, particularly in experiential and aspirational categories.

- **Anxiety and overwhelm** characterize the information-gathering phase of complex purchases. Brands that simplify choice architecture while providing emotional reassurance see 25% higher conversion rates.

**Simulation implication:** Persona internal monologues should be primarily emotional, not rational. The "behavioral psychology" section of each persona should include emotional drivers and anxieties, not just analytical frameworks. The simulation should capture anticipatory excitement and anxiety as distinct phases.

---

### 5.2 Post-Purchase Rationalization

**Source:** Festinger (1957), *A Theory of Cognitive Dissonance*.

**Source:** Psychology Today, "Buyer's Remorse." [Link](https://www.psychologytoday.com/us/blog/wishful-thoughts/201708/buyers-remorse)

**Key findings and actionable insights:**

- Over **80% of consumers** experience buyer's remorse, yet most never return the product.

- Post-purchase rationalization is a cognitive bias where buyers downplay flaws and emphasize benefits to justify their decision. The more expensive the purchase, the stronger the rationalization drive.

- Three elements predict the severity of cognitive dissonance: **effort** (resources invested), **responsibility** (felt agency in the decision), and **commitment** (degree of irreversibility).

- After committing to a product, people actively seek information confirming their choice and avoid disconfirming information.

**Simulation implication:** Personas who convert should show rationalization in their internal monologues at the renewal point. The 12-month simulation should include a "post-purchase justification" phase where the persona constructs a narrative about why their choice was correct, even in the face of friction.

---

### 5.3 Trust Formation and Decay

**Source:** Yale School of Management (2023), "Navigating Brand Trust in Modern Marketing." [Link](https://som.yale.edu/story/2023/navigating-brand-trust-modern-marketing)

**Source:** Edelman Trust Barometer (annual). 67% of consumers must trust a brand before purchasing.

**Source:** Manchester Research (PDF), "Consumer Trust and Distrust." [PDF](https://research.manchester.ac.uk/files/261211368/FULL_TEXT.PDF)

**Key findings and actionable insights:**

- Trust and distrust are **asymmetric**: trust is built slowly through consistent positive experiences but can be destroyed rapidly by a single negative event.

- **Trust has cognitive and affective dimensions**: cognitive trust is based on rational evidence (reviews, track record, transparency); affective trust is based on emotional connection and feeling cared for.

- In digital environments, an over-proliferation of trust signals (badges, ratings, testimonials) creates **"trust inflation"** where these cues lose informativeness.

- Relationship length increases the influence of trust -- long-time customers are more forgiving of individual failures than new customers.

**Simulation implication:** Each persona should have a trust threshold that must be met before conversion. The trust-building signals on a landing page (social proof, security badges, transparent pricing) should be evaluated differently by different personas. Personas who have negative experiences during simulation should show trust decay that is harder to reverse than the original trust was to build.

---

### 5.4 Regret Aversion

**Source:** Bell (1982), "Regret in Decision Making Under Uncertainty."

**Source:** PMC (2025), "Can Anticipated Regret Promote Rationality?" [Link](https://pmc.ncbi.nlm.nih.gov/articles/PMC12460334/)

**Source:** Springer (2024), "Pricing Substitutable Products Under Consumer Regrets." [Link](https://www.sciencedirect.com/science/article/abs/pii/S0925527318302718)

**Key findings and actionable insights:**

- Anticipated regret makes consumers more cautious and risk-averse. When uncertainty is high and consumers anticipate much purchase regret, they **defer decisions** and wait for more information.

- Regret aversion can paralyze decision-making: consumers try to avoid choosing poorly even when not choosing carries its own costs.

- For pricing: when anticipated regret is strong, consumers prefer options that minimize potential downside rather than maximize potential upside. This favors: money-back guarantees, free tiers, and lower-commitment entry points.

**Simulation implication:** Risk-averse personas should show regret-driven decision patterns: preferring the "safe" option, seeking guarantees, and sometimes choosing not to decide at all. The simulation should model "no decision" as a valid outcome.

---

### 5.5 The Peak-End Rule

**Source:** Kahneman, Fredrickson, Schreiber & Redelmeier (1993), "When More Pain Is Preferred to Less."

**Source:** NN/g, "The Peak-End Rule: How Impressions Become Memories." [Link](https://www.nngroup.com/articles/peak-end-rule/)

**Key findings and actionable insights:**

- People evaluate experiences based primarily on two moments: the **peak** (most emotionally intense) and the **end** (the final moment). The duration and average quality of the experience have relatively little impact on remembered satisfaction.

- In the original study, subjects preferred a longer painful experience that ended slightly better over a shorter painful experience that ended at peak pain.

- For product experiences: a subscription service that provides occasional "wow" moments and ensures a positive offboarding experience (even for churners) will be remembered more favorably than one that is consistently adequate.

**Simulation implication:** Each persona's 12-month usage simulation should include identifiable peak moments and attention to how the experience ends (at renewal or cancellation). The NPS score should be influenced more by the peak and the ending than by the average experience.

---

### 5.6 Reactance Theory (Resistance to Forced Choices)

**Source:** Brehm (1966), *A Theory of Psychological Reactance*.

**Source:** PMC (2015), "Understanding Psychological Reactance: New Developments and Findings." [Link](https://pmc.ncbi.nlm.nih.gov/articles/PMC4675534/)

**Key findings and actionable insights:**

- When people feel their freedom of choice is threatened, they experience **reactance** -- an emotional resistance that often leads them to do the opposite of what's being pressured.

- Controlling language ("you must," "you should," "you need to") triggers significantly more reactance than autonomy-supportive language ("you could consider," "you might want to").

- Mandatory upsells, forced account creation, or aggressive "upgrade now" prompts can trigger reactance that **damages the entire customer relationship**, not just the upsell conversion.

- Reactance is personality-dependent: high-autonomy individuals show stronger reactance.

**Simulation implication:** Personas with high autonomy needs should show negative reactions to aggressive pricing tactics, mandatory upsells, or limited-choice architectures. The simulation should model cases where aggressive tactics backfire -- producing not just non-conversion but active negative word-of-mouth.

---

## 6. LLMs and Behavioral Economics

### 6.1 Do LLMs Exhibit Human-Like Biases?

**Source:** Bini, Cong, Huang & Jin (2025), "Behavioral Economics of AI: LLM Biases and Corrections," NBER Working Paper 34745. [PDF](https://arxiv.org/pdf/2602.09362)

**Source:** Chen et al. (2024), "LLM Economicus? Mapping the Behavioral Biases of LLMs via Utility Theory," COLM 2024. [Link](https://arxiv.org/html/2408.02784v1)

**Source:** Yaron, Demszky & Hullman (2025), "Prospect Theory Fails for LLMs." [Link](https://arxiv.org/html/2508.08992)

**Key findings and actionable insights:**

- LLMs exhibit **some but not all** human behavioral biases. The pattern is inconsistent and model-dependent:

  - **Anchoring**: LLMs are highly susceptible -- "expert" anchors in prompts significantly shift responses. Mitigation strategies (Chain-of-Thought, reflection) are largely ineffective against anchoring.

  - **Loss aversion**: GPT-4 shows no probability distortion for gains (more rational than humans) but stronger probability distortion for losses (less rational than humans). Models tend toward risk-averse behavior in gains but don't consistently show risk-seeking behavior in losses as prospect theory predicts.

  - **Mental accounting**: LLMs replicate the tendency to favor multiple small wins over a lump sum and to consolidate negative outcomes, suggesting folk economics is embedded in training data.

  - **Framing effects**: Present but weaker than in humans. Effect is model-specific -- Llama3-70B shows stronger framing bias than GPT-4o.

  - **Hyperbolic discounting**: GPT-3.5 and GPT-4 are both less patient than humans, with measured discount rates considerably larger than those in humans.

- LLMs are **bias-consistent in 17.8-57.3% of instances** across cognitive bias tests, meaning they show the expected human bias between a fifth and half the time.

- Larger models (>32B parameters) reduce bias in 39.5% of cases, and higher prompt detail reduces most biases by up to 14.9%.

**Critical implication for Facet:** LLMs will not automatically simulate human biases correctly. Facet's persona templates must **explicitly instruct** which biases should manifest for each persona type. Relying on the LLM to "naturally" produce loss aversion, anchoring, or framing effects will produce inconsistent and often unrealistic behavior.

---

### 6.2 LLMs as Synthetic Economic Agents (Homo Silicus)

**Source:** Horton, Filippas & Manning (2023), "Large Language Models as Simulated Economic Agents: What Can We Learn from Homo Silicus?" NBER Working Paper 31122. [PDF](https://benjaminmanning.io/files/homo_silicus.pdf)

**Source:** Brand et al. (2023), "Can LLMs Capture Human Preferences?" *Marketing Science*. [Link](https://pubsonline.informs.org/doi/10.1287/mksc.2023.0306)

**Key findings and actionable insights:**

- LLMs can be given endowments, information, and preferences, and their behavior explored in economic simulations -- they are "implicit computational models of humans."

- Experimental replications using LLMs produce **qualitatively similar** results to classic behavioral economics experiments, and when they differ, the differences are often generative for future research.

- A semantic similarity rating method achieved **90% of human test-retest reliability** for purchase intent predictions across 57 consumer product surveys.

- However, LLMs show **less patience** than humans, and their discount rates are significantly higher. They also show less sensitivity to kinship and group size in social dilemmas.

- **Graph neural networks can match LLM accuracy** for discrete choice simulation at 1/1000th the computational cost, suggesting LLMs may be unnecessarily expensive for pure prediction tasks. Their strength is in **narrative generation** -- producing the rich behavioral descriptions that explain *why* a decision was made.

**Implication for Facet:** The Homo Silicus research validates the general approach of using LLMs for persona simulation. But Facet's value is not in prediction accuracy (where cheaper models might suffice) -- it's in the rich, explanatory narratives that help product teams understand decision dynamics. The templates should leverage this narrative strength while compensating for known bias gaps.

---

### 6.3 The Silicon Sampling Problem

**Source:** Argyle et al. (2023), "Synthetic Replacements for Human Survey Data? The Perils of Large Language Models," *Political Analysis*. [Link](https://www.cambridge.org/core/journals/political-analysis/article/synthetic-replacements-for-human-survey-data-the-perils-of-large-language-models/B92267DC26195C7F36E63EA04A47D2FE)

**Source:** ArXiv (2025), "The Personality Trap: How LLMs Embed Bias When Generating Human-Like Personas." [Link](https://arxiv.org/html/2602.03334v1)

**Source:** ScienceDirect (2025), "Bias and Gendering in LLM-Generated Synthetic Personas." [Link](https://www.sciencedirect.com/science/article/pii/S1071581925002083)

**Key findings and actionable insights:**

- ChatGPT-generated responses **exaggerate partisan and social division by 7x** compared to actual human opinions. LLM personas are systematically more polarized, more extreme, and more stereotypical than real people.

- LLMs describe socially subordinate groups (African, Asian, Hispanic Americans) as **more homogeneous** than dominant groups, reinforcing reductive stereotypes.

- The more creative freedom allowed in persona generation, the more biased and unrepresentative results become -- "skewing too optimistic, progressive, or homogeneous, and missing real-world nuance."

- **Structured templates reduce bias**: using objective, pre-defined categories keeps simulations grounded. This directly validates Facet's approach of using detailed persona templates rather than open-ended generation.

- Multi-agent bias risks: biases can **intensify through agent interactions**, even when individual agents are initially unbiased. This is relevant for Facet's weave phase.

- The average absolute difference between population proportion and LLM proportion for demographic subgroups is **8 percentage points**. For smaller demographic groups, synthetic data is "close to useless for crosstabs."

**Critical implication for Facet:** The structured template approach is correct and essential. The persona template should include explicit instructions to avoid stereotyping, model within-group variation, and include "surprising" details that break expected patterns. The weave phase should be designed to resist bias amplification.

---

### 6.4 Bias-Adjusted LLM Agents

**Source:** ArXiv (2025), "Bias-Adjusted LLM Agents for Human-Like Decision-Making via Behavioral Economics." [Link](https://arxiv.org/abs/2508.18600)

**Source:** ArXiv (2024), "Bias Runs Deep: Implicit Reasoning Biases in Persona-Assigned LLMs." [Link](https://arxiv.org/abs/2311.04892)

**Key findings and actionable insights:**

- Researchers have developed **Econographics** -- a dataset of behavioral indicators from 1,000 human participants across demographic groups -- to calibrate LLM personas against real behavioral data.

- Applying persona-specific behavioral calibration to the ultimatum game improved alignment between simulated and empirical behavior, particularly on the responder side.

- **Prompt-based de-biasing shows limited effectiveness**. More promising approaches include population-level alignment, contrastive learning, persona selection and tuning via likelihood-ratio criteria, and iterative persona rewriting.

- The field lacks widely adopted de-biasing protocols, but the direction is clear: behavioral economics data can be used to calibrate LLM agents for more realistic simulation.

**Implication for Facet:** Future versions could incorporate behavioral calibration data -- for instance, specifying each persona's loss aversion coefficient, discount rate, and social proof sensitivity as explicit parameters that the template instructs the LLM to respect.

---

## 7. Decision Frameworks for Simulation

### 7.1 The Fogg Behavior Model (B = MAP)

**Source:** BJ Fogg, Stanford Behavior Design Lab. [Link](https://behaviordesign.stanford.edu/resources/fogg-behavior-model)

**Source:** Fogg (2009), "A Behavior Model for Persuasive Design."

**Key findings and actionable insights:**

- Behavior occurs when three elements converge simultaneously: **Motivation** (desire to act), **Ability** (ease of performing the behavior), and a **Prompt** (trigger/cue).

- Six factors influence Ability: **time, money, physical effort, mental effort (brain cycles), social deviance, and non-routine**.

- Three types of prompts: **Facilitators** (high motivation, low ability -- reduce friction), **Sparks** (high ability, low motivation -- increase desire), **Signals** (high ability, high motivation -- just remind).

- A person with high motivation but low ability needs a Facilitator (simplified signup, reduced price). A person with high ability but low motivation needs a Spark (compelling use case, urgency).

**Simulation implication:** Each persona's conversion likelihood should be modeled as the intersection of motivation (how much they want the product), ability (how easy it is for them to adopt), and prompt (how they discover it). The B=MAP framework should explicitly inform the persona generation template.

---

### 7.2 Jobs-to-be-Done Framework

**Source:** Christensen, Anthony, Berstell & Nitterhouse (2007), "Finding the Right Job For Your Product."

**Source:** Christensen Institute, "Jobs to Be Done Theory." [Link](https://www.christenseninstitute.org/theory/jobs-to-be-done/)

**Source:** Ulwick (2005), *What Customers Want*.

**Key findings and actionable insights:**

- Customers don't buy products -- they **"hire" products to get a job done**. The job has functional, social, and emotional dimensions.

- The McDonald's milkshake case: customers "hired" milkshakes for the job of "making my boring commute more engaging." This was not about the milkshake's features (thickness, flavor) but about the job it performed.

- Understanding the Job-to-be-Done reveals **non-obvious competitors**: a milkshake competes with a banana, a donut, and a podcast, not just other milkshakes.

- The purchase decision itself is a job: the decision-maker uses financial and performance metrics to decide which product to acquire.

**Simulation implication:** Each persona should have a clearly defined "job" they are hiring the product for. This job should drive their evaluation criteria more than abstract feature comparisons. The job framing should inform what the persona pays attention to on the landing page and what they ignore.

---

### 7.3 The Kano Model

**Source:** Kano, Seraku, Takahashi & Tsuji (1984), "Attractive Quality and Must-Be Quality."

**Source:** ASQ, "What Is the Kano Model?" [Link](https://asq.org/quality-resources/kano-model)

**Key findings and actionable insights:**

- Features fall into five categories:
  - **Must-Be (Basic)**: expected and taken for granted. Absence causes dissatisfaction; presence doesn't increase satisfaction. These are the price of entry.
  - **Performance (One-Dimensional)**: satisfaction scales linearly with how well these are done. "More is better."
  - **Attractive (Delighters)**: unexpected features that create disproportionate satisfaction. Their absence doesn't cause dissatisfaction.
  - **Indifferent**: features that don't affect satisfaction either way.
  - **Reverse**: features that cause dissatisfaction when present.

- **Features drift over time**: yesterday's delighter becomes today's performance expectation and tomorrow's must-be. Expectations rise with market maturity.

**Simulation implication:** Feature evaluation in pricing simulations should categorize features using the Kano model. Different personas will categorize the same feature differently: what's a "delighter" for a casual user may be a "must-be" for a power user. This should be explicitly part of the persona's domain profile.

---

### 7.4 System 1 / System 2 Thinking

**Source:** Kahneman (2011), *Thinking, Fast and Slow*.

**Source:** The Marketing Society, "System 1 and System 2 Thinking." [Link](https://www.marketingsociety.com/think-piece/system-1-and-system-2-thinking)

**Key findings and actionable insights:**

- **System 1** (fast, automatic, intuitive): handles most daily decisions, including low-cost habitual purchases. Driven by emotional associations, visual cues, and heuristics.

- **System 2** (slow, deliberate, analytical): activated for high-stakes, novel, or complex decisions. Requires effort and is easily fatigued.

- Most product decisions involve **both systems**: System 1 forms the initial emotional impression; System 2 activates only if the decision is important enough or if System 1 encounters something unexpected.

- For inexpensive, frequently-purchased products: System 1 dominates. For expensive, novel, or complex products: System 2 engages, but System 1 still shapes the emotional frame.

- **Marketing that appeals only to System 2 (rational arguments) while neglecting System 1 (emotional resonance) will underperform.**

**Simulation implication:** Persona internal monologues should reflect which system is dominant for each decision. Low-cost subscriptions should trigger more System 1 responses (gut reactions, visual impressions). High-cost commitments should show System 2 engagement (calculations, comparisons, deliberation). Copy variants should be evaluated for their System 1 appeal (emotional, visual, simple) vs. System 2 appeal (logical, detailed, comparative).

---

### 7.5 Elaboration Likelihood Model

**Source:** Petty & Cacioppo (1986), *Communication and Persuasion: Central and Peripheral Routes to Attitude Change*.

**Key findings and actionable insights:**

- **Central route** processing: high motivation + high ability = careful evaluation of arguments. Produces durable attitude change.

- **Peripheral route** processing: low motivation or low ability = reliance on heuristic cues (source credibility, number of arguments, production quality). Produces less durable attitude change.

- Product involvement determines the route: high-involvement products (cars, homes, enterprise software) trigger central processing; low-involvement products (snacks, basic SaaS tools) trigger peripheral processing.

- Different personas will process the same marketing material through different routes depending on their involvement level, domain expertise, and cognitive resources.

**Simulation implication:** Personas with high domain expertise and high purchase involvement should evaluate copy through central-route processing (scrutinizing claims, checking evidence). Personas with low involvement should respond more to peripheral cues (celebrity endorsements, design quality, number of reviews).

---

### 7.6 Construal Level Theory

**Source:** Trope & Liberman (2010), "Construal-Level Theory of Psychological Distance," *Psychological Review*.

**Source:** ScienceDirect (2024), "Construal Level Theory in Advertising Research." [Link](https://www.sciencedirect.com/science/article/pii/S0148296324003746)

**Key findings and actionable insights:**

- Greater psychological distance (temporal, spatial, social, hypothetical) leads to more **abstract** mental representations. Closer distance leads to more **concrete** representations.

- When considering a future purchase, people focus on abstract benefits ("it will make my life easier"). When the purchase is imminent, they focus on concrete details ("does it support my file format?").

- **Construal-level matching**: ad evaluations are more favorable when the abstraction level of the message matches the psychological distance. Abstract messaging for future-oriented products; concrete messaging for immediate-use products.

**Simulation implication:** Personas evaluating a product they'll use "someday" should focus on high-level value propositions. Personas ready to buy "today" should focus on specific feature compatibility, price details, and logistics. Copy variants should be tested for construal-level match with different persona readiness states.

---

### 7.7 Weber-Fechner Law (Just Noticeable Difference)

**Source:** Weber (1834); Fechner (1860).

**Source:** Eaton Business School, "How to Use Psychophysics for Marketing." [Link](https://ebsedu.org/blog/psychophysics-for-marketing/)

**Key findings and actionable insights:**

- The just noticeable difference (JND) is a **constant proportion** of the original stimulus, not a fixed amount. A $1 price increase on a $5 product is highly noticeable; a $1 increase on a $100 product is barely perceptible.

- Companies use JND principles to: (a) keep negative changes (price increases, quality reductions) below the JND threshold, and (b) ensure positive changes (feature additions, price decreases) are above the JND threshold.

- This applies to subscription pricing: a $1/month increase on a $5/month subscription (20%) is much more noticeable and objectionable than a $1/month increase on a $30/month subscription (3.3%).

**Simulation implication:** Price changes and feature changes in the simulation should be evaluated relative to the base price, not in absolute terms. A persona's sensitivity to a price increase should scale with the percentage change relative to their reference point.

---

### 7.8 Cialdini's Principles of Influence

**Source:** Cialdini (1984, 2021), *Influence: The Psychology of Persuasion* (including 7th principle).

**Key findings and actionable insights:**

Seven principles, each relevant to persona simulation:

1. **Reciprocity**: free tier, free trial, free content creates obligation to reciprocate (by converting, sharing, or engaging).

2. **Commitment and Consistency**: once a persona takes a small step (creating an account, completing onboarding), they feel pressure to behave consistently with that commitment.

3. **Social Proof**: testimonials, user counts, reviews. Effectiveness varies by persona demographic match.

4. **Authority**: expert endorsements, press coverage, certifications. More influential for personas who process via peripheral route.

5. **Scarcity**: limited-time offers, limited availability. More effective on impulsive personas; may trigger reactance in autonomy-oriented ones.

6. **Liking**: brand personality, founder story, design aesthetics. Personas who identify with the brand personality are more susceptible.

7. **Unity**: shared identity ("you're one of us"). Strongest for personas with strong in-group identification.

**Simulation implication:** Each persuasion mechanism should be mapped to specific persona types. The copy variant evaluation should assess which Cialdini principles are active in each variant and how they interact with each persona's psychology.

---

### 7.9 Distinction Bias

**Source:** Hsee & Zhang (2004), "Distinction Bias: Misprediction and Mischoice Due to Joint Evaluation," *Journal of Personality and Social Psychology*.

**Key findings and actionable insights:**

- When evaluating options side-by-side (joint evaluation), small differences appear larger than they actually are in experience (separate evaluation).

- A consumer comparing two TV models in a store perceives the quality difference as significant. At home, watching only one TV, the difference in experienced satisfaction is negligible.

- People systematically overpay for marginal improvements when options are compared simultaneously.

**Simulation implication:** When personas compare pricing tiers side-by-side, they will overweight small feature differences between tiers. The simulation should model this -- the perceived value gap between tiers should be larger during the decision than during actual usage.

---

### 7.10 Hedonic Adaptation

**Source:** Brickman & Campbell (1971), "Hedonic Relativism and Planning the Good Society."

**Source:** Frederick & Loewenstein (1999), "Hedonic Adaptation."

**Key findings and actionable insights:**

- People adapt to both positive and negative changes, returning toward a baseline satisfaction level. The excitement of a new product wears off as it becomes routine.

- One of the forces driving hedonic adaptation is **habituation**: the more we experience something, the more the novelty fades.

- **Intrinsically motivated activities buffer against hedonic adaptation** because pleasure comes from the activity itself, not novelty. Products that provide ongoing variety resist adaptation better than static products.

**Simulation implication:** The 12-month usage simulation should model declining excitement over time. The "peak" of satisfaction should occur in the first 1-3 months, with gradual normalization. Products that introduce novelty over time should show slower adaptation in the simulation.

---

## 8. Synthesis: Implications for Facet

### 8.1 What the Current Templates Do Well

- The persona template already captures rich behavioral psychology, internal monologues, specific financial details, and 12-month usage simulations. This structure is well-aligned with the research.

- The plan template's segment matrix with diverse psychographic traits maps naturally to the behavioral economics dimensions described above.

- The weave template's referral chain modeling aligns with word-of-mouth research, including the critical insight about information distortion.

- The adversarial review template provides a check on confirmation bias, which the LLM stereotyping research confirms is essential.

### 8.2 Specific Enhancements the Research Supports

**For the Plan Template:**

1. **Adoption curve mapping**: Each segment should be explicitly mapped to a position on Rogers' diffusion curve (innovator through laggard).

2. **Behavioral parameter specification**: The plan should specify expected behavioral economics parameters per segment: approximate loss aversion intensity (low/medium/high), discount rate steepness, social proof sensitivity, and primary Cialdini influence principle.

3. **Cultural dimension annotation**: When segments include cultural diversity, Hofstede-adjacent dimensions should be noted (individualist/collectivist tendency, uncertainty avoidance level).

**For the Persona Template:**

4. **Mental accounting context**: Section 2 (Behavioral Psychology) should explicitly model the persona's mental spending categories and what budget "account" the product falls into.

5. **Reference point specification**: Each persona should have an explicit reference point -- their current solution's price and value -- against which the new product is evaluated asymmetrically.

6. **System 1/System 2 indicator**: The persona's processing mode for this decision should be specified -- whether they're approaching it intuitively or analytically.

7. **Bias instruction block**: An explicit instruction to the generating LLM about which behavioral biases this persona should exhibit (e.g., "This persona exhibits strong loss aversion, moderate anchoring susceptibility, and low hyperbolic discounting due to financial literacy").

8. **Subscription fatigue counter**: Number of existing subscriptions and the persona's current relationship with recurring payments.

9. **Construal level note**: Whether the persona is in immediate-purchase mode (concrete construal) or exploratory mode (abstract construal).

**For the Weave Template:**

10. **Referral distortion modeling**: Explicit instruction that referral conversations should show information mutation -- what the referrer says should differ from the product's actual features/pricing, reflecting the ~60% distortion rate found in WOM research.

**For the Synthesis Template:**

11. **Behavioral economics explanation layer**: The synthesis should identify which behavioral economics mechanisms drove the result -- not just "Segment X preferred Option A" but "Segment X preferred Option A primarily due to loss aversion around their current solution and status quo bias, with social proof from perceived adoption level reinforcing the choice."

**For the Adversarial Template:**

12. **LLM bias audit**: The adversarial review should specifically check for known LLM stereotyping patterns -- are marginalized group personas described more homogeneously? Are opinions unrealistically polarized? Are behavioral biases inconsistently applied?

### 8.3 Highest-Impact, Lowest-Effort Changes

If implementing all of the above is impractical immediately, the research most strongly supports these four changes:

1. **Add explicit bias instructions to the persona template** -- this addresses the core finding that LLMs don't reliably produce human-like biases without explicit guidance (Section 6.1).

2. **Add subscription fatigue context** -- the dramatic shift from 4.1 to 2.8 subscriptions per household means every subscription simulation must account for this (Section 4.1).

3. **Add mental accounting/reference point context** -- this is the foundation of prospect theory and directly affects every pricing decision simulation (Sections 1.1, 1.2).

4. **Add LLM stereotyping guardrails** -- structured templates reduce bias, but explicit anti-stereotyping instructions further help (Section 6.3).

---

## Sources

### Prospect Theory and Reference Dependence
- [Kahneman & Tversky (1979) - Prospect Theory PDF](https://web.mit.edu/curhan/www/docs/Articles/15341_Readings/Behavioral_Decision_Theory/Kahneman_Tversky_1979_Prospect_theory.pdf)
- [Barberis (2012) - Thirty Years of Prospect Theory, NBER](https://www.nber.org/system/files/working_papers/w18621/w18621.pdf)
- [Reference Dependence - Wikipedia](https://en.wikipedia.org/wiki/Reference_dependence)
- [Reference Dependence - BehavioralEconomics.com](https://www.behavioraleconomics.com/resources/mini-encyclopedia-of-be/reference-dependence/)
- [Loss Aversion - Wikipedia](https://en.wikipedia.org/wiki/Loss_aversion)

### Mental Accounting
- [Thaler (1999) - Mental Accounting Matters PDF](https://people.bath.ac.uk/mnsrf/Teaching%202011/Thaler-99.pdf)
- [Thaler (1985) - Mental Accounting and Consumer Choice](https://pubsonline.informs.org/doi/10.1287/mksc.4.3.199)
- [Frontiers - Individual Differences in Mental Accounting](https://www.frontiersin.org/journals/psychology/articles/10.3389/fpsyg.2019.02866/full)
- [The Decision Lab - Mental Accounting](https://thedecisionlab.com/biases/mental-accounting)

### Anchoring Effect
- [Frontiers (2022) - Anchoring Effect and Price Judgment](https://www.frontiersin.org/journals/psychology/articles/10.3389/fpsyg.2022.794135/full)
- [Stanford GSB - Anchoring Effects on WTP](https://www.gsb.stanford.edu/faculty-research/working-papers/anchoring-effects-consumers-willingness-pay-willingness-accept)
- [ResearchGate - Real-World Cases of Anchoring's Pricing Strategies](https://www.researchgate.net/publication/394824417)

### Endowment Effect and IKEA Effect
- [Springer (2025) - Free Trials and Psychological Ownership](https://link.springer.com/article/10.1007/s12144-025-08231-x)
- [HBS - Norton, Mochon, Ariely - IKEA Effect](https://www.hbs.edu/ris/Publication%20Files/11-091.pdf)
- [Endowment Effect - Wikipedia](https://en.wikipedia.org/wiki/Endowment_effect)

### Status Quo Bias
- [Springer (2022) - Measuring Status Quo Bias Review](https://link.springer.com/article/10.1007/s11301-022-00283-8)
- [The Decision Lab - Status Quo Bias](https://thedecisionlab.com/biases/status-quo-bias)
- [Polites & Karahanna - Shackled to the Status Quo](https://www.academia.edu/55480137)

### Hyperbolic Discounting
- [HBS (2024) - Enke, Complexity and Hyperbolic Discounting](https://www.hbs.edu/ris/Publication%20Files/24-048_304d978e-f730-4523-a9e0-4370f82ebd03.pdf)
- [PMC (2024) - Financial Knowledge and Hyperbolic Discounting](https://pmc.ncbi.nlm.nih.gov/articles/PMC11591072/)
- [The Decision Lab - Hyperbolic Discounting](https://thedecisionlab.com/biases/hyperbolic-discounting)

### Choice Overload
- [Iyengar & Lepper (2000) - When Choice Is Demotivating](https://faculty.washington.edu/jdb/345/345%20Articles/Iyengar%20&%20Lepper%20(2000).pdf)
- [Chernev et al. (2015) - Choice Overload Meta-Analysis](https://chernev.com/wp-content/uploads/2017/02/ChoiceOverload_JCP_2015.pdf)

### Social Proof and Word-of-Mouth
- [WiserNotify - Social Proof Statistics 2026](https://wisernotify.com/blog/social-proof-statistics/)
- [Tremendous - WOM Marketing Psychology](https://www.tremendous.com/blog/word-of-mouth-marketing-psychology/)
- [PMC (2023) - Information Distortion in WOM](https://pmc.ncbi.nlm.nih.gov/articles/PMC10105362/)
- [GrowSurf - Referral Program Psychology](https://growsurf.com/blog/referral-program-psychology)

### Diffusion of Innovation
- [Rogers - Diffusion of Innovations, Wikipedia](https://en.wikipedia.org/wiki/Diffusion_of_innovations)
- [High Tech Strategies - Adopter Segment Profiles](https://www.hightechstrategies.com/innovation-adoption-curve/)

### Tribal Identity and Branding
- [Raimondo (2022) - Identity Signaling, Psychology & Marketing](https://onlinelibrary.wiley.com/doi/full/10.1002/mar.21711)
- [Wharton - Identity Signaling with Social Capital](https://faculty.wharton.upenn.edu/wp-content/uploads/2012/04/Identity-Signaling-with-Social-Capital-w-names.pdf)

### Generational and Demographic Differences
- [SAGE (2025) - Generational Investment Behavior](https://journals.sagepub.com/doi/10.1177/21582440251352342)
- [MDPI (2022) - Generational Differences in Risk Tolerance](https://www.mdpi.com/2227-7072/10/2/35)
- [PNAS (2019) - Scarcity Mindset Neural Processing](https://www.pnas.org/doi/10.1073/pnas.1818572116)
- [Hofstede - Cultural Dimensions, Wikipedia](https://en.wikipedia.org/wiki/Hofstede's_cultural_dimensions_theory)
- [Scielo - National Culture and Decision-Making Styles](https://www.scielo.br/j/bar/a/4xJ5VDbd48m53mJtMVCpzMB/?lang=en)
- [Meyers-Levy - Gender Differences, JSTOR](https://www.jstor.org/stable/4188961)

### Urban vs. Rural
- [PNAS Nexus (2023) - Smartphone Usage Urban vs Rural](https://academic.oup.com/pnasnexus/article/2/11/pgad357/7442564)
- [SAGE (2024) - FinTech Adoption in Rural Communities](https://journals.sagepub.com/doi/full/10.1177/21582440241227770)

### Subscription Fatigue
- [CivicScience - Subscription Fatigue Survey](https://civicscience.com/feelings-of-video-subscription-fatigue-take-hold-driving-streamers-to-switch-churn-and-cancel/)
- [Marketing LTB - Subscription Statistics 2025](https://marketingltb.com/blog/statistics/subscription-statistics/)

### Zero Price Effect
- [Shampanier, Mazar, Ariely (2007) - Zero as a Special Price](https://web.mit.edu/ariely/www/MIT/Papers/zero.pdf)
- [St. Louis Fed (2025) - Psychology of Free](https://www.stlouisfed.org/publications/page-one-economics/2025/apr/psychology-of-free-how-price-of-zero-influences-decisionmaking)

### Flat-Rate Bias
- [Lambrecht & Skiera - Paying Too Much and Being Happy](https://www.marketing.uni-frankfurt.de/fileadmin/Publikationen/Lambrecht_Skiera_Tariff-Choice-Biases-JMR.pdf)
- [Springer (2022) - Consumer Preference for Pay-Per-Use](https://link.springer.com/article/10.1007/s11747-022-00853-y)

### Charm Pricing
- [Troll et al. (2024) - Meta-Analysis of Just-Below Prices](https://myscp.onlinelibrary.wiley.com/doi/full/10.1002/jcpy.1353)
- [Capital One Shopping - Pricing Psychology Statistics](https://capitaloneshopping.com/research/pricing-psychology-statistics/)

### Decoy Effect
- [The Decision Lab - Decoy Effect](https://thedecisionlab.com/biases/decoy-effect)
- [Simon-Kucher - Decoy Pricing](https://www.simon-kucher.com/en/insights/positioning-decoy-pricing-shape-how-customers-perceive-value)

### Payment Pain
- [Prelec & Loewenstein (1998) - Red and the Black](https://www.behavioraleconomics.com/resources/mini-encyclopedia-of-be/pain-of-paying/)
- [Neurosciencemarketing.com - Pain of Paying](https://www.neurosciencemarketing.com/blog/articles/pain-of-paying.htm)

### Emotional Decision-Making
- [Research & Metric - Consumer Psychology Buying Decisions](https://www.researchandmetric.com/blog/consumer-psychology-buying-decisions-emotional-factors/)
- [ResearchGate - Anticipated Emotions in Product Adoption](https://www.researchgate.net/publication/324433640)

### Trust
- [Yale SOM - Navigating Brand Trust](https://som.yale.edu/story/2023/navigating-brand-trust-modern-marketing)
- [Manchester Research - Consumer Trust and Distrust](https://research.manchester.ac.uk/files/261211368/FULL_TEXT.PDF)

### Post-Purchase Rationalization
- [Psychology Today - Buyer's Remorse](https://www.psychologytoday.com/us/blog/wishful-thoughts/201708/buyers-remorse)
- [CXL - Post-Purchase Rationalization](https://cxl.com/blog/post-purchase-rationalization/)

### Regret Aversion
- [PMC (2025) - Anticipated Regret and Rationality](https://pmc.ncbi.nlm.nih.gov/articles/PMC12460334/)
- [Nature - Regret Theory in Decision Making](https://www.nature.com/research-intelligence/nri-topic-summaries/regret-theory-in-decision-making-and-economic-behavior-micro-524250)

### Peak-End Rule
- [NN/g - Peak-End Rule](https://www.nngroup.com/articles/peak-end-rule/)
- [The Decision Lab - Peak-End Rule](https://thedecisionlab.com/biases/peak-end-rule)

### Reactance Theory
- [PMC (2015) - Understanding Psychological Reactance](https://pmc.ncbi.nlm.nih.gov/articles/PMC4675534/)
- [The Decision Lab - Reactance Theory](https://thedecisionlab.com/reference-guide/psychology/reactance-theory)

### LLMs and Behavioral Economics
- [Bini et al. (2025) - Behavioral Economics of AI, NBER](https://www.nber.org/papers/w34745)
- [Chen et al. (2024) - LLM Economicus, COLM](https://arxiv.org/html/2408.02784v1)
- [Yaron et al. (2025) - Prospect Theory Fails for LLMs](https://arxiv.org/html/2508.08992)
- [Horton et al. (2023) - Homo Silicus, NBER](https://www.nber.org/papers/w31122)
- [Brand et al. (2023) - Can LLMs Capture Human Preferences](https://pubsonline.informs.org/doi/10.1287/mksc.2023.0306)
- [Argyle et al. (2023) - Silicon Sampling Perils](https://www.cambridge.org/core/journals/political-analysis/article/synthetic-replacements-for-human-survey-data-the-perils-of-large-language-models/B92267DC26195C7F36E63EA04A47D2FE)
- [ArXiv (2025) - Personality Trap LLM Personas](https://arxiv.org/html/2602.03334v1)
- [ArXiv (2025) - Bias-Adjusted LLM Agents](https://arxiv.org/abs/2508.18600)
- [ScienceDirect (2025) - Bias and Gendering in LLM Personas](https://www.sciencedirect.com/science/article/pii/S1071581925002083)
- [ArXiv (2024) - Bias Runs Deep](https://arxiv.org/abs/2311.04892)
- [SSRN (2024) - Folk Economics in the Machine](https://papers.ssrn.com/sol3/papers.cfm?abstract_id=4705130)
- [ArXiv (2025) - Anchoring Bias in LLMs](https://link.springer.com/article/10.1007/s42001-025-00435-2)
- [EMNLP (2025) - Cognitive Biases Impact on LLM Product Decisions](https://aclanthology.org/2025.emnlp-main.1140.pdf)
- [Nature (2025) - LLMs Predict Human Social Decisions](https://www.nature.com/articles/s41598-025-17188-7)
- [ArXiv (2025) - LLMs Reproduce Purchase Intent](https://arxiv.org/abs/2510.08338)

### Decision Frameworks
- [BJ Fogg - Behavior Model](https://behaviordesign.stanford.edu/resources/fogg-behavior-model)
- [Christensen Institute - Jobs to Be Done](https://www.christenseninstitute.org/theory/jobs-to-be-done/)
- [ASQ - Kano Model](https://asq.org/quality-resources/kano-model)
- [The Decision Lab - System 1 and System 2](https://thedecisionlab.com/reference-guide/philosophy/system-1-and-system-2-thinking)
- [ELM - Wikipedia](https://en.wikipedia.org/wiki/Elaboration_likelihood_model)
- [CLT - PMC](https://pmc.ncbi.nlm.nih.gov/articles/PMC3152826/)
- [Weber-Fechner Law - Wikipedia](https://en.wikipedia.org/wiki/Weber%E2%80%93Fechner_law)
- [Cialdini - 7 Principles of Persuasion](https://www.influenceatwork.com/7-principles-of-persuasion/)
- [Hsee & Zhang (2004) - Distinction Bias](https://thedecisionlab.com/biases/distinction-bias)

### Other Behavioral Economics References
- [Ariely (2008) - Predictably Irrational, Wikipedia](https://en.wikipedia.org/wiki/Predictably_Irrational)
- [Thaler & Sunstein (2008) - Nudge / Choice Architecture](https://en.wikipedia.org/wiki/Choice_architecture)
- [Default Effect - Wikipedia](https://en.wikipedia.org/wiki/Default_effect)
- [Sunk Cost Fallacy - The Decision Lab](https://thedecisionlab.com/biases/the-sunk-cost-fallacy)
- [Bandwagon Effect - Wikipedia](https://en.wikipedia.org/wiki/Bandwagon_effect)
- [Hedonic Treadmill - Wikipedia](https://en.wikipedia.org/wiki/Hedonic_treadmill)
- [Availability Heuristic - The Decision Lab](https://thedecisionlab.com/biases/availability-heuristic)
- [Fairness Pricing - Painful Prices Model](https://academic.oup.com/jcr/advance-article/doi/10.1093/jcr/ucaf045/8195730)
- [Foot-in-the-Door Technique - Wikipedia](https://en.wikipedia.org/wiki/Foot-in-the-door_technique)
- [Present Bias - BehavioralEconomics.com](https://www.behavioraleconomics.com/resources/mini-encyclopedia-of-be/present-bias/)
- [Network Effects - Wikipedia](https://en.wikipedia.org/wiki/Network_effect)
- [NFX - Network Effects Bible](https://www.nfx.com/post/network-effects-bible)
