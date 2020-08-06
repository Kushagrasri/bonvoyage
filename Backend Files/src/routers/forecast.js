const express = require('express')
const router = new express.Router()
const forecast = require('../utils/forecast')


router.get('/forecast', (req, res) => {
    if (!req.body.longitude) {
        return res.send({
            error: 'Provide an address'
        })
    }

    forecast(req.body.latitude, req.body.longitude, (error, forecastData) => {
        if (error) {
            return res.send({ error }) 
        }

        res.send({
            forecast: forecastData,
        })
    })   
})

module.exports = router