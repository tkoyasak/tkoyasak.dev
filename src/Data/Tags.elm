module Data.Tags exposing (Metadata, getAllTags, getReferencedTags, metadataDecoder)

import Data.Api exposing (requestContent)
import DataSource
import Dict
import Dict.Extra as Dict
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


getReferencedTags : DataSource.DataSource (List ( String, Int ))
getReferencedTags =
    requestContent
        "posts"
        (Decoder.field "contents"
            (Decoder.list
                (Decoder.field "tags"
                    (Decoder.list (Decoder.field "name" Decoder.string))
                )
            )
        )
        |> DataSource.map List.concat
        |> DataSource.map Dict.frequencies
        |> DataSource.map Dict.toList
        |> DataSource.map (List.sortWith descendingOrder)


descendingOrder : ( a, Int ) -> ( a, Int ) -> Order
descendingOrder a b =
    case compare (Tuple.second a) (Tuple.second b) of
        LT ->
            GT

        EQ ->
            EQ

        GT ->
            LT
