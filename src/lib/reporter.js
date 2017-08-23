/* global __SENTRY_DSN__, __SENTRY_ENV__ */
import Raven from 'raven-js'

let isEnable = false
export const getConfig = () => ({
  shouldSendCallback: () => isEnable
})
console.debug('__SENTRY_DSN__', __SENTRY_DSN__)
export const configure = (enable) => {
  isEnable = enable
  Raven.config(`${__SENTRY_DSN__}`, getConfig()).install()
}

export const logException = (err) => {
  return new Promise(resolve => {
    Raven.captureException(err)
    console.warn('Raven is recording exception')
    console.error(err)
    resolve()
  })
}

const logMessage = (message, level = 'info', force) => {
  return new Promise(resolve => {
    const updateConfig = force && !isEnable
    if (updateConfig) {
      configure(true)
    }
    Raven.captureMessage(message, {
      level
    })
    if (updateConfig) {
      configure(false)
    }
    resolve()
  })
}

export const logInfo = (message, force = false) => logMessage(message, 'info', force)
export const pingOnceADay = () => logInfo('good day: user opens the app')
