# jlp-coding-challenge2

## Install toolchain

https://docs.haskellstack.org/en/stable/README/#how-to-install

## Building

```
$ stack build
```

## Testing

```
$ stack test

...
pennies - number of pennies in a price
  10.50 => 1050
  7 => 700
parsePrice - string to price
  10 => Price 10 Nothing
  11.02 => Price 11 (Just 2)
parseLabel - extract prices from string
  converts Was £10, then £8, then £11
  converts Was £10.23, then £8, then £11.02
formatPrice - price to string
  £23
  £23.00
  £6.02
  £0.99
toLabel - list of prices to english
  [10, 8, 6.02] => Was £10, then £8, now £6.02
fixPrices - correct prices
  10, 8, 11, 6 => 11, 6
  10, 8, 8, 6 => 10, 8, 6
  10, 6, 4, 8 => 10, 8
  10 => 10
  10, 9.50, 9 => 10, 9.50, 9
fixPriceLabel - correct prices
  Was £10, then £8, then £11, now £6 => Was £11, now £6
  Was £10, then £8, then £8, now £6 => Was £10, then £8, now £6
  Was £10, then £6, then £4, now £8 => Was £10, now £8
  Was £10, then £8, then £8, now £6 => Was £10, then £8, now £6

Finished in 0.0249 seconds
20 examples, 0 failures
```


## Running

```
$ stack exec jlp-coding-challenge2 'Was £10, then £8, then £11, now £6'
Was £11, now £6
```

## How it works

* Toolchain is `stack` with the `GHC 8.6.4` compiler
* Code under test is in `src/Challenge2.hs`
* Tests are in `test/Challenge2Spec.hs` in rspec style, including specs for helper functions
* There's also a main program in `app/Main.hs`

Represents prices as an int for the pounds and, optionally, another int for the pence. This means that £10 is distinct from £10.00, as the requirements imply but don't explicitly state.

Uses the `split` library to split the prices away from the rest of the label.

Uses the `regex-applicative` library to parse numbers into prices.

See `Challenge2Spec.hs` for more.
