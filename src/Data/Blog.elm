module Data.Blog exposing (ArticleMetadata, getAllPosts, getPostById)

import DataSource
import DataSource.Http
import Date exposing (Date)
import OptimizedDecoder as Decoder
import Pages.Secrets as Secrets


blogApi : String
blogApi =
    "https://tkoyasak.microcms.io/api/v1/"


requestContents :
    String
    -> Decoder.Decoder a
    -> DataSource.DataSource a
requestContents query =
    DataSource.Http.request
        (Secrets.succeed
            (\apiKey ->
                { url = blogApi ++ query
                , method = "GET"
                , headers = [ ( "X-MICROCMS-API-KEY", apiKey ) ]
                , body = DataSource.Http.emptyBody
                }
            )
            |> Secrets.with "API_KEY"
        )


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
    requestContents
        ("posts" ++ "?limit=100")
        (Decoder.field "contents" (Decoder.list articleMetadataDecoder))


getPostById : String -> DataSource.DataSource ArticleMetadata
getPostById id =
    requestContents
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
