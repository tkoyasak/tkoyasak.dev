module Data.Api exposing (requestContent)

import DataSource
import DataSource.Http
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
