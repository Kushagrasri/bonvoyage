const express = require('express')
const router = new express.Router()
const forecast = require('../utils/distance')


router.get('/distance', (req, res) => {
    if (!req.body.longitude1||!req.body.longitude2||!req.body.latitude1||!req.body.latitude2) {
        return res.send({
            error: 'Provide an address'
        })
    }

    forecast(req.body.latitude1, req.body.longitude1, req.body.latitude2, req.body.longitude2, (error, distanceData) => {
        if (error) {
            return res.send({ error }) 
        }

        //console.log(distanceData.resourceSets[0])
        res.send({
            distance: distanceData.resourceSets[0].resources[0].results[0].travelDistance,
        })
    })   
})

module.exports = router