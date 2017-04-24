StepView = require '../step'
_ = require 'underscore'


module.exports = class FingView extends StepView
    template: require '../templates/view_steps_fing'

    ui:
        next: '.controls .next'
        pass: '.controls .pass'

    events:
        'click @ui.next': 'onSubmit'
        'click @ui.pass': 'onSubmit'


    onRender: (args...) ->
        super args...
        @$errorContainer=@$('.errors')

        if @error
            @renderError(@error)
        else
            @$errorContainer.hide()


    onSubmit: (event) ->
        event.preventDefault()
        @model
            .submit()
            .then null, (error) =>
                @renderError error.message


    serializeData: ->
        _.extend super,
            id: "#{@model.get 'name'}-figure"
            service: "service-logo--#{@model.get 'name'}"
            figureid: require '../../assets/sprites/fing.svg'
            edfLogo: require '../../assets/sprites/edf.svg'
            orangeLogo: require '../../assets/sprites/orange.svg'


    renderError: (error) ->
        @$errorContainer.html(t(error))
        @$errorContainer.show()
