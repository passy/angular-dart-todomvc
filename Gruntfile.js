/*jshint node:true */
'use strict';

module.exports = function (grunt) {
	grunt.initConfig({
		dart2js: {
			options: {
				dart2js_bin: "dart2js"
			},
			dist: {
				expand: true,
				cwd: 'src',
				src: '{,*/}*.dart',
				dest: 'dist/',
				ext: '.js'
			}
		},
		watch: {
			options: {
				livereload: 35279
			},
			dart: {
				files: ['src/{,*/}*.dart'],
				tasks: ['dart2js']
			},
			livereload: {
				files: ['**/*.css']
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

	grunt.registerTask('serve', [
		'connect',
		'watch'
	]);
	grunt.registerTask('default', [
		'dart2js'
	]);
  };
