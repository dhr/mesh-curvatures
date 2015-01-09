"use strict"

# # Globbing
# for performance reasons we're only matching one level down:
# 'test/spec/{,*/}*.js'
# use this if you want to recursively match all subfolders:
# 'test/spec/**/*.js'
module.exports = (grunt) ->
  # Load grunt tasks automatically
  require("load-grunt-tasks") grunt
  
  # Time how long tasks take. Can help when optimizing build times
  require("time-grunt") grunt
  
  # Define the configuration for all the tasks
  grunt.initConfig
    # Project settings
    yeoman:
      app: "app"
      dist: "dist"
    
    # Watches files for changes and runs tasks based on the changed files
    watch:
      jade:
        files: ['<%= yeoman.app %>/{,*/}*.jade']
        tasks: ['jade']

      gruntfile:
        files: ["Gruntfile.coffee"]

      livereload:
        options:
          livereload: "<%= connect.options.livereload %>"

        files: [
          ".tmp/{,*/}*.html"
          ".tmp/{,*/}*.css"
          ".tmp/{,*/}*.js"
          "<%= yeoman.app %>/meshes/*.json"
          "<%= yeoman.app %>/images/{,*/}*.{png,jpg,jpeg,gif,webp,svg}"
        ]

    
    # The actual grunt server settings
    connect:
      options:
        port: 9000
        
        # Change this to '0.0.0.0' to access the server from outside.
        hostname: "localhost"
        livereload: 35729

      livereload:
        options:
          open: true
          base: [
            ".tmp"
            "<%= yeoman.app %>"
          ]

      dist:
        options:
          base: "<%= yeoman.dist %>"

    
    # Empties folders to start fresh
    clean:
      dist:
        files: [
          dot: true
          src: [
            ".tmp"
            "<%= yeoman.dist %>/*"
            "!<%= yeoman.dist %>/.git*"
          ]
        ]

      server: ".tmp"


    # Process jade files
    jade:
      dist:
        options:
          pretty: true
        files: [
          expand: true
          cwd: '<%= yeoman.app %>'
          dest: '.tmp'
          src: '{*,/*}.jade'
          ext: '.html'
        ]


    # Copies remaining files to places other tasks can use
    copy:
      dist:
        files: [
          {
            expand: true
            dot: true
            cwd: "<%= yeoman.app %>"
            dest: "<%= yeoman.dist %>"
            src: [
              "{,*/}*.js"
              "{,*/}*.html"
              "{,*/}*.json"
            ]
          }
          {
            expand: true
            cwd: ".tmp"
            dest: "<%= yeoman.dist %>"
            src: [
              "{,*/}*.html"
            ]
          }
        ]

  grunt.registerTask "serve", (target) ->
    if target is "dist"
      return grunt.task.run([
        "build"
        "connect:dist:keepalive"
      ])
    grunt.task.run [
      "clean:server"
      "jade"
      "connect:livereload"
      "watch"
    ]
    return

  grunt.registerTask "build", [
    "clean:dist"
    "jade"
    "copy:dist"
  ]
  return
