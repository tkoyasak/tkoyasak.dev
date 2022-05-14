module Data.Post exposing (ArticleMetadata, getAllPosts, getPostById)

import Data.Api exposing (requestContent)
import DataSource
import Date exposing (Date)
import OptimizedDecoder as Decoder


type alias ArticleMetadata =
    { id : String
    , title : String
    , summary : String
    , description : String
    , publishedAt : Date
    , revisedAt : Date
    }


getAllPosts : DataSource.DataSource (List ArticleMetadata)
getAllPosts =
    requestContent
        ("posts" ++ "?limit=100")
        (Decoder.field "contents" (Decoder.list articleMetadataDecoder))


getPostById : String -> DataSource.DataSource ArticleMetadata
getPostById id =
    requestContent
        ("posts/" ++ id)
        articleMetadataDecoder


articleMetadataDecoder : Decoder.Decoder ArticleMetadata
articleMetadataDecoder =
    Decoder.map6 ArticleMetadata
        (Decoder.field "id" Decoder.string)
        (Decoder.field "title" Decoder.string)
        (Decoder.field "summary" Decoder.string)
        (Decoder.field "description" Decoder.string)
        (Decoder.field "publishedAt" dateDecoder)
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
