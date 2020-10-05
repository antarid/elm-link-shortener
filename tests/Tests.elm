module Tests exposing (..)

import Expect
import Main exposing (canGenerateLink)
import Test exposing (..)



-- Check out https://package.elm-lang.org/packages/elm-explorations/test/latest to learn more about testing in Elm!


canGenerateLinkTest : Test
canGenerateLinkTest =
    describe "canGenerateLink"
        [ test "Shouldn't generate link with empty string" <|
            \_ ->
                Expect.equal False (canGenerateLink { generatedLink = "", isLoading = False, linkInputValue = "" })
        , test "Shouldn't generate link with wrong string" <|
            \_ ->
                Expect.equal False (canGenerateLink { generatedLink = "", isLoading = False, linkInputValue = "I'm definately not a link" })
        , test "Should generate link with correct string" <|
            \_ ->
                Expect.equal True (canGenerateLink { generatedLink = "", isLoading = False, linkInputValue = "https://google.com" })
        , test "Shouldn't retry to generate link while it's loading" <|
            \_ ->
                Expect.equal False (canGenerateLink { generatedLink = "", isLoading = True, linkInputValue = "https://google.com" })
        ]
