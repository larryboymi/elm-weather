import HtmlWebpackPlugin from 'html-webpack-plugin'
import path from 'path'
import webpack from 'webpack'

const exclude = [ /elm-stuff/, /node_modules/ ]

export default {
  entry: [
    'webpack-dev-server/client?http://localhost:8080',
    path.join(__dirname, 'src', 'index'),
  ],
  devServer: {
    inline: true,
    noInfo: true,
    progress: true,
  },
  output: {
    path: path.resolve(__dirname, 'dist'),
    filename: '[hash].js',
  },
  resolve: {
    extensions: [ '', '.js', '.elm' ],
  },
  module: {
    loaders: [
      {
        test: /\.elm$/,
        exclude,
        loader: 'elm-webpack'
      },
      {
        test: /\.js$/,
        exclude,
        loader: 'babel',
      },
    ],
    noParse: /\.elm$/,
  },
  plugins: [
    new HtmlWebpackPlugin({
      template: 'static/index.html',
      inject: 'body',
      filename: 'index.html'
    }),
  ],
}
