
const ENV = process.env.NODE_ENV = process.env.ENV || 'prod'

console.log("\r\n\r\n ============================\r\n\r\n");
console.log("ENV: " + ENV);
console.log("\r\n\r\n ============================\r\n\r\n");


var path = require('path')
var webpack = require('webpack');
var HtmlWebpackPlugin = require('html-webpack-plugin');

var plugins =  [

	new webpack.DefinePlugin({
    'process.env': {
      'ENV': JSON.stringify(ENV)
    }
  }),

	new webpack.ContextReplacementPlugin(
    /angular(\\|\/)core(\\|\/)@angular/,
    path.resolve(__dirname,'./frontend'),
    {} // a map of your routes
  )
]

if ( ENV === "build" || ENV === "prod" ) {

	plugins = plugins.concat([

		new webpack.optimize.UglifyJsPlugin({

			beautify: false,
			comments: false,
      mangle: {
        screw_ie8: true,
        keep_fnames: true
      },
      compress: {
        screw_ie8: true,
        sequences: true,
				booleans: true,
				loops: true,
				unused: true,
				warnings: false,
				drop_console: false,
				unsafe: true
      },
      
		}),

	])

}

var config = {

	devtool: ( ENV === "dev" ) ? "source-map" : "cheap-module-source-map",

  entry: {
    'vendor': './frontend/vendor.js',
    'app': './frontend/app.coffee'
  },

  output:  {

		path: path.join(__dirname, "htdocs"),
		publicPath:  "/" ,
		pathinfo: ( ENV === "dev" ), // show comments in bundles
		
		filename:
			( ENV === "build" || ENV === "prod" )
			? "bundles/[name]/[name].min.js?[hash]"
			: "bundles/[name]/[name].js?[hash]",

		chunkFilename:
			( ENV === "build" || ENV === "prod" )
			? "chunks/[name]/[name].min.js?[hash]"
			: "chunks/[name]/[name].js?[hash]",
	
	},

	plugins: plugins.concat([

			new webpack.optimize.CommonsChunkPlugin({
				name: ['app', 'vendor'],
			}),

			new HtmlWebpackPlugin({
				// inject: "head",
				template: "./frontend/index.pug",
				filename: "./index.html",
				chunksSortMode: function(a, b) {
					var order = ["vendor", "app"];
					return order.indexOf(a.names[0]) - order.indexOf(b.names[0]); 
				}
			}),


	]),


	devServer: {

		stats: "errors-only",

		port: 8888,

		contentBase: path.join(__dirname, "htdocs"),

		proxy: {
			"/api/*": {
					target: "http://test.ru",
					changeOrigin: true
			 },
		},

		historyApiFallback: {
			rewrites: [
				{ from: /^\/$/, to: "/index.html" },
			]
		},

	},

	resolve: {
    extensions: ['.ts', '.js', '.coffee']
  },


  module: {

    rules: [

      {
        test: /\.js$/,
        exclude: [
				  path.resolve(__dirname, "node_modules"),
				],
        loaders: [
        	{
        		loader: "babel-loader",
          	options: {
              presets: ['es2015'],
              plugins: [
              	'angular2-annotations',
              	'transform-decorators-legacy',
              	'transform-class-properties',
              	'transform-flow-strip-types'
              ]
            }
          },
          'angular-router-loader?option=value',
        ]
      },

      {
				test: /\.coffee$/,
				loaders: [
					"coffee-loader"
				]
			},

      {
        test: /\.html$/,
        loader: 'html-loader'
      },

      {
				test: /\.pug$/,
				use:
					( ENV === "build" || ENV === "prod" )
					? "pug-loader"
					: "pug-loader?pretty",
			},

  	]

	}

}

module.exports = config;


