module Api exposing (..)


getShowLinkMessage : String -> String
getShowLinkMessage link =
    "[\"showLink\", " ++ "\"" ++ link ++ "\"]"


getHideLinkMessage : String
getHideLinkMessage =
    "[\"hideLink\"]"
