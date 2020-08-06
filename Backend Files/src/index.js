//To import the express module related to server
const express = require('express')      

// To setup database
require('./db/mongoose')

// Importing various paths/routes/URL to the user
const userRouter = require('./routers/user')   
const dayvisitRouter = require('./routers/dayvisit')           
const visitRouter = require('./routers/visit')           
const bookmarkRouter = require('./routers/bookmark')   
const forecastRouter = require('./routers/forecast')   
const distanceRouter = require('./routers/distance') 


// Syntax to set port to localhost or given port(after deployment)
const app = express()                                  
const port = process.env.PORT || 3000               


// Method of express to recognise incoming request as JSON Object
app.use(express.json())                                

// Instructing to use other routes
app.use(userRouter)   
app.use(dayvisitRouter)                                     
app.use(visitRouter)                                   
app.use(bookmarkRouter)                                
app.use(forecastRouter)
app.use(distanceRouter)
                            
                         

// To run server and to print the port in console
app.listen(port, () => {                               
    console.log('Server is up on port ' + port)         
})