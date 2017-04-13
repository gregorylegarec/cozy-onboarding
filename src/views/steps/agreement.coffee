StepView = require '../step'
_ = require 'underscore'


module.exports = class AgreementView extends StepView
    template: require '../templates/view_steps_agreement'

    ui:
        next: '.controls .next'
        checkbox: '.checkbox input'
        errors: '.errors'

    events:
        'click @ui.next': 'onSubmit'


    onRender: (args...) ->
        super args...
        @$statsPart = @$('.stats-agreement')

        if @error
            @showError(@error)
        else
            @hideError()

        # if expected environment variable, hide stats checkbox part
        if @isStatsAgreementDisabled
            @$statsPart.hide()


    serializeData: ->
        # the following figures object keys will be the
        # elementName in the related view
        _.extend super,
            figures: [
                require '../../assets/sprites/icon-shield.svg'
                require '../../assets/sprites/icon-hand-files.svg'
                require '../../assets/sprites/icon-forbidden-sign.svg'
                require '../../assets/sprites/icon-magnifier-user.svg'
                require '../../assets/sprites/icon-safe.svg'
                require '../../assets/sprites/icon-user.svg'
            ]
            cguLink: 'https://files.cozycloud.cc/cgu.pdf'


    onSubmit: (event)->
        event.preventDefault()
        if @isStatsAgreementDisabled
            allowStats = false
        else
            allowStats = @ui.checkbox?[0].checked
        @model.submit {allowStats: allowStats}


    # function use by the application to hide/display the stats checbox
    # part according to an environment variable
    disableStatsAgreement: ->
        @isStatsAgreementDisabled = true
