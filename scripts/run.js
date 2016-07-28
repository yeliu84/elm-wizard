import webpack from 'webpack'
import WebpackDevServer from 'webpack-dev-server'
import config from './webpack.config'

function dev () {
  new WebpackDevServer(webpack(config), config.devServer).listen(8080)
}

function build () {
  webpack(config, (err, stats) => {
    if (err) {
      console.error(err)
      process.exit(1)
    }
    stats = stats.toJson()
    if (stats.errors.length) {
      console.log(stats.errors.join('\n'))
      process.exit(1)
    }
    if (stats.warnings.length) {
      console.log(stats.warnings.join('\n'))
    }
  })
}

const cmd = process.argv[2]
const actions = { dev, build }

actions[cmd]()
