module Regex (Regex(..), rUnion, rConcat, star, showRegex, simplify) where

-- Definición de Regex
data Regex
    = Empty              -- La expresión vacía
    | Epsilon            -- La palabra nula
    | Symbol Char        -- Un símbolo
    | Union Regex Regex  -- Una unión
    | Concat Regex Regex -- Una concatenación
    | Star Regex         -- La clausura estrella
    deriving (Show, Eq)  -- Permite imprimirse y compararse


-- Unión de dos regex
rUnion :: Regex -> Regex -> Regex
rUnion Empty r = r
rUnion r Empty = r
rUnion r s | r == s = r
rUnion (Concat r1 r2) (Concat r3 r4)
    | r1 == r3  = rConcat r1 (rUnion r2 r4)
rUnion (Concat r1 r2) (Concat r3 r4)
    | r2 == r4  = rConcat (rUnion r1 r3) r2
rUnion (Concat r1 r2) r3
    | r1 == r3  = rConcat r1 (rUnion r2 Epsilon)
rUnion r1 (Concat r2 r3)
    | r1 == r2  = rConcat r1 (rUnion Epsilon r3)
rUnion (Concat r1 r2) r3
    | r2 == r3  = rConcat (rUnion r1 Epsilon) r2
rUnion r1 (Concat r2 r3)
    | r1 == r3  = rConcat (rUnion Epsilon r2) r1
rUnion r1 (Concat (Star r2) r3)
    | r1 == r3  = rConcat (star r2) r3
    | otherwise = Union r1 (Concat (Star r2) r3)
rUnion (Concat (Star r2) r3) r1
    | r1 == r3 = rConcat (star r2) r3
rUnion r1 (Concat r2 (Star r3))
    | r1 == r2 && r2 == r3 = rConcat r2 (star r3)
rUnion (Concat r2 (Star r3)) r1
    | r1 == r2 && r2 == r3 = rConcat r2 (star r3)
rUnion (Star r) Epsilon = star r
rUnion Epsilon (Star r) = star r
rUnion (Star r) s | r == s = star r
rUnion s (Star r) | r == s = star r
rUnion r s = Union r s

-- Concatenación dos regex
rConcat :: Regex -> Regex -> Regex
rConcat Empty _ = Empty
rConcat _ Empty = Empty
rConcat Epsilon x = x
rConcat x Epsilon = x
rConcat (Star r) (Star s)
    | r == s = star r
rConcat (Star r) (Star (Star s))
    | r == s = star r
rConcat (Star (Star r)) (Star s)
    | r == s = star r
rConcat (Union Epsilon r1) (Star (Union Epsilon r2))
    | r1 == r2 = star r1
rConcat (Star (Union Epsilon r1)) (Union Epsilon r2)
    | r1 == r2 = star r1
rConcat (Union Epsilon r1) (Star r2)
    | r1 == r2 = star r1
rConcat (Star r2) (Union Epsilon r1)
    | r1 == r2 = star r1
rConcat r s = Concat r s

-- Operador estrella de Kleene
star :: Regex -> Regex
star Empty = Epsilon
star Epsilon = Epsilon
star (Star r) = Star r
star (Union Epsilon r) = star r
star (Union r Epsilon) = star r
star (Concat r Epsilon) = star r
star (Concat Epsilon r) = star r
star r = Star r

-- Definir cómo mostrar una regex
showRegex :: Regex -> String
showRegex Empty = "∅"
showRegex Epsilon = "E"
showRegex (Symbol c) = [c]
showRegex (Union r s) = "(" ++ showRegex r ++ "+" ++ showRegex s ++ ")"
showRegex (Concat r s) = showRegex r ++ showRegex s
showRegex (Star (Concat r s)) = "(" ++ showRegex (Concat r s) ++ ")*"
showRegex (Star r) = showRegex r ++ "*"
-- podría hacer falta poner paréntesis (r)*
-- showRegex (Star r) = "(" ++ showRegex r ++ ")*"

-- Función que simplifica una expresión regular de forma básica
simplify :: Regex -> Regex
simplify Empty = Empty
simplify Epsilon = Epsilon
simplify (Symbol c) = Symbol c
simplify (Star r) = star (simplify r)
simplify (Concat r1 r2) = rConcat (simplify r1) (simplify r2)
simplify (Union r1 r2) = rUnion (simplify r1) (simplify r2)
