import { Request, Response } from "express";
import {
  createPostSchema,
  postIdSchema,
  updatePostParamsSchema,
  updatePostSchema,
} from "../../validations/post.validation";
import { db } from "../../config/db";
import { categoriesTable, postsTable, usersTable } from "../../config/schema";
import { desc, eq, and, like, or } from "drizzle-orm";
import {
  deleteFromCloudinary,
  uploadToCloudinary,
} from "../../services/cloudinary.service";
import { createGzip } from "zlib";

export class PostsController {
  // CREATE
  createPost = async (req: Request, res: Response) => {
    try {
      // 1. validation
      const validatedData = createPostSchema.parse(req.body);
      const { userId, categoryId, title, content } = validatedData;
      let imageUrl: string | undefined;
      let imagePublicId: string | undefined;
      // 2. Jika ada file yang di-upload, kirim ke Cloudinary
      if (req.file) {
        const uploadResult = await uploadToCloudinary(req.file.buffer);
        imageUrl = uploadResult.secure_url;
        imagePublicId = uploadResult.public_id;
      }
      // 3. Create New Post
      const [insertedPost] = await db
        .insert(postsTable)
        .values({ userId, categoryId, title, content, imageUrl, imagePublicId })
        .$returningId();
      // 4. Ambil Post yg baru di buat tadi
      const newPost = await db.query.postsTable.findFirst({
        where: eq(postsTable.id, insertedPost.id),
      });
      // 5. Tampilkan dalam API
      return res.status(201).json({
        success: true,
        message: "Post created successfully",
        data: {
          post: newPost,
        },
      });
    } catch (error) {
      console.error("Create post error:", error);
      return res.status(500).json({
        success: false,
        message: "Terjadi kesalahan pada server",
        error: error instanceof Error ? error.message : error,
      });
    }
  };

  // READ
  // ALL
  getPosts = async (req: Request, res: Response) => {
    try {
      const { categoryId, searchQuery } = req.query;

      let condition = eq(postsTable.status, "published");

      if (categoryId) {
        condition = and(
          eq(postsTable.status, "published"),
          eq(postsTable.categoryId, Number(categoryId)),
        )!;
      } else if (searchQuery) {
        condition = and(
          eq(postsTable.status, "published"),
          or(
            like(postsTable.title, `%${searchQuery}%`),
            like(postsTable.content, `%${searchQuery}%`),
          ),
        )!;
      }

      const posts = await db
        .select({
          id: postsTable.id,
          title: postsTable.title,
          content: postsTable.content,
          imageUrl: postsTable.imageUrl,
          imagePublicId: postsTable.imagePublicId,
          status: postsTable.status,
          createdAt: postsTable.createdAt,
          updatedAt: postsTable.updatedAt,

          user: {
            id: usersTable.id,
            username: usersTable.username,
          },

          category: {
            id: categoriesTable.id,
            title: categoriesTable.title,
          },
        })
        .from(postsTable)
        .leftJoin(usersTable, eq(postsTable.userId, usersTable.id))
        .leftJoin(
          categoriesTable,
          eq(postsTable.categoryId, categoriesTable.id),
        )
        .where(condition)
        .orderBy(desc(postsTable.createdAt));

      return res.status(200).json({
        success: true,
        message: "Get Posts Successfully",
        data: {
          posts: posts,
        },
      });
    } catch (error: any) {
      console.error("Read post error:", error);
      return res.status(500).json({
        success: false,
        message: "Terjadi kesalahan pada server",
        error: error instanceof Error ? error.message : error,
      });
    }
  };

  // READ
  // BY ID
  getPostById = async (req: Request, res: Response) => {
    try {
      const validateParams = postIdSchema.parse(req.params);
      const { id } = validateParams;

      const [post] = await db
        .select({
          id: postsTable.id,
          title: postsTable.title,
          content: postsTable.content,
          imageUrl: postsTable.imageUrl,
          imagePublicId: postsTable.imagePublicId,
          status: postsTable.status,
          createdAt: postsTable.createdAt,
          updatedAt: postsTable.updatedAt,

          user: {
            id: usersTable.id,
            username: usersTable.username,
          },

          category: {
            id: categoriesTable.id,
            title: categoriesTable.title,
          },
        })
        .from(postsTable)
        .leftJoin(usersTable, eq(postsTable.userId, usersTable.id))
        .leftJoin(
          categoriesTable,
          eq(postsTable.categoryId, categoriesTable.id),
        )
        .where(and(eq(postsTable.id, id), eq(postsTable.status, "published")));

      if (!post) {
        return res.status(404).json({
          success: false,
          message: "No posts found",
        });
      }

      return res.status(200).json({
        success: true,
        message: "Retrieving post succesfully",
        data: {
          post: post,
        },
      });
    } catch (error: any) {
      console.error("Read post error:", error);
      return res.status(500).json({
        success: false,
        message: "Terjadi kesalahan pada server",
        error: error instanceof Error ? error.message : error,
      });
    }
  };

  // UPDATE
  updatePost = async (req: Request, res: Response) => {
    try {
      const validateParams = updatePostParamsSchema.parse(req.params);
      const { id } = validateParams;

      const validateData = updatePostSchema.parse(req.body);
      const { title, content, categoryId } = validateData;

      const [existingPost] = await db
        .select()
        .from(postsTable)
        .where(eq(postsTable.id, id));

      if (!existingPost) {
        return res.status(404).json({
          success: false,
          message: "Corresponding post not found",
        });
      }

      let imageUrl = existingPost.imageUrl;
      let imagePublicId = existingPost.imagePublicId;

      if (req.file) {
        const uploadResult = await uploadToCloudinary(req.file.buffer);
        imageUrl = uploadResult.secure_url;
        imagePublicId = uploadResult.public_id;

        if (existingPost.imagePublicId) {
          await deleteFromCloudinary(existingPost.imagePublicId);
        }
      }

      await db
        .update(postsTable)
        .set({
          ...(categoryId !== undefined && {
            categoryId,
          }),

          ...(title !== undefined && {
            title,
          }),

          ...(content !== undefined && {
            content,
          }),

          ...(req.file && {
            imageUrl,
            imagePublicId,
          }),
        })
        .where(eq(postsTable.id, id));

      const [updatedPost] = await db
        .select()
        .from(postsTable)
        .where(eq(postsTable.id, id));

      return res.status(200).json({
        success: true,
        message: "Post updated successfully",
        data: {
          post: updatedPost,
        },
      });
    } catch (error: any) {
      console.error("Update post error:", error);
      return res.status(500).json({
        success: false,
        message: "Internal server error",
        error: error.message,
      });
    }
  };

  // DELETE
  deletePost = async (req: Request, res: Response) => {
    try {
      const validateParams = postIdSchema.parse(req.params);
      const { id } = validateParams;

      const existingPost = await db.query.postsTable.findFirst({
        where: eq(postsTable.id, id),
      });

      if (!existingPost) {
        return res.status(404).json({
          success: false,
          message: "Corresponding post not found",
        });
      }

      await db
        .update(postsTable)
        .set({ status: "delete" })
        .where(eq(postsTable.id, id));

      return res.status(200).json({
        success: true,
        message: "Post deleted successfully",
      });
    } catch (error: any) {
      console.error("Delete post error:", error);
      return res.status(500).json({
        success: false,
        message: "Internal server error",
        error: error.message,
      });
    }
  };
}

export default new PostsController();
