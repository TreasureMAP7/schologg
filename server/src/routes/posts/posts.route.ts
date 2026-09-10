import { Router } from "express";
import PostsController from "../../controllers/posts/posts.controller";
import { uploadSingleImage } from "../../middleware/post.middleware";

const router = Router();

router.post("/", uploadSingleImage, PostsController.createPost);

export default router;
