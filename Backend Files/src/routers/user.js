const express = require('express')
const multer = require('multer')                                           // MiddleWare
//const sharp = require('sharp')
const User = require('../models/user')
const auth = require('../middleware/auth')
const checkForFollow = require('../middleware/checkForFollow')
const router = new express.Router()
const { sendWelcomeEmail } = require('../emails/account')
const { sendTokenAgain } = require('../emails/account')


//Signup 
router.post('/users', async (req, res) => { 
    const verificationCode = Math.floor( Math.random() * (99999 - 10000) + 10000)
    var verificationCodeTime = new Date();
      
    const user = new User({
        ...req.body,
        verificationCode: verificationCode,
        verificationCodeTime: verificationCodeTime.getTime()
    })
    
    try {
        const username = req.body.username
        const email = req.body.email

        const ifUsernameExists = await User.findOne({ username })
        const ifEmailExists = await User.findOne({ email })

        if(ifUsernameExists)
        {
            res.status(400).send('Username Already exists!')
        }
        else if(ifEmailExists)
        {
            res.status(400).send('Email Already exists!')
        }
        else{
            await user.save()
            sendWelcomeEmail(user.email, user.name, user.verificationCode)
            // const token = await user.generateAuthToken()
            // res.status(201).send({ user, token })
            res.status(201).send('Verify your email!')
        }       
    } catch (e) {
        res.status(400).send(e)
    }
})
 
//Login
router.post('/users/login', async (req, res) => {
    try {
        const user = await User.findByCredentials(req.body.username, req.body.password)
        if(user.isVerified)
        {
            const token = await user.generateAuthToken()
            res.send({ user, token })
        }
        else
        {
            res.status(401).send({error: 'Verify your email first!'})
        }       
    } catch (e) {
        console.log(e)
        if(e=='Error: Password does not match')
        res.status(400).send({error: 'Password does not match!'})
        else
        res.status(400).send({error: 'User not found!'})
    }
})

// Verify email
router.post('/users/verify', async (req, res) => {
    try {
        const user = await User.findByCredentials(req.body.username, req.body.password)
        if(req.body.verificationCode===user.verificationCode)
        {
            const timeNow = new Date();
            if(timeNow-user.verificationCodeTime<=3600000)
            {
                await User.findOneAndUpdate({username: user.username}, {"$set":{"isVerified":true}})
                const token = await user.generateAuthToken()
                res.send({ user, token })
            }
            else
            {
                const verificationCode = Math.floor( Math.random() * (99999 - 10000) + 10000)
                await User.findOneAndUpdate({username: user.username}, {"$set":{"verificationCode":verificationCode}})
                await User.findOneAndUpdate({username: user.username}, {"$set":{"verificationCodeTime":timeNow}})
                sendTokenAgain(user.email, user.name, verificationCode)
                res.status(401).send({error: 'Code expired! Check your mail for new code!'})
            }
        }
        else
        {
            res.status(400).send({error: 'Wrong Verification Code!'})
        }       
    } catch (e) {
        console.log(e)
        if(e=='Error: Password does not match')
        res.status(400).send({error: 'Password does not match!'})
        else
        res.status(400).send({error: 'User not found!'})
    }
})

//Logout
router.post('/users/logout', auth, async (req, res) => {
    try {
        req.user.tokens = req.user.tokens.filter((token) => {
            return token.token !== req.token
        })
        await req.user.save()

        res.send()
    } catch (e) {
        res.status(500).send()
    }
}) 

//Logout from all devices
router.post('/users/logoutAll', auth, async (req, res) => {
    try {
        req.user.tokens = []
        await req.user.save()
        res.send()
    } catch (e) {
        res.status(500).send()
    }
})

//My profile
router.get('/users/me', auth, async (req, res) => {
    res.send(req.user)
})


//Read any user's profile
router.get('/users/:username', auth, checkForFollow, async (req, res) => {

    const username = req.params.username

    const userSearched = await User.findOne({ username })
    res.send(userSearched)
 
})

//Read and user's visited place
router.get('/users/:username/visits', auth, checkForFollow, async (req, res) => {

    const username = req.params.username

    const userSearched = await User.findOne({ username })

    await userSearched.populate({
        path: 'visits',
    }).execPopulate()
    res.send(userSearched.visits)

})

//Update My Profile
router.patch('/users/me', auth, async (req, res) => {
    const updates = Object.keys(req.body)
    const allowedUpdates = ['name', 'email', 'password', 'age']
    const isValidOperation = updates.every((update) => allowedUpdates.includes(update))

    if (!isValidOperation) {
        return res.status(400).send({ error: 'Invalid updates!' })
    }

    try {
        updates.forEach((update) => req.user[update] = req.body[update])
        await req.user.save()
        res.send(req.user)
    } catch (e) {
        res.status(400).send(e)
    }
})

//Delete My Account
router.delete('/users/me', auth, async (req, res) => {
    try {
        await req.user.remove()
        res.send(req.user)
    } catch (e) {
        res.status(500).send()
    }
})

const upload = multer({
    limits: {
        fileSize: 1000000
    },
    fileFilter(req, file, cb) {
        if (!file.originalname.match(/\.(jpg|jpeg|png)$/)) {
            return cb(new Error('Please upload an image'))
        }

        cb(undefined, true)
    }
})

//My profile Picture
router.post('/users/me/avatar', auth, upload.single('avatar'), async (req, res) => {
    //const buffer = await sharp(req.file.buffer).resize({ width: 250, height: 250 }).png().toBuffer()
    req.user.avatar = req.file.buffer
    await req.user.save()
    res.send()
}, (error, req, res, next) => {
    res.status(400).send({ error: error.message })
})

router.delete('/users/me/avatar', auth, async (req, res) => {
    req.user.avatar = undefined
    await req.user.save()
    res.send()
})

//Any user's Profile Picture
router.get('/users/:id/avatar', async (req, res) => {
    try {
        const user = await User.findById(req.params.id)

        if (!user || !user.avatar) {
            throw new Error()
        }
 
        res.set('Content-Type', 'image/png')
        res.send(user.avatar)
    } catch (e) {
        res.status(404).send()
    }
})

//View my followers
router.get('/followers', auth, async (req, res) => {
    res.send(req.user.follower)
})

//View my followings
router.get('/followings', auth, async (req, res) => {
    res.send(req.user.following)
})

//View Requests
router.get('/requests', auth, async (req, res) => {
    res.send(req.user.request)
})

//To respond a user for its request
//In body pass follow parameter as true or false
router.get('/requests/:username', auth, async (req, res) => {
    if(req.body.follow){
        await User.findOneAndUpdate({username: req.user.username}, {$push: {follower: req.params.username}})
        await User.findOneAndUpdate({username: req.user.username}, {$inc: {followers: 1}})
        await User.findOneAndUpdate({username: req.user.username}, {$inc: {requests: -1}})
        await User.findOneAndUpdate({username: req.user.username}, { $pull: { "request": req.params.username }})

        await User.findOneAndUpdate({username: req.params.username}, {$push: {following: req.user.username}})
        await User.findOneAndUpdate({username: req.params.username}, {$inc: {followings: 1}})
        await User.findOneAndUpdate({username: req.params.username}, {$pull: { "requested": req.user.username }})

        res.status(200).send('Follow request accepted!') 
    }
    else{
        await User.findOneAndUpdate({username: req.user.username}, {$inc: {requests: -1}})
        await User.findOneAndUpdate({username: req.user.username}, { $pull: { "request": req.params.username }})

        res.status(200).send('Follow request declined!') 
    }
})

//  To send follow request
router.get('/users/:username/follow', auth, async (req, res) => {  
    const userToFollow =  req.params.username
    try{
        
            await User.findOneAndUpdate({username: req.user.username}, {$push: {requested: userToFollow}})

            await User.findOneAndUpdate({username: userToFollow}, {$push: {request: req.user.username}})
            await User.findOneAndUpdate({username: userToFollow}, {$inc: {requests: 1}})

            res.status(200).send('Follow request sent!') 
    } catch (e) {
        res.status(404).send('Cant send request!')
    }
})

 
module.exports = router