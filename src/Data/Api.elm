module Data.Api exposing (dateDecoder, requestContent)

import DataSource
import DataSource.Http
import Date exposing (Date)
import OptimizedDecoder as Decoder
import Pages.Secrets as Secrets


contentApi : String
contentApi =
    "https://tkoyasak.microcms.io/api/v1/"


requestContent :
    String
    -> Decoder.Decoder a
    -> DataSource.DataSource a
requestContent query =
    DataSource.Http.request
        (Secrets.succeed
            (\apiKey ->
                { url = contentApi ++ query
                , method = "GET"
                , headers = [ ( "X-MICROCMS-API-KEY", apiKey ) ]
                , body = DataSource.Http.emptyBody
                }
            )
            |> Secrets.with "API_KEY"
        )


dateDecoder : Decoder.Decoder Date
dateDecoder =
    Decoder.string
        |> Decoder.andThen
            (\isoString ->
                String.slice 0 10 isoString
                    |> Date.fromIsoString
                    |> Decoder.fromResult
            )
