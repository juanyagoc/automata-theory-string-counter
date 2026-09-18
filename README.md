# Efficient Implementation of a String Counting Function Using Automata Theory

### Motivation
Having taken the "Automata Theory" class this past semester and complementing the course content by reading cover-to-cover "Introduction to Automata Theory, Languages, and Computation" by Hopcroft & Ullman, I thought it would be great to try implementing some of the efficient algorithms on strings mentioned in the book. I decided to use Haskell mainly because of the adequate translation between the logic of the automata procedures and functional descriptions, and because I am trying to improve the functional thinking needed to write in LaTeX and Haskell as well.

### What This Project Contains
Counting the number of words with a given length was just the main motivation to start this project. From there, I extended it to include other implementations, such as the automaton-to-regex (and vice versa) translator, and experimented with optimizations like a regex shortener. 

* [AFD.hs](app/AFD.hs): The definition of a Deterministic Finite Automaton, with functions that tell whether it accepts a string or not, and an extra simplification function.
* [Regex.hs](app/Regex.hs): The definition of a regular expression with simplification functions based on heuristics and basic structure.
* [AutomataToRegex.hs](app/AutomataToRegex.hs) & [AutomataToRegexExt.hs](app/AutomataToRegexExt.hs): The implementation of the function that translates an automaton to a regex. The `-Ext` ended file adds an extra capability to a DFA so it can have regexes as transition symbols.
* [Counter.hs](app/Counter.hs): The actual function to count the number of words for a given length, using the previously defined functions.
* [Examples.hs](app/Examples.hs): Contains some DFA instances from Hopcroft & Ullman's book.
* [Bench.hs](app/Bench.hs): A benchmarking system built to compare the efficiency of this implementation against large examples.

### Build It Yourself

After cloning this repository, you can run the project by executing `cabal run` inside the project folder. 

Make sure you have the right tools installed:
* **GHCup** (Haskell & packages installer)
* **GHC** (Haskell compiler)
* **Cabal** (Project & package manager for Haskell)

If you have worked with Haskell before, you likely have these already installed. If not, you can install the complete environment by executing:

```bash
curl --proto '=https' --tlsv1.2 -sSf [https://get-ghcup.haskell.org](https://get-ghcup.haskell.org) | sh
```
Follow the installation instructions provided by the script (restarting your terminal might be required), and then you are ready to execute `cabal run`

### Explanation folder

This project contains a useful resource if you are trying to learn what's going on in the code, especially if you are taking an "Automata Theory" class. The `explicacion` folder contains the LaTeX code and the generated PDF explaining the motivation behind every main function in the project, along with a hint of the theory behind it. To dive deeper, I recommend reading Hopcroft & Ullman's marvelous book, more precisely chapters *(insert chapters)*.

### Benchmarking

To test the efficiency of my implementation, I used `Criterion`, a powerful Haskell library to perform all kinds of measurements. Running `Bench.hs`—which you can do yourself with `cabal bench`—will generate a new `report.html` file, overwriting the existing one. Open it with your preferred browser to visualize the complete benchmarking results for the main functions.
