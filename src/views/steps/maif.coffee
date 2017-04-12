StepView = require '../step'
_ = require 'underscore'

module.exports = class MaifView extends StepView
    template: require '../templates/view_steps_maif'

    ui:
        next: '.controls .next'
        pass: '.controls .pass'
        errors: '.errors'

    events:
        'click @ui.next': 'onSubmit'
        'click @ui.pass': 'onSubmit'


    onRender: (args...) ->
        super args...

        if @error
            @showError(@error)
        else
            @hideError()


    onSubmit: (event) ->
        event.preventDefault()
        @model
            .submit()
            .then null, (error) =>
                @showError error.message


    serializeData: ->
        _.extend super,
            id: "#{@model.get 'name'}-figure"
            service: "service-logo--#{@model.get 'name'}"
            figureid: require '../../assets/sprites/maif.svg'
