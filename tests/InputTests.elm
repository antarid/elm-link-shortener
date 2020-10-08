module InputTests exposing (..)

import Expect
import Html exposing (Html)
import Html.Attributes exposing (attribute, value)
import Main exposing (Model, Msg(..), initialModel, view)
import Test exposing (..)
import Test.Html.Event as Event
import Test.Html.Query as Query
import Test.Html.Selector as Selector


getButton : Model -> Query.Single Msg
getButton model =
    model
        |> view
        |> Query.fromHtml
        |> Query.find [ Selector.attribute (attribute "data-testid" "generate-link-button") ]


getInput : Model -> Query.Single Msg
getInput model =
    model
        |> view
        |> Query.fromHtml
        |> Query.find [ Selector.tag "input" ]


inputTest : Test
inputTest =
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
