import { z } from "zod";

export const createPostSchema = z.object({
  userId: z.coerce.number().int().positive(),
  categoryId: z.coerce.number().int().positive(),
  title: z.string().min(3).max(255),
  content: z.string().min(10),
});

export const postIdSchema = z.object({
  id: z.coerce.number().int().positive(),
});

export const userIdSchema = z.object({
  userId: z.coerce.number().int().positive(),
});

export const userPostParamsSchema = z.object({
  userId: z.coerce.number().int().positive(),
  postId: z.coerce.number().int().positive(),
});
