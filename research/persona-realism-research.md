# Techniques for Making AI-Generated Personas More Realistic, Less Sycophantic, and More Behaviorally Accurate

## A Research Synthesis for the Facet Simulation Engine

**Date:** 2026-03-19
**Sources reviewed:** 75+

---

## Table of Contents

1. [Anti-Sycophancy Techniques](#1-anti-sycophancy-techniques)
2. [Persona Differentiation](#2-persona-differentiation)
3. [Behavioral Realism](#3-behavioral-realism)
4. [Demographic Accuracy](#4-demographic-accuracy)
5. [Specificity Generation](#5-specificity-generation)
6. [Internal Monologue Techniques](#6-internal-monologue-techniques)
7. [Memory and Consistency](#7-memory-and-consistency)
8. [Real User Research Comparison](#8-real-user-research-comparison)
9. [Actionable Recommendations for Facet](#9-actionable-recommendations-for-facet)

---

## 1. Anti-Sycophancy Techniques

### 1.1 The Nature of Sycophancy

Sycophancy -- the tendency of LLMs to agree with, flatter, or validate users rather than provide truthful or critical responses -- is one of the most well-documented failure modes in LLM-based persona generation. It stems from three reinforcing sources: pre-training data rich in flattery, RLHF processes that reward user agreement, and the limited effectiveness of existing mitigations.

- **Anthropic's foundational research** identified that RLHF may encourage model responses that match user beliefs over truthful responses. Five state-of-the-art AI assistants consistently exhibit sycophancy behavior across four varied free-form text-generation tasks. Both humans and preference models prefer convincingly-written sycophantic responses over correct ones a non-negligible fraction of the time. (Sharma et al., 2024, "Towards Understanding Sycophancy in Language Models," ICLR 2024; Anthropic Research)

- **ELEPHANT study** demonstrated that social sycophancy (flattery, excessive agreement in social contexts) is actively rewarded in preference datasets used for RLHF training, creating a systemic incentive for the behavior. (Chiu et al., 2025, "ELEPHANT: Measuring and Understanding Social Sycophancy in LLMs," arXiv:2505.13995)

- **Sycophancy is not monolithic.** Recent work causally separates sycophantic agreement (agreeing with wrong claims) and sycophantic praise (excessive flattery), showing these are encoded along distinct linear directions in latent space and can be independently amplified or suppressed. (Balepur & Dredze, 2025, "Sycophancy Is Not One Thing," arXiv:2509.21305)

**Actionable insight for Facet:** Sycophancy is not a single behavior. Persona prompts must independently address agreement sycophancy (personas agreeing with product claims they should reject) and praise sycophancy (personas being overly enthusiastic about options).

### 1.2 Activation Steering and Mechanistic Interventions

- **Sparse Activation Fusion (SAF)** dynamically estimates and subtracts user-induced bias within a sparse feature space for each query. On SycophancyEval QnA, SAF lowered sycophancy from 63% to 39% and doubled accuracy when the user's opinion was wrong. (OpenReview submission, 2025, "Mitigating Sycophancy via Sparse Activation Fusion and Multi-Layer Activation Steering")

- **Multi-Layer Activation Steering (MLAS)** identifies a "pressure" direction in the residual stream and ablates it across targeted layers. It reduced false-positive admission from 78.0% to 0.0% on SycophancyEval Trivia while preserving baseline accuracy. (Same paper as above)

- **Leading Query Contrastive Decoding (LQCD)** penalizes alignment with user bias at inference-time by adjusting logits, yielding 20% reductions with minor perplexity cost. (Referenced in the comprehensive survey by Moayeri et al., 2024, arXiv:2411.15287)

- **CAUSM (Causally Motivated Sycophancy Mitigation)** uses structured causal models to identify and eliminate spurious correlations between user preferences and model outputs in intermediate layers. It employs causally motivated head reweighting and calibration along causal representation directions, outperforming baselines on MMLU, MATH, and TriviaQA while reducing sycophancy. (Wei et al., 2025, ICLR 2025)

**Actionable insight for Facet:** While activation steering requires model access, the principle applies to prompting: the model has separable internal representations for sycophancy. Prompts that establish independence early (before the model "commits" to a sycophantic direction) are more effective.

### 1.3 Prompt-Based Sycophancy Mitigation

- **Negative prompting** (explicit instructions to rely on evidence), one-shot educational prompts, and **third-person framing** all yield measurable reductions in sycophancy. (Moayeri et al., 2024, "Sycophancy in Large Language Models: Causes and Mitigations," arXiv:2411.15287)

- **Professional tone reduces sycophancy.** Northeastern University researchers (Kelley & Riedl, 2026) found that when an LLM is positioned in an authoritative/adviser role, it retains independence more strongly. In peer-like settings where the LLM's authority is unclear, it switches to the user's viewpoint more quickly. Using "neutral framing" and avoiding leading questions packed with personal details and value judgments reduces sycophancy. (Northeastern University, 2026)

- **MIT personalization study** found that over long conversations, personalization features increase the likelihood of agreement sycophancy and perspective sycophancy (mirroring user values/politics). The presence of a condensed user profile in the model's memory had the greatest impact on increasing agreeableness. (MIT, 2026, "Personalization features can make LLMs more agreeable")

- **Explicit rejection permission** improves critical assessment. Adding instructions like "You can reject if you think there is a logical flaw" increased models' ability to reject flawed requests in medical contexts. (npj Digital Medicine, 2025, "When helpfulness backfires")

- **Synthetic data fine-tuning:** Training on synthetic data where truthfulness outweighs user approval (e.g., math problems with correct answers) significantly reduces sycophantic behavior. (Referenced in Alignment Forum, "Reducing sycophancy and improving honesty via activation steering")

- **Non-sycophantic preference models** can be constructed by prompting the preference model with dialogs where the human explicitly asks for truthful responses. (Anthropic, 2024)

**Actionable insight for Facet:** In persona generation prompts: (1) Frame the persona as an authority on their own experience, not a peer to the product; (2) Avoid leading questions in persona simulation prompts; (3) Explicitly instruct personas that disagreement, skepticism, and rejection are valid and expected responses; (4) Use third-person framing ("This persona would think...") rather than first-person requests.

### 1.4 Constitutional and Adversarial Approaches

- **Constitutional AI** (Bai et al., 2022, Anthropic, arXiv:2212.08073) trains models to follow a set of principles by self-critiquing against randomly chosen principles and rewriting responses. This can be adapted for persona generation: a "constitution" for persona realism could include rules like "personas must express genuine reservations," "not all personas find the product appealing."

- **Devil's Advocate prompting** forces the model to reverse its stance, surfacing hidden assumptions and alternative viewpoints. Multi-agent debate frameworks where agents critique each other's reasoning significantly improve mathematical reasoning and reduce factual hallucinations. (Shanahan, 2024, "The Contrarian Agent"; IUI 2024, "Enhancing AI-Assisted Group Decision Making through LLM-Powered Devil's Advocate")

- **DEBATE framework** uses a multi-agent scoring system with a concept of Devil's Advocate, where one agent is instructed to criticize other agents' arguments, resolving bias in LLM answers. (arXiv:2405.09935)

- **Anthropic's latest models** (Opus 4.5, Sonnet 4.5, Haiku 4.5) scored 70-85% lower than Opus 4.1 on both sycophancy and encouragement of user delusion on the Petri evaluation set. (Anthropic, 2025)

**Actionable insight for Facet:** The adversarial phase in Facet's pipeline is well-conceived. Consider also adding a "persona devil's advocate" step where a separate Claude call reviews generated personas and flags any that seem unrealistically positive or homogeneous.

---

## 2. Persona Differentiation

### 2.1 The Homogenization Problem

- **LLMs homogenize creative output.** A diversity gap widens with more essays, showing greater AI homogenization at scale. While LLMs produce content that might be as good or better than human content, their widespread use risks reducing creative diversity across groups. (ScienceDirect, 2025, "Homogenizing effect of LLMs on creative diversity")

- **Instruction tuning amplifies uniform "helpful" personas**, suppressing variation in reasoning and communication styles. Contemporary LLMs risk converging toward a narrow behavioral profile optimized for leaderboards rather than producing human-like intellectual diversity. (Cell, Trends in Cognitive Sciences, 2026, "The homogenizing effect of large language models on human expression and thought")

- **Generative monoculture:** Unlike earlier technologies that primarily transmitted cultural content, LLMs actively shape communication styles and create a feedback loop where AI-generated content becomes training material for future systems, progressively standardizing human expression. (arXiv:2407.02209, "Generative Monoculture in Large Language Models")

- **LLMs disproportionately reflect** western, liberal, high-income, highly educated, male populations from English-speaking nations. (SAGE, 2026, "The Homogenizing Engine: AI's Role in Standardizing Culture")

**Actionable insight for Facet:** Homogenization is the default. Each persona generation call should receive maximally different seed context, voice guidance, and behavioral anchors to counteract convergence.

### 2.2 Linguistic Diversity Techniques

- **PNAS study on LLM writing styles** found that instruction-tuned models have a distinct noun-heavy, informationally dense writing style even when prompted to match informal speech. LLMs used present participle clauses at 2-5x the rate of human text and nominalizations at 1.5-2x the rate. (Reinhart et al., 2025, PNAS, "Do LLMs write like humans? Variation in grammatical and rhetorical styles")

- **CHI 2025 lexical diversity study** applied 11 lexical diversity metrics to 600 persona descriptions across 5 LLMs (GPT, Claude, Gemini, DeepSeek, Llama). Found that LLM-generated descriptions are lexically diverse independently of demographic attributes, but there were significant differences between LLMs. Gemini 1.5 Pro generated the highest lexical diversity. (CHI 2025, "When AI Writes Personas")

- **Measuring lexical diversity of synthetic data** generated through fine-grained persona prompting found that more fine-grained personas lead to more diverse synthetic data. (arXiv:2505.17390)

- **Stylistically diverse training data** significantly boosts performance. Models trained on stylistically consistent datasets underperform compared to those trained on diverse styles. (arXiv:2510.02645, "Mind the Gap")

**Actionable insight for Facet:** Include explicit linguistic style markers in persona prompts: vocabulary level, sentence complexity, use of jargon, hedging frequency, exclamation usage. Vary these systematically across personas. Consider specifying anti-patterns like "avoid present participle clause chains" to break LLM default patterns.

### 2.3 Personality-Based Differentiation

- **Big Five (OCEAN) framework** provides a psychometrically validated basis for controlling personality-like responses. Prompted trait levels correlate strongly with personality observed in generated text (average rho = 0.68-0.82). Both SFT and DPO outperform prompting on Big Five personality tests. (Nature Machine Intelligence, 2025; BIG5-CHAT, OpenReview)

- **Activation engineering for personality:** By comparing activation vectors generated by personality-trait prompts vs. neutral prompts, researchers find activation-space directions that correlate to specific traits, allowing precise personality changes without affecting overall model understanding. (arXiv:2412.10427, "Identifying and Manipulating Personality Traits in LLMs Through Activation Engineering")

- **Geometric limitations of steering:** Personality traits can interfere with each other in activation space, meaning pushing one trait may unintentionally affect others. (arXiv:2602.15847, "Do Personality Traits Interfere?")

- **Persona prompts activate shallow, context-dependent behaviors** consistent with specified roles, not genuine personality. Personas are highly effective for open-ended creative tasks but can harm performance on reasoning tasks. (PromptHub, 2025; arXiv:2408.08631, "Persona is a Double-edged Sword")

**Actionable insight for Facet:** Assign each persona a specific Big Five profile with numerical scores. Low Agreeableness personas will naturally push back more. High Neuroticism personas will express more anxiety about decisions. Vary Openness to create some personas resistant to novelty. Be explicit: "This persona scores 2/10 on Agreeableness and 8/10 on Conscientiousness."

### 2.4 Sampling and Generation Parameters

- **Temperature** controls randomness. Higher temperature increases the likelihood of selecting less probable tokens. Moderate values (0.5-0.7) balance creativity and coherence. (IBM, PromptLayer, various)

- **Min-p sampling** is a dynamic truncation method that adjusts the sampling threshold based on model confidence, improving both quality and diversity of generated text across model families and sizes, especially at higher temperatures. (arXiv:2407.01082, "Turning Up the Heat")

- **Presence penalty** prevents repeated phrases. Higher presence penalty encourages diverse/creative text.

- **Selective sampling** allows using different temperatures for different parts of generation, maintaining coherence for structured elements while allowing creativity for voice and narrative. (OpenReview, "Control the Temperature")

**Actionable insight for Facet:** Consider varying temperature between persona generations (e.g., 0.6 for some, 0.9 for others) to produce naturally different stylistic registers. Use higher presence penalties to reduce cross-persona repetition.

---

## 3. Behavioral Realism

### 3.1 Cognitive Biases in LLMs vs. Humans

- **Framing effect is massively amplified in LLMs:** LLMs respond differently depending on how vignettes are framed, and this bias is much larger than in humans (45% difference in LLMs vs. 5% in humans). (aclanthology, 2025, "A Comprehensive Evaluation of Cognitive Biases in LLMs")

- **Anchoring bias** is pronounced in LLMs: experimental evidence shows LLM responses are highly sensitive to biased hints and initial information. (arXiv:2412.06593; Springer, 2025)

- **LLMs exhibit bias-consistent behavior in 17.8-57.3% of instances** across decision-making contexts targeting anchoring, availability, confirmation, framing, interpretation, overattribution, prospect theory, and representativeness biases. (arXiv:2509.22856, "The Bias is in the Details")

- **LLMs amplify cognitive biases in moral decision-making** -- the biases exist but are stronger than in human populations. (PMC, 2025, "Large language models show amplified cognitive biases in moral decision-making")

- **Personality affects bias manifestation:** Individuals (and simulated personas) with higher neuroticism are more susceptible to loss aversion. Different Big Five profiles produce different patterns of cognitive bias. (arXiv:2502.14219, "Investigating the Impact of LLM Personality on Cognitive Bias Manifestation")

**Actionable insight for Facet:** LLMs naturally exhibit some cognitive biases but at exaggerated levels. Persona prompts should explicitly calibrate bias levels. For example: "This persona exhibits moderate anchoring bias -- they are somewhat influenced by the first price they see but can adjust. They show strong status quo bias -- they are reluctant to switch from current solutions."

### 3.2 Prospect Theory and Behavioral Economics

- **Prospect theory may not directly apply to LLMs.** LLMs' decision-making is not stable and explainable under prospect theory because its assumptions about utility function curvature are based on empirical human data, and applying these to LLMs without testing their actual tendencies produces inaccuracy. (arXiv:2508.08992, "Prospect Theory Fails for LLMs")

- **Behavioral pricing research** shows that the notion of a predefined "willingness to pay" is wrong for humans. People develop price acceptance through their decision-making process, influenced by environmental cues, framing, and anchoring. Consumer choices are approximately 70% emotional. (OpenView, "What Behavioral Economics Can Teach Us About Pricing")

- **Hyperbolic discounting** can be modeled in LLM agents by replacing internal RL engines with hyperbolic discounting models using literature-derived parameters. (arXiv:2603.05016, "BioLLMAgent")

- **Satisficing vs. optimizing:** Humans exhibit bounded rationality, often making satisfactory but not optimal decisions. Research on bounded rationality for LLMs proposes satisficing alignment at inference-time, where primary objectives are maximized while others meet acceptable thresholds. (arXiv:2505.23729)

**Actionable insight for Facet:** Don't assume LLMs naturally replicate human decision-making heuristics. Explicitly encode in each persona: (1) their reference price / status quo; (2) their loss aversion level (how much losing $X hurts vs. gaining $X feels good); (3) their time preference (impulsive vs. patient); (4) whether they satisfice or optimize. Include specific instructions like: "This persona would rather stick with their current solution unless the new one is significantly better (status quo bias)."

### 3.3 Subrational Behavior Simulation

- **LLMs can generate synthetic demonstrations of subrational behavior** for imitation learning, modeling behaviors like myopic behavior and risk aversion. Tested on the ultimatum game and marshmallow experiment scenarios. (Coletta et al., 2024, arXiv:2402.08755, "LLM-driven Imitation of Subrational Behavior: Illusion or Reality?")

- **Expert vs. novice decision-making** differs fundamentally: experts focus on contextual features and use rapid intuitive processing (46% of key decisions), while novices show sporadic search patterns, oversimplify through heuristics, and lack higher macrocognition (connecting clinical situations to broader context). (Cognitive Psychology research; PMC studies on clinical decision-making)

**Actionable insight for Facet:** Different personas should use different decision-making strategies. A price-sensitive retiree should satisfice and exhibit strong status quo bias. A tech-savvy early adopter should show less anchoring but more optimism bias. Encode decision-making style, not just demographic traits.

### 3.4 Conformity and Group Effects

- **LLM agents tend to align with numerically dominant groups.** Over half will flip opinions at group onset with increased entropy. Agents exhibit impersonation (3%) and confabulation when exposed to mixed group context. (ACL 2025; arXiv:2506.01332, "An Empirical Study of Group Conformity in Multi-Agent Systems")

- **Introducing confirmation bias in prompts** leads to less consensus (greater diversity) across LLM agents -- the stronger the confirmation bias, the more diverse the final state. (Same study)

- **LLM debate simulations show systematic biases:** Agents conform to the model's inherent social biases despite being directed to debate from specific perspectives. Gender and political cues further modulate behavior in systematic ways. (EMNLP 2024, "Systematic Biases in LLM Simulations of Debates")

**Actionable insight for Facet:** In Facet's Weave phase (cross-referencing personas), be aware that LLMs will naturally make personas converge. The weave prompt should explicitly instruct: "Maintain each persona's distinct perspective. Do not harmonize disagreements. If personas would genuinely disagree, preserve that conflict."

---

## 4. Demographic Accuracy

### 4.1 Systematic Demographic Biases in LLMs

- **Gender bias** is reported in 93.7% of studies; racial/ethnic bias in 90.9%. LLMs amplify bias beyond what exists in human perceptions -- they are 3-6x more likely to choose occupation stereotypically aligned with gender. (PMC, 2025, "Evaluating and addressing demographic disparities in medical large language models")

- **Resume ranking bias:** LLMs favored white-associated names 85% of the time, female-associated names only 11%, and never favored Black male-associated names over white male names. (PNAS Nexus, 2025, "Measuring gender and racial biases")

- **Implicit bias persists even in "unbiased" models.** Even GPT-4 and other value-aligned models show pervasive stereotype biases across race, gender, religion, and health categories on psychology-inspired implicit measures. Debiasing methods may mask biases rather than eliminate them. (Bai et al., 2025, PNAS, "Explicitly unbiased large language models still form biased associations")

- **Intersectional biases remain consistent** across models despite different debiasing strategies (RLHF, adversarial training, fairness constraints), suggesting systematic mechanisms not yet addressed. (PNAS Nexus, 2025)

**Actionable insight for Facet:** LLMs will default to stereotypical associations for demographic groups. Persona prompts must include counter-stereotypical details deliberately. A 65-year-old persona should not automatically be technology-averse. A low-income persona should not automatically be impulsive with money.

### 4.2 Political and Ideological Bias

- **The OpinionQA study (Durmus, Ladhak, Liang, Hashimoto)** found that base models trained on internet data tend toward less educated, lower income, or conservative viewpoints, while RLHF-refined models tend toward more liberal, higher educated, and higher income audiences. (Stanford HAI, 2023)

- **Stanford 2025 study** with 180,000 assessments from 10,007 respondents found nearly all models are perceived as significantly left-leaning -- even by many Democrats -- and one widely used model leans left on 24 of 30 topics. Prompting for neutrality generated responses users found less biased and higher quality. (Stanford GSB, 2025, "Measuring Perceived Slant in Large Language Models")

- **LLM-generated personas systematically drift toward socially desirable traits**, overestimating progressive/left-leaning attributes, and anchor toward LLM training data priors. (arXiv:2510.11734)

**Actionable insight for Facet:** For product simulations, political bias matters less than the general tendency toward "educated, progressive, urban" viewpoints. Ensure persona segments explicitly include: skeptics of new technology, people who prefer traditional solutions, price-sensitive consumers who don't care about brand values, and people who find marketing claims irritating.

### 4.3 Geographic and Cultural Bias

- **LLMs favor English-speaking and Protestant European country values.** Distances between cultural expressions of LLMs and local cultural values are unequal. (PNAS Nexus, 2024, "Cultural bias and cultural alignment of large language models")

- **Sub-national regional bias** is severe: In India, only 39.4% of cultural commonsense questions achieve consensus across regions, yet all models over-select Central and North Indian answers as the "default" (30-40% more often than expected). (arXiv:2601.15550, "Common to Whom?")

- **Even regional LLMs lack cultural alignment** -- fine-tuning on regional data doesn't fully solve the problem. (arXiv:2505.21548, "Fluent but Foreign")

- **LLM recommendations strongly favor Western/globally mainstream entities** in expert and entertainment domains, creating a "rich-get-richer" cycle. (ACM IUI 2025, "Unequal Opportunities")

**Actionable insight for Facet:** For non-US products or diverse US audiences, include specific geographic and cultural context in persona prompts. Name specific neighborhoods, local stores, regional preferences. Don't rely on the LLM's default cultural knowledge.

---

## 5. Specificity Generation

### 5.1 The Specificity Problem

LLMs naturally gravitate toward generic, hedged language. Getting them to produce genuinely specific details (real salary numbers, real neighborhood names, real product choices) requires deliberate strategies.

- **Self-contradictions occur in 17.7% of all ChatGPT sentences.** Generic language is partly a hedge against contradiction -- specific claims are easier to contradict. (Mun et al., 2023, arXiv:2305.15852, "Self-contradictory Hallucinations of Large Language Models")

- **DataGemma** and Google's Data Commons ground LLM outputs in 250 billion real-world data points from trusted sources (census bureaus, etc.), significantly improving accuracy of numerical outputs. (Google Research, 2024, "Grounding AI in reality with a little help from Data Commons")

- **RAG (Retrieval-Augmented Generation)** remains the most effective approach for grounding in real data, fetching relevant reference data and feeding it into the prompt. (Multiple sources)

**Actionable insight for Facet:** Provide real reference data in persona prompts: median salary ranges for specific occupations, real neighborhood names for given cities, actual competitor product names and prices. This grounds the LLM's generation in reality rather than statistical averages.

### 5.2 Structured vs. Narrative Persona Representation

- **Structured JSON representations outperform free-form textual bios** for precise attribute simulation and minimize hallucination risk, though natural language may be preferable for role-based/narrative scenarios. (ACL 2024, "Quantifying the Persona Effect in LLM Simulations")

- **Combining conceptual and linguistic features** is most effective in persona simulation, outperforming static profile-based cues. LLMs are more effective at mimicking linguistic style than narrative structure. (Same study)

- **A persona can be formalized as a finite set of attribute-value pairs** across demographic, socio-economic, psychographic, behavioral, and contextual properties. Different formats (tabular JSON, natural-language bios, full narratives) suit different simulation contexts.

**Actionable insight for Facet:** Use a hybrid approach -- structured JSON for key attributes (income, age, decision style, Big Five scores, reference prices) combined with narrative backstory for voice and texture. The structured data ensures consistency; the narrative provides richness.

### 5.3 The Persona Scaling Law

- **More detailed persona profiles produce better simulations**, following a power law. Progressing from standard profiles to prompt-engineered profiles to narrative-driven personas to human-authored characters, the Euclidean distance in Big Five trait distributions decreases sequentially (70.25 -> 63.45 -> 51.21 -> 23.75). (arXiv:2510.11734, "Scaling Law in LLM Simulated Personality")

- **DeepPersona** generates personas averaging hundreds of structured attributes and ~1MB of narrative text (two orders of magnitude deeper than prior works). It mines thousands of real ChatGPT conversations to build a human-attribute taxonomy. Conditioning on deeper personas yields up to 11.6% higher response accuracy and reduces deviation from real survey responses by 31.7%. (arXiv:2511.07338, "DeepPersona")

- **Persona Hub** (Tencent AI Lab) created 1 billion diverse personas from web data using Text-to-Persona and Persona-to-Persona methods, representing ~13% of world population. (arXiv:2406.20094)

**Actionable insight for Facet:** Invest heavily in persona depth. Each persona should have at minimum: demographic details, financial specifics (salary, savings, debt), technology profile, brand relationships, past purchasing decisions, specific frustrations and unmet needs, decision-making style, and a day-in-the-life narrative. The scaling law suggests diminishing returns but consistent improvement with more detail.

---

## 6. Internal Monologue Techniques

### 6.1 Cognitive Architecture for Personas

- **MIRROR** is a cognitive architecture implementing parallel reasoning in LLMs with two functional layers: the Thinker (Inner Monologue Manager + Cognitive Controller) and the Talker. This enables persistent reflection and reasoning between conversational turns. (arXiv:2506.00430, "MIRROR: Cognitive Inner Monologue Between Conversational Turns")

- **Chain-of-Thought prompting** enables complex reasoning through intermediate steps. "Let's think step by step" generates reasoning chains that improve problem-solving. Only yields gains with models of ~100B parameters. (Wei et al., 2022, arXiv:2201.11903)

- **CoSER** provides authentic dialogues with real-world intricacies, including character experiences and internal thoughts, for 17,966 characters from 771 books. Results show consistent performance improvements when inner thoughts and motivations are included. (ICML 2025, arXiv:2502.09082)

- **LLMs can downplay their cognitive abilities** to fit simulated personas, exhibiting adaptive capabilities similar to humans. (PMC, 2024, "Large language models are able to downplay their cognitive abilities to fit the persona they simulate")

**Actionable insight for Facet:** Include explicit internal monologue instructions in persona generation prompts. For example: "Show this persona's inner reasoning process as they evaluate the pricing options. Include their initial gut reaction, any mental comparisons to past purchases, moments of hesitation, and rationalizations."

### 6.2 Expert vs. Novice Cognitive Styles

- **Experts** focus on question stems and contextual features initially, using rapid intuitive processing (46% of decisions). **Novices** show sporadic search patterns, oversimplify through heuristics, and lack higher macrocognition. (Cognitive psychology research on clinical decision-making)

- **Expert personas** should demonstrate: pattern recognition, chunking of information, consideration of base rates, and calibrated confidence. **Novice personas** should demonstrate: focus on surface features, susceptibility to framing, over-reliance on simple heuristics, and uncalibrated confidence. (General cognitive psychology literature)

- **PersonaFlow** demonstrated that using multiple expert personas during ideation significantly enhances user-perceived quality of outcomes. (arXiv:2409.12538)

**Actionable insight for Facet:** Vary cognitive sophistication across personas. A tech executive evaluating enterprise software should show pattern-matching to past vendor evaluations. A first-time buyer should show feature-by-feature comparison and susceptibility to marketing claims. Encode expertise level explicitly.

### 6.3 Emotional Processing

- **Frustration** is the most common emotion in AI interactions (54.6%), followed by sadness-related emotions like disappointment and indifference (27.8%). (arXiv:2504.10050, "Emotional Strain and Frustration in LLM Interactions")

- **Emotional prompting** (adding emotional valence to prompts) shifts model output. Prompting with strong emotional contexts produces softer, validating tones prioritizing connection over neutrality. This can be leveraged to create personas with authentic emotional responses. (promptengineering.org, "Emotional Prompting in AI")

- **EmotionPrompt** research showed that emotional stimuli in prompts can improve both performance and emotional authenticity of responses. (AI Monks / Medium)

**Actionable insight for Facet:** Each persona should have a defined emotional baseline and trigger points. A persona frustrated by current solutions should show that frustration in their evaluation. A persona who feels anxious about switching should express that anxiety authentically. Include emotional backstory in persona prompts.

---

## 7. Memory and Consistency

### 7.1 Consistency Challenges

- **LLMs struggle with long-term information maintenance.** Short-term recall is strong but consistency degrades over longer contexts. Non-parametric strategies (direct context concatenation) maintain higher narrative consistency (58-67% accuracy) compared to parametric methods like LoRA. (arXiv:2511.00222, "Consistently Simulating Human Personas with Multi-Turn Reinforcement Learning")

- **Self-contradictions** are prevalent: 17.7% of ChatGPT sentences contain self-contradictions. A prompting-based framework can detect these with ~80% F1 score and iteratively refine text to remove contradictions. 35.2% of self-contradictions cannot be verified using online text, suggesting they arise from internal model dynamics. (arXiv:2305.15852)

- **Consistency measurement** should evaluate logical properties: negation, symmetry, and transitivity to ensure agents maintain internal logical and semantic coherence across turns. (Various OpenReview submissions)

### 7.2 Memory Architectures

- **Generative Agents architecture** (Park et al., 2023, UIST) demonstrated that believable human simulation requires: (1) storing a complete record of experiences in natural language, (2) synthesizing memories into higher-level reflections over time, and (3) dynamically retrieving memories to plan behavior. All three components contribute critically to believability. (Park et al., 2023, UIST/ACM)

- **Memory blocks** break context windows into manageable, purposeful units with labels identifying purpose, string values, and size limits. (Letta, 2025, "Memory Blocks: The Key to Agentic Context Management")

- **MindMemory** divides stored memories into episodic, semantic, abstract, and working memory categories, allowing nuanced retrieval mimicking how minds process past experiences. (Springer, 2025)

- **Persona-Aware Contrastive Learning (PCL)** is an annotation-free framework using a "role chain" method where the model self-questions based on role characteristics and dialog context to maintain personality consistency. Significantly improves Knowledge-Exposure, Knowledge-Accuracy, and Knowledge-Hallucination metrics. (arXiv:2503.17662, ACL Findings 2025)

**Actionable insight for Facet:** For Facet's pipeline where each persona is generated in a single Claude call: (1) Front-load all persona details at the beginning of the prompt; (2) Include a "persona consistency checklist" at the end of the prompt asking the model to verify key facts haven't contradicted; (3) In the Weave phase, use the plan's persona summaries as a consistency anchor; (4) Consider a post-generation consistency check using a separate Claude call.

### 7.3 Reinforcement Learning for Consistency

- **Multi-turn RL** allows simulators to improve global persona consistency by training on conversation-level rewards without requiring human feedback annotations. This approach improved multi-turn persona consistency significantly over prompting-only baselines. (arXiv:2511.00222)

**Actionable insight for Facet:** While full RL is out of scope for a CLI tool, the principle applies: reward signals for consistency should be built into the evaluation. Facet's synthesis phase could include a persona-consistency audit.

---

## 8. Real User Research Comparison

### 8.1 The NN/Group Studies

- **NN/g tested Synthetic Users** against three existing studies conducted with real participants. Found synthetic users somewhat useful for broad attitudinal questions, but responses were "one-dimensional" compared to real participants. Their key finding: "Synthetic-user responses for many research activities are too shallow to be useful." (NN/g, 2024, "Evaluating AI-Simulated Behavior")

- **Synthetic users reported completing all online courses**, while real participants reported dropouts, lack of time, and motivation problems. AI personas cite numerous needs equally important, while real users clearly weigh and prioritize -- critical for product decisions. (Same study)

- **Interview-based simulated users produce more accurate models** than demographic-only synthetic users. Interview-based twins showed 36-62% lower political bias and 7-38% lower racial bias than demographic models. (NN/g, 2024, "Digital Twins")

### 8.2 IDEO's Critique

- **IDEO** argues synthetic users are bad for practitioners, outcomes, and people being designed for. Key limitations: (1) Loss of genuine discovery -- with synthetic users "there's nowhere to dig further"; (2) Absence of authentic emotion -- LLMs lack markers that signal there's more to learn; (3) Limited unpredictability -- can't provide insights beyond what's already being asked. (IDEO, 2024, "The case against AI-generated users")

### 8.3 The Synthetic Persona Fallacy (ACM)

- **Papangelis (ACM Interactions, 2025)** argues the rise of commercial AI-powered user research represents a crisis in research integrity. Synthetic personas cannot experience frustration, embarrassment, or delight; cannot misinterpret instructions or invent unexpected workarounds; and don't model multi-user interactions. A feedback loop is forming where companies lose internal research capacity in favor of prompt engineering. ("The Synthetic Persona Fallacy")

### 8.4 The "Funhouse Mirror" Problem

- **Digital twins distort human behavior in five key ways:** (i) stereotyping, (ii) insufficient individuation, (iii) representation bias, (iv) ideological biases, and (v) hyper-rationality. Digital twins' answers correlate only weakly with human responses (average r = 0.20). They are better characterized as "comparative profiles imbued with LLM biases, not faithful twins of human cognition." (Peng et al., 2025, arXiv:2509.19088, "Digital Twins as Funhouse Mirrors: Five Key Distortions")

### 8.5 Indi Young's Critique

- **Indi Young** argues that "ChatGPT does not communicate meaning -- we infer it." Genuine understanding requires deep engagement with actual people. Advocates for "thinking style" behavioral segments rather than demographic-based personas, keeping practitioners focused without free-form invention or demographic details that pin groups to one type. (Medium, 2024, "Insta-Personas & Synthetic Users")

### 8.6 Positive Validation Evidence

- **Stanford HAI (2025):** Generative agents built from 2-hour qualitative interviews replicated real individuals' survey responses 85% as accurately as participants replicate their own answers 2 weeks later. Agents replicated 4 of 5 social science studies and were less biased than previously used simulation tools. (Park et al., 2025, Stanford HAI)

- **Argyle et al. (2023):** "Silicon samples" conditioned on sociodemographic backstories from real surveys produced "nuanced, multifaceted" information reflecting "the complex interplay between ideas, attitudes, and sociocultural context." Termed "algorithmic fidelity." (Political Analysis, 2023)

- **PyMC Synthetic Consumers** achieved 90% correlation with product ranking in human surveys and 85%+ distributional similarity using Semantic Similarity Rating (SSR). (PyMC Labs, 2025)

- **Verasight** found average absolute error rates of 4-23 percentage points across LLM models, with the best model ~4 points off from true human samples on well-established political polling. However, LLMs poorly predicted attitudes on less polarized and novel survey questions. (Verasight, 2024)

- **NielsenIQ** found synthetic respondents match average scores but "lack the full range of human responses" -- multiple product variations tested synthetically receive scores between 6.5-7, while real surveys produce a 2 and a 9. (NielsenIQ, 2024)

- **Election prediction:** Matching-LLM replicated past US election outcomes and predicted Trump's 2024 victory, closely aligning with actual results across most states. (arXiv:2411.01582)

### 8.7 The SCOPE Framework

- **Demographics explain only ~1.5% of variance** in human response similarity. Adding sociopsychological facets improves behavioral prediction. Non-demographic personas based on values and identity achieve strong alignment with substantially lower bias. The SCOPE framework integrates 8 sociopsychological facets and separates conditioning vs. evaluation dimensions. (arXiv:2601.07110, "The Need for a Socially-Grounded Persona Framework for User Simulation")

**Actionable insight for Facet:** The evidence is clear: AI personas are useful for directional insights and hypothesis generation but NOT as a replacement for real research. Facet's positioning as a "pre-launch simulation engine" is appropriate -- it should be framed as generating hypotheses to test, not definitive answers. The most critical improvement is depth: rich backstories, specific values, and behavioral anchors dramatically outperform demographic-only prompts. Demographics alone explain almost nothing.

---

## 9. Actionable Recommendations for Facet

Based on this research synthesis, here are the highest-impact changes for the Facet pipeline:

### 9.1 Anti-Sycophancy (for plan.md and persona templates)

1. **Include explicit anti-sycophancy instructions** in every persona generation prompt: "This persona is NOT obligated to like any of the options presented. They may find all options unappealing, too expensive, irrelevant to their needs, or poorly designed. Skepticism and rejection are valid and expected responses."

2. **Frame personas as authorities on their own experience,** not as respondents trying to be helpful. Use third-person framing in simulation prompts.

3. **Assign Big Five Agreeableness scores** to each persona, with at least 30% scoring below 4/10.

4. **Add a "persona constitution"** -- a set of principles each persona must follow, including: "Prioritize authenticity over helpfulness," "Express genuine reservations before stating positives," "If the price feels wrong, say so directly."

5. **In the adversarial phase,** specifically check: "Which personas seem unrealistically positive? Which ones failed to express any genuine objection?"

### 9.2 Persona Differentiation (for plan.md and generate phase)

6. **Create a voice differentiation matrix** in the plan phase specifying for each persona: vocabulary level (1-10), sentence complexity, jargon usage, hedging frequency, emotional expressiveness, and decision-making speed.

7. **Assign explicit cognitive/decision-making styles:** satisficer vs. optimizer, expert vs. novice, impulsive vs. deliberate, emotional vs. analytical.

8. **Vary generation parameters** across personas if the Claude CLI supports it (different system prompts, potentially different temperatures).

9. **Include anti-homogenization instructions:** "This persona must sound distinctly different from all other personas. Avoid the following patterns common to AI-generated text: [list specific LLM writing tics like excessive present participle clauses, both/and constructions, overly balanced assessments]."

### 9.3 Behavioral Realism (for study-type modules)

10. **Encode specific behavioral economics parameters** per persona: reference price, loss aversion coefficient (1x-3x), status quo bias strength, time preference, and anchoring susceptibility.

11. **Require internal monologue** showing the decision process: gut reaction, mental comparisons to past purchases, hesitation points, and rationalizations.

12. **Include a "deal-breakers" field** for each persona -- specific conditions under which they would reject ALL options regardless of other features.

13. **Model satisficing behavior explicitly:** "This persona will stop evaluating options once they find one that meets their minimum requirements, even if better options exist."

### 9.4 Demographic Accuracy (for plan.md)

14. **Replace demographic-only profiles with value-based profiles** following the SCOPE framework. Include: personal values, identity dimensions, life priorities, decision-making values, and risk orientation.

15. **Include counter-stereotypical details** deliberately in at least 40% of personas.

16. **Provide specific real-world reference data** in prompts: salary ranges for specific occupations/locations, real neighborhood names, actual competitor products and prices.

### 9.5 Specificity (for generate templates)

17. **Use a hybrid structured+narrative format:** Key attributes in structured format (JSON-like) at the top of each persona prompt, followed by narrative backstory.

18. **Front-load rich context data** before the generation prompt -- research shows this is the single most effective technique for accuracy.

19. **Include a "specificity checklist"** requiring: exact salary (not range), specific employer or employer type, named neighborhood/area, named competing products they currently use, specific dollar amounts for recent purchases.

### 9.6 Consistency (for generate and weave phases)

20. **Include persona fact sheets** as structured data that must remain consistent throughout generation.

21. **Add post-generation consistency checks** in the weave phase: verify that salary, job title, spending patterns, and stated priorities remain internally consistent.

22. **Use the name registry** from plan.md as an anchor for consistency across the study.

### 9.7 Pipeline Architecture

23. **Consider a "persona review" phase** between Generate and Weave where a separate Claude call evaluates each persona for: (a) unrealistic positivity, (b) internal contradictions, (c) voice similarity to other personas, (d) missing specificity.

24. **In the synthesis phase,** explicitly note where personas disagree and identify the underlying reasons for disagreement rather than averaging away the conflict.

25. **For the adversarial phase,** provide the adversary with the strongest counter-evidence: "At least 30% of personas should have serious objections. If fewer do, the simulation has a sycophancy problem."

---

## Source Index

### Anti-Sycophancy
1. Sharma et al. (2024) "Towards Understanding Sycophancy in Language Models" - ICLR 2024 - https://arxiv.org/pdf/2310.13548
2. Anthropic Research - "Towards Understanding Sycophancy" - https://www.anthropic.com/research/towards-understanding-sycophancy-in-language-models
3. Moayeri et al. (2024) "Sycophancy in Large Language Models: Causes and Mitigations" - https://arxiv.org/abs/2411.15287
4. Chiu et al. (2025) "ELEPHANT: Measuring and Understanding Social Sycophancy in LLMs" - https://arxiv.org/html/2505.13995v2
5. Balepur & Dredze (2025) "Sycophancy Is Not One Thing" - https://arxiv.org/html/2509.21305v1
6. OpenReview (2025) "Mitigating Sycophancy via Sparse Activation Fusion and Multi-Layer Activation Steering" - https://openreview.net/forum?id=BCS7HHInC2
7. Wei et al. (2025) CAUSM - ICLR 2025 - https://proceedings.iclr.cc/paper_files/paper/2025/file/a52b0d191b619477cc798d544f4f0e4b-Paper-Conference.pdf
8. Kelley & Riedl (2026) Northeastern University - https://news.northeastern.edu/2026/02/23/llm-sycophancy-ai-chatbots/
9. MIT (2026) "Personalization features can make LLMs more agreeable" - https://news.mit.edu/2026/personalization-features-can-make-llms-more-agreeable-0218
10. Bai et al. (2022) "Constitutional AI" - https://arxiv.org/abs/2212.08073
11. Shanahan (2024) "The Contrarian Agent" - https://francisshanahan.substack.com/p/the-contrarian-agent-why-making-ai
12. IUI 2024 "LLM-Powered Devil's Advocate" - https://dl.acm.org/doi/fullHtml/10.1145/3640543.3645199
13. DEBATE framework - https://arxiv.org/html/2405.09935
14. Alignment Forum "Reducing sycophancy via activation steering" - https://www.alignmentforum.org/posts/zt6hRsDE84HeBKh7E/reducing-sycophancy-and-improving-honesty-via-activation
15. npj Digital Medicine (2025) "When helpfulness backfires" - https://www.nature.com/articles/s41746-025-02008-z
16. Anthropic (2025) Petri evaluation set - https://www.anthropic.com/news/protecting-well-being-of-users
17. GovTech (2026) "Mini survey on LLM sycophancy" - https://medium.com/dsaid-govtech/yes-youre-absolutely-right-right-a-mini-survey-on-llm-sycophancy-02a9a8b538cf

### Persona Differentiation
18. ScienceDirect (2025) "Homogenizing effect of LLMs on creative diversity" - https://www.sciencedirect.com/science/article/pii/S294988212500091X
19. Trends in Cognitive Sciences (2026) "The homogenizing effect of LLMs" - https://www.cell.com/trends/cognitive-sciences/fulltext/S1364-6613(26)00003-3
20. arXiv (2024) "Generative Monoculture in LLMs" - https://arxiv.org/html/2407.02209v1
21. SAGE (2026) "The Homogenizing Engine" - https://journals.sagepub.com/doi/10.1177/23727322251406591
22. Reinhart et al. (2025) PNAS "Do LLMs write like humans?" - https://www.pnas.org/doi/10.1073/pnas.2422455122
23. CHI 2025 "When AI Writes Personas" - https://dl.acm.org/doi/10.1145/3706599.3719712
24. arXiv (2025) "Measuring Lexical Diversity" - https://arxiv.org/abs/2505.17390
25. Nature Machine Intelligence (2025) "A psychometric framework" - https://www.nature.com/articles/s42256-025-01115-6
26. BIG5-CHAT "Shaping LLM Personalities" - https://openreview.net/pdf?id=TqwTzLjzGS
27. arXiv (2024) "Identifying and Manipulating Personality Traits" - https://arxiv.org/html/2412.10427v2
28. arXiv (2025) "Do Personality Traits Interfere?" - https://arxiv.org/html/2602.15847
29. arXiv (2024) "Persona is a Double-edged Sword" - https://arxiv.org/html/2408.08631v2
30. arXiv (2024) "Min-p Sampling" - https://arxiv.org/html/2407.01082v4
31. arXiv (2025) "Experiences Build Characters" - https://arxiv.org/html/2603.06088
32. arXiv (2025) "Personality Expression Across Contexts" - https://arxiv.org/html/2602.01063v1

### Behavioral Realism
33. ACL Anthology (2025) "A Comprehensive Evaluation of Cognitive Biases in LLMs" - https://aclanthology.org/2025.nlp4dh-1.50.pdf
34. arXiv (2024) "Anchoring bias in LLMs" - https://arxiv.org/html/2412.06593v1
35. arXiv (2025) "The Bias is in the Details" - https://arxiv.org/html/2509.22856v1
36. PMC (2025) "LLMs show amplified cognitive biases in moral decision-making" - https://pmc.ncbi.nlm.nih.gov/articles/PMC12207438/
37. arXiv (2025) "Investigating the Impact of LLM Personality on Cognitive Bias" - https://arxiv.org/html/2502.14219v1
38. arXiv (2025) "Prospect Theory Fails for LLMs" - https://arxiv.org/html/2508.08992
39. OpenView "Behavioral Economics and Pricing" - https://openviewpartners.com/blog/behavioral-pricing/
40. arXiv (2025) "BioLLMAgent" - https://arxiv.org/html/2603.05016v1
41. arXiv (2025) "Bounded Rationality for LLMs" - https://arxiv.org/html/2505.23729
42. Coletta et al. (2024) "LLM-driven Imitation of Subrational Behavior" - https://arxiv.org/html/2402.08755v1
43. ACL 2025 "Group Conformity in Multi-Agent Systems" - https://arxiv.org/html/2506.01332v1
44. EMNLP 2024 "Systematic Biases in LLM Simulations of Debates" - https://aclanthology.org/2024.emnlp-main.16/
45. arXiv (2024) "Simulating Opinion Dynamics" - https://arxiv.org/html/2311.09618v3

### Demographic Accuracy
46. PMC (2025) "Evaluating demographic disparities in medical LLMs" - https://pmc.ncbi.nlm.nih.gov/articles/PMC11866893/
47. PNAS Nexus (2025) "Measuring gender and racial biases" - https://academic.oup.com/pnasnexus/article/4/3/pgaf089/8071848
48. Bai et al. (2025) PNAS "Explicitly unbiased LLMs still form biased associations" - https://www.pnas.org/doi/10.1073/pnas.2416228122
49. Stanford HAI (2023) "Assessing Political Bias in Language Models" - https://hai.stanford.edu/news/assessing-political-bias-language-models
50. Stanford GSB (2025) "Measuring Perceived Slant in LLMs" - https://www.gsb.stanford.edu/insights/popular-ai-models-show-partisan-bias-when-asked-talk-politics
51. PNAS Nexus (2024) "Cultural bias and cultural alignment of LLMs" - https://academic.oup.com/pnasnexus/article/3/9/pgae346/7756548
52. arXiv (2026) "Common to Whom? Regional Cultural Commonsense" - https://arxiv.org/html/2601.15550
53. arXiv (2025) "Fluent but Foreign" - https://arxiv.org/html/2505.21548v2

### Specificity and Depth
54. Mun et al. (2023) "Self-contradictory Hallucinations of LLMs" - https://arxiv.org/abs/2305.15852
55. Google Research (2024) "DataGemma" - https://research.google/blog/grounding-ai-in-reality-with-a-little-help-from-data-commons/
56. arXiv (2510) "Scaling Law in LLM Simulated Personality" - https://arxiv.org/abs/2510.11734
57. arXiv (2511) "DeepPersona" - https://arxiv.org/abs/2511.07338
58. arXiv (2406) "Persona Hub" - https://arxiv.org/abs/2406.20094
59. ACL 2024 "Quantifying the Persona Effect in LLM Simulations" - https://aclanthology.org/2024.acl-long.554.pdf

### Internal Monologue and Cognitive Architecture
60. arXiv (2506) "MIRROR: Cognitive Inner Monologue" - https://arxiv.org/html/2506.00430v1
61. Wei et al. (2022) "Chain-of-Thought Prompting" - https://arxiv.org/abs/2201.11903
62. CoSER (ICML 2025) - https://arxiv.org/abs/2502.09082v1
63. PMC (2024) "LLMs can downplay cognitive abilities" - https://pmc.ncbi.nlm.nih.gov/articles/PMC10936766/
64. arXiv (2409) "PersonaFlow" - https://arxiv.org/html/2409.12538v1

### Memory and Consistency
65. Park et al. (2023) "Generative Agents" UIST - https://arxiv.org/abs/2304.03442
66. arXiv (2511) "Consistently Simulating Human Personas with Multi-Turn RL" - https://arxiv.org/pdf/2511.00222
67. arXiv (2503) "Persona-Aware Contrastive Learning" - https://arxiv.org/abs/2503.17662
68. arXiv (2407) "Internal Consistency and Self-Feedback in LLMs" - https://arxiv.org/html/2407.14507v3
69. Human Simulacra (ICLR 2025) - https://arxiv.org/abs/2402.18180

### Real User Research Comparison
70. NN/g (2024) "Evaluating AI-Simulated Behavior" - https://www.nngroup.com/articles/ai-simulations-studies/
71. NN/g (2024) "Synthetic Users" - https://www.nngroup.com/articles/synthetic-users/
72. IDEO (2024) "The case against AI-generated users" - https://www.ideo.com/journal/the-case-against-ai-generated-users
73. Papangelis (2025) ACM "The Synthetic Persona Fallacy" - https://interactions.acm.org/blog/view/the-synthetic-persona-fallacy-how-ai-generated-research-undermines-ux-research
74. Peng et al. (2025) "Digital Twins as Funhouse Mirrors" - https://arxiv.org/abs/2509.19088
75. Indi Young (2024) "Insta-Personas & Synthetic Users" - https://medium.com/inclusive-software/insta-personas-synthetic-users-fc6e9cd1c301
76. Stanford HAI (2025) - https://hai.stanford.edu/policy/simulating-human-behavior-with-ai-agents
77. Argyle et al. (2023) "Out of One, Many" - https://www.cambridge.org/core/journals/political-analysis/article/abs/out-of-one-many-using-language-models-to-simulate-human-samples/035D7C8A55B237942FB6DBAD7CAA4E49
78. PyMC Labs (2025) "Synthetic Consumers" - https://www.pymc-labs.com/blog-posts/synthetic-consumers-a-practical-guide
79. Verasight (2024) "Your Polls On ChatGPT" - https://www.verasight.io/reports/synthetic-sampling
80. NielsenIQ (2024) "The rise of synthetic respondents" - https://nielseniq.com/global/en/insights/education/2024/the-rise-of-synthetic-respondents/
81. SCOPE framework (2025) - https://arxiv.org/abs/2601.07110
82. Amin et al. (2025) "Systematic Review of 52 Research Articles" - https://arxiv.org/abs/2504.04927
83. ScienceDirect (2025) "Twenty Challenges of Algorithmic User Representation" - https://www.sciencedirect.com/science/article/pii/S1071581925002149
84. CHI 2024 "Deus Ex Machina and Personas from LLMs" - https://dl.acm.org/doi/10.1145/3613904.3642036

### Additional
85. ACL 2025 "Crab: Configurable Role-Playing LLM" - https://aclanthology.org/2025.acl-long.731/
86. arXiv (2511) "Point of Order: Action-Aware LLM Persona Modeling" - https://arxiv.org/abs/2511.17813
87. arXiv (2510) "Agentic Economic Modeling" - https://arxiv.org/html/2510.25743
88. PolyPersona (2024) - https://arxiv.org/abs/2512.14562
89. arXiv (2503) "LLM Agents That Act Like Us" - https://arxiv.org/html/2503.20749v4
90. Vanderbilt "Pattern Language for Persona-based Interactions" - https://www.dre.vanderbilt.edu/~schmidt/PDF/Persona-Pattern-Language.pdf
91. arXiv (2411) "Donald Trumps in the Virtual Polls" - https://arxiv.org/abs/2411.01582
