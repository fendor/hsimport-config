module Main where

import qualified Language.Haskell.Exts as HS
import HsImport

type HsImportDecl = HS.ImportDecl HS.SrcSpanInfo

main :: IO ()
main = hsimport $ defaultConfig { prettyPrint = prettyPrint, findImportPos = findImportPos }
   where
      -- This is a bogus implementation of prettyPrint, because it doesn't handle the
      -- qualified import case nor does it considers any explicitely imported or hidden symbols.
      prettyPrint :: HsImportDecl -> String
      prettyPrint (HS.ImportDecl { HS.importModule = HS.ModuleName _ modName }) =
         "import " ++ modName

      -- This findImportPos implementation will always add the new import declaration
      -- at the end of the current ones. The data type ImportPos has the two constructors
      -- After and Before.
      findImportPos :: HsImportDecl -> [HsImportDecl] -> Maybe ImportPos
      findImportPos _         []             = Nothing
      findImportPos newImport currentImports = Just . After . last $ currentImports
