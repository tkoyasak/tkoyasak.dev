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
import View.Layout


type alias Model =
    ()


type alias Msg =
    Never


type alias RouteParams =
    {}


type alias Data =
    List ( String, Int )


page : Page RouteParams Data
page =
    Page.single
        { head = head
        , data = data
        }
        |> Page.buildNoState { view = view }


data : DataSource Data
data =
    Data.Tags.getUsedTags


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


view :
    Maybe PageUrl
    -> Shared.Model
    -> StaticPayload Data RouteParams
    -> View Msg
view _ _ static =
    { title = "Tags"
    , body =
        View.Layout.pageTitle "Tags"
            ++ [ Html.div
                    [ Attr.class "terminal-tags-list" ]
                    [ Html.ul []
                        (List.map
                            (\( tag, count ) ->
                                Html.li []
                                    [ Html.a
                                        [ Attr.href ("/tags/" ++ tag) ]
                                        [ Html.text ("#" ++ tag) ]
                                    , Html.text (" (" ++ String.fromInt count ++ ")")
                                    ]
                            )
                            static.data
                        )
                    ]
               ]
    }
