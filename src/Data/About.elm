module Data.About exposing (Metadata, getAbout)

import Data.Api exposing (dateDecoder, requestContent)
import DataSource
import Date exposing (Date)
import OptimizedDecoder as Decoder


type alias Metadata =
    { about : String
    , revisedAt : Date
    }


metadataDecoder : Decoder.Decoder Metadata
metadataDecoder =
    Decoder.map2 Metadata
        (Decoder.field "about" Decoder.string)
        (Decoder.field "revisedAt" dateDecoder)


getAbout : DataSource.DataSource Metadata
getAbout =
    requestContent
        "about"
        metadataDecoder
