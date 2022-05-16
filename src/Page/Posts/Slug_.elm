module Page.Posts.Slug_ exposing (..)

import Data.Posts
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
    { slug : String }


page : Page RouteParams Data
page =
    Page.prerender
        { data = data
        , routes = routes
        , head = head
        }
        |> Page.buildNoState { view = view }


data : RouteParams -> DataSource Data
data route =
    DataSource.map
        (\metadata -> { metadata = metadata })
        (Data.Posts.getPostById route.slug)


routes : DataSource (List RouteParams)
routes =
    Data.Posts.getAllPosts
        |> DataSource.map
            (List.map (\post -> { slug = post.id }))


head : StaticPayload Data RouteParams -> List Head.Tag
head static =
    Seo.summary
        { canonicalUrlOverride = Nothing
        , siteName = Site.title
        , image =
            { url = Site.iconUrl
            , alt = Site.title ++ " icon"
            , dimensions = Nothing
            , mimeType = Nothing
            }
        , locale = Nothing
        , description = static.data.metadata.description
        , title = static.data.metadata.title ++ " - " ++ Site.title
        }
        |> Seo.article
            { expirationTime = Nothing
            , modifiedTime = Just (Date.format "y-MM-dd" static.data.metadata.revisedAt)
            , publishedTime = Just (Date.format "y-MM-dd" static.data.metadata.publishedAt)
            , section = Nothing
            , tags = []
            }


type alias Data =
    { metadata : Data.Posts.Metadata }


view :
    Maybe PageUrl
    -> Shared.Model
    -> StaticPayload Data RouteParams
    -> View Never
view _ _ static =
    { title = static.data.metadata.title ++ " - " ++ Site.title
    , body =
        [ Html.h1
            [ Attr.class "title has-text-centered" ]
            [ Html.text static.data.metadata.title ]
        , Html.div
            [ Attr.class "has-text-grey-light has-text-centered" ]
            [ Html.text (Date.format "y-MM-dd" static.data.metadata.publishedAt) ]
        , Html.div
            [ Attr.class "tags is-justify-content-center" ]
            (List.map
                (\tagdata ->
                    Html.a
                        [ Attr.class "tag"
                        , Attr.href ("/posts/tags/" ++ tagdata.name)
                        ]
                        [ Html.text ("#" ++ tagdata.name) ]
                )
                static.data.metadata.tags
            )
        , Html.br [] []
        , View.Markdown.toHtml static.data.metadata.description
        ]
    }
