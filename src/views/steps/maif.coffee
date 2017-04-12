StepView = require '../step'
ServiceView = require './subviews/service'
_ = require 'underscore'

module.exports = class MaifView extends StepView
    template: require '../templates/view_steps_maif'

    ui:
        next: '.controls .next'
        pass: '.controls .pass a'
        errors: '.errors'

    regions:
        progression: '.progression'
        services: '.services'

    events:
        'click @ui.next': 'onSubmit'
        'click @ui.pass': 'onSubmit'


    onRender: (args...) ->
        super args...

        @showChildView 'services', new ServiceView {
            service: {
                name: 'step maif service',
                service: "service-logo--maif"
                figureid: require '../../assets/sprites/maif.svg'
            },
            intent: {
                action: 'PICK'
                type: 'io.cozy.files' # Temporary value
            },
            onIntentStart: () =>
                @hideError()
                @disableStep()
            onIntentSuccess: (doc) =>
                @enableStep()
                @enableNext()
            onIntentEnd: () =>
                @enableStep()
            onIntentError: (error) =>
                @showError 'intent service error'
                console.error error
        }


    onSubmit: (event) ->
        event.preventDefault()
        if not @stepDisabled
            @model
                .submit()
                .then null, (error) =>
                    @showError error.message


    serializeData: ->
        _.extend super,
            id: "#{@model.get 'name'}-figure"
            service: "service-logo--#{@model.get 'name'}"
            figureid: require '../../assets/sprites/maif.svg'


    disableStep: () ->
        @stepDisabled = true


    enableStep: () ->
        @stepDisabled = false


    enableNext: () ->
        @ui.next.removeAttr('disabled')
        @ui.next.removeAttr('aria-disabled')
