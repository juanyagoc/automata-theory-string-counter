module AutomataToRegexG where

import qualified Data.Map as M
import AFD
import Regex

-- Extensión del AFD para que permita regex en sus transiciones?

data EstGNFA q = NuevoInicio | NuevoFin | Original q
  deriving (Show, Eq, Ord)

type GNFA q = M.Map (EstGNFA q, EstGNFA q) Regex

inicio :: (Eq q, Ord q) => Automata q -> GNFA q
inicio aut =
  let orig =
        M.fromListWith
          rUnion
          [((Original p, Original s), Symbol c) | (p, c, s) <- delta aut]
      ini = M.singleton (NuevoInicio, Original (inicial aut)) Epsilon
      fin = M.fromList [((Original f, NuevoFin), Epsilon) | f <- finales aut]
   in M.unionsWith rUnion [orig, ini, fin]
