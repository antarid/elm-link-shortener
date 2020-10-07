module Tests exposing (..)

import Expect
import Html exposing (Html)
import Html.Attributes exposing (value)
import Http
import Main exposing (Model, Msg(..), canGenerateLink, initialModel, update, view)
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


getButton : Model -> Query.Single Msg
getButton model =
    model
        |> view
        |> Query.fromHtml
        |> Query.find [ Selector.tag "button" ]


getInput : Model -> Query.Single Msg
getInput model =
    model
        |> view
        |> Query.fromHtml
        |> Query.find [ Selector.tag "input" ]


viewTest : Test
viewTest =
    describe "view test"
        [ describe "button"
            [ test "should be disabled on initialization" <|
                \_ ->
                    initialModel
                        |> getButton
                        |> Query.has [ Selector.text "generate link", Selector.disabled True ]
            , test "should be enabled when linkInputValue is a correct link" <|
                \_ ->
                    { initialModel | linkInputValue = "https://google.com" }
                        |> getButton
                        |> Query.has [ Selector.disabled False ]
            , test "should produce ClickButton action on click" <|
                \_ ->
                    { initialModel | linkInputValue = "https://google.com" }
                        |> getButton
                        |> Event.simulate Event.click
                        |> Event.expect ClickButton
            ]
        , describe "input"
            [ test "should be enabled when is not loading" <|
                \_ ->
                    { initialModel | linkInputValue = "Whatever" }
                        |> getInput
                        |> Query.has [ Selector.disabled False ]
            , test "should be disabled when is loading" <|
                \_ ->
                    { initialModel | isLoading = True, linkInputValue = "Whatever" }
                        |> getInput
                        |> Query.has [ Selector.disabled True ]
            , test "should produce ChangeLinkInput action on input" <|
                \_ ->
                    initialModel
                        |> getInput
                        |> Event.simulate (Event.input "smth")
                        |> Event.expect (ChangeLinkInput "smth")
            , test "should have value according to linkInputValue" <|
                \_ ->
                    { initialModel | linkInputValue = "value" }
                        |> getInput
                        |> Query.has [ Selector.attribute (value "value") ]
            ]
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
                        |> Expect.equal initialModel
            , test "should update model with Error result" <|
                \_ ->
                    update (GenerateLink (Err (Http.BadStatus 500))) { initialModel | isLoading = True, linkInputValue = "https://google.com" }
                        |> Tuple.first
                        |> Expect.equal initialModel
            ]
        ]
