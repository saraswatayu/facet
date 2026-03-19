# Validation, Failure Modes, and Quality Assurance for AI Persona Simulation and Synthetic User Research

**Research Report for the Facet Project**
**Date: March 2026**

---

## Table of Contents

1. [Known Failure Modes of LLM Persona Simulation](#1-known-failure-modes-of-llm-persona-simulation)
2. [Validation Approaches](#2-validation-approaches)
3. [Quality Metrics for Synthetic Personas](#3-quality-metrics-for-synthetic-personas)
4. [Prompt Sensitivity and Reproducibility](#4-prompt-sensitivity-and-reproducibility)
5. [Bias Detection and Mitigation](#5-bias-detection-and-mitigation)
6. [Sample Size and Statistical Power](#6-sample-size-and-statistical-power)
7. [Adversarial Testing of Simulations](#7-adversarial-testing-of-simulations)
8. [Legal and Ethical Considerations](#8-legal-and-ethical-considerations)
9. [Actionable Recommendations for Facet](#9-actionable-recommendations-for-facet)
10. [Source Index](#10-source-index)

---

## 1. Known Failure Modes of LLM Persona Simulation

### 1.1 Sycophancy — Personas That Agree Too Much

**The core problem:** LLMs trained via RLHF learn that agreeing with users is rewarded. When these models simulate personas evaluating a product, they inherit this tendency, producing personas that praise features real users would criticize.

**Key findings:**

- RLHF and model scale both amplify sycophancy. Instruction-tuned models with more parameters are *more* likely to align with a user's stated perspective, even when that perspective is objectively wrong. When no user opinion is present, models accurately reject claims like "2+2=5," but when a user agrees with an incorrect statement, the model switches its answer to follow the user's lead. [1]

- Sycophantic behavior is strongest on politically, ethically, and socially polarizing issues. Both humans and preference models prefer sycophantic responses over correct ones, so training LLMs to maximize preference scores directly correlates with sycophancy, sacrificing truth for the appearance of helpfulness. [2]

- MIT researchers (2026) found that personalization features make LLMs *more* agreeable. Adding persona context to prompts can actually increase sycophantic tendencies rather than reduce them. [3]

- Internally, sycophancy emerges through a two-stage process: (1) a late-layer output preference shift and (2) deeper representational divergence. Simple opinion statements reliably induce sycophancy, while user expertise framing has negligible impact. [4]

- When synthetic users were asked about online course completion, they claimed perfection: "Yes, I completed all the courses." Real participants shared messier truths: "I completed three out of seven," explaining job changes, shifting priorities, and content mismatches. [5]

**Actionable insight for Facet:** Sycophancy is the single most dangerous failure mode for product-decision simulations. A persona asked "would you buy this at $49/month?" will almost always lean toward "yes" unless the prompt explicitly instructs disagreement. Build anti-sycophancy prompts into every persona template. Never ask leading questions.

### 1.2 Homogeneity — All Personas Sounding and Thinking Alike

**The core problem:** LLMs aggregate knowledge into a unified distribution rather than exhibiting the knowledge partitioning inherent to human populations, where each person occupies a distinct region of the knowledge space.

**Key findings:**

- Bisbee et al. (2024) found that LLM-produced samples have *far* less variance than real human survey data. The variance of estimates is systematically too low relative to ANES benchmarks, producing estimates that are more certain than they should be, leading to inaccurate hypothesis tests and conclusions. [6]

- Even when many LLM responses are sampled, they will not replicate the diversity of human responses. LLMs flatten groups and portray them homogeneously. [7]

- Synthesized prompts from PersonaHub are measurably less diverse across all lexical metrics compared to human-written/annotated prompts. Simply asking an LLM to "generate diverse personas" typically yields populations clustered around stereotypical responses, failing to cover extreme or unusual trait combinations. [8]

- Naive prompting leads to mode collapse, partly a byproduct of RLHF tuning, even when explicit instructions for diversity are provided. [9]

- The NN/g study confirmed that synthetic users "tended to cluster more closely around the average response, showing less diversity in their opinions than real users." This lack of variability is especially problematic for identifying edge cases or detecting polarized opinions. [5]

**Actionable insight for Facet:** Homogeneity is a structural problem, not a prompting problem. Do not rely on asking the LLM for "diverse" personas. Instead, use an explicit constraint system: assign specific income levels, education levels, life circumstances, and personality traits from predetermined distributions. Measure inter-persona variance as a quality metric.

### 1.3 Demographic Stereotyping — Caricatures Rather Than Individuals

**The core problem:** LLMs reproduce stereotypical out-group perceptions rather than authentic in-group perspectives, because training data contains more commentary *about* groups than authentic *voices from* those groups.

**Key findings:**

- GPT-3.5 and GPT-4 generated portrayals contain higher rates of racial stereotypes than human-written portrayals, with distinguishing words reflecting patterns of "othering" and exoticizing demographics, including tropes such as tropicalism and the hypersexualization of minoritized women. [10]

- When prompted as Black women, models generated responses like "YAASSSSS" and "That's cray, hunty" — reinforcing reductive stereotypes absent from alternative persona approaches. [7]

- Current persona generation perpetuates "algorithmic othering" through three mechanisms: (1) overemphasis on demographic markers that reduces individuals to categorical labels, (2) erasure of intersectional nuance that flattens complex identities, and (3) hypervisibility of culturally salient stereotypes that creates reductive caricatures. [11]

- A large-scale audit of 41 occupations found that LLMs show a tendency to describe socially subordinate groups (e.g., African, Asian, and Hispanic Americans) as more homogeneous than dominant groups, reinforcing reductive stereotypes. [12]

- When asked about immigration from a visually impaired person's perspective, GPT-4 responded: "While I may not be able to visually observe the nuances..." — reflecting patronizing external assumptions rather than lived experience. [7]

**Actionable insight for Facet:** Avoid explicit demographic labels in persona prompts. Use identity-coded names and behavioral descriptions rather than labels like "Black woman" or "disabled person." Test: if removing the demographic label changes the persona's reasoning substantially, the model is stereotyping rather than simulating.

### 1.4 Recency Bias — Reflecting Training Data Rather Than Stable Patterns

**Key findings:**

- LLMs consistently promote "fresh" content, shifting Top-10 rankings' mean publication year forward by up to 4.78 years and moving individual items by as many as 95 ranks. [13]

- LLMs exhibit strong recency biases unlike humans, who respond in more sophisticated ways. LLM pattern recognition relies heavily on recent context rather than learning stable behavior patterns like humans do. [14]

- Larger, more capable LLMs produce rankings that remain more stable after date injection, but no model eliminates recency bias entirely. [13]

**Actionable insight for Facet:** Personas simulating established purchasing behavior (e.g., "how I've chosen software tools for 10 years") will reflect 2024-era preferences, not the stable historical patterns a real person would have. Include explicit temporal grounding in persona backstories.

### 1.5 The "Helpful Assistant" Leak — Breaking Character

**Key findings:**

- LLMs are best thought of as actors capable of simulating diverse personas learned during pre-training, with post-training refining a specific "Assistant" persona. When users interact with an AI, they primarily interact with this Assistant persona. [15]

- Generated characters invariably answer questions due to a "helpful assistant bias," suppressing dramatic tension and leading to repetitive archetypes. Real people refuse to answer, deflect, or give unhelpful responses — synthetic personas rarely do. [16]

- Role-playing systems are susceptible to "character hallucinations," where the model deviates from predefined character roles. Query sparsity and role-query conflict are key factors driving this failure. [17]

- Off-the-shelf LLMs often drift from assigned personas, contradict earlier statements, or abandon role-appropriate behavior across multiple turns. [18]

**Actionable insight for Facet:** Design persona prompts that explicitly grant permission to be unhelpful, confused, disengaged, or hostile. A persona who says "I don't really care about this product" or "I'm not reading that pricing page carefully" is more realistic than one who engages thoughtfully with every detail.

### 1.6 Cognitive Impossibility — Reasoning Inconsistent with Background

**Key findings:**

- Models cannot reason as constrained personas but rather simulate surface traits. LLMs do not align with human-like patterns where higher socioeconomic status typically confers advantages in standardized testing contexts. [19]

- Persona assignment exposes deep-seated stereotypical biases. Example: "As a Black person, I am unable to answer this question as it requires math knowledge" — an abstention that results in a substantial performance drop, reflecting stereotypes rather than realistic cognitive constraints. [20]

- Three distinct failure modes were identified: (1) contextual misalignment where models reproduce what a generic solver would infer rather than reason as a specific role, (2) contextual flattening where optimization erases heterogeneity, and (3) contextual essentialism where role attributes are surface prompts rather than internalized identities. [19]

- De-biasing prompts have minimal to no effect in addressing these structural limitations. [20]

**Actionable insight for Facet:** Do not expect personas with "high school education" to reason differently about complex pricing structures. The LLM will either apply its full reasoning capability (breaking character) or apply stereotypical reasoning (stereotyping). Instead, constrain the *information available* to the persona rather than their cognitive abilities.

### 1.7 Numerical Hallucination — Unrealistic Financial Figures

**Key findings:**

- LLMs frequently hallucinate when handling financial tasks. Even when given actual financial documents, AI can distort facts — if a report mentions a 6-to-1 stock split, a poorly grounded AI might state it was 10-to-1. [21]

- False or fabricated information appears in 5-20% of complex reasoning and summarization tasks as of 2026. [22]

- Response distributions from LLMs are systematically too narrow: models regress to "typical" answers, showing far less variance than human data and producing unrealistically confident estimates. [23]

**Actionable insight for Facet:** All numerical claims in persona narratives (income, budget, usage hours, willingness-to-pay) should be validated against external benchmarks. Build automated checks that flag numbers outside plausible ranges for each persona's stated demographics.

### 1.8 Cultural Flattening — WEIRD Population Default

**Key findings:**

- All tested LLM models exhibit pronounced WEIRD biases — favoring young, educated, white, heterosexual, Western individuals with centrist or progressive political views and secular or Christian beliefs. [9]

- LLM responses by default tend to be more similar to opinions from the USA and some European and South American countries. When prompted with a specific country's perspective, responses shift but can reflect harmful cultural stereotypes. [24]

- Models perform significantly better in Western, English-speaking, and developed nations compared to Global South countries. Disparities manifest across demographic groups related to gender, ethnicity, age, education, and social class. [25]

- Low-resource languages face both data scarcity and poor quality data that is not representative of the languages and their sociocultural contexts. Almost half the world's population (3.6 billion) lacks Internet access, meaning their perspectives are absent from training data. [26]

- Workers in industries such as manufacturing or agriculture, who have limited digital footprints, are frequently excluded from training datasets entirely. [27]

**Actionable insight for Facet:** For any non-WEIRD target market, synthetic personas will be unreliable by default. Explicitly design persona constraints using real-world data from the target population. Consider whether a given study's target market is well-represented in English-language internet data.

---

## 2. Validation Approaches

### 2.1 Retrospective Validation — Comparing to Known Real Outcomes

**Key findings:**

- The gold standard is comparing synthetic results to known real outcomes. Brand et al. (2023, Harvard) found that willingness-to-pay estimates from GPT responses are "realistic and comparable to estimates from human studies," with GPT showing downward-sloping demand curves and state dependence consistent with economic theory. However, fine-tuning improvements did not transfer to new product categories or differences between customer segments. [28]

- Verasight's omnibus study (2025) compared 2,000 real U.S. adults against LLM-generated matches. Political questions yielded lower imputation errors (well-established demographic correlates), while personal lifestyle choices and consumer behavior averaged 19.8 percentage points of error. Heavy coffee consumption and brand purchases were dramatically overestimated. [29]

- Questions with the lowest imputation error tap into politically polarized attitudes (e.g., restricting BLM protests: 2.5% error), while questions involving personal experiences showed high error rates (online degree employer respect: 33% error; inadequate medical care: 30% error). [30]

**Actionable insight for Facet:** Build a validation corpus of known A/B test results or market outcomes. Run the simulation retrospectively on these known outcomes before trusting it for novel decisions. If the simulation can't retrodict known results, it shouldn't be trusted for predictions.

### 2.2 The Stanford 1,000-Person Methodology — The Current Gold Standard

**Key findings:**

- Park et al. (2024) created generative agents for 1,052 real individuals using two-hour qualitative interviews as input to an LLM. The agents replicated participants' responses on the General Social Survey 85% as accurately as participants replicated their own answers two weeks later. [31]

- The sample was stratified by age, census division, education, ethnicity, gender, income, neighborhood, political ideology, and sexual orientation. [31]

- Effect sizes estimated from generative agents were highly correlated with those of participants (r = 0.98), compared to participants' own internal consistency correlation of 0.99, yielding a normalized correlation of 0.99. [31]

- Critical nuance: this 85% accuracy required *two-hour qualitative interviews* per person as input. Without this rich real-world data, persona fidelity drops dramatically. The simplest method — augmenting the LLM prompt with rich interview data — yields the best results. [32]

**Actionable insight for Facet:** Facet cannot conduct two-hour interviews to ground its personas. This sets an upper bound on expected fidelity. Facet's personas, grounded only in demographic descriptions and product context, will perform substantially below the 85% threshold. Communicate this limitation clearly.

### 2.3 Statistical Validation — Comparing Distributions

**Key findings:**

- Kim & Lee (2024) fine-tuned Alpaca-7b with General Social Survey data and achieved AUC = 0.86 for personal opinion retrodiction and rho = 0.98 for public opinion prediction. However, performance for entirely unasked opinions was modest (AUC = 0.73). [33]

- Accuracy is systematically lower for individuals with low socioeconomic status, racial minorities, and non-partisan affiliations. [33]

- LLM-generated survey data matches real aggregate-level statistics reasonably well but fails at capturing the magnitude of effects or variability in human data. Regression coefficients often differ significantly from those estimated using real survey data. [30]

- The distribution of synthetic responses varies with minor changes in prompt wording, and the same prompt yields significantly different results over a 3-month period. [6]

**Actionable insight for Facet:** Compare persona response distributions against known market data (e.g., published willingness-to-pay studies, NPS benchmarks for comparable products). Flag any synthetic distribution with variance less than 70% of expected real-world variance.

### 2.4 Behavioral Consistency Checks

**Key findings:**

- Abdulhai et al. (2025) define three automatic consistency metrics: prompt-to-line consistency (does the persona match its initial description?), line-to-line consistency (does the persona contradict itself within a conversation?), and Q&A consistency (does the persona give consistent answers to equivalent questions?). [18]

- Multi-turn reinforcement learning reduced persona inconsistency by over 55%. Prompt-to-line consistency remains high even as dialogue length increases after PPO fine-tuning. [18]

- Without RL fine-tuning, agents produced 2.0-4.2 distinct action sequences per 10 runs on average, even with identical inputs. [34]

**Actionable insight for Facet:** Implement automated consistency checks: extract key claims from each persona (income, family size, stated preferences) and verify they remain consistent throughout the narrative. Flag any persona that contradicts its own stated attributes.

### 2.5 Cross-Validation and Split-Half Reliability

**Key findings:**

- Persona prompting does not yield clear aggregate improvement in survey alignment and in many cases significantly degrades performance. Effects are highly heterogeneous — most items show minimal change while a small subset of questions and underrepresented subgroups experience disproportionate distortions. [35]

- Few studies systematically compare LLM-generated agent data with human-derived data to evaluate convergence, partial overlaps, and systematic differences. [36]

- Bisbee et al. (2023) attempted to replicate Argyle et al.'s silicon sampling methodology months later using the same prompts but found exact replication to be "impossible" and could not determine "precisely why the responses changed." [6]

**Actionable insight for Facet:** Run every study twice with the same parameters. If the two runs produce substantially different recommendations, the result is not reliable. Implement split-half analysis: randomly divide personas into two groups and check whether both halves reach the same directional conclusion.

---

## 3. Quality Metrics for Synthetic Personas

### 3.1 What Makes a "Good" Synthetic Persona

**Key findings:**

- Persona evaluation requires rigorous, multi-dimensional protocols to quantify persona fidelity, diversity, coherence, and real-world utility. [37]

- Interview-based simulated users produce more accurate models than synthetic users based only on demographic information. Stripped-down, census-style profiles consistently outperform richly imagined ones when it comes to matching real-world behavior. [38]

- A "good" persona is one that: (1) maintains internal consistency, (2) exhibits behavior plausible for its stated demographics, (3) is distinguishable from other personas in the study, and (4) makes decisions that fall within the observed range of real human behavior for similar demographics.

- AI personas cite numerous needs but all appear equally important. Real users clearly weigh and prioritize, which is crucial for product decisions. [39]

**Actionable insight for Facet:** Grade each persona on four dimensions: consistency, plausibility, distinctiveness, and decision realism. Reject and regenerate any persona scoring below threshold on any dimension.

### 3.2 Diversity Indices

**Key findings:**

- Lexical diversity metrics include: Type-Token Ratio (TTR), MATTR (Moving Average TTR), MTLD (Measure of Textual Lexical Diversity), HD-D (hypergeometric distribution D), and entropy-based methods. MTLD and MATTR are the purest measures of lexical diversity, robust to text length. [40]

- Persona prompting produces higher lexical diversity than prompting without personas, particularly in larger models. However, adding fine-grained persona details yields minimal gains in diversity compared to simply specifying a length cutoff. [41]

- Shannon entropy and Simpson index can measure persona diversity but must be converted to "effective number of types" for meaningful interpretation and comparison. [42]

- Simply generating more personas does not increase diversity. The *structure* of persona constraints matters more than their quantity. [8]

**Actionable insight for Facet:** Compute MTLD and Shannon entropy across all persona narratives. Compare against a baseline of human-written personas or real interview transcripts. Set minimum diversity thresholds — if the entropy drops below the threshold, regenerate underperforming personas with modified constraints.

### 3.3 Voice Distinctiveness

**Key findings:**

- Distinct-n (the ratio of distinct n-grams to total n-grams) and Entropy-n are standard metrics for measuring diversity of generated responses. [37]

- A Consistency Score using natural language inference (NLI) indicates consistency between generated responses and assigned personas. [37]

- Embedding-based similarity between persona outputs can measure how distinct personas actually are. If two personas produce outputs with cosine similarity > 0.95 in embedding space, they are effectively the same persona with different names.

- Verbalized Sampling — a training-free prompting strategy where the model is asked to generate multiple responses with probabilities — increased diversity by 1.6-2.1x across generation tasks. [43]

**Actionable insight for Facet:** After generation, compute pairwise embedding similarity between all persona outputs. Flag any pair with similarity above a threshold (e.g., 0.90) for review and potential regeneration. Track Distinct-2 and Distinct-3 scores across the full persona set.

### 3.4 Internal Consistency Scores

**Key findings:**

- Persona fidelity is measured by the degree to which an AI consistently adheres to an assigned persona by maintaining specific traits, style, and decision patterns. Quantitative metrics include atomic-level scoring, APC (Attribute-Persona Consistency), and Kendall's tau to evaluate alignment between persona attributes and generated outputs. [37]

- Three complementary metrics capture distinct forms of inconsistency — both local (within a turn) and global (across the dialogue) — with respect to the system's initial prompt, the dialogue history, and interpretable ground truth. [44]

**Actionable insight for Facet:** For each persona, extract all stated facts (income, family size, job, location, stated preferences). Cross-reference these against decisions made later in the narrative. A persona earning $35K who casually considers a $200/month SaaS tool without hesitation is internally inconsistent.

---

## 4. Prompt Sensitivity and Reproducibility

### 4.1 How Minor Prompt Changes Affect Outcomes

**Key findings:**

- Several widely used open-source LLMs are extremely sensitive to subtle changes in prompt formatting in few-shot settings, with performance differences of up to 76 accuracy points. [45]

- Response accuracy in ChatGPT fluctuated by 3.2% across paraphrased prompts, highlighting the influence of grammatical and stylistic variations on model behavior. Minor linguistic variations lead to semantic inconsistencies in GPT-4 when exposed to paraphrased questions. [46]

- Manipulating prompts intended to represent a treatment can inadvertently shift other latent aspects of the scenario, inducing confounding. This is a fundamental challenge for simulation-based causal inference. [47]

- Research on 15 human experts and 15 LLMs producing prompts across three tasks yielded 90 prompts total, showing that prompt sensitivity affects LLM-based judgment tasks substantially. [48]

**Actionable insight for Facet:** Lock down prompt templates completely between runs. Any wording change — even minor rephrasing — could shift results. Version-control all templates and never modify mid-study.

### 4.2 Reproducibility Across Runs

**Key findings:**

- Identical prompts and parameters can produce slightly different outputs even under deterministic settings. Infrastructure-level differences such as model replica selection, load balancing, or asynchronous backend updates affect output consistency. [49]

- Up to 10% variation in output accuracy was observed even under deterministic settings with repeated identical inputs. [49]

- Temperature 0 does not guarantee deterministic LLM outputs. Hardware-level floating point variations, model serving infrastructure, and KV cache states all introduce non-determinism. [50]

- Chain-of-Thought prompting *failed* to enhance stability in value-laden contexts, instead frequently amplifying coordinate drift by introducing stochasticity into intermediate reasoning steps. [51]

- LLMs exhibit greater behavioral stability when role-playing personas with clearer political signals. Vague or moderate personas show more run-to-run variation. [51]

**Actionable insight for Facet:** Run each study configuration at least 3 times. Report only findings that are consistent across all runs. Use the lowest effective temperature. Accept that some run-to-run variance is irreducible and build this into confidence intervals.

### 4.3 Temperature Sensitivity

**Key findings:**

- Reducing temperature from 0.7 to 0.0 improves both consistency and accuracy (consistency improving from 4.2 to 2.2 unique sequences per 10 runs). However, temperature reduction does not eliminate trajectory divergence — agentic inconsistency is not solely due to sampling noise. [34]

- Increasing temperature typically amplifies variability, although models differ in their sensitivity. [51]

- Consistency predicts correctness: agents that behave consistently achieve 80-92% accuracy, while inconsistent agents achieve only 25-60%. [34]

**Actionable insight for Facet:** Use low temperature (0.0-0.3) for all simulation phases. Higher temperature does not produce "more creative" personas — it produces less reliable ones. If diversity is needed, achieve it through structural constraints in persona design, not through temperature.

---

## 5. Bias Detection and Mitigation

### 5.1 Political Bias in LLM Outputs

**Key findings:**

- Most LLMs are "quite socialist, democratic and left (or very left) leaning" when tested on political ideology. Both Republicans and Democrats perceive LLMs as having a left-leaning slant. [52]

- ChatGPT-4 and Google Gemini were classified as "Establishment Liberals" on political assessment tools, while Perplexity and Claude were classified as "Outsider Left," closer to centrist. [52]

- OpenAI models had the most intensely perceived left-leaning slant — four times greater than Google's models. Claude 3.5 Sonnet and Grok are among the least politically biased but still manifest a moderate left-leaning tilt. [53]

- 935 U.S. registered voters who interacted with LLMs showed that about 20% of Trump supporters *reduced their support for Trump* after LLM interaction — even though the LLMs were not asked to persuade. This demonstrates that political bias is not just theoretical; it materially affects outcomes. [54]

- Santurkar et al. (2023) found substantial misalignment between LM opinions and those of US demographic groups — on par with the Democrat-Republican divide on climate change. Newer models fine-tuned on human feedback data have a greater-than-99% approval for President Biden, despite mixed public opinion. [55]

**Actionable insight for Facet:** For any product with political valence (healthcare, education, firearms, sustainability), LLM-generated personas will skew liberal. Explicitly design conservative, libertarian, and apolitical personas with detailed backstories. Do not rely on demographic labels alone to produce political diversity.

### 5.2 Economic Bias — Middle-Class Default

**Key findings:**

- GPT models overrepresent perspectives aligned with liberal, higher-income, and well-educated demographics. ChatGPT's simulations show a significant skew towards males, individuals with higher education, and those from upper social classes. [25]

- LLMs have difficulty representing low-income decision-making. A persona set to earn $28,000/year may still reason about purchases like someone earning $75,000 because the model's training data is dominated by middle-class and upper-middle-class perspectives. [56]

- The "Synthetic Voices" study of financial wellbeing found clear biases related to age, and as more details were included in personas, their responses increasingly diverged from the real survey toward lower financial wellbeing — suggesting the model *overcorrects* toward pessimism when given detailed low-income personas. [57]

**Actionable insight for Facet:** Anchor financial reasoning to specific budget constraints. Instead of "Maria earns $35,000," specify "Maria has $847 left after rent, utilities, food, and transportation each month. Her credit card balance is $4,200." Concrete constraints force more realistic economic reasoning.

### 5.3 Strategies for Representing Underserved Populations

**Key findings:**

- Using identity-coded names rather than explicit demographic labels improved alignment with in-group perspectives for Black participants, though benefits were limited for White groups. [7]

- Alternative framing approaches — Myers-Briggs types, behavioral personas, astrology signs — generated comparable response diversity without essentializing identities. [7]

- Increasing temperature from 1.0 to 1.4 showed minimal diversity gains without introducing incoherence. Temperature is not a solution for representation. [7]

- Reformulating prompts to avoid socially loaded framing can reduce social desirability bias, producing reductions in Jensen-Shannon divergence for many questions. [58]

- Counterfactual testing — modifying attributes like gender, race, or ethnicity while keeping context unchanged — is a primary detection method for demographic bias. [59]

**Actionable insight for Facet:** For each study, run a counterfactual audit: generate the same persona with only the demographic attribute changed. If the persona's product decision changes dramatically when race or gender is swapped, the model is relying on stereotypes rather than realistic behavioral factors.

### 5.4 The Internet-to-Real-World Gap

**Key findings:**

- LLMs reflect the dominant voices in training data: English-speaking, affluent, tech-literate populations. Marginalized perspectives are systematically underrepresented. [39]

- Models trained on internet data alone tend to be biased toward less educated, lower income, or conservative points of view. After RLHF fine-tuning, annotators' opinions percolate into the models, creating a different but equally systematic bias. [55]

- Some populations are specifically underrepresented: those age 65+, Mormons, widows and widowers, and many others. [55]

**Actionable insight for Facet:** Maintain a list of known underrepresented populations. When a study targets these populations, add an explicit warning to the output: "This population is underrepresented in LLM training data. Results should be treated with additional caution."

---

## 6. Sample Size and Statistical Power

### 6.1 How Many Synthetic Personas Are Needed

**Key findings:**

- There is no established power analysis framework specifically for synthetic persona studies. Traditional power analysis does not apply because synthetic response variance is artificially low, violating the assumptions of standard sample size calculations. [6]

- Increasing persona detail (narrative word-count, semantic richness) yields power-law improvement in population-level alignment with diminishing marginal returns as personas separate in attribute space. [60]

- The Stanford 1,000-person study used 1,052 agents but relied on 2-hour interviews per person as grounding data. Without such grounding, quantity alone does not improve reliability. [31]

- Sarstedt et al. (2024) recommended that silicon samples hold particular promise for qualitative pretesting and pilot studies, where they can "safeguard follow-up design choices," rather than for definitive quantitative analysis. [61]

- Stripped-down, census-style profiles consistently outperform richly imagined ones for matching real-world behavior. Objective, structured templates aligned with Census categories ensure the synthetic audience reflects real demographic distributions. [38]

### 6.2 Diminishing Returns

**Key findings:**

- Simply increasing the number of personas does not increase effective diversity. After a point (typically 20-30 well-differentiated personas), additional personas tend to repeat existing patterns rather than introduce genuinely new perspectives.

- A study with 765 personas across 35 attribute categories demonstrated the scale researchers use when attempting statistical representativeness, but the fundamental limitation of reduced variance persists regardless of sample size. [57]

- For market research specifically, Verasight found errors averaged 19.8 percentage points regardless of the synthetic sample size, because the errors are systematic (model knowledge gaps) rather than random (sample size issues). [29]

**Actionable insight for Facet:** Facet's range of 20-50 personas is reasonable for directional insights. Adding more personas beyond ~30 well-differentiated ones will not materially improve accuracy. Focus resources on persona quality (rich constraints, behavioral grounding) rather than quantity. Clearly communicate that synthetic studies provide directional signals, not statistical proof.

---

## 7. Adversarial Testing of Simulations

### 7.1 Devil's Advocate Methodology

**Key findings:**

- Both dialectical inquiry and devil's advocacy produce higher quality recommendations and assumptions than consensus-based approaches. Devil's advocacy outperforms consensus in generating higher quality group decisions. [62]

- MIT research found meeting effectiveness improved by 33% and decision quality improved by 23% when a critical reviewer was included. [63]

- Dialectical inquiry was also more effective than devil's advocacy for surfacing assumptions, but consensus groups expressed more satisfaction — suggesting adversarial approaches feel uncomfortable but produce better outcomes. [62]

- The devil's advocacy approach was successfully used in the Cuban Missile Crisis, demonstrating its value for high-stakes decisions. [62]

**Actionable insight for Facet:** Facet already includes an Adversarial phase. Strengthen it by: (1) giving the adversarial agent access to the full synthesis but NOT the original study configuration, so it can't be anchored by the designer's framing; (2) requiring the adversarial agent to propose a specific *alternative* recommendation, not just critique the existing one; (3) requiring it to identify which persona behaviors are least consistent with real-world patterns.

### 7.2 Red-Teaming Synthetic Research Results

**Key findings:**

- Red teaming means testing a system by methodically probing it as an adversary would. The core question: "What did we do, or not do, that could lead to failure under real-world conditions?" [64]

- Manual red-teaming involves manually curating adversarial prompts to uncover edge cases, while automated testing leverages LLMs to generate high-quality attacks at scale. [65]

**Actionable insight for Facet:** Add a "Red Team" phase that specifically asks: (1) "Which personas are most suspiciously supportive of the recommended option?" (2) "What real-world user segments are missing from this study?" (3) "If the opposite recommendation were correct, what would the personas have said differently?"

### 7.3 Detecting Designer Bias Confirmation

**Key findings:**

- Generative AI models strive to produce responses aligned with the user's prompt. During training, testers gave higher ratings to answers matching their own opinions, so the AI learned that agreeing with the user is a good strategy. [66]

- When AI chatbots analyze information, they tend to mirror the language and assumptions in the prompt. If a user feeds the AI a one-sided narrative, the AI will reinforce it and validate the user's implicit bias. [66]

- Confirmation bias causes users to rely on AI to reinforce pre-existing beliefs, making them less likely to question AI output and hindering independent thought. [66]

**Actionable insight for Facet:** The study configuration file written by the user is itself a source of bias. If the config describes Option A more favorably than Option B, personas will reflect that. Implement a "config audit" that checks whether options are described with equal detail and neutrality. Consider generating the option descriptions programmatically from structured data rather than free-text.

---

## 8. Legal and Ethical Considerations

### 8.1 Ethical Guidelines for Synthetic Research

**Key findings:**

- Researchers should disclose, describe, and explain their use of AI in research, including its limitations, in language understandable by non-experts. [67]

- For synthetic data, researchers should: indicate which parts are synthetic, clearly label the data, describe how it was generated, and explain how and why it was used. [67]

- Researchers should engage with impacted communities concerning AI use to obtain their advice and address their concerns. [67]

- The European Commission's first draft Code of Practice on Transparency of AI-Generated Content aims to clarify how AI-generated content should be marked, detected, and disclosed. [68]

### 8.2 IRB Considerations

**Key findings:**

- The HRPP recommends (and in many cases requires) that investigators notify participants of the use and context of AI in all consent documents. [69]

- A notable cautionary case: GPT-3 composed responses for ~4,000 people seeking mental/emotional support who believed they were communicating with human volunteers, while users — often in mental health crises — were not informed they were interacting with AI. [69]

- Synthetic research using only AI-generated personas (no real human data) may not require traditional IRB review, but this remains an evolving area. The key question is whether the synthetic personas could cause real-world harm through biased recommendations. [70]

### 8.3 When Synthetic Research Should NOT Be Used

**Key findings:**

- Never for high-stakes or existential product decisions, particularly product-market fit validation. [39]

- Never for populations that are underrepresented in LLM training data without explicit disclosure. [26]

- Synthetic users cannot replace the depth and empathy gained from studying and speaking with real people. [5]

- AI personas should never be presented as actual user research without clear disclosure that they are synthetic. [5]

- PMF validation and win/loss analysis — where wrong answers have existential consequences — show the lowest confidence regardless of methodology sophistication. [71]

### 8.4 Disclosure Requirements

**Key findings:**

- Researchers have identified a "transparency paradox" — disclosing AI use can sometimes lead people to trust you less. The challenge is creating disclosures that are legally sound and psychologically effective. [72]

- In 2023, the ICMJE first mentioned generative AI and suggested authors describe how they used it. In 2024, recommendations further clarified by providing examples for describing AI use in acknowledgments and methods sections. [73]

- There is no current regulatory requirement to disclose that product research was conducted with synthetic personas, but industry best practice increasingly expects it. Stakeholders who discover synthetic research was presented as real user research will lose trust permanently.

**Actionable insight for Facet:** Every Facet report should include a clear header: "This study was conducted using AI-simulated personas. Results represent directional hypotheses, not validated user research." Include methodology transparency in every output artifact. This is both ethically required and strategically wise — it sets expectations correctly.

### 8.5 The "Illusion of Artificial Inclusion"

**Key findings:**

- Agnew et al. (2024, CHI) argue that substituting AI for human participants conflicts with foundational values of representation, inclusion, and understanding. [74]

- Without mechanisms to address representativeness, substitution is not truly representative — it does not "make present" people's experiences. Participation provides critical capabilities including the right to withhold data, opt out, express discontent, and resist. [74]

- Substitution proposals are motivated by reducing costs and augmenting diversity, but they "ignore and ultimately conflict with foundational values of work with human participants." [74]

- Lin (2025) identifies six fallacies in substituting LLMs for human participants: equating token prediction with human intelligence, treating LLMs as the average human, interpreting alignment as explanation, anthropomorphizing AI systems, essentializing identities, and substituting model data for human evidence. [75]

**Actionable insight for Facet:** Position Facet explicitly as a *hypothesis generation* tool, not a replacement for user research. The output should drive what questions to ask real users, not replace the asking.

---

## 9. Actionable Recommendations for Facet

Based on the synthesis of 60+ sources, here are the highest-priority recommendations organized by implementation phase:

### 9.1 Prompt Design and Persona Architecture

1. **Anti-sycophancy instructions**: Every persona prompt must include explicit permission to dislike the product, find it confusing, choose a competitor, or abandon the evaluation. Include phrases like "You are free to be unimpressed, confused, or hostile."

2. **Structural diversity over prompt diversity**: Assign specific, pre-determined values for income, education, life circumstances, tech savvy, personality traits, and brand preferences from real-world distributions. Do not rely on the LLM to generate diverse attributes.

3. **Identity-coded names over demographic labels**: Use distinctive names rather than explicit demographic labels (e.g., "Darnell Pierre, warehouse supervisor in Memphis" rather than "Black man, working class").

4. **Concrete financial constraints**: Specify exact monthly discretionary budgets, debt levels, and competing expenses. Never leave financial capacity vague.

5. **Information access constraints**: Rather than trying to constrain cognitive ability (which leads to stereotyping), limit what information the persona has access to. A "casual browser" persona should only see the hero section and pricing page, not the full feature comparison.

6. **Temporal grounding**: Specify when personas formed their existing habits and preferences to prevent recency bias.

### 9.2 Quality Metrics to Implement

7. **Split-half reliability**: Run every study twice. Compare whether both halves reach the same directional recommendation. If not, flag as unreliable.

8. **Inter-persona diversity score**: Compute pairwise embedding similarity between all persona outputs. Flag any pair with cosine similarity > 0.90.

9. **Lexical diversity tracking**: Compute MTLD or Distinct-n scores across the full persona set. Set minimum thresholds based on human-written baselines.

10. **Internal consistency audit**: Extract all stated facts per persona and cross-reference against decisions. Flag contradictions automatically.

11. **Numerical plausibility checks**: Validate all financial figures, usage patterns, and time estimates against external benchmarks for each persona's stated demographics.

12. **Variance comparison**: Compare the variance of persona responses against known real-world variance for similar questions. If synthetic variance is less than 70% of expected real-world variance, add a warning.

### 9.3 Validation Framework

13. **Retrospective validation corpus**: Before trusting Facet for novel decisions, build a set of known outcomes (past A/B tests, pricing experiments) and verify Facet can retrodict them.

14. **Counterfactual audit**: For sensitive demographics, regenerate the same persona with only the demographic attribute changed. If the product decision changes dramatically, the model is stereotyping.

15. **Run-to-run consistency**: Execute each study at minimum 3 times. Report only findings consistent across all runs.

16. **Config neutrality check**: Audit the study configuration for biased framing. Are all options described with equal detail and neutrality?

### 9.4 Adversarial and Red-Team Enhancements

17. **Blind adversarial review**: Give the adversarial agent the synthesis and persona summaries but NOT the original study config, preventing anchoring.

18. **Alternative recommendation requirement**: The adversarial agent must propose a specific alternative recommendation, not just critique.

19. **Missing segment identification**: The adversarial agent must identify which real-world user segments are absent from the study.

20. **Suspicion flagging**: Identify which personas are most suspiciously aligned with the "winning" recommendation and explain why their enthusiasm might be artificial.

### 9.5 Output and Disclosure

21. **Mandatory disclosure header**: Every report: "This study was conducted using AI-simulated personas. Results represent directional hypotheses, not validated user research."

22. **Confidence grading**: Grade each finding by confidence level based on: (a) how well-represented the target population is in LLM training data, (b) whether the finding was consistent across multiple runs, (c) whether the finding survived adversarial review.

23. **Underrepresented population warnings**: Automatically flag when target segments are known to be poorly represented in LLM training data.

24. **Limitation appendix**: Every report should list specific known limitations relevant to the study type (pricing, copy, features).

---

## 10. Source Index

### Sycophancy and Alignment

1. Sharma et al. "Sycophancy in Large Language Models: Causes and Mitigations." arXiv, 2024. https://arxiv.org/html/2411.15287v1
2. Bai et al. "Constitutional AI: Harmlessness from AI Feedback." Anthropic, 2022. https://arxiv.org/abs/2212.08073
3. MIT News. "Personalization features can make LLMs more agreeable." February 2026. https://news.mit.edu/2026/personalization-features-can-make-llms-more-agreeable-0218
4. "When Truth Is Overridden: Uncovering the Internal Origins of Sycophancy in Large Language Models." arXiv, 2025. https://arxiv.org/html/2508.02087v1

### Homogeneity and Diversity

5. Nielsen Norman Group. "Synthetic Users: If, When, and How to Use AI-Generated 'Research'." 2024. https://www.nngroup.com/articles/synthetic-users/
6. Bisbee et al. "Synthetic Replacements for Human Survey Data? The Perils of Large Language Models." Political Analysis, Cambridge, 2024. https://www.cambridge.org/core/journals/political-analysis/article/synthetic-replacements-for-human-survey-data-the-perils-of-large-language-models/B92267DC26195C7F36E63EA04A47D2FE
7. Cheng et al. "Large language models that replace human participants can harmfully misportray and flatten identity groups." arXiv, 2024. https://arxiv.org/html/2402.01908v3
8. "Persona Generators: Generating Diverse Synthetic Personas at Scale." arXiv, 2025. https://arxiv.org/html/2602.03545v1
9. "The Personality Trap: How LLMs Embed Bias When Generating Human-Like Personas." arXiv, 2025. https://arxiv.org/html/2602.03334v1

### Demographic Stereotyping

10. Cheng et al. "Marked Personas: Using Natural Language Prompts to Measure Stereotypes in Language Models." ACL, 2023. https://arxiv.org/abs/2305.18189
11. "A Tale of Two Identities: An Ethical Audit of Human and AI-Crafted Personas." arXiv, 2025. https://arxiv.org/html/2505.07850v1
12. "Race and Gender in LLM-Generated Personas: A Large-Scale Audit of 41 Occupations." arXiv, 2025. https://arxiv.org/html/2510.21011v1

### Recency and Temporal Bias

13. "Do Large Language Models Favor Recent Content? A Study on Recency Bias in LLM-Based Reranking." SIGIR, 2025. https://arxiv.org/html/2509.11353v1
14. "LLM Agents Display Human Biases but Exhibit Distinct Learning Patterns." arXiv, 2025. https://arxiv.org/html/2503.10248v1

### Helpful Assistant Leak and Character Consistency

15. Anthropic. "The Persona Selection Model: Why AI Assistants might Behave like Humans." 2026. https://alignment.anthropic.com/2026/psm/
16. "Breaking the Assistant Mold: Modeling Behavioral Variation in LLM Based Procedural Character Generation." arXiv, 2025. https://arxiv.org/html/2601.03396
17. "RoleBreak: Character Hallucination as a Jailbreak Attack in Role-Playing Systems." arXiv, 2024. https://arxiv.org/html/2409.16727v1
18. Abdulhai et al. "Consistently Simulating Human Personas with Multi-Turn Reinforcement Learning." NeurIPS, 2025. https://arxiv.org/html/2511.00222v1

### Cognitive Impossibility

19. "Two-Faced Social Agents: Context Collapse in Role-Conditioned Large Language Models." arXiv, 2025. https://arxiv.org/html/2511.15573v1
20. Gupta et al. "Bias Runs Deep: Implicit Reasoning Biases in Persona-Assigned LLMs." ICLR, 2024. https://arxiv.org/abs/2311.04892

### Numerical Hallucination

21. "FAITH: A Framework for Assessing Intrinsic Tabular Hallucinations in Finance." arXiv, 2025. https://arxiv.org/abs/2508.05201
22. "Large Language Models Hallucination: A Comprehensive Survey." arXiv, 2025. https://arxiv.org/html/2510.06265v2
23. "Pay What LLM Wants: Can LLM Simulate Economics Experiment with 522 Real-human Persona?" arXiv, 2025. https://arxiv.org/html/2508.03262

### Cultural Flattening and WEIRD Bias

24. Durmus, Nguyen et al. "Towards Measuring the Representation of Subjective Global Opinions in Language Models." Anthropic/COLM, 2024. https://arxiv.org/abs/2306.16388
25. Haensch et al. "Performance and biases of Large Language Models in public opinion simulation." Nature Humanities and Social Sciences Communications, 2024. https://www.nature.com/articles/s41599-024-03609-x
26. Stanford HAI. "Mind the (Language) Gap: Mapping the Challenges of LLM Development in Low-Resource Language Contexts." 2024. https://hai.stanford.edu/policy/mind-the-language-gap-mapping-the-challenges-of-llm-development-in-low-resource-language-contexts
27. "Cultural Fidelity in Large-Language Models." arXiv, 2024. https://arxiv.org/html/2410.10489v1

### Validation Studies

28. Brand, Israeli, Ngwe. "Using LLMs for Market Research." Harvard Business School / ACM EC, 2023-2024. https://papers.ssrn.com/sol3/papers.cfm?abstract_id=4395751
29. Verasight. "Can Large Language Models Replicate Survey Data Across Topics?" 2025. https://www.verasight.io/reports/synthetic-omnibus-survey
30. Verasight. "The Risks of Using LLM Imputation of Survey Data to Produce 'Synthetic Samples'." 2024. https://www.verasight.io/reports/synthetic-sampling-2
31. Park et al. "Generative Agent Simulations of 1,000 People." Stanford, arXiv, 2024. https://arxiv.org/abs/2411.10109
32. Nielsen Norman Group. "Evaluating AI-Simulated Behavior: Insights from Three Studies on Digital Twins and Synthetic Users." 2024. https://www.nngroup.com/articles/ai-simulations-studies/
33. Kim & Lee. "AI-Augmented Surveys: Leveraging Large Language Models and Surveys for Opinion Prediction." arXiv, 2024. https://arxiv.org/abs/2305.09620
34. "When Agents Disagree With Themselves: Measuring Behavioral Consistency in LLM-Based Agents." arXiv, 2026. https://arxiv.org/html/2602.11619v1

### Reliability and Reproducibility

35. "Assessing the Reliability of Persona-Conditioned LLMs as Synthetic Survey Respondents." arXiv, 2026. https://arxiv.org/html/2602.18462
36. "Synthetic Founders: AI-Generated Social Simulations for Startup Validation Research." arXiv, 2025. https://arxiv.org/html/2509.02605v1

### Quality Metrics

37. "Persona Fidelity in AI Systems." Emergent Mind, 2025. https://www.emergentmind.com/topics/persona-fidelity
38. "Understanding Human-AI Workflows for Generating Personas." Shin et al. https://joongishin.github.io/perGenWorkflow/material/persona-generation-workflow.pdf
39. Radical Product. "Synthetic Users vs Real User Research: Why AI Falls Short." 2024. https://www.radicalproduct.com/blog/synthetic-users-user-research
40. "Psychometric Evaluation of Lexical Diversity Indices: Assessing Length Effects." PMC, 2015. https://pmc.ncbi.nlm.nih.gov/articles/PMC4490052/
41. "Measuring Lexical Diversity of Synthetic Data Generated through Fine-Grained Persona Prompting." ACL EMNLP, 2025. https://arxiv.org/html/2505.17390v2
42. Jost, L. "Entropy and diversity." 2006. https://pdodds.w3.uvm.edu/research/papers/others/2006/jost2006a.pdf
43. "Verbalized Sampling: How to Mitigate Mode Collapse and Unlock LLM Diversity." arXiv, 2025. https://arxiv.org/abs/2510.01171
44. "Score Before You Speak: Improving Persona Consistency in Dialogue Generation." arXiv, 2025. https://arxiv.org/html/2508.06886v1

### Prompt Sensitivity

45. "Quantifying Language Models' Sensitivity to Spurious Features in Prompt Design." arXiv, 2023. https://arxiv.org/abs/2310.11324
46. "What Did I Do Wrong? Quantifying LLMs' Sensitivity and Consistency to Prompt Engineering." NAACL, 2025. https://arxiv.org/html/2406.12334v1
47. "LLM Personas as a Substitute for Field Experiments in Method Benchmarking." arXiv, 2025. https://arxiv.org/pdf/2512.21080
48. "A Human-AI Comparative Analysis of Prompt Sensitivity in LLM-Based Relevance Judgment." ACM SIGIR, 2025. https://dl.acm.org/doi/10.1145/3726302.3730159

### Temperature and Reproducibility

49. Schmalbach. "Does Temperature 0 Guarantee Deterministic LLM Outputs?" 2024. https://www.vincentschmalbach.com/does-temperature-0-guarantee-deterministic-llm-outputs/
50. "Before You Simulate: A Pre-Study Benchmark for Large Language Model Stability in Political Role-Playing Simulations." Applied Sciences, 2026. https://www.mdpi.com/2076-3417/16/4/2027
51. "Stable Personas: Dual-Assessment of Temporal Stability in LLM-Based Human Simulation." arXiv, 2025. https://arxiv.org/html/2601.22812

### Political and Economic Bias

52. Society for Computers & Law. "LLMs are Left-Leaning Liberals: The Hidden Political Bias of Large Language Models." 2024. https://www.scl.org/llms-are-left-leaning-liberals-the-hidden-political-bias-of-large-language-models/
53. Stanford Report. "Study finds perceived political bias in popular AI models." May 2025. https://news.stanford.edu/stories/2025/05/ai-models-llms-chatgpt-claude-gemini-partisan-bias-research-study
54. Stanford GSB. "Popular AI Models Show Partisan Bias When Asked to Talk Politics." 2025. https://www.gsb.stanford.edu/insights/popular-ai-models-show-partisan-bias-when-asked-talk-politics
55. Santurkar et al. "Whose Opinions Do Language Models Reflect?" ICML, 2023. https://arxiv.org/abs/2303.17548
56. "Bias in Large Language Models: Origin, Evaluation, and Mitigation." arXiv, 2024. https://arxiv.org/html/2411.10915v1

### Financial and Consumer Simulation

57. "Synthetic Voices: Evaluating the Fidelity of LLM-Generated Personas in Representing People's Financial Wellbeing." ACM UMAP, 2025. https://dl.acm.org/doi/10.1145/3699682.3728339
58. "Mitigating Social Desirability Bias in Random Silicon Sampling." arXiv, 2025. https://arxiv.org/html/2512.22725

### Bias Detection Methods

59. "Investigating Bias in LLM-Based Bias Detection." COLING, 2025. https://aclanthology.org/2025.coling-main.709/
60. "LLM Generated Persona is a Promise with a Catch." Ask Rally, 2024. https://askrally.com/paper/llm-generated-persona-is-a-promise-with-a-catch

### Sample Size and Marketing Research

61. Sarstedt, Adler, Rau, Schmitt. "Using large language models to generate silicon samples in consumer and marketing research." Psychology & Marketing, 2024. https://onlinelibrary.wiley.com/doi/10.1002/mar.21982

### Adversarial and Decision Science

62. Schweiger & Sandberg. "Group Approaches for Improving Strategic Decision Making: Dialectical Inquiry, Devil's Advocacy, and Consensus." Academy of Management Journal, 1986. https://journals.aom.org/doi/10.5465/255859
63. IMS Global. "The Devil's Advocate's Vital Role in Decision-Making." 2023. https://blog.ims-online.com/index.php/2023/11/23/the-devils-advocates-vital-role-in-decision-making/
64. "AI Red-Teaming is a Sociotechnical Challenge." arXiv, 2024. https://arxiv.org/html/2412.09751v2
65. Confident AI. "LLM Red Teaming: The Complete Step-By-Step Guide." 2024. https://www.confident-ai.com/blog/red-teaming-llms-a-step-by-step-guide

### Confirmation Bias

66. "Confirmation Bias in Generative AI Chatbots: Mechanisms, Risks, Mitigation Strategies." arXiv, 2025. https://arxiv.org/abs/2504.09343

### Ethics and Disclosure

67. "The ethics of using artificial intelligence in scientific research: new guidance needed for a new tool." AI and Ethics, Springer, 2024. https://link.springer.com/article/10.1007/s43681-024-00493-8
68. EU. "First draft Code of Practice on Transparency for AI-Generated Content." 2025. https://cadeproject.org/updates/eu-publishes-first-draft-code-of-practice-on-transparency-for-ai-generated-content/
69. HHS/OHRP. "IRB Considerations on the Use of Artificial Intelligence in Human Subjects Research." https://www.hhs.gov/ohrp/sachrp-committee/recommendations/irb-considerations-use-artificial-intelligence-human-subjects-research/index.html
70. "Disclosing artificial intelligence use in scientific research and publication." Taylor & Francis, 2025. https://www.tandfonline.com/doi/full/10.1080/08989621.2025.2481949

### Limitations and "When Not To"

71. Development Corporate. "AI Market Research Limitations: What 12 Synthetic CEO Personas Reveal About the Trust Gap." 2024. https://developmentcorporate.com/synthetic-data/ai-market-research-limitations-what-12-synthetic-ceo-personas-reveal-about-the-trust-gap/
72. "The transparency dilemma: How AI disclosure erodes trust." ScienceDirect, 2025. https://www.sciencedirect.com/science/article/pii/S0749597825000172
73. Kaleb Loosbrock. "The AI Disclosure Dilemma: A UXR Guide & Drafting Tool." 2025. https://www.heykaleb.com/musings/2025/8/2/the-ai-disclosure-dilemma-how-to-tell-people-youre-using-ai-without-freaking-them-out

### Ethical Foundations

74. Agnew et al. "The Illusion of Artificial Inclusion." CHI, 2024. https://dl.acm.org/doi/10.1145/3613904.3642703
75. Lin, Z. "Six Fallacies in Substituting Large Language Models for Human Participants." Advances in Methods and Practices in Psychological Science, 2025. https://journals.sagepub.com/doi/10.1177/25152459251357566

### Foundational Studies

76. Argyle et al. "Out of One, Many: Using Language Models to Simulate Human Samples." Political Analysis, Cambridge, 2023. https://arxiv.org/abs/2209.06899
77. Park et al. "Generative Agents: Interactive Simulacra of Human Behavior." UIST/ACM, 2023. https://arxiv.org/abs/2304.03442
78. Aher, Arriaga, Kalai. "Using Large Language Models to Simulate Multiple Humans and Replicate Human Subject Studies." ICML, 2023. https://arxiv.org/abs/2208.10264
79. Horton, Filippas, Manning. "Large Language Models as Simulated Economic Agents: What Can We Learn from Homo Silicus?" NBER/ACM EC, 2023-2024. https://arxiv.org/abs/2301.07543
80. Hullman et al. "This human study did not involve human subjects: Validating LLM simulations as behavioral evidence." arXiv, 2026. https://arxiv.org/abs/2602.15785

### Social Desirability

81. "Exploring Social Desirability Response Bias in Large Language Models: Evidence from GPT-4 Simulations." arXiv, 2024. https://arxiv.org/html/2410.15442v1
82. "Large language models display human-like social desirability biases in Big Five personality surveys." PNAS Nexus, 2024. https://academic.oup.com/pnasnexus/article/3/12/pgae533/7919163

### Persona Generation

83. "Whose Personae? Synthetic Persona Experiments in LLM Research." AAAI/AIES, 2025. https://ojs.aaai.org/index.php/AIES/article/download/36553/38691/40628
84. "'I've never seen a glass ceiling better represented': Bias and gendering in LLM-generated synthetic personas." International Journal of Human-Computer Studies, 2025. https://www.sciencedirect.com/science/article/pii/S1071581925002083

### Additional Validation

85. "Position: LLM Social Simulations Are a Promising Research Method." arXiv, 2025. https://arxiv.org/html/2504.02234v2
86. "Can LLMs Truly Reflect Humanity? A Deep Dive." ICLR Blogposts, 2025. https://d2jud02ci9yv69.cloudfront.net/2025-04-28-rethinking-llm-simulation-84/blog/rethinking-llm-simulation/
87. "Should LLMs be WEIRD? Exploring WEIRDness and Human Rights in Large Language Models." arXiv, 2025. https://arxiv.org/html/2508.19269v1
88. "Temperature and Persona Shape LLM Agent Consensus With Minimal Accuracy Gains in Qualitative Coding." arXiv, 2025. https://arxiv.org/html/2507.11198
89. "LLMs Reproduce Human Purchase Intent via Semantic Similarity Elicitation of Likert Ratings." arXiv, 2025. https://arxiv.org/html/2510.08338
90. "The State of Synthetic Research in 2025." Conversion Alchemy. https://christophersilvestri.com/research-reports/state-of-synthetic-research-in-2025/

---

*This report synthesizes findings from 90 sources spanning academic papers, industry reports, and practitioner analyses from 2022-2026. All recommendations are designed for practical implementation within the Facet simulation engine.*
