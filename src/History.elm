module History exposing (..)

import Html exposing (Html, a, div, text)
import Html.Attributes exposing (attribute, href, style, target)
import Types exposing (HistoryItem)


viewHistory : List HistoryItem -> Html msg
viewHistory links =
    links
        |> List.map
            (\link ->
                div [ attribute "data-testid" "history" ]
                    [ text link.originalLink
                    , a
                        [ href link.shortenedLink
                        , style "margin-left" "10px"
                        , target "_blank"
                        ]
                        [ text link.shortenedLink ]
                    ]
            )
        |> div []
