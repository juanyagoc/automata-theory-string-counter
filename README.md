# Efficient Implementation of a String Counting Function Using Automata Theory

### Motivation
Having taken the "Automata Theory" class this past semester and complementing the course content by reading cover-to-cover "Introduction to Automata Theory, Languages, and Computation" by Hopcroft & Ullman, I thought it would be great to try implementing some of the efficient algorithms on strings mentioned in the book. I decided to use Haskell mainly because of the adequate translation between the logic of the automata procedures and functional descriptions, and because I am trying to improve the functional thinking needed to write in LaTeX and Haskell as well.

### What This Project Contains
Counting the number of words with a given length was just the main motivation to start this project. From there, I extended it to include other implementations, such as the automaton-to-regex (and vice versa) translator, and experimented with optimizations like a regex shortener. 

* [AFD.hs](app/AFD.hs): The definition of a Deterministic Finite Automaton, with functions that tell whether it accepts a string or not, and an extra simplification function.
* [Regex.hs](app/Regex.hs): The definition of a regular expression with simplification functions based on heuristics and basic structure.
* [AutomataToRegex.hs](app/AutomataToRegex.hs) & [AutomataToRegexExt.hs](app/AutomataToRegexExt.hs): The implementation of the function that translates an automaton to a regex. The `-Ext` file adds an extra capability to a DFA so it can have regexes as transition symbols.
* [Counter.hs](app/Counter.hs): The actual function to count the number of words for a given length, using the previously defined functions.
* [Examples.hs](app/Examples.hs): Contains some DFA instances from Hopcroft & Ullman's book.
* [Bench.hs](app/Bench.hs): A benchmarking system built to compare the efficiency of this implementation against large examples.

...

### Build It Yourself
...