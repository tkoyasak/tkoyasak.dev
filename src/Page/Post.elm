module Page.Post exposing (Data, Model, Msg, page)

import Data.Post
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
    {}


page : Page RouteParams Data
page =
    Page.single
        { head = head
        , data = data
        }
        |> Page.buildNoState { view = view }


data : DataSource Data
data =
    Data.Post.getAllPosts


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
        , title = "Post | " ++ Site.title
        }
        |> Seo.website


type alias Data =
    List Data.Post.Metadata


view :
    Maybe PageUrl
    -> Shared.Model
    -> StaticPayload Data RouteParams
    -> View Msg
view _ _ static =
    { title = "Post"
    , body =
        [ Html.section
            [ Attr.class "section" ]
            [ Html.div
                [ Attr.class "tile is-ancestor is-justify-content-center" ]
                [ Html.div
                    [ Attr.class "tile is-parent is-vertical is-12" ]
                    (List.map postTile static.data)
                ]
            ]
        ]
    }


postTile : Data.Post.Metadata -> Html.Html msg
postTile metadata =
    Html.a
        [ Attr.class "tile is-child box"
        , Attr.href ("/post/" ++ metadata.id)
        ]
        [ Html.div
            [ Attr.class "is-size-5" ]
            [ Html.text metadata.title ]
        , Html.div
            [ Attr.class "has-text-grey-light" ]
            [ Html.text (Date.format "y-MM-dd" metadata.publishedAt) ]
        , Html.br [] []
        , View.Markdown.toHtml metadata.summary
        ]
