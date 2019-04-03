module Challenge2 where

import Text.Regex.Applicative
import Data.List.Split (wordsBy)
import Data.Char hiding (Space)
import Data.Maybe (fromMaybe, catMaybes)

data Price = Price Int (Maybe Int)
    deriving (Show, Eq)

inPennies (Price l d) = l * 100 + fromMaybe 0 d

parseLabel :: String -> [Price]
parseLabel s = catMaybes $ parsePrice <$> wordsBy (not . isPriceChar) s
    where isPriceChar c = elem c ".0123456789"

parsePrice :: String -> Maybe Price
parsePrice = match ( Price <$> num <*> (optional (sym '.' *> num)) )

num :: RE Char Int
num = read <$> (some $ psym isDigit)

fixPrices :: [Price] -> [Price]
fixPrices = reverse . fixAscendingPrices . reverse

fixAscendingPrices []                = []
fixAscendingPrices [now]             = [now]
fixAscendingPrices (now:was:wass)
    | inPennies was > inPennies now  = now : fixAscendingPrices (was:wass)
    | otherwise                      = fixAscendingPrices (now:wass)

-- fixPriceLabel "Was £10, then £8, then £11, now £6" = "Was £11, now £6"
fixPriceLabel = toLabel . fixPrices . parseLabel

formatPrice (Price l Nothing) = '£' : show l
formatPrice (Price l (Just d)) = '£' : show l ++ "." ++ formatPennies d
    where formatPennies d
            | d < 10    = '0' : show d
            | otherwise = show d

toLabel [] = []
toLabel [now] = formatThen [now]
toLabel (was:next:nexts) =
    "Was " ++ formatPrice was ++ ", " ++ formatThen (next:nexts)

formatThen [now] = "now " ++ formatPrice now
formatThen (price:prices) =
    "then " ++ formatPrice price ++ ", " ++ formatThen prices
