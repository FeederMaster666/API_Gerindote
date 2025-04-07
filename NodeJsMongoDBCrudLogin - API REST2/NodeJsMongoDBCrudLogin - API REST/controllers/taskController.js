
// controllers/taskController.js
const Task = require("../models/Task");

exports.createTask = async (req, res) => {
    try {
        userId = req.user.id;
        const { title, description } = req.body;
        if (!userId) {
            return res.status(401).json({ message: "Usuario no autenticado" });
        }
        const newTask = new Task({ title, description, user: userId });
        await newTask.insert();
        res.status(201).json(newTask);
    } catch (error) {
        res.status(500).json({ message: "Error al crear la tarea" });
    }
};

exports.getTasks = async (req, res) => {
    try {
        const task = new Task();
        const tasks = await task.findAll(req.user._id);
        res.json(tasks);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

exports.updateTask = async (req, res) => {
    try {
        const task = new Task();
        await task.update(req.params.id, req.body);
        res.json(task);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

exports.deleteTask = async (req, res) => {
    try {
        const task = new Task();

        await task.delete(req.params.id, req.body );
                res.json({ message: "Tarea eliminada" });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};
