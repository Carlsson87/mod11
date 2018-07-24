module Mod11 exposing (calculate, verify)

{-| This library helps you create and verify numeric strings according to the Modulus 11 algorithm.


# Verify

@docs verify


# Calculate

@docs calculate

-}


{-| Verfify a numeric string with the Modulus 11 algorithm.

    verify "123456789" == True
    verify "123456780" == False
    verify "nonsense" == False

-}
verify : String -> Bool
verify str =
    Maybe.map2 (==)
        (calculate (String.dropRight 1 str))
        (List.head (String.toList (String.right 1 str)))
        |> Maybe.withDefault False


{-| Calculate the "check digit" for a numeric string.

    calculate "12345678" == Just '9'
    calculate "nonsense" == Nothing

-}
calculate : String -> Maybe Char
calculate str =
    String.split "" str
        |> List.map String.toInt
        |> List.foldl (Maybe.map2 (::)) (Just [])
        |> Maybe.map ((::) 0)
        |> Maybe.andThen calculateHelp


generateWeightList : Int -> List Int
generateWeightList length =
    List.range 0 length
        |> List.map (modBy 10 >> (+) 1)


calculateHelp : List Int -> Maybe Char
calculateHelp ints =
    List.map2 (*) ints (generateWeightList (List.length ints))
        |> List.sum
        |> modBy 11
        |> toCheckDigit
        |> Maybe.andThen (String.fromInt >> String.uncons >> Maybe.map Tuple.first)


toCheckDigit : Int -> Maybe Int
toCheckDigit int =
    if int == 0 then
        Just 0
    else if int == 1 then
        Nothing
    else
        Just (11 - int)
