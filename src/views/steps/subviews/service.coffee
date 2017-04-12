{ItemView} = require 'backbone.marionette'
_ = require 'underscore'

ModalView = require '../../modal'

module.exports = class ServiceView extends ItemView
    template: require '../../templates/service'

    className: 'service'

    ui:
        connect: '[role=connect]'

    events:
      'click [role=connect]': 'onConnect'


    initialize: (options) ->
        @service = options.service
        @intent = options.intent

        @onIntentStart = () =>
            if typeof options.onIntentSuccess is 'function'
                options.onIntentStart()

        @onIntentSuccess = (doc) =>
            if typeof options.onIntentSuccess is 'function'
                options.onIntentSuccess doc

        @onIntentError = (error) =>
            if typeof options.onIntentError is 'function'
                options.onIntentError error

        @onIntentEnd = () =>
            if typeof options.onIntentEnd is 'function'
                options.onIntentEnd()


    serializeData: () ->
        _.extend super,
            @service


    onConnect: () ->
        @onIntentStart()
        @setBusy true

        modal = new ModalView \
            onHide: () =>
                @onIntentEnd()
                @setBusy false


        cozy.client.intents
            .create @intent.action, @intent.type
            .start modal.getContentWrapper()
            .then (doc) =>
                @onIntentSuccess doc
            .catch (error) =>
                @onIntentError error
            .then () =>
                @setBusy false


    setBusy: (busy) ->
        if busy
            @disableConnect()
            @ui.connect.attr 'aria-busy', true
        else
            @enableConnect()
            @ui.connect.removeAttr 'aria-busy'


    enableConnect: () ->
        @ui.connect.removeAttr 'disabled'
        @ui.connect.removeAttr 'aria-disabled'


    disableConnect: () ->
        @ui.connect.attr 'disabled', 'disabled'
        @ui.connect.attr 'aria-disabled', 'true'
