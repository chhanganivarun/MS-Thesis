# Viva Preparation — Q&A Defense Notes

Working notes for the MS thesis defense: *Ground then Navigate: Language-guided Navigation in Dynamic Scenes*.

Not part of the LaTeX build. Lives at repo root, outside `ms_thesis_master/`.

Each entry follows the same five parts:

- **Question** — as an examiner would phrase it
- **Say first** — the actual spoken answer, two or three sentences
- **Backing** — where it is in the thesis
- **Follow-up** — the sharpest counter-question and the response
- **Concede** — the genuine limitation, stated plainly

---

## Metrics

### Are the Wilson confidence intervals from the paper?

**Say first.** No. The ICRA paper reports Task Completion as bare point estimates with no uncertainty quantification of any kind. The Wilson intervals are a thesis-only addition — I computed them post-hoc from the published success counts, because with 25 validation and 34 test episodes a single-run delta is fragile, and I did not want the 0.72 headline to stand unqualified.

**Backing.** `ICRA_2022/main.tex` contains no occurrence of "Wilson", "confidence interval", or "binomial"; Table 1 there gives TC as 0.72 / 0.68 and stops. The thesis adds `table:tc_ci` in `chapters/vln.tex` (lines 203–219), and the caption is explicit that the intervals are *derived*: "derived from binomial counts on 25 validation and 34 test episodes." Section `sec:eval_metrics` (line 130) says they were "computed from the binomial success counts implied by the point estimates," and `sec:extended_eval` (line 473) frames the whole exercise as reporting "what can be derived without re-training." The thesis never claims the paper did this.

**Follow-up — "how did you recover the counts if the paper only published percentages?"** The counts are uniquely recoverable given n. Only 18 of 25 rounds to 0.72; 17/25 = 0.68 and 19/25 = 0.76. Only 23 of 34 rounds to 0.68; 22/34 = 0.647 and 24/34 = 0.706. So the back-derivation is exact, not an estimate. Same for every other row.

**Concede.** They are intervals for a *single evaluation pass* under a binomial model. They do not capture training-seed variance, CARLA traffic randomisation, or annotator disagreement on the human TC label. The thesis says all three explicitly at line 481.

---

### What is a Wilson score interval, and why that one?

**Say first.** It is a confidence interval for a binomial proportion, obtained by inverting the score test rather than using the normal approximation to the estimate. For k successes in n trials with \(\hat p = k/n\) and z = 1.96:

\[
\text{centre} = \frac{\hat p + \frac{z^2}{2n}}{1 + \frac{z^2}{n}}, \qquad
\text{half-width} = \frac{z}{1 + \frac{z^2}{n}}\sqrt{\frac{\hat p(1-\hat p)}{n} + \frac{z^2}{4n^2}}
\]

**Why not Wald.** The textbook interval \(\hat p \pm z\sqrt{\hat p(1-\hat p)/n}\) fails badly in exactly this regime. Its actual coverage at n in the twenties and thirties is well below the nominal 95%; it can return bounds outside [0, 1]; and it collapses to zero width when \(\hat p\) is 0 or 1. Wilson is always inside [0, 1], is asymmetric (it pulls toward 0.5, which is the honest behaviour when n is small), and has far better small-sample coverage. With n = 25 and n = 34, that difference is not cosmetic.

**Worked check — CLIP-MC validation, k = 18, n = 25.** Centre = (18 + 1.9208)/28.8416 = 0.691. Half-width = (1.96/28.8416)·√(18·7/25 + 0.9604) = 0.0680 · 2.4496 = 0.166. Interval [0.52, 0.86], matching the table. Note the point estimate 0.72 sits *above* the interval centre 0.69 — that asymmetry is the Wilson shrinkage, and is worth being able to explain if asked why the interval is not centred on 0.72.

**Follow-up — "your intervals overlap, so is the main claim supported?"** Handle this directly, do not dodge. No single pairwise comparison is significant: CLIP-MC validation [0.52, 0.86] overlaps CLIP-M [0.37, 0.73] heavily, and CLIP-MC's lower bound of 0.52 is exactly the point estimate of two weaker baselines. What supports the claim is the joint pattern rather than any one interval — the test split is monotonic across the architecture ladder (CLIP-S 0.47, CLIP-SC 0.50, CLIP-M 0.55, CLIP-MC 0.68), the frame ablation is monotonic on test from n = 1 to n = 8, and Fréchet Distance and nDTW move the same direction. Several weak signals agreeing is a different kind of evidence from one strong signal, and I claim only the former.

**Concede.** The right fix is multi-seed evaluation, not better intervals on one pass. The thesis specifies the protocol at line 481: at least three training seeds, fixed spawn poses with resampled traffic, mean ± standard deviation of TC plus bootstrap CIs for path metrics. That was not run.

---

## Dataset

### Would different annotators click different regions?

**Say first.** Yes, and this is why the thesis argues Task Completion must be the primary metric rather than any trajectory-distance metric. A language command does not designate a single trajectory — it designates a *set* of valid trajectories, and the recorded demonstration is one sample from that set drawn by whichever annotator happened to run the episode.

**Do not say** "the metrics are trajectory-based, not mask-based, so click variance does not matter." This does not survive scrutiny. From `chapters/dataset.tex` line 48, the same click is inverse-projected through the camera matrices into a 3D world coordinate that becomes the goal for CARLA's local planner. The click produces the mask *and* the demonstration trajectory τ*, and ADE/FDE/Fréchet are measured against τ*. Click variance flows straight into the trajectory metrics. The thesis states this at `vln.tex` line 162: "much of the measured displacement is click-placement variance within the navigable region rather than model error."

**Backing.** `sec:metric_validity` develops the Φ(C) set argument in full. Three supporting points: the ground-truth region is a deliberately coarse 3m × 4m car-sized rectangle, so sub-rectangle jitter is largely absorbed; only the centroid of the largest connected component ever reaches the planner (line 159), so most mask disagreement is discarded downstream; and `dataset.tex` line 140 and line 145 record the process controls — observer/navigator/verifier roles rotated among annotators, with the verifier rejecting ambiguous episodes and Dr. Gandhi adjudicating hard cases.

**Concede.** The click-placement noise floor was never measured. `sec:reproducible_tc` line 509 names the exact experiment that should have been run: re-collect a subset of episodes with a second navigator under matched traffic seeds and report ADE/FDE between the two human trajectories.

---

### What is inter-annotator agreement?

**Say first.** It is the degree to which independent annotators produce the same annotation for the same item, reported as a statistic that corrects for the agreement you would get by chance alone. Its real purpose is to establish a noise ceiling: if two humans only agree to within some tolerance, then a model that reaches that tolerance is already at human level and further gains are fitting annotator idiosyncrasy rather than the task.

**The standard statistics.** Cohen's kappa for two raters on categorical labels, \(\kappa = (p_o - p_e)/(1 - p_e)\), where \(p_o\) is observed and \(p_e\) chance agreement. Fleiss' kappa generalises to more than two raters; Krippendorff's alpha handles arbitrary measurement scales and missing data. Landis and Koch's conventional bands: 0.41–0.60 moderate, 0.61–0.80 substantial, above 0.81 almost perfect.

**How it applies here — three places, three different statistics.** Kappa does *not* apply to the clicks, because they are not categorical labels. The measurement splits into:

- **Clicks and masks.** IoU or Dice between two annotators' rectangles for the same command, or Euclidean distance between their click points in world coordinates.
- **Demonstration trajectories.** ADE/FDE between two human navigators for the same command under matched traffic seeds — the "annotation noise floor" already specified by name in `sec:reproducible_tc`.
- **Task Completion.** This is the exposed one. TC is a *binary human verdict*, so Cohen's or Fleiss' kappa applies directly and straightforwardly — and `vln.tex` line 126 states plainly that "inter-rater agreement was not recorded."

**Follow-up — "so your headline number is a human judgement with unknown reliability, on 25 episodes?"** Yes, and the thesis discloses it rather than burying it. Line 165: human TC "delegates Φ(C) to a judge without recorded inter-rater agreement... The construct problem was relocated into the annotator, not solved." The verifier stage acted as an adjudication gate, which controls quality but does not produce an agreement statistic. `sec:reproducible_tc` proposes the fix — a geometric success predicate (goal arrival within radius r of the annotated final region, ordered visits to intermediate regions, zero collisions and red-light infractions) that removes the human judge from the loop entirely while still admitting multiple valid paths.

**Concede.** No agreement statistic of any kind was computed for this dataset. Kappa for TC is a few hours of work on the existing episodes and should have been done.

---

## Method

### Why segmentation and not waypoint prediction?

**Know the trap first.** The thesis does *not* formally answer this question. `sec:formal_analysis` contains a subsection titled "Why Segmentation Dominates Discrete Action Selection" — it rules out a *finite action alphabet* (FORWARD/LEFT/RIGHT/STOP) via the Hausdorff quantisation gap \(\delta = \sup_{x \in \mathcal{R}_{\text{road}}} \inf_{y \in \mathcal{R}_{\text{disc}}} \|x - y\|\). That argument has no force against continuous waypoint regression, which has no quantisation gap at all. Do not answer this question by reciting the discrete-action argument; an examiner asking about waypoints has probably noticed exactly that the formal analysis skips this comparison.

**Say first.** Because the target is set-valued, not point-valued. A command like "park between the two cars on the right" admits multiple valid goal locations, and a regression head trained under squared loss converges to the conditional *mean* of those modes — which for a bimodal target sits between the two parking spots, in the middle of the road, and is not itself a valid goal. A segmentation head models a per-pixel field, so it can place mass on several disjoint valid regions; taking the largest connected component then recovers a *mode* rather than an average.

**The connective tissue.** This is the same observation that drives the metric argument in `sec:metric_validity`: a command designates a set Φ(C), not a single element. The thesis applies that insight to the *evaluation* (hence Task Completion over ADE/FDE) but never applies it to the *output head*, which is where this question lands. Being able to state that the two arguments are the same argument in two places is the strongest available answer.

**Backing — the three points that do transfer.** From `sec:formal_analysis`, "Advantages of Grounding-First" (`vln.tex` lines 38–42):

- **Supervision density.** Each frame supplies \(O(HW)\) pixel-level targets rather than a single label. Against waypoint regression the contrast is even sharper — a waypoint gives two scalars per frame.
- **Dynamics as a prior.** The factorisation \(P(\text{controls} \mid V,P,L) = P_{\text{plan}}(\text{controls} \mid y_t, \text{state})\,P_\theta(y_t \mid V,P,L)\) puts kinematics and collision avoidance in a fixed planner. The network learns *where*, the planner learns *how*. This part is orthogonal to mask-vs-waypoint — both are grounding-first — so do not oversell it here.
- **Inspectability.** A mask shows the model's believed *extent* of navigability; a waypoint is a single dot. This is the operational basis of the interpretability contribution, not a post-hoc explanation.

**Two system-level reasons specific to this build.** The stopping rule in Algorithm 1 (`sec:live_nav`) fires when mask *area* exceeds a threshold for five consecutive predictions — area grows under perspective as the vehicle approaches. A waypoint has no area, so a separate distance or termination estimator would be needed. Second, commands routinely refer to regions not yet in frame; a thresholded probability field supports natural abstention and the confidence-band fallbacks documented in the stopping-rule evolution, whereas a point regressor always emits some point with no notion of "not yet visible."

**Lineage.** The task formulation inherits from RNR~(Rufus et al.), which `background.tex` line 194 calls "the right output type for our setting." The thesis reformulates RNR for dynamic scenes rather than replacing its output space. `background.tex` line 197 dismisses Talk2Nav-style waypoint selection as restricting manoeuvre diversity — note this is a related-work dismissal, not a controlled comparison.

**Follow-up — "you take the centroid of the largest connected component and hand the planner a single point, so you are doing waypoint prediction with extra steps."** This is the sharpest form of the question and the thesis concedes the information discard at `vln.tex` line 159: Pointing Game and Recall@k "measure a signal the closed-loop controller mostly discards — only the centroid of the largest connected component reaches the planner." The answer is that the collapse happens *at the planner interface*, after three things the mask has already done that a regressor cannot: selected a mode instead of averaging them, supplied the area that triggers stopping, and provided the dense gradient that shaped the representation during training. The output is a point; the *computation that chooses* the point is not point-based.

**Concede.** No ablation compares a mask head against a coordinate-regression head on CARLA-NAV, so the claim rests on the argument above rather than on measurement. The honest scope: naive single-point L2 regression is ruled out by mode averaging, but a modern multimodal waypoint head — mixture density, anchor set, or trajectory-set classification, as used in current end-to-end driving stacks — would sidestep that objection, and the thesis does not evaluate against one. Note also that the trajectory head \(z_t\) is itself the closest thing to waypoint prediction in the system, and it too is rendered as a dense mask, is not fed to the planner (`vln.tex` line 44), and was never ablated (line 514).

## Results

*(entries to be added)*
