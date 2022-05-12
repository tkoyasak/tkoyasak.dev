module View.Markdown exposing (toHtml)

{-| This module customizes markdown rendering.

@docs toHtml

-}

import Css
import Html.Styled as Html
import Html.Styled.Attributes as Attr
import Markdown.Block as Block exposing (Block(..))
import Markdown.Html
import Markdown.Parser
import Markdown.Renderer


toHtml : String -> Html.Html msg
toHtml markdown =
    case
        markdown
            |> Markdown.Parser.parse
            |> Result.mapError (\err -> err |> List.map Markdown.Parser.deadEndToString |> String.join "\n")
            |> Result.andThen (\ast -> Markdown.Renderer.render renderer ast)
    of
        Ok content ->
            Html.div
                (Attr.class "content" :: styles)
                content

        Err err ->
            Html.div
                (Attr.class "content" :: styles)
                [ Html.text err ]


renderer : Markdown.Renderer.Renderer (Html.Html msg)
renderer =
    { heading = headingRender
    , paragraph = Html.p []
    , hardLineBreak = Html.br [] []
    , blockQuote = Html.blockquote []
    , strong = Html.strong []
    , emphasis = Html.em []
    , strikethrough = Html.del []
    , codeSpan = codeSpanRender
    , link = linkRender
    , image = imageRender
    , text = Html.text
    , unorderedList = unorderedListRender
    , orderedList = orderedListRender
    , html = Markdown.Html.oneOf []
    , codeBlock = codeBlockRender
    , thematicBreak = Html.hr [] []
    , table = Html.table []
    , tableHeader = Html.thead []
    , tableBody = Html.tbody []
    , tableRow = Html.tr []
    , tableHeaderCell = tableHeaderCellRender
    , tableCell = tableCellRender
    }


headingRender :
    { level : Block.HeadingLevel
    , rawText : String
    , children : List (Html.Html msg)
    }
    -> Html.Html msg
headingRender heading =
    case heading.level of
        Block.H1 ->
            Html.h1 [] heading.children

        Block.H2 ->
            Html.h2 [] heading.children

        Block.H3 ->
            Html.h3 [] heading.children

        Block.H4 ->
            Html.h4 [] heading.children

        Block.H5 ->
            Html.h5 [] heading.children

        Block.H6 ->
            Html.h6 [] heading.children


codeSpanRender : String -> Html.Html msg
codeSpanRender content =
    Html.code [] [ Html.text content ]


linkRender :
    { title : Maybe String
    , destination : String
    }
    -> List (Html.Html msg)
    -> Html.Html msg
linkRender link content =
    case link.title of
        Just title ->
            Html.a
                [ Attr.href link.destination
                , Attr.title title
                ]
                content

        Nothing ->
            Html.a [ Attr.href link.destination ] content


imageRender :
    { alt : String
    , src : String
    , title : Maybe String
    }
    -> Html.Html msg
imageRender image =
    case image.title of
        Just title ->
            Html.img
                [ Attr.class "image"
                , Attr.src image.src
                , Attr.alt image.alt
                , Attr.title title
                ]
                []

        Nothing ->
            Html.img
                [ Attr.src image.src
                , Attr.alt image.alt
                ]
                []


unorderedListRender :
    List (Block.ListItem (Html.Html msg))
    -> Html.Html msg
unorderedListRender items =
    let
        listItem (Block.ListItem task_ children) =
            Html.li [] (checkbox task_ :: children)

        checkbox task =
            case task of
                Block.NoTask ->
                    Html.text ""

                Block.IncompleteTask ->
                    Html.input
                        [ Attr.disabled True
                        , Attr.checked False
                        , Attr.type_ "checkbox"
                        ]
                        []

                Block.CompletedTask ->
                    Html.input
                        [ Attr.disabled True
                        , Attr.checked True
                        , Attr.type_ "checkbox"
                        ]
                        []
    in
    Html.ul [] (List.map listItem items)


orderedListRender :
    Int
    -> List (List (Html.Html msg))
    -> Html.Html msg
orderedListRender _ items =
    Html.ol [] (List.map (Html.li []) items)


codeBlockRender :
    { body : String
    , language : Maybe String
    }
    -> Html.Html msg
codeBlockRender codeBlock =
    let
        classes =
            -- Only the first word is used in the class
            case Maybe.map String.words codeBlock.language of
                Just (actualLanguage :: _) ->
                    [ Attr.class ("language-" ++ actualLanguage) ]

                _ ->
                    []
    in
    Html.pre []
        [ Html.code classes
            [ Html.text codeBlock.body
            ]
        ]


tableHeaderCellRender :
    Maybe Block.Alignment
    -> List (Html.Html msg)
    -> Html.Html msg
tableHeaderCellRender maybeAlignment =
    let
        attrs =
            maybeAlignment
                |> Maybe.map
                    (\alignment ->
                        case alignment of
                            Block.AlignLeft ->
                                "left"

                            Block.AlignCenter ->
                                "center"

                            Block.AlignRight ->
                                "right"
                    )
                |> Maybe.map Attr.align
                |> Maybe.map List.singleton
                |> Maybe.withDefault []
    in
    Html.th attrs


tableCellRender :
    Maybe Block.Alignment
    -> List (Html.Html msg)
    -> Html.Html msg
tableCellRender maybeAlignment =
    let
        attrs =
            maybeAlignment
                |> Maybe.map
                    (\alignment ->
                        case alignment of
                            Block.AlignLeft ->
                                "left"

                            Block.AlignCenter ->
                                "center"

                            Block.AlignRight ->
                                "right"
                    )
                |> Maybe.map Attr.align
                |> Maybe.map List.singleton
                |> Maybe.withDefault []
    in
    Html.td attrs


styles : List (Html.Attribute msg)
styles =
    [ Attr.css
        [ Css.property "word-wrap" "break-word"
        ]
    ]
