// npm i @sendgrid/mail@6.3.1

const sgmail = require('@sendgrid/mail')

const sendgridAPIKey= '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'

sgmail.setApiKey(sendgridAPIKey)

const sendWelcomeEmail = (email, name, verificationCode) => {
    sgmail.send({
        to: email,
        from: 'varunnssaini@gmail.com',
        subject: `Welcome ${name}!`,
        text: `Welcome to the app, ${name}. Your verification code is ${verificationCode}!`
    })
}

const sendTokenAgain = (email, name, verificationCode) => {
    sgmail.send({
        to: email,
        from: 'varunnssaini@gmail.com',
        subject: `New code`,
        text: `${name} here is your new verification code - ${verificationCode} .`
    })
}

module.exports = {
    sendWelcomeEmail,
    sendTokenAgain
}
