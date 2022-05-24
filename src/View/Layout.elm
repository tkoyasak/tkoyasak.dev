module View.Layout exposing (pageTitle, postTags, postsList, view)

import Data.Posts
import Date
import Html exposing (Html, a, br, div, footer, h1, h2, header, li, main_, nav, p, section, span, text, ul)
import Html.Attributes exposing (class, href)
import Site


view : List (Html msg) -> Html msg
view body =
    div
        [ class "terminal container" ]
        [ navbar_
        , Html.main_ [] body
        , footer_
        ]


navbar_ : Html msg
navbar_ =
    div
        [ class "terminal-nav" ]
        [ header
            [ class "navbar-logo" ]
            [ div
                [ class "logo terminal-prompt" ]
                [ a
                    [ href "/", class "no-style" ]
                    [ text Site.title ]
                ]
            ]
        , nav
            [ class "terminal-menu" ]
            [ ul []
                [ li []
                    [ a
                        [ href "/posts", class "menu-item" ]
                        [ span [] [ text "Posts" ] ]
                    ]
                , li []
                    [ a
                        [ href "/tags", class "menu-item" ]
                        [ span [] [ text "Tags" ] ]
                    ]
                , li []
                    [ a
                        [ href "/about", class "menu-item" ]
                        [ span [] [ text "About" ] ]
                    ]
                ]
            ]
        ]


footer_ : Html msg
footer_ =
    div
        [ class "terminal-footer" ]
        [ footer []
            [ span []
                [ text "Powered by "
                , a [ href "https://elm-pages.com" ] [ text "elm-pages" ]
                , text " & "
                , a [ href "https://terminalcss.xyz" ] [ text "terminal.css" ]
                ]
            , br [] []
            , span []
                [ text "© 2022 tkoyasak" ]
            ]
        ]


pageTitle : String -> List (Html msg)
pageTitle title =
    [ header
        [ class "terminal-page-title" ]
        [ h1 [] [ text title ] ]
    , div [ class "terminal-page-title-divider" ] []
    ]


postsList : List Data.Posts.Metadata -> Html msg
postsList posts =
    section [] (List.map postItem posts)


postItem : Data.Posts.Metadata -> Html msg
postItem post =
    div
        [ class "terminal-post-item" ]
        [ a
            [ href ("/posts/" ++ post.id) ]
            [ h2 [] [ text post.title ] ]
        , postTags post
        , p [] [ text post.summary ]
        , a
            [ href ("/posts/" ++ post.id) ]
            [ text "Read more >" ]
        ]


postTags : Data.Posts.Metadata -> Html msg
postTags post =
    ul
        [ class "terminal-post-tags" ]
        (li [] [ text (Date.format "y-MM-dd |" post.publishedAt) ]
            :: List.map
                (\tag ->
                    li []
                        [ a
                            [ href ("/tags/" ++ tag.name) ]
                            [ text ("#" ++ tag.name) ]
                        ]
                )
                post.tags
        )
