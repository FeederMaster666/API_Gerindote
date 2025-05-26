const User = require("../models/user");

// Get all users (admin only)
const getAllUsers = async (req, res) => {
  try {
    const users = await User.find();
    res.status(200).json(users);
  } catch (error) {
    res.status(500).json({ message: "Error retrieving users", error });
  }
};

// Update user role (admin only)
const updateUserRole = async (req, res) => {
  const { id } = req.params;
  const { rol } = req.body;

  if (!["admin", "user"].includes(rol)) {
    return res.status(400).json({ message: "Invalid role" });
  }

  try {
    const user = await User.findByIdAndUpdate(id, { rol }, { new: true });
    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }
    res.status(200).json(user);
  } catch (error) {
    res.status(500).json({ message: "Error updating user role", error });
  }
};

module.exports = { getAllUsers, updateUserRole };
