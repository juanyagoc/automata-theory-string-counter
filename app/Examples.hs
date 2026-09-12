module Examples where

import AFD ( Automata(..) )

-- Ejemplos de AFDs con el alfabeto binario {a, b}

-- paralbas que terminan en 'bb'
ejemplo1 :: Automata String
ejemplo1 = Automata {
    estados  = ["q0","q1","q2"],
    alfabeto = ['a','b'],
    delta    = [("q0",'a',"q0"),
                ("q0",'b',"q1"),
                ("q1",'a',"q0"),
                ("q1",'b',"q2"),
                ("q2",'a',"q0"),
                ("q2",'b',"q2")],
    inicial  = "q0",
    finales  = ["q2"]
}

-- palabras que terminan en 'b'
ejemplo2 :: Automata String
ejemplo2 = Automata {
    estados  = ["q0","q1"],
    alfabeto = ['a','b'],
    delta    = [("q0",'a',"q0"),
                ("q0",'b',"q1"),
                ("q1",'a',"q0"),
                ("q1",'b',"q1")],
    inicial  = "q0",
    finales  = ["q1"]
}

-- palabras de la forma (ab)*
ejemplo3 :: Automata String
ejemplo3 = Automata {
    estados  = ["q0", "q1", "q2"],
    alfabeto = ['a', 'b'],
    delta    = [("q0", 'a', "q1"),
                ("q0", 'b', "q2"),
                ("q1", 'a', "q2"),
                ("q1", 'b', "q0"),
                ("q2", 'a', "q2"),
                ("q2", 'b', "q2")],
    inicial = "q0",
    finales = ["q0"]
}

-- ejemplo simplificación Hopcroft & Ullman pg.163
ejemplo4 :: Automata String
ejemplo4 = Automata {
    estados  = ["a","b","c", "d", "e", "f", "g", "h"],
    alfabeto = ['0', '1'],
    delta    = [("a", '0', "b"),
                ("a", '1', "f"),
                ("b", '0', "g"),
                ("b", '1', "c"),
                ("c", '0', "a"),
                ("c", '1', "c"),
                ("d", '0', "c"),
                ("d", '1', "g"),
                ("e", '0', "h"),
                ("e", '1', "f"),
                ("f", '0', "c"),
                ("f", '1', "g"),
                ("g", '0', "g"),
                ("g", '1', "e"),
                ("h", '0', "g"),
                ("h", '1', "c")],
    inicial = "a",
    finales = ["c"]
}

-- ejemploRegex = Union ((Symbol 'a') (Concat (Star (Symbol 'b')) (Symbol 'a')))
