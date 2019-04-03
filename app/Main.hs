module Main where

import Challenge2
import System.Environment

main :: IO ()
main = do
    args <- getArgs
    mapM_ (putStrLn . fixPriceLabel) args


    