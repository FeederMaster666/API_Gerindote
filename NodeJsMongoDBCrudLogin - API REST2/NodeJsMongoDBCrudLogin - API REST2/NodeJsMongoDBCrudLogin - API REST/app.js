var createError = require('http-errors');
var express = require('express');
var path = require('path');
var cookieParser = require('cookie-parser');
const session = require('express-session');
const passport = require('passport');
const logger = require('morgan');
const cors = require('cors');
const MongoStore = require('connect-mongo'); 


var app = express();
require('./database');
require('./passport/local-auth');


var tasksRouter = require('./routes/tasks');
var usersRouter = require('./routes/users');
// view engine setup
app.set('port', process.env.PORT || 3000);


// middlewares
app.use(logger('dev'));
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(cookieParser());
//app.use(express.static(path.join(__dirname, 'public')));
app.use("/public", express.static(path.resolve(__dirname + '/public')));
app.use(session({
  secret: 'mysecretsession',
  resave: false,
  saveUninitialized: false,
  cookie: { secure: false }  // Si estás en un entorno de desarrollo sin HTTPS
}));

app.use(passport.initialize());
app.use(passport.session());
// middlewares

// Configurar CORS para permitir solicitudes desde cualquier origen
app.use(cors({
  origin: 'http://localhost:5500',  // O permite solo tu frontend, por ejemplo: 'http://localhost:5500'
  methods: ['GET', 'POST', 'PUT', 'DELETE'],
  allowedHeaders: ['Content-Type', 'Authorization'],
  credentials: true // Permite que las cookies se envíen con las peticiones

}));


app.use((req, res, next) => {
  console.log("🟢 Usuario autenticado:", req.user);  // <-- Verifica si aparece en la consola
  app.locals.user = req.user;
  next();
});

//routes
app.use('/api/users', usersRouter);
app.use('/api/tasks', tasksRouter);

// catch 404 and forward to error handler
app.use(function(req, res, next) {
  next(createError(404));
});

// error handler
app.use(function(err, req, res, next) {
  // set locals, only providing error in development
  res.locals.message = err.message;
  res.locals.error = req.app.get('env') === 'development' ? err : {};

  // render the error page
  res.status(err.status || 500);
  res.render('error');
});

module.exports = app;
