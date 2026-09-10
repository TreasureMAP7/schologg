import { Router } from "express";
import { authenticate } from "../../middleware/auth.middleware";
import UsersController from "../../controllers/users/users.controller";

const router = Router();

// Get All Data by User Id For User
router.get("/:userId", authenticate, UsersController.getPostsByUserId);

// Get Data by Id For User
router.get("/:userId/posts/:postId", authenticate, UsersController.getUserPost);

export default router;
