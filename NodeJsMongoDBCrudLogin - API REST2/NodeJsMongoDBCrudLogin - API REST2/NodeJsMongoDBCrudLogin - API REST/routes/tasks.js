const express = require("express");
const { createTask, getTasks, updateTask, deleteTask } = require("../controllers/taskController");
const router = express.Router();

router.post("/add", isAuthenticated, createTask);
router.get("/", isAuthenticated, getTasks);
router.put("/:id", isAuthenticated, updateTask);
router.delete("/:id", isAuthenticated, deleteTask);
function isAuthenticated(req, res, next) {
  if (req.isAuthenticated()) {
      return next();
  }
  res.status(401).json({ message: "No autorizado" });
}
module.exports = router;