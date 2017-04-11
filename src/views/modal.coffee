{ItemView} = require 'backbone.marionette'
Backbone = require 'backbone'

key = {
  ESC: 27
}


module.exports = class ModalView extends ItemView
    template: require './templates/modal'

    ui:
        modalOverlay: '.modal-overlay'
        contentWrapper: '.modal'

    events:
        'click @ui.contentWrapper': 'preventClick'
        'keyup @ui.modalOverlay': 'onKeyUp'


    initialize: (options) ->
        @onHide = options.onHide
        this.render options.item


    getContentWrapper: ->
        return @ui.contentWrapper.get(0)


    onRender: (item) ->
        @document = @el.ownerDocument
        @document.body.appendChild @el

        @document.addEventListener 'keyup', @hide.bind(@)

        contentWrapperElement = @ui.contentWrapper.get(0)

        # Wait for content like iframe to be loaded
        observer = new MutationObserver (event) =>
            $iframe = @$ 'iframe'
            if $iframe.length
                $iframe.on 'load', (event) =>
                    @show()
            else
                @show()

        observer.observe contentWrapperElement, childList: true


    preventClick: (event) ->
        event.stopPropagation()


    onKeyUp: (event) ->
        if event.keyCode is key.ESC
            hide()


    dispose: () ->
        @document.body.removeChild @el


    hide: () ->
        @$el.one 'transitionend', () =>
            if typeof @onHide is 'function'
                @onHide()
            @dispose()

        @ui.modalOverlay.attr 'aria-hidden', 'true'

    show: () ->
        @ui.modalOverlay.attr 'aria-hidden', 'false'
        @ui.modalOverlay.on 'click', () => @hide()
