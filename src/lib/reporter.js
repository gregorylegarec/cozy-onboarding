/* global __SENTRY_DSN__, __SENTRY_SECRET__ */
import Raven from 'raven-js'

let isEnable = false
export const getConfig = (cozyClient, useCozyProxy) => {
  const config = {
    shouldSendCallback: () => isEnable
  }

  if (useCozyProxy && cozyClient) {
    config.transport = (options) => {
      const { auth, data } = options
      const parameters = {...auth, ...{project: data.project}, ...{data: JSON.stringify(data)}, ...{sentry_secret: __SENTRY_SECRET__}}
      cozyClient.fetchJSON('POST', '/remote/cc.cozycloud.sentry', parameters)
        .catch(options.onError)
        .then(options.onSuccess)
    }
  }

  return config
}

export const configure = (enable, cozyClient, useCozyProxy) => {
  isEnable = enable
  Raven.config(`${__SENTRY_DSN__}`, getConfig(cozyClient, useCozyProxy)).install()
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
