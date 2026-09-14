import Criterion.Main
import AFD (Automata (..), simpHopcroft)

-- Creamos un autómata de prueba grande para poner a prueva las funciones
automataGrande :: Int -> Automata Int
automataGrande n = Automata
  { estados  = [1..n]
  , alfabeto = ['a', 'b']
  , delta    = [ (i, 'a', if even i then 1 else i) | i <- [1..n] ] ++
               [ (i, 'b', min n (i + 1)) | i <- [1..n] ]
  , inicial  = 1
  , finales  = [ i | i <- [1..n], i `mod` 5 == 0 ]
  }

main :: IO ()
main = do
  let aut100   = automataGrande 100
  let aut1000  = automataGrande 1000
  let aut10000 = automataGrande 10000

  defaultMain [
    bgroup "Hopcroft Minimization" [
      bench "100 estados"   $ nf simpHopcroft aut100
    , bench "1000 estados"  $ nf simpHopcroft aut1000
    , bench "10000 estados" $ nf simpHopcroft aut10000
    ]
    ]
