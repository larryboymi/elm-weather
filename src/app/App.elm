module App (init, update, view) where


import Signal exposing (..)
import Html exposing (..)
import Html.Attributes as Attr exposing (..)
import Html.Events exposing (onClick, targetValue, on)
import Effects exposing (Effects, Never)
import Http
import Json.Decode
import Json.Encode
import Task
import ByCity exposing (..)
import Debug

-- MODEL
defaultWeather : Weather
defaultWeather =
  {
    coord = {
      lon = 0,
      lat = 0
    },
    weather = [{
      id = 0,
      main = "",
      description = "",
      icon = ""
    }],
    base = "",
    main = {
      temp = 0,
      pressure = 0,
      humidity = 0,
      temp_min = 0,
      temp_max = 0
    },
    visibility = Just 0,
    wind = {
      speed = 0,
      deg = Just 0
    },
    clouds = {
      all = 0
    },
    dt = 0,
    sys = {
      sysType = 0,
      id = 0,
      message = 0,
      country = "",
      sunrise = 0,
      sunset = 0
    },
    id = 0,
    name = "",
    cod = 0
  }
defaultWeatherModel : Model
defaultWeatherModel =
  { zip = ""
  , appid = ""
  , weather = defaultWeather
  }

init : ( Model, Effects Action )
init =
  ( defaultWeatherModel
  , Effects.none
  )


--- UPDATE


type Action
  = DoNothing
  | UpdateZip String
  | UpdateAppId String
  | RequestWeather
  | UpdateWeather (Maybe Weather)


update : Action -> Model -> ( Model, Effects Action )
update action model =
  case action of
    DoNothing ->
      ( model, Effects.none )

    UpdateZip i ->
      ( {model | zip = i }
      , Effects.none
      )

    UpdateAppId i ->
      ( {model | appid = i }
      , Effects.none
      )

    RequestWeather ->
      ( model, requestWeather model )

    UpdateWeather w ->
      ( { model | weather = Maybe.withDefault defaultWeather w }
      , Effects.none
      )



-- VIEW

view : Address Action -> Model -> Html
view address model =
  let zipField =
        input
          [ placeholder "Zip Code"
          , value model.zip
          , on "input" targetValue (\str -> Signal.message address (UpdateZip str ) )
          ]
          []
      appIdField =
        input
          [ placeholder "App ID"
          , value model.appid
          , on "input" targetValue (\str -> Signal.message address (UpdateAppId str ) )
          ]
          []
      clickyButton =
        button [ onClick address RequestWeather ] [ text "Get Weather for Zip Code" ]
      messages =
        [ pre [ ] [ text (Json.Encode.encode 2 (encodeWeather model.weather)) ] ]
  in
      div [] (zipField :: appIdField :: clickyButton :: messages)


--- Effects


requestWeather : Model -> Effects Action
requestWeather { zip, appid } =
  Http.get decodeWeather ("http://api.openweathermap.org/data/2.5/weather?appid=" ++ appid ++ "&zip=" ++ zip)
    |> Task.toMaybe
    |> Task.map UpdateWeather
    |> Effects.task
