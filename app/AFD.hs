module AFD (Automata (..), accepts, simpHopcroft) where

import Data.List (foldl') 
import qualified Data.Set as Set
import qualified Data.Map as Map

------------------------------------------------------
-- Definicion de un AFD con un alfabeto de Caracteres
------------------------------------------------------

data Automata a = Automata
  { estados  :: [a],
    alfabeto :: [Char],
    delta    :: [(a, Char, a)],
    inicial  :: a,
    finales  :: [a]
  }
  deriving (Show, Eq)

--------------------------------------------------
-- Test de aceptacion de una palabra sobre un AFD
--------------------------------------------------

accepts :: (Ord a) => Automata a -> String -> Bool
accepts a s =
  let step currStates char =
        Set.fromList
          [ nxt
          | (orig, c, nxt) <- delta a
          , c == char
          , orig `Set.member` currStates
          ]
      reached = foldl' step (Set.singleton (inicial a)) s
  in not (Set.null (Set.intersection reached (Set.fromList (finales a))))

------------------------------------------------
-- Seccion de funciones para simplificar un AFD
------------------------------------------------

type DeltaInv a = Map.Map (a, Char) (Set.Set a)
type PWconj a = (Set.Set (Set.Set a), Set.Set (Set.Set a))
--type NewDelta a = Map.Map a a

simpHopcroft :: (Ord a) => Automata a -> Automata a
simpHopcroft a = a'
  where
    a' = a { estados = newQ }
    newQ = [Set.findMin s | s <- Set.toList $ go iP iW]
    -- crear la funcion delta inversa una sola vez para reutilizarla en cada simbolo
    fDeltaInversa = calcDeltaInv (delta a)
    f        = Set.fromList (finales a)
    qSinF    = Set.difference (Set.fromList (estados a)) f
    iP       = Set.fromList $ filter (not . Set.null) [f, qSinF]
    iW       = iP
    go p w
      | Set.null w = p -- caso base cuando se vacía W
      | otherwise =
        let (s, wr)  = Set.deleteFindMin w
            (s1, s2) = foldl (procesar fDeltaInversa s) (p, wr) (alfabeto a)
        in go s1 s2

procesar :: (Ord a) => DeltaInv a -> Set.Set a -> PWconj a -> Char -> PWconj a
procesar fDeltaInversa s (p, w) a = Set.foldl' refinarBloque (p, w) p
  where
    refinarBloque (accP, accW) r =
      let la = deltaInv fDeltaInversa s a -- estados que llegan al conjunto s leyendo a
          r1 = Set.intersection r la
          r2 = Set.difference r r1
      in
        -- r tiene elementos en común con la y elementos fuera de la
        if not (Set.null r1) && not (Set.null r2) then
          -- substituir r por r1 y r2 en accP
          let newP = Set.insert r2 $ Set.insert r1 $ Set.delete r accP
              newW
                -- si r ya estaba en W lo quitamos y añadimos r1 y r2
                | r `Set.member` accW = Set.insert r1 $ Set.insert r2 $ Set.delete r accW
                -- si no podemos, entra el mas pequeño de los dos
                | Set.size r1 <= Set.size r2 = Set.insert r1 accW
                | otherwise                  = Set.insert r2 accW
          -- devolvemos los nuevos conjuntos P y W modificados
          in (newP, newW)
        -- de otra forma no hacemos cambios
        else (accP, accW)

-----------------------------------
-- Funcion de transiciones inversa
-----------------------------------

-- Construir la función de transiciones inversa para Hopcroft
calcDeltaInv :: (Ord a) => [(a, Char, a)] -> DeltaInv a
calcDeltaInv l =
  Map.fromListWith Set.union [((d, c), Set.singleton o) | (o, c, d) <- l]

-- Obtener el conjunto resultado de la funcion delta inversa
deltaInv :: (Ord a) => DeltaInv a -> Set.Set a -> Char -> Set.Set a
deltaInv dInv s o =
  Set.unions [Map.findWithDefault Set.empty (x, o) dInv | x <- Set.toList s]
