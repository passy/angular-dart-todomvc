/*jshint node:true */
'use strict';

module.exports = function (grunt) {
	require('time-grunt')(grunt);

	grunt.initConfig({
		copy: {
			packages: {
				expand: true,
				src: 'packages/**',
				dest: 'src/'
			}
		},
		dart2js: {
			options: {
				dart2js_bin: 'dart2js'
			},
			dev: {
				expand: true,
				cwd: 'src',
				src: 'main.dart',
				dest: 'dist/',
				ext: '.js'
			},
			dist: {
				options: {
					minify: true
				},
				expand: true,
				cwd: 'src',
				src: 'main.dart',
				dest: 'dist/',
				ext: '.js',
			}
		},
		watch: {
			options: {
				livereload: 35279
			},
			dart: {
				files: ['src/{,*/}*.dart'],
				tasks: ['dart2js:dev']
			},
			livereload: {
				files: ['index.html', '**/*.css']
			}
		},
		connect: {
			options: {
				port: 9000,
				livereload: 35279,
				hostname: 'localhost',
				open: true
			},
			dist: {}
		}
	});

	grunt.loadNpmTasks('grunt-dart2js');
	grunt.loadNpmTasks('grunt-contrib-connect');
	grunt.loadNpmTasks('grunt-contrib-watch');
	grunt.loadNpmTasks('grunt-contrib-copy');

	grunt.registerTask('serve', [
		'connect',
		'watch'
	]);
	grunt.registerTask('default', [
		'copy',
		'dart2js:dist'
	]);
  };
