module Data.Posts exposing (Metadata, getAllPosts, getPostById)

import Data.Api exposing (dateDecoder, requestContent)
import Data.Tags
import DataSource
import Date exposing (Date)
import OptimizedDecoder as Decoder


type alias Metadata =
    { id : String
    , title : String
    , tags : List Data.Tags.Metadata
    , summary : String
    , description : String
    , publishedAt : Date
    , revisedAt : Date
    }


getAllPosts : DataSource.DataSource (List Metadata)
getAllPosts =
    requestContent
        ("posts" ++ "?limit=100")
        (Decoder.field "contents" (Decoder.list metadataDecoder))


getPostById : String -> DataSource.DataSource Metadata
getPostById id =
    requestContent
        ("posts/" ++ id)
        metadataDecoder


metadataDecoder : Decoder.Decoder Metadata
metadataDecoder =
    Decoder.map7 Metadata
        (Decoder.field "id" Decoder.string)
        (Decoder.field "title" Decoder.string)
        (Decoder.field "tags" (Decoder.list Data.Tags.metadataDecoder))
        (Decoder.field "summary" Decoder.string)
        (Decoder.field "description" Decoder.string)
        (Decoder.field "publishedAt" dateDecoder)
        (Decoder.field "revisedAt" dateDecoder)
