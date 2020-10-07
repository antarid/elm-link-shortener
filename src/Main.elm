port module Main exposing (Model, Msg(..), canGenerateLink, initialModel, main, update, view)

import Api exposing (..)
import Browser
import Html exposing (Html, a, button, div, input, text)
import Html.Attributes exposing (class, disabled, href, id, placeholder, style, target, value)
import Html.Events exposing (onClick, onInput)
import Http
import Json.Decode exposing (Decoder, field, string)
import Json.Encode as Encode
import Regex


bitlyApiToken =
    "f221393742452044bda6b4805a6efe9cde106c4f"


urlRegex =
    Maybe.withDefault Regex.never <|
        Regex.fromString "https?:\\/\\/(www\\.)?[-a-zA-Z0-9@:%._\\+~#=]{1,256}\\.[a-zA-Z0-9()]{1,6}\\b([-a-zA-Z0-9()@:%_\\+.~#?&//=]*)"


linkDecoder : Decoder String
linkDecoder =
    field "link" string


canGenerateLink : Model -> Bool
canGenerateLink model =
    Regex.contains urlRegex model.linkInputValue && not model.isLoading


generateLink : String -> Cmd Msg
generateLink longLink =
    Http.request
        { method = "POST"
        , expect = Http.expectJson GenerateLink linkDecoder
        , url = "https://api-ssl.bitly.com/v4/shorten"
        , headers = [ Http.header "Authorization" ("Bearer " ++ bitlyApiToken) ]
        , body =
            Encode.object [ ( "long_url", Encode.string longLink ) ]
                |> Http.jsonBody
        , timeout = Nothing
        , tracker = Nothing
        }


port sendMessage : String -> Cmd msg


type alias Model =
    { linkInputValue : String
    , isLoading : Bool
    }


initialModel =
    { isLoading = False, linkInputValue = "" }


init : () -> ( Model, Cmd msg )
init _ =
    ( initialModel, Cmd.none )


type Msg
    = ChangeLinkInput String
    | ClickButton
    | GenerateLink (Result Http.Error String)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ChangeLinkInput newLinkInputValue ->
            ( { model | linkInputValue = newLinkInputValue }, Cmd.none )

        ClickButton ->
            ( { model | isLoading = True }
            , Cmd.batch
                [ getHideLinkMessage |> sendMessage
                , generateLink model.linkInputValue
                ]
            )

        GenerateLink result ->
            case result of
                Ok link ->
                    ( initialModel, link |> getShowLinkMessage |> sendMessage )

                Err _ ->
                    ( initialModel, "Oh, something went wrong" |> getShowLinkMessage |> sendMessage )


view : Model -> Html Msg
view model =
    div [ id "elm-container" ]
        [ div [ class "input-container" ]
            [ input
                [ class "input"
                , placeholder "Enter link"
                , value model.linkInputValue
                , onInput ChangeLinkInput
                , disabled model.isLoading
                ]
                []
            , button
                [ class "button"
                , disabled (not (canGenerateLink model))
                , onClick ClickButton
                ]
                [ text "generate link" ]
            ]
        ]


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , subscriptions = subscriptions
        , view = view
        , update = update
        }
