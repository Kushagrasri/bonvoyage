const mongoose = require('mongoose')
 
const dayvisitSchema = new mongoose.Schema({
    latitude: {
        type: Number,
        required: true
    },
    longitude: {
        type: Number,
        required: true
    },
    timeSpent: {
        type: Number,
    },
    owner: {
        type: mongoose.Schema.Types.ObjectId,
        required: true,
        ref: 'User'
    }
}, {
    timestamps: true
})

dayvisitSchema.methods.toJSON = function () {
    const dayvisit = this
    const dayvisitObject = dayvisit.toObject()

    return dayvisitObject
}

const Dayvisit = mongoose.model('Dayvisit', dayvisitSchema)

module.exports = Dayvisit