import express from "express";
import cors from "cors";
import nssRoutes from "./routes/nss.routes";

const app = express();
const PORT = 3000;

app.use(cors());
app.use(express.json());

app.use("/api", nssRoutes);

app.get("/", (_req, res) => {
  res.send(" NSS Backend running");
});

app.listen(PORT, () => {
  console.log(`Server running on http://localhost:${PORT}`);
});
