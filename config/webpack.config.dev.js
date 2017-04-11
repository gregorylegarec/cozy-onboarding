'use strict'

const webpack = require('webpack')

module.exports = {
  devtool: '#source-map',
  externals: ['cozy'],
  plugins: [
    new webpack.DefinePlugin({
      __SERVER__: JSON.stringify('http://app.cozy.tools'),
      __STACK_ASSETS__: false
    }),
    new webpack.ProvidePlugin({
      'cozy.client': 'cozy-client-js/dist/cozy-client.js'
    })
  ]
}
