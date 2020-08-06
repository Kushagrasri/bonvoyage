const mongoose = require('mongoose')
 
const visitSchema = new mongoose.Schema({
    comment: {
        type: String,
        required: true,
        trim: true
    },
    latitude: {
        type: Number,
        required: true
    },
    longitude: {
        type: Number,
        required: true
    },
    visited: {
        type: Boolean,
        default: false
    },
    rating: {
        type: Number,
        required: false
    },
    owner: {
        type: mongoose.Schema.Types.ObjectId,
        required: true,
        ref: 'User'
    }
}, {
    timestamps: true
})

visitSchema.methods.toJSON = function () {
    const visit = this
    const visitObject = visit.toObject()

    return visitObject
}

const Visit = mongoose.model('Visit', visitSchema)

module.exports = Visit