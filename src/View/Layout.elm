module View.Layout exposing (pageTitle, postTags, postsList, view)

import Css.Global
import Css.Reset
import Data.Posts
import Date
import Html.Styled as Html
import Html.Styled.Attributes as Attr
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
        [ Attr.class "terminal container" ]
        [ Css.Global.global Css.Reset.normalize
        , navbar_ config
        , Html.main_ [] body
        , footer_
        ]


navbar_ :
    { a
        | showMenu : Bool
        , onOpenMenu : msg
        , onCloseMenu : msg
    }
    -> Html.Html msg
navbar_ _ =
    Html.div
        [ Attr.class "terminal-nav" ]
        [ Html.header
            [ Attr.class "navbar-logo" ]
            [ Html.div
                [ Attr.class "logo terminal-prompt" ]
                [ Html.a
                    [ Attr.href "/", Attr.class "no-style" ]
                    [ Html.text Site.title ]
                ]
            ]
        , Html.nav
            [ Attr.class "terminal-menu" ]
            [ Html.ul []
                [ Html.li []
                    [ Html.a
                        [ Attr.href "/posts", Attr.class "menu-item" ]
                        [ Html.span [] [ Html.text "Posts" ] ]
                    ]
                , Html.li []
                    [ Html.a
                        [ Attr.href "/tags", Attr.class "menu-item" ]
                        [ Html.span [] [ Html.text "Tags" ] ]
                    ]
                , Html.li []
                    [ Html.a
                        [ Attr.href "/about", Attr.class "menu-item" ]
                        [ Html.span [] [ Html.text "About" ] ]
                    ]
                ]
            ]
        ]


footer_ : Html.Html msg
footer_ =
    Html.div
        [ Attr.class "terminal-footer" ]
        [ Html.footer []
            [ Html.span []
                [ Html.text "Powered by "
                , Html.a [ Attr.href "https://elm-pages.com" ] [ Html.text "elm-pages" ]
                , Html.text " & "
                , Html.a [ Attr.href "https://terminalcss.xyz" ] [ Html.text "terminal.css" ]
                ]
            , Html.br [] []
            , Html.span []
                [ Html.text "© 2022 tkoyasak" ]
            ]
        ]


pageTitle : String -> List (Html.Html msg)
pageTitle title =
    [ Html.header
        [ Attr.class "terminal-page-title" ]
        [ Html.h1 [] [ Html.text title ] ]
    , Html.div [ Attr.class "terminal-page-title-divider" ] []
    ]


postsList : List Data.Posts.Metadata -> Html.Html msg
postsList posts =
    Html.section [] (List.map postItem posts)


postItem : Data.Posts.Metadata -> Html.Html msg
postItem post =
    Html.div
        [ Attr.class "terminal-post-item" ]
        [ Html.a
            [ Attr.href ("/posts/" ++ post.id) ]
            [ Html.h2 [] [ Html.text post.title ] ]
        , postTags post
        , Html.p [] [ Html.text post.summary ]
        , Html.a
            [ Attr.href ("/posts/" ++ post.id) ]
            [ Html.text "Read more >" ]
        ]


postTags : Data.Posts.Metadata -> Html.Html msg
postTags post =
    Html.ul
        [ Attr.class "terminal-post-tags" ]
        (Html.li [] [ Html.text (Date.format "y-MM-dd |" post.publishedAt) ]
            :: List.map
                (\tag ->
                    Html.li []
                        [ Html.a
                            [ Attr.href ("/tags/" ++ tag.name) ]
                            [ Html.text ("#" ++ tag.name) ]
                        ]
                )
                post.tags
        )
