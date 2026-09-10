import { Router } from "express";
import PostsController from "../../controllers/posts/posts.controller";
import { uploadSingleImage } from "../../middleware/post.middleware";
import { authenticate } from "../../middleware/auth.middleware";

const router = Router();

// CREATE
router.post("/", authenticate, uploadSingleImage, PostsController.createPost);

// READ ALL GUEST
router.get("/", PostsController.getPosts);
router.get("/:id", PostsController.getPostById);

// UPDATE
router.patch(
  "/:id",
  authenticate,
  uploadSingleImage,
  PostsController.updatePost,
);

router.delete(
  "/:id",
  authenticate,
  uploadSingleImage,
  PostsController.deletePost,
);

export default router;
