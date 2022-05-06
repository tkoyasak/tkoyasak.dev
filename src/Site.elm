module Site exposing (config)

import DataSource
import Head
import LanguageTag
import LanguageTag.Language
import MimeType
import Pages.Manifest as Manifest
import Pages.Url
import Path
import Route
import SiteConfig exposing (SiteConfig)


type alias Data =
    ()


config : SiteConfig Data
config =
    { data = data
    , canonicalUrl = "https://tkoyasak.dev"
    , manifest = manifest
    , head = head
    }


data : DataSource.DataSource Data
data =
    DataSource.succeed ()


head : Data -> List Head.Tag
head _ =
    [ language
    , Head.rssLink "/feed.xml"
    , Head.icon [ ( 100, 100 ) ] MimeType.Jpeg icon
    ]


manifest : Data -> Manifest.Config
manifest _ =
    Manifest.init
        { name = "So himagine imagine..."
        , description = "tkoyasak's website"
        , startUrl = Route.Index |> Route.toPath
        , icons =
            [ { src = icon
              , sizes = [ ( 100, 100 ) ]
              , mimeType = Just MimeType.Jpeg
              , purposes = [ Manifest.IconPurposeAny ]
              }
            ]
        }


language : Head.Tag
language =
    LanguageTag.Language.ja
        |> LanguageTag.build LanguageTag.emptySubtags
        |> Head.rootLanguage


icon : Pages.Url.Url
icon =
    [ "images", "icon.jpg" ]
        |> Path.join
        |> Pages.Url.fromPath
