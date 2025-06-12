const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const NoticiaSchema = Schema({
  titulo: {
    type: String,
    required: true
  },
  descripcion: {
    type: String,
    required: true
  },
  imagen: {
    type: String
  },
  fecha: {
    type: Date,
    default: Date.now
  },
  enlace: {//enlace a la noticia en la web
    type: String,
  }
});

// Métodos similares a Task para CRUD

NoticiaSchema.methods.findAll = async function () {
  const Noticia = mongoose.model("noticias", NoticiaSchema);
  return await Noticia.find().sort({ fecha: -1 })
    .then(result => result)
    .catch(error => console.log(error));
};

NoticiaSchema.methods.insert = async function () {
  await this.save()
    .then(result => console.log(result))
    .catch(error => console.log(error));
};

NoticiaSchema.methods.update = async function (id, noticia) {
  const Noticia = mongoose.model("noticias", NoticiaSchema);
  await Noticia.updateOne({ _id: id }, noticia)
    .then(result => console.log(result))
    .catch(error => console.log(error));
};

NoticiaSchema.methods.delete = async function (id) {
  const Noticia = mongoose.model("noticias", NoticiaSchema);
  await Noticia.deleteOne({ _id: id })
    .then(result => console.log(error));
};

NoticiaSchema.methods.findById = async function (id) {
  const Noticia = mongoose.model("noticias", NoticiaSchema);
  return await Noticia.findById(id)
    .then(result => result)
    .catch(error => console.log(error));
};

module.exports = mongoose.model('noticias', NoticiaSchema);
