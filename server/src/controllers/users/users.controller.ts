import { Request, Response } from "express";
import {
  userIdSchema,
  userPostParamsSchema,
} from "../../validations/post.validation";
import { db } from "../../config/db";
import { categoriesTable, postsTable, usersTable } from "../../config/schema";
import { and, desc, eq } from "drizzle-orm";

export class UsersController {
  // Get user data
  getUsers = async (req: Request, res: Response) => {
    try {
      const users = await db
        .select()
        .from(usersTable)
        .orderBy(desc(usersTable.createdAt));

      return res.status(200).json({
        success: true,
        message: "Get Users Successfully",
        data: {
          users: users,
        },
      });
    } catch (error) {
      console.error("Read user error:", error);
      return res.status(500).json({
        success: false,
        message: "Terjadi kesalahan pada server",
        error: error instanceof Error ? error.message : error,
      });
    }
  };

  // All Data
  getPostsByUserId = async (req: Request, res: Response) => {
    try {
      const validateParams = userIdSchema.parse(req.params);
      const { userId } = validateParams;

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
        .where(
          and(
            eq(postsTable.userId, userId),
            eq(postsTable.status, "published"),
          ),
        )
        .orderBy(desc(postsTable.createdAt));

      return res.status(200).json({
        success: true,
        message: "Retrieving post succesfully",
        data: {
          posts,
        },
      });
    } catch (error: any) {
      console.error("Read post by user ID error:", error);
      return res.status(500).json({
        success: false,
        message: "Terjadi kesalahan pada server",
        error: error instanceof Error ? error.message : error,
      });
    }
  };
  // By Id
  getUserPost = async (req: Request, res: Response) => {
    try {
      const validatedParams = userPostParamsSchema.parse(req.params);
      const { userId, postId } = validatedParams;
      const [post] = await db
        .select()
        .from(postsTable)
        .where(
          and(
            eq(postsTable.id, postId),
            eq(postsTable.userId, userId),
            eq(postsTable.status, "published"),
          ),
        );
      if (!post) {
        return res.status(404).json({
          success: false,
          message: "Post not found",
        });
      }
      return res.status(200).json({
        success: true,
        message: "Post retrieved successfully",
        data: {
          post,
        },
      });
    } catch (error: any) {
      console.error("Get user post error:", error);
      return res.status(500).json({
        success: false,
        message: "Internal server error",
        error: error.message,
      });
    }
  };
}

export default new UsersController();
