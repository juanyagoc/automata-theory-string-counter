module Counter (counter) where

import AFD (Automata (..))
import Data.List (elemIndex, transpose)
import qualified Data.Maybe

-- Cuenta el número exacto de palabras de longitud n aceptadas por el
-- autómata mediante la matriz de transición.
--
-- M es la matriz |Q|x|Q| donde M_ij = número de símbolos que llevan
-- del estado i al estado j. Entonces M^n_ij es el número de caminos
-- etiquetados de longitud n de i a j. Para un AFD cada palabra crea
-- a lo sumo un camino, así que sumar M^n_{q0,f} sobre los estados
-- finales f cuenta palabras distintas y no caminos repetidos.
counter :: (Eq a) => Automata a -> Int -> Integer
counter aut n =
    let qs    = estados aut
        size  = length qs
        idx x = Data.Maybe.fromMaybe (error "estado fuera de Q") (elemIndex x qs)
        -- M_ij: cuántos símbolos van del estado i-ésimo al j-ésimo
        -- Forma M contando las tripletas de la función delta del automata
        -- que van desde i hasta j para todos los estados i y j
        m = [ [ toInteger (length [ () | (p, _, s) <- delta aut
                                       , p == qs !! i, s == qs !! j ])
              | j <- [0 .. size - 1] ]
            | i <- [0 .. size - 1] ]
        mn = matPow size m n
        i0 = idx (inicial aut)
    -- Suma todas las entradas de M^n que lleven desde el estado inicial
    -- a cualquiera de los finales
    in sum [ (mn !! i0) !! idx f | f <- finales aut ]


-- Producto de matrices de enteros.
matMul :: [[Integer]] -> [[Integer]] -> [[Integer]]
matMul a b =
    let bt = transpose b
    in [ [ sum (zipWith (*) row col) | col <- bt ] | row <- a ]


matPow :: Int -> [[Integer]] -> Int -> [[Integer]]
matPow size _ 0 = identity size
matPow size m k
    | even k    = let h = matPow size m (k `div` 2) in matMul h h
    | otherwise = matMul m (matPow size m (k - 1))


-- Matriz identidad de tamaño size.
identity :: Int -> [[Integer]]
identity size =
    [ [ if i == j then 1 else 0 | j <- [0 .. size - 1] ]
    | i <- [0 .. size - 1] ]
