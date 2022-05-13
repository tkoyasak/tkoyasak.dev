module Cms exposing (ArticleMetadata, getAllPosts, getPostById)

import DataSource
import DataSource.Http
import Date exposing (Date)
import OptimizedDecoder as Decoder
import Pages.Secrets as Secrets


microCmsApi : String
microCmsApi =
    "https://tkoyasak.microcms.io/api/v1/"


getInMicroCms : String -> Decoder.Decoder a -> DataSource.DataSource a
getInMicroCms query =
    DataSource.Http.request
        (Secrets.succeed
            (\apiKey ->
                { url = microCmsApi ++ query
                , method = "GET"
                , headers = [ ( "X-MICROCMS-API-KEY", apiKey ) ]
                , body = DataSource.Http.emptyBody
                }
            )
            |> Secrets.with "API_KEY"
        )


contentsDecoder : Decoder.Decoder a -> Decoder.Decoder (List a)
contentsDecoder decoder =
    Decoder.field "contents" (Decoder.list decoder)


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
    getInMicroCms
        ("posts" ++ "?limit=100")
        (contentsDecoder articleMetadataDecoder)


getPostById : String -> DataSource.DataSource ArticleMetadata
getPostById id =
    getInMicroCms
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
