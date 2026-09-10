import express from "express";

import authRouter from "./routes/auth/auth.route";

const app = express();
const PORT = 5000;

app.get("/", (req, res) => {
  res.send("Hai dari port 5000");
});

app.get("/api/v1/auth", (req, res) => {
  res.send("Halaman Auth");
});

app.use(express.json());

app.use("/api/v1/auth", authRouter);

app.listen(PORT, () => {
  console.log(`Server is running on http://localhost:${PORT}`);
});
