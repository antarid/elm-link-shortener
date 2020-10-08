module HistoryTests exposing (..)

import Expect
import Html exposing (Html, a, button, div, input, text)
import Html.Attributes exposing (attribute, value)
import Main exposing (Mode(..), Model, Msg(..), initialModel, view)
import Test exposing (..)
import Test.Html.Event as Event
import Test.Html.Query as Query
import Test.Html.Selector as Selector


getButton : Model -> Query.Single Msg
getButton model =
    model
        |> view
        |> Query.fromHtml
        |> Query.find [ Selector.attribute (attribute "data-testid" "change-mode-button") ]


getHistory : Model -> Query.Single Msg
getHistory model =
    model
        |> view
        |> Query.fromHtml
        |> Query.find [ Selector.attribute (attribute "data-testid" "history") ]


historyTest : Test
historyTest =
    describe "history"
        [ describe "mode button"
            [ test "should produce ChangeMode action on click" <|
                \_ ->
                    initialModel
                        |> getButton
                        |> Event.simulate Event.click
                        |> Event.expect (ChangeMode History)
            ]

        -- , describe "history"
        --     [ test "should not exist when mode is Input" <|
        --         \_ ->
        --             initialModel
        --                 |> getHistory
        --                 |> Query.contains
        --                     [ a [] [ text "hello world" ] ]
        --     ]
        ]
