const mongoose = require('mongoose');
const { Schema } = mongoose;

const espacioSchema = new Schema({

    nombre: {type: String, required: true, unique:true},
    estado:{type: Boolean, default: null},
}, {timestamps: true});// timestamps: true añade createdAt y updatedAt automáticamente



espacioSchema.methods.insert= async function () {
    //await this.save();
    await this.save()
    .then(result => console.log(result))
    .catch(error => console.log(error));
  };
module.exports = mongoose.model('Espacio', espacioSchema);