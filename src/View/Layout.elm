module View.Layout exposing (view)

import Html.Styled exposing (a, div, footer, main_, nav, p, span, text)
import Html.Styled.Attributes exposing (attribute, class, href, id)
import Html.Styled.Events exposing (onClick)
import Site exposing (config)


view :
    { a
        | showMenu : Bool
        , onOpenMenu : msg
        , onCloseMenu : msg
    }
    -> List (Html.Styled.Html msg)
    -> Html.Styled.Html msg
view config body =
    div
        []
        [ navbar_ config
        , main_ [] body
        , footer_
        ]


navbar_ :
    { a
        | showMenu : Bool
        , onOpenMenu : msg
        , onCloseMenu : msg
    }
    -> Html.Styled.Html msg
navbar_ config =
    let
        state =
            if config.showMenu then
                " is-active"

            else
                " burger"

        menuMsg =
            if config.showMenu then
                config.onCloseMenu

            else
                config.onOpenMenu
    in
    nav
        [ class "navbar" ]
        [ div
            [ class "navbar-brand" ]
            [ a
                [ class "navbar-item", href "/" ]
                [ text Site.title ]
            , div
                [ class ("navbar-burger burger" ++ state)
                , attribute "aria-expanded" "false"
                , attribute "data-target" "navMenu"
                , onClick menuMsg
                ]
                [ span [] []
                , span [] []
                , span [] []
                ]
            ]
        , div
            [ class ("navbar-menu" ++ state), id "navMenu" ]
            [ div
                [ class "navbar-end" ]
                [ a
                    [ class "navbar-item", href "/blog" ]
                    [ text "Blog" ]
                , a
                    [ class "navbar-item", href "/about" ]
                    [ text "About" ]
                ]
            ]
        ]


footer_ : Html.Styled.Html msg
footer_ =
    footer
        [ class "footer" ]
        [ div
            [ class "content has-text-centered" ]
            [ p [] [ text "© 2022 tkoyasak" ] ]
        ]
