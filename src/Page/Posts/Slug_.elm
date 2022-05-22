module Page.Posts.Slug_ exposing (..)

import Data.Posts
import DataSource exposing (DataSource)
import Date
import Head
import Head.Seo as Seo
import Page exposing (Page, StaticPayload)
import Pages.PageUrl exposing (PageUrl)
import Shared
import Site
import View exposing (View)
import View.Layout
import View.Markdown


type alias Model =
    ()


type alias Msg =
    Never


type alias RouteParams =
    { slug : String }


type alias Data =
    Data.Posts.Metadata


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
    Data.Posts.getPostById route.slug
        |> DataSource.map
            (\metadata -> metadata)


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
        , description = static.data.description
        , title = static.data.title ++ " - " ++ Site.title
        }
        |> Seo.article
            { expirationTime = Nothing
            , modifiedTime = Just (Date.format "y-MM-dd" static.data.revisedAt)
            , publishedTime = Just (Date.format "y-MM-dd" static.data.publishedAt)
            , section = Nothing
            , tags = []
            }


view :
    Maybe PageUrl
    -> Shared.Model
    -> StaticPayload Data RouteParams
    -> View Never
view _ _ static =
    { title = static.data.title ++ " - " ++ Site.title
    , body =
        View.Layout.pageTitle static.data.title
            ++ [ View.Layout.postTags static.data
               , View.Markdown.toHtml static.data.description
               ]
    }
