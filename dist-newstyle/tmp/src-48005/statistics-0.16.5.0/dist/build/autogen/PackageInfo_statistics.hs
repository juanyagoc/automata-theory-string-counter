{-# LANGUAGE NoRebindableSyntax #-}
{-# OPTIONS_GHC -fno-warn-missing-import-lists #-}
{-# OPTIONS_GHC -w #-}
module PackageInfo_statistics (
    name,
    version,
    synopsis,
    copyright,
    homepage,
  ) where

import Data.Version (Version(..))
import Prelude

name :: String
name = "statistics"
version :: Version
version = Version [0,16,5,0] []

synopsis :: String
synopsis = "A library of statistical types, data, and functions"
copyright :: String
copyright = "2009-2014 Bryan O'Sullivan"
homepage :: String
homepage = "https://github.com/haskell/statistics"
