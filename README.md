
<script type="text/javascript" async
  src="https://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-MML-AM_CHTML">
</script>
<script type="text/x-mathjax-config">
MathJax.Hub.Config({
      tex2jax: {inlineMath: [['$','$'], ['\\(','\\)']]}
});
</script>

# Patterns in Riordan arrays

This repository collects our thesis about Riordan arrays, which is our
work to graduate at the University of Florence, defended on October 10, 2015.

Candidate: *Massimo Nocentini* (massimo.nocentini@unifi.it)<br>
Supervisor: *Donatella Merlini* (donatella.merlini@unifi.it)

## Abstract

This work aims to study a subset of objects belonging to the field of analytic
combinatorics, in particular generating functions, formal power series and
infinite lower triangular matrices. Many interesting books by Flajolet and
Sedgewick [1], Knuth [2] and Graham et al. [3] exist on those topics, where
skillful methods to handle sequences of *counting numbers*, combinatorial sums
and classes of combinatorial discrete objects, such as graphs, words, lattice
paths and trees, are presented. The concept of *Riordan array* is the core of
the present work.  We are interested to show new characterizations to spot some
properties of their structure. One example is the $h$-characterization
$\\mathcal{R}\_{h(t)}$ of a Riordan array $\\mathcal{R}$ and a second one is the
generalization of the $A$-sequence $\lbrace a_{n}\rbrace_{n\in\mathbb{N}}$ and
$A$-matrix $\lbrace a_{ij}\rbrace_{i,j\in\mathbb{N}}$ concepts.

Although *Riordan group* theory has been studied intensively in the recent
past, we would like to give an introduction with our words, rethink about the
original and introductory papers of this theory, in particular those by
*Shapiro*, who introduces the *Riordan group* and builds a combinatorial
triangle counting *non-intersecting* paths; by *Rogers*, who introduces the
concept of *renewal arrays* and finds the important concept of their
$A$-sequences; by *Eplett*, who provides an identity involving determinants and
*Catalan* numbers; and, finally, by *Sprugnoli*, who uses Riordan arrays in
order to find generating functions of combinatorial sums in a *constructive*
way, not just proving that a sum equals a *given* value (usually denoted by a
closed formula). 

The other topic of this work is the description and formalization of Riordan
arrays under the light of modular arithmetic. We have shown some congruences
about *Pascal* array $\mathcal{P}$ and its inverse $\mathcal{P}^{-1}$. We have
also proved a formal characterization for the *Catalan* array $\mathcal{C}$.
These results were presented in a talk contributed at a recent conference held
in Lecco [4]. All major researchers involved in Riordan group theory
were present and some of them threw some important ideas about possible
enhancement of our results.  

Finally, we have implemented a subset of *Riordan group theory* using the
Python programming language, on top of *Sage* mathematical framework.  Our
implementation is written in *pure object-oriented* style and allows us to do
raw matrix expansion, computing inverse arrays, applying modular
transformation, using a set of partition functions, and building LaTeX,code
for representing such modular arrays as coloured triangles.

[1] Flajolet and Sedgewick, *Analytic Combinatorics*, Cambridge University Press, 2009<br>
[2] Knuth, *The Art of Computer Programming*, vol.  1-3, Addison-Wesley, 1973<br>
[3] Graham, Knuth and Patashnik, *Concrete Mathematics*, Addison-Wesley, 1994<br>
[4] *Second International Symposium on Riordan Arrays and Related Topics*, RART2015<br>

## RART2015 and paper submission

The content about modular transformations, applied to Pascal and Catalan arrays in 
particular, was shown in a talk at [RART2015][rart2015]; moreover, a paper that
collects theorems about the Catalan triangle has been submitted.

Also, we provide an implementation to do matrix expansion of Riordan matrices
and computing inverses, symbolically; finally, the code base includes the
inductive procedure given in the paper to build the modular Catalan triangle,
choosing modulo 2, avoiding the brute force approach; for details and other
*fractal objects*, have a look in [this
notebook][inductive:catalan:triangle:nb].

[rart2015]:https://www.mate.polimi.it/RART2015/
[inductive:catalan:triangle:nb]:http://nbviewer.jupyter.org/github/massimo-nocentini/master-thesis/blob/master/modular-article/implementation/fractals-and-inductive-catalan-triangle.ipynb


