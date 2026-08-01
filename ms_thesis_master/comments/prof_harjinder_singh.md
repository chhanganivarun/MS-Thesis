# Chapter 1

* [x] p. 2 : T2 – last line - What is RL setting? Abbreviations must be written in full form at least once before they are used without the full form.

* [x] p.4 – first para – all the links (1,2,3,…) to the challenges take you to the end of the referred context instead of the beginning – check such links throughout the thesis. The same problem happened with the link for Ref. 63.

* [x] p. 4 : The term ‘Skip connections’ shoud be explained.

    - Explained by citation to the original residual connections paper, reworded the sentences.

* [x] p. 5: Have you written QAOA and PQC in full form once before using the abbreviation?

* [x] p.5 : last para in Sec. 1.2 : Insert ‘we’ in ‘In our PQC analysis software qLEET, build a backend a...’

* [x] Should you not be referring to this paper somewhere: https://arxiv.org/pdf/1907.00397.pdf - Variational Quantum Circuits for Deep Reinforcement Learning SAMUEL YEN-CHI CHENet al.?
    - We do RL and apply it to Variational Quantum, Quantum Circuits to do RL is beyond the scope of our interest in the papers, but I will come back to this and cite it in the future scope and uses to science section.

# Chapter 2

* [x] Chap. 2 : The words ‘Background in’ may be moved from the title of the chapter.

* [x] p.7 : Para 3 : Replace ‘we start a discussion on’ by ‘we discuss’ (there is a ‘starting’ immediately afterwards); ‘moving on’ may be replaced by ‘move on; or ‘we move on’.


* [x] p.7 : para 3 : ‘… and these subroutines are often and repeatedly used, motivating the value of performing routing as close to optimally as possible on these circuits’ – Does everyone understand what is meant by ‘ value of performing routing’ ? Work on simplifying (or elaborating) such sentences throughout the thesis.
    - This has been elaborated, other examples I will try to go through later

* [x] p.7 : para 4 : ‘Finally, we move to a didactic introduction to reinforcement learning the different settings like Value-based, Policy-based, etc.’ Some words may be missing here?

* [x] p.7 : Sec. 2.1.1 : ‘can be evolved’ – bad English. Possible alternatives : ‘evolve’ or ‘can evolve’ ;

* [x] last sentence - ‘The gate model of computation is rather familiar’ - this is ‘spoken English’ – while writing you need to be formal. This may a good place to introduce the quantum mechanical Hamiltonian, and the evolution operator.
    - English made more formal, the discussion on unitaries is moved to the next section. I am unsure what you mean by Hamitonian - Evolution operator. Unitary evolution is discussed, Hamiltonians have corresponding unitaries but that is the annealing stuff, right? (DISCUSS)

* [x] p.8 : Fig. 2.1 caption : A few words explaining crx and crz will be good.

* [x] p.8 : Eq. (2.1) : The probabilities for the outcomes are not \alpha^2 and \beta^2 – they are |\alpha^2| and |\beta^2|.

* [x] p.8 : Sec. 2.1.2 : ‘unitary gate’ should be explained. If the evolution operator is explained in Sec. 2.1.1, here the unitary property may be explained. Also, an example of an entangled state (like a Bell state) may be given here and the term may be explained.
    - Added definition of unitary, why it is so, in sec. 2.1.1

* [x] p.9 : Sec. 2.1.3 : After Eq. (2.2) : ‘Much like unitary operations on state vectors’ – you have not adequately explained anywhere before what this means.
    - added that in 2.1.1, referenced that here

* [x] p.10: Fig. 2.3 : cite the source, even if it is a rather known set of gates (Nielsen and Chuang will do).

* [x] p.10: Bulleted lines : Why ‘Grover’ and ‘Shor’s’ – be consistent. 

* [x] Before presenting this bulleted set of lines, you need to state what you are presenting – e.g., we can categorise the different algorithms into groups of the following kind…
And afterwards you state – Below we briefly describe each….

* [x] p.11 : Sec. 2.2.1.1
line 1 : ‘to search in an unordered list of size n..’ - search what?

* [x] The Problem – line 3 : replace ‘wished’ by ‘wish’ and ‘were’ by ‘are’.

* [x] Line 4 : Remove the words ‘We are told that’

* [x] Overview of the Algorithm : Remove ‘the’ from ‘ the Grover’s Algorithm’

* [x] item 2 : line 2 : ‘then the oracle that bitstring with a negative phase’ – word(s) missing.

* [x] (WONTFIX) p.12 : Eqs. (2.8) and (2.9) : mention that s goes from 0 to n-1.
    - s goes from 0 to size-of-the-subgroup - 1, but I don't think it's necessary to talk about the domain of the eigen-values because I am not too sure of the math myself. There is a different s for each of the eigenvalues, given eigenvalue we know how to identify s, we leave it to the person solving to find all eigen values and compute the domain of s.

* [x] Above Eq. (2.10) : Remove ‘Now’ from “Now we know..’

* [x] After Eq. (2.11) : Change ‘With high probability, r will be even, if it’s not we will repeat this process with a new a.’ to
‘With high probability, r is even; if it is not then we will repeat this process with a new a.’

* [x] p. 13 : line 2 : change ‘but at the moment, it demands too many qubits, and it demands that fault tolerance be implemented, which is presently infeasible’ to
‘it demands too many qubits, and that fault tolerance be implemented; these are at present infeasible’

* [x] end of para : cite a reference for HHL algorithm.

* [x] Trotterization : cite a reference. It may be better to write ‘Suzuki-Trotter decomposition’ rather than ‘Trotter decomposition’

* [x] p.14 : Sec. 2.2.2 : line 2 : change ‘presently classical competitors’ to ‘present classical competitors’

* [x] Fig. 2.4 caption : words missing at the end – incomplete sentence.

* [x] p.15 : Eq. (2.14) is not adequately explained. It is not clear why the mixer hamiltonian is X gates on all the states.

* [x] After Eq. (2.15) : ‘This has to be phrased for each problem’ – what does ‘phrased’ mean here? ‘defined’ may be a better word.

* [x] Item 4 : ‘We present’ – present or ‘repeat’ or ‘execute’?

* [x] p.16 : Other applications – line 3 : ‘ for a short span of about 3-months,..’ - when? Mention the period and cite a reference.
    - Added reference, unable to find the semidefinite programming paper, has been buried by so many that have come after it. I remember the video Prof. Farhi said this in.

* [x] p.18 : sentence before Eq. (2.23) : ‘ we can rewrite equation 2.23 as’ – How can you write 2.23 as Eq. (2.23) ? The link leads to after Eq. (2.24)!
    - The equation cited was wrong, how to rewrite is explained in the paragraph

* [x] p.19 : Eq. (2.24) : ‘ The update operation in equation 2.24..’ - this line should be ‘ The update operation is shown in EQ. 2.24…’

* [x] p.19 : Sec. 2.3.2.2.1 : line 1 : You cannot begin a sentence with ‘E.g.,’ - write it s ‘For instance, …’

* [x] p.20 : before Eq. (2.25), the reference at the end of the line is blank .
    - Added Sutton's paper on Policy Gradients theorem

* [x] p.20 : Sec. 2.3.2.3 : line 1 : The link for 2.25 is defunct.
    - It's not defunct, the reference resolves at the top of the page which doesn't make the page move a lot.

# Chapter 3

* [x] Chap. 3 : Sec. 3.2 : The first sentence is incomplete.

* [x] Fix the links to the references. Link to ref. N takes you to ref. N+1.

* [ ] (Hard to fix) Consider changing some, if not all, of the ‘will/shall’ to present tense (‘will have’ to ‘has’, etc.).

* [x] Change ‘In this article’ to ‘Here’ or ‘‘In this chapter’.

* [x] p. 30 : next to the last line : change ‘it’s’ to ‘its’. Look for such errors throughout the thesis and correct them. The term ‘it’s’ means ‘it is’ and ‘its’means ‘of it’.

* [x] Sec. 3.6 : line 1 : Change ‘In this article’ to ‘Here’ or ‘‘In this chapter’ (or, it can be removed completely). Look for such errors throughout the thesis and correct them.

* [x] After the abstract, mention in parentheses, that the work is published and cite it with reference in bibliography at the end.

# General Comments

* [x] (DISCUSS where to add what) General comment : Every chapter should have an introductory section (labeled or unlabeled). This chapter seems to jump into specific comments on ‘work’ right in para 3, that should appear much later.
    - Each chapter does have abstract+intro or direct intro. Where do I need to add content?

* [x] (DISCUSS) Generally, I advise students to cut down on verbosity in the introduction, but with you, I suggest that think of making it more reader friendly. This means you may insert a few more lines to elaborate some of the ideas. Typically, people begin with history and preliminaries, and I find that quite a torture but jumping right into the description of the work may be equally an extreme approach. I am not asking you to change the format completely - just make it more reader friendly.
    - Don't really know what to do, added the explanation of what a unitary is and stuff. Added some intro on why this is useful to science. A smoother ML/RL intro is really hard for me, and QC I know very little of.

* [x] (DISCUSS Conclusions) There is one important issue I keep forgetting to mention. 
In the first chapter there should be at least one para (100-200 words) on application of ML and quantum computing to sciences. A general discussion will suffice. This must be done because your thesis is for MS in CNS,
A sentence or two in the conclusion chapter will also be good. 
    - Intro paragraph has been added with lots of citations, conclusion I added but it feels artificial