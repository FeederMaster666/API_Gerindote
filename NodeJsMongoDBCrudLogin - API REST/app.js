var createError = require('http-errors');
var express = require('express');
var path = require('path');
var cookieParser = require('cookie-parser');
const session = require('express-session');
const passport = require('passport');
const logger = require('morgan');
const cors = require('cors');
const MongoStore = require('connect-mongo');
const fs = require("fs");

var app = express();
require('./database');
require('./passport/local-auth');

var tasksRouter = require('./routes/tasks');
var usersRouter = require('./routes/users');

// view engine setup
app.set('port', process.env.PORT || 5500);

// Middlewares
app.use(logger('dev'));
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(cookieParser());

// Sesiones
app.use(session({
  secret: 'mysecretsession',
  resave: false,
  saveUninitialized: false,
  cookie: { secure: false } // solo true si usas HTTPS
}));

app.use(passport.initialize());
app.use(passport.session());

// CORS
app.use(cors({
  origin: 'http://127.0.0.1:5500', // tu frontend
  methods: ['GET', 'POST', 'PUT', 'DELETE'],
  allowedHeaders: ['Content-Type', 'Authorization'],
  credentials: true
}));

// Variable global user
app.use((req, res, next) => {
  console.log("🟢 Usuario autenticado:", req.user);
  app.locals.user = req.user;
  next();
});

// Rutas API
app.use('/api/users', usersRouter);
app.use('/api/tasks', tasksRouter);

// RENDER personalizado para "/"
app.get("/", (req, res) => {
  const authenticated = !!req.user;

  let html = fs.readFileSync(path.join(__dirname, "public", "index.html"), "utf8");

  html = html.replace(
    "</head>",
    `<script>window.AUTHENTICATED = ${authenticated};</script>\n</head>`
  );

  res.send(html);
});

// Resto de archivos estáticos
app.use(express.static(path.join(__dirname, 'public')));

// 404
app.use((req, res, next) => {
  res.status(404).json({ message: "Route not found" });
});

// 500
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({ message: "Internal server error", error: err.message });
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`✅ Server running at http://localhost:${PORT}`);
});

module.exports = app;
