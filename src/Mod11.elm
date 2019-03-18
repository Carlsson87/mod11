module Mod11 exposing
    ( Error(..)
    , hasValidCheckDigit
    , calculateCheckDigit
    )

{-|


# Problems

@docs Error


# Validating

@docs hasValidCheckDigit


# Constructing

@docs calculateCheckDigit

-}


{-| The Modulus 11 algorithm works on sequences of digits, but since boths lists and integers
can represent values that are invalid in this context there are some cases that will result in
errors.
-}
type Error
    = NumbersOutOfRange
    | EmptySequence
    | InvalidMod11Number


{-| Check if the last digit in a sequence of digits is a valid check
digit for the sequence according to the Modulus 11 algorithm.

    hasValidCheckDigit [3, 2, 4, 5, 5, 8] == Ok True

    hasValidCheckDigit [ -2, 3 4 ] == Err NumbersOutOfRange

    hasValidCheckDigit [] == Err EmptySequence

    hasValidCheckDigit [0, 0, 0] = Err InvalidMod11Number

-}
hasValidCheckDigit : List Int -> Result Error Bool
hasValidCheckDigit numbers =
    case List.reverse numbers of
        [] ->
            Err EmptySequence

        head :: tail ->
            calculateCheckDigit (List.reverse tail)
                |> Result.map ((==) head)


{-| Calculate the "check digit" for a given sequence of digits.

    calculateCheckDigit [ 1, 2, 3 ] == Ok 6

    calculateCheckDigit [ 1, 2, 30 ] == Err NumbersOutOfRange

-}
calculateCheckDigit : List Int -> Result Error Int
calculateCheckDigit numbers =
    if List.isEmpty numbers then
        Err EmptySequence

    else if List.all isSingleDigit numbers then
        List.reverse numbers
            |> (::) 0
            |> List.indexedMap applyWeight
            |> List.sum
            |> toCheckDigit

    else
        Err NumbersOutOfRange


isSingleDigit : Int -> Bool
isSingleDigit n =
    n >= 0 && n <= 9


toCheckDigit : Int -> Result Error Int
toCheckDigit num =
    case 11 - remainderBy 11 num of
        10 ->
            Err InvalidMod11Number

        11 ->
            Ok 0

        n ->
            Ok n


applyWeight : Int -> Int -> Int
applyWeight index num =
    (modBy 10 index + 1) * num
