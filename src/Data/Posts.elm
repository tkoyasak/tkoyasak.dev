module Data.Posts exposing (Metadata, getAllPosts, getPostById, getPostsByTag)

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


getAllPosts : DataSource.DataSource (List Metadata)
getAllPosts =
    requestContent
        "posts"
        (Decoder.field "contents" (Decoder.list metadataDecoder))


getPostById : String -> DataSource.DataSource Metadata
getPostById id =
    requestContent
        ("posts/" ++ id)
        metadataDecoder


getPostsByTag : String -> DataSource.DataSource (List Metadata)
getPostsByTag name =
    requestContent
        "posts"
        (Decoder.field "contents" (Decoder.list metadataDecoder))
        |> DataSource.map
            (\allPosts ->
                List.filter
                    (\post ->
                        List.member name
                            (List.map
                                (\metadata -> metadata.name)
                                post.tags
                            )
                    )
                    allPosts
            )
