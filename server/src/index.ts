import express from "express";

import authRouter from "./routes/auth/auth.route";
import postRouter from "./routes/posts/posts.route";
import userRouter from "./routes/users/users.route";

const app = express();
const PORT = 5000;

app.get("/", (req, res) => {
  res.send("Server connected");
});

app.use(express.json());

app.use("/api/v1/auth", authRouter);
app.use("/api/v1/posts", postRouter);
app.use("/api/v1/users", userRouter);

app.listen(PORT, () => {
  console.log(`Server is running on http://localhost:${PORT}`);
});
