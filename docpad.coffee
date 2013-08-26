docpadConfig = {
    templateData:  

        site:
            url: "http://www.uxchannel.com"
            title: "UX Videos and Updates"  
            description: "efewfewfwefwe."
            
         getPreparedTitle: ->
            if @document.title
                "#{@document.title} | #{@site.title}"
            else
                @site.title
                
        getPreparedDescription: ->            
            @document.description or @site.description
            
        getGruntedStyles: ->
            _ = require 'underscore'
            styles = []
            gruntConfig = require('./grunt-config.json')
            _.each gruntConfig, (value, key) ->
                styles = styles.concat _.flatten _.pluck value, 'dest'
            styles = _.filter styles, (value) ->
                return value.indexOf('.min.css') > -1
            _.map styles, (value) ->
                return value.replace 'out', ''

        getGruntedScripts: ->
            _ = require 'underscore'
            scripts = []
            gruntConfig = require('./grunt-config.json')
            _.each gruntConfig, (value, key) ->
                scripts = scripts.concat _.flatten _.pluck value, 'dest'
            scripts = _.filter scripts, (value) ->
                return value.indexOf('.min.js') > -1
            _.map scripts, (value) ->
                return value.replace 'out', ''
                
        getCuttedContent: (content) ->            
            i = content.search('<!--more-->')
            if i >= 0
                content[0..i-1]                
            else
                content

        hasReadMore: (content) ->
            content.search('<!--more-->') >= 0
                
    collections:
        posts: ->
            @getCollection("html").findAllLive({relativeOutDirPath: 'posts', isPagedAuto: $ne: true},[{date:-1}])
        
        learn: ->
             @getCollection("html").findAllLive({relativeOutDirPath: 'learn', isPagedAuto: $ne: true},[{date:-1}])
             
        issues: ->
             @getCollection("html").findAllLive({relativeOutDirPath: 'issues', isPagedAuto: $ne: true},[{date:-1}]) 
             
        tools: ->
             @getCollection("html").findAllLive({relativeOutDirPath: 'tools', isPagedAuto: $ne: true},[{date:-1}]) 

            
    plugins:
        datefromfilename:
            removeDate: true

###
    events:
        writeAfter: (opts,next) ->
            docpad = @docpad
            rootPath = docpad.config.rootPath
            balUtil = require 'bal-util'
            _ = require 'underscore'

            # Make sure to register a grunt `default` task
            command = ["#{rootPath}/node_modules/.bin/grunt", 'default']

            # Execute
            balUtil.spawn command, {cwd:rootPath,output:true}, ->
                src = []
                gruntConfig = require './grunt-config.json'
                _.each gruntConfig, (value, key) ->
                src = src.concat _.flatten _.pluck value, 'src'
                _.each src, (value) ->
                    balUtil.spawn ['rm', value], {cwd:rootPath, output:false}, ->
                balUtil.spawn ['find', '.', '-type', 'd', '-empty', '-exec', 'rmdir', '{}', '\;'], {cwd:rootPath+'/out', output:false}, ->
                next()

            # Chain
            @
###
}

# Export the DocPad Configuration
module.exports = docpadConfig