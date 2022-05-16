module Page.Tags exposing (..)

import Data.Tags
import DataSource exposing (DataSource)
import Head
import Head.Seo as Seo
import Html.Styled as Html
import Html.Styled.Attributes as Attr
import Page exposing (Page, StaticPayload)
import Pages.PageUrl exposing (PageUrl)
import Shared
import Site
import View exposing (View)


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
    Data.Tags.getAllTags


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
        , title = "Tags | " ++ Site.title
        }
        |> Seo.website


type alias Data =
    List Data.Tags.Metadata


view :
    Maybe PageUrl
    -> Shared.Model
    -> StaticPayload Data RouteParams
    -> View Msg
view _ _ static =
    { title = "Tags"
    , body =
        [ Html.div
            [ Attr.class "tags" ]
            (List.map
                (\metadata ->
                    Html.a
                        [ Attr.class "tag"
                        , Attr.href ("/tags/" ++ metadata.name)
                        ]
                        [ Html.text ("#" ++ metadata.name) ]
                )
                static.data
            )
        ]
    }
