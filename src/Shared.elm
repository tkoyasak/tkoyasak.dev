module Shared exposing (Data, Model, Msg(..), SharedMsg(..), template)

import Browser.Navigation
import DataSource
import Element exposing (..)
import Element.Border as Border
import Element.Font as Font
import Element.Region as Region
import Html exposing (Html)
import Pages.Flags
import Pages.PageUrl exposing (PageUrl)
import Path exposing (Path)
import Route exposing (Route)
import SharedTemplate exposing (SharedTemplate)
import Site
import View exposing (View)


template : SharedTemplate Msg Model Data msg
template =
    { init = init
    , update = update
    , view = view
    , data = data
    , subscriptions = subscriptions
    , onPageChange = Just OnPageChange
    }


type Msg
    = OnPageChange
        { path : Path
        , query : Maybe String
        , fragment : Maybe String
        }
    | SharedMsg SharedMsg


type alias Data =
    ()


type SharedMsg
    = NoOp


type alias Model =
    { showMobileMenu : Bool
    }


init :
    Maybe Browser.Navigation.Key
    -> Pages.Flags.Flags
    ->
        Maybe
            { path :
                { path : Path
                , query : Maybe String
                , fragment : Maybe String
                }
            , metadata : route
            , pageUrl : Maybe PageUrl
            }
    -> ( Model, Cmd Msg )
init _ _ _ =
    ( { showMobileMenu = False }
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnPageChange _ ->
            ( { model | showMobileMenu = False }, Cmd.none )

        SharedMsg _ ->
            ( model, Cmd.none )


subscriptions : Path -> Model -> Sub Msg
subscriptions _ _ =
    Sub.none


data : DataSource.DataSource Data
data =
    DataSource.succeed ()


view :
    Data
    ->
        { path : Path
        , route : Maybe Route
        }
    -> Model
    -> (Msg -> msg)
    -> View msg
    -> { body : Html msg, title : String }
view _ _ _ _ pageView =
    { body =
        layout
            [ Font.family
                [ Font.external
                    { name = "Fira Mono"
                    , url = "https://fonts.googleapis.com/css2?family=Fira+Mono&display=swap"
                    }
                ]
            , width (fill |> minimum 700)
            ]
            (column [ width fill ]
                [ navbar
                , body pageView.body
                , footer
                ]
            )
    , title = pageView.title
    }


navbar : Element msg
navbar =
    row
        [ Region.navigation
        , Border.shadow { blur = 7, size = 1, offset = ( 0, 0 ), color = rgba 0 0 0 0.2 }
        , width fill
        , height (px 60)
        , paddingXY 30 10
        ]
        [ image
            [ width (px 42)
            , height (px 42)
            , Border.rounded 50
            , clip
            ]
            { src = "/images/icon.jpg"
            , description = "icon"
            }
        , link
            [ Font.bold
            , paddingXY 10 0
            ]
            { url = "/"
            , label = text Site.title
            }
        , menu
        ]


menu : Element msg
menu =
    row
        [ alignRight
        , spacing 40
        ]
        [ link [] { url = "/blog", label = text "Blog" }
        , link [] { url = "/about", label = text "About" }
        ]


body : List (Element msg) -> Element msg
body =
    column
        [ Region.mainContent
        , width fill
        , paddingXY 100 40
        ]


footer : Element msg
footer =
    wrappedRow
        [ Region.footer
        , Font.color (rgba 0 0 0 0.5)
        , centerX
        ]
        [ text "© 2022 tkoyasak"
        ]
