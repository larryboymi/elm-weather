module ByCity (..) where

import Json.Decode exposing ((:=))
import Json.Decode.Extra exposing ((|:))
import Json.Encode

type alias Model =
    { zip: String
    , appid: String
    , weather: Weather
    }

type alias Weather =
    { coord : WeatherCoord
    , weather : List WeatherWeather
    , base : String
    , main : WeatherMain
    , visibility : Maybe Int
    , wind : WeatherWind
    , clouds : WeatherClouds
    , dt : Int
    , sys : WeatherSys
    , id : Int
    , name : String
    , cod : Int
    }

type alias WeatherWeather =
    { id : Int
    , main : String
    , description : String
    , icon : String
    }

type alias WeatherCoord =
    { lon : Float
    , lat : Float
    }

type alias WeatherMain =
    { temp : Float
    , pressure : Int
    , humidity : Int
    , temp_min : Float
    , temp_max : Float
    }

type alias WeatherWind =
    { speed : Float
    , deg : Maybe Int
    }

type alias WeatherClouds =
    { all : Int
    }

type alias WeatherSys =
    { sysType : Int
    , id : Int
    , message : Float
    , country : String
    , sunrise : Int
    , sunset : Int
    }

decodeWeather : Json.Decode.Decoder Weather
decodeWeather =
    Json.Decode.succeed Weather
        |: ("coord" := decodeWeatherCoord)
        |: ("weather" := Json.Decode.list decodeWeatherWeather)
        |: ("base" := Json.Decode.string)
        |: ("main" := decodeWeatherMain)
        |: (Json.Decode.maybe ("visibility" := Json.Decode.int))
        |: ("wind" := decodeWeatherWind)
        |: ("clouds" := decodeWeatherClouds)
        |: ("dt" := Json.Decode.int)
        |: ("sys" := decodeWeatherSys)
        |: ("id" := Json.Decode.int)
        |: ("name" := Json.Decode.string)
        |: ("cod" := Json.Decode.int)


decodeWeatherWeather : Json.Decode.Decoder WeatherWeather
decodeWeatherWeather =
    Json.Decode.succeed WeatherWeather
        |: ("id" := Json.Decode.int)
        |: ("main" := Json.Decode.string)
        |: ("description" := Json.Decode.string)
        |: ("icon" := Json.Decode.string)

decodeWeatherCoord : Json.Decode.Decoder WeatherCoord
decodeWeatherCoord =
    Json.Decode.succeed WeatherCoord
        |: ("lon" := Json.Decode.float)
        |: ("lat" := Json.Decode.float)

decodeWeatherMain : Json.Decode.Decoder WeatherMain
decodeWeatherMain =
    Json.Decode.succeed WeatherMain
        |: ("temp" := Json.Decode.float)
        |: ("pressure" := Json.Decode.int)
        |: ("humidity" := Json.Decode.int)
        |: ("temp_min" := Json.Decode.float)
        |: ("temp_max" := Json.Decode.float)

decodeWeatherWind : Json.Decode.Decoder WeatherWind
decodeWeatherWind =
    Json.Decode.succeed WeatherWind
        |: ("speed" := Json.Decode.float)
        |: (Json.Decode.maybe ("deg" := Json.Decode.int))

decodeWeatherClouds : Json.Decode.Decoder WeatherClouds
decodeWeatherClouds =
    Json.Decode.succeed WeatherClouds
        |: ("all" := Json.Decode.int)

decodeWeatherSys : Json.Decode.Decoder WeatherSys
decodeWeatherSys =
    Json.Decode.succeed WeatherSys
        |: ("type" := Json.Decode.int)
        |: ("id" := Json.Decode.int)
        |: ("message" := Json.Decode.float)
        |: ("country" := Json.Decode.string)
        |: ("sunrise" := Json.Decode.int)
        |: ("sunset" := Json.Decode.int)

encodeWeather : Weather -> Json.Encode.Value
encodeWeather record =
    Json.Encode.object
        [ ("coord",  encodeWeatherCoord record.coord)
        , ("weather",  Json.Encode.list <| List.map encodeWeatherWeather record.weather)
        , ("base",  Json.Encode.string record.base)
        , ("main",  encodeWeatherMain record.main)
        , ("visibility",  Json.Encode.int (Maybe.withDefault 0 record.visibility))
        , ("wind",  encodeWeatherWind record.wind)
        , ("clouds",  encodeWeatherClouds record.clouds)
        , ("dt",  Json.Encode.int record.dt)
        , ("sys",  encodeWeatherSys record.sys)
        , ("id",  Json.Encode.int record.id)
        , ("name",  Json.Encode.string record.name)
        , ("cod",  Json.Encode.int record.cod)
        ]

encodeWeatherWeather : WeatherWeather -> Json.Encode.Value
encodeWeatherWeather record =
    Json.Encode.object
        [ ("id",  Json.Encode.int record.id)
        , ("main",  Json.Encode.string record.main)
        , ("description", Json.Encode.string record.description)
        , ("icon", Json.Encode.string record.icon)
        ]

encodeWeatherCoord : WeatherCoord -> Json.Encode.Value
encodeWeatherCoord record =
    Json.Encode.object
        [ ("lon",  Json.Encode.float record.lon)
        , ("lat",  Json.Encode.float record.lat)
        ]

encodeWeatherMain : WeatherMain -> Json.Encode.Value
encodeWeatherMain record =
    Json.Encode.object
        [ ("temp",  Json.Encode.float record.temp)
        , ("pressure",  Json.Encode.int record.pressure)
        , ("humidity",  Json.Encode.int record.humidity)
        , ("temp_min",  Json.Encode.float record.temp_min)
        , ("temp_max",  Json.Encode.float record.temp_max)
        ]

encodeWeatherWind : WeatherWind -> Json.Encode.Value
encodeWeatherWind record =
    Json.Encode.object
        [ ("speed",  Json.Encode.float record.speed)
        , ("deg",  Json.Encode.int (Maybe.withDefault 0 record.deg))
        ]

encodeWeatherClouds : WeatherClouds -> Json.Encode.Value
encodeWeatherClouds record =
    Json.Encode.object
        [ ("all",  Json.Encode.int record.all)
        ]

encodeWeatherSys : WeatherSys -> Json.Encode.Value
encodeWeatherSys record =
    Json.Encode.object
        [ ("type",  Json.Encode.int record.sysType)
        , ("id",  Json.Encode.int record.id)
        , ("message",  Json.Encode.float record.message)
        , ("country",  Json.Encode.string record.country)
        , ("sunrise",  Json.Encode.int record.sunrise)
        , ("sunset",  Json.Encode.int record.sunset)
        ]
