module Data.About exposing (Metadata, getAbout)

import Data.Api exposing (requestContent)
import DataSource
import Date exposing (Date)
import OptimizedDecoder as Decoder


type alias Metadata =
    { about : String
    , revisedAt : Date
    }


getAbout : DataSource.DataSource Metadata
getAbout =
    requestContent
        "about"
        metadataDecoder


metadataDecoder : Decoder.Decoder Metadata
metadataDecoder =
    Decoder.map2 Metadata
        (Decoder.field "about" Decoder.string)
        (Decoder.field "revisedAt" dateDecoder)


dateDecoder : Decoder.Decoder Date
dateDecoder =
    Decoder.string
        |> Decoder.andThen
            (\isoString ->
                String.slice 0 10 isoString
                    |> Date.fromIsoString
                    |> Decoder.fromResult
            )
