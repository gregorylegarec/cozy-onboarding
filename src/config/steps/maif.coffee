module.exports = {
    name: 'maif',
    view : 'steps/maif'
    isActive: (instance) ->
        instance.attributes \
        && instance.attributes.context \
        && (instance.attributes.context.toLowerCase() is 'maif' || instance.attributes.context.toLowerCase() is 'maif_fing')
}
