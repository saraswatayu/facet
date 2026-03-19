# Cognitive Architectures, Simulation Methodologies, and Generation Algorithms for AI Persona Simulation

## A Research Report for Facet's Pipeline Architecture

---

## 1. COGNITIVE ARCHITECTURES FOR AGENT SIMULATION

### 1.1 Stanford Generative Agents: Memory Stream + Reflection + Planning

The foundational work by **Park et al. (2023)** at Stanford introduced the generative agents architecture with three core capabilities: **memory streams** (structured episodic records of all experiences in natural language), **reflection** (periodic synthesis of memories into higher-level abstractions and goals), and **planning** (multi-timescale plans that guide action). Perceptions feed into the memory stream, and feedback loops allow memory retrieval, which in turn enables reflection and planning before agents act. In evaluation, crowdworkers judged generative agents' interview responses as more believable than responses from humans roleplaying the same characters. Each architectural component (observation, planning, reflection) contributed critically to believability. Published at UIST '23.

**Actionable insight for Facet:** The Generate phase should give each persona a structured memory of their life experiences (financial history, past product decisions, social context) that can be retrieved and reflected upon, rather than just a flat demographic profile.

### 1.2 Cognitive Architectures for Language Agents (CoALA)

**Sumers et al. (2023)**, Princeton, proposed CoALA, drawing on cognitive science and symbolic AI to describe language agents with: **modular memory** (working memory as short-term scratchpad; long-term memory subdivided into episodic, semantic, and procedural); **structured action space** (internal actions for reasoning/retrieval, external actions for environment interaction); and a **generalized decision-making cycle** (retrieve, reason, then ground or learn). CoALA maps the decision processes of ACT-R and Soar to the observe-decide-act pattern commonly used in LLM agent design.

**Actionable insight for Facet:** Structure persona templates around CoALA's memory types: episodic (personal experiences), semantic (knowledge about the product category), and procedural (decision-making habits).

### 1.3 ACT-R and Soar Adapted for LLMs

**Cognitive design patterns** from ACT-R and Soar serve as analytical tools for organizing agentic LLM systems. Research by **Wu et al. (2025)** in the Journal of Human Factors and Ergonomics Society proposes "Cognitive LLMs" that combine LLMs with customized cognitive architecture, demonstrating that such combined systems require significantly fewer tokens than querying an LLM directly. Knowledge compilation, a core mechanism in ACT-R and Soar for problem-solving, is an emerging area for agentic LLM systems. A key paper on **"Applying Cognitive Design Patterns to General LLM Agents"** maps classical cognitive patterns to modern agent architectures.

**Actionable insight for Facet:** Implement knowledge compilation in the Plan phase by pre-computing decision heuristics for each segment rather than having every persona reason from scratch.

### 1.4 BDI (Belief-Desire-Intention) Models

BDI agents integrated with LLMs combine formal, verifiable decision-making with natural language capabilities. **BDIPrompting** integrates the BDI knowledge representation framework into prompt design, allowing agents to generate motivational and goal-directed plans proactively while offering transparency into decision rationale. The hybrid approach "Lilobot" demonstrates BDI-based training systems, and researchers recommend that LLMs should be **paired with** a structured BDI system rather than replace it. The **BDI Ontology** supports integration of symbolic reasoning within heterogeneous computational settings including LLMs and logic-based frameworks.

**Actionable insight for Facet:** Structure each persona's decision narrative around explicit beliefs (about the product/market), desires (what outcomes they want), and intentions (what they plan to do), making the reasoning chain transparent and auditable.

### 1.5 Theory of Mind Implementations

**SimToM** enhances LLMs' Theory of Mind using a two-stage process: Stage 1 identifies which information a character is aware of; Stage 2 answers questions from that character's perspective. This outperforms Zero-Shot and Chain-of-Thought prompting. **TOMA (Theory of Mind Aware agents)** uses simulation-based training to improve reasoning about mental states, leading to more strategic behavior. However, **Oguntola (2025, CMU)** found that strong literal ToM performance does not imply strong functional ToM, and most LLMs struggle with the latter.

**Actionable insight for Facet:** When generating personas, explicitly model what each persona knows and doesn't know about the product/competition, rather than giving all personas the same information set.

### 1.6 Emotional and Needs-Based Cognition

The **Emotional Cognitive Modeling Framework** incorporates desire generation and objective management for emotion alignment between LLM agents and humans. **GPLab (Zhang et al., 2026, JASSS)** models non-rational influences through an emotion system in its policy simulation framework, using memory reflection where LLMs generate high-level insights from historical memories.

**Actionable insight for Facet:** Add an emotional state layer to personas that influences their decision-making, not just rational cost-benefit analysis.

---

## 2. MULTI-AGENT INTERACTION PATTERNS

### 2.1 Social Contagion and Opinion Dynamics

The **Fusing Dynamics Equation-LLM (FDE-LLM)** algorithm aligns LLM opinion evolution with real-world social network data. Research on **LLM-based opinion dynamics** compares interactions with classical models (Bounded Confidence, Friedkin-Johnsen, DeGroot) and demonstrates effectiveness in simulating polarization and echo chambers. The **bounded confidence model** (Hegselmann-Krause) restricts agents to considering only opinions not too far from their own, while the **DeGroot model** conceptualizes opinion formation as weighted averaging of peers' opinions.

**Actionable insight for Facet:** The Weave phase should model how personas influence each other's opinions based on social proximity, not just add cross-references. Consider implementing bounded confidence where persona A only considers persona B's opinion if they're in a similar enough segment.

### 2.2 Network Effects on Adoption

Agent-based models for product adoption incorporate Theory of Planned Behavior, social influence, and structural equivalence. **AdoptAgriSim (2025)** achieves 94.2% prediction accuracy for five-year adoption intervals using a multi-objective decision mechanism balancing rational economic reasoning with social learning shaped by trust-based network structures. Key adoption drivers include word-of-mouth, social influence, entity similarity, and network effects.

**Actionable insight for Facet:** Model referral chains in the Weave phase based on trust networks and structural equivalence (people in similar positions), not just random connections.

### 2.3 Group Decision-Making and Groupthink

Agent-based models of **groupthink** show it results in low-quality decisions and inability to explore alternatives. Simulation results support using **devil's advocacy** to alleviate groupthink. **Group polarization** causes individual attitudes to become more extreme after group discussion. Process losses occur when groups discuss shared information while ignoring information available to only a few members.

**Actionable insight for Facet:** The Adversarial phase should specifically check for group polarization effects in the synthesis, where the aggregation process may have made the recommendation more extreme than warranted.

### 2.4 LLM-Based Consumer Behavior Simulation

A multi-agent framework by researchers in 2025 models consumer decisions and social dynamics, demonstrating emergent **word-of-mouth diffusion** arising organically through peer-to-peer exchanges. In a price-discount scenario, the system reveals how price incentives influence public opinion, consumer stickiness, choice shifts, and purchase reasoning. Each agent maintains a personalized memory stream for selective retrieval.

**Actionable insight for Facet:** Consider having personas naturally reference and react to other personas' choices in the Weave phase, modeling organic word-of-mouth rather than just stated preferences.

---

## 3. SEGMENT DESIGN METHODOLOGY

### 3.1 Psychographic Segmentation: VALS and AIO

The **VALS framework** segments consumers along two dimensions: resources (income, education, self-confidence) and primary motivation (ideals, achievement, self-expression), producing eight types (Innovators, Thinkers, Believers, Achievers, Strivers, Experiencers, Makers, Survivors). **AIO (Activities, Interests, Opinions)** analysis provides a more flexible, customizable framework. Best practice: use VALS for brand/upper-funnel creative strategy, but combine with behavioral and transactional segmentation for CRM decisions. Home-grown question sets tend to misclassify; use licensed instruments or state limitations.

**Actionable insight for Facet:** The Plan phase should generate segments along both motivation (VALS-style) and behavioral dimensions, not just demographics. Each segment should specify the primary motivation driving purchase decisions.

### 3.2 Jobs-to-be-Done (JTBD) Integration

JTBD focuses on what users are trying to accomplish, while personas focus on who they are. **Nielsen Norman Group** and others emphasize that customers who share similar jobs often have different demographics. JTBD-infused personas begin with job-based segments, then look for demographic patterns within. Companies integrating both frameworks outperform those using either alone.

**Actionable insight for Facet:** Structure segments around the "job" the product does for them first, then add demographic variation within each job-based segment.

### 3.3 Optimal Number of Segments

**Decision Analyst** and others note there is no universal optimal number. Key determinants: strategic usefulness, no segments smaller than 5% of sample, extent of association with other data, and activation cost (mass media favors fewer segments; email/direct can support 50+). Statistical approaches include cross-validation, penalized fit heuristics, and replicability. The number is ultimately a managerial question informed by statistics.

**Actionable insight for Facet:** Default to 4-6 segments for most studies. Provide guidance that each segment should represent at least 10-15% of the target market. Allow users to configure macro/micro segment hierarchies for deeper analysis.

---

## 4. PLAN GENERATION

### 4.1 Experimental Design for Simulations

**Latin Hypercube Sampling (LHS)** efficiently explores high-dimensional parameter spaces by ensuring every interval of every parameter is sampled exactly once. This is far more efficient than full factorial design. Nearly Orthogonal Latin Hypercubes can analyze 22 variables in as few as 129 runs. For agent-based simulations, space-filling designs maximize the minimum distance between sample points.

**Actionable insight for Facet:** Apply LHS principles to persona attribute generation: ensure the personas collectively cover the full range of each relevant attribute (income, tech-savviness, brand loyalty, etc.) without redundant combinations.

### 4.2 Population-Aligned Persona Generation

**Microsoft Research (2025)** proposed a systematic framework with three stages: seed persona mining from real social media, global distribution alignment via **importance sampling and optimal transport**, and group-specific persona construction. Stratified analyses reveal under/over-representation within intersectional subgroups, guiding iterative refinement. This approach achieves Big Five personality alignment with reference distributions.

**Actionable insight for Facet:** The Plan phase should specify target distributions for key persona attributes and verify that generated personas match those distributions, not just create diverse-sounding profiles.

### 4.3 HAG: Hierarchical Demographic Trees

**Chen et al. (2026)** introduced HAG, which formalizes population generation as a two-stage decision process: constructing a Topic-Adaptive Tree using hierarchical conditional probabilities from a World Knowledge Model (achieving macro-level distribution alignment), then instantiating and augmenting with real-world data (ensuring micro-level consistency). HAG reduces population alignment errors by 37.7% and enhances sociological consistency by 18.8% versus baselines.

**Actionable insight for Facet:** Build the segment matrix in the Plan phase as a hierarchical tree, where high-level branches are segment types and leaves are specific persona archetypes with conditional attributes.

### 4.4 Name Generation and Demographic Realism

**DeepPersona** constructs a taxonomy of 4,676 unique nodes across 12 broad categories, with each persona averaging 200-250 structured attributes. Census data provides foundational sources for realistic personas. **PersonaGen** integrates statistically-grounded personas for culturally appropriate names across 10 regions with locale-adjusted attributes.

**Actionable insight for Facet:** Ground name generation in census-derived frequency distributions for the target market's demographic composition. Avoid generating only "interesting" or unusual names.

---

## 5. PARALLEL VS. SEQUENTIAL GENERATION

### 5.1 Maintaining Diversity in Batch Generation

**Guide-to-Generation (G2)** uses three coordinated modules: a base generator for quality, a Diversity Guide for novelty, and a Dedupe Guide for suppression of repetition. In the parallel setting, these three prompts are batched into a single forward pass. A **center selection strategy** selects a representative subset of prior generations to condition the guiding modules.

**Actionable insight for Facet:** When generating personas in parallel, include a diversity guide in each prompt that references the other planned personas' key attributes (from the Plan) to prevent convergence.

### 5.2 Persona Generators at Scale

**Persona Generators (2026)** formalize persona population creation as a two-stage process: stochastic sampling along orthogonal diversity axes, followed by expansion into full persona descriptions, with a multi-objective evolutionary loop encouraging coverage maximization. Personas are generated in batches of 5-10, with previously generated personas included in context.

**Actionable insight for Facet:** Generate personas in small batches (5-10) rather than fully independently. Each batch includes summaries of already-generated personas to encourage distinctiveness.

### 5.3 Trade-offs

Parallel generation is faster but risks convergence to similar archetypes. Sequential generation allows each persona to be aware of predecessors but is slower and may create artificial dependencies. The **HACHIMI system** uses a shared whiteboard where later agents condition on earlier decisions, preventing cross-component contradictions while allowing parallelism at the module level.

**Actionable insight for Facet:** The current parallel-with-plan approach is sound. Enhance it by having the Plan phase create a sufficiently detailed "seed" for each persona that constrains key differentiating attributes, so parallel generation doesn't converge.

---

## 6. SYNTHESIS METHODOLOGY

### 6.1 Meta-Analysis Techniques

Classical meta-analysis uses two approaches: **one-stage methods** (modeling all data simultaneously while accounting for clustering) and **two-stage methods** (computing summary statistics per study, then weighted averaging). Individual Participant Data (IPD) meta-analysis is more powerful than aggregate data meta-analysis. Heterogeneity testing is critical: meta-analysis should only combine sufficiently homogeneous studies.

**Actionable insight for Facet:** The Synthesize phase should explicitly test for heterogeneity within segments before aggregating. If personas within a segment disagree strongly, report the split rather than forcing consensus.

### 6.2 Dealing with Conflicting Signals

In qualitative metasummary, frequency effect sizes (percentage of studies containing a finding) and intensity effect sizes (concentration of findings within studies) help separate signal from noise. When signals conflict, the appropriate response is to report the conflict and its potential causes, not to average it away.

**Actionable insight for Facet:** When personas within a segment split on a decision, the synthesis should report the split ratio, identify the differentiating factor, and note implications for targeting strategy.

### 6.3 When Is N Large Enough?

**Huang et al. (2025)** introduced a framework that converts LLM-simulated responses into confidence sets for population parameters, adaptively selecting simulation sample size to achieve nominal coverage guarantees. The method uses similar questions with available real results to calibrate the number of synthetic samples needed. The selected sample size reflects the "effective human population size" the LLM represents.

**Actionable insight for Facet:** 15-30 personas per study is likely sufficient for directional insights, but confidence should be explicitly stated as "synthetic N" rather than implying statistical power equivalent to human N.

---

## 7. ADVERSARIAL REVIEW / RED-TEAMING

### 7.1 Devil's Advocate Effectiveness

A meta-analysis by **Schwenk & Cosier (1990)** found devil's advocacy and dialectical inquiry produce significantly higher-quality decisions than consensus. However, the **authentic dissenter** is more effective than the assigned devil's advocate, because the assigned role struggles to offer genuinely creative alternative perspectives. A critical reviewer improved meeting decision quality by 33% (MIT Sloan Management Review). Members of devil's advocacy groups report more reevaluation of assumptions but lower acceptance of group decisions.

**Actionable insight for Facet:** The Adversarial phase should not just argue against the synthesis but present a genuinely plausible alternative recommendation with its own supporting evidence from the persona data. Use a completely fresh context (no knowledge of the synthesis reasoning) for maximum independence.

### 7.2 Pre-Mortem Analysis

The **pre-mortem technique** asks participants to imagine the decision has already failed and identify what went wrong. It overcomes reluctance to express reservations and cognitive biases like overconfidence. The technique is especially effective at surfacing risks that groupthink suppresses.

**Actionable insight for Facet:** Add a pre-mortem step to the Adversarial phase: "Imagine we followed this recommendation and it failed spectacularly. What went wrong?"

### 7.3 AI Red-Teaming Methodologies

Modern red-teaming uses threat modeling, manual testing, and automated tools like **Microsoft's PyRIT**. The **RTPE framework** uses evolutionary algorithms to automatically refine adversarial prompts. NIST ARIA conducted large-scale exercises in 2024. Key techniques: prompt mutation, prompt synthesis, and search-based generation.

**Actionable insight for Facet:** The Adversarial phase could use multiple adversarial "angles" (e.g., market skeptic, competitor advocate, risk analyst) rather than a single devil's advocate.

---

## 8. CALIBRATION AND VALIDATION

### 8.1 Backtesting LLM Predictions

**Hewitt et al. (2024, Stanford)** tested GPT-4 against 476 treatment effects from 70 pre-registered experiments involving 105,165 participants. LLM predictions correlated at r = 0.85 with measured treatment effects, and accuracy held at r = 0.90 even for unpublished studies not in the training data. However, LLMs show a "remarkable inability" to match the variation of human responses.

**Actionable insight for Facet:** Aggregate-level directional predictions are reliable; individual-level variance is systematically underestimated. Frame simulation outputs as "directional confidence" rather than precise forecasts.

### 8.2 Ground Truth Comparison

**Toubia et al. (2025)** published Twin-2K-500, a dataset of 2,058 U.S. participants across 500 questions. Their mega-study across 19 domains found digital twins capture relative heterogeneity but struggle with precise individual prediction and exhibit a **"blue-shift" bias** where richer persona descriptions paradoxically lead to more progressive, skewed outcomes.

**Actionable insight for Facet:** Be aware that richer persona backstories may actually increase liberal/progressive bias in the simulation outputs. Consider deliberately terse demographic prompts for some personas to counterbalance.

### 8.3 Confidence Interval Estimation

The **uncertainty quantification framework** by Huang et al. (2025) demonstrates that too many simulated responses produce overly narrow confidence sets with poor coverage, while too few yield excessively loose estimates. The optimal sample size depends on the discrepancy between synthetic and real populations.

**Actionable insight for Facet:** Include explicit confidence language in synthesis outputs: "High confidence (strong agreement across segments)", "Moderate confidence (majority agreement with notable dissent)", "Low confidence (split or ambiguous signals)."

### 8.4 Validation as the Central Challenge

A critical review by researchers published in **Artificial Intelligence Review (2025)** found that 15 of 35 papers on generative social simulation are validated **solely through subjective "believability"** assessments. LLM outputs exhibit exaggerated politeness, verbosity, and selection bias from training corpora. The paper argues generative ABMs occupy an ambiguous methodological space lacking both the parsimony of formal models and the empirical validity of data-driven approaches.

**Actionable insight for Facet:** Build in explicit calibration steps. Where possible, compare a subset of simulation results against known outcomes (e.g., run a simulation for a product with known market data and check alignment).

---

## 9. RECENT PAPERS (2024-2026) ON LLM-BASED SURVEY SIMULATION

### 9.1 "Out of One, Many" (Argyle et al., 2023, Political Analysis)

Proposed "silicon sampling" by conditioning GPT-3 on sociodemographic backstories from real survey participants. Demonstrated fine-grained demographic correlation in the model's "algorithmic bias," enabling accurate emulation of response distributions from various human subgroups. Extended by **Sun et al.** with "random silicon sampling" showing close mirroring of U.S. public opinion polls on political topics, but failure on non-political attitude questions.

### 9.2 "Homo Silicus" (Filippas & Horton, 2024, ACM EC)

Framed LLMs as implicit computational models of humans that can be given endowments, preferences, and information, then explored via simulation. Treatment effects estimated from LLMs and human populations were highly correlated (r = 0.85 across ~500 effects). Key limitation: sample response distributions from GPT diverge significantly from humans, being more deterministic and exhibiting liberal bias.

### 9.3 AI-Human Hybrids (Arora et al., 2025, Journal of Marketing)

Demonstrated that AI-human hybrid approaches improve marketing research efficiency. LLMs effectively create synthetic respondents for qualitative research, with quality improving through few-shot learning and RAG. Replicated a Fortune 500 food company study using GPT-4 with synthetic personas.

### 9.4 LLM Purchase Intent (PyMC Labs / Colgate, 2025)

The **Semantic Similarity Rating (SSR)** method achieved 90% correlation attainment with human product rankings across 57 real consumer surveys (9,300 human responses). The key innovation: let LLMs respond in natural text, then map to Likert scales via semantic similarity to reference anchors, rather than asking for direct numeric ratings. Synthetic consumers showed less positivity bias than human panels.

### 9.5 "Pay What LLM Wants" (2025)

Evaluated LLMs' ability to predict individual economic decisions using PWYW pricing experiments with 522 real Korean participants. While LLMs struggle with precise individual-level predictions, they demonstrate reasonable group-level behavioral tendencies.

### 9.6 Mixture-of-Personas (MoP, 2025, ACL Findings)

A probabilistic prompting method where each component is an LM agent with a persona and exemplar representing subpopulation behaviors, randomly chosen according to learned mixing weights. MoP outperforms competing methods in alignment and diversity without requiring fine-tuning.

### 9.7 SimAB (2025-2026)

Reframes A/B testing as persona-conditioned simulation. Evaluated against 47 historical A/B tests, achieving 67% overall accuracy and **83% for high-confidence cases**. Reduces feedback latency from months to minutes.

### 9.8 Persona Drift and Consistency (Abdulhai et al., 2025, NeurIPS)

Defined three automatic metrics for persona consistency: prompt-to-line, line-to-line, and Q&A consistency. Multi-turn reinforcement learning reduces inconsistency by over 55%.

### 9.9 "The Personality Trap" (2026)

Found that personas generated with more LLM creative freedom consistently produce more left-leaning, less representative results. **Anchoring personas in hard demographic tables** prevents biases and makes synthetic samples robust across models and runs.

### 9.10 Social Desirability Bias in LLMs (2025)

LLMs exhibit social desirability bias that increases in more recent models (GPT-4: 1.20 SD shift, Llama 3: 0.98 SD). **Question reformulation** is the most effective mitigation strategy. The bias is consistent across all tested models.

### 9.11 NN/g Evaluation (2024-2025)

Nielsen Norman Group found synthetic users tend to fail at capturing messy, nuanced human behavior, but digital twins built from extensive individual data show promise. Recommended using synthetic users for rapid early signals and validating critical decisions with real users.

### 9.12 DeepPersona (2025, NeurIPS)

A taxonomy of 4,676 unique attribute nodes across 12 categories. Personas average 200-250 attributes and ~1MB of narrative text. Improves personalized QA accuracy by 11.6% and narrows the gap between simulated and authentic survey responses by 31.7%.

### 9.13 AgentSociety (2025, Tsinghua)

Simulates 10,000+ agents with 5 million interactions. Demonstrates that large-scale LLM social simulation is feasible with proper infrastructure, though validation remains the central challenge.

### 9.14 Position Paper: LLM Social Simulations (Anthis et al., 2025, ICML)

Identifies five challenges: diversity, bias, sycophancy, alienness, and generalization. Argues simulations can already be used for exploratory research and theory-building. Recommends context-rich prompting and fine-tuning with social science datasets.

---

## SYNTHESIS: KEY IMPLICATIONS FOR FACET'S PIPELINE

### Plan Phase
- Use hierarchical segment trees (HAG-style) with conditional attribute distributions
- Apply Latin Hypercube Sampling principles to ensure persona attributes cover the full parameter space
- Ground segments in JTBD theory, not just demographics
- Pre-specify target distributions for key attributes and verify post-generation

### Generate Phase
- Anchor personas in hard demographic data to mitigate "personality trap" bias
- Use structured JSON for precise attributes, natural language for narrative
- Generate in small batches (5-10) with awareness of already-generated personas
- Implement BDI-structured decision narratives (explicit beliefs, desires, intentions)
- Model what each persona knows/doesn't know (SimToM-style perspective-taking)

### Weave Phase
- Model social influence using bounded confidence principles
- Create trust-based referral networks, not random connections
- Allow organic word-of-mouth dynamics to emerge
- Check for and flag convergence/deduplication issues

### Synthesize Phase
- Test for heterogeneity before aggregating within segments
- Report splits and conflicts rather than forcing consensus
- Use meta-analytic weighting (not simple averaging)
- Include explicit confidence levels with each finding

### Adversarial Phase
- Use multiple adversarial angles, not just one devil's advocate
- Include pre-mortem analysis ("imagine this recommendation failed")
- Present a genuinely plausible alternative recommendation
- Check specifically for group polarization in the synthesis

### Calibration
- Frame outputs as directional confidence, not precise forecasts
- Be aware of systematic biases: liberal skew, reduced variance, social desirability
- Where possible, backtest against known market outcomes
- Treat synthetic N as qualitatively different from human N

---

## Sources

- [Park et al. - Generative Agents: Interactive Simulacra of Human Behavior (2023)](https://arxiv.org/abs/2304.03442)
- [Sumers et al. - Cognitive Architectures for Language Agents (CoALA)](https://arxiv.org/abs/2309.02427)
- [Wu et al. - Cognitive LLMs: Integrating Cognitive Architectures and LLMs](https://journals.sagepub.com/doi/10.1177/29498732251377341)
- [Applying Cognitive Design Patterns to General LLM Agents](https://arxiv.org/html/2505.07087v2)
- [Bootstrapping Cognitive Agents with an LLM](https://arxiv.org/html/2403.00810v1)
- [BDI-LLM Integration for Reliable Human-Robot Interaction](https://www.sciencedirect.com/science/article/pii/S0952197624019304)
- [BDIPrompting for Proactive Task Planning](https://dl.acm.org/doi/10.1145/3623809.3623930)
- [Controlled Yet Natural: Hybrid BDI-LLM Conversational Agent](https://arxiv.org/html/2509.16784v1)
- [SimToM Prompting: Enhancing Theory of Mind in LLMs](https://learnprompting.org/docs/advanced/zero_shot/simtom)
- [Oguntola - Theory of Mind in Multi-Agent Systems (CMU, 2025)](https://ml.cmu.edu/research/phd-dissertation-pdfs/ioguntol_phd_mld_2025.pdf)
- [LLMs Achieve Adult Human Performance on Higher-Order ToM Tasks](https://pmc.ncbi.nlm.nih.gov/articles/PMC12808479/)
- [Emotional Cognitive Modeling Framework for LLM Agents](https://arxiv.org/html/2510.13195v1)
- [Fusing Dynamics Equation with LLM-Based Agents (Opinion Dynamics)](https://www.nature.com/articles/s41598-025-99704-3)
- [Simulating Opinion Dynamics with Networks of LLM-based Agents](https://arxiv.org/html/2311.09618v3)
- [Impact of Mindset Types on Opinion Dynamics (LLM-MAS)](https://www.sciencedirect.com/science/article/abs/pii/S0747563225001773)
- [Decoding Echo Chambers: LLM-Powered Simulations](https://arxiv.org/abs/2409.19338)
- [Agent-Based Model for Technology Adoption (ASME)](https://asmedigitalcollection.asme.org/mechanicaldesign/article/143/2/021402/1085678/)
- [AdoptAgriSim: Socio-Technical Agent-Based Model (2025)](https://www.nature.com/articles/s41598-025-27523-7)
- [VALS Framework (Wikipedia)](https://en.wikipedia.org/wiki/VALS)
- [Understanding Psychographic Segmentation](https://www.segmentationstudyguide.com/understanding-psychographic-segmentation/)
- [NN/g Personas vs. Jobs-to-Be-Done](https://www.nngroup.com/articles/personas-jobs-be-done/)
- [JTBD vs Personas: Unified Customer Understanding (thrv)](https://www.thrv.com/blog/jobs-to-be-done-vs-personas-the-ultimate-guide-to-unified-customer-understanding-in-product-development)
- [How Many Segments Are Optimal? (Decision Analyst)](http://www.decisionanalyst.com/blog/how-many-segments-are-optimal/)
- [Q Research Software: Determining Number of Segments](https://www.qresearchsoftware.com/how-to-work-out-the-number-of-segments-for-a-market-segmentation)
- [Population-Aligned Persona Generation (Microsoft, 2025)](https://arxiv.org/abs/2509.10127)
- [HAG: Hierarchical Demographic Tree-based Agent Generation (2026)](https://arxiv.org/abs/2601.05656)
- [DeepPersona: Generative Engine for Scaling Deep Synthetic Personas (NeurIPS 2025)](https://arxiv.org/abs/2511.07338)
- [Persona Generators: Generating Diverse Synthetic Personas at Scale](https://arxiv.org/html/2602.03545v1)
- [SimAB: Simulating A/B Tests with Persona-Conditioned AI Agents](https://arxiv.org/abs/2603.01024)
- [Latin Hypercube Design Tutorial (Viana, 2016)](https://onlinelibrary.wiley.com/doi/10.1002/qre.1924)
- [Efficient Nearly Orthogonal Space-Filling Experimental Designs](https://apps.dtic.mil/sti/tr/pdf/ADA406957.pdf)
- [G2: Guided Generation for Enhanced Output Diversity in LLMs](https://arxiv.org/html/2511.00432)
- [HACHIMI: Scalable Persona Generation via Orchestrated Agents](https://arxiv.org/html/2603.04855v2)
- [Cochrane Handbook: Analysing Data and Meta-Analyses](https://training.cochrane.org/handbook/current/chapter-10)
- [Meta-Analyses of Aggregate Data or IPD (Columbia)](https://www.publichealth.columbia.edu/research/population-health-methods/meta-analyses-aggregate-data-or-individual-participant-data-meta-analyses-retrospectively-and)
- [Uncertainty Quantification for LLM-Based Survey Simulations (Huang et al., 2025)](https://arxiv.org/abs/2502.17773)
- [Schwenk & Cosier - Devil's Advocate Meta-Analysis (1990)](https://www.sciencedirect.com/science/article/abs/pii/074959789090051A)
- [Pre-Mortem Technique (ISCRAM)](https://idl.iscram.org/files/veinott/2010/1049_Veinott_etal2010.pdf)
- [Why Meetings Need a Constructive Devil's Advocate (MIT Sloan)](https://sloanreview.mit.edu/article/why-meetings-need-a-constructive-devils-advocate/)
- [Groupthink Simulation: Devil's Advocacy as Preventive Measure](https://link.springer.com/article/10.1007/s42001-020-00083-8)
- [CSET: AI Red-Teaming Design: Threat Models and Tools](https://cset.georgetown.edu/article/ai-red-teaming-design-threat-models-and-tools/)
- [Hewitt et al. - Predicting Social Science Experiments Using LLMs (Stanford, 2024)](https://news.stanford.edu/stories/2025/07/ai-social-science-research-simulated-human-subjects)
- [Toubia et al. - Twin-2K-500 Dataset (Marketing Science, 2025)](https://pubsonline.informs.org/doi/10.1287/mksc.2025.0262)
- [Filippas & Horton - Homo Silicus (ACM EC, 2024)](https://arxiv.org/abs/2301.07543)
- [Argyle et al. - Out of One, Many (Political Analysis, 2023)](https://arxiv.org/abs/2209.06899)
- [Arora et al. - AI-Human Hybrids for Marketing Research (Journal of Marketing, 2025)](https://journals.sagepub.com/doi/abs/10.1177/00222429241276529)
- [PyMC Labs / SSR Method - LLMs Reproduce Human Purchase Intent](https://arxiv.org/html/2510.08338v1)
- [Pay What LLM Wants (2025)](https://arxiv.org/abs/2508.03262)
- [Mixture-of-Personas Language Models (ACL 2025)](https://arxiv.org/abs/2504.05019)
- [Anthis et al. - LLM Social Simulations Position Paper (ICML 2025)](https://arxiv.org/abs/2504.02234)
- [Validation is the Central Challenge (AI Review, 2025)](https://link.springer.com/article/10.1007/s10462-025-11412-6)
- [Abdulhai et al. - Consistently Simulating Human Personas (NeurIPS 2025)](https://arxiv.org/abs/2511.00222)
- [The Personality Trap: How LLMs Embed Bias (2026)](https://arxiv.org/html/2602.03334v1)
- [Social Desirability Bias in LLMs (PNAS Nexus, 2024)](https://academic.oup.com/pnasnexus/article/3/12/pgae533/7919163)
- [Mitigating Social Desirability Bias in Random Silicon Sampling](https://arxiv.org/html/2512.22725)
- [NN/g: Evaluating AI-Simulated Behavior (2024)](https://www.nngroup.com/articles/ai-simulations-studies/)
- [NN/g: Digital Twins: Simulating Humans with Generative AI](https://www.nngroup.com/articles/digital-twins/)
- [Assessing Reliability of Persona-Conditioned LLMs (2025)](https://arxiv.org/abs/2602.18462)
- [CHARCO: Character-Coherent Role-Playing Dialogue](https://www.mdpi.com/2078-2489/16/9/738)
- [Enhancing Persona Consistency via Contrastive Learning (ACL 2025)](https://aclanthology.org/2025.findings-acl.1344/)
- [Self-Refine: Iterative Refinement with Self-Feedback](https://selfrefine.info/)
- [Reflexion: Self-Reflection for LLM Agents](https://www.promptingguide.ai/techniques/reflexion)
- [Hu & Collier - Quantifying the Persona Effect (ACL 2024)](https://aclanthology.org/2024.acl-long.554/)
- [Ghaffarzadegan et al. - GABM Introduction and Tutorial (System Dynamics Review, 2024)](https://onlinelibrary.wiley.com/doi/abs/10.1002/sdr.1761)
- [Gao et al. - LLM-Empowered ABM Survey (Tsinghua, Nature Humanities & Social Sciences, 2024)](https://www.nature.com/articles/s41599-024-03611-3)
- [AgentSociety: Large-Scale LLM Social Simulation (Tsinghua, 2025)](https://arxiv.org/abs/2502.08691)
- [Artificial Leviathan: Social Evolution of LLM Agents (2024)](https://arxiv.org/abs/2406.14373)
- [GPLab: Generative Agent-Based Policy Simulation (JASSS, 2026)](https://www.jasss.org/29/1/6.html)
- [LLM-Based Multi-Agent System for Marketing (2025)](https://arxiv.org/abs/2510.18155)
- [BookWorld: Novels to Interactive Agent Societies](https://arxiv.org/html/2504.14538v1)
- [Specializing LLMs to Simulate Survey Responses for Global Populations](https://arxiv.org/html/2502.07068v1)
- [Verasight: Risks of LLM Imputation for Synthetic Samples](https://www.verasight.io/reports/synthetic-sampling-2)
- [NIQ: The Rise of Synthetic Respondents in Market Research](https://nielseniq.com/global/en/insights/education/2024/the-rise-of-synthetic-respondents/)
- [Persona Prompting: Temperature and Persona Shape Agent Consensus](https://arxiv.org/pdf/2507.11198)
- [Memory Mechanisms in LLM Agents (Survey)](https://www.emergentmind.com/topics/memory-mechanisms-in-llm-based-agents)
- [Position: Episodic Memory is the Missing Piece for Long-Term LLM Agents](https://arxiv.org/pdf/2502.06975)
- [Avoiding Tokenism in Inclusive Design](https://frankspillers.com/avoiding-tokenism-in-inclusive-design/)
