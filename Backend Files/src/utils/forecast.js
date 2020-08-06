// Utility that returns the weather of a location


const request = require('request')                    // Importing request Module

const forecast = (latitude, longitude, callback) => {    // function to call weather API
    const url = 'https://www.mapquestapi.com/geocoding/v1/reverse?key=uK5ypqb39ZNnlV0f8xkTUisANzpG4o92&location='+latitude+','+longitude

    request({url: url, json: true}, (error, response) => {
        if(error){
            callback('Unable to connect', undefined)     // If there is a problem in conection
        } else if (response.body.error) {
            callback('Unable to find location',undefined) //If given location is not found
        } else {
            callback(undefined,response.body)             // Return weather in JSON format
        }   
    })
}
 
module.exports = forecast