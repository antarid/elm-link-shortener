module Tests exposing (..)

import Expect
import Html exposing (Html)
import Html.Attributes exposing (value)
import Http
import Main exposing (Mode(..), Model, Msg(..), canGenerateLink, initialModel, update, view)
import Test exposing (..)
import Test.Html.Event as Event
import Test.Html.Query as Query
import Test.Html.Selector as Selector



-- Check out https://package.elm-lang.org/packages/elm-explorations/test/latest to learn more about testing in Elm!


canGenerateLinkTest : Test
canGenerateLinkTest =
    describe "canGenerateLink test"
        [ test "shouldn't generate link with empty string" <|
            \_ ->
                initialModel
                    |> canGenerateLink
                    |> Expect.equal False
        , test "shouldn't generate link with wrong string" <|
            \_ ->
                { initialModel | linkInputValue = "I'm definately not a link" }
                    |> canGenerateLink
                    |> Expect.equal False
        , test "should generate link with correct string" <|
            \_ ->
                { initialModel | linkInputValue = "https://google.com" }
                    |> canGenerateLink
                    |> Expect.equal True
        , test "shouldn't retry to generate link while it's loading" <|
            \_ ->
                { initialModel | isLoading = True, linkInputValue = "https://google.com" }
                    |> canGenerateLink
                    |> Expect.equal False
        ]


updateTest : Test
updateTest =
    describe "update test"
        [ describe "ChangeLinkInput"
            [ test "should update model correctly" <|
                \_ ->
                    update (ChangeLinkInput "newValue") initialModel
                        |> Tuple.first
                        |> (\model -> model.linkInputValue)
                        |> Expect.equal "newValue"
            ]
        , describe "GenerateLink"
            [ test "should update model with Ok result" <|
                \_ ->
                    update (GenerateLink (Ok "https://shrtnd.link")) { initialModel | isLoading = True, linkInputValue = "https://google.com" }
                        |> Tuple.first
                        |> Expect.equal { initialModel | history = [ { originalLink = "https://google.com", shortenedLink = "https://shrtnd.link" } ] }
            , test "should update model with Error result" <|
                \_ ->
                    update (GenerateLink (Err (Http.BadStatus 500))) { initialModel | isLoading = True, linkInputValue = "https://google.com" }
                        |> Tuple.first
                        |> Expect.equal initialModel
            ]
        , describe "ChangeMode"
            [ test "should correctly update model" <|
                \_ ->
                    update (ChangeMode History) initialModel
                        |> Tuple.first
                        |> (\model -> model.mode)
                        |> Expect.equal History
            ]
        ]
