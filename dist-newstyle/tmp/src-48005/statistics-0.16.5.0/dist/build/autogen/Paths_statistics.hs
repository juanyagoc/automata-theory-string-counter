{-# LANGUAGE CPP #-}
{-# LANGUAGE NoRebindableSyntax #-}
#if __GLASGOW_HASKELL__ >= 810
{-# OPTIONS_GHC -Wno-prepositive-qualified-module #-}
#endif
{-# OPTIONS_GHC -fno-warn-missing-import-lists #-}
{-# OPTIONS_GHC -w #-}
module Paths_statistics (
    version,
    getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where


import qualified Control.Exception as Exception
import qualified Data.List as List
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude


#if defined(VERSION_base)

#if MIN_VERSION_base(4,0,0)
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#else
catchIO :: IO a -> (Exception.Exception -> IO a) -> IO a
#endif

#else
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#endif
catchIO = Exception.catch

version :: Version
version = Version [0,16,5,0] []

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir `joinFileName` name)

getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath




bindir, libdir, dynlibdir, datadir, libexecdir, sysconfdir :: FilePath
bindir     = "/Users/juanyago/.local/share/cabal/store/ghc-9.6.7/sttstcs-0.16.5.0-611d12e6/bin"
libdir     = "/Users/juanyago/.local/share/cabal/store/ghc-9.6.7/sttstcs-0.16.5.0-611d12e6/lib"
dynlibdir  = "/Users/juanyago/.local/share/cabal/store/ghc-9.6.7/lib"
datadir    = "/Users/juanyago/.local/share/cabal/store/ghc-9.6.7/sttstcs-0.16.5.0-611d12e6/share"
libexecdir = "/Users/juanyago/.local/share/cabal/store/ghc-9.6.7/sttstcs-0.16.5.0-611d12e6/libexec"
sysconfdir = "/Users/juanyago/.local/share/cabal/store/ghc-9.6.7/sttstcs-0.16.5.0-611d12e6/etc"

getBinDir     = catchIO (getEnv "statistics_bindir")     (\_ -> return bindir)
getLibDir     = catchIO (getEnv "statistics_libdir")     (\_ -> return libdir)
getDynLibDir  = catchIO (getEnv "statistics_dynlibdir")  (\_ -> return dynlibdir)
getDataDir    = catchIO (getEnv "statistics_datadir")    (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "statistics_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "statistics_sysconfdir") (\_ -> return sysconfdir)



joinFileName :: String -> String -> FilePath
joinFileName ""  fname = fname
joinFileName "." fname = fname
joinFileName dir ""    = dir
joinFileName dir fname
  | isPathSeparator (List.last dir) = dir ++ fname
  | otherwise                       = dir ++ pathSeparator : fname

pathSeparator :: Char
pathSeparator = '/'

isPathSeparator :: Char -> Bool
isPathSeparator c = c == '/'
