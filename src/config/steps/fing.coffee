module.exports = {
    name: 'fing',
    view : 'steps/fing'
    isActive: (instance) ->
        instance.attributes \
        && instance.attributes.context \
        && (instance.attributes.context.toLowerCase() is 'fing' || instance.attributes.context.toLowerCase() is 'maif_fing')
}
