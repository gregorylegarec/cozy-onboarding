StepView = require '../step'
_ = require 'underscore'


module.exports = class AccountsView extends StepView
    template: require '../templates/view_steps_accounts'

    ui:
        next: '.controls .next'
        errors: '.errors'

    events:
        'click @ui.next': 'onSubmit'


    onRender: (args...) ->
        super args...

        if @error
            @showError(@error)
        else
            @hideError()


    onSubmit: (event)->
        event.preventDefault()
        @triggerMethod 'browse:myaccounts', @model


    serializeData: ->
        _.extend super,
            id: "#{@model.get 'name'}-figure"
            figureid: require '../../assets/sprites/icon-thumbup.svg'
