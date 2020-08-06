const express = require('express')
const Dayvisit = require('../models/dayvisit')
const auth = require('../middleware/auth')
const router = new express.Router()

router.post('/dayvisits', auth, async (req, res) => {   
    try {
        const alreadyvisit = await Dayvisit.findOneAndUpdate({latitude:req.body.latitude,longitude:req.body.longitude,owner: req.user._id }, {$inc: {timeSpent: 10}})
        if(alreadyvisit){
            res.send(alreadyvisit)
        }else{
            const dayvisit = new Dayvisit({
                ...req.body,
                owner: req.user._id
            })        
            try { 
            await dayvisit.save()
            res.status(201).send('Yes')
            } catch (e) {
                res.status(400).send(e)
            }   
        }
    } catch (e) {
        res.status(500).send(e)
    }   
})

// router.get('/dayvisits', auth, async (req, res) => {
//     // const match = {}
//     // const sort = {}

//     // if (req.query.visited) {
//     //     match.latitude = req.query.latitude
//     // }

//     // if (req.query.sortBy) {
//     //     const parts = req.query.sortBy.split(':')
//     //     sort[parts[0]] = parts[1] === 'desc' ? -1 : 1
//     // }
//     try {
//         await req.user.populate({
//             path: 'dayvisits',
//             // match,
//             // options: {
//             //     limit: parseInt(req.query.limit),
//             //     skip: parseInt(req.query.skip),
//             //     sort
//             // }
//         }).execPopulate()
//         res.send(req.user.dayvisits)
//     } catch (e) {
//         console.log(e)
//         res.status(500).send(e)
//     }
// })

module.exports = router