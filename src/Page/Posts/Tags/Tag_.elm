module Page.Posts.Tags.Tag_ exposing (..)

import Data.Posts
import Data.Tags
import DataSource exposing (DataSource)
import Date
import Head
import Head.Seo as Seo
import Html.Styled as Html
import Html.Styled.Attributes as Attr
import Page exposing (Page, StaticPayload)
import Pages.PageUrl exposing (PageUrl)
import Shared
import Site
import View exposing (View)
import View.Markdown


type alias Model =
    ()


type alias Msg =
    Never


type alias RouteParams =
    { tag : String }


page : Page RouteParams Data
page =
    Page.prerender
        { data = data
        , routes = routes
        , head = head
        }
        |> Page.buildNoState { view = view }


data : RouteParams -> DataSource.DataSource Data
data route =
    let
        entries =
            Data.Posts.getAllPosts
                |> DataSource.map
                    (\allPosts ->
                        List.filter
                            (\post ->
                                List.member route.tag
                                    (List.map
                                        (\tag -> tag.name)
                                        post.tags
                                    )
                            )
                            allPosts
                    )

        target =
            DataSource.succeed route.tag
    in
    DataSource.map2 Data entries target


routes : DataSource (List RouteParams)
routes =
    Data.Tags.getAllTags
        |> DataSource.map
            (List.map (\metadata -> { tag = metadata.name }))


head :
    StaticPayload Data RouteParams
    -> List Head.Tag
head _ =
    Seo.summary
        { canonicalUrlOverride = Nothing
        , siteName = Site.title
        , image =
            { url = Site.iconUrl
            , alt = Site.title ++ " icon"
            , dimensions = Nothing
            , mimeType = Nothing
            }
        , description = Site.description
        , locale = Nothing
        , title = "Posts | " ++ Site.title
        }
        |> Seo.website


type alias Data =
    { entries : List Data.Posts.Metadata, tag : String }


view :
    Maybe PageUrl
    -> Shared.Model
    -> StaticPayload Data RouteParams
    -> View Msg
view _ _ static =
    { title = "Posts"
    , body =
        [ Html.div
            [ Attr.class "tile is-ancestor is-justify-content-center" ]
            [ Html.div
                [ Attr.class "tile is-parent is-12" ]
                (List.map postTile static.data.entries)
            ]
        ]
    }


postTile : Data.Posts.Metadata -> Html.Html msg
postTile metadata =
    Html.a
        [ Attr.class "tile is-child box"
        , Attr.href ("/posts/" ++ metadata.id)
        ]
        [ Html.div
            [ Attr.class "is-size-5" ]
            [ Html.text metadata.title ]
        , Html.div
            [ Attr.class "has-text-grey-light" ]
            [ Html.text (Date.format "y-MM-dd" metadata.publishedAt) ]
        , Html.div
            [ Attr.class "tags" ]
            (List.map
                (\tagdata ->
                    Html.text ("#" ++ tagdata.name)
                )
                metadata.tags
            )
        , View.Markdown.toHtml metadata.summary
        ]