module View.Layout exposing (view)

import Css
import Css.Global exposing (global)
import Html.Styled as Html
import Html.Styled.Attributes as Attr
import Html.Styled.Events as Evt
import Site


view :
    { a
        | showMenu : Bool
        , onOpenMenu : msg
        , onCloseMenu : msg
    }
    -> List (Html.Html msg)
    -> Html.Html msg
view config body =
    Html.div
        []
        [ global
            [ Css.Global.body
                [ Css.fontFamilies [ Css.qt "Fira Mono", Css.qt "monospace" ] ]
            ]
        , navbar_ config
        , Html.main_ []
            [ Html.section
                [ Attr.class "section" ]
                [ Html.div
                    [ Attr.class "container is-max-desktop" ]
                    body
                ]
            ]
        , footer_
        ]


navbar_ :
    { a
        | showMenu : Bool
        , onOpenMenu : msg
        , onCloseMenu : msg
    }
    -> Html.Html msg
navbar_ config =
    let
        menuState =
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
    Html.nav
        [ Attr.class "navbar" ]
        [ Html.div
            [ Attr.class "container is-max-desktop" ]
            [ Html.div
                [ Attr.class "navbar-brand" ]
                [ Html.a
                    [ Attr.class "navbar-item is-size-4 has-text-weight-bold", Attr.href "/" ]
                    [ Html.text Site.title ]
                , Html.div
                    [ Attr.class ("navbar-burger burger" ++ menuState)
                    , Attr.attribute "aria-expanded" "false"
                    , Attr.attribute "data-target" "navMenu"
                    , Evt.onClick menuMsg
                    ]
                    [ Html.span [] []
                    , Html.span [] []
                    , Html.span [] []
                    ]
                ]
            , Html.div
                [ Attr.class ("navbar-menu" ++ menuState), Attr.id "navMenu" ]
                [ Html.div
                    [ Attr.class "navbar-end" ]
                    [ Html.a
                        [ Attr.class "navbar-item", Attr.href "/post" ]
                        [ Html.text "Post" ]
                    , Html.a
                        [ Attr.class "navbar-item", Attr.href "/about" ]
                        [ Html.text "About" ]
                    ]
                ]
            ]
        ]


footer_ : Html.Html msg
footer_ =
    Html.footer
        [ Attr.class "footer has-background-white" ]
        [ Html.div
            [ Attr.class "container is-max-desktop" ]
            [ Html.div
                [ Attr.class "content has-text-right has-text-grey" ]
                [ Html.p []
                    [ Html.text "Powered by "
                    , Html.a [ Attr.href "https://elm-pages.com" ] [ Html.text "elm-pages" ]
                    , Html.text " & "
                    , Html.a [ Attr.href "https://bulma.io" ] [ Html.text "bulma" ]
                    , Html.text ". Source is "
                    , Html.a [ Attr.href "https://github.com/tkoyasak/tkoyasak.dev" ] [ Html.text "here" ]
                    , Html.text "."
                    , Html.br [] []
                    , Html.text "© 2022 tkoyasak"
                    ]
                ]
            ]
        ]
