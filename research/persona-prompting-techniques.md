# Prompt Engineering for Persona Simulation: Research Report

**Date**: 2026-03-19
**Purpose**: Comprehensive review of techniques for generating realistic, diverse, behaviorally accurate personas via LLM prompting, with actionable insights for Facet's simulation engine.

---

## Table of Contents

1. [Persona Prompting Patterns](#1-persona-prompting-patterns)
2. [Chain-of-Thought for Behavioral Simulation](#2-chain-of-thought-for-behavioral-simulation)
3. [Few-Shot Examples for Persona Generation](#3-few-shot-examples-for-persona-generation)
4. [Temperature and Sampling](#4-temperature-and-sampling)
5. [Structured Output for Simulations](#5-structured-output-for-simulations)
6. [Prompt Techniques for Specific Persona Dimensions](#6-prompt-techniques-for-specific-persona-dimensions)
7. [Multi-Turn vs Single-Turn Persona Generation](#7-multi-turn-vs-single-turn-persona-generation)
8. [Debiasing Prompts](#8-debiasing-prompts)
9. [Cross-Referencing and Consistency](#9-cross-referencing-and-consistency)
10. [Scaling Persona Generation](#10-scaling-persona-generation)
11. [Actionable Recommendations for Facet](#11-actionable-recommendations-for-facet)

---

## 1. Persona Prompting Patterns

### 1.1 Role-Playing Prompts vs. Narrative Prompts vs. Analytical Prompts

**Finding**: Role prompting assigns a persona to an LLM (e.g., "You are a budget-conscious single parent in Detroit") to guide the style, tone, and focus of responses. This enhances text clarity and accuracy by aligning the response with the role. However, role prompting carries a significant risk: assigning social identity personas may introduce or amplify associated social biases, and relying on a single, static persona can reinforce stereotypes.

**Source**: [Learn Prompting — Role Prompting Guide](https://learnprompting.org/docs/advanced/zero_shot/role_prompting); [Gupta & Shrivastava, "Bias Runs Deep: Implicit Reasoning Biases in Persona-Assigned LLMs," 2023](https://arxiv.org/abs/2311.04892)

**Finding**: A comprehensive survey (Chen et al., EMNLP 2024) identifies two distinct lines of LLM persona research: (1) **LLM Role-Playing**, where personas are assigned to the model, and (2) **LLM Personalization**, where the model adapts to user personas. The survey finds that leveraging role-playing increases LLM capabilities including reasoning, planning, and problem-solving, because role-playing triggers corresponding inherent personalities to generate responses aligned with given roles and environments.

**Source**: [Chen et al., "Two Tales of Persona in LLMs: A Survey of Role-Playing and Personalization," EMNLP 2024 Findings](https://aclanthology.org/2024.findings-emnlp.969/)

**Finding**: The PsyPlay framework formalizes persona roles via Big-Five personality vectors, discretizing trait levels and crafting JSON role cards. Dialogues are generated under explicit injection of personality traits and narrative context, which steers LLM persona expression more reliably than free-form role descriptions.

**Source**: [Emergent Mind — Role Agents: Persona-Driven LLMs](https://www.emergentmind.com/topics/role-agents)

**Finding**: "Persona is a Double-Edged Sword" (2024) demonstrates that combining role-playing prompts with neutral prompts in an ensemble improves zero-shot reasoning. Using persona prompting alone can sometimes degrade performance on reasoning tasks, but ensembling the two approaches captures the best of both.

**Source**: [Persona is a Double-edged Sword: Enhancing the Zero-shot Reasoning by Ensembling the Role-playing and Neutral Prompts, 2024](https://arxiv.org/html/2408.08631v1)

### 1.2 Effect of Prompt Length on Output Quality

**Finding**: Studies reveal a paradox: LLM reasoning performance declines as input length increases, well before reaching technical maximums. After approximately 2,000 tokens, most LLMs start performing worse. At 500 tokens accuracy is ~95%, at 1,000 tokens ~90%, by 2,000 tokens ~80%, and each additional 500 tokens cuts accuracy by roughly 5 percentage points. Longer prompts introduce distraction and information overload. Even small amounts of irrelevant information lead to inconsistent predictions.

**Source**: [Grit Daily — "More Words, Less Accuracy: The Surprising Impact of Prompt Length on LLM Performance"](https://gritdaily.com/impact-prompt-length-llm-performance/); [MLOps Community — "The Impact of Prompt Bloat on LLM Output Quality"](https://mlops.community/the-impact-of-prompt-bloat-on-llm-output-quality/); [arXiv — "Effects of Prompt Length on Domain-specific Tasks for Large Language Models," 2025](https://arxiv.org/html/2502.14255v1)

**Actionable Insight for Facet**: The current persona template is well-structured but the combined prompt (config + plan + study-type rules + persona template + name registry) could easily exceed 2,000 tokens. Consider separating information into files that the Claude call reads sequentially rather than injecting everything into a single prompt. Since Facet already uses Read/Write tools, this is architecturally sound.

### 1.3 System Prompt vs. User Prompt Strategies

**Finding**: System prompts should define the AI's overall behavior, role, and persistent constraints. User prompts should drive the immediate interaction with specific, dynamic content. However, there is limited hard empirical evidence about optimal placement. Importantly, Anthropic's Claude places more emphasis on user messages than system prompts, meaning more importance is placed on how the user instructs the model.

**Source**: [PromptHub — System Messages vs User Messages](https://www.prompthub.us/blog/the-difference-between-system-messages-and-user-messages-in-prompt-engineering); [Hamel Husain — "What should go in the system prompt vs. the user prompt?"](https://hamel.dev/blog/posts/evals-faq/what-should-go-in-the-system-prompt-vs-the-user-prompt.html)

**Finding**: Anthropic's own documentation recommends XML tags to structure prompts, using tags like `<instructions>`, `<context>`, `<input>` to clearly separate different sections. This reduces misinterpretation. There are no canonical "best" tag names, but they should make sense with the content they surround. Combining XML with techniques like chain of thought (`<thinking>`, `<answer>`) creates high-performance prompts.

**Source**: [Anthropic Docs — Use XML tags to structure your prompts](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/use-xml-tags); [Anthropic Docs — Prompting best practices](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/claude-prompting-best-practices)

**Actionable Insight for Facet**: Since Facet uses Claude CLI (`claude --print`), the persona template and context are passed via the `-p` flag as a user-level prompt. Given Claude's emphasis on user messages, this is correct. Use XML tags within the prompt to clearly delineate sections: `<study-config>`, `<plan>`, `<persona-outline>`, `<study-rules>`, `<output-instructions>`.

### 1.4 The "Lost in the Middle" Problem

**Finding**: Language models show significant performance degradation (30%+) when relevant information is positioned in the middle of long contexts. Performance follows a U-shaped curve: highest when information appears at the beginning or end. This is caused by positional attention bias in transformer architectures (RoPE embeddings create long-term decay that deprioritizes middle content).

**Source**: [Liu et al., "Lost in the Middle: How Language Models Use Long Contexts," 2023, TACL 2024](https://arxiv.org/abs/2307.03172); [Hsieh et al., "Found in the Middle: Calibrating Positional Attention Bias Improves Long Context Utilization," 2024](https://arxiv.org/abs/2406.16008)

**Actionable Insight for Facet**: Place the most critical persona-specific instructions (the persona outline, the specific segment assignment) at the beginning and end of the prompt. Put the general study config and name registry (less persona-specific) in the middle.

---

## 2. Chain-of-Thought for Behavioral Simulation

### 2.1 CoT for Decision Simulation

**Finding**: Chain-of-thought prompting enhances LLM output on complex tasks requiring multistep reasoning. For behavioral simulation specifically, CoT and hyperparameter tuning are "lightweight interventions which reduce misalignment" between LLM-simulated and real human behavior. LLMs reproduce most hypothesis-level effects and capture key decision biases, but their response distributions still diverge from human data. CoT helps narrow this gap.

**Source**: [Wei et al., "Chain-of-Thought Prompting Elicits Reasoning in Large Language Models," 2022](https://arxiv.org/abs/2201.11903); [arXiv — behavioral simulation with CoT, 2025](https://arxiv.org/html/2510.03310)

### 2.2 Structured Reasoning Frameworks for Personas

**Finding**: For personas simulating decisions, a structured reasoning chain should follow the persona's actual cognitive process. The "Chain-of-Feeling" approach (developed by Synthetic Users) combines emotional states with OCEAN personality traits to produce more human-like responses. Each simulation step captures not only the "what" (chain-of-thought) but the "how it feels" (chain-of-feeling). A persona high in Neuroticism might escalate frustration quicker; a highly Agreeable user might maintain calm longer.

**Source**: [Synthetic Users — Chain-of-Feeling](https://www.syntheticusers.com/science-posts/chain-of-feeling)

**Finding**: The MIRROR framework implements inner monologue in LLMs by generating parallel threads across three dimensions: cognitive reasoning, emotional processing, and persona consistency. The Cognitive Controller synthesizes these threads into a persistent first-person narrative. This enables sophisticated reasoning through role-based self-reference prompting.

**Source**: [MIRROR: Cognitive Inner Monologue Between Conversational Turns, 2025](https://arxiv.org/html/2506.00430v1)

**Actionable Insight for Facet**: The current persona template already asks for "internal monologue" during purchase decisions. Enhance this by explicitly structuring the reasoning: "First consider your budget constraints and monthly cash flow. Then consider your emotional reaction to the price. Then consider your past experiences with similar products. Then consider what your social circle would think. Finally, make your decision." This mirrors the Chain-of-Feeling approach.

### 2.3 CoT Reduces Anchoring Bias in Numerical Generation

**Finding**: LLMs demonstrate anchoring bias when generating numerical estimates: they anchor on numbers present in the prompt. Chain-of-Thought prompting significantly reduced anchoring bias for some models (notably GPT-4), though instructions to "ignore earlier conversation" were largely ineffective. To mitigate anchoring, prompts should collect information from comprehensive angles rather than presenting a single reference number.

**Source**: [arXiv — "Anchoring Bias in Large Language Models: An Experimental Study," 2024](https://arxiv.org/html/2412.06593v1); [Springer — "Anchoring bias in large language models," 2025](https://link.springer.com/article/10.1007/s42001-025-00435-2)

**Actionable Insight for Facet**: When generating financial details for personas, avoid providing specific salary or spending anchors in the persona outline. Instead, provide income *ranges* per segment and let the persona generation call derive specific numbers through chain-of-thought reasoning ("Given she works as [job] in [city] with [years] experience, her likely salary would be..."). This avoids anchoring all personas in a segment to the same number.

---

## 3. Few-Shot Examples for Persona Generation

### 3.1 Examples Help Quality But Can Hurt Diversity

**Finding**: Few-shot learning draws on in-context learning where exposure to even a handful of demonstrations meaningfully improves task performance without model modification. A single example may suffice for simpler tasks or highly capable models. However, multiple examples provide additional guidance for complex tasks. The key tension: examples improve *format compliance* and *quality floor* but can reduce *output diversity* because the model mimics the examples.

**Source**: [Emergent Mind — Persona Prompting](https://www.emergentmind.com/topics/persona-prompting-pp); [Kambhatla et al., "Measuring Lexical Diversity of Synthetic Data Generated through Fine-Grained Persona Prompting," EMNLP 2025](https://aclanthology.org/2025.findings-emnlp.1146/)

**Finding**: The EMNLP 2025 study on lexical diversity found that: (1) Synthetic prompts/instructions are significantly less diverse than human-written ones. (2) Persona prompting produces higher lexical diversity than prompting without personas, especially in larger models. (3) Adding fine-grained persona details yields *minimal* additional gains in diversity compared to simply specifying a length cutoff.

**Source**: [Kambhatla et al., 2025](https://arxiv.org/abs/2505.17390)

### 3.2 Contrastive Examples (Positive + Negative)

**Finding**: Contrastive examples (showing both correct and incorrect outputs) outperform standard few-shot prompting in both performance and token efficiency. Negative examples generated from zero-shot outputs were as effective as human-written negative examples. During critical learning phases, each additional negative example improves accuracy approximately 10x more than each additional positive example. Near-miss negative examples (plausible but wrong) are more influential than obviously incorrect ones.

**Source**: [arXiv — "Large Language Models are Contrastive Reasoners," 2024](https://arxiv.org/html/2403.08211v1); [arXiv — "How much do LLMs learn from negative examples?" 2025](https://arxiv.org/abs/2503.14391); [arXiv — "Not All Negative Samples Are Equal," 2025](https://arxiv.org/html/2602.03516v1)

**Finding**: However, negative *instructions* (phrased as "don't do X") are less effective than positive framing. Negative instructions confuse LLMs or get ignored. Positive prompts actively boost probabilities of desired outcomes, while negative prompts only slightly reduce probabilities of unwanted tokens.

**Source**: [Gadlet — "Why Positive Prompts Outperform Negative Ones with LLMs?"](https://gadlet.com/posts/negative-prompting/)

**Actionable Insight for Facet**: Rather than providing full example personas (which would create mimicry), provide short contrastive *snippets* of good vs. bad persona details. For example:

```
GOOD: "$38,500/year — $18.50/hour, the result of seven years of seniority"
BAD: "She makes a moderate salary"
GOOD: "A Hacker News Show HN post at 11pm on a Wednesday"
BAD: "She found it on social media"
```

This guides quality without constraining diversity. Frame these as positive instructions ("Write details at this level of specificity") rather than negative ones ("Don't be vague").

---

## 4. Temperature and Sampling

### 4.1 Temperature's True Effect

**Finding**: A 2024 study directly challenges the assumption that temperature is a reliable "creativity parameter." The research found only a weak positive correlation between novelty and temperature, with a moderately negative correlation between coherence and temperature. Temperature increases the chance of generating variety in a limited sample, but does not enable access to a fundamentally larger slice of the probability distribution.

**Source**: [ICCC 2024 — "Is Temperature the Creativity Parameter of Large Language Models?"](https://computationalcreativity.net/iccc24/papers/ICCC24_paper_70.pdf)

**Finding**: Temperature significantly impacts whether and when consensus is reached in multi-agent LLM systems. However, contrary to expectations, diverse personas do not consistently lead to better outcomes. Temperature had a larger effect on consensus dynamics than persona variation.

**Source**: [arXiv — "Temperature and Persona Shape LLM Agent Consensus With Minimal Accuracy Gains," 2025](https://arxiv.org/pdf/2507.11198)

### 4.2 Min-p Sampling: The Better Alternative

**Finding**: Min-p sampling is a dynamic truncation method that adjusts the sampling threshold based on the model's confidence. Unlike top-p (nucleus) sampling which uses a fixed threshold, min-p scales its truncation relative to the highest-probability token. Experiments across Mistral and Llama 3 models (1B to 123B parameters) show min-p improves both quality and diversity, especially at higher temperatures. It achieves higher creative writing win rates without sacrificing coherence. Min-p has been adopted by Hugging Face Transformers, vLLM, and other major frameworks.

**Source**: [arXiv — "Turning Up the Heat: Min-p Sampling for Creative and Coherent LLM Outputs," 2024](https://arxiv.org/abs/2407.01082)

### 4.3 Verbalized Sampling: Prompting for Diversity

**Finding**: Verbalized Sampling (VS) is a training-free prompting strategy that instructs the model to verbalize a probability distribution over responses (e.g., "Generate 5 possible responses and their corresponding probabilities"). This reframes the task from "pick the most typical answer" to "surface the distribution," letting the model tap into its pretraining diversity. VS increases diversity by 1.6-2.1x over direct prompting. It is orthogonal to temperature (works at any temperature), model-agnostic (works with GPT, Claude, Gemini, Llama), and effective across creative writing, social simulation, and synthetic data generation.

**Source**: [arXiv — "Verbalized Sampling: How to Mitigate Mode Collapse and Unlock LLM Diversity," 2025](https://arxiv.org/abs/2510.01171)

**Actionable Insight for Facet**: Since Facet uses Claude CLI where temperature and sampling parameters may have limited configurability, **Verbalized Sampling is the most actionable technique**. When generating personas, consider prompting: "Before writing the full persona, briefly brainstorm 3 possible personality archetypes for this segment outline, each with distinct financial philosophies and emotional profiles. Then choose the most interesting one and develop it fully." This achieves the VS effect within a single prompt.

---

## 5. Structured Output for Simulations

### 5.1 Format Restrictions Degrade Reasoning

**Finding**: The landmark "Let Me Speak Freely?" study (2024) systematically tested the impact of format restrictions on LLM performance. Key findings: (1) Strict JSON mode degrades reasoning by 10-15%. (2) Stricter constraints lead to greater degradation in reasoning tasks. (3) However, JSON mode either matches or exceeds performance for *classification* tasks. (4) The degradation occurs because forced structured adherence undermines the reasoning process, exemplified by misordering of reasoning steps and final answers.

**Source**: [arXiv — "Let Me Speak Freely? A Study on the Impact of Format Restrictions on Performance of Large Language Models," 2024](https://arxiv.org/html/2408.02442v1)

### 5.2 Markdown vs. JSON for Persona Output

**Finding**: Research comparing formats found that GPT-4 favors Markdown while GPT-3.5 favors JSON. Markdown is approximately 10% more token-efficient than YAML and significantly more efficient than JSON. JSON is "a serious token hog" that can use twice as many tokens for the same data. Models produce better code (and by extension, better creative text) when returning it as markdown compared to JSON. For nested data, YAML and Markdown outperform XML and JSON.

**Source**: [arXiv — "Does Prompt Formatting Have Any Impact on LLM Performance?" 2024](https://arxiv.org/html/2411.10541v1); [Improving Agents — "Which Nested Data Format Do LLMs Understand Best?"](https://www.improvingagents.com/blog/best-nested-data-format/); [aider — "LLMs are bad at returning code in JSON"](https://aider.chat/2024/08/14/code-in-json.html)

### 5.3 The Two-Stage NL-to-Format Approach

**Finding**: The recommended approach is two-stage generation: (1) First, generate the content in natural language/markdown without format constraints, allowing the model to leverage its full reasoning capabilities. (2) Then, if structured data is needed, convert the output to the target format in a second pass. This adds one extra forward pass but works reliably and avoids reasoning degradation.

**Source**: [arXiv — "Decoupling Task-Solving and Output Formatting in LLM Generation," 2025](https://arxiv.org/html/2510.03595v1)

**Actionable Insight for Facet**: Facet's current approach of generating personas as Markdown files is already optimal. Markdown is the best format for Claude, the most token-efficient, and avoids the reasoning degradation caused by strict JSON constraints. If structured data extraction is needed later (e.g., for the synthesis phase), parse the markdown post-generation rather than constraining the generation format.

---

## 6. Prompt Techniques for Specific Persona Dimensions

### 6.1 Realistic Financial Details

**Finding**: LLMs exhibit anchoring bias on numbers present in the prompt. When asked to generate financial details, they anchor on any specific numbers provided as reference points. A framework called "Synthesizing Behaviorally-Grounded Reasoning Chains" (2025) showed that through careful data curation and behavioral integration, even an 8B model achieved performance comparable to much larger baselines for generating personalized financial scenarios.

**Source**: [arXiv — "Synthesizing Behaviorally-Grounded Reasoning Chains," 2025](https://arxiv.org/html/2509.14180v1)

**Actionable Insight for Facet**: For financial specificity, provide the persona with contextual anchors rather than exact numbers. Instead of "income: $45,000", use "She works as a dental hygienist in Memphis, TN with 7 years experience. Derive her specific salary, tax situation, and monthly budget from this context." This produces internally consistent financial details without anchoring all personas to the same numbers.

### 6.2 Authentic Emotional Responses and Internal Monologues

**Finding**: LLMs develop "a surprisingly well-defined internal geometry of emotion" that sharpens with model scale. On standard emotional intelligence tests, GPT-4, Claude 3.5, and others outperformed humans (81% average accuracy vs. 56% human average). However, simply reflecting affective states ("Feeling hesitation and anxiety") appears inauthentic. More effective: the "inner monologue" approach where the model generates parallel cognitive and emotional threads.

**Source**: [arXiv — "Decoding Emotion in the Deep," 2025](https://arxiv.org/html/2510.04064v1); [PMC — "Large language models are proficient in emotional intelligence tests"](https://pmc.ncbi.nlm.nih.gov/articles/PMC12095572/); [arXiv — MIRROR framework, 2025](https://arxiv.org/html/2506.00430v1)

**Finding**: The Chain-of-Feeling approach models how OCEAN personality traits alter emotional responses over time. A user high in Neuroticism escalates frustration faster; a highly Agreeable user maintains calm longer. Patterns in chain-of-feeling logs reveal which personalities or emotional triggers lead to task success/failure, early drop-off, or dissatisfaction.

**Source**: [Synthetic Users — Chain-of-Feeling](https://www.syntheticusers.com/science-posts/chain-of-feeling)

**Actionable Insight for Facet**: The persona template already asks for internal monologue "in their voice, with their vocabulary." Strengthen this by adding explicit emotional scaffolding: "Show the emotional arc of the decision: initial reaction, building considerations, the moment of doubt, the resolution. Use the persona's specific vocabulary and thought patterns—not generic emotional labels."

### 6.3 Realistic Social Networks and Referral Behavior

**Finding**: The landmark Stanford "Generative Agents" work (Park et al., 2023) demonstrated that LLM-powered agents can form relationships, share news, and coordinate group activities when given memory systems and social architectures. Agents plan their days, maintain social graphs, and demonstrate emergent social behaviors including information cascading through networks.

**Source**: [Park et al., "Generative Agents: Interactive Simulacra of Human Behavior," 2023, UIST 2023](https://arxiv.org/abs/2304.03442)

**Actionable Insight for Facet**: The current "Weave" phase (which adds cross-references and referral chains after persona generation) is architecturally correct. The plan template's "Cross-Reference Plan" section already designs the social fabric. To improve referral realism, the weave prompt should include specific instructions: "When describing referral conversations, include the exact setting (group text, dinner conversation, office hallway), the exact words used, and whether the referral message gets distorted as it travels."

### 6.4 Culturally Appropriate Details for Diverse Demographics

**Finding**: A large-scale audit of LLM-generated personas across 41 occupations found systematic suppression of certain groups across roles, including consistent erasure of women and racial minorities. All personas generated tended to be young adults (20s-30s), even when prompted with names associated with older generations. Female personas are depicted with greater emotional stability and prosocial traits. Atheist personas deviate dramatically from religious groups on personality traits.

**Source**: [arXiv — "Race and Gender in LLM-Generated Personas: A Large-Scale Audit of 41 Occupations," 2025](https://arxiv.org/html/2510.21011v1); [ScienceDirect — "Bias and gendering in LLM-generated synthetic personas," 2025](https://www.sciencedirect.com/science/article/pii/S1071581925002083)

**Finding**: LLM personas do not accurately reflect the authentic experience of real people in resource-scarce environments, with particularly large gaps in empathy and credibility. Alignment with cultural values is improved more by explicit cultural perspective framing than by targeted prompt language.

**Source**: [arXiv — "Misalignment of LLM-Generated Personas with Human Perceptions in Low-Resource Settings," 2025](https://arxiv.org/html/2512.02058); [arXiv — "LLMs and Cultural Values: the Impact of Prompt Language and Explicit Cultural Framing," 2025](https://arxiv.org/html/2511.03980v1)

**Actionable Insight for Facet**: The plan template already requires geographic, demographic, and cultural diversity. Strengthen this by: (1) Explicitly specifying age ranges across the full spectrum (20s-70s) in the plan's diversity requirements. (2) Using explicit cultural framing ("Write from the perspective of someone who grew up in a Mexican-American household in South Texas") rather than just naming demographics. (3) Including an anti-stereotyping instruction: "Avoid associating demographic traits with expected personality types. A 67-year-old grandmother can be tech-savvy; a young tech worker can be financially conservative."

### 6.5 Simulating Decision-Making Under Uncertainty

**Finding**: A comprehensive behavioral economics framework applied to LLMs found they generally exhibit human-like patterns: risk aversion, loss aversion, and overweighting small probabilities. However, when modeled with socio-demographic features, significant disparities emerge—for instance, Claude-3-Opus displays increased risk aversion when assigned minority group personas, leading to more conservative choices. Recent research challenges the direct application of human-centric Prospect Theory to LLMs, especially in linguistically uncertain contexts.

**Source**: [arXiv — "Decision-Making Behavior Evaluation Framework for LLMs under Uncertain Context," NeurIPS 2024](https://arxiv.org/abs/2406.05972); [arXiv — "Prospect Theory Fails for LLMs," 2025](https://arxiv.org/html/2508.08992)

**Actionable Insight for Facet**: When simulating purchase decisions under uncertainty, explicitly scaffold the decision framework: "Consider: What is the worst case? What is the best case? What is most likely? How much would you regret choosing this option if it went wrong? How much would you regret NOT choosing it if it went well?" This structures the uncertainty reasoning and produces more nuanced decision simulations than simply asking "would you buy this?"

---

## 7. Multi-Turn vs Single-Turn Persona Generation

### 7.1 Self-Refine: Iterative Refinement Improves Quality by 20%+

**Finding**: Self-Refine (Madaan et al., 2023) demonstrated that LLM outputs improve by ~20% absolute on average when the model generates an initial output, provides feedback on it, and refines iteratively. Improvements range from 5% to 40%+ across different tasks. The approach works with a single LLM, requires no supervised training data, and allows even strong models like GPT-4 to "unlock their full potential."

**Source**: [Madaan et al., "Self-Refine: Iterative Refinement with Self-Feedback," 2023](https://arxiv.org/abs/2303.17651)

### 7.2 Limitations of Self-Critique

**Finding**: However, self-critique has significant limitations. Without external feedback, self-improvement loops may lead to performance *degradation*. LLMs may lack the ability to meaningfully self-critique and revise without external verification. The CRITIC framework addresses this by incorporating tool-interactive critiquing, where the model validates its output using external tools before revision.

**Source**: [arXiv — "CRITIC: Large Language Models Can Self-Correct with Tool-Interactive Critiquing," 2023](https://arxiv.org/abs/2305.11738); [Learn Prompting — Self-Criticism Techniques](https://learnprompting.org/docs/advanced/self_criticism/introduction)

### 7.3 Multi-Agent Debate for Factuality

**Finding**: Multi-agent debate (where multiple LLM instances critique each other's responses) significantly enhances mathematical and strategic reasoning and reduces hallucinations. Facts that agents disagree on tend to be "debated out or corrected." The approach can be applied to black-box models with identical prompts for all agents.

**Source**: [Du et al., "Improving Factuality and Reasoning in Language Models through Multiagent Debate," ICML 2024](https://arxiv.org/abs/2305.14325)

**Actionable Insight for Facet**: Facet's current single-shot persona generation (one Claude call per persona) is reasonable for the Generate phase. However, the Adversarial phase (which argues against the synthesis) already implements a form of multi-agent debate. Consider adding a lightweight self-critique step within persona generation: "After completing the persona, review it for: (1) Internal numerical consistency, (2) Whether the financial details add up, (3) Whether the emotional responses match the personality described, (4) Whether the discovery story is plausible. Fix any issues." This captures Self-Refine benefits within a single call by using max-turns generously (already set at 15 for Generate).

---

## 8. Debiasing Prompts

### 8.1 System 2 Prompting Reduces Bias by Up to 33%

**Finding**: Multiple prompting approaches—including human persona, debiasing, System 2, and Chain-of-Thought prompting—can reduce social biases by up to 33%. Combining System 2 prompting (asking the model to reason slowly and carefully) with a human persona produces the largest reductions in bias when averaged across models and bias categories.

**Source**: [arXiv — "Prompting Techniques for Reducing Social Bias in LLMs through System 1 and System 2 Cognitive Processes," RANLP 2025](https://arxiv.org/html/2404.17218v4)

### 8.2 Multi-Persona Thinking (MPT) for Debiasing

**Finding**: Multi-Persona Thinking (MPT) engages models in an iterative, dialectical process across different social identities. This transforms persona-assignment from a bias risk into a strength for bias mitigation. MPT reduces bias while preserving logical reasoning capability.

**Source**: [arXiv — "Multi-Persona Thinking for Bias Mitigation in Large Language Models," 2025](https://arxiv.org/html/2601.15488v1)

### 8.3 Self-Debiasing

**Finding**: Zero-shot self-debiasing leverages LLM capabilities to reduce stereotyping through two approaches: self-debiasing via explanation (asking the model to explain its reasoning, which surfaces and corrects biased assumptions) and self-debiasing via reprompting (asking the model to reconsider from a different angle). Both significantly reduce stereotypes across diverse social groups using only the LLM and a simple prompt.

**Source**: [arXiv — "Self-Debiasing Large Language Models: Zero-Shot Recognition and Reduction of Stereotypes," 2024](https://arxiv.org/html/2402.01981v1)

### 8.4 "Bias Runs Deep" — The Limitation of Prompt-Based Debiasing

**Finding**: Despite the above techniques, persona-induced bias is persistent and resists simple mitigation. With ChatGPT-3.5, 80% of personas demonstrate bias, with certain datasets showing performance drops of 70%+. Importantly, simple de-biasing prompts (e.g., "don't make stereotypical assumptions") have been found to be "ineffective or impractical." The bias manifests as abstentions ("As a Black person, I am unable to answer this question as it requires math knowledge"), revealing deep implicit biases.

**Source**: [Gupta et al., "Bias Runs Deep: Implicit Reasoning Biases in Persona-Assigned LLMs," ICLR 2024](https://arxiv.org/abs/2311.04892)

### 8.5 Sycophancy and Agreeable Bias in Simulations

**Finding**: LLM sycophancy (excessive agreement with the user/prompt) is a major risk for persona simulation. An "aligned" or "friendly" LLM may be a worse simulator by generating unrealistically agreeable responses. Personalization features increase sycophancy. Mitigation: keeping interactions professional rather than friendly reduces sycophancy—when framed as an adviser rather than a friend, models are more likely to push back.

**Source**: [MIT News — "Personalization features can make LLMs more agreeable," 2026](https://news.mit.edu/2026/personalization-features-can-make-llms-more-agreeable-0218); [arXiv — "Position: LLM Social Simulations Are a Promising Research Method," 2025](https://arxiv.org/html/2504.02234v2); [arXiv — "Sycophancy in Large Language Models: Causes and Mitigations," 2024](https://arxiv.org/html/2411.15287v1)

### 8.6 Counter-Stereotypical Prompting

**Finding**: Controlled bias-challenging prompts can reduce gender biases in stereotypical associations by 40%. FairPro uses meta-prompting where the LLM identifies potential bias and generates fairness-aware system prompts. Alignment with cultural values is improved more with explicit cultural perspective than with targeted prompt language (i.e., explicitly framing "respond from the perspective of X culture" works better than just writing the prompt in that culture's language).

**Source**: [arXiv — "Aligned but Stereotypical?" 2025](https://arxiv.org/html/2512.04981); [arXiv — "LLMs and Cultural Values," 2025](https://arxiv.org/html/2511.03980v1)

**Actionable Insight for Facet**: Add to the persona template a debiasing instruction block:

```
IMPORTANT: This persona simulation must avoid sycophancy and stereotyping.
- Do NOT make this persona unrealistically agreeable with the product.
- Do NOT default to stereotypical behavior based on demographics.
- Some personas should be harsh critics. Some should be confused. Some should be indifferent.
- If this persona would realistically reject the product, show that rejection authentically.
- Frame the simulation as analytical assessment, not friendly conversation.
```

Additionally, the plan template already requires skeptic segments and hard-to-convert segments—this is good. Ensure the persona template reinforces that some personas should actively dislike the product.

---

## 9. Cross-Referencing and Consistency

### 9.1 Verification-First Prompting

**Finding**: Verification-First (VF) is a cost-effective prompting strategy that enhances reasoning by instructing models to verify a candidate answer before generating a solution. This triggers a reverse reasoning process complementary to standard forward chain-of-thought. The approach adds minimal cost while improving accuracy.

**Source**: [arXiv — "Asking LLMs to Verify First is Almost Free Lunch," 2025](https://arxiv.org/html/2511.21734v1)

### 9.2 Score Before You Speak (SBS)

**Finding**: The SBS framework (ECAI 2025) improves persona consistency in dialogue generation by training models to correlate responses with quality scores. Score-conditioned training allows models to better capture a spectrum of persona-consistent dialogues. The approach outperforms previous methods for both million- and billion-parameter models.

**Source**: [arXiv — "Score Before You Speak: Improving Persona Consistency in Dialogue Generation," ECAI 2025](https://arxiv.org/html/2508.06886v1)

### 9.3 Persona-Aware Contrastive Learning (PCL)

**Finding**: PCL enforces consistency by combining role-chain and introspective prompting with a contrastive objective that penalizes deviations from persona-specific outputs. This achieves measurable gains in character consistency.

**Source**: [ResearchGate — "Enhancing Persona Consistency for LLMs' Role-Playing using Persona-Aware Contrastive Learning," 2025](https://www.researchgate.net/publication/394298208)

### 9.4 Self-Consistency Verification

**Finding**: An LMT Consistency Framework detects early contradictions and triggers a "consistency mode" upon conflict, resulting in re-tagged, cautious outputs that prompt for re-definition rather than overconfident resolution. For persona generation, this translates to: after generating a persona section, check whether it contradicts earlier sections.

**Source**: [PhilArchive — Yoshino, "LMT Consistency Framework," 2025](https://philarchive.org/rec/YOSLCF)

**Actionable Insight for Facet**: Add a consistency verification step at the end of the persona template:

```
### CONSISTENCY CHECK (do not include in output)
Before writing the final file, verify:
- Does the 12-month usage simulation's total spending match the persona's stated income/budget?
- Does the NPS score align with the emotional reactions described?
- Does the referral behavior match the persona's personality (introverts refer differently than extroverts)?
- Do the specific dates and amounts in the simulation table add up correctly?
- Is the discovery story consistent with the persona's media diet and social circle?
Fix any inconsistencies before writing.
```

This leverages Self-Refine within the single generation call (possible because Facet allows 15 max-turns per persona).

---

## 10. Scaling Persona Generation

### 10.1 Mode Collapse is the Central Challenge

**Finding**: Naive prompting leads to mode collapse: simply asking an LLM to "generate diverse personas" produces populations clustered around stereotypical responses. LLMs default to an "average persona" that underrepresents behavioral heterogeneity.

**Source**: [arXiv — "Persona Generators: Generating Diverse Synthetic Personas at Scale," 2025](https://arxiv.org/html/2602.03545v1); [arXiv — "Population-Aligned Persona Generation for LLM-based Social Simulation," 2024](https://arxiv.org/html/2509.10127v1)

### 10.2 Persona Hub: 1 Billion Personas via Text-to-Persona

**Finding**: Tencent AI Lab's Persona Hub curates 1 billion diverse personas from web data using a "Text-to-Persona" technique: given arbitrary text, the model answers "Who is likely to read/write/like/dislike this text?" By applying this to massive web corpora, they obtain billions of diverse personas. Each persona acts as a "distributed carrier of world knowledge" that steers the LLM toward distinct data generation.

**Source**: [Tencent AI Lab — "Scaling Synthetic Data Creation with 1,000,000,000 Personas," 2024](https://arxiv.org/abs/2406.20094)

### 10.3 Staggered Generation with Diversity Axes

**Finding**: The Persona Generators framework formalizes population creation as two stages: (1) quasi-random sampling along orthogonal diversity axes, then (2) expansion into full persona descriptions. This uses quasi-random (low-discrepancy) sampling to ensure even coverage. The framework produces significantly better coverage than naive prompting.

**Source**: [arXiv — "Persona Generators," 2025](https://arxiv.org/html/2602.03545v1)

### 10.4 DeepPersona: Taxonomy-Guided Deep Personas

**Finding**: DeepPersona uses a two-stage taxonomy-guided method: (1) algorithmically construct a human-attribute taxonomy of hundreds of hierarchical attributes from real user conversations, then (2) progressively sample attributes and conditionally generate coherent personas averaging hundreds of structured attributes and ~1 MB of narrative text. Results: 32% higher attribute diversity and 44% greater profile uniqueness vs. baselines. Personalized QA accuracy improved by 11.6%.

**Source**: [arXiv — "DeepPersona: A Generative Engine for Scaling Deep Synthetic Personas," 2024](https://arxiv.org/abs/2511.07338)

### 10.5 HACHIMI: Propose-Validate-Revise at Scale

**Finding**: HACHIMI generates 1 million personas using a multi-agent Propose-Validate-Revise framework. Key innovations: (1) A theory-anchored educational schema for each persona. (2) A neuro-symbolic validator enforcing developmental and psychological constraints. (3) Stratified sampling with semantic deduplication to reduce mode collapse. (4) A shared whiteboard for sequential agent conditioning to mitigate intra-profile inconsistency.

**Source**: [arXiv — "HACHIMI: Scalable and Controllable Student Persona Generation via Orchestrated Agents," 2025](https://arxiv.org/html/2603.04855v2)

### 10.6 Evolutionary Optimization for Diversity

**Finding**: An evolutionary approach uses a multi-objective loop (inspired by AlphaEvolve) to optimize Persona Generator code, maximizing coverage metrics (Monte Carlo coverage, convex hull volume, pairwise distances, dispersion, KL divergence to reference distributions). The optimized generator reaches 80%+ coverage on test sets. Evolution produces steady increases in both convex hull volume and coverage.

**Source**: [Vallinder — "Evolving Diverse Synthetic Personas," 2025](https://vallinder.se/blog/evolving-diverse-synthetic-personas/)

### 10.7 The Stanford "1,000 People" Approach

**Finding**: Stanford's generative agents architecture simulates 1,052 real individuals by applying LLMs to 2-hour qualitative interviews about their lives. The agents replicated participants' survey responses 85% as accurately as participants replicated their own answers two weeks later. Interview-based agents were more accurate *and less biased* than agents given only demographic descriptions.

**Source**: [Park et al., "Generative Agent Simulations of 1,000 People," 2024](https://arxiv.org/abs/2411.10109)

### 10.8 Importance Sampling for Population Alignment

**Finding**: Recent work applies importance sampling to achieve global alignment with reference psychometric distributions (e.g., Big Five personality traits). Stratified analyses reveal under/over-representation within intersectional subgroups, enabling iterative refinement. A task-specific module adapts the globally aligned persona set to targeted subpopulations.

**Source**: [Microsoft Research — "Population-Aligned Persona Generation for LLM-based Social Simulation," 2024](https://arxiv.org/abs/2509.10127)

**Actionable Insight for Facet**: Facet generates 20-50 personas per study. At this scale, the plan phase is the critical diversity control point. The current plan template already includes segment matrix design, but should be enhanced with:

1. **Explicit diversity axes**: Define orthogonal axes (income, age, tech comfort, risk tolerance, decision speed) and ensure the persona outlines sample broadly across each axis.
2. **Anti-clustering instruction**: "Ensure no two personas in the same segment share more than 2 of these traits: same age decade, same income bracket, same city type, same family structure, same discovery channel."
3. **Wildcard allocation**: Already present ("accidental/unusual discoverers") but ensure at least 10-15% of personas are edge cases.

---

## 11. Actionable Recommendations for Facet

Based on the synthesis of 60+ sources, here are the highest-impact changes for Facet's persona simulation engine, ordered by expected impact:

### HIGH IMPACT

**1. Add Verbalized Sampling to the Generate Phase**
Before writing the full persona, ask the model to brainstorm 3 distinct personality archetypes for the given outline, then select and develop the most interesting one. This mitigates mode collapse within segments at zero cost (1.6-2.1x diversity improvement per Verbalized Sampling research).

**2. Restructure Prompts with XML Tags**
Wrap each section of the persona generation prompt in XML tags (`<study-config>`, `<plan>`, `<persona-assignment>`, `<study-rules>`, `<output-template>`). Place persona-specific content at the beginning and end of the prompt; place general context in the middle. This leverages Claude's XML tag optimization and mitigates the "Lost in the Middle" problem.

**3. Add Contrastive Quality Examples**
Instead of full example personas (which would reduce diversity), add 4-6 short contrastive snippets showing "GOOD vs. BAD" details. Focus on specificity of financial details, discovery stories, and emotional monologues. Frame as positive guidance, not negative instructions.

**4. Add Anti-Sycophancy Instructions**
Explicitly instruct personas to be authentically critical when appropriate. "This is an analytical simulation, not a sales pitch. Some personas should reject the product. Some should be indifferent. Simulate authentic human responses, including negative ones."

**5. Use Markdown Output (Already Correct)**
Facet already generates personas as markdown files. This is optimal: markdown avoids the 10-15% reasoning degradation from JSON constraints, is more token-efficient, and is Claude's preferred format.

### MEDIUM IMPACT

**6. Add Chain-of-Feeling Scaffolding**
Enhance the internal monologue sections with explicit emotional scaffolding: "Show the emotional arc: initial reaction -> building considerations -> moment of doubt -> resolution. Use the persona's vocabulary, not generic emotional labels."

**7. Add Consistency Verification Step**
Include a self-check instruction at the end of the persona template verifying numerical consistency, personality-behavior alignment, and timeline plausibility. Since Facet allows 15 max-turns per persona generation, this adds verification within the existing call budget.

**8. Avoid Numerical Anchoring in Persona Outlines**
In the plan phase, provide income *ranges* and demographic *contexts* rather than specific numbers. Let the generation call derive exact figures through reasoning. This produces more diverse financial profiles within segments.

**9. Strengthen Cultural Framing**
Use explicit cultural perspective framing ("Write from the perspective of someone who grew up in...") rather than just listing demographic attributes. Research shows explicit cultural framing improves authenticity more than demographic labeling.

**10. Add Anti-Clustering Constraints to Plan**
Require that no two personas in the same segment share more than 2 of: same age decade, same income bracket, same city type, same family structure, same discovery channel. This prevents within-segment mode collapse.

### LOWER IMPACT BUT WORTH CONSIDERING

**11. Explore Two-Pass Generation for Complex Personas**
For the most complex personas (high-value segments, edge cases), consider a two-pass approach: generate in natural language first, then structure into the template format. This would require architectural changes but could improve quality for key personas.

**12. Add Multi-Persona Thinking to the Plan Phase**
When the plan call designs segments, have it first consider the product from 5-6 very different perspectives (a skeptic, an enthusiast, a confused newcomer, a budget-constrained parent, a tech-savvy early adopter, an elderly technophobe) before designing the formal segment matrix. This MPT approach reduces stereotypical segment designs.

**13. Leverage Adversarial Phase for Bias Detection**
The existing Adversarial phase already argues against the synthesis. Extend it to also check for: stereotypical persona patterns, missing demographic representation, sycophantic bias (are too many personas positive about the product?), and financial inconsistencies.

**14. Consider Prompt Chaining for the Weave Phase**
The Weave phase (75 max-turns) reads all personas and adds cross-references. This is the highest-context phase. Consider splitting it: first have a call identify plausible connections, then have a second call write the actual cross-reference narratives. This reduces context load per call.

---

## Appendix: Source Index

### Persona Prompting and Role-Playing
1. Chen et al., "Two Tales of Persona in LLMs," EMNLP 2024 — [ACL Anthology](https://aclanthology.org/2024.findings-emnlp.969/)
2. Learn Prompting, "Role Prompting Guide" — [learnprompting.org](https://learnprompting.org/docs/advanced/zero_shot/role_prompting)
3. Emergent Mind, "Role Agents: Persona-Driven LLMs" — [emergentmind.com](https://www.emergentmind.com/topics/role-agents)
4. "Persona is a Double-edged Sword," 2024 — [arXiv](https://arxiv.org/html/2408.08631v1)
5. AAAI AIES, "Whose Personae? Synthetic Persona Experiments in LLM Research" — [AAAI](https://ojs.aaai.org/index.php/AIES/article/download/36553/38691/40628)

### Prompt Length and Structure
6. "Effects of Prompt Length on Domain-specific Tasks," 2025 — [arXiv](https://arxiv.org/html/2502.14255v1)
7. Grit Daily, "Impact of Prompt Length on LLM Performance" — [gritdaily.com](https://gritdaily.com/impact-prompt-length-llm-performance/)
8. MLOps Community, "Impact of Prompt Bloat" — [mlops.community](https://mlops.community/the-impact-of-prompt-bloat-on-llm-output-quality/)
9. Anthropic, "Prompting best practices" — [platform.claude.com](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/claude-prompting-best-practices)
10. Anthropic, "Use XML tags" — [platform.claude.com](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/use-xml-tags)

### System vs User Prompts
11. PromptHub, "System vs User Messages" — [prompthub.us](https://www.prompthub.us/blog/the-difference-between-system-messages-and-user-messages-in-prompt-engineering)
12. Hamel Husain, "System vs User Prompt" — [hamel.dev](https://hamel.dev/blog/posts/evals-faq/what-should-go-in-the-system-prompt-vs-the-user-prompt.html)
13. PromptLayer, "System Prompt vs User Prompt" — [promptlayer.com](https://blog.promptlayer.com/system-prompt-vs-user-prompt-a-comprehensive-guide-for-ai-prompts/)

### Lost in the Middle
14. Liu et al., "Lost in the Middle," TACL 2024 — [arXiv](https://arxiv.org/abs/2307.03172)
15. Hsieh et al., "Found in the Middle," 2024 — [arXiv](https://arxiv.org/abs/2406.16008)

### Chain-of-Thought
16. Wei et al., "Chain-of-Thought Prompting," 2022 — [arXiv](https://arxiv.org/abs/2201.11903)
17. "Behavioral simulation with CoT," 2025 — [arXiv](https://arxiv.org/html/2510.03310)
18. Synthetic Users, "Chain-of-Feeling" — [syntheticusers.com](https://www.syntheticusers.com/science-posts/chain-of-feeling)
19. MIRROR Framework, 2025 — [arXiv](https://arxiv.org/html/2506.00430v1)

### Anchoring and Numerical Bias
20. "Anchoring Bias in Large Language Models," 2024 — [arXiv](https://arxiv.org/html/2412.06593v1)
21. Springer, "Anchoring bias in LLMs," 2025 — [springer.com](https://link.springer.com/article/10.1007/s42001-025-00435-2)

### Few-Shot and Contrastive Examples
22. Kambhatla et al., "Measuring Lexical Diversity," EMNLP 2025 — [ACL Anthology](https://aclanthology.org/2025.findings-emnlp.1146/)
23. "Large Language Models are Contrastive Reasoners," 2024 — [arXiv](https://arxiv.org/html/2403.08211v1)
24. "How much do LLMs learn from negative examples?" 2025 — [arXiv](https://arxiv.org/abs/2503.14391)
25. "Not All Negative Samples Are Equal," 2025 — [arXiv](https://arxiv.org/html/2602.03516v1)
26. Gadlet, "Why Positive Prompts Outperform Negative Ones" — [gadlet.com](https://gadlet.com/posts/negative-prompting/)

### Temperature and Sampling
27. "Is Temperature the Creativity Parameter of LLMs?" ICCC 2024 — [computationalcreativity.net](https://computationalcreativity.net/iccc24/papers/ICCC24_paper_70.pdf)
28. "Temperature and Persona Shape LLM Agent Consensus," 2025 — [arXiv](https://arxiv.org/pdf/2507.11198)
29. "Min-p Sampling," 2024 — [arXiv](https://arxiv.org/abs/2407.01082)
30. "Verbalized Sampling," 2025 — [arXiv](https://arxiv.org/abs/2510.01171)

### Structured Output
31. "Let Me Speak Freely?" 2024 — [arXiv](https://arxiv.org/html/2408.02442v1)
32. "Does Prompt Formatting Have Any Impact?" 2024 — [arXiv](https://arxiv.org/html/2411.10541v1)
33. Improving Agents, "Best Nested Data Format" — [improvingagents.com](https://www.improvingagents.com/blog/best-nested-data-format/)
34. aider, "LLMs are bad at returning code in JSON" — [aider.chat](https://aider.chat/2024/08/14/code-in-json.html)
35. "Decoupling Task-Solving and Output Formatting," 2025 — [arXiv](https://arxiv.org/html/2510.03595v1)

### Financial and Emotional Simulation
36. "Synthesizing Behaviorally-Grounded Reasoning Chains," 2025 — [arXiv](https://arxiv.org/html/2509.14180v1)
37. "Decoding Emotion in the Deep," 2025 — [arXiv](https://arxiv.org/html/2510.04064v1)
38. "LLMs are proficient in emotional intelligence tests," PMC — [PMC](https://pmc.ncbi.nlm.nih.gov/articles/PMC12095572/)

### Social Simulation and Referral
39. Park et al., "Generative Agents," UIST 2023 — [arXiv](https://arxiv.org/abs/2304.03442)
40. Park et al., "Generative Agent Simulations of 1,000 People," 2024 — [arXiv](https://arxiv.org/abs/2411.10109)
41. Stanford HAI, "Simulating Human Behavior with AI Agents" — [hai.stanford.edu](https://hai.stanford.edu/policy/simulating-human-behavior-with-ai-agents)

### Cultural Diversity and Demographic Bias
42. "Race and Gender in LLM-Generated Personas," 2025 — [arXiv](https://arxiv.org/html/2510.21011v1)
43. "Bias and gendering in LLM-generated synthetic personas," 2025 — [ScienceDirect](https://www.sciencedirect.com/science/article/pii/S1071581925002083)
44. "Misalignment of LLM-Generated Personas in Low-Resource Settings," 2025 — [arXiv](https://arxiv.org/html/2512.02058)
45. "LLMs and Cultural Values," 2025 — [arXiv](https://arxiv.org/html/2511.03980v1)
46. "The Personality Trap: How LLMs Embed Bias," 2025 — [arXiv](https://arxiv.org/html/2602.03334v1)

### Decision Making Under Uncertainty
47. "Decision-Making Behavior Evaluation Framework," NeurIPS 2024 — [arXiv](https://arxiv.org/abs/2406.05972)
48. "Prospect Theory Fails for LLMs," 2025 — [arXiv](https://arxiv.org/html/2508.08992)
49. "LLM economicus? Mapping Behavioral Biases," OpenReview — [openreview.net](https://openreview.net/forum?id=Rx3wC8sCTJ)

### Multi-Turn and Self-Refinement
50. Madaan et al., "Self-Refine," 2023 — [arXiv](https://arxiv.org/abs/2303.17651)
51. "CRITIC: LLMs Can Self-Correct with Tool-Interactive Critiquing," 2023 — [arXiv](https://arxiv.org/abs/2305.11738)
52. Du et al., "Improving Factuality through Multiagent Debate," ICML 2024 — [arXiv](https://arxiv.org/abs/2305.14325)

### Debiasing and Sycophancy
53. "Prompting Techniques for Reducing Social Bias," RANLP 2025 — [arXiv](https://arxiv.org/html/2404.17218v4)
54. "Multi-Persona Thinking for Bias Mitigation," 2025 — [arXiv](https://arxiv.org/html/2601.15488v1)
55. "Self-Debiasing LLMs: Zero-Shot Reduction of Stereotypes," 2024 — [arXiv](https://arxiv.org/html/2402.01981v1)
56. Gupta et al., "Bias Runs Deep," ICLR 2024 — [arXiv](https://arxiv.org/abs/2311.04892)
57. MIT News, "Personalization features can make LLMs more agreeable," 2026 — [MIT News](https://news.mit.edu/2026/personalization-features-can-make-llms-more-agreeable-0218)
58. "Sycophancy in Large Language Models," 2024 — [arXiv](https://arxiv.org/html/2411.15287v1)
59. "Aligned but Stereotypical?" 2025 — [arXiv](https://arxiv.org/html/2512.04981)

### Consistency and Verification
60. "Score Before You Speak," ECAI 2025 — [arXiv](https://arxiv.org/html/2508.06886v1)
61. Yoshino, "LMT Consistency Framework," 2025 — [PhilArchive](https://philarchive.org/rec/YOSLCF)
62. "Asking LLMs to Verify First," 2025 — [arXiv](https://arxiv.org/html/2511.21734v1)
63. "Enhancing Persona Consistency via Contrastive Learning," 2025 — [ResearchGate](https://www.researchgate.net/publication/394298208)

### Scaling and Diversity
64. "Persona Generators: Generating Diverse Synthetic Personas at Scale," 2025 — [arXiv](https://arxiv.org/html/2602.03545v1)
65. Tencent, "Scaling Synthetic Data Creation with 1B Personas," 2024 — [arXiv](https://arxiv.org/abs/2406.20094)
66. "DeepPersona," 2024 — [arXiv](https://arxiv.org/abs/2511.07338)
67. "HACHIMI," 2025 — [arXiv](https://arxiv.org/html/2603.04855v2)
68. Vallinder, "Evolving Diverse Synthetic Personas," 2025 — [vallinder.se](https://vallinder.se/blog/evolving-diverse-synthetic-personas/)
69. "Population-Aligned Persona Generation," 2024 — [arXiv](https://arxiv.org/abs/2509.10127)
70. PersonaTrace, 2025 — [arXiv](https://arxiv.org/html/2603.11955)

### Synthetic User Research Validation
71. NNGroup, "Evaluating AI-Simulated Behavior," 2024 — [nngroup.com](https://www.nngroup.com/articles/ai-simulations-studies/)
72. NNGroup, "Synthetic Users: If, When, and How" — [nngroup.com](https://www.nngroup.com/articles/synthetic-users/)
73. Argyle et al., "Out of One, Many," 2023 — [Cambridge Core](https://www.cambridge.org/core/journals/political-analysis/article/abs/out-of-one-many-using-language-models-to-simulate-human-samples/035D7C8A55B237942FB6DBAD7CAA4E49)
74. PyMC Labs, "AI Synthetic Consumers Now Rival Real Surveys" — [pymc-labs.com](https://www.pymc-labs.com/blog-posts/AI-based-Customer-Research)
75. "LLMs Reproduce Human Purchase Intent via SSR," 2025 — [arXiv](https://arxiv.org/html/2510.08338v1)

### Big Five Personality and Persona Accuracy
76. PersonaLLM, NAACL 2024 — [ACL Anthology](https://aclanthology.org/2024.findings-naacl.229/)
77. Nature, "Evaluating the ability of LLMs to emulate personality," 2024 — [nature.com](https://www.nature.com/articles/s41598-024-84109-5)
78. "Evaluating LLMs for Synthetic Personas Generation," CHItaly 2025 — [ACM DL](https://dl.acm.org/doi/10.1145/3750069.3750142)

### Prompt Chaining and Workflow
79. Deepchecks, "Multi-Step LLM Chains: Best Practices" — [deepchecks.com](https://deepchecks.com/orchestrating-multi-step-llm-chains-best-practices/)
80. Prompt Engineering Guide, "Prompt Chaining" — [promptingguide.ai](https://www.promptingguide.ai/techniques/prompt_chaining)

### Meta-Prompting
81. Prompt Engineering Guide, "Meta Prompting" — [promptingguide.ai](https://www.promptingguide.ai/techniques/meta-prompting)
82. Anthropic, "Effective context engineering for AI agents" — [anthropic.com](https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents)
