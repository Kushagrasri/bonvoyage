// Utility that returns the distance between two locations


const request = require('request')                        // Importing request Module

const distance = (latitude1, longitude1, latitude2, longitude2,callback) => {
    const url = 'https://dev.virtualearth.net/REST/v1/Routes/DistanceMatrix?origins='+latitude1+','+longitude1+'&destinations='+latitude2+','+longitude2+'&travelMode=driving&key=AtRuyEcJ5wYw1w-UPRYLYOUr9DwuW68wmcixcSMRG3eDdTLr1k_cE5PQFPcInf9e'

    request({url: url, json: true}, (error, response) => {
        if(error){
            callback('Unable to connect', undefined)        // If there is a problem in conection
        } else if (response.body.error) {
            callback('Unable to find location',undefined)   //If given location is not found
        } else {
            callback(undefined,response.body)               // Return weather in JSON format
        }   
    })
}
 
module.exports = distance