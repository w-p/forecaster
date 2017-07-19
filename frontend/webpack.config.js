
var path = require('path');
var riot = require('riot');
var stylus = require('stylus');
var postcss = require('postcss');
var autoprefixer = require('autoprefixer');
var prefixer = postcss([autoprefixer]);

riot.parsers.css.postcss = function (name, css, opts, url) {
    css = stylus(css).render();
    css = prefixer.process(css).css;
    return css;
}

module.exports = {
    entry: './src/app.js',
    output: {
        filename: 'bundle.js',
        path: path.resolve(__dirname, './dist')
    },
    module: {
        rules: [
            {
                test: /\.tag$/,
                exclude: /node_modules/,
                loader: 'riot-tag-loader',
                query: {
                    type: 'es6',
                    hot: true
                }
            },
            {
                test: /\.js$/,
                exclude: /node_modules/,
                loader: 'babel-loader',
                options: {
                    presets: [
                        'es2015-riot'
                    ]
                }
            },
            {
                test: require.resolve('axios'),
                use: [
                    {
                        loader: 'expose-loader',
                        options: 'request'
                    }
                ]
            },
            {
                test: require.resolve('lodash'),
                use: [
                    {
                        loader: 'expose-loader',
                        options: '_'
                    }
                ]
            }
        ]
    },
    node: {
        fs: 'empty',
        net: 'empty',
        tls: 'empty',
        console: true
    },
    devServer: {
        host: '0.0.0.0',
        port: 8000,
        overlay: true,
        disableHostCheck: true,
        watchContentBase: true,
        contentBase: path.resolve(__dirname, './dist')
    }
}
