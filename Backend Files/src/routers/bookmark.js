const express = require('express')
const Bookmark = require('../models/bookmark')
const auth = require('../middleware/auth')
const router = new express.Router()

router.post('/bookmarks', auth, async (req, res) => {
    const bookmark = new Bookmark({
        ...req.body,
        owner: req.user._id
    })

    try {
        await bookmark.save()
        res.status(201).send(bookmark)
    } catch (e) {
        res.status(400).send(e)
    }
})

// GET /bookmarks?completed=true
// GET /bookmarks?limit=10&skip=20
// GET /bookmarks?sortBy=createdAt:desc
router.get('/bookmarks', auth, async (req, res) => {
    
    try {
        await req.user.populate({
            path: 'bookmarks',
        }).execPopulate()
        res.send(req.user.bookmarks)
    } catch (e) {
        res.status(500).send()
    }
})

router.get('/bookmarks/:id', auth, async (req, res) => {
    const _id = req.params.id

    try {
        const bookmark = await Bookmark.findOne({ _id, owner: req.user._id })

        if (!bookmark) {
            return res.status(404).send()
        }

        res.send(bookmark)
    } catch (e) {
        res.status(500).send()
    }
})

router.patch('/bookmarks/:id', auth, async (req, res) => {
    const updates = Object.keys(req.body)
    const allowedUpdates = ['description', 'completed']
    const isValidOperation = updates.every((update) => allowedUpdates.includes(update))

    if (!isValidOperation) {
        return res.status(400).send({ error: 'Invalid updates!' })
    }

    try {
        const bookmark = await Bookmark.findOne({ _id: req.params.id, owner: req.user._id})

        if (!bookmark) {
            return res.status(404).send()
        }

        updates.forEach((update) => bookmark[update] = req.body[update])
        await bookmark.save()
        res.send(bookmark)
    } catch (e) {
        res.status(400).send(e)
    }
})

router.delete('/bookmarks/:id', auth, async (req, res) => {
    try {
        const bookmark = await Bookmark.findOneAndDelete({ _id: req.params.id, owner: req.user._id })

        if (!bookmark) {
            res.status(404).send()
        }

        res.send(bookmark)
    } catch (e) {
        res.status(500).send()
    }
})

module.exports = router