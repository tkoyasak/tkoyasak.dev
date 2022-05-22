module Data.Tags exposing (Metadata, getAllTags, metadataDecoder)

import Data.Api exposing (requestContent)
import DataSource
import OptimizedDecoder as Decoder


type alias Metadata =
    { id : String
    , name : String
    }


getAllTags : DataSource.DataSource (List Metadata)
getAllTags =
    requestContent
        "tags"
        (Decoder.field "contents" (Decoder.list metadataDecoder))


metadataDecoder : Decoder.Decoder Metadata
metadataDecoder =
    Decoder.map2 Metadata
        (Decoder.field "id" Decoder.string)
        (Decoder.field "name" Decoder.string)
