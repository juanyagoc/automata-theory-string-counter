module Main where

--import Counter ( counter )
--import Regex ( showRegex )
--import AutomataToRegex ( dfaToRegex )
import Examples
import AFD
import qualified Data.Set as Set
import Data.List


main :: IO ()
main = do
   -- putStrLn "Longitud de palabras para contar: "
   -- n <- (readLn :: IO Int)
   -- putStrLn "-> El número de palabras es"
   -- print (counter ejemplo2 n)
   -- print (showRegex (dfaToRegex ejemplo2))
   print $ simpHopcroft ejemplo4
   -- print (coefficient n (regexToRational (Concat (Star (Union (Symbol 'a') (Symbol 'b'))) (Symbol 'b'))))

-- Función para imprimir Sets legiblemente
mostrarParticion :: (Show a) => [Set.Set a] -> String
mostrarParticion p = unlines [ "{" ++ intercalate ", " (map show (Set.toList bloque)) ++ "}" 
                             | bloque <- p ]