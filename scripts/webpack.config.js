import path from 'path'

const exampleDir = path.join(__dirname, '..', 'example')

export default {
  context: exampleDir,
  entry: './index.js',
  output: {
    path: exampleDir,
    filename: 'bundle.js'
  },

  module: {
    loaders: [{
      test: /\.js$/,
      exclude: /node_modules/,
      loader: 'babel'
    }, {
      test: /\.elm$/,
      exclude: [/elm-stuff/, /node_modules/],
      loader: 'elm-webpack'
    }],
    noParse: /\.elm$/
  },

  devServer: {
    contentBase: exampleDir
  }
}
