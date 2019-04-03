{-# LANGUAGE BlockArguments #-}
module Challenge2Spec
where

import Test.Hspec
import Test.QuickCheck
import Control.Monad

import Challenge2

pounds l = Price l Nothing
poundsAnd l d = Price l (Just d)

spec :: Spec
spec = do
    describe "pennies - number of pennies in a price" do
        it "10.50 => 1050" $ inPennies (poundsAnd 10 50) `shouldBe` 1050
        it "7 => 700" $ inPennies (pounds 7) `shouldBe` 700

    describe "parsePrice - string to price" do
        it "10 => Price 10 Nothing" $
            parsePrice "10" `shouldBe` Just (pounds 10)
        it "11.02 => Price 11 (Just 2)" $
            parsePrice "11.02" `shouldBe` Just (poundsAnd 11 02)

    describe "parseLabel - extract prices from string" do
        it "converts Was £10, then £8, then £11" $
            parseLabel "Was £10, then £8, then £11" `shouldBe` [pounds 10, pounds 8, pounds 11]
        it "converts Was £10.23, then £8, then £11.02" $
            parseLabel "Was £10.23, then £8, then £11.02" `shouldBe` [poundsAnd 10 23, pounds 8, poundsAnd 11 2]

    describe "formatPrice - price to string" do
        it "£23" do
            formatPrice (pounds 23) `shouldBe` "£23"
        it "£23.00" do
            formatPrice (poundsAnd 23 0) `shouldBe` "£23.00"
        it "£6.02" do
            formatPrice (poundsAnd 6 2) `shouldBe` "£6.02"
        it "£0.99" do
            formatPrice (poundsAnd 0 99) `shouldBe` "£0.99"
        
    describe "toLabel - list of prices to english" $
        it "[10, 8, 6.02] => Was £10, then £8, now £6.02" $
            toLabel [pounds 10, pounds 8, poundsAnd 6 2] `shouldBe` "Was £10, then £8, now £6.02"

    describe "fixPrices - correct prices" do
        it "10, 8, 11, 6 => 11, 6" $
            fixPrices [pounds 10, pounds 8, pounds 11, pounds 6] `shouldBe`
                [pounds 11, pounds 6]
        it "10, 8, 8, 6 => 10, 8, 6" $
            fixPrices [pounds 10, pounds 8, pounds 8, pounds 6] `shouldBe`
                [pounds 10, pounds 8, pounds 6]
        it "10, 6, 4, 8 => 10, 8" $
            fixPrices [pounds 10, pounds 6, pounds 4, pounds 8] `shouldBe`
                [pounds 10, pounds 8]
        it "10 => 10" $
            fixPrices [pounds 10] `shouldBe` [pounds 10]
        it "10, 9.50, 9 => 10, 9.50, 9" $
            fixPrices [pounds 10, poundsAnd 9 50, pounds 9] `shouldBe`
                [pounds 10, poundsAnd 9 50, pounds 9]

    describe "fixPriceLabel - correct prices" do
        let examples = [
                ("Was £10, then £8, then £11, now £6","Was £11, now £6"),
                ("Was £10, then £8, then £8, now £6","Was £10, then £8, now £6"),
                ("Was £10, then £6, then £4, now £8","Was £10, now £8"),
                ("Was £10, then £8, then £8, now £6","Was £10, then £8, now £6")
                ]
        forM_ examples $ \(w,s)->
            it (w ++ " => " ++ s) $
                fixPriceLabel w `shouldBe` s
                