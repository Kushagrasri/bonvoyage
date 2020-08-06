// This file is responsible for doing authentication using auth middleware

const User = require('../models/user')

const check = async (req, res, next) => {
    const username = req.params.username
    try {

        const userSearched = await User.findOne({ username })
        if(!userSearched){
            throw new Error('User not found!')
        }

        if(userSearched.private){
            if(req.user.following.includes(username)){
                next()
            }
            else{
                throw new Error('User has private account!')
            }           
        }
        else{
            next()
        }       
    } catch (e) {
        console.log(e)
        if(e=='Error: User not found!')
        res.status(401).send({error: 'User not found'})
        else
        res.status(401).send({error: 'User has private account!'})
    }
}

module.exports = check