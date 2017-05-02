/* global describe, it, browser */
const assert = require('chai').assert
const fetch = require('node-fetch')

browser.timeouts('script', 120000)

const filterInstance = (instances, domain) => {
  return instances.find(instance => {
    return instance.doc && instance.doc.domain === domain
  }) || instances[0]
}

const fetchRegisterToken = () => fetch(
      'http://localhost:5984/global%2Finstances/_all_docs?include_docs=true'
    )
    .then(response => response.json())
    .then(json => {
      return filterInstance(json.rows, 'cozy.local:8080')
    })
    .then(instance => {
      return fetch(`http://localhost:5984/global%2Finstances/${instance.id}`)
    })
    .then(response => response.json())
    .then(json => {
      return json['register_token']
    })
    .then(registerTokenBase64 => Buffer.from(registerTokenBase64, 'base64').toString('hex'))

describe('BrowserStack Local Testing', function () {
  it('can check tunnel working', function (done) {
    console.log('can check tunnel working')
    fetchRegisterToken()
      .then(registerToken => {
        console.log(`accessing http://onboarding.cozy.local:8080/?registerToken=${registerToken}`)
        browser
          .url(`http://onboarding.cozy.local:8080/?registerToken=${registerToken}`)

        console.log('url.then')
        browser.waitUntil(() => {
          console.log('browser.waitUntil', browser.getUrl())
          return browser.getUrl() !== `http://onboarding.cozy.local:8080/?registerToken=${registerToken}`
        }, 30000)
        .then(() => {
          // assert(browser.getSource().match(/Up and running/i))
          assert.equal(browser.getText('h1'), 'Welcome!')
          done()
        })
      })
  })
})
