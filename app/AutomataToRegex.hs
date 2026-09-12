module AutomataToRegex ( dfaToRegex ) where

import qualified Data.Map as M
import AFD
import Regex
import Data.List ( sortOn )

-- Mapea una 3-tupla (est_inicial, est_resultante, # de saltos)
-- con una expresión regular
type Table q = M.Map (q, q, Int) Regex 

-- Paso Base del algoritmo de Kleene
casoBase :: (Eq q, Ord q) => Automata q -> Table q
casoBase aut =
    let base i j =
            -- Encuentra para cada par de estados i,j todos los simbolos
            -- que llevan de i a j y los pone en una lista syms
            let syms = [Symbol a | (p, a, s) <- delta aut, p == i, s == j]
                unir = foldr rUnion Empty syms
                eps = if i == j then Epsilon else Empty
            in rUnion eps unir
    -- Para cada 3-tupla (i,j,0) le asigna el conjunto syms calculado
    -- lo hace para todos los pares de estados del automata
    in M.fromList [((i, j, 0), base i j) | i <- estados aut, j <- estados aut]


-- Implementacion del algoritmo de Kleene (Hopcroft y Ullman)
-- R(i,j,k) = R(i,j,k-1) u (R(i,qk,k-1) R(qk,qk,k-1)* R(qk,j,k-1))
extendR :: (Ord q) => [q] -> Table q -> Int -> Table q
extendR qs prev k =
  let qk = (!!) qs (k - 1)
   in M.fromList
        [ ( (i, j, k),
            rUnion
              (prev M.! (i, j, k - 1))
              ( rConcat
                  ( rConcat
                      (prev M.! (i, qk, k - 1))
                      (star (prev M.! (qk, qk, k - 1)))
                  )
                  (prev M.! (qk, j, k - 1))
              )
          )
          | i <- qs,
            j <- qs
        ]


-- Ejecuta el algoritmo de Kleene y une todos los resultados para cada estado final
dfaToRegex :: (Eq q, Ord q) => Automata q -> Regex
dfaToRegex aut =
    let noSortqs = estados aut
        -- Eurística de optimizacion por eliminación de estados con menor peso primero
        qs       = sortOn (stateWeight aut) noSortqs
        inicio   = inicial aut
        finales' = finales aut
        n        = length qs
        r0       = casoBase aut -- el caso base
        table    = foldl (extendR qs) r0 [1 .. n] -- los demás a partir del caso base
    in foldr rUnion Empty [table M.! (inicio, f, n) | f <- finales'] -- une todos


-- Calculo del peso de los estados para aplicar la euristica de ordenacion de la lista
stateWeight :: (Eq q) => Automata q -> q -> Int
stateWeight aut q =
    let inEdges  = length [() | (_, _, d) <- delta aut, d == q]
        outEdges = length [() | (o, _, _) <- delta aut, o == q]
    in inEdges * outEdges
